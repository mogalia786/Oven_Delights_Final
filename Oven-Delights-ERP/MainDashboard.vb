Imports System.Windows.Forms
Imports Microsoft.Web.WebView2.WinForms
Imports Microsoft.Web.WebView2.Core
Imports Oven_Delights_ERP.UI
Imports System.IO

Partial Class MainDashboard
    Inherits Form

    Private ReadOnly BrandPrimary As Color = Color.FromArgb(183, 58, 46)   ' #B73A2E
    Private ReadOnly BrandPrimaryDark As Color = Color.FromArgb(158, 47, 37) ' hover/darker
    Private ReadOnly BrandTint As Color = Color.FromArgb(242, 215, 212)    ' light tint for stats panel

    Private logoutAllowed As Boolean = False
    Private currentUser As User
    Private _currentUserId As Integer
    Private dashboardService As DashboardChartsService
    Private signalRService As SignalRService
    Private reportingService As ReportingService
    ' Sidebar integration fields
    Private sidebar As SidebarControl
    Private currentProvider As ISidebarProvider

    Public Sub New(user As User)
        ' Diagnostic guard: capture any exception thrown inside InitializeComponent
        Try
            InitializeComponent()
        Catch ex As Exception
            MessageBox.Show($"InitializeComponent failed: {ex.Message}{Environment.NewLine}{ex.ToString()}",
                            "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            ' Re-throw or exit early to avoid follow-up NullReference
            Throw
        End Try
        ' Prefer global session if available
        If AppSession.CurrentUser IsNot Nothing Then
            Me.currentUser = AppSession.CurrentUser
            Me._currentUserId = AppSession.CurrentUserID
            Me.Text = $"Oven Delights ERP - Main Dashboard ({AppSession.CurrentUsername})"
        Else
            Me.currentUser = user
            Me._currentUserId = If(user IsNot Nothing, user.UserID, 0)
            If user IsNot Nothing Then
                Me.Text = $"Oven Delights ERP - Main Dashboard ({user.Username})"
            End If
        End If
        Me.IsMdiContainer = True
        Me.WindowState = FormWindowState.Maximized
        Me.FormBorderStyle = FormBorderStyle.FixedDialog
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.ControlBox = False
        ' Guard against MenuStrip1 being Nothing if InitializeComponent aborted
        If Me.MenuStrip1 IsNot Nothing Then
            Me.MenuStrip1.Dock = DockStyle.Top
            Me.MenuStrip1.Visible = True
            Me.MenuStrip1.Enabled = True
        End If

        ' Neutralize/hide the pink right panel without editing Designer
        Try
            If Me.pnlRightStats IsNot Nothing Then
                Me.pnlRightStats.Visible = False
                Me.pnlRightStats.Dock = DockStyle.None
                Me.pnlRightStats.Width = 0
                Me.pnlRightStats.BackColor = Color.White
            End If
        Catch
        End Try

        ' Hide legacy red sidebar panel to avoid double-left columns
        Try
            If Me.pnlSidebar IsNot Nothing Then
                Me.pnlSidebar.Visible = False
                Me.pnlSidebar.Dock = DockStyle.None
                Me.pnlSidebar.Width = 0
            End If
        Catch
        End Try

        ' Ensure MDI background blends with dashboard
        Try
            For Each ctl As Control In Me.Controls
                Dim mdi = TryCast(ctl, MdiClient)
                If mdi IsNot Nothing Then
                    mdi.BackColor = Color.WhiteSmoke
                End If
            Next
        Catch
        End Try

        ' Initialize services
        InitializeServices()

        ' Sidebar: host once on parent (non-invasive to children)
        Try
            SetupSidebar()
        Catch
            ' Do not block dashboard if sidebar fails
        End Try

        ' Add brand strip and logo, and ensure dashboard is visible with charts
        Try
            ApplyBrandStripAndLogo()
        Catch
        End Try
        Try
            EnsureDashboardOpen()
        Catch
        End Try

        ' Wire Manufacturing menu (non-invasive to Designer)
        Try
            SetupManufacturingMenu()
        Catch
            ' do not block dashboard if menu wiring fails
        End Try

        ' Add Categories/Subcategories and Expenses menus (runtime, safe if already present)
        Try
            SetupCategoryMenus()
        Catch
        End Try
        Try
            SetupAccountingExpensesMenus()
        Catch
        End Try

        ' Wire Stockroom Add Inventory menu under Inventory Management
        Try
            SetupStockroomAddInventoryMenu()
        Catch
            ' non-fatal
        End Try

        ' Wire bundle menus (Manufacturing & Stockroom)
        Try
            SetupBundleMenus()
        Catch
        End Try

        ' Role-based menu security
        Try
            ApplyRoleMenuSecurity()
        Catch
        End Try

        ' Role-based landing after core UI is ready
        Try
            ApplyRoleBasedLanding()
        Catch
            ' non-fatal
        End Try

        ' Enforce role-based menu enablement/visibility
        Try
            ApplyRoleBasedMenuSecurity()
        Catch
            ' non-fatal
        End Try

        ' Update window title with branch and role
        Try
            UpdateWindowTitleFromSession()
        Catch
        End Try

        ' Ensure Accounting menu placeholders exist
        Try
            SetupAccountingMenus()
        Catch
        End Try

        ' Wire Retail Products and Manufacturing User Dashboard shortcuts
        Try
            SetupRetailAndMfgShortcuts()
        Catch
            ' non-fatal
        End Try

        ' Build full Retail menu (POS, Products, Inventory, Transfers, Purchasing, Reports, Settings)
        Try
            SetupRetailMenus()
        Catch
            ' non-fatal
        End Try

        ' Build concise, professional top-level menus for Retail, Stockroom, and Manufacturing
        Try
            SetupProfessionalMenus()
        Catch
            ' non-fatal
        End Try
    End Sub

    ' Utility: find or create a submenu by display text safely
    Private Function EnsureSubMenu(parent As ToolStripMenuItem, text As String) As ToolStripMenuItem
        For Each it As ToolStripItem In parent.DropDownItems
            If String.Equals(it.Text, text, StringComparison.OrdinalIgnoreCase) Then
                Return CType(it, ToolStripMenuItem)
            End If
        Next
        Dim mi As New ToolStripMenuItem(text)
        parent.DropDownItems.Add(mi)
        Return mi
    End Function

    Private Function FindTopMenu(text As String) As ToolStripMenuItem
        If Me.MenuStrip1 Is Nothing Then Return Nothing
        For Each it As ToolStripItem In Me.MenuStrip1.Items
            Dim mi = TryCast(it, ToolStripMenuItem)
            If mi Is Nothing Then Continue For
            Dim miText As String = mi.Text
            If Not String.IsNullOrEmpty(miText) Then miText = miText.Replace("&", String.Empty).Trim()
            Dim want As String = If(text, String.Empty)
            If Not String.IsNullOrEmpty(want) Then want = want.Replace("&", String.Empty).Trim()
            If String.Equals(miText, want, StringComparison.OrdinalIgnoreCase) Then
                Return mi
            End If
        Next
        Return Nothing
    End Function

    Private Function EnsureTopMenu(text As String) As ToolStripMenuItem
        Dim mi = FindTopMenu(text)
        If mi IsNot Nothing Then Return mi
        If Me.MenuStrip1 Is Nothing Then Return Nothing
        mi = New ToolStripMenuItem(text)
        Me.MenuStrip1.Items.Add(mi)
        Return mi
    End Function

    Private Sub ApplyRoleMenuSecurity()
        ' Determine role
        Dim role As String = If(AppSession.CurrentRoleName, String.Empty)
        Dim isSuperAdmin As Boolean = String.Equals(role, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        Dim isAdmin As Boolean = String.Equals(role, "Administrator", StringComparison.OrdinalIgnoreCase)

        If Me.MenuStrip1 Is Nothing Then Exit Sub

        ' Super Admin/Admin: leave menus enabled
        If isSuperAdmin OrElse isAdmin Then
            For Each it As ToolStripItem In Me.MenuStrip1.Items
                it.Enabled = True
            Next
            Exit Sub
        End If

        ' Option B policy: Managers see only their own module menu enabled; others disabled
        Dim sensitive() As String = {"Manufacturing", "Accounting", "Stockroom", "Retail", "Brand"}
        Dim allowMenu As String = Nothing
        Select Case role
            Case "Accounting Manager"
                allowMenu = "Accounting"
            Case "Manufacturing Manager"
                allowMenu = "Manufacturing"
            Case "Stockroom Manager"
                allowMenu = "Stockroom"
            Case "Retail Manager"
                allowMenu = "Retail"
            Case "Brand Manager"
                allowMenu = "Brand"
            Case Else
                allowMenu = Nothing ' e.g., Teller: no sensitive menus
        End Select

        ' First disable all sensitive menus
        For Each it As ToolStripItem In Me.MenuStrip1.Items
            Dim mi = TryCast(it, ToolStripMenuItem)
            If mi Is Nothing Then Continue For
            For Each s As String In sensitive
                If String.Equals(mi.Text, s, StringComparison.OrdinalIgnoreCase) Then
                    mi.Enabled = False
                    Exit For
                End If
            Next
        Next

        ' Re-enable the permitted one, if any
        If Not String.IsNullOrWhiteSpace(allowMenu) Then
            Dim target As ToolStripMenuItem = FindTopMenu(allowMenu)
            If target IsNot Nothing Then target.Enabled = True
        End If
    End Sub

    Private Sub SetupCategoryMenus()
        ' Ensure the Manufacturing top menu exists even if it wasn't present in Designer
        Dim mfg As ToolStripMenuItem = EnsureTopMenu("Manufacturing")
        If mfg Is Nothing Then Return
        Dim catalog As ToolStripMenuItem = EnsureSubMenu(mfg, "Catalog")

        ' Categories
        Dim categoriesItem As ToolStripMenuItem = EnsureSubMenu(catalog, "Categories")
        RemoveHandler categoriesItem.Click, AddressOf OpenCategories
        AddHandler categoriesItem.Click, AddressOf OpenCategories

        ' Subcategories
        Dim subcategoriesItem As ToolStripMenuItem = EnsureSubMenu(catalog, "Subcategories")
        RemoveHandler subcategoriesItem.Click, AddressOf OpenSubcategories
        AddHandler subcategoriesItem.Click, AddressOf OpenSubcategories
    End Sub

    Private Sub OpenCategories(sender As Object, e As EventArgs)
        Try
            ' Activate existing form if already open
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Manufacturing.CategoriesForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Manufacturing.CategoriesForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Categories: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenSubcategories(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Manufacturing.SubcategoriesForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Manufacturing.SubcategoriesForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Subcategories: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupAccountingExpensesMenus()
        Dim acct As ToolStripMenuItem = FindTopMenu("Accounting")
        If acct Is Nothing Then Return
        Dim master As ToolStripMenuItem = EnsureSubMenu(acct, "Master Data")

        ' Expense Types
        Dim miExpenseTypes As ToolStripMenuItem = EnsureSubMenu(master, "Expense Types")
        RemoveHandler miExpenseTypes.Click, AddressOf OpenExpenseTypes
        AddHandler miExpenseTypes.Click, AddressOf OpenExpenseTypes

        ' Expenses
        Dim miExpenses As ToolStripMenuItem = EnsureSubMenu(master, "Expenses")
        RemoveHandler miExpenses.Click, AddressOf OpenExpenses
        AddHandler miExpenses.Click, AddressOf OpenExpenses
    End Sub

    Private Sub OpenExpenseTypes(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Accounting.ExpenseTypesForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Accounting.ExpenseTypesForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Expense Types: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenExpenses(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Accounting.ExpensesForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Accounting.ExpensesForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Expenses: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Minimal data viewer for quick presentation without interfering with existing forms
    Private Function CreateSimpleGridForm(title As String, sql As String) As Form
        Dim f As New Form()
        f.Text = title
        f.Width = 900
        f.Height = 600
        Dim grid As New DataGridView() With {.Dock = DockStyle.Fill, .ReadOnly = True, .AllowUserToAddRows = False}
        f.Controls.Add(grid)
        Try
            Dim cs As String = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Using con As New Microsoft.Data.SqlClient.SqlConnection(cs)
                con.Open()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, con)
                    Dim dt As New DataTable()
                    Using da As New Microsoft.Data.SqlClient.SqlDataAdapter(cmd)
                        da.Fill(dt)
                    End Using
                    grid.DataSource = dt
                End Using
            End Using
        Catch
        End Try
        Return f
    End Function

    Private Sub ApplyBrandStripAndLogo()
        ' Thin red strip on the far left
        Dim existing = Me.Controls.OfType(Of Panel)().FirstOrDefault(Function(p) p.Name = "pnlBrandStrip")
        If existing Is Nothing Then
            Dim brandStrip As New Panel()
            brandStrip.Name = "pnlBrandStrip"
            brandStrip.BackColor = BrandPrimary
            brandStrip.Width = 6
            brandStrip.Dock = DockStyle.Left
            Me.Controls.Add(brandStrip)
            Me.Controls.SetChildIndex(brandStrip, 0)
        End If

        ' Inject logo at top of sidebar if available
        If sidebar IsNot Nothing Then
            Dim hasLogo As Boolean = sidebar.Controls.OfType(Of PictureBox)().Any(Function(pb) pb.Name = "picBrandLogo")
            If Not hasLogo Then
                Try
                    Dim logoPath As String = Path.Combine(System.Windows.Forms.Application.StartupPath, "logo.png")
                    If File.Exists(logoPath) Then
                        Dim logoImg = Image.FromFile(logoPath)
                        Dim logoBox As New PictureBox()
                        logoBox.Name = "picBrandLogo"
                        logoBox.Image = logoImg
                        logoBox.SizeMode = PictureBoxSizeMode.Zoom
                        logoBox.Dock = DockStyle.Top
                        logoBox.Height = 68
                        logoBox.BackColor = Color.Transparent
                        sidebar.Controls.Add(logoBox)
                        sidebar.Controls.SetChildIndex(logoBox, 0)
                    End If
                Catch
                    ' ignore logo load errors
                End Try
            End If
        End If
    End Sub

    Private Sub SetupStockroomAddInventoryMenu()
        If Me.MenuStrip1 Is Nothing OrElse Me.StockroomToolStripMenuItem Is Nothing OrElse Me.InventoryManagementToolStripMenuItem Is Nothing Then Return

        Dim addInventory As ToolStripMenuItem = Nothing
        For Each it As ToolStripItem In InventoryManagementToolStripMenuItem.DropDownItems
            If it.Text = "Add Inventory" Then addInventory = CType(it, ToolStripMenuItem)
        Next
        If addInventory Is Nothing Then
            addInventory = New ToolStripMenuItem("Add Inventory")
            InventoryManagementToolStripMenuItem.DropDownItems.Add(addInventory)
        End If

        Dim addBase As ToolStripMenuItem = Nothing
        For Each it As ToolStripItem In addInventory.DropDownItems
            If it.Text = "Add Base Inventory" Then addBase = CType(it, ToolStripMenuItem)
        Next
        If addBase Is Nothing Then
            addBase = New ToolStripMenuItem("Add Base Inventory")
            addInventory.DropDownItems.Add(addBase)
        End If

        Dim ensureItem = Function(text As String, handler As EventHandler) As ToolStripMenuItem
                             Dim existing As ToolStripMenuItem = Nothing
                             For Each it As ToolStripItem In addBase.DropDownItems
                                 If it.Text = text Then existing = CType(it, ToolStripMenuItem)
                             Next
                             If existing Is Nothing Then
                                 Dim mi As New ToolStripMenuItem(text)
                                 AddHandler mi.Click, handler
                                 addBase.DropDownItems.Add(mi)
                                 Return mi
                             Else
                                 ' ensure handler wired once
                                 RemoveHandler existing.Click, handler
                                 AddHandler existing.Click, handler
                                 Return existing
                             End If
                         End Function

        ensureItem("Raw Material", Sub(sender, e)
                                       Try
                                           Dim frm As New RawMaterialsForm()
                                           frm.MdiParent = Me
                                           frm.Show()
                                           frm.WindowState = FormWindowState.Maximized
                                           Try
                                               frm.AddNewMaterialRow()
                                           Catch
                                           End Try
                                       Catch ex As Exception
                                           MessageBox.Show("Error opening Raw Materials: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                       End Try
                                   End Sub)

        Dim openCatalog As Action(Of String) = Sub(typeName As String)
                                                   Try
                                                       Dim frm As New InventoryCatalogCrudForm(typeName)
                                                       frm.MdiParent = Me
                                                       frm.Show()
                                                       frm.WindowState = FormWindowState.Maximized
                                                       Try
                                                           frm.AddNewItemRow()
                                                       Catch
                                                       End Try
                                                   Catch ex As Exception
                                                       MessageBox.Show($"Error opening {typeName}: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                                   End Try
                                               End Sub

        ensureItem("SubAssembly", Sub(s, e) openCatalog("SubAssembly"))
        ensureItem("Decoration", Sub(s, e) openCatalog("Decoration"))
        ensureItem("Topping", Sub(s, e) openCatalog("Topping"))
        ensureItem("Accessory", Sub(s, e) openCatalog("Accessory"))
        ensureItem("Packaging", Sub(s, e) openCatalog("Packaging"))
    End Sub

    ' ---------------- Accounting menu wiring ----------------
    Private Sub SetupAccountingMenus()
        ' Guard against missing designer elements
        If Me.MenuStrip1 Is Nothing OrElse Me.AccountingToolStripMenuItem Is Nothing Then Return

        ' Helper to ensure a menu item exists under a parent and wire a click handler
        Dim ensureMenu = Function(parent As ToolStripMenuItem, caption As String, handler As EventHandler) As ToolStripMenuItem
                             Dim existing As ToolStripMenuItem = Nothing
                             For Each it As ToolStripItem In parent.DropDownItems
                                 If String.Equals(it.Text, caption, StringComparison.InvariantCultureIgnoreCase) Then
                                     existing = CType(it, ToolStripMenuItem)
                                     Exit For
                                 End If
                             Next
                             If existing Is Nothing Then
                                 existing = New ToolStripMenuItem(caption)
                                 parent.DropDownItems.Add(existing)
                             End If
                             ' Ensure handler is attached once
                             RemoveHandler existing.Click, handler
                             AddHandler existing.Click, handler
                             Return existing
                         End Function

        ' Accounting -> Journals Viewer
        ensureMenu(Me.AccountingToolStripMenuItem, "Journals Viewer", Sub(sender, e)
                                                                          Try
                                                                              OpenMdiSingleton(Of JournalViewerForm)()
                                                                          Catch ex As Exception
                                                                              MessageBox.Show("Error opening Journals Viewer: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                                                          End Try
                                                                      End Sub)

        ' Accounting -> General Ledger Viewer
        ensureMenu(Me.AccountingToolStripMenuItem, "General Ledger Viewer", Sub(sender, e)
                                                                                Try
                                                                                    OpenMdiSingleton(Of GeneralLedgerViewerForm)()
                                                                                Catch ex As Exception
                                                                                    MessageBox.Show("Error opening General Ledger Viewer: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                                                                End Try
                                                                            End Sub)

        ' Accounting -> Payroll Journal
        ensureMenu(Me.AccountingToolStripMenuItem, "Payroll Journal", Sub(sender, e)
                                                                          Try
                                                                              OpenMdiSingleton(Of PayrollJournalForm)()
                                                                          Catch ex As Exception
                                                                              MessageBox.Show("Error opening Payroll Journal: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                                                          End Try
                                                                      End Sub)

        ' Administrator -> Staff Management and Payroll Entry
        If Me.AdministratorToolStripMenuItem IsNot Nothing Then
            ensureMenu(Me.AdministratorToolStripMenuItem, "Staff Management", Sub(sender, e)
                                                                                  Try
                                                                                      OpenMdiSingleton(Of StaffManagementForm)()
                                                                                  Catch ex As Exception
                                                                                      MessageBox.Show("Error opening Staff Management: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                                                                  End Try
                                                                              End Sub)
            ensureMenu(Me.AdministratorToolStripMenuItem, "Payroll Entry", Sub(sender, e)
                                                                               Try
                                                                                   OpenMdiSingleton(Of PayrollEntryForm)()
                                                                               Catch ex As Exception
                                                                                   MessageBox.Show("Error opening Payroll Entry: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                                                                               End Try
                                                                           End Sub)
        End If
    End Sub

    Private Sub EnsureDashboardOpen()
        ' If no dashboard child is open, open one so charts appear immediately
        Dim hasDashboard As Boolean = Me.MdiChildren.Any(Function(f) TypeOf f Is DashboardForm)
        If Not hasDashboard Then
            Dim dashboardForm As New DashboardForm()
            dashboardForm.MdiParent = Me
            dashboardForm.Show()
            dashboardForm.WindowState = FormWindowState.Maximized
        End If
    End Sub

    ' ---------------- Sidebar integration ----------------
    Private Sub SetupSidebar()
        If sidebar Is Nothing Then
            sidebar = New SidebarControl()
            sidebar.Name = "SidebarControlHost"
            sidebar.Dock = DockStyle.Left
            Controls.Add(sidebar)
            Controls.SetChildIndex(sidebar, 0)
        End If
        ' Wire navigation from sidebar buttons
        RemoveHandler sidebar.Navigate, AddressOf OnSidebarNavigate
        AddHandler sidebar.Navigate, AddressOf OnSidebarNavigate
        AddHandler Me.MdiChildActivate, AddressOf OnMdiChildActivate_UpdateSidebar
        ' Ensure no residual context is shown at startup
        sidebar.SetTitle("Oven Delights")
        sidebar.ClearContext()
        OnMdiChildActivate_UpdateSidebar(Me, EventArgs.Empty)
        ' Toggle visibility based on role (admins should not see stockroom sidebar at all)
        Try
            If IsAdminRole() Then
                sidebar.Visible = False
            Else
                sidebar.Visible = True
            End If
        Catch
        End Try
    End Sub

    Private Sub OnMdiChildActivate_UpdateSidebar(sender As Object, e As EventArgs)
        If sidebar Is Nothing Then Return

        ' Unsubscribe previous provider
        If currentProvider IsNot Nothing Then
            RemoveHandler currentProvider.SidebarContextChanged, AddressOf OnChildSidebarContextChanged
            currentProvider = Nothing
        End If

        ' Ensure admin never sees sidebar regardless of active child
        Try
            If IsAdminRole() Then
                sidebar.Visible = False
            Else
                sidebar.Visible = True
            End If
        Catch
        End Try

        Dim child = Me.ActiveMdiChild
        If child Is Nothing Then
            sidebar.SetTitle("Oven Delights")
            sidebar.ClearContext()
            Return
        End If

        ' Keep brand title fixed on the left under the logo
        sidebar.SetTitle("Oven Delights")

        ' Explicitly clear sidebar for admin user management forms to avoid stockroom context bleed
        Dim childName As String = child.GetType().Name
        If childName = "UserManagementForm" OrElse childName = "UserAddEditForm" OrElse childName = "AdminWelcomeForm" OrElse childName = "DashboardForm" Then
            sidebar.ClearContext()
            Exit Sub
        End If

        If TypeOf child Is ISidebarProvider Then
            currentProvider = CType(child, ISidebarProvider)
            Try
                Dim panel = currentProvider.BuildSidebarPanel()
                sidebar.SetContext(panel)
            Catch
                sidebar.ClearContext()
            End Try
            AddHandler currentProvider.SidebarContextChanged, AddressOf OnChildSidebarContextChanged
        Else
            sidebar.ClearContext()
        End If
    End Sub

    Private Sub OnChildSidebarContextChanged(sender As Object, e As EventArgs)
        If currentProvider Is Nothing OrElse sidebar Is Nothing Then Return
        Try
            Dim panel = currentProvider.BuildSidebarPanel()
            sidebar.SetContext(panel)
        Catch
            ' no-op on render errors
        End Try
    End Sub

    Private Sub SetupManufacturingMenu()
        If Me.MenuStrip1 Is Nothing OrElse Me.ManufacturingToolStripMenuItem Is Nothing Then Return

        If ManufacturingToolStripMenuItem.DropDownItems.Count = 0 Then
            Dim miCategories As New ToolStripMenuItem("Categories")
            AddHandler miCategories.Click, Sub(sender, e)
                                               OpenMdiSingleton(Of Manufacturing.CategoryManagementForm)()
                                           End Sub

            Dim miSubcategories As New ToolStripMenuItem("Subcategories")
            AddHandler miSubcategories.Click, Sub(sender, e)
                                                  OpenMdiSingleton(Of Manufacturing.SubcategoryManagementForm)()
                                              End Sub

            Dim miProducts As New ToolStripMenuItem("Products")
            AddHandler miProducts.Click, Sub(sender, e)
                                             OpenMdiSingleton(Of Manufacturing.ProductForm)()
                                         End Sub

            Dim miRecipeCreator As New ToolStripMenuItem("Recipe Creator")
            AddHandler miRecipeCreator.Click, Sub(sender, e)
                                                  OpenMdiSingleton(Of Manufacturing.RecipeCreatorForm)()
                                              End Sub

            Dim miBuildMyProduct As New ToolStripMenuItem("Build My Product")
            AddHandler miBuildMyProduct.Click, Sub(sender, e)
                                                   OpenMdiSingleton(Of Manufacturing.BuildProductForm)()
                                               End Sub

            Dim miBOM As New ToolStripMenuItem("BOM Editor")
            AddHandler miBOM.Click, Sub(sender, e)
                                        OpenMdiSingleton(Of Manufacturing.BOMEditorForm)()
                                    End Sub

            Dim miCompleteBuild As New ToolStripMenuItem("Complete Build of Materials")
            AddHandler miCompleteBuild.Click, Sub(sender, e)
                                                  OpenMdiSingleton(Of Manufacturing.CompleteBuildForm)()
                                              End Sub

            Dim miMOActions As New ToolStripMenuItem("MO Actions")
            AddHandler miMOActions.Click, Sub(sender, e)
                                              OpenMdiSingleton(Of Manufacturing.MOActionsForm)()
                                          End Sub

            ManufacturingToolStripMenuItem.DropDownItems.AddRange(New ToolStripItem() {
                miCategories, miSubcategories, miProducts, miRecipeCreator, miBuildMyProduct, miBOM, miCompleteBuild, miMOActions
            })
        End If
    End Sub

    Private Sub OpenMdiSingleton(Of T As {Form, New})()
        For Each child As Form In Me.MdiChildren
            If TypeOf child Is T Then
                child.Activate()
                child.WindowState = FormWindowState.Maximized
                Return
            End If
        Next
        Dim frm As New T()
        frm.MdiParent = Me
        frm.Show()
        frm.WindowState = FormWindowState.Maximized
    End Sub

    Private Sub OnSidebarNavigate(moduleKey As String)
        If String.IsNullOrWhiteSpace(moduleKey) Then Return
        Select Case moduleKey.ToLowerInvariant()
            Case "dashboard"
                ' Open Dashboard
                Try
                    For Each child As Form In Me.MdiChildren
                        If TypeOf child Is DashboardForm Then
                            child.Activate()
                            child.WindowState = FormWindowState.Maximized
                            Return
                        End If
                    Next
                    Dim dashboardForm As New DashboardForm()
                    dashboardForm.MdiParent = Me
                    dashboardForm.Show()
                    dashboardForm.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    MessageBox.Show("Error opening Dashboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try

            Case "materials"
                ' Open Raw Materials maintenance if available, fallback to Stockroom
                Try
                    For Each child As Form In Me.MdiChildren
                        If TypeOf child Is RawMaterialsForm Then
                            child.Activate()
                            child.WindowState = FormWindowState.Maximized
                            Return
                        End If
                    Next
                    Dim frm As Form
                    Try
                        frm = New RawMaterialsForm()
                    Catch
                        frm = New StockroomManagementForm(currentUser)
                    End Try
                    frm.MdiParent = Me
                    frm.Show()
                    frm.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    MessageBox.Show("Error opening Materials: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try

            Case "suppliers"
                ' Open Suppliers
                Try
                    For Each child As Form In Me.MdiChildren
                        If TypeOf child Is SuppliersForm Then
                            child.Activate()
                            child.WindowState = FormWindowState.Maximized
                            Return
                        End If
                    Next
                    Dim frm As New SuppliersForm()
                    frm.MdiParent = Me
                    frm.Show()
                    frm.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    MessageBox.Show("Error opening Suppliers: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try

            Case "po"
                ' Open Purchase Orders
                Try
                    For Each child As Form In Me.MdiChildren
                        If TypeOf child Is PurchaseOrderForm Then
                            child.Activate()
                            child.WindowState = FormWindowState.Maximized
                            Return
                        End If
                    Next
                    Dim poForm As New PurchaseOrderForm()
                    poForm.MdiParent = Me
                    poForm.Show()
                    poForm.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    MessageBox.Show("Error opening Purchase Orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try

            Case "grv"
                ' Open GRV (Invoice Capture receiving against PO)
                Try
                    For Each child As Form In Me.MdiChildren
                        If TypeOf child Is InvoiceCaptureForm Then
                            child.Activate()
                            child.WindowState = FormWindowState.Maximized
                            Return
                        End If
                    Next
                    Dim branchId As Integer = If(currentUser IsNot Nothing AndAlso currentUser.BranchID.HasValue, currentUser.BranchID.Value, 0)
                    Dim userId As Integer = If(currentUser IsNot Nothing, currentUser.UserID, 0)
                    Dim invForm As New InvoiceCaptureForm(branchId, userId)
                    invForm.MdiParent = Me
                    invForm.Show()
                    invForm.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    MessageBox.Show("Error opening GRV: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try

            Case "ap"
                ' Accounts Payable module not yet implemented
                MessageBox.Show("Accounts Payable module is coming soon.", "Info", MessageBoxButtons.OK, MessageBoxIcon.Information)

            Case "reports"
                ' Reports entry — open Audit Log Viewer as a placeholder entry point
                Try
                    For Each child As Form In Me.MdiChildren
                        If TypeOf child Is AuditLogViewer Then
                            child.Activate()
                            child.WindowState = FormWindowState.Maximized
                            Return
                        End If
                    Next
                    Dim rpt As New AuditLogViewer()
                    rpt.MdiParent = Me
                    rpt.Show()
                    rpt.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    MessageBox.Show("Error opening Reports: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
        End Select
    End Sub

    ' ---------------- Role-based landing ----------------
    Private Sub ApplyRoleBasedLanding()
        Dim role As String = TryCast(AppSession.CurrentRoleName, String)
        If String.IsNullOrWhiteSpace(role) Then Return

        role = role.Trim()

        ' Normalize for comparisons
        Dim r As String = role.ToLowerInvariant()

        If r.Contains("stockroom") OrElse r = "sm" Then
            ' Open Stockroom home for stockroom roles
            Try
                Dim stockroomForm As New StockroomManagementForm(currentUser)
                stockroomForm.MdiParent = Me
                stockroomForm.Show()
                stockroomForm.WindowState = FormWindowState.Maximized
            Catch
                ' Fallback: keep dashboard
            End Try
            ' Stockroom roles should see the sidebar
            If sidebar IsNot Nothing Then sidebar.Visible = True
            Return
        End If

        ' Manufacturing landing
        If r.Contains("manufacturing") OrElse r = "mm" Then
            Try
                ' Open a sensible manufacturing home screen
                Dim mfgHome As New Manufacturing.ProductForm()
                mfgHome.MdiParent = Me
                mfgHome.Show()
                mfgHome.WindowState = FormWindowState.Maximized
            Catch
                ' Fallback: keep dashboard
            End Try
            ' Manufacturing roles should see the sidebar
            If sidebar IsNot Nothing Then sidebar.Visible = True
            Return
        End If

        If r.Contains("admin") OrElse r = "sa" Then
            ' Administrator landing: Dashboard/Admin welcome; ensure no stockroom context
            Try
                ' Clear any lingering stockroom context before opening admin forms
                If sidebar IsNot Nothing Then
                    sidebar.SetTitle("Oven Delights")
                    sidebar.ClearContext()
                    ' Hide sidebar entirely for admin users
                    sidebar.Visible = False
                End If
                ' Prefer AdminWelcomeForm if present, else Dashboard
                Dim adminWelcomeType = AppDomain.CurrentDomain.GetAssemblies() _
                    .SelectMany(Function(a) a.GetTypes()) _
                    .FirstOrDefault(Function(t) t.Name = "AdminWelcomeForm")
                NewMethod(adminWelcomeType)
            Catch
                ' fallback no-op
            End Try
            Return
        End If

        ' Other roles: default to Dashboard
        Try
            Dim dashboardForm As New DashboardForm()
            dashboardForm.MdiParent = Me
            dashboardForm.Show()
            dashboardForm.WindowState = FormWindowState.Maximized
        Catch
        End Try
        ' Default: show sidebar for non-admin roles
        If sidebar IsNot Nothing Then sidebar.Visible = True
    End Sub

    Private Sub NewMethod(adminWelcomeType As Type)
        If DirectCast(adminWelcomeType, Object) IsNot Nothing Then
            Dim frm = CType(Activator.CreateInstance(adminWelcomeType), Form)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Else
            Dim dashboardForm As New DashboardForm()
            dashboardForm.MdiParent = Me
            dashboardForm.Show()
            dashboardForm.WindowState = FormWindowState.Maximized
        End If
    End Sub

    Private Function IsAdminRole() As Boolean
        Dim role As String = TryCast(AppSession.CurrentRoleName, String)
        If String.IsNullOrWhiteSpace(role) Then Return False
        Dim r As String = role.Trim().ToLowerInvariant()
        Return r.Contains("admin") OrElse r = "sa"
    End Function

    Private Sub ApplyRoleBasedMenuSecurity()
        If Me.MenuStrip1 Is Nothing Then Return
        Dim role As String = TryCast(AppSession.CurrentRoleName, String)
        If String.IsNullOrWhiteSpace(role) Then Return
        Dim r As String = role.Trim().ToLowerInvariant()

        Dim enableAdmin As Boolean = (r.Contains("admin") OrElse r = "sa")
        Dim enableStockroom As Boolean = (r.Contains("stockroom") OrElse r = "sm")
        Dim enableManufacturing As Boolean = (r.Contains("manufacturing") OrElse r = "mm")
        Dim enableRetail As Boolean = (r.Contains("retail") OrElse r = "rm")

        ' Helpers
        Dim findMenu = Function(caption As String) As ToolStripMenuItem
                           Try
                               Return Me.MenuStrip1.Items.OfType(Of ToolStripMenuItem)() _
                                   .FirstOrDefault(Function(x) String.Equals(x.Text, caption, StringComparison.InvariantCultureIgnoreCase))
                           Catch
                               Return Nothing
                           End Try
                       End Function

        Dim setMenu = Sub(mi As ToolStripMenuItem, enabledFlag As Boolean)
                          Try
                              If mi IsNot Nothing Then
                                  mi.Enabled = enabledFlag
                                  mi.Visible = enabledFlag
                              End If
                          Catch
                          End Try
                      End Sub

        ' Try common captions used in designer. These calls are safe even if not found
        setMenu(findMenu("Administrator"), enableAdmin)
        setMenu(findMenu("Stockroom"), enableAdmin OrElse enableStockroom)
        setMenu(findMenu("Inventory Management"), enableAdmin OrElse enableStockroom)
        setMenu(findMenu("Manufacturing"), enableAdmin OrElse enableManufacturing)
        setMenu(findMenu("Reports"), enableAdmin OrElse enableStockroom OrElse enableManufacturing OrElse enableRetail)
        setMenu(findMenu("Accounts Payable"), enableAdmin)
        setMenu(findMenu("Accounting"), enableAdmin)

        ' Ensure Exit is always available
        Try
            Dim exitMi = findMenu("Exit")
            If exitMi IsNot Nothing Then
                exitMi.Enabled = True
                exitMi.Visible = True
            End If
        Catch
        End Try
    End Sub

    Private Async Sub InitializeServices()
        Try
            ' Initialize reporting service
            reportingService = New ReportingService()

            ' Initialize dashboard service
            dashboardService = New DashboardChartsService()

            ' Initialize SignalR service (optional - don't fail if connection fails)
            Try
                signalRService = New SignalRService()
                AddHandler signalRService.UserLoggedIn, AddressOf OnUserLoggedIn
                AddHandler signalRService.UserLoggedOut, AddressOf OnUserLoggedOut
                AddHandler signalRService.SecurityAlert, AddressOf OnSecurityAlert
                AddHandler signalRService.SystemNotification, AddressOf OnSystemNotification

                ' Start SignalR connection (optional)
                Await signalRService.StartAsync()
            Catch signalREx As Exception
                ' SignalR connection failed - continue without real-time features
                ' This is expected if no SignalR hub is running
                signalRService = Nothing
            End Try

        Catch ex As Exception
            MessageBox.Show("Error initializing core services: " & ex.Message, "Initialization Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Protected Overrides Sub OnFormClosing(e As FormClosingEventArgs)
        If Not logoutAllowed AndAlso Not allowExit Then
            e.Cancel = True
        End If
        MyBase.OnFormClosing(e)
    End Sub

    ' Call this method to allow logout and close
    Public Sub AllowLogoutAndClose()
        logoutAllowed = True
        Me.Close()
    End Sub

    Private allowExit As Boolean = False
    Private Sub ExitToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles ExitToolStripMenuItem.Click
        allowExit = True
        Application.Exit()
    End Sub

    Private Sub AdministratorToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AdministratorToolStripMenuItem.Click
        Try
            ' Close any existing dashboard forms
            For Each childForm As Form In Me.MdiChildren
                If TypeOf childForm Is DashboardForm Then
                    childForm.Close()
                End If
            Next

            ' Open dashboard form
            Dim dashboardForm As New DashboardForm()
            dashboardForm.MdiParent = Me
            dashboardForm.Show()
            dashboardForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Administrator dashboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockroomToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StockroomToolStripMenuItem.Click
        Try
            ' Close any existing stockroom forms
            For Each childForm As Form In Me.MdiChildren
                If TypeOf childForm Is StockroomManagementForm Then
                    childForm.Close()
                End If
            Next

            ' Open stockroom management form
            Dim stockroomForm As New StockroomManagementForm(currentUser)
            stockroomForm.MdiParent = Me
            stockroomForm.Show()
            stockroomForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Stockroom management: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenUserManagement()
        If currentUser Is Nothing Then
            MessageBox.Show("User session not found. Please log in again.", "Authentication Error",
                         MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Dim userMgmtForm As New UserManagementForm(currentUser.UserID)
            userMgmtForm.MdiParent = Me
            userMgmtForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening User Management: {ex.Message}", "Error",
                         MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UserManagementMenuItem_Click(sender As Object, e As EventArgs)
        OpenUserManagement()
    End Sub

    Private Sub OpenDashboard()
        Dim dashboardForm As New DashboardForm()
        dashboardForm.MdiParent = Me
        dashboardForm.Show()
    End Sub

    Private Sub DashboardMenuItem_Click(sender As Object, e As EventArgs)
        OpenDashboard()
    End Sub

    ' SignalR Event Handlers
    Private Sub OnUserLoggedIn(sender As Object, username As String)
        Me.Invoke(Sub()
                      ' Update UI to show user logged in
                      ' You can add a status bar or notification area
                  End Sub)
    End Sub

    Private Sub OnUserLoggedOut(sender As Object, username As String)
        Me.Invoke(Sub()
                      ' Update UI to show user logged out
                  End Sub)
    End Sub

    Private Sub OnSecurityAlert(sender As Object, message As String)
        Me.Invoke(Sub()
                      MessageBox.Show(message, "Security Alert", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                  End Sub)
    End Sub

    Private Sub OnSystemNotification(sender As Object, message As String)
        Me.Invoke(Sub()
                      ' Show system notification in UI
                      ' You can implement a notification panel or toast
                  End Sub)
    End Sub

    ' Cleanup on form closing
    Protected Overrides Sub OnFormClosed(e As FormClosedEventArgs)
        Try
            If signalRService IsNot Nothing Then
                signalRService.StopAsync().Wait()
                signalRService.Dispose()
            End If
        Catch ex As Exception
            ' Silent cleanup
        End Try
        MyBase.OnFormClosed(e)
    End Sub

    ' Administrator Submenu Event Handlers
    Private Sub DashboardToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles DashboardToolStripMenuItem.Click
        Try
            Dim dashboardForm As New DashboardForm()
            dashboardForm.MdiParent = Me
            dashboardForm.Show()
            dashboardForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Dashboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub UserManagementToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles UserManagementToolStripMenuItem.Click
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error",
                             MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim userMgmtForm As New UserManagementForm(currentUser.UserID)
            userMgmtForm.MdiParent = Me
            userMgmtForm.Show()
            userMgmtForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening User Management: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub BranchManagementToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles BranchManagementToolStripMenuItem.Click
        Try
            Dim branchMgmtForm As New BranchManagementForm(_currentUserId)
            branchMgmtForm.MdiParent = Me
            branchMgmtForm.Show()
            branchMgmtForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Branch Management: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub AuditLogToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles AuditLogToolStripMenuItem.Click
        Try
            Dim auditLogForm As New AuditLogViewer()
            auditLogForm.MdiParent = Me
            auditLogForm.Show()
            auditLogForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Audit Log: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SystemSettingsToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SystemSettingsToolStripMenuItem.Click
        Try
            Dim systemSettingsForm As New SystemSettingsForm_New(_currentUserId)
            systemSettingsForm.MdiParent = Me
            systemSettingsForm.Show()
            systemSettingsForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening System Settings: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Stockroom Submenu Event Handlers
    Private Sub InventoryManagementToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles InventoryManagementToolStripMenuItem.Click
        Try
            Dim stockroomForm As New StockroomManagementForm(currentUser)
            stockroomForm.MdiParent = Me
            stockroomForm.Show()
            stockroomForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Inventory Management: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SuppliersToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SuppliersToolStripMenuItem.Click
        Try
            ' Activate existing SuppliersForm if open, else create new
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is SuppliersForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New SuppliersForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Suppliers: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub PurchaseOrdersToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles PurchaseOrdersToolStripMenuItem.Click
        Try
            ' Activate existing PurchaseOrderForm if open, else create new
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is PurchaseOrderForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim poForm As New PurchaseOrderForm()
            poForm.MdiParent = Me
            poForm.Show()
            poForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Purchase Orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SupplierInvoicesToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles SupplierInvoicesToolStripMenuItem.Click
        Try
            ' Activate existing InvoiceCaptureForm if open, else create new
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is InvoiceCaptureForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim branchId As Integer = If(currentUser IsNot Nothing AndAlso currentUser.BranchID.HasValue, currentUser.BranchID.Value, 0)
            Dim userId As Integer = If(currentUser IsNot Nothing, currentUser.UserID, 0)
            Dim invForm As New InvoiceCaptureForm(branchId, userId)
            invForm.MdiParent = Me
            invForm.Show()
            invForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Supplier Invoices: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub CreditNotesToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles CreditNotesToolStripMenuItem.Click
        Try
            ' Credit Notes require a selected PO context, route to Purchase Order workspace
            Dim poForm As New PurchaseOrderForm()
            poForm.MdiParent = Me
            poForm.Show()
            poForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Credit Notes: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockTransfersToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StockTransfersToolStripMenuItem.Click
        Try
            Dim stockTransferForm As New StockTransferForm(currentUser)
            stockTransferForm.MdiParent = Me
            stockTransferForm.Show()
            stockTransferForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Stock Transfers: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockAdjustmentsToolStripMenuItem_Click(sender As Object, e As EventArgs) Handles StockAdjustmentsToolStripMenuItem.Click
        Try
            Dim stockAdjustmentForm As New StockAdjustmentForm(currentUser)
            stockAdjustmentForm.MdiParent = Me
            stockAdjustmentForm.Show()
            stockAdjustmentForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Stock Adjustments: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub InventoryMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockroomForm As New StockroomManagementForm(currentUser)
            stockroomForm.MdiParent = Me
            stockroomForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Inventory: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockTransfersMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockTransferForm As New StockTransferForm(currentUser)
            stockTransferForm.MdiParent = Me
            stockTransferForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Stock Transfers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub StockAdjustmentsMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockAdjustmentForm As New StockAdjustmentForm(currentUser)
            stockAdjustmentForm.MdiParent = Me
            stockAdjustmentForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Stock Adjustments: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SuppliersMenuItem_Click(sender As Object, e As EventArgs)
        Try
            If currentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Dim stockroomForm As New StockroomManagementForm(currentUser)
            stockroomForm.MdiParent = Me
            stockroomForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Set current user when dashboard is opened
    Public Sub SetCurrentUser(user As User)
        If user IsNot Nothing Then
            currentUser = user
            Me.Text = $"Oven Delights ERP - Main Dashboard - {user.DisplayName}"
        ElseIf AppSession.CurrentUser IsNot Nothing Then
            currentUser = AppSession.CurrentUser
            Me.Text = $"Oven Delights ERP - Main Dashboard - {AppSession.CurrentUsername}"
        End If
    End Sub

    Private Sub MainDashboard_Load(sender As Object, e As EventArgs) Handles MyBase.Load

    End Sub

    Private Sub UpdateWindowTitleFromSession()
        Try
            Dim username As String = Nothing
            Dim branchName As String = Nothing
            Dim roleName As String = Nothing

            If AppSession.CurrentUser IsNot Nothing Then
                username = AppSession.CurrentUsername
                If AppSession.CurrentUser.BranchID.HasValue Then
                    branchName = AppSession.CurrentBranchName
                End If
                roleName = AppSession.CurrentRoleName
            ElseIf currentUser IsNot Nothing Then
                username = currentUser.Username
                If currentUser.BranchID.HasValue Then
                    branchName = currentUser.BranchID.Value.ToString()
                End If
            End If

            Dim parts As New List(Of String)()
            parts.Add("Oven Delights ERP - Main Dashboard")
            If Not String.IsNullOrWhiteSpace(username) Then parts.Add(username)
            If Not String.IsNullOrWhiteSpace(branchName) Then parts.Add(branchName)
            If Not String.IsNullOrWhiteSpace(roleName) Then parts.Add(roleName)
            Me.Text = String.Join(" - ", parts)
        Catch
            ' Best-effort only
        End Try
    End Sub

    ' =============================
    ' Bundle-first workflow menus
    ' =============================
    Private Sub SetupBundleMenus()
        ' Manufacturing menu cleanup
        Dim mfg As ToolStripMenuItem = FindTopMenu("Manufacturing")
        If mfg IsNot Nothing Then
            ' Ensure clean Actions submenu
            Dim actions As ToolStripMenuItem = EnsureSubMenu(mfg, "Actions")
            ' Replace any legacy "MO Actions (Bundles)" entry with the new one
            For Each itm As ToolStripItem In actions.DropDownItems
                If String.Equals(itm.Text, "MO Actions (Bundles)", StringComparison.OrdinalIgnoreCase) Then
                    actions.DropDownItems.Remove(itm)
                    Exit For
                End If
            Next
            Dim reqMaterials As ToolStripMenuItem = EnsureSubMenu(actions, "Request Materials (Bundle)")
            RemoveHandler reqMaterials.Click, AddressOf OpenMOActionsBundles
            AddHandler reqMaterials.Click, AddressOf OpenMOActionsBundles

            ' Master Data -> BOM Editing
            Dim masterData As ToolStripMenuItem = EnsureSubMenu(mfg, "Master Data")
            Dim bomEdit As ToolStripMenuItem = EnsureSubMenu(masterData, "BOM Editing")
            RemoveHandler bomEdit.Click, AddressOf OpenBOMEditor
            AddHandler bomEdit.Click, AddressOf OpenBOMEditor
        End If

        ' Stockroom menu
        Dim stock As ToolStripMenuItem = FindTopMenu("Stockroom")
        If stock IsNot Nothing Then
            ' Receive Supplies (external receipts) - placeholder wiring
            Dim receive As ToolStripMenuItem = EnsureSubMenu(stock, "Receive Supplies")
            RemoveHandler receive.Click, AddressOf OpenStockroomReceive
            AddHandler receive.Click, AddressOf OpenStockroomReceive

            ' Supply to Manufacturing (Fulfill Bundles)
            Dim supply As ToolStripMenuItem = EnsureSubMenu(stock, "Supply to Manufacturing (Fulfill Bundles)")
            RemoveHandler supply.Click, AddressOf OpenInternalOrdersBundles
            AddHandler supply.Click, AddressOf OpenInternalOrdersBundles
        End If
    End Sub

    Private Sub OpenMOActionsBundles(sender As Object, e As EventArgs)
        Try
            ' Activate existing form if already open
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Manufacturing.MOActionsForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Manufacturing.MOActionsForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening MO Actions (Bundles): " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenInternalOrdersBundles(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Stockroom.InternalOrdersForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Stockroom.InternalOrdersForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Internal Orders (Bundles): " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenStockroomReceive(sender As Object, e As EventArgs)
        ' Placeholder: if a dedicated receiving form exists, wire it here.
        ' For now, navigate to Internal Orders screen as central hub.
        OpenInternalOrdersBundles(sender, e)
    End Sub

    Private Sub OpenBOMEditor(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Stockroom.InternalOrdersForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Stockroom.InternalOrdersForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening BOM Editing: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' =============================
    ' Retail/Mfg Shortcuts (runtime)
    ' =============================
    Private Sub SetupRetailAndMfgShortcuts()
        ' Retail > Products (frontend label), opens ProductsForm
        Dim retail As ToolStripMenuItem = EnsureTopMenu("Retail")
        If retail IsNot Nothing Then
            Dim products As ToolStripMenuItem = EnsureSubMenu(retail, "Products")
            RemoveHandler products.Click, AddressOf OpenRetailProducts
            AddHandler products.Click, AddressOf OpenRetailProducts
        End If

        ' Manufacturing > Producers Dashboard (touch)
        Dim mfg As ToolStripMenuItem = EnsureTopMenu("Manufacturing")
        If mfg IsNot Nothing Then
            Dim dash As ToolStripMenuItem = EnsureSubMenu(mfg, "Producers Dashboard")
            RemoveHandler dash.Click, AddressOf OpenMfgUserDashboard
            AddHandler dash.Click, AddressOf OpenMfgUserDashboard

            ' Also expose Complete Build (BOM) for bakers
            Dim complete As ToolStripMenuItem = EnsureSubMenu(mfg, "Complete Build (BOM)")
            RemoveHandler complete.Click, AddressOf OpenMfgCompleteBuild
            AddHandler complete.Click, AddressOf OpenMfgCompleteBuild
        End If

        ' If role is Manufacturer, restrict to only the two screens
        Try
            Dim role As String = If(AppSession.CurrentRoleName, String.Empty)
            If String.Equals(role, "Manufacturer", StringComparison.OrdinalIgnoreCase) Then
                RestrictManufacturerMenus()
                ' Land on Producers Dashboard automatically
                OpenMfgUserDashboard(Me, EventArgs.Empty)
            End If
        Catch
        End Try
    End Sub

    Private Sub OpenRetailProducts(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ProductsForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New ProductsForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Retail Products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenMfgUserDashboard(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Manufacturing.UserDashboardForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Manufacturing.UserDashboardForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Producers Dashboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenMfgCompleteBuild(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Manufacturing.CompleteBuildForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Manufacturing.CompleteBuildForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Complete Build: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub RestrictManufacturerMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        ' Disable all menus first
        For Each it As ToolStripItem In Me.MenuStrip1.Items
            it.Enabled = False
        Next
        ' Enable only Manufacturing top and limit its children to two entries
        Dim mfg As ToolStripMenuItem = EnsureTopMenu("Manufacturing")
        If mfg Is Nothing Then Exit Sub
        mfg.Enabled = True
        ' Disable all existing children
        For Each it As ToolStripItem In mfg.DropDownItems
            it.Enabled = False
        Next
        ' Ensure our two items are present and enabled
        Dim dash As ToolStripMenuItem = EnsureSubMenu(mfg, "Producers Dashboard")
        dash.Enabled = True
        RemoveHandler dash.Click, AddressOf OpenMfgUserDashboard
        AddHandler dash.Click, AddressOf OpenMfgUserDashboard

        Dim complete As ToolStripMenuItem = EnsureSubMenu(mfg, "Complete Build (BOM)")
        complete.Enabled = True
        RemoveHandler complete.Click, AddressOf OpenMfgCompleteBuild
        AddHandler complete.Click, AddressOf OpenMfgCompleteBuild
    End Sub

    ' =============================
    ' Retail Menus (full structure)
    ' =============================
    Private Sub SetupRetailMenus()
        Dim retail As ToolStripMenuItem = EnsureTopMenu("Retail")
        If retail Is Nothing Then Exit Sub

        ' POS
        Dim pos As ToolStripMenuItem = EnsureSubMenu(retail, "POS")
        Dim miNewSale As ToolStripMenuItem = EnsureSubMenu(pos, "New Sale (Scan/Lookup)")
        RemoveHandler miNewSale.Click, AddressOf RetailPlaceholder
        AddHandler miNewSale.Click, AddressOf RetailPlaceholder
        Dim miHold As ToolStripMenuItem = EnsureSubMenu(pos, "Hold/Resume Sales")
        RemoveHandler miHold.Click, AddressOf RetailPlaceholder
        AddHandler miHold.Click, AddressOf RetailPlaceholder
        Dim miReturns As ToolStripMenuItem = EnsureSubMenu(pos, "Returns/Refunds")
        RemoveHandler miReturns.Click, AddressOf RetailPlaceholder
        AddHandler miReturns.Click, AddressOf RetailPlaceholder
        Dim miZ As ToolStripMenuItem = EnsureSubMenu(pos, "Daily Z Report (Close)")
        RemoveHandler miZ.Click, AddressOf RetailPlaceholder
        AddHandler miZ.Click, AddressOf RetailPlaceholder

        ' Products
        Dim products As ToolStripMenuItem = EnsureSubMenu(retail, "Products")
        Dim internalProducts As ToolStripMenuItem = EnsureSubMenu(products, "Internal Products (Manufactured)")
        Dim miIntList As ToolStripMenuItem = EnsureSubMenu(internalProducts, "List & Search (Today-only)")
        RemoveHandler miIntList.Click, AddressOf OpenRetailProducts
        AddHandler miIntList.Click, AddressOf OpenRetailProducts
        Dim miIntReorder As ToolStripMenuItem = EnsureSubMenu(internalProducts, "Reorder (Create BOM Bundle → select Manufacturer)")
        RemoveHandler miIntReorder.Click, AddressOf OpenRetailProducts
        AddHandler miIntReorder.Click, AddressOf OpenRetailProducts
        Dim miIntLabels As ToolStripMenuItem = EnsureSubMenu(internalProducts, "Labels/Barcodes")
        RemoveHandler miIntLabels.Click, AddressOf RetailPlaceholder
        AddHandler miIntLabels.Click, AddressOf RetailPlaceholder

        Dim externalProducts As ToolStripMenuItem = EnsureSubMenu(products, "External Products (Purchased)")
        Dim miExtList As ToolStripMenuItem = EnsureSubMenu(externalProducts, "List & Search")
        RemoveHandler miExtList.Click, AddressOf OpenRetailExternalProducts
        AddHandler miExtList.Click, AddressOf OpenRetailExternalProducts
        Dim miExtPrices As ToolStripMenuItem = EnsureSubMenu(externalProducts, "Price Lists")
        RemoveHandler miExtPrices.Click, AddressOf RetailPlaceholder
        AddHandler miExtPrices.Click, AddressOf RetailPlaceholder
        Dim miExtLabels As ToolStripMenuItem = EnsureSubMenu(externalProducts, "Labels/Barcodes")
        RemoveHandler miExtLabels.Click, AddressOf RetailPlaceholder
        AddHandler miExtLabels.Click, AddressOf RetailPlaceholder

        Dim miCatTaxes As ToolStripMenuItem = EnsureSubMenu(products, "Categories & Taxes")
        RemoveHandler miCatTaxes.Click, AddressOf RetailPlaceholder
        AddHandler miCatTaxes.Click, AddressOf RetailPlaceholder

        ' Inventory (Retail Branch)
        Dim inv As ToolStripMenuItem = EnsureSubMenu(retail, "Inventory (Retail Branch)")
        Dim miOnHand As ToolStripMenuItem = EnsureSubMenu(inv, "Stock on Hand")
        RemoveHandler miOnHand.Click, AddressOf OpenRetailStockOnHand
        AddHandler miOnHand.Click, AddressOf OpenRetailStockOnHand
        Dim miAdjust As ToolStripMenuItem = EnsureSubMenu(inv, "Adjustments (Write-off, Count)")
        RemoveHandler miAdjust.Click, AddressOf RetailPlaceholder
        AddHandler miAdjust.Click, AddressOf RetailPlaceholder
        Dim miSerial As ToolStripMenuItem = EnsureSubMenu(inv, "Serial/Lot (Query) [if enabled]")
        RemoveHandler miSerial.Click, AddressOf RetailPlaceholder
        AddHandler miSerial.Click, AddressOf RetailPlaceholder
        Dim miReorderPts As ToolStripMenuItem = EnsureSubMenu(inv, "Reorder Points (Alerts)")
        RemoveHandler miReorderPts.Click, AddressOf RetailPlaceholder
        AddHandler miReorderPts.Click, AddressOf RetailPlaceholder

        ' Transfers (IBT)
        Dim transfers As ToolStripMenuItem = EnsureSubMenu(retail, "Transfers (IBT)")
        Dim miTO As ToolStripMenuItem = EnsureSubMenu(transfers, "Transfer Orders")
        Dim miTOCreate As ToolStripMenuItem = EnsureSubMenu(miTO, "Create")
        RemoveHandler miTOCreate.Click, AddressOf RetailPlaceholder
        AddHandler miTOCreate.Click, AddressOf RetailPlaceholder
        Dim miTODispatch As ToolStripMenuItem = EnsureSubMenu(miTO, "Dispatch")
        RemoveHandler miTODispatch.Click, AddressOf RetailPlaceholder
        AddHandler miTODispatch.Click, AddressOf RetailPlaceholder
        Dim miTOReceive As ToolStripMenuItem = EnsureSubMenu(miTO, "Receive")
        RemoveHandler miTOReceive.Click, AddressOf RetailPlaceholder
        AddHandler miTOReceive.Click, AddressOf RetailPlaceholder
        Dim miInTransit As ToolStripMenuItem = EnsureSubMenu(transfers, "In-Transit")
        RemoveHandler miInTransit.Click, AddressOf RetailPlaceholder
        AddHandler miInTransit.Click, AddressOf RetailPlaceholder

        ' Purchasing
        Dim purchasing As ToolStripMenuItem = EnsureSubMenu(retail, "Purchasing")
        Dim miPO As ToolStripMenuItem = EnsureSubMenu(purchasing, "Purchase Orders")
        Dim miPONew As ToolStripMenuItem = EnsureSubMenu(miPO, "New PO (Inventory or Product)")
        RemoveHandler miPONew.Click, AddressOf RetailPlaceholder
        AddHandler miPONew.Click, AddressOf RetailPlaceholder
        Dim miPOApprove As ToolStripMenuItem = EnsureSubMenu(miPO, "Approve")
        RemoveHandler miPOApprove.Click, AddressOf RetailPlaceholder
        AddHandler miPOApprove.Click, AddressOf RetailPlaceholder
        Dim miPOReceive As ToolStripMenuItem = EnsureSubMenu(miPO, "Receive (GRN)")
        RemoveHandler miPOReceive.Click, AddressOf RetailPlaceholder
        AddHandler miPOReceive.Click, AddressOf RetailPlaceholder
        Dim miSuppliers As ToolStripMenuItem = EnsureSubMenu(purchasing, "Suppliers")
        RemoveHandler miSuppliers.Click, AddressOf RetailPlaceholder
        AddHandler miSuppliers.Click, AddressOf RetailPlaceholder
        Dim miPrices As ToolStripMenuItem = EnsureSubMenu(purchasing, "Price Agreements")
        RemoveHandler miPrices.Click, AddressOf RetailPlaceholder
        AddHandler miPrices.Click, AddressOf RetailPlaceholder

        ' Manufacturing (Hand-off)
        Dim handoff As ToolStripMenuItem = EnsureSubMenu(retail, "Manufacturing (Hand-off)")
        Dim miDash As ToolStripMenuItem = EnsureSubMenu(handoff, "Producer Dashboard (Today-only)")
        RemoveHandler miDash.Click, AddressOf OpenMfgUserDashboard
        AddHandler miDash.Click, AddressOf OpenMfgUserDashboard
        Dim miComplete As ToolStripMenuItem = EnsureSubMenu(handoff, "Complete Build (BOM → FG to Retail)")
        RemoveHandler miComplete.Click, AddressOf OpenMfgCompleteBuild
        AddHandler miComplete.Click, AddressOf OpenMfgCompleteBuild

        ' Reports
        Dim reports As ToolStripMenuItem = EnsureSubMenu(retail, "Reports")
        Dim miRptSOH As ToolStripMenuItem = EnsureSubMenu(reports, "Stock on Hand by Branch")
        RemoveHandler miRptSOH.Click, AddressOf RetailPlaceholder
        AddHandler miRptSOH.Click, AddressOf RetailPlaceholder
        Dim miRptSales As ToolStripMenuItem = EnsureSubMenu(reports, "Sales by Product/Category")
        RemoveHandler miRptSales.Click, AddressOf RetailPlaceholder
        AddHandler miRptSales.Click, AddressOf RetailPlaceholder
        Dim miRptMargins As ToolStripMenuItem = EnsureSubMenu(reports, "Margins")
        RemoveHandler miRptMargins.Click, AddressOf RetailPlaceholder
        AddHandler miRptMargins.Click, AddressOf RetailPlaceholder
        Dim miRptTransit As ToolStripMenuItem = EnsureSubMenu(reports, "Transfers (In-Transit)")
        RemoveHandler miRptTransit.Click, AddressOf RetailPlaceholder
        AddHandler miRptTransit.Click, AddressOf RetailPlaceholder
        Dim miRptAdj As ToolStripMenuItem = EnsureSubMenu(reports, "Adjustments & Write-offs")
        RemoveHandler miRptAdj.Click, AddressOf RetailPlaceholder
        AddHandler miRptAdj.Click, AddressOf RetailPlaceholder

        ' Settings
        Dim settings As ToolStripMenuItem = EnsureSubMenu(retail, "Settings")
        Dim miBarcodes As ToolStripMenuItem = EnsureSubMenu(settings, "Barcodes (GTIN mapping)")
        RemoveHandler miBarcodes.Click, AddressOf RetailPlaceholder
        AddHandler miBarcodes.Click, AddressOf RetailPlaceholder
        Dim miGL As ToolStripMenuItem = EnsureSubMenu(settings, "GL Mappings (RetailInventory, FGInventory, InterBranch, COGS/Revenue)")
        RemoveHandler miGL.Click, AddressOf RetailPlaceholder
        AddHandler miGL.Click, AddressOf RetailPlaceholder
        Dim miSerialLot As ToolStripMenuItem = EnsureSubMenu(settings, "Serial/Lot Policies")
        RemoveHandler miSerialLot.Click, AddressOf RetailPlaceholder
        AddHandler miSerialLot.Click, AddressOf RetailPlaceholder
        Dim miRoles As ToolStripMenuItem = EnsureSubMenu(settings, "Roles & Access (POS overrides, approvals)")
        RemoveHandler miRoles.Click, AddressOf RetailPlaceholder
        AddHandler miRoles.Click, AddressOf RetailPlaceholder
    End Sub

    Private Sub RetailPlaceholder(sender As Object, e As EventArgs)
        Dim it = TryCast(sender, ToolStripMenuItem)
        Dim name As String = If(it IsNot Nothing, it.Text, "Feature")
        MessageBox.Show($"{name} - coming soon", "Retail", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub OpenRetailStockOnHand(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Retail.RetailStockOnHandForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Retail.RetailStockOnHandForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Retail Stock on Hand: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenRetailExternalProducts(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Retail.ExternalProductsForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Retail.ExternalProductsForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening External Products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' --- Professional Top-Level Menus ---
    Private Sub SetupProfessionalMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub

        ' Retail top menu (manager view)
        Dim retail As ToolStripMenuItem = EnsureTopMenu("Retail")
        If retail IsNot Nothing Then
            Dim dash As ToolStripMenuItem = EnsureSubMenu(retail, "Dashboard")
            RemoveHandler dash.Click, AddressOf OpenRetailManagerDashboard
            AddHandler dash.Click, AddressOf OpenRetailManagerDashboard

            Dim inv As ToolStripMenuItem = EnsureSubMenu(retail, "Inventory")
            Dim miSoh As ToolStripMenuItem = EnsureSubMenu(inv, "Stock on Hand")
            RemoveHandler miSoh.Click, AddressOf OpenRetailStockOnHand
            AddHandler miSoh.Click, AddressOf OpenRetailStockOnHand

            Dim purch As ToolStripMenuItem = EnsureSubMenu(retail, "Purchasing")
            Dim miPO As ToolStripMenuItem = EnsureSubMenu(purch, "Purchase Orders")
            Dim miPONew As ToolStripMenuItem = EnsureSubMenu(miPO, "Create / Approve / Receive")
            RemoveHandler miPONew.Click, AddressOf RetailPlaceholder
            AddHandler miPONew.Click, AddressOf RetailPlaceholder
        End If

        ' Stockroom top menu
        Dim stockMenu As ToolStripMenuItem = EnsureTopMenu("Stockroom")
        If stockMenu IsNot Nothing Then
            Dim dash As ToolStripMenuItem = EnsureSubMenu(stockMenu, "Dashboard")
            RemoveHandler dash.Click, AddressOf OpenStockroomDashboard
            AddHandler dash.Click, AddressOf OpenStockroomDashboard

            ' Consolidated BOM action for Stockroom
            Dim bomFulfill As ToolStripMenuItem = EnsureSubMenu(stockMenu, "BOM Fulfill")
            RemoveHandler bomFulfill.Click, AddressOf OpenStockroomDashboard
            AddHandler bomFulfill.Click, AddressOf OpenStockroomDashboard
        End If

        ' Manufacturing top menu
        Dim mfg As ToolStripMenuItem = EnsureTopMenu("Manufacturing")
        If mfg IsNot Nothing Then
            ' Consolidate under BOM submenu
            Dim bom As ToolStripMenuItem = EnsureSubMenu(mfg, "BOM")
            Dim bomCreate As ToolStripMenuItem = EnsureSubMenu(bom, "BOM Create")
            RemoveHandler bomCreate.Click, AddressOf OpenMfgBOMCreate
            AddHandler bomCreate.Click, AddressOf OpenMfgBOMCreate
            Dim bomComplete As ToolStripMenuItem = EnsureSubMenu(bom, "BOM Complete")
            RemoveHandler bomComplete.Click, AddressOf OpenMfgBOMComplete
            AddHandler bomComplete.Click, AddressOf OpenMfgBOMComplete
        End If
    End Sub

    Private Sub OpenRetailManagerDashboard(sender As Object, e As EventArgs)
        ' Open Retail Manager Dashboard as MDI child
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Retail.RetailManagerDashboardForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Retail.RetailManagerDashboardForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Retail Dashboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenStockroomDashboard(sender As Object, e As EventArgs)
        ' Open Stockroom Dashboard as MDI child
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Stockroom.StockroomDashboardForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Stockroom.StockroomDashboardForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Stockroom Dashboard: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenMfgBOMCreate(sender As Object, e As EventArgs)
        ' Open BOMCreateForm as MDI child
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Manufacturing.BOMCreateForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Manufacturing.BOMCreateForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening BOM Create: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenMfgBOMComplete(sender As Object, e As EventArgs)
        ' Open BOMCompleteForm as MDI child
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Manufacturing.BOMCompleteForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Manufacturing.BOMCompleteForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening BOM Complete: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
End Class
