Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Linq
Imports System.Drawing
Imports System.Drawing.Printing

Namespace Manufacturing

    Public Class BuildProductForm
        Inherits Form

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

        ' Logo colors
        Private ReadOnly ColorPrimary As Color = Color.FromArgb(230, 126, 34)
        Private ReadOnly ColorDark As Color = Color.FromArgb(110, 44, 0)
        Private ReadOnly ColorLight As Color = Color.FromArgb(245, 222, 179)

        Private cmbProduct As ComboBox ' Changed from txtProductName
        Private txtSKU As TextBox
        Private txtProductID As TextBox
        Private cmbCategory As ComboBox
        Private cmbSubcategory As ComboBox
        Private txtRecipeMethod As TextBox ' New: Recipe method textbox

        Private btnAddComponent As Button
        Private btnDone As Button
        Private btnPrint As Button ' New: Print button

        Private treeRecipe As TreeView
        Private pnlCosting As Panel
        Private lblTotalCost As Label
        Private lblMaterialsCost As Label
        Private lblSubAsmCost As Label

        Private _selectedProductId As Integer = 0

        ' Add missing method declaration
        Private Sub SubcategoryDropDownRefresh(sender As Object, e As EventArgs)
            ' Refresh subcategory data when dropdown opens
            If cmbCategory.SelectedValue IsNot Nothing Then
                LoadSubcategories(Convert.ToInt32(cmbCategory.SelectedValue))
            End If
        End Sub

        Public Sub New()
            Me.Text = "Build My Product"
            Me.Width = 1120
            Me.Height = 740
            Me.StartPosition = FormStartPosition.CenterParent
            InitializeUi()
            AddHandler btnAddComponent.Click, AddressOf OnAddComponent
            AddHandler btnDone.Click, AddressOf OnDone
            AddHandler btnPrint.Click, AddressOf OnPrint
            AddHandler Me.Load, AddressOf OnFormLoad
            AddHandler txtSKU.Leave, AddressOf OnCodeLeave
            AddHandler txtSKU.KeyDown, AddressOf OnCodeKeyDown
        End Sub

        ' Load existing hierarchy from RecipeNode into the TreeView (ordered by SortOrder)
        Private Sub LoadHierarchy(productId As Integer)
            Dim dt As New DataTable()
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT NodeID, ParentNodeID, Level, NodeKind, ItemType, ItemName, Qty, UoMID, Notes, SortOrder FROM dbo.RecipeNode WHERE ProductID=@pid ORDER BY ISNULL(ParentNodeID, 0), SortOrder, NodeID", cn)
                    cmd.Parameters.AddWithValue("@pid", productId)
                    dt.Load(cmd.ExecuteReader())
                End Using
            End Using

            treeRecipe.BeginUpdate()
            treeRecipe.Nodes.Clear()

            Dim rowsByParent = dt.AsEnumerable().GroupBy(Function(r) If(r.Field(Of Integer?)("ParentNodeID").HasValue, r.Field(Of Integer?)("ParentNodeID").Value, 0)).ToDictionary(Function(g) g.Key, Function(g) g.OrderBy(Function(r) r.Field(Of Integer)("SortOrder")).ToList())

            ' Build roots (ParentNodeID IS NULL -> key 0)
            If rowsByParent.ContainsKey(0) Then
                For Each row In rowsByParent(0)
                    Dim root As TreeNode = CreateNodeFromRow(row)
                    treeRecipe.Nodes.Add(root)
                    AddChildrenRecursive(root, row.Field(Of Integer)("NodeID"), rowsByParent)
                Next
            End If

            treeRecipe.ExpandAll()
            treeRecipe.EndUpdate()
        End Sub

        Private Sub AddChildrenRecursive(parentNode As TreeNode, parentNodeId As Integer, rowsByParent As Dictionary(Of Integer, List(Of DataRow)))
            If Not rowsByParent.ContainsKey(parentNodeId) Then Return
            For Each row In rowsByParent(parentNodeId)
                Dim child = CreateNodeFromRow(row)
                parentNode.Nodes.Add(child)
                AddChildrenRecursive(child, row.Field(Of Integer)("NodeID"), rowsByParent)
            Next
        End Sub

        Private Function CreateNodeFromRow(row As DataRow) As TreeNode
            Dim kind As String = If(TryCast(row("NodeKind"), String), "Component")
            Dim itemType As String = If(TryCast(row("ItemType"), String), Nothing)
            Dim itemName As String = If(TryCast(row("ItemName"), String), String.Empty)
            Dim qtyObj As Object = row("Qty")
            Dim display As String
            If String.Equals(kind, "Component", StringComparison.OrdinalIgnoreCase) Then
                display = itemName
            Else
                If Not String.IsNullOrWhiteSpace(itemType) Then
                    display = itemType & ": " & itemName
                Else
                    display = itemName
                End If
            End If
            Dim n As New TreeNode(display)
            Dim bag As New Dictionary(Of String, Object)()
            If String.Equals(kind, "Component", StringComparison.OrdinalIgnoreCase) Then
                bag("Type") = "Component"
                bag("Name") = itemName
            Else
                bag("Type") = itemType
                bag("Item") = itemName
                If qtyObj IsNot DBNull.Value Then bag("Qty") = Convert.ToDecimal(qtyObj)
                bag("Notes") = If(row("Notes") Is DBNull.Value, Nothing, CStr(row("Notes")))
            End If
            n.Tag = bag
            Return n
        End Function

        Private Sub InitializeUi()
            ' Header Panel with professional styling
            Dim pnlHeader As New Panel() With {
                .Dock = DockStyle.Top,
                .Height = 80,
                .BackColor = ColorDark
            }

            Dim lblHeader As New Label() With {
                .Text = "✨ Build Product Recipe",
                .Font = New Font("Segoe UI", 18, FontStyle.Bold),
                .ForeColor = Color.White,
                .AutoSize = True,
                .Left = 30,
                .Top = 25
            }

            Dim lblSubHeader As New Label() With {
                .Text = "Create recipe for manufactured products",
                .Font = New Font("Segoe UI", 10),
                .ForeColor = ColorLight,
                .AutoSize = True,
                .Left = 30,
                .Top = 52
            }

            pnlHeader.Controls.AddRange({lblHeader, lblSubHeader})

            ' Split container for tree and recipe method
            Dim splitMain As New SplitContainer() With {
                .Dock = DockStyle.Fill,
                .Orientation = Orientation.Vertical,
                .SplitterDistance = 650
            }

            ' LEFT PANEL: Tree and components
            Dim leftPanel As New Panel() With {.Dock = DockStyle.Fill}

            ' Product selection panel
            Dim pnlProductSelect As New Panel() With {.Dock = DockStyle.Top, .Height = 100, .BackColor = Color.White, .Padding = New Padding(20, 10, 20, 10)}

            Dim x As Integer = 0
            Dim y As Integer = 10

            ' Product Dropdown (changed from textbox)
            Dim lblProduct = New Label() With {
                .Text = "Select Product *",
                .Left = x,
                .Top = y,
                .Width = 150,
                .Font = New Font("Segoe UI", 10, FontStyle.Bold),
                .ForeColor = ColorDark
            }
            cmbProduct = New ComboBox() With {
                .Left = x,
                .Top = y + 25,
                .Width = 400,
                .DropDownStyle = ComboBoxStyle.DropDownList,
                .Font = New Font("Segoe UI", 10)
            }
            AddHandler cmbProduct.SelectedIndexChanged, AddressOf OnProductSelected

            Dim lblSKU = New Label() With {
                .Text = "Product Code:",
                .Left = 420,
                .Top = y,
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9),
                .ForeColor = Color.Gray
            }
            txtSKU = New TextBox() With {
                .Left = 420,
                .Top = y + 25,
                .Width = 150,
                .ReadOnly = True,
                .BackColor = ColorLight,
                .Font = New Font("Segoe UI", 10),
                .BorderStyle = BorderStyle.FixedSingle
            }

            Dim lblProductID = New Label() With {
                .Text = "Product ID:",
                .Left = 590,
                .Top = y,
                .AutoSize = True,
                .Font = New Font("Segoe UI", 9),
                .ForeColor = Color.Gray
            }
            txtProductID = New TextBox() With {
                .Left = 590,
                .Top = y + 25,
                .Width = 100,
                .ReadOnly = True,
                .BackColor = ColorLight,
                .Font = New Font("Segoe UI", 10),
                .BorderStyle = BorderStyle.FixedSingle
            }

            pnlProductSelect.Controls.AddRange({lblProduct, cmbProduct, lblSKU, txtSKU, lblProductID, txtProductID})

            ' Load products
            LoadProductsWithoutRecipe()

            ' Action bar
            Dim pnlActions As New Panel() With {.Dock = DockStyle.Top, .Height = 56, .BackColor = Color.White}
            btnAddComponent = New Button() With {.Text = "Add Component", .Width = 140, .Height = 32, .Left = 20, .Top = 12}
            btnDone = New Button() With {.Text = "Save Recipe", .Width = 120, .Height = 32, .Left = 170, .Top = 12}
            btnPrint = New Button() With {.Text = "Print", .Width = 100, .Height = 32, .Left = 300, .Top = 12}
            pnlActions.Controls.AddRange(New Control() {btnAddComponent, btnDone, btnPrint})

            ' Hierarchy tree
            treeRecipe = New TreeView() With {.Dock = DockStyle.Fill, .HideSelection = False}
            AddHandler treeRecipe.NodeMouseClick, AddressOf OnTreeNodeMouseClick

            ' Costing panel (bottom)
            pnlCosting = New Panel() With {.Dock = DockStyle.Bottom, .Height = 64, .BackColor = Color.WhiteSmoke}
            lblTotalCost = New Label() With {.Left = 20, .Top = 10, .AutoSize = True, .Font = New Font("Segoe UI", 10, FontStyle.Bold), .Text = "Total Cost: R 0.00"}
            lblMaterialsCost = New Label() With {.Left = 220, .Top = 12, .AutoSize = True, .Text = "Raw Materials: R 0.00"}
            lblSubAsmCost = New Label() With {.Left = 450, .Top = 12, .AutoSize = True, .Text = "Sub-Assemblies: R 0.00"}
            pnlCosting.Controls.AddRange(New Control() {lblTotalCost, lblMaterialsCost, lblSubAsmCost})

            ' Compose left panel
            leftPanel.Controls.Add(treeRecipe)
            leftPanel.Controls.Add(pnlCosting)
            leftPanel.Controls.Add(pnlActions)
            leftPanel.Controls.Add(pnlProductSelect)

            ' RIGHT PANEL: Recipe Method
            Dim rightPanel As New Panel() With {.Dock = DockStyle.Fill, .Padding = New Padding(10), .BackColor = Color.White}
            Dim lblMethod As New Label() With {
                .Text = "Recipe Method / Instructions:",
                .Font = New Font("Segoe UI", 11, FontStyle.Bold),
                .Dock = DockStyle.Top,
                .Height = 30,
                .TextAlign = ContentAlignment.MiddleLeft
            }
            txtRecipeMethod = New TextBox() With {
                .Dock = DockStyle.Fill,
                .Multiline = True,
                .ScrollBars = ScrollBars.Vertical,
                .Font = New Font("Segoe UI", 10),
                .BorderStyle = BorderStyle.FixedSingle
            }
            rightPanel.Controls.Add(txtRecipeMethod)
            rightPanel.Controls.Add(lblMethod)

            ' Add panels to split container
            splitMain.Panel1.Controls.Add(leftPanel)
            splitMain.Panel2.Controls.Add(rightPanel)

            ' Add split container and header to form
            Me.Controls.Add(splitMain)
            Me.Controls.Add(pnlHeader)
        End Sub

        Private Sub LoadProductsWithoutRecipe()
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT ProductID, ProductName FROM Products WHERE ItemType IN ('internal', 'Manufactured') AND IsActive = 1 ORDER BY ProductName"
                    Using cmd As New SqlCommand(sql, con)
                        Dim dt As New DataTable()
                        Using reader = cmd.ExecuteReader()
                            dt.Load(reader)
                        End Using
                        cmbProduct.DisplayMember = "ProductName"
                        cmbProduct.ValueMember = "ProductID"
                        cmbProduct.DataSource = dt
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading products: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnProductSelected(sender As Object, e As EventArgs)
            If cmbProduct.SelectedValue Is Nothing Then Return

            Try
                _selectedProductId = Convert.ToInt32(cmbProduct.SelectedValue)

                ' Load product details and auto-fill
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    Dim sql As String = "SELECT ProductID, ProductCode, CategoryID, SubcategoryID FROM Products WHERE ProductID = @id"
                    Using cmd As New SqlCommand(sql, con)
                        cmd.Parameters.AddWithValue("@id", _selectedProductId)
                        Using reader = cmd.ExecuteReader()
                            If reader.Read() Then
                                txtProductID.Text = reader("ProductID").ToString()
                                txtSKU.Text = If(reader("ProductCode") Is DBNull.Value, "", reader("ProductCode").ToString())

                                ' Auto-fill category and subcategory
                                ' Category and subcategory are already set in the product - no need to display selector
                            End If
                        End Using
                    End Using
                End Using

                ' Clear existing recipe
                treeRecipe.Nodes.Clear()
                txtRecipeMethod.Clear()
                RecomputeCosts()

            Catch ex As Exception
                MessageBox.Show($"Error loading product details: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnAddComponent(sender As Object, e As EventArgs)
            If _selectedProductId = 0 Then
                MessageBox.Show("Please select a product first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Using dlg As New ComponentDialog()
                Dim result = dlg.ShowDialog(Me)
                If result = DialogResult.OK Then
                    Dim nodeText As String = dlg.ComponentDisplayName
                    Dim node As New TreeNode(nodeText)
                    node.Tag = dlg.GetCreatedComponentTag()
                    ' Add sub-action buttons notionally handled by context menu
                    EnsureContextMenu()
                    treeRecipe.Nodes.Add(node)
                    ' Select the newly added component so subsequent subcomponents attach here
                    treeRecipe.SelectedNode = node
                    treeRecipe.Focus()
                    treeRecipe.ExpandAll()
                    RecomputeCosts()
                End If
            End Using
        End Sub

        Private Sub EnsureContextMenu()
            If treeRecipe.ContextMenuStrip IsNot Nothing Then Return
            Dim cms As New ContextMenuStrip()
            cms.Items.Add("Add Subcomponent", Nothing, AddressOf OnAddSubcomponent)
            cms.Items.Add("Done", Nothing, AddressOf OnNodeDone)
            cms.Items.Add("Delete", Nothing, AddressOf OnDeleteNode)
            treeRecipe.ContextMenuStrip = cms
        End Sub

        Private Sub OnTreeNodeMouseClick(sender As Object, e As TreeNodeMouseClickEventArgs)
            ' Ensure right-click updates selection so context menu actions target the clicked node
            If e.Button = MouseButtons.Right OrElse e.Button = MouseButtons.Left Then
                treeRecipe.SelectedNode = e.Node
            End If
        End Sub

        Private Sub OnAddSubcomponent(sender As Object, e As EventArgs)
            If treeRecipe.SelectedNode Is Nothing Then Return
            Using dlg As New SubcomponentDialog()
                Dim result = dlg.ShowDialog(Me)
                If result = DialogResult.OK Then
                    Dim childText As String = dlg.SubcomponentDisplayName
                    Dim child As New TreeNode(childText)
                    child.Tag = dlg.GetCreatedSubcomponentTag()
                    treeRecipe.SelectedNode.Nodes.Add(child)
                    treeRecipe.SelectedNode.Expand()
                    RecomputeCosts()
                End If
            End Using
        End Sub

        Private Sub OnDeleteNode(sender As Object, e As EventArgs)
            If treeRecipe.SelectedNode Is Nothing Then Return
            Dim n = treeRecipe.SelectedNode
            Dim msg = $"Delete '{n.Text}' and all its children?"
            If MessageBox.Show(msg, "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = DialogResult.Yes Then
                n.Remove()
                RecomputeCosts()
            End If
        End Sub

        ' Placeholder handler for node-level completion from context menu.
        ' Currently a no-op to keep behavior unchanged; extend as needed.
        Private Sub OnNodeDone(sender As Object, e As EventArgs)
            ' Intentionally left blank
        End Sub

        Private Sub OnDone(sender As Object, e As EventArgs)
            ' Validation
            If _selectedProductId = 0 Then
                MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If treeRecipe.Nodes.Count = 0 Then
                MessageBox.Show("Please add at least one component to the recipe.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                ' Save the product recipe with method
                SaveProductRecipe()

                ' Update RecipeCreated flag
                UpdateRecipeCreatedFlag()

                ' Trigger sync after successful save
                InventoryEventHandler.OnRawMaterialsChanged()

                MessageBox.Show("Product recipe saved and inventory synced!", "Build Product", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error saving product recipe: {ex.Message}", "Build Product", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub UpdateRecipeCreatedFlag()
            Using con As New SqlConnection(_connectionString)
                con.Open()
                ' Check if ModifiedDate column exists
                Dim hasModifiedDate As Boolean = False
                Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'ModifiedDate'", con)
                    hasModifiedDate = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
                End Using
                
                Dim sql As String = If(hasModifiedDate, 
                    "UPDATE Products SET RecipeCreated = 'Yes', ModifiedDate = GETDATE() WHERE ProductID = @id",
                    "UPDATE Products SET RecipeCreated = 'Yes' WHERE ProductID = @id")
                Using cmd As New SqlCommand(sql, con)
                    cmd.Parameters.AddWithValue("@id", _selectedProductId)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
        End Sub

        Private Sub OldOnDone(sender As Object, e As EventArgs)
            ' This method is deprecated - use OnDone instead
            ' Product already has category/subcategory when created in AddProductForm
            Try
                ' Save the product recipe
                SaveProductRecipe()

                ' Trigger sync after successful save
                InventoryEventHandler.OnRawMaterialsChanged()

                MessageBox.Show("Product recipe saved and inventory synced!", "Build Product", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Me.Close()
            Catch ex As Exception
                MessageBox.Show($"Error saving product recipe: {ex.Message}", "Build Product", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub SaveHierarchy(productId As Integer)
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Using tx = cn.BeginTransaction()
                    Try
                        ' Clear existing nodes for this product
                        Using cmdDel As New Microsoft.Data.SqlClient.SqlCommand("DELETE FROM dbo.RecipeNode WHERE ProductID=@pid", cn, tx)
                            cmdDel.Parameters.AddWithValue("@pid", productId)
                            cmdDel.ExecuteNonQuery()
                        End Using

                        ' Insert all root nodes
                        For i As Integer = 0 To treeRecipe.Nodes.Count - 1
                            Dim root = treeRecipe.Nodes(i)
                            Dim rootId As Integer = InsertNodeRecursive(cn, tx, productId, Nothing, 0, i + 1, root)
                        Next

                        tx.Commit()
                    Catch
                        Try
                            tx.Rollback()
                        Catch
                        End Try
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Private Function InsertNodeRecursive(cn As Microsoft.Data.SqlClient.SqlConnection, tx As Microsoft.Data.SqlClient.SqlTransaction, productId As Integer, parentNodeId As Integer?, level As Integer, sortOrder As Integer, node As TreeNode) As Integer
            ' Extract data from node.Tag and node text
            Dim kind As String
            Dim itemType As Object = DBNull.Value
            Dim materialId As Object = DBNull.Value
            Dim subAsmId As Object = DBNull.Value
            Dim itemName As Object = DBNull.Value
            Dim qty As Object = DBNull.Value
            Dim uomId As Object = DBNull.Value
            Dim notes As Object = DBNull.Value

            If node.Tag IsNot Nothing AndAlso TypeOf node.Tag Is Dictionary(Of String, Object) Then
                Dim bag = DirectCast(node.Tag, Dictionary(Of String, Object))
                kind = If(TryCast(bag.GetValueOrDefault("Type"), String), "Component")
                If String.Equals(kind, "Component", StringComparison.OrdinalIgnoreCase) Then
                    itemName = If(TryCast(bag.GetValueOrDefault("Name"), String), node.Text)
                Else
                    itemType = If(TryCast(bag.GetValueOrDefault("Type"), String), CType(DBNull.Value, Object))
                    itemName = If(TryCast(bag.GetValueOrDefault("Item"), String), node.Text)
                    Dim qObj As Object = bag.GetValueOrDefault("Qty")
                    If qObj IsNot Nothing Then qty = Convert.ToDecimal(qObj)
                    ' IDs (optional)
                    If bag.ContainsKey("MaterialID") AndAlso bag("MaterialID") IsNot Nothing Then materialId = bag("MaterialID")
                    If bag.ContainsKey("SubAssemblyProductID") AndAlso bag("SubAssemblyProductID") IsNot Nothing Then subAsmId = bag("SubAssemblyProductID")
                    If bag.ContainsKey("UoMID") AndAlso bag("UoMID") IsNot Nothing Then uomId = bag("UoMID")
                    notes = If(TryCast(bag.GetValueOrDefault("Notes"), String), CType(DBNull.Value, Object))
                End If
            Else
                ' Fallback
                kind = If(node.Parent Is Nothing, "Component", "Subcomponent")
                itemName = node.Text
            End If

            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("INSERT INTO dbo.RecipeNode (ProductID, ParentNodeID, Level, NodeKind, ItemType, MaterialID, SubAssemblyProductID, ItemName, Qty, UoMID, Notes, SortOrder) VALUES (@pid, @parent, @lvl, @kind, @itype, @mat, @sub, @name, @qty, @uom, @notes, @sort); SELECT SCOPE_IDENTITY();", cn, tx)
                cmd.Parameters.AddWithValue("@pid", productId)
                cmd.Parameters.AddWithValue("@parent", If(parentNodeId.HasValue, CType(parentNodeId.Value, Object), CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@lvl", level)
                cmd.Parameters.AddWithValue("@kind", kind)
                cmd.Parameters.AddWithValue("@itype", itemType)
                cmd.Parameters.AddWithValue("@mat", materialId)
                cmd.Parameters.AddWithValue("@sub", subAsmId)
                cmd.Parameters.AddWithValue("@name", If(itemName, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@qty", If(qty, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@uom", If(uomId, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@notes", If(notes, CType(DBNull.Value, Object)))
                cmd.Parameters.AddWithValue("@sort", sortOrder)
                Dim newId = Convert.ToInt32(cmd.ExecuteScalar())

                ' Children
                For j As Integer = 0 To node.Nodes.Count - 1
                    InsertNodeRecursive(cn, tx, productId, newId, level + 1, j + 1, node.Nodes(j))
                Next
                Return newId
            End Using
        End Function

        Private Sub OnCodeKeyDown(sender As Object, e As KeyEventArgs)
            If e.KeyCode = Keys.Enter Then
                e.Handled = True
                e.SuppressKeyPress = True
                OnCodeLeave(sender, EventArgs.Empty)
            End If
        End Sub

        Private Sub OnCodeLeave(sender As Object, e As EventArgs)
            ' No longer needed - using dropdown selection
        End Sub

        Private Function TryResolveExistingProduct(code As String, ByRef productId As Integer, ByRef productName As String) As Boolean
            productId = 0
            productName = Nothing
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Dim hasSku As Boolean = ColumnExists(cn, Nothing, "Products", "SKU")
                If hasSku Then
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT TOP 1 ProductID, ProductName FROM dbo.Products WHERE SKU=@sku", cn)
                        cmd.Parameters.AddWithValue("@sku", code)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                productId = Convert.ToInt32(r("ProductID"))
                                productName = If(TryCast(r("ProductName"), String), Nothing)
                                Return True
                            End If
                        End Using
                    End Using
                Else
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT TOP 1 ProductID, ProductName FROM dbo.Products WHERE ProductCode=@code", cn)
                        cmd.Parameters.AddWithValue("@code", code)
                        Using r = cmd.ExecuteReader()
                            If r.Read() Then
                                productId = Convert.ToInt32(r("ProductID"))
                                productName = If(TryCast(r("ProductName"), String), Nothing)
                                Return True
                            End If
                        End Using
                    End Using
                End If
            End Using
            Return False
        End Function
        Private Function ResolveOrCreateProduct(code As String, name As String, categoryId As Integer, subcategoryId As Integer?) As Integer
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Dim hasSku As Boolean = ColumnExists(cn, Nothing, "Products", "SKU")
                Dim hasItemType As Boolean = ColumnExists(cn, Nothing, "Products", "ItemType")

                ' Products table uses BaseUoM (varchar) not DefaultUoMID, and has ItemType
                Dim insertSql As String = "IF EXISTS (SELECT 1 FROM dbo.Products WHERE SKU=@sku OR ProductCode=@sku) " &
                                          "SELECT ProductID FROM dbo.Products WHERE SKU=@sku OR ProductCode=@sku " &
                                          "ELSE BEGIN " &
                                          "INSERT INTO dbo.Products (SKU, ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, BaseUoM, IsActive) " &
                                          "VALUES (@sku, @sku, @pname, @cid, @scid, 'internal', 'ea', 1); " &
                                          "SELECT SCOPE_IDENTITY(); END"
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(insertSql, cn)
                    cmd.Parameters.AddWithValue("@sku", code)
                    cmd.Parameters.AddWithValue("@pname", name)
                    cmd.Parameters.AddWithValue("@cid", categoryId)
                    cmd.Parameters.AddWithValue("@scid", If(subcategoryId > 0, CType(subcategoryId, Object), DBNull.Value))
                    Dim obj = cmd.ExecuteScalar()
                    Return Convert.ToInt32(obj)
                End Using
            End Using
        End Function

        Private Function ColumnExists(cn As Microsoft.Data.SqlClient.SqlConnection, tx As Microsoft.Data.SqlClient.SqlTransaction, tableName As String, columnName As String) As Boolean
            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME=@t AND COLUMN_NAME=@c) THEN 1 ELSE 0 END", cn, tx)
                cmd.Parameters.AddWithValue("@t", tableName)
                cmd.Parameters.AddWithValue("@c", columnName)
                Return Convert.ToInt32(cmd.ExecuteScalar()) = 1
            End Using
        End Function

        Private Sub RecomputeCosts()
            Dim total As Decimal = 0D
            Dim raw As Decimal = 0D
            Dim subasm As Decimal = 0D
            For Each root As TreeNode In treeRecipe.Nodes
                AccumulateCostsRecursive(root, total, raw, subasm)
            Next
            lblTotalCost.Text = $"Total: {total:N2}"
            lblMaterialsCost.Text = $"Raw Materials: {raw:N2}"
            lblSubAsmCost.Text = $"Sub-Assemblies: {subasm:N2}"
        End Sub

        Private Sub AccumulateCostsRecursive(n As TreeNode, ByRef total As Decimal, ByRef raw As Decimal, ByRef subasm As Decimal)
            If n.Tag IsNot Nothing AndAlso TypeOf n.Tag Is Dictionary(Of String, Object) Then
                Dim bag = DirectCast(n.Tag, Dictionary(Of String, Object))
                If bag.ContainsKey("Type") Then
                    Dim itemType = bag("Type").ToString()

                    ' Get quantity (default to 1 if not specified)
                    Dim qty As Decimal = 1
                    If bag.ContainsKey("Qty") AndAlso bag("Qty") IsNot Nothing Then
                        Decimal.TryParse(bag("Qty").ToString(), qty)
                    End If

                    ' Calculate cost with quantity
                    Dim unitCost = GetLatestCost(itemType, bag)
                    Dim totalCost = unitCost * qty

                    If String.Equals(itemType, "Raw Material", StringComparison.OrdinalIgnoreCase) Then
                        raw += totalCost
                        total += totalCost
                    ElseIf String.Equals(itemType, "SubAssembly", StringComparison.OrdinalIgnoreCase) Then
                        subasm += totalCost
                        total += totalCost
                    Else
                        ' All other types (Decoration, Toppings, Accessories, Packaging) count as raw materials
                        raw += totalCost
                        total += totalCost
                    End If
                End If
            End If
            For Each c As TreeNode In n.Nodes
                AccumulateCostsRecursive(c, total, raw, subasm)
            Next
        End Sub

        Private Function GetLatestCost(itemType As String, bag As Dictionary(Of String, Object)) As Decimal
            Dim id As Integer = 0
            Dim tableName As String = ""
            Dim idColumn As String = ""

            ' Get ID and determine table/column based on type
            Select Case itemType
                Case "Raw Material"
                    If bag.ContainsKey("MaterialID") AndAlso bag("MaterialID") IsNot Nothing Then
                        Integer.TryParse(bag("MaterialID").ToString(), id)
                    End If
                    tableName = "RawMaterials"
                    idColumn = "MaterialID"

                Case "SubAssembly"
                    If bag.ContainsKey("SubAssemblyID") AndAlso bag("SubAssemblyID") IsNot Nothing Then
                        Integer.TryParse(bag("SubAssemblyID").ToString(), id)
                    End If
                    tableName = "SubAssemblies"
                    idColumn = "SubAssemblyID"

                Case "Toppings", "Topping"
                    If bag.ContainsKey("ToppingID") AndAlso bag("ToppingID") IsNot Nothing Then
                        Integer.TryParse(bag("ToppingID").ToString(), id)
                    End If
                    tableName = "Toppings"
                    idColumn = "ToppingID"

                Case "Decoration"
                    If bag.ContainsKey("DecorationID") AndAlso bag("DecorationID") IsNot Nothing Then
                        Integer.TryParse(bag("DecorationID").ToString(), id)
                    End If
                    tableName = "Decorations"
                    idColumn = "DecorationID"

                Case "Packaging"
                    If bag.ContainsKey("PackagingID") AndAlso bag("PackagingID") IsNot Nothing Then
                        Integer.TryParse(bag("PackagingID").ToString(), id)
                    End If
                    tableName = "Packaging"
                    idColumn = "PackagingID"

                Case "Accessories"
                    If bag.ContainsKey("AccessoryID") AndAlso bag("AccessoryID") IsNot Nothing Then
                        Integer.TryParse(bag("AccessoryID").ToString(), id)
                    End If
                    tableName = "Accessories"
                    idColumn = "AccessoryID"

                Case Else
                    Return 0D
            End Select

            If id <= 0 OrElse String.IsNullOrEmpty(tableName) Then Return 0D

            ' Get cost from appropriate table
            Try
                Using cn As New SqlConnection(_connectionString)
                    cn.Open()
                    ' RawMaterials uses LastCost, others use LastPaidCost
                    Dim costColumn As String = If(itemType = "Raw Material", "LastCost", "LastPaidCost")
                    Dim sql As String = $"SELECT ISNULL({costColumn}, 0) FROM {tableName} WHERE {idColumn} = @id"
                    Using cmd As New SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@id", id)
                        Dim result = cmd.ExecuteScalar()
                        If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                            Return Convert.ToDecimal(result)
                        End If
                    End Using
                End Using
            Catch
                Return 0D
            End Try

            Return 0D
        End Function

        Private Function GetRawMaterialFallbackCost(cn As Microsoft.Data.SqlClient.SqlConnection, materialId As Integer) As Decimal
            ' 1) Prefer latest UnitCost from cost history, branch-scoped when BranchID exists
            If ColumnExists(cn, Nothing, "InventoryItemCostHistory", "UnitCost") Then
                Dim hasBranch As Boolean = ColumnExists(cn, Nothing, "InventoryItemCostHistory", "BranchID")
                Dim histSql As String = "SELECT TOP 1 UnitCost FROM dbo.InventoryItemCostHistory WHERE ItemType='RawMaterial' AND ItemID=@id"
                If hasBranch Then
                    histSql &= " AND BranchID=@bid"
                End If
                histSql &= " ORDER BY ISNULL(PaidDate,'1900-01-01') DESC, HistoryID DESC"
                Using cmdHist As New Microsoft.Data.SqlClient.SqlCommand(histSql, cn)
                    cmdHist.Parameters.AddWithValue("@id", materialId)
                    If hasBranch Then
                        cmdHist.Parameters.AddWithValue("@bid", AppSession.CurrentBranchID)
                    End If
                    Dim obj = cmdHist.ExecuteScalar()
                    If obj IsNot Nothing AndAlso Not IsDBNull(obj) Then
                        Dim hv As Decimal
                        If Decimal.TryParse(obj.ToString(), hv) AndAlso hv > 0D Then Return hv
                    End If
                End Using
            End If

            ' 2) Fallback to common cost column names on dbo.RawMaterials in priority order
            Dim candidates As String() = {"CurrentCost", "LastPaidCost", "StandardCost", "UnitCost", "Price"}
            ' Discover which exist
            Dim existing As New List(Of String)()
            Using cmdCols As New Microsoft.Data.SqlClient.SqlCommand("SELECT name FROM sys.columns WHERE object_id = OBJECT_ID(N'dbo.RawMaterials')", cn)
                Using rdr = cmdCols.ExecuteReader()
                    While rdr.Read()
                        existing.Add(Convert.ToString(rdr.GetValue(0)))
                    End While
                End Using
            End Using
            For Each col In candidates
                If existing.Contains(col, StringComparer.OrdinalIgnoreCase) Then
                    Dim sql = $"SELECT TOP 1 {col} FROM dbo.RawMaterials WHERE MaterialID=@id"
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@id", materialId)
                        Dim obj = cmd.ExecuteScalar()
                        If obj IsNot Nothing AndAlso Not IsDBNull(obj) Then
                            Dim v As Decimal
                            If Decimal.TryParse(obj.ToString(), v) AndAlso v > 0D Then Return v
                        End If
                    End Using
                End If
            Next
            Return 0D
        End Function

        Private Function GetSubAssemblyCost(cn As Microsoft.Data.SqlClient.SqlConnection, productId As Integer) As Decimal
            ' Wrapper enabling memoization and cycle detection
            Dim visited As New HashSet(Of Integer)()
            Dim cache As New Dictionary(Of Integer, Decimal)()
            Return GetSubAssemblyCostInternal(cn, productId, visited, cache)
        End Function

        Private Function GetSubAssemblyCostInternal(cn As Microsoft.Data.SqlClient.SqlConnection, productId As Integer, visited As HashSet(Of Integer), cache As Dictionary(Of Integer, Decimal)) As Decimal
            ' Prevent infinite recursion on cyclic references and reuse computed values
            If visited.Contains(productId) Then Return 0D
            If cache.ContainsKey(productId) Then Return cache(productId)
            visited.Add(productId)

            Dim total As Decimal = 0D
            ' Load nodes for this productId
            Dim dt As New DataTable()
            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT NodeID, ParentNodeID, NodeKind, ItemType, MaterialID, SubAssemblyProductID, ItemName, Qty FROM dbo.RecipeNode WHERE ProductID=@pid ORDER BY ISNULL(ParentNodeID,0), SortOrder, NodeID", cn)
                cmd.Parameters.AddWithValue("@pid", productId)
                Using r = cmd.ExecuteReader()
                    dt.Load(r)
                End Using
            End Using
            If dt.Rows.Count = 0 Then
                cache(productId) = 0D
                visited.Remove(productId)
                Return 0D
            End If

            ' Build lookup by parent
            Dim rows = dt.AsEnumerable()
            Dim byParent = rows.GroupBy(Function(r) If(r.Field(Of Integer?)("ParentNodeID").HasValue, r.Field(Of Integer?)("ParentNodeID").Value, 0)).ToDictionary(Function(g) g.Key, Function(g) g.ToList())

            Dim stack As New Stack(Of Integer)()
            stack.Push(0)
            While stack.Count > 0
                Dim parent = stack.Pop()
                If byParent.ContainsKey(parent) Then
                    For Each row In byParent(parent)
                        Dim kind = If(TryCast(row("NodeKind"), String), Nothing)
                        If Not String.IsNullOrEmpty(kind) AndAlso Not String.Equals(kind, "Component", StringComparison.OrdinalIgnoreCase) Then
                            Dim itype = If(TryCast(row("ItemType"), String), Nothing)
                            Dim qty As Decimal = 1D
                            Dim qObj = row("Qty")
                            If qObj IsNot DBNull.Value Then Decimal.TryParse(qObj.ToString(), qty)
                            Dim unit As Decimal = 0D
                            If String.Equals(itype, "Raw Material", StringComparison.OrdinalIgnoreCase) Then
                                Dim mid As Integer = If(row("MaterialID") Is DBNull.Value, 0, Convert.ToInt32(row("MaterialID")))
                                If mid > 0 Then unit = GetRawMaterialFallbackCost(cn, mid)
                            ElseIf String.Equals(itype, "SubAssembly", StringComparison.OrdinalIgnoreCase) Then
                                Dim sid As Integer = If(row("SubAssemblyProductID") Is DBNull.Value, 0, Convert.ToInt32(row("SubAssemblyProductID")))
                                If sid > 0 Then unit = GetSubAssemblyCostInternal(cn, sid, visited, cache)
                            End If
                            total += unit * qty
                        End If
                        stack.Push(row.Field(Of Integer)("NodeID"))
                    Next
                End If
            End While

            cache(productId) = total
            visited.Remove(productId)
            Return total
        End Function

        Private Function BuildRecipeLinesData() As DataTable
            Dim dt As New DataTable()
            dt.Columns.AddRange(New DataColumn() {
            New DataColumn("Level", GetType(Integer)),
            New DataColumn("Kind", GetType(String)),
            New DataColumn("ItemType", GetType(String)),
            New DataColumn("Name", GetType(String)),
            New DataColumn("Qty", GetType(Decimal)),
            New DataColumn("UoM", GetType(String)),
            New DataColumn("UnitCost", GetType(Decimal)),
            New DataColumn("LineCost", GetType(Decimal)),
            New DataColumn("Notes", GetType(String))
        })
            For i As Integer = 0 To treeRecipe.Nodes.Count - 1
                AddPreviewRowsRecursive(dt, treeRecipe.Nodes(i), 0)
            Next
            Return dt
        End Function

        Private Sub AddPreviewRowsRecursive(dt As DataTable, n As TreeNode, level As Integer)
            Dim kind As String = "Component"
            Dim itemType As String = Nothing
            Dim name As String = n.Text
            Dim qty As Decimal = 0D
            Dim uom As String = Nothing
            Dim unitCost As Decimal = 0D
            Dim notes As String = Nothing
            If n.Tag IsNot Nothing AndAlso TypeOf n.Tag Is Dictionary(Of String, Object) Then
                Dim bag = DirectCast(n.Tag, Dictionary(Of String, Object))
                kind = If(TryCast(bag.GetValueOrDefault("Type"), String), "Component")
                If String.Equals(kind, "Component", StringComparison.OrdinalIgnoreCase) Then
                    name = If(TryCast(bag.GetValueOrDefault("Name"), String), n.Text)
                Else
                    itemType = kind
                    name = If(TryCast(bag.GetValueOrDefault("Item"), String), n.Text)
                    Dim qObj = bag.GetValueOrDefault("Qty")
                    If qObj IsNot Nothing Then Decimal.TryParse(qObj.ToString(), qty)
                    unitCost = GetLatestCost(itemType, bag)
                    notes = If(TryCast(bag.GetValueOrDefault("Notes"), String), Nothing)
                End If
            End If
            Dim lineCost As Decimal = unitCost * If(qty = 0D, 1D, qty)
            dt.Rows.Add(level, If(String.Equals(kind, "Component", StringComparison.OrdinalIgnoreCase), kind, "Subcomponent"), itemType, name, If(qty = 0D, DBNull.Value, CType(qty, Object)), uom, unitCost, lineCost, notes)
            For Each c As TreeNode In n.Nodes
                AddPreviewRowsRecursive(dt, c, level + 1)
            Next
        End Sub

        ' Populate categories on form load and cascade subcategories when category changes
        Private Sub OnFormLoad(sender As Object, e As EventArgs)
            Try
                LoadCategories()
                ' If a category is preselected, load subcategories for it
                Dim selCat As Integer = 0
                If cmbCategory IsNot Nothing AndAlso cmbCategory.SelectedValue IsNot Nothing AndAlso Integer.TryParse(cmbCategory.SelectedValue.ToString(), selCat) Then
                    LoadSubcategories(selCat)
                Else
                    LoadSubcategories(0)
                End If
            Catch ex As Exception
                MessageBox.Show("Load failed: " & ex.Message, "Build Product", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub OnCategoryChanged(sender As Object, e As EventArgs)
            Try
                Dim catId As Integer = 0
                If cmbCategory IsNot Nothing AndAlso cmbCategory.SelectedValue IsNot Nothing AndAlso Integer.TryParse(cmbCategory.SelectedValue.ToString(), catId) Then
                    LoadSubcategories(catId)
                Else
                    LoadSubcategories(0)
                End If
            Catch ex As Exception
                MessageBox.Show("Category change failed: " & ex.Message, "Build Product", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Sub LoadCategories()
            If cmbCategory Is Nothing Then Return
            Dim dt As New DataTable()
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                Using cmd As New SqlCommand("SELECT CategoryID, CategoryName FROM dbo.Categories WHERE ISNULL(IsActive,1)=1 ORDER BY CategoryName", cn)
                    Using r = cmd.ExecuteReader()
                        dt.Load(r)
                    End Using
                End Using
            End Using
            cmbCategory.DisplayMember = "CategoryName"
            cmbCategory.ValueMember = "CategoryID"
            cmbCategory.DataSource = dt
            If dt.Rows.Count > 0 Then cmbCategory.SelectedIndex = 0
            ' Refresh subcategories list on dropdown open too
            RemoveHandler cmbCategory.DropDown, AddressOf CategoryDropDownRefresh
            AddHandler cmbCategory.DropDown, AddressOf CategoryDropDownRefresh
        End Sub

        Private Sub CategoryDropDownRefresh(sender As Object, e As EventArgs)
            ' Reload categories so new CRUD entries appear
            Dim prev As Integer = 0
            If cmbCategory.SelectedValue IsNot Nothing Then Integer.TryParse(cmbCategory.SelectedValue.ToString(), prev)
            LoadCategories()
            ' Restore previous selection if still present
            If prev > 0 Then
                For i As Integer = 0 To cmbCategory.Items.Count - 1
                    Dim drv = TryCast(cmbCategory.Items(i), DataRowView)
                    If drv IsNot Nothing AndAlso Convert.ToInt32(drv("CategoryID")) = prev Then
                        cmbCategory.SelectedIndex = i
                        Exit For
                    End If
                Next
            End If
        End Sub

        Private Sub LoadSubcategories(categoryId As Integer)
            If cmbSubcategory Is Nothing Then Return
            Dim dt As New DataTable()
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                Dim sql As String = "SELECT SubcategoryID, SubcategoryName FROM dbo.Subcategories WHERE ISNULL(IsActive,1)=1"
                If categoryId > 0 Then sql &= " AND CategoryID=@cid"
                sql &= " ORDER BY SubcategoryName"
                Using cmd As New SqlCommand(sql, cn)
                    If categoryId > 0 Then cmd.Parameters.AddWithValue("@cid", categoryId)
                    Using r = cmd.ExecuteReader()
                        dt.Load(r)
                    End Using
                End Using
            End Using
            cmbSubcategory.DisplayMember = "SubcategoryName"
            cmbSubcategory.ValueMember = "SubcategoryID"
            cmbSubcategory.DataSource = dt
            If dt.Rows.Count > 0 Then cmbSubcategory.SelectedIndex = 0 Else cmbSubcategory.SelectedIndex = -1
            ' Allow refresh on dropdown open
            RemoveHandler cmbSubcategory.DropDown, AddressOf SubcategoryDropDownRefresh
            AddHandler cmbSubcategory.DropDown, AddressOf SubcategoryDropDownRefresh
        End Sub

        Private Sub OnCategorySelectionChanged(sender As Object, e As EventArgs)
            ' Product already has category - no validation needed
            btnDone.Enabled = True
        End Sub

        Private Sub SaveProductRecipe()
            ' Save product recipe to RecipeNode table
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using trans As SqlTransaction = conn.BeginTransaction()
                    Try
                        If _selectedProductId <= 0 Then
                            Throw New Exception("Please select a product first.")
                        End If

                        ' Save recipe structure to RecipeNode table
                        SaveRecipeNodes(_selectedProductId, conn, trans)

                        ' Save recipe method
                        SaveRecipeMethod(_selectedProductId, conn, trans)
                        
                        ' Save calculated cost to Products table
                        SaveProductCost(_selectedProductId, conn, trans)

                        trans.Commit()
                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Private Sub SaveRecipeMethod(productId As Integer, conn As SqlConnection, trans As SqlTransaction)
            ' Save recipe method to Products table if RecipeMethod column exists
            Dim hasRecipeMethod As Boolean = False
            Using cmdCheck As New SqlCommand("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME = 'RecipeMethod'", conn, trans)
                hasRecipeMethod = Convert.ToInt32(cmdCheck.ExecuteScalar()) > 0
            End Using
            
            If hasRecipeMethod Then
                Dim sql As String = "UPDATE Products SET RecipeMethod = @method WHERE ProductID = @id"
                Using cmd As New SqlCommand(sql, conn, trans)
                    cmd.Parameters.AddWithValue("@id", productId)
                    cmd.Parameters.AddWithValue("@method", If(String.IsNullOrWhiteSpace(txtRecipeMethod.Text), DBNull.Value, txtRecipeMethod.Text.Trim()))
                    cmd.ExecuteNonQuery()
                End Using
            End If
        End Sub
        
        Private Sub SaveProductCost(productId As Integer, conn As SqlConnection, trans As SqlTransaction)
            ' Calculate and save total cost to Products table
            Dim total As Decimal = 0D
            Dim raw As Decimal = 0D
            Dim subasm As Decimal = 0D
            
            For Each root As TreeNode In treeRecipe.Nodes
                AccumulateCostsRecursive(root, total, raw, subasm)
            Next
            
            ' Update Products table with calculated cost
            ' Check which cost column exists in Products table
            Dim costColumn As String = Nothing
            Using cmdCheck As New SqlCommand("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Products' AND COLUMN_NAME IN ('Cost', 'StandardCost', 'UnitCost', 'ProductCost', 'CostPrice', 'ManufacturingCost')", conn, trans)
                Using reader = cmdCheck.ExecuteReader()
                    If reader.Read() Then
                        costColumn = reader("COLUMN_NAME").ToString()
                    End If
                End Using
            End Using
            
            ' Only update if a cost column exists
            If Not String.IsNullOrEmpty(costColumn) Then
                Dim sql As String = $"UPDATE Products SET {costColumn} = @cost WHERE ProductID = @id"
                Using cmd As New SqlCommand(sql, conn, trans)
                    cmd.Parameters.AddWithValue("@id", productId)
                    cmd.Parameters.AddWithValue("@cost", total)
                    cmd.ExecuteNonQuery()
                End Using
            End If
        End Sub

        Private Sub SaveRecipeNodes(productId As Integer, conn As SqlConnection, trans As SqlTransaction)
            ' Save the recipe tree structure to RecipeNode table
            ' This preserves the bill of materials for manufacturing
            If treeRecipe.Nodes.Count > 0 Then
                ' Clear existing recipe nodes for this product
                Using cmd As New SqlCommand("DELETE FROM dbo.RecipeNode WHERE ProductID = @pid", conn, trans)
                    cmd.Parameters.AddWithValue("@pid", productId)
                    cmd.ExecuteNonQuery()
                End Using

                ' Save ALL root nodes and their children
                For i As Integer = 0 To treeRecipe.Nodes.Count - 1
                    SaveNodeRecursive(treeRecipe.Nodes(i), productId, Nothing, 0, i + 1, conn, trans)
                Next
            End If
        End Sub

        Private Sub SaveNodeRecursive(node As TreeNode, productId As Integer, parentNodeId As Integer?, level As Integer, sortOrder As Integer, conn As SqlConnection, trans As SqlTransaction)
            ' Extract data from node.Tag
            Dim nodeKind As String = If(node.Parent Is Nothing, "Component", "Subcomponent")
            Dim itemType As String = ""
            Dim itemName As String = node.Text
            Dim qty As Decimal = 1.0
            Dim notes As String = ""
            Dim materialId As Object = DBNull.Value
            Dim subAsmId As Object = DBNull.Value
            Dim uomId As Object = DBNull.Value
            
            If node.Tag IsNot Nothing AndAlso TypeOf node.Tag Is Dictionary(Of String, Object) Then
                Dim bag = DirectCast(node.Tag, Dictionary(Of String, Object))
                
                If bag.ContainsKey("Type") Then
                    Dim typeVal = bag("Type").ToString()
                    If typeVal = "Component" Then
                        nodeKind = "Component"
                    Else
                        nodeKind = "Subcomponent"
                        itemType = typeVal
                    End If
                End If
                
                If bag.ContainsKey("Item") Then itemName = bag("Item").ToString()
                If bag.ContainsKey("Name") Then itemName = bag("Name").ToString()
                If bag.ContainsKey("Qty") Then Decimal.TryParse(bag("Qty").ToString(), qty)
                If bag.ContainsKey("Notes") Then notes = bag("Notes").ToString()
                If bag.ContainsKey("MaterialID") Then materialId = bag("MaterialID")
                If bag.ContainsKey("SubAssemblyID") Then subAsmId = bag("SubAssemblyID")
                If bag.ContainsKey("UoMID") Then uomId = bag("UoMID")
            End If

            ' Insert this node
            Dim sql As String = "INSERT INTO dbo.RecipeNode (ProductID, ParentNodeID, Level, NodeKind, ItemType, MaterialID, SubAssemblyProductID, ItemName, Qty, UoMID, Notes, SortOrder) VALUES (@pid, @parent, @level, @kind, @type, @mat, @sub, @name, @qty, @uom, @notes, @sort); SELECT SCOPE_IDENTITY()"

            Dim nodeId As Integer
            Using cmd As New SqlCommand(sql, conn, trans)
                cmd.Parameters.AddWithValue("@pid", productId)
                cmd.Parameters.AddWithValue("@parent", If(parentNodeId.HasValue, CType(parentNodeId.Value, Object), DBNull.Value))
                cmd.Parameters.AddWithValue("@level", level)
                cmd.Parameters.AddWithValue("@kind", nodeKind)
                cmd.Parameters.AddWithValue("@type", If(String.IsNullOrEmpty(itemType), DBNull.Value, CType(itemType, Object)))
                cmd.Parameters.AddWithValue("@mat", materialId)
                cmd.Parameters.AddWithValue("@sub", subAsmId)
                cmd.Parameters.AddWithValue("@name", itemName)
                cmd.Parameters.AddWithValue("@qty", qty)
                cmd.Parameters.AddWithValue("@uom", uomId)
                cmd.Parameters.AddWithValue("@notes", If(String.IsNullOrEmpty(notes), DBNull.Value, CType(notes, Object)))
                cmd.Parameters.AddWithValue("@sort", sortOrder)
                nodeId = Convert.ToInt32(cmd.ExecuteScalar())
            End Using

            ' Save child nodes recursively
            For i As Integer = 0 To node.Nodes.Count - 1
                SaveNodeRecursive(node.Nodes(i), productId, nodeId, level + 1, i + 1, conn, trans)
            Next
        End Sub

        Private Sub OnPrint(sender As Object, e As EventArgs)
            If _selectedProductId = 0 Then
                MessageBox.Show("Please select a product first.", "Print Recipe", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            Try
                Dim productName As String = cmbProduct.Text
                Dim recipeText As String = GetRecipeTextForPrint(_selectedProductId, productName)
                
                Dim printDoc As New PrintDocument()
                AddHandler printDoc.PrintPage, Sub(s, ev)
                    Dim font As New Font("Arial", 10)
                    Dim headerFont As New Font("Arial", 16, FontStyle.Bold)
                    Dim subHeaderFont As New Font("Arial", 12, FontStyle.Bold)
                    Dim y As Single = 80
                    
                    ' Print company header
                    ev.Graphics.DrawString("OVEN DELIGHTS", headerFont, New SolidBrush(ColorDark), 50, 30)
                    ev.Graphics.DrawString("Product Recipe", subHeaderFont, Brushes.Gray, 50, 55)
                    
                    ' Print product name
                    ev.Graphics.DrawString($"Product: {productName}", New Font("Arial", 12, FontStyle.Bold), Brushes.Black, 50, y)
                    y += 30
                    ev.Graphics.DrawString(New String("-"c, 100), font, Brushes.Black, 50, y)
                    y += 30
                    
                    ' Print recipe text
                    Dim lines() As String = recipeText.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
                    For Each line In lines
                        If y > ev.PageBounds.Height - 100 Then Exit For
                        ev.Graphics.DrawString(line, font, Brushes.Black, 50, y)
                        y += 22
                    Next
                End Sub
                
                Dim printDialog As New PrintDialog() With {.Document = printDoc}
                If printDialog.ShowDialog() = DialogResult.OK Then
                    printDoc.Print()
                    MessageBox.Show("Recipe sent to printer!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            Catch ex As Exception
                MessageBox.Show($"Error printing recipe: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End Sub

        Private Function GetRecipeTextForPrint(productId As Integer, productName As String) As String
            Dim result As New System.Text.StringBuilder()
            
            Try
                Using con As New SqlConnection(_connectionString)
                    con.Open()
                    
                    ' Get recipe method
                    Dim recipeMethod As String = If(String.IsNullOrWhiteSpace(txtRecipeMethod.Text), "No method specified", txtRecipeMethod.Text)
                    
                    result.AppendLine("COMPONENTS:")
                    result.AppendLine()
                    
                    ' Build from tree
                    For Each node As TreeNode In treeRecipe.Nodes
                        AppendNodeToText(node, result, 0)
                    Next
                    
                    result.AppendLine()
                    result.AppendLine("METHOD:")
                    result.AppendLine(recipeMethod)
                End Using
            Catch ex As Exception
                result.AppendLine($"Error: {ex.Message}")
            End Try
            
            Return result.ToString()
        End Function

        Private Sub AppendNodeToText(node As TreeNode, sb As System.Text.StringBuilder, level As Integer)
            Dim indent As String = New String(" "c, level * 3)
            sb.AppendLine($"{indent}• {node.Text}")
            For Each child As TreeNode In node.Nodes
                AppendNodeToText(child, sb, level + 1)
            Next
        End Sub

    End Class

End Namespace
