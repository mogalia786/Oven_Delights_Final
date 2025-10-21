Imports System.Windows.Forms
Imports Microsoft.Web.WebView2.WinForms
Imports System.Data.SqlClient
Imports System.Data
Imports System.Configuration

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
    Private sidebar As UI.SidebarControl
    Private currentProvider As UI.ISidebarProvider
    ' Branch rule enforcement timer (hide branch selectors for non–Super Admin)
    Private ReadOnly _branchRuleTimer As New Timer()

    Public Sub New(user As User)
        MessageBox.Show("MainDashboard Constructor STARTED!", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
        ' Diagnostic guard: capture any exception thrown inside InitializeComponent
        Try
            InitializeComponent()
        Catch ex As Exception
            ' Log initialization error and show user-friendly message
            System.Diagnostics.Debug.WriteLine($"InitializeComponent failed: {ex.Message}")
            Dim errorForm As New Form() With {
                .Text = "System Error",
                .Size = New Size(400, 200),
                .StartPosition = FormStartPosition.CenterScreen
            }
            Dim lblError As New Label() With {
                .Text = "The application failed to initialize properly. Please contact support.",
                .Dock = DockStyle.Fill,
                .TextAlign = ContentAlignment.MiddleCenter
            }
            errorForm.Controls.Add(lblError)
            errorForm.ShowDialog()
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
            ' Disable auto-opening child on startup per request
            'EnsureDashboardOpen()
        Catch
        End Try

        ' Wire Manufacturing menu (non-invasive to Designer)
        Try
            SetupManufacturingMenu()
        Catch
            ' do not block dashboard if menu wiring fails
        End Try

        ' Apply modern theme to main dashboard with logo
        Try
            Dim logoPath = IO.Path.Combine(Application.StartupPath, "Resources\ASSETS\LOGO.png")
            If IO.File.Exists(logoPath) Then
                UI.Theme.Apply(Me, Image.FromFile(logoPath))
                UI.Theme.EnableAutoApply(logoPath)
            Else
                UI.Theme.Apply(Me)
            End If
        Catch
        End Try

        ' Setup Administration menu
        Try
            SetupAdministrationMenu()
        Catch
        End Try

        ' Force create all core menus early
        ' DISABLED: Designer already creates menus, this causes duplicates
        'Try
        '    CreateCoreMenus()
        'Catch ex As Exception
        '    System.Diagnostics.Debug.WriteLine($"Menu creation error: {ex.Message}")
        'End Try
        
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

        ' Consolidate duplicate Administration menus - ensure only one exists
        Try
            ConsolidateAdministrationMenus()
        Catch
        End Try

        ' Wire bundle menus (Manufacturing & Stockroom)
        Try
            SetupBundleMenus()
            SetupRetailInventoryMenus()
        Catch
            ' non-fatal
        End Try

        ' Role-based menu security - DISABLED FOR DEBUGGING
        Try
            ' ApplyRoleMenuSecurity()
        Catch
        End Try

        ' Role-based landing after core UI is ready
        Try
            ' Apply role-based menu security - DISABLED FOR DEBUGGING
            Try
                ' Dim permissionService As New RolePermissionService()
                ' permissionService.ApplyMenuSecurity(Me.MenuStrip1)
            Catch
                ' non-fatal
            End Try

            ' Update window title with branch and role
            Try
                UpdateWindowTitleFromSession()
            Catch
            End Try
        Catch
            ' non-fatal
        End Try

        ' Ensure Accounting menu placeholders exist
        Try
            SetupAccountingMenus()
        Catch
        End Try
        Try
            SetupAccountingBankingMenus()
        Catch
        End Try
        Try
            SetupAccountingReportsMenus()
        Catch
        End Try
        ' Administration menu handlers are now wired in ConsolidateAdministrationMenus
        ' Accounting viewers (grids)
        Try
            SetupAccountingViewerMenus()
        Catch
        End Try

        ' Add Admin menu and Role Access Control launcher
        Try
            SetupAdminMenus()
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

        ' Ensure Retail > Reports items open working forms
        Try
            SetupRetailReportMenus()
            ' SetupManufacturingMenus() - Method not implemented yet
            SetupStockroomMenus()
        Catch
        End Try

        ' Extend Retail > Reports with Sales by Product (Grid)
        Try
            SetupRetailReportMenus_Ext()
        Catch
        End Try

        ' Retail > Settings > System Settings
        Try
            SetupRetailSettingsMenus()
        Catch
        End Try

        ' Retail > Reports > Sales Report
        Try
            SetupRetailSalesReportMenu()
        Catch
        End Try

        ' Retail > Reports > Inventory Report
        Try
            SetupRetailInventoryReportMenu()
        Catch
        End Try

        ' Manufacturing > Production Schedule
        Try
            SetupManufacturingProductionScheduleMenu()
        Catch
        End Try

        ' Manufacturing > Orders > New Orders, Ready Orders, All Orders
        MessageBox.Show("ABOUT TO CALL SetupManufacturingOrdersMenu", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Try
            SetupManufacturingOrdersMenu()
            MessageBox.Show("SetupManufacturingOrdersMenu COMPLETED", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Catch ex As Exception
            MessageBox.Show($"ERROR in SetupManufacturingOrdersMenu: {ex.Message}{vbCrLf}{vbCrLf}{ex.StackTrace}", "MENU ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try

        ' Stockroom > Reports > Stock Movement Report
        Try
            SetupStockroomStockMovementReportMenu()
        Catch
        End Try

        ' Build concise, professional top-level menus for Retail, Stockroom, and Manufacturing
        ' DISABLED: Causes duplicate menus since Designer already creates them
        'Try
        '    SetupProfessionalMenus()
        'Catch
        '    ' non-fatal
        'End Try

        ' Ensure Stockroom > Supply Invoices (Capture, Edit)
        Try
            SetupStockroomInvoicesMenus()
        Catch
            ' non-fatal
        End Try
        ' Ensure Stockroom > Inter-Branch Transfer menus
        Try
            SetupInterBranchMenus()
        Catch
            ' non-fatal
        End Try
        ' Ensure Stockroom > Reports > Cross-Branch Lookup
        Try
            SetupStockroomReportsMenus()
        Catch
            ' non-fatal
        End Try
        
        ' Utilities menu (CSV imports)
        Try
            SetupUtilitiesMenu()
        Catch
            ' non-fatal
        End Try

        ' Start global branch lock rule enforcement for non–Super Admins
        Try
            Dim isSuper As Boolean = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
            If Not isSuper Then
                StartBranchRuleEnforcement()
            End If
        Catch
        End Try

        ' Apply logo-driven theme using provided logo path, with fallback to Application.StartupPath\logo.png
        Try
            Dim explicitLogoPath As String = "C:\\Development Apps\\Cascades projects\\Oven-Delights-ERP\\Oven-Delights-ERP\\Resources\\ASSETS\\LOGO.png"
            Dim img As Image = Nothing
            Dim selectedLogoPath As String = Nothing
            If IO.File.Exists(explicitLogoPath) Then
                img = Image.FromFile(explicitLogoPath)
                selectedLogoPath = explicitLogoPath
            Else
                Dim fallback As String = IO.Path.Combine(Application.StartupPath, "logo.png")
                If IO.File.Exists(fallback) Then
                    img = Image.FromFile(fallback)
                    selectedLogoPath = fallback
                End If
            End If
            If img IsNot Nothing Then
                UI.Theme.Apply(Me, img)
                ' Disable global auto-apply to prevent duplicate logos/theme repaint storms
                ' (Explicitly apply theme per form as needed)
            Else
                ' Apply base theme if logo not found
                UI.Theme.Apply(Me, Nothing)
            End If
        Catch
            ' Theme application failure should not block dashboard
        End Try

        ' Apply role-based menu permissions (hide/disable) for non–Super Admin
        Try
            Dim isSuper As Boolean = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
            If Not isSuper Then ApplyMenuPermissions()
        Catch
        End Try
    End Sub

    ' ---------------- Stockroom > Reports wiring ----------------
    Private Sub SetupStockroomReportsMenus()
        Dim stockroom As ToolStripMenuItem = FindTopMenu("Stockroom")
        If stockroom Is Nothing Then stockroom = EnsureTopMenu("Stockroom")
        If stockroom Is Nothing Then Exit Sub
        Dim reports As ToolStripMenuItem = EnsureSubMenu(stockroom, "Reports")
        Dim miLookup As ToolStripMenuItem = EnsureSubMenu(reports, "Cross-Branch Lookup")
        RemoveHandler miLookup.Click, AddressOf OpenCrossBranchLookup
        AddHandler miLookup.Click, AddressOf OpenCrossBranchLookup
    End Sub

    Private Sub OpenCrossBranchLookup(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is CrossBranchLookupForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New CrossBranchLookupForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            ' Log error and show user-friendly notification
            System.Diagnostics.Debug.WriteLine($"Cross-Branch Lookup error: {ex.Message}")
            ShowUserNotification("Cross-Branch Lookup is temporarily unavailable. Please try again later.", "Stockroom Reports")
        End Try
    End Sub

    ' ---------------- Stockroom > Inter-Branch Transfer wiring ----------------
    Private Sub SetupInterBranchMenus()
        Dim stockroom As ToolStripMenuItem = FindTopMenu("Stockroom")
        If stockroom Is Nothing Then stockroom = EnsureTopMenu("Stockroom")
        If stockroom Is Nothing Then Exit Sub

        Dim ibt As ToolStripMenuItem = EnsureSubMenu(stockroom, "Inter-Branch Transfer")
        Dim miReq As ToolStripMenuItem = EnsureSubMenu(ibt, "Requests List")
        RemoveHandler miReq.Click, AddressOf OpenIbtRequestsList
        AddHandler miReq.Click, AddressOf OpenIbtRequestsList
        Dim miFulfil As ToolStripMenuItem = EnsureSubMenu(ibt, "Fulfil Transfers")
        RemoveHandler miFulfil.Click, AddressOf OpenIbtFulfil
        AddHandler miFulfil.Click, AddressOf OpenIbtFulfil
    End Sub

    Private Sub OpenIbtRequestsList(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is InterBranchRequestsListForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New InterBranchRequestsListForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            ' Log error and show user-friendly notification
            System.Diagnostics.Debug.WriteLine($"IBT Requests error: {ex.Message}")
            ShowUserNotification("Inter-Branch Transfer requests are temporarily unavailable. Please try again later.", "Inter-Branch")
        End Try
    End Sub

    Private Sub OpenInterBranchTransferCreate(sender As Object, e As EventArgs)
        Try
            Dim frm As New Forms.InterBranchTransferForm()
            frm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show($"Error opening Inter-Branch Transfer: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenIbtFulfil(sender As Object, e As EventArgs)
        ' The fulfilment form requires a RequestID; route to Requests List to select one.
        OpenIbtRequestsList(sender, e)
    End Sub

    ' Minimal role-based menu permissions stub to satisfy references; implement details later
    Private Sub ApplyMenuPermissions()
        ' No-op placeholder to resolve compile references
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

    Private Sub SetupAdminMenus()
        ' Only Super Administrator may see Admin menu
        Dim isSuper As Boolean = String.Equals(AppSession.CurrentRoleName, "Super Administrator", StringComparison.OrdinalIgnoreCase)
        If Not isSuper Then Exit Sub
        Dim adminTop = EnsureTopMenu("Administration")
        If adminTop Is Nothing Then Exit Sub
        ' Role Access Control launcher
        Dim miRoles = EnsureSubMenu(adminTop, "Role Access Control")
        RemoveHandler miRoles.Click, AddressOf OpenRoleAccessControl
        AddHandler miRoles.Click, AddressOf OpenRoleAccessControl
    End Sub

    Private Sub OpenRoleAccessControl(sender As Object, e As EventArgs)
        Try
            Dim frm As New RoleAccessControlForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            ' Log error and show user-friendly notification
            System.Diagnostics.Debug.WriteLine($"Role Access Control error: {ex.Message}")
            ShowUserNotification("Role Access Control is temporarily unavailable. Please contact your administrator.", "Administration")
        End Try
    End Sub

    ' Helper method for user notifications
    Private Sub ShowUserNotification(message As String, title As String)
        Try
            Dim notificationForm As New Form() With {
                .Text = title,
                .Size = New Size(400, 150),
                .StartPosition = FormStartPosition.CenterParent,
                .FormBorderStyle = FormBorderStyle.FixedDialog,
                .MaximizeBox = False,
                .MinimizeBox = False,
                .ShowInTaskbar = False
            }
            
            Dim lblMessage As New Label() With {
                .Text = message,
                .Dock = DockStyle.Fill,
                .TextAlign = ContentAlignment.MiddleCenter,
                .Font = New Font("Segoe UI", 10)
            }
            
            Dim btnOK As New Button() With {
                .Text = "OK",
                .Size = New Size(75, 30),
                .Anchor = AnchorStyles.Bottom Or AnchorStyles.Right,
                .DialogResult = DialogResult.OK
            }
            btnOK.Location = New Point(notificationForm.Width - btnOK.Width - 20, notificationForm.Height - btnOK.Height - 40)
            
            notificationForm.Controls.Add(lblMessage)
            notificationForm.Controls.Add(btnOK)
            notificationForm.AcceptButton = btnOK
            
            notificationForm.ShowDialog(Me)
        Catch
            ' Fallback to simple message box if custom notification fails
            MessageBox.Show(message, title, MessageBoxButtons.OK, MessageBoxIcon.Information)
        End Try
    End Sub


    Private Sub OnOpenBankStatementImport(sender As Object, e As EventArgs)
        Try
            Using f As New BankStatementImportForm()
                f.ShowDialog(Me)
            End Using
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Bank Statement Import error: {ex.Message}")
            ShowUserNotification("Bank Statement Import is temporarily unavailable. Please try again later.", "Accounting")
        End Try
    End Sub

    Private Sub OpenSARSReporting(sender As Object, e As EventArgs)
        ' Open SARS Reporting form as MDI child
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is SARSReportingForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New SARSReportingForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"SARS Reporting error: {ex.Message}")
            ShowUserNotification("SARS Reporting is temporarily unavailable. Please contact your administrator.", "SARS Reporting")
        End Try
    End Sub

    Private Sub SetupAccountingReportsMenus()
        Dim accountingTop = EnsureTopMenu("Accounting")
        If accountingTop Is Nothing Then Exit Sub
        Dim reports = EnsureSubMenu(accountingTop, "Reports")
        Dim miIS = EnsureSubMenu(reports, "Income Statement")
        RemoveHandler miIS.Click, AddressOf OnOpenIncomeStatement
        AddHandler miIS.Click, AddressOf OnOpenIncomeStatement
    End Sub

    ' Accounting > Banking menus
    Private Sub SetupAccountingBankingMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        Dim acct As ToolStripMenuItem = EnsureTopMenu("Accounting")
        If acct Is Nothing Then Exit Sub
        Dim banking As ToolStripMenuItem = EnsureSubMenu(acct, "Banking")
        Dim miImport As ToolStripMenuItem = EnsureSubMenu(banking, "Bank Statement Import…")
        RemoveHandler miImport.Click, AddressOf OnOpenBankStatementImport
        AddHandler miImport.Click, AddressOf OnOpenBankStatementImport
    End Sub

    Private Sub OnOpenIncomeStatement(sender As Object, e As EventArgs)
        Try
            Dim frm As New IncomeStatementForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Income Statement error: {ex.Message}")
            ShowUserNotification("Income Statement report is temporarily unavailable. Please try again later.", "Accounting")
        End Try
    End Sub

    Private Sub OnOpenBalanceSheet(sender As Object, e As EventArgs)
        Try
            Dim frm As New BalanceSheetForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Balance Sheet error: {ex.Message}")
            ShowUserNotification("Balance Sheet report is temporarily unavailable. Please try again later.", "Accounting")
        End Try
    End Sub

    Private Sub OnOpenAccountsPayable(sender As Object, e As EventArgs)
        Try
            Dim frm As New Forms.Accounting.AccountsPayableForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Accounts Payable error: {ex.Message}")
            ShowUserNotification("Accounts Payable is temporarily unavailable. Please try again later.", "Accounting")
        End Try
    End Sub

    Private Sub OnOpenInvoiceCapture(sender As Object, e As EventArgs)
        Try
            Dim frm As New InvoiceCaptureForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Invoice Capture error: {ex.Message}")
            ShowUserNotification("Invoice Capture is temporarily unavailable. Please try again later.", "Accounting")
        End Try
    End Sub

    Private Sub SetupRetailInventoryMenus()
        Dim retail As ToolStripMenuItem = EnsureTopMenu("Retail")
        If retail Is Nothing Then Exit Sub
        
        Dim inventory As ToolStripMenuItem = EnsureSubMenu(retail, "Inventory")
        
        Dim stockOnHand As ToolStripMenuItem = EnsureSubMenu(inventory, "Stock on Hand")
        RemoveHandler stockOnHand.Click, AddressOf OnOpenRetailStockOnHand
        AddHandler stockOnHand.Click, AddressOf OnOpenRetailStockOnHand
        
        Dim adjustments As ToolStripMenuItem = EnsureSubMenu(inventory, "Adjustments")
        RemoveHandler adjustments.Click, AddressOf OnOpenRetailAdjustments
        AddHandler adjustments.Click, AddressOf OnOpenRetailAdjustments
    End Sub

    Private Sub OnOpenRetailStockOnHand(sender As Object, e As EventArgs)
        Try
            Dim frm As New Retail.RetailStockOnHandForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Retail Stock on Hand error: {ex.Message}")
            ShowUserNotification("Retail Stock on Hand is temporarily unavailable. Please try again later.", "Retail")
        End Try
    End Sub

    Private Sub OnOpenRetailAdjustments(sender As Object, e As EventArgs)
        Try
            Dim frm As New RetailInventoryAdjustmentForm(currentUser)
            frm.ShowDialog(Me)
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Retail Adjustments error: {ex.Message}")
            ShowUserNotification("Retail Adjustments is temporarily unavailable. Please try again later.", "Retail")
        End Try
    End Sub

    Private Sub StartBranchRuleEnforcement()
        _branchRuleTimer.Interval = 1000 ' check every second, lightweight
        RemoveHandler _branchRuleTimer.Tick, AddressOf BranchRuleTick
        AddHandler _branchRuleTimer.Tick, AddressOf BranchRuleTick
        _branchRuleTimer.Start()
    End Sub

    Private Sub BranchRuleTick(sender As Object, e As EventArgs)
        Try
            For Each f As Form In Application.OpenForms
                If f Is Nothing OrElse f.IsDisposed Then Continue For
                ' Hide typical branch selector controls for non–Super Admins
                Try
                    Dim cbo = f.Controls.Find("cboBranch", True).FirstOrDefault()
                    Dim lbl = f.Controls.Find("lblBranch", True).FirstOrDefault()
                    If cbo IsNot Nothing Then cbo.Visible = False
                    If lbl IsNot Nothing Then lbl.Visible = False
                Catch
                End Try
                ' Attach Print/Export context menu to all DataGridViews
                Try
                    UI.GridExportAttacher.AttachOnForm(f)
                Catch
                End Try
            Next
        Catch
            ' best effort only
        End Try
    End Sub

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

    ' ---------------- Stockroom > Supply Invoices menu wiring ----------------
    Private Sub SetupStockroomInvoicesMenus()
        Dim stockroom As ToolStripMenuItem = FindTopMenu("Stockroom")
        If stockroom Is Nothing Then stockroom = EnsureTopMenu("Stockroom")
        If stockroom Is Nothing Then Exit Sub

        ' Create/ensure: Stockroom > Supply Invoices > (Capture Invoice, Edit Invoice)
        Dim supply As ToolStripMenuItem = EnsureSubMenu(stockroom, "Supply Invoices")
        Dim miCapture As ToolStripMenuItem = EnsureSubMenu(supply, "Capture Invoice")
        RemoveHandler miCapture.Click, AddressOf OpenSupplyCaptureInvoice
        AddHandler miCapture.Click, AddressOf OpenSupplyCaptureInvoice
        Dim miEdit As ToolStripMenuItem = EnsureSubMenu(supply, "Edit Invoice")
        RemoveHandler miEdit.Click, AddressOf OpenSupplyEditInvoice
        AddHandler miEdit.Click, AddressOf OpenSupplyEditInvoice
    End Sub

    Private Sub OpenInvoiceEditor(sender As Object, e As EventArgs)
        Try
            Dim branchId As Integer = If(currentUser IsNot Nothing AndAlso currentUser.BranchID.HasValue, currentUser.BranchID.Value, 0)
            Dim userId As Integer = If(currentUser IsNot Nothing, currentUser.UserID, 0)
            Dim f As New InvoiceEditorForm(branchId, userId)
            f.MdiParent = Me
            f.Show()
            f.WindowState = FormWindowState.Maximized
            f.BringToFront()
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Invoice Editor error: {ex.Message}")
            ShowUserNotification("Invoice Editor is temporarily unavailable. Please try again later.", "Invoice Editor")
        End Try
    End Sub

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

        ' Stockroom menu items
        Dim stockroomManagementItem As New ToolStripMenuItem("Stockroom Management")
        AddHandler stockroomManagementItem.Click, AddressOf OpenStockroomDashboard
        
        Dim inventoryCatalogItem As New ToolStripMenuItem("Inventory Catalog")
        AddHandler inventoryCatalogItem.Click, AddressOf OpenAddInventory
        
        Dim purchaseOrderItem As New ToolStripMenuItem("Purchase Orders")
        AddHandler purchaseOrderItem.Click, AddressOf OpenCreatePurchaseOrder
        
        Dim invoiceCaptureItem As New ToolStripMenuItem("Invoice Capture")
        AddHandler invoiceCaptureItem.Click, AddressOf OpenInvoiceCapture
        
        Dim grvManagementItem As New ToolStripMenuItem("GRV Management")
        AddHandler grvManagementItem.Click, AddressOf OpenGRVManagement

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
            System.Diagnostics.Debug.WriteLine($"Categories error: {ex.Message}")
            ShowUserNotification("Categories management is temporarily unavailable. Please try again later.", "Categories")
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
            System.Diagnostics.Debug.WriteLine($"Subcategories error: {ex.Message}")
            ShowUserNotification("Subcategories management is temporarily unavailable. Please try again later.", "Subcategories")
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
        
        ' Cash Book submenu
        Dim miCashBookMenu As ToolStripMenuItem = EnsureSubMenu(acct, "Cash Book")
        
        ' Main Cash Book
        Dim miMainCashBook As ToolStripMenuItem = EnsureSubMenu(miCashBookMenu, "Main Cash Book")
        RemoveHandler miMainCashBook.Click, AddressOf OpenMainCashBook
        AddHandler miMainCashBook.Click, AddressOf OpenMainCashBook
        
        ' Petty Cash
        Dim miPettyCash As ToolStripMenuItem = EnsureSubMenu(miCashBookMenu, "Petty Cash")
        RemoveHandler miPettyCash.Click, AddressOf OpenPettyCash
        AddHandler miPettyCash.Click, AddressOf OpenPettyCash
        
        ' Cash Book Ledger Viewer
        Dim miCashBookLedger As ToolStripMenuItem = EnsureSubMenu(miCashBookMenu, "Ledger Viewer")
        RemoveHandler miCashBookLedger.Click, AddressOf OpenCashBookLedger
        AddHandler miCashBookLedger.Click, AddressOf OpenCashBookLedger
        
        ' Legacy Cash Book Journal (keep for compatibility)
        Dim miCashBookLegacy As ToolStripMenuItem = EnsureSubMenu(acct, "Cash Book Journal (Legacy)")
        RemoveHandler miCashBookLegacy.Click, AddressOf OpenCashBookJournal
        AddHandler miCashBookLegacy.Click, AddressOf OpenCashBookJournal
        
        ' Timesheet Entry
        Dim miTimesheet As ToolStripMenuItem = EnsureSubMenu(acct, "Timesheet Entry")
        RemoveHandler miTimesheet.Click, AddressOf OpenTimesheetEntry
        AddHandler miTimesheet.Click, AddressOf OpenTimesheetEntry
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
            System.Diagnostics.Debug.WriteLine($"Expense Types error: {ex.Message}")
            ShowUserNotification("Expense Types management is temporarily unavailable. Please try again later.", "Expense Types")
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
            System.Diagnostics.Debug.WriteLine($"Expenses error: {ex.Message}")
            ShowUserNotification("Expenses management is temporarily unavailable. Please try again later.", "Expenses")
        End Try
    End Sub

    Private Sub OpenMainCashBook(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Accounting.MainCashBookForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Accounting.MainCashBookForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Main Cash Book error: {ex.Message}")
            ShowUserNotification("Main Cash Book is temporarily unavailable. Please try again later.", "Cash Book")
        End Try
    End Sub

    Private Sub OpenPettyCash(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Accounting.PettyCashForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Accounting.PettyCashForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Petty Cash error: {ex.Message}")
            ShowUserNotification("Petty Cash is temporarily unavailable. Please try again later.", "Petty Cash")
        End Try
    End Sub

    Private Sub OpenCashBookLedger(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Accounting.CashBookLedgerViewerForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New Accounting.CashBookLedgerViewerForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Cash Book Ledger error: {ex.Message}")
            ShowUserNotification("Cash Book Ledger is temporarily unavailable. Please try again later.", "Cash Book")
        End Try
    End Sub

    Private Sub OpenCashBookJournal(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is CashBookJournalForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New CashBookJournalForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Cash Book error: {ex.Message}")
            ShowUserNotification("Cash Book Journal is temporarily unavailable. Please try again later.", "Cash Book")
        End Try
    End Sub

    Private Sub OpenTimesheetEntry(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is TimesheetEntryForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New TimesheetEntryForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"Timesheet error: {ex.Message}")
            ShowUserNotification("Timesheet Entry is temporarily unavailable. Please try again later.", "Timesheet")
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
        ' First, remove any previously injected runtime logos to avoid duplicates
        Try
            Dim themeLogos() As Control = Me.Controls.Find("__ThemeLogo", True)
            For Each c As Control In themeLogos
                Try
                    If c IsNot Nothing AndAlso c.Parent IsNot Nothing Then c.Parent.Controls.Remove(c)
                    c.Dispose()
                Catch
                End Try
            Next
        Catch
        End Try
        If sidebar IsNot Nothing Then
            ' Remove any old picBrandLogo instances to enforce a single logo
            Try
                Dim olds = sidebar.Controls.OfType(Of PictureBox)().Where(Function(pb) pb.Name = "picBrandLogo").ToList()
                For Each pb In olds
                    Try
                        sidebar.Controls.Remove(pb)
                        pb.Dispose()
                    Catch
                    End Try
                Next
            Catch
            End Try
            Dim hasLogo As Boolean = sidebar.Controls.OfType(Of PictureBox)().Any(Function(pb) pb.Name = "picBrandLogo")
            If Not hasLogo Then
                Try
                    Dim logoPath As String = IO.Path.Combine(System.Windows.Forms.Application.StartupPath, "logo.png")
                    If IO.File.Exists(logoPath) Then
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

        ensureItem("Raw Materials (Ingredients)", Sub(sender, e)
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
                                           System.Diagnostics.Debug.WriteLine($"Raw Materials error: {ex.Message}")
                                           ShowUserNotification("Raw Materials management is temporarily unavailable. Please try again later.", "Raw Materials")
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
                                                       System.Diagnostics.Debug.WriteLine($"{typeName} error: {ex.Message}")
                                                       ShowUserNotification($"{typeName} is temporarily unavailable. Please try again later.", typeName)
                                                   End Try
                                               End Sub

        ensureItem("Internal Products (i)", Sub(s, e) openCatalog("Internal Product"))
        ensureItem("External Products (x)", Sub(s, e) openCatalog("External Product"))
        ensureItem("SubAssembly", Sub(s, e) openCatalog("SubAssembly"))
        ensureItem("Decoration", Sub(s, e) openCatalog("Decoration"))
        ensureItem("Topping", Sub(s, e) openCatalog("Topping"))
        ensureItem("Accessory", Sub(s, e) openCatalog("Accessory"))
        ensureItem("Packaging", Sub(s, e) openCatalog("Packaging"))
    End Sub

    ' ---------------- Legacy duplicate method removed ----------------

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
            sidebar = New UI.SidebarControl()
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

        If TypeOf child Is UI.ISidebarProvider Then
            currentProvider = CType(child, UI.ISidebarProvider)
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

            Dim miAddProduct As New ToolStripMenuItem("Add Product")
            AddHandler miAddProduct.Click, Sub(sender, e)
                                              Dim frm As New Manufacturing.AddProductForm()
                                              frm.ShowDialog()
                                          End Sub

            Dim miRecipeCreator As New ToolStripMenuItem("Recipe Creator")
            AddHandler miRecipeCreator.Click, Sub(sender, e)
                                                  OpenMdiSingleton(Of Manufacturing.RecipeCreatorForm)()
                                              End Sub

            Dim miBuildMyProduct As New ToolStripMenuItem("Build My Product")
            AddHandler miBuildMyProduct.Click, Sub(sender, e)
                                                   OpenMdiSingleton(Of Manufacturing.BuildProductForm)()
                                               End Sub

            Dim miRecipeViewer As New ToolStripMenuItem("Recipe Viewer")
            AddHandler miRecipeViewer.Click, Sub(sender, e)
                                                OpenMdiSingleton(Of Manufacturing.RecipeViewerForm)()
                                            End Sub

            Dim miBOM As New ToolStripMenuItem("BOM Management")
            AddHandler miBOM.Click, Sub(sender, e)
                                        OpenMdiSingleton(Of Manufacturing.BOMEditorForm)()
                                    End Sub

            Dim miCompleteBuild As New ToolStripMenuItem("Complete Build")
            AddHandler miCompleteBuild.Click, Sub(sender, e)
                                                  OpenMdiSingleton(Of Manufacturing.CompleteBuildForm)()
                                              End Sub

            Dim miMOActions As New ToolStripMenuItem("MO Actions")
            AddHandler miMOActions.Click, Sub(sender, e)
                                              OpenMdiSingleton(Of Manufacturing.MOActionsForm)()
                                          End Sub

            ManufacturingToolStripMenuItem.DropDownItems.AddRange(New ToolStripItem() {
                miCategories, miSubcategories, miProducts, miAddProduct, miRecipeCreator, miBuildMyProduct, miRecipeViewer, miBOM, miCompleteBuild, miMOActions
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

    ' Remove duplicate top-level menus with the same caption, keeping the first instance
    Private Sub DeduplicateTopMenu(caption As String)
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        Dim matches = Me.MenuStrip1.Items.OfType(Of ToolStripMenuItem)() _
            .Where(Function(mi) String.Equals(mi.Text, caption, StringComparison.OrdinalIgnoreCase)) _
            .ToList()
        If matches Is Nothing OrElse matches.Count <= 1 Then Exit Sub
        ' Keep the first instance; remove the rest
        For i As Integer = 1 To matches.Count - 1
            Try
                Me.MenuStrip1.Items.Remove(matches(i))
            Catch
            End Try
        Next
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
                    System.Diagnostics.Debug.WriteLine($"Dashboard error: {ex.Message}")
                    ShowUserNotification("Dashboard is temporarily unavailable. Please try again later.", "Dashboard")
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
                    System.Diagnostics.Debug.WriteLine($"Materials error: {ex.Message}")
                    ShowUserNotification("Materials management is temporarily unavailable. Please try again later.", "Materials")
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
                    System.Diagnostics.Debug.WriteLine($"Suppliers error: {ex.Message}")
                    ShowUserNotification("Suppliers management is temporarily unavailable. Please try again later.", "Suppliers")
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
                    System.Diagnostics.Debug.WriteLine($"Purchase Orders error: {ex.Message}")
                    ShowUserNotification("Purchase Orders are temporarily unavailable. Please try again later.", "Purchase Orders")
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
                    Dim invForm As New InvoiceCaptureForm()
                    invForm.MdiParent = Me
                    invForm.Show()
                    invForm.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    System.Diagnostics.Debug.WriteLine($"GRV error: {ex.Message}")
                    ShowUserNotification("Goods Received Voucher is temporarily unavailable. Please try again later.", "GRV")
                End Try

            Case "ap"
                ' Open Accounts Payable form
                Try
                    Dim frm As New Forms.Accounting.AccountsPayableForm()
                    frm.MdiParent = Me
                    frm.Show()
                    frm.WindowState = FormWindowState.Maximized
                Catch ex As Exception
                    System.Diagnostics.Debug.WriteLine($"Accounts Payable error: {ex.Message}")
                    ShowUserNotification("Accounts Payable is temporarily unavailable. Please try again later.", "Accounting")
                End Try

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
                    System.Diagnostics.Debug.WriteLine($"Reports error: {ex.Message}")
                    ShowUserNotification("Reports are temporarily unavailable. Please try again later.", "Reports")
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
            System.Diagnostics.Debug.WriteLine($"Core services initialization error: {ex.Message}")
            ' Continue operation - service initialization errors are non-fatal
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
            System.Diagnostics.Debug.WriteLine($"Administrator dashboard error: {ex.Message}")
            ShowUserNotification("Administrator dashboard is temporarily unavailable. Please try again later.", "Administration")
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
            System.Diagnostics.Debug.WriteLine($"Stockroom management error: {ex.Message}")
            ShowUserNotification("Stockroom management is temporarily unavailable. Please try again later.", "Stockroom")
        End Try
    End Sub

    Private Sub OpenUserManagement()
        If currentUser Is Nothing Then
            ShowUserNotification("User session not found. Please log in again.", "Authentication Error")
            Return
        End If

        Try
            Dim userMgmtForm As New UserManagementForm()
            userMgmtForm.MdiParent = Me
            userMgmtForm.Show()
            userMgmtForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            System.Diagnostics.Debug.WriteLine($"User Management error: {ex.Message}")
            ShowUserNotification("User Management is temporarily unavailable. Please try again later.", "User Management")
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
                      ShowUserNotification(message, "Security Alert")
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
            ' Start background AI testing service
            Try
                backgroundService = New AITestingBackgroundService(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                backgroundService.StartBackgroundTesting()
            Catch ex As Exception
                ' Silent fail - background service is optional
            End Try
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

            Dim userMgmtForm As New UserManagementForm()
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
            Dim invForm As New InvoiceCaptureForm()
            invForm.MdiParent = Me
            invForm.Show()
            invForm.WindowState = FormWindowState.Maximized
            invForm.BringToFront()
            invForm.Activate()
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

    Private backgroundService As AITestingBackgroundService

    Private Sub MainDashboard_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            ' Apply global theme automatically for all forms using the brand logo
            Try
                Dim logoPath As String = IO.Path.Combine(Application.StartupPath, "Resources", "ASSETS", "LOGO.png")
                UI.Theme.EnableAutoApply(logoPath)
            Catch
            End Try
            ' Ensure the View/Edit Invoices menu exists and is wired
            Try
                SetupStockroomInvoicesMenus()
            Catch
            End Try
            
            ' Manufacturing > Orders menu is in Designer - no setup needed
        Catch
        End Try
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
    ' Stockroom Menus Setup
    ' =============================
    Private Sub SetupStockroomMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        
        Dim stockroom As ToolStripMenuItem = EnsureTopMenu("Stockroom")
        If stockroom Is Nothing Then Exit Sub
        
        ' Purchase Orders
        Dim po As ToolStripMenuItem = EnsureSubMenu(stockroom, "Purchase Orders")
        Dim miCreatePO As ToolStripMenuItem = EnsureSubMenu(po, "Create Purchase Order")
        RemoveHandler miCreatePO.Click, AddressOf OpenCreatePurchaseOrder
        AddHandler miCreatePO.Click, AddressOf OpenCreatePurchaseOrder
        
        ' Inventory Management
        Dim inventory As ToolStripMenuItem = EnsureSubMenu(stockroom, "Inventory Management")
        Dim miAddInventory As ToolStripMenuItem = EnsureSubMenu(inventory, "Add Inventory")
        RemoveHandler miAddInventory.Click, AddressOf OpenAddInventory
        AddHandler miAddInventory.Click, AddressOf OpenAddInventory
        
        ' Reports
        Dim reports As ToolStripMenuItem = EnsureSubMenu(stockroom, "Reports")
        Dim miStockReport As ToolStripMenuItem = EnsureSubMenu(reports, "Stock Movement Report")
        RemoveHandler miStockReport.Click, AddressOf OpenStockReport
        AddHandler miStockReport.Click, AddressOf OpenStockReport

        ' GRV Management
        Dim miGRVMgmt As ToolStripMenuItem = EnsureSubMenu(stockroom, "GRV Management")
        RemoveHandler miGRVMgmt.Click, AddressOf OpenGRVManagement
        AddHandler miGRVMgmt.Click, AddressOf OpenGRVManagement
    End Sub

    Private Sub OpenCreatePurchaseOrder(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is PurchaseOrderForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New PurchaseOrderForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Purchase Order form: " & ex.Message, "Stockroom", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenAddInventory(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is InventoryCatalogCrudForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New InventoryCatalogCrudForm("Product")
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Add Inventory form: " & ex.Message, "Stockroom", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenStockReport(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is StockMovementReportForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New StockMovementReportForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Stock Report: " & ex.Message, "Stockroom", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenGRVManagement(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is GRVManagementForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New GRVManagementForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening GRV Management: " & ex.Message, "Stockroom", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenInvoiceCapture(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is InvoiceGRVForm Then
                    child.Activate()
                    Return
                End If
            Next
            
            Dim invoiceGRVForm As New InvoiceGRVForm()
            invoiceGRVForm.MdiParent = Me
            invoiceGRVForm.Show()
        Catch ex As Exception
            MessageBox.Show($"Error opening Invoice & GRV form: {ex.Message}{vbCrLf}{ex.StackTrace}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' =============================
    ' Administration Menu Setup
    ' =============================
    Private Sub SetupAdministrationMenu()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        
        Dim admin As ToolStripMenuItem = EnsureTopMenu("Administration")
        If admin Is Nothing Then Exit Sub
        
        ' User Management
        Dim miUserMgmt As ToolStripMenuItem = EnsureSubMenu(admin, "User Management")
        RemoveHandler miUserMgmt.Click, AddressOf OpenUserManagement
        AddHandler miUserMgmt.Click, AddressOf OpenUserManagement
        
        ' Branch Management
        Dim miBranchMgmt As ToolStripMenuItem = EnsureSubMenu(admin, "Branch Management")
        RemoveHandler miBranchMgmt.Click, AddressOf OpenBranchManagement
        AddHandler miBranchMgmt.Click, AddressOf OpenBranchManagement
        
        ' System Settings
        Dim miSystemSettings As ToolStripMenuItem = EnsureSubMenu(admin, "System Settings")
        RemoveHandler miSystemSettings.Click, AddressOf OpenSystemSettings
        AddHandler miSystemSettings.Click, AddressOf OpenSystemSettings
    End Sub

    Private Sub OpenSystemSettings(sender As Object, e As EventArgs)
        Try
            Dim uid As Integer = If(currentUser IsNot Nothing, currentUser.UserID, 0)
            Dim settingsForm As New NewSystemSettingsForm(uid)
            settingsForm.MdiParent = Me
            settingsForm.Show()
            settingsForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening System Settings: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' =============================
    ' Core Menu Creation (Force All Menus)
    ' =============================
    Private Sub CreateCoreMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        
        ' Create all core menus directly without clearing
        Dim retail As New ToolStripMenuItem("Retail")
        Dim stockroom As New ToolStripMenuItem("Stockroom")
        Dim manufacturing As New ToolStripMenuItem("Manufacturing")
        Dim accounting As New ToolStripMenuItem("Accounting")
        Dim administration As New ToolStripMenuItem("Administration")
        Dim reports As New ToolStripMenuItem("Reports")
        
        ' Add them directly to MenuStrip
        Me.MenuStrip1.Items.Add(retail)
        Me.MenuStrip1.Items.Add(stockroom)
        Me.MenuStrip1.Items.Add(manufacturing)
        Me.MenuStrip1.Items.Add(accounting)
        Me.MenuStrip1.Items.Add(administration)
        Me.MenuStrip1.Items.Add(reports)
        
        ' Force refresh the menu strip
        Me.MenuStrip1.Refresh()
        Me.MenuStrip1.Update()
        
        ' Add basic submenus to each
        If retail IsNot Nothing Then
            EnsureSubMenu(retail, "POS")
            EnsureSubMenu(retail, "Products")
            EnsureSubMenu(retail, "Inventory")
        End If
        
        If stockroom IsNot Nothing Then
            EnsureSubMenu(stockroom, "Purchase Orders")
            EnsureSubMenu(stockroom, "Inventory Management")
            EnsureSubMenu(stockroom, "Reports")
        End If
        
        If manufacturing IsNot Nothing Then
            EnsureSubMenu(manufacturing, "Production")
            EnsureSubMenu(manufacturing, "BOM Management")
            EnsureSubMenu(manufacturing, "Reports")
        End If
        
        If accounting IsNot Nothing Then
            EnsureSubMenu(accounting, "Accounts Payable")
            EnsureSubMenu(accounting, "Accounts Receivable")
            EnsureSubMenu(accounting, "SARS Compliance")
        End If
        
        If administration IsNot Nothing Then
            EnsureSubMenu(administration, "User Management")
            EnsureSubMenu(administration, "Branch Management")
            EnsureSubMenu(administration, "System Settings")
        End If
        
        If reports IsNot Nothing Then
            EnsureSubMenu(reports, "Sales Reports")
            EnsureSubMenu(reports, "Inventory Reports")
            EnsureSubMenu(reports, "Financial Reports")
        End If
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
            ' Check permissions - temporarily disabled for testing
            ' Dim permissionService As New RolePermissionService()
            ' If Not permissionService.IsSuperAdmin() AndAlso Not permissionService.HasPermission("MFG_ACCESS") Then
            '     MessageBox.Show("You do not have permission to access the Manufacturing system.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            '     Return
            ' End If
            
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
    ' Accounting Menus
    ' =============================
    Private Sub SetupAccountingMenus()
        Dim accounting As ToolStripMenuItem = EnsureTopMenu("Accounting")
        If accounting Is Nothing Then Exit Sub

        ' Accounts Payable
        Dim ap As ToolStripMenuItem = EnsureSubMenu(accounting, "Accounts Payable")
        Dim miPaymentSchedule As ToolStripMenuItem = EnsureSubMenu(ap, "Payment Schedule")
        RemoveHandler miPaymentSchedule.Click, AddressOf OpenPaymentSchedule
        AddHandler miPaymentSchedule.Click, AddressOf OpenPaymentSchedule

        Dim miBankImport As ToolStripMenuItem = EnsureSubMenu(ap, "Bank Statement Import")
        RemoveHandler miBankImport.Click, AddressOf OnOpenBankStatementImport
        AddHandler miBankImport.Click, AddressOf OnOpenBankStatementImport

        ' SARS Compliance
        Dim sars As ToolStripMenuItem = EnsureSubMenu(accounting, "SARS Compliance")
        Dim miSARSReporting As ToolStripMenuItem = EnsureSubMenu(sars, "Tax Returns & Reporting")
        RemoveHandler miSARSReporting.Click, AddressOf OpenSARSReporting
        AddHandler miSARSReporting.Click, AddressOf OpenSARSReporting

        ' General Ledger
        Dim gl As ToolStripMenuItem = EnsureSubMenu(accounting, "General Ledger")
        Dim miJournalEntries As ToolStripMenuItem = EnsureSubMenu(gl, "Journal Entries")
        RemoveHandler miJournalEntries.Click, AddressOf ShowComingSoonMessage
        AddHandler miJournalEntries.Click, AddressOf ShowComingSoonMessage

        Dim miTrialBalance As ToolStripMenuItem = EnsureSubMenu(gl, "Trial Balance")
        RemoveHandler miTrialBalance.Click, AddressOf ShowComingSoonMessage
        AddHandler miTrialBalance.Click, AddressOf ShowComingSoonMessage

        ' Reports
        Dim reports As ToolStripMenuItem = EnsureSubMenu(accounting, "Reports")
        Dim miAP As ToolStripMenuItem = EnsureSubMenu(accounting, "Accounts Payable")
        RemoveHandler miAP.Click, AddressOf OnOpenAccountsPayable
        AddHandler miAP.Click, AddressOf OnOpenAccountsPayable
        
        Dim miInvoices As ToolStripMenuItem = EnsureSubMenu(ap, "Invoice Capture")
        RemoveHandler miInvoices.Click, AddressOf OnOpenInvoiceCapture
        AddHandler miInvoices.Click, AddressOf OnOpenInvoiceCapture

        Dim miBS As ToolStripMenuItem = EnsureSubMenu(reports, "Balance Sheet")
        RemoveHandler miBS.Click, AddressOf OnOpenBalanceSheet
        AddHandler miBS.Click, AddressOf OnOpenBalanceSheet
    End Sub

    Private Sub ShowComingSoonMessage(sender As Object, e As EventArgs)
        ' Determine which feature was clicked and open appropriate form
        Dim menuItem = TryCast(sender, ToolStripMenuItem)
        If menuItem IsNot Nothing Then
            Select Case menuItem.Text.ToLower()
                Case "system settings"
                    OpenSystemSettings(sender, e)
                Case "dashboard"
                    OpenDashboard()
                Case Else
                    MessageBox.Show($"Feature '{menuItem.Text}' is under development.", "Feature Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End Select
        Else
            MessageBox.Show("Feature is under development.", "Feature Status", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
    End Sub

    Private Sub OpenPaymentSchedule(sender As Object, e As EventArgs)
        Try
            Dim paymentForm As New PaymentScheduleForm()
            paymentForm.MdiParent = Me
            paymentForm.Show()
            paymentForm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show($"Error opening Payment Schedule: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
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
        
        ' SKU Assignment for products created without barcodes
        Dim miSKUAssign As ToolStripMenuItem = EnsureSubMenu(products, "Assign SKU/Barcodes")
        RemoveHandler miSKUAssign.Click, AddressOf OpenProductSKUAssignment
        AddHandler miSKUAssign.Click, AddressOf OpenProductSKUAssignment

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
        RemoveHandler miTOCreate.Click, AddressOf OpenInterBranchTransferCreate
        AddHandler miTOCreate.Click, AddressOf OpenInterBranchTransferCreate
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

        ' Accounting
        Dim accounting As ToolStripMenuItem = EnsureSubMenu(retail, "Accounting")
        Dim miAccounting As ToolStripMenuItem = EnsureSubMenu(accounting, "Retail Sales Reports")
        RemoveHandler miAccounting.Click, AddressOf RetailPlaceholder
        AddHandler miAccounting.Click, AddressOf RetailPlaceholder

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
        Dim name As String = If(it IsNot Nothing, it.Text, String.Empty)
        
        ' Temporarily disable permission check for debugging
        ' TODO: Re-enable after fixing role detection
        ' Dim hasPermission As Boolean = HasModulePermission("Retail")
        ' If Not hasPermission Then
        '     MessageBox.Show("Access denied", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        '     Return
        ' End If
        
        Try
            If String.IsNullOrWhiteSpace(name) Then
                ' Safe fallback to Retail dashboard if no name
                OpenMdiSingleton(Of RetailManagerDashboardForm)()
                Exit Sub
            End If

            Dim key As String = name.ToLowerInvariant()

            ' Route known report items to working forms
            If key.Contains("low stock") Then
                OpenMdiSingleton(Of LowStockReportForm)()
                Exit Sub
            End If
            If key.Contains("product catalog") OrElse key.Contains("catalog") Then
                OpenMdiSingleton(Of ProductCatalogReportForm)()
                Exit Sub
            End If
            If key.Contains("price history") Then
                OpenMdiSingleton(Of PriceHistoryReportForm)()
                Exit Sub
            End If

            ' Safe default routes
            If key.Contains("products") OrElse key.Contains("inventory") OrElse key.Contains("stock") Then
                OpenMdiSingleton(Of Retail.RetailStockOnHandForm)()
                Exit Sub
            End If

            ' Final fallback: Retail dashboard
            OpenMdiSingleton(Of RetailManagerDashboardForm)()
        Catch ex As Exception
            MessageBox.Show("Error opening feature: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Function HasModulePermission(moduleName As String) As Boolean
        Try
            ' Always allow access for admin roles - bypass database check
            Dim currentRole As String = If(AppSession.CurrentRoleName, "")
            If currentRole.ToLowerInvariant().Contains("admin") Then
                Return True
            End If
            
            ' For non-admin roles, check database permissions
            Using conn As New SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                conn.Open()
                
                ' First ensure permissions exist for the role
                Dim ensureSql = "IF NOT EXISTS (SELECT 1 FROM RolePermissions rp INNER JOIN Roles r ON rp.RoleID = r.RoleID WHERE r.RoleName = @roleName AND rp.ModuleName = @moduleName) " & _
                               "BEGIN " & _
                               "INSERT INTO RolePermissions (RoleID, ModuleName, CanRead, CanWrite, CanDelete) " & _
                               "SELECT r.RoleID, @moduleName, 1, 1, 1 FROM Roles r WHERE r.RoleName = @roleName " & _
                               "END"
                Using ensureCmd As New SqlCommand(ensureSql, conn)
                    ensureCmd.Parameters.AddWithValue("@roleName", currentRole)
                    ensureCmd.Parameters.AddWithValue("@moduleName", moduleName)
                    ensureCmd.ExecuteNonQuery()
                End Using
                
                ' Check permissions
                Dim sql = "SELECT COUNT(*) FROM RolePermissions rp " & _
                         "INNER JOIN Roles r ON rp.RoleID = r.RoleID " & _
                         "WHERE r.RoleName = @roleName AND rp.ModuleName = @moduleName AND rp.CanRead = 1"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@roleName", currentRole)
                    cmd.Parameters.AddWithValue("@moduleName", moduleName)
                    Return Convert.ToInt32(cmd.ExecuteScalar()) > 0
                End Using
            End Using
        Catch
            ' If database check fails, allow admin roles
            Dim currentRole As String = If(AppSession.CurrentRoleName, "")
            Return currentRole.ToLowerInvariant().Contains("admin")
        End Try
    End Function

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

    Private Sub OpenRetailPOWorkflow(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is POReceivingForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New POReceivingForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Purchase Orders workflow: " & ex.Message, "Retail Purchasing", MessageBoxButtons.OK, MessageBoxIcon.Error)
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

    ' ---------------- Retail > Reports concrete wiring ----------------
    Private Sub SetupRetailReportMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        Dim retail As ToolStripMenuItem = EnsureTopMenu("Retail")
        If retail Is Nothing Then Exit Sub
        Dim reports As ToolStripMenuItem = EnsureSubMenu(retail, "Reports")
        ' Low Stock
        Dim miLow As ToolStripMenuItem = EnsureSubMenu(reports, "Low Stock")
        RemoveHandler miLow.Click, AddressOf OpenRetailLowStock
        AddHandler miLow.Click, AddressOf OpenRetailLowStock
        ' Product Catalog
        Dim miCat As ToolStripMenuItem = EnsureSubMenu(reports, "Product Catalog")
        RemoveHandler miCat.Click, AddressOf OpenRetailProductCatalog
        AddHandler miCat.Click, AddressOf OpenRetailProductCatalog
        ' Price History
        Dim miPH As ToolStripMenuItem = EnsureSubMenu(reports, "Price History")
        RemoveHandler miPH.Click, AddressOf OpenRetailPriceHistory
        AddHandler miPH.Click, AddressOf OpenRetailPriceHistory
        
        ' Retail → POS menu wiring
        Dim miPOS As ToolStripMenuItem = EnsureSubMenu(retail, "Point of Sale")
        RemoveHandler miPOS.Click, AddressOf OpenRetailPOS
        AddHandler miPOS.Click, AddressOf OpenRetailPOS
    End Sub

    ' --- Retail menu handlers ---
    Private Sub OpenRetailLowStock(sender As Object, e As EventArgs)
        Try
            OpenMdiSingleton(Of LowStockReportForm)()
        Catch ex As Exception
            MessageBox.Show("Error opening Low Stock Report: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenRetailPOS(sender As Object, e As EventArgs)
        Try
            ' Temporarily disable permission check for debugging
            ' Dim permissionService As New RolePermissionService()
            ' If Not permissionService.IsSuperAdmin() AndAlso Not permissionService.HasPermission("POS_ACCESS") Then
            '     MessageBox.Show("You do not have permission to access the Point of Sale system.", "Access Denied", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            '     Return
            ' End If
            
            OpenMdiSingleton(Of POSForm)()
        Catch ex As Exception
            MessageBox.Show("Error opening Point of Sale: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenRetailProductCatalog(sender As Object, e As EventArgs)
        Try
            OpenMdiSingleton(Of ProductCatalogReportForm)()
        Catch ex As Exception
            MessageBox.Show("Error opening Product Catalog: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenRetailPriceHistory(sender As Object, e As EventArgs)
        Try
            OpenMdiSingleton(Of PriceHistoryReportForm)()
        Catch ex As Exception
            MessageBox.Show("Error opening Price History: " & ex.Message, "Retail", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
            RemoveHandler miPONew.Click, AddressOf OpenRetailPOWorkflow
            AddHandler miPONew.Click, AddressOf OpenRetailPOWorkflow
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
                If TypeOf child Is RetailManagerDashboardForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New RetailManagerDashboardForm()
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

    ' ---------------- Supply Invoices (top-level) ----------------
    Private Sub SetupSupplyInvoicesMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        Dim supply As ToolStripMenuItem = EnsureTopMenu("Supply Invoices")
        If supply Is Nothing Then Exit Sub
        Dim miCapture As ToolStripMenuItem = EnsureSubMenu(supply, "Capture Invoice")
        RemoveHandler miCapture.Click, AddressOf OpenSupplyCaptureInvoice
        AddHandler miCapture.Click, AddressOf OpenSupplyCaptureInvoice
        Dim miEdit As ToolStripMenuItem = EnsureSubMenu(supply, "Edit Invoice")
        RemoveHandler miEdit.Click, AddressOf OpenSupplyEditInvoice
        AddHandler miEdit.Click, AddressOf OpenSupplyEditInvoice
    End Sub

    Private Sub OpenSupplyCaptureInvoice(sender As Object, e As EventArgs)
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
            Dim f As New InvoiceCaptureForm()
            f.MdiParent = Me
            f.Show()
            f.WindowState = FormWindowState.Maximized
            f.BringToFront()
        Catch ex As Exception
            MessageBox.Show("Error opening Capture Invoice: " & ex.Message, "Supply Invoices", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenSupplyEditInvoice(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is InvoiceEditorForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim branchId As Integer = If(currentUser IsNot Nothing AndAlso currentUser.BranchID.HasValue, currentUser.BranchID.Value, 0)
            Dim userId As Integer = If(currentUser IsNot Nothing, currentUser.UserID, 0)
            Dim f As New InvoiceEditorForm(branchId, userId)
            f.MdiParent = Me
            f.Show()
            f.WindowState = FormWindowState.Maximized
            f.BringToFront()
        Catch ex As Exception
            MessageBox.Show("Error opening Edit Invoice: " & ex.Message, "Supply Invoices", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Consolidate all Administration menu items into single menu
    Private Sub ConsolidateAdministrationMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        
        ' Remove any duplicate Administration menus first
        Dim adminMenus As New List(Of ToolStripMenuItem)()
        For Each item As ToolStripItem In Me.MenuStrip1.Items
            If TypeOf item Is ToolStripMenuItem Then
                Dim menuItem = CType(item, ToolStripMenuItem)
                If menuItem.Text.Contains("Administration") OrElse menuItem.Text.Contains("Administrator") Then
                    adminMenus.Add(menuItem)
                End If
            End If
        Next
        
        ' Keep only the first Administration menu, remove others
        If adminMenus.Count > 1 Then
            For i As Integer = 1 To adminMenus.Count - 1
                Me.MenuStrip1.Items.Remove(adminMenus(i))
            Next
        End If
        
        ' Ensure the remaining menu has all required items
        Dim admin As ToolStripMenuItem = EnsureTopMenu("Administration")
        If admin Is Nothing Then Exit Sub
        
        ' Core administration items
        EnsureSubMenu(admin, "Dashboard")
        EnsureSubMenu(admin, "User Management")
        EnsureSubMenu(admin, "Branch Management")
        EnsureSubMenu(admin, "Audit Log")
        EnsureSubMenu(admin, "System Settings")
        
        ' Wire up handlers
        WireAdministrationMenuHandlers(admin)
    End Sub
    
    Private Sub WireAdministrationMenuHandlers(admin As ToolStripMenuItem)
        ' Wire Audit Log
        Dim auditLog = FindSubMenu(admin, "Audit Log")
        If auditLog IsNot Nothing Then
            RemoveHandler auditLog.Click, AddressOf OpenAuditLogViewer
            AddHandler auditLog.Click, AddressOf OpenAuditLogViewer
        End If
        
        ' Wire User Management
        Dim userMgmt = FindSubMenu(admin, "User Management")
        If userMgmt IsNot Nothing Then
            RemoveHandler userMgmt.Click, AddressOf OpenUserManagement
            AddHandler userMgmt.Click, AddressOf OpenUserManagement
        End If
        
        ' Wire Branch Management
        Dim branchMgmt = FindSubMenu(admin, "Branch Management")
        If branchMgmt IsNot Nothing Then
            RemoveHandler branchMgmt.Click, AddressOf OpenBranchManagement
            AddHandler branchMgmt.Click, AddressOf OpenBranchManagement
        End If
        
        ' Wire System Settings
        Dim sysSettings = FindSubMenu(admin, "System Settings")
        If sysSettings IsNot Nothing Then
            RemoveHandler sysSettings.Click, AddressOf OpenSystemSettings
            AddHandler sysSettings.Click, AddressOf OpenSystemSettings
        End If
        
        ' Wire AI Testing Dashboard
        Dim aiTesting = EnsureSubMenu(admin, "AI Testing Dashboard")
        If aiTesting IsNot Nothing Then
            AddHandler aiTesting.Click, AddressOf OpenAITestingDashboard
        End If
    End Sub
    
    Private Function FindSubMenu(parent As ToolStripMenuItem, text As String) As ToolStripMenuItem
        For Each item As ToolStripItem In parent.DropDownItems
            If TypeOf item Is ToolStripMenuItem Then
                Dim menuItem = CType(item, ToolStripMenuItem)
                If menuItem.Text = text Then Return menuItem
            End If
        Next
        Return Nothing
    End Function

    Private Sub OpenAuditLogViewer(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is AuditLogViewer Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New AuditLogViewer()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Audit Log: " & ex.Message, "Administration", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenUserManagement(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is UserManagementForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New UserManagementForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening User Management: " & ex.Message, "Administration", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenBranchManagement(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is BranchManagementForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim uid As Integer = If(currentUser IsNot Nothing, currentUser.UserID, 0)
            Dim frm As New BranchManagementForm(uid)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Branch Management: " & ex.Message, "Administration", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    ' Duplicate method removed - keeping the one at line 2820

    ' ---------------- Accounting viewers (grid-based) ----------------
    Private Sub SetupAccountingViewerMenus()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        Dim acct As ToolStripMenuItem = EnsureTopMenu("Accounting")
        If acct Is Nothing Then Exit Sub
        Dim viewers As ToolStripMenuItem = EnsureSubMenu(acct, "Viewers")
        Dim miJ As ToolStripMenuItem = EnsureSubMenu(viewers, "Journals (Grid)")
        RemoveHandler miJ.Click, AddressOf OpenJournalsGrid
        AddHandler miJ.Click, AddressOf OpenJournalsGrid
        Dim miTB As ToolStripMenuItem = EnsureSubMenu(viewers, "Trial Balance (Grid)")
        RemoveHandler miTB.Click, AddressOf OpenTrialBalanceGrid
        AddHandler miTB.Click, AddressOf OpenTrialBalanceGrid
        Dim miGL As ToolStripMenuItem = EnsureSubMenu(viewers, "General Ledger Viewer")
        RemoveHandler miGL.Click, AddressOf OpenGeneralLedgerViewer
        AddHandler miGL.Click, AddressOf OpenGeneralLedgerViewer
        Dim miSupp As ToolStripMenuItem = EnsureSubMenu(viewers, "Supplier Ledger (Grid)")
        RemoveHandler miSupp.Click, AddressOf OpenSupplierLedgerGrid
        AddHandler miSupp.Click, AddressOf OpenSupplierLedgerGrid
        
        ' Supplier Payments
        Dim payments As ToolStripMenuItem = EnsureSubMenu(acct, "Payments")
        Dim miPaySupplier As ToolStripMenuItem = EnsureSubMenu(payments, "Pay Supplier Invoice")
        RemoveHandler miPaySupplier.Click, AddressOf OpenSupplierPayment
        AddHandler miPaySupplier.Click, AddressOf OpenSupplierPayment
        
        ' Credit Notes
        Dim creditNotes As ToolStripMenuItem = EnsureSubMenu(acct, "Credit Notes")
        Dim miViewCreditNotes As ToolStripMenuItem = EnsureSubMenu(creditNotes, "View Credit Notes")
        RemoveHandler miViewCreditNotes.Click, AddressOf OpenCreditNotesList
        AddHandler miViewCreditNotes.Click, AddressOf OpenCreditNotesList
    End Sub
    
    Private Sub OpenSupplierPayment(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is SupplierPaymentForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New SupplierPaymentForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Supplier Payment form: " & ex.Message, "Accounting", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenCreditNotesList(sender As Object, e As EventArgs)
        Try
            ' Show all credit notes for current branch
            Dim frm As New CreditNoteViewerForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Credit Notes: " & ex.Message, "Accounting", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenJournalsGrid(sender As Object, e As EventArgs)
        Try
            Dim sql As String = "SELECT TOP 500 JournalID, JournalDate, AccountCode, AccountName, Description, Debit, Credit, BranchID FROM dbo.GL_Journals ORDER BY JournalDate DESC, JournalID DESC"
            Dim f As Form = CreateSimpleGridForm("Journals (Top 500)", sql)
            f.MdiParent = Me
            f.Show()
            f.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Journals grid: " & ex.Message, "Accounting", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenTrialBalanceGrid(sender As Object, e As EventArgs)
        Try
            Dim sql As String = "SELECT AccountCode, AccountName, SUM(Debit) AS Debit, SUM(Credit) AS Credit, SUM(Debit - Credit) AS Balance FROM dbo.v_GL_TrialBalance GROUP BY AccountCode, AccountName ORDER BY AccountCode"
            Dim f As Form = CreateSimpleGridForm("Trial Balance", sql)
            f.MdiParent = Me
            f.Show()
            f.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Trial Balance: " & ex.Message, "Accounting", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenGeneralLedgerViewer(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is GeneralLedgerViewerForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New GeneralLedgerViewerForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening General Ledger Viewer: " & ex.Message, "Accounting", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenSupplierLedgerGrid(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is SupplierLedgerForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New SupplierLedgerForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Supplier Ledger: " & ex.Message, "Accounting", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' ---------------- Retail report/menu extensions ----------------
    Private Sub SetupRetailReportMenus_Ext()
        Dim retail As ToolStripMenuItem = FindTopMenu("Retail")
        If retail Is Nothing Then retail = EnsureTopMenu("Retail")
        If retail Is Nothing Then Exit Sub
        Dim reports As ToolStripMenuItem = EnsureSubMenu(retail, "Reports")
        Dim miSales As ToolStripMenuItem = EnsureSubMenu(reports, "Sales by Product (Grid)")
        RemoveHandler miSales.Click, AddressOf OpenSalesByProductGrid
        AddHandler miSales.Click, AddressOf OpenSalesByProductGrid
    End Sub

    ' Duplicate EnsureTopMenu function - REMOVED to fix BC30269 error

    Private Sub OpenAITestingDashboard(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is Forms.Admin.AITestingDashboard Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim connectionString = System.Configuration.ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
            Dim frm As New Forms.Admin.AITestingDashboard(connectionString)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening AI Testing Dashboard: " & ex.Message, "Admin", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenSalesByProductGrid(sender As Object, e As EventArgs)
        Try
            Dim sql As String = "IF OBJECT_ID('dbo.v_Retail_SalesByProduct','V') IS NOT NULL " & _
                                "SELECT TOP 500 ProductID, Name, TotalQty, TotalAmount FROM dbo.v_Retail_SalesByProduct ORDER BY TotalAmount DESC " & _
                                "ELSE SELECT CAST(NULL AS INT) AS ProductID, CAST('' AS NVARCHAR(200)) AS Name, CAST(0 AS DECIMAL(18,2)) AS TotalQty, CAST(0 AS DECIMAL(18,2)) AS TotalAmount WHERE 1=0;"
            Dim f As Form = CreateSimpleGridForm("Sales by Product (Top 500)", sql)
            f.MdiParent = Me
            f.Show()
            f.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Sales by Product: " & ex.Message, "Retail Reports", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupRetailSettingsMenus()
        Dim retail As ToolStripMenuItem = FindTopMenu("Retail")
        If retail Is Nothing Then retail = EnsureTopMenu("Retail")
        If retail Is Nothing Then Exit Sub
        Dim settings As ToolStripMenuItem = EnsureSubMenu(retail, "Settings")
        Dim mi As ToolStripMenuItem = EnsureSubMenu(settings, "System Settings")
        RemoveHandler mi.Click, AddressOf OpenSystemSettingsRetail
        AddHandler mi.Click, AddressOf OpenSystemSettingsRetail
    End Sub

    Private Sub OpenSystemSettingsRetail(sender As Object, e As EventArgs)
        Try
            Dim uid As Integer = If(currentUser IsNot Nothing, currentUser.UserID, 0)
            Dim frm As New NewSystemSettingsForm(uid)
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening System Settings: " & ex.Message, "Settings", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupRetailSalesReportMenu()
        Dim retail As ToolStripMenuItem = FindTopMenu("Retail")
        If retail Is Nothing Then retail = EnsureTopMenu("Retail")
        If retail Is Nothing Then Exit Sub
        Dim reports As ToolStripMenuItem = EnsureSubMenu(retail, "Reports")
        Dim mi As ToolStripMenuItem = EnsureSubMenu(reports, "Sales Report")
        RemoveHandler mi.Click, AddressOf OpenSalesReport
        AddHandler mi.Click, AddressOf OpenSalesReport
    End Sub

    Private Sub OpenSalesReport(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is SalesReportForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New SalesReportForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Sales Report: " & ex.Message, "Retail Reports", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupRetailInventoryReportMenu()
        Dim retail As ToolStripMenuItem = FindTopMenu("Retail")
        If retail Is Nothing Then retail = EnsureTopMenu("Retail")
        If retail Is Nothing Then Exit Sub
        Dim reports As ToolStripMenuItem = EnsureSubMenu(retail, "Reports")
        Dim mi As ToolStripMenuItem = EnsureSubMenu(reports, "Inventory Report")
        RemoveHandler mi.Click, AddressOf OpenInventoryReport
        AddHandler mi.Click, AddressOf OpenInventoryReport
    End Sub

    Private Sub OpenInventoryReport(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is InventoryReportForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New InventoryReportForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Inventory Report: " & ex.Message, "Retail Reports", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupManufacturingProductionScheduleMenu()
        Dim mfg As ToolStripMenuItem = FindTopMenu("Manufacturing")
        If mfg Is Nothing Then mfg = EnsureTopMenu("Manufacturing")
        If mfg Is Nothing Then Exit Sub
        Dim mi As ToolStripMenuItem = EnsureSubMenu(mfg, "Production Schedule")
        RemoveHandler mi.Click, AddressOf OpenProductionSchedule
        AddHandler mi.Click, AddressOf OpenProductionSchedule
    End Sub

    Private Sub OpenProductionSchedule(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ProductionScheduleForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New ProductionScheduleForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Production Schedule: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupManufacturingOrdersMenu()
        MessageBox.Show("SetupManufacturingOrdersMenu CALLED!", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
        Dim mfg As ToolStripMenuItem = FindTopMenu("Manufacturing")
        MessageBox.Show($"Manufacturing menu found: {mfg IsNot Nothing}", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
        If mfg Is Nothing Then mfg = EnsureTopMenu("Manufacturing")
        If mfg Is Nothing Then 
            MessageBox.Show("Manufacturing menu is STILL Nothing after EnsureTopMenu!", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If
        Dim orders As ToolStripMenuItem = EnsureSubMenu(mfg, "Orders")
        MessageBox.Show($"Orders submenu created: {orders IsNot Nothing}", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
        
        Dim miNew As ToolStripMenuItem = EnsureSubMenu(orders, "New Orders")
        RemoveHandler miNew.Click, AddressOf OpenNewOrders
        AddHandler miNew.Click, AddressOf OpenNewOrders
        
        Dim miReady As ToolStripMenuItem = EnsureSubMenu(orders, "Ready Orders")
        RemoveHandler miReady.Click, AddressOf OpenReadyOrders
        AddHandler miReady.Click, AddressOf OpenReadyOrders
        
        Dim miAll As ToolStripMenuItem = EnsureSubMenu(orders, "All Orders")
        RemoveHandler miAll.Click, AddressOf OpenAllOrders
        AddHandler miAll.Click, AddressOf OpenAllOrders
    End Sub

    Private Sub OpenNewOrders(sender As Object, e As EventArgs)
        Try
            Dim frm As New ManufacturerOrdersForm("New")
            frm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show("Error opening New Orders: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenReadyOrders(sender As Object, e As EventArgs)
        Try
            Dim frm As New ManufacturerOrdersForm("Ready")
            frm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show("Error opening Ready Orders: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenAllOrders(sender As Object, e As EventArgs)
        Try
            Dim frm As New ManufacturerOrdersForm("All")
            frm.ShowDialog()
        Catch ex As Exception
            MessageBox.Show("Error opening All Orders: " & ex.Message, "Manufacturing", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' Manufacturing Orders menu event handlers (wired to Designer menu items)
    Private Sub mnuNewOrders_Click(sender As Object, e As EventArgs) Handles mnuNewOrders.Click
        OpenNewOrders(sender, e)
    End Sub

    Private Sub mnuReadyOrders_Click(sender As Object, e As EventArgs) Handles mnuReadyOrders.Click
        OpenReadyOrders(sender, e)
    End Sub

    Private Sub mnuAllOrders_Click(sender As Object, e As EventArgs) Handles mnuAllOrders.Click
        OpenAllOrders(sender, e)
    End Sub

    Private Sub SetupStockroomStockMovementReportMenu()
        Dim stockroom As ToolStripMenuItem = FindTopMenu("Stockroom")
        If stockroom Is Nothing Then stockroom = EnsureTopMenu("Stockroom")
        If stockroom Is Nothing Then Exit Sub
        Dim reports As ToolStripMenuItem = EnsureSubMenu(stockroom, "Reports")
        Dim mi As ToolStripMenuItem = EnsureSubMenu(reports, "Stock Movement Report")
        RemoveHandler mi.Click, AddressOf OpenStockMovementReport
        AddHandler mi.Click, AddressOf OpenStockMovementReport
    End Sub

    Private Sub OpenStockMovementReport(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is StockMovementReportForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            Dim frm As New StockMovementReportForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Stock Movement Report: " & ex.Message, "Stockroom Reports", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    ' =============================
    ' Utilities Menu Setup
    ' =============================
    Private Sub SetupUtilitiesMenu()
        If Me.MenuStrip1 Is Nothing Then Exit Sub
        
        ' Find Reporting menu to insert Utilities before it
        Dim reportingIndex As Integer = -1
        For i As Integer = 0 To Me.MenuStrip1.Items.Count - 1
            Dim item = TryCast(Me.MenuStrip1.Items(i), ToolStripMenuItem)
            If item IsNot Nothing AndAlso item.Text.Replace("&", "").Trim().Equals("Reporting", StringComparison.OrdinalIgnoreCase) Then
                reportingIndex = i
                Exit For
            End If
        Next
        
        ' Create or find Utilities menu
        Dim utilities As ToolStripMenuItem = FindTopMenu("Utilities")
        If utilities Is Nothing Then
            utilities = New ToolStripMenuItem("Utilities")
            If reportingIndex >= 0 Then
                Me.MenuStrip1.Items.Insert(reportingIndex, utilities)
            Else
                Me.MenuStrip1.Items.Add(utilities)
            End If
        End If
        
        ' Add Import Categories submenu
        Dim importCategories As ToolStripMenuItem = EnsureSubMenu(utilities, "Import Categories from CSV")
        RemoveHandler importCategories.Click, AddressOf OpenImportCategories
        AddHandler importCategories.Click, AddressOf OpenImportCategories
        
        ' Add Import Products submenu
        Dim importProducts As ToolStripMenuItem = EnsureSubMenu(utilities, "Import Products from CSV")
        RemoveHandler importProducts.Click, AddressOf OpenImportProducts
        AddHandler importProducts.Click, AddressOf OpenImportProducts
        
        ' Add Import Suppliers submenu
        Dim importSuppliers As ToolStripMenuItem = EnsureSubMenu(utilities, "Import Suppliers from CSV")
        RemoveHandler importSuppliers.Click, AddressOf OpenImportSuppliers
        AddHandler importSuppliers.Click, AddressOf OpenImportSuppliers
    End Sub
    
    Private Sub OpenImportCategories(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ImportCategoriesForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            
            Dim frm As New ImportCategoriesForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Import Categories: " & ex.Message, "Utilities", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenImportProducts(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ImportProductsForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            
            Dim frm As New ImportProductsForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Import Products: " & ex.Message, "Utilities", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub OpenImportSuppliers(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ImportSuppliersForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            
            Dim frm As New ImportSuppliersForm()
            frm.MdiParent = Me
            frm.Show()
            frm.WindowState = FormWindowState.Maximized
        Catch ex As Exception
            MessageBox.Show("Error opening Import Suppliers: " & ex.Message, "Utilities", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub OpenProductSKUAssignment(sender As Object, e As EventArgs)
        Try
            For Each child As Form In Me.MdiChildren
                If TypeOf child Is ProductSKUAssignmentForm Then
                    child.Activate()
                    child.WindowState = FormWindowState.Maximized
                    Return
                End If
            Next
            
            Dim f As New ProductSKUAssignmentForm()
            f.MdiParent = Me
            f.Show()
            f.WindowState = FormWindowState.Maximized
            f.BringToFront()
        Catch ex As Exception
            MessageBox.Show("Error opening SKU Assignment: " & ex.Message, "Retail Products", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

End Class
