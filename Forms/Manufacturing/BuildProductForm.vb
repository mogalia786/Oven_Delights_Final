Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration
Imports System.Linq

Namespace Manufacturing

Public Class BuildProductForm
    Inherits Form

    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Private cmbCategory As ComboBox
    Private cmbSubcategory As ComboBox
    Private txtProductName As TextBox
    Private txtSKU As TextBox
    Private txtProductID As TextBox

    Private btnAddComponent As Button
    Private btnDone As Button

    Private treeRecipe As TreeView
    Private pnlCosting As Panel
    Private lblTotalCost As Label
    Private lblMaterialsCost As Label
    Private lblSubAsmCost As Label

    Public Sub New()
        Me.Text = "Build My Product"
        Me.Width = 1120
        Me.Height = 740
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUi()
        AddHandler btnAddComponent.Click, AddressOf OnAddComponent
        AddHandler btnDone.Click, AddressOf OnDone
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
        ' Header panel (same structure as RecipeCreator header)
        Dim pnlHeader As New Panel() With {.Dock = DockStyle.Top, .Height = 140, .BackColor = Color.White}
        Dim header As New Label() With {
            .Text = "Build Product (Hierarchy)",
            .Font = New Font("Segoe UI", 14, FontStyle.Bold),
            .AutoSize = True,
            .Left = 20,
            .Top = 10,
            .ForeColor = Color.FromArgb(183, 58, 46)
        }
        pnlHeader.Controls.Add(header)

        Dim x As Integer = 20
        Dim y As Integer = 44

        Dim lblCategory = New Label() With {.Text = "Category:", .Left = x, .Top = y, .AutoSize = True}
        cmbCategory = New ComboBox() With {.Left = x + 90, .Top = y - 3, .Width = 220, .DropDownStyle = ComboBoxStyle.DropDownList}
        AddHandler cmbCategory.SelectedIndexChanged, AddressOf OnCategoryChanged
        Dim lblSubcategory = New Label() With {.Text = "Subcategory:", .Left = 340, .Top = y, .AutoSize = True}
        cmbSubcategory = New ComboBox() With {.Left = 430, .Top = y - 3, .Width = 260, .DropDownStyle = ComboBoxStyle.DropDownList}

        Dim lblSKU = New Label() With {.Text = "Product Code/SKU:", .Left = 710, .Top = y, .AutoSize = True}
        txtSKU = New TextBox() With {.Left = 850, .Top = y - 3, .Width = 160}

        y += 34
        Dim lblProductID = New Label() With {.Text = "Product ID:", .Left = 710, .Top = y, .AutoSize = True}
        txtProductID = New TextBox() With {.Left = 780, .Top = y - 3, .Width = 230, .ReadOnly = True, .BackColor = Color.Gainsboro}

        y += 34
        Dim lblProduct = New Label() With {.Text = "Product:", .Left = x, .Top = y, .AutoSize = True}
        txtProductName = New TextBox() With {.Left = x + 90, .Top = y - 3, .Width = 320}

        pnlHeader.Controls.AddRange(New Control() {lblCategory, cmbCategory, lblSubcategory, cmbSubcategory, lblSKU, txtSKU, lblProductID, txtProductID, lblProduct, txtProductName})

        ' Action bar
        Dim pnlActions As New Panel() With {.Dock = DockStyle.Top, .Height = 56, .BackColor = Color.White}
        btnAddComponent = New Button() With {.Text = "Add Component", .Width = 140, .Height = 32, .Left = 20, .Top = 12}
        btnDone = New Button() With {.Text = "Done", .Width = 100, .Height = 32, .Left = 170, .Top = 12}
        pnlActions.Controls.AddRange(New Control() {btnAddComponent, btnDone})

        ' Hierarchy tree
        treeRecipe = New TreeView() With {.Dock = DockStyle.Fill, .HideSelection = False}
        ' Ensure right-click selects the node under mouse before context menu actions
        AddHandler treeRecipe.NodeMouseClick, AddressOf OnTreeNodeMouseClick

        ' Costing panel (bottom)
        pnlCosting = New Panel() With {.Dock = DockStyle.Bottom, .Height = 64, .BackColor = Color.WhiteSmoke}
        lblTotalCost = New Label() With {.Left = 20, .Top = 10, .AutoSize = True, .Font = New Font("Segoe UI", 10, FontStyle.Bold), .Text = "Total: 0.00"}
        lblMaterialsCost = New Label() With {.Left = 220, .Top = 12, .AutoSize = True, .Text = "Raw Materials: 0.00"}
        lblSubAsmCost = New Label() With {.Left = 420, .Top = 12, .AutoSize = True, .Text = "Sub-Assemblies: 0.00"}
        pnlCosting.Controls.AddRange(New Control() {lblTotalCost, lblMaterialsCost, lblSubAsmCost})

        ' Compose
        Me.Controls.Add(treeRecipe)
        Me.Controls.Add(pnlCosting)
        Me.Controls.Add(pnlActions)
        Me.Controls.Add(pnlHeader)
    End Sub

    Private Sub OnAddComponent(sender As Object, e As EventArgs)
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
        ' Header validation + resolve ProductID using SKU/ProductCode schema
        If cmbCategory.SelectedValue Is Nothing OrElse cmbSubcategory.SelectedValue Is Nothing Then
            MessageBox.Show("Please select a Category and Subcategory.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If String.IsNullOrWhiteSpace(txtProductName.Text) Then
            MessageBox.Show("Please enter a Product name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If String.IsNullOrWhiteSpace(txtSKU.Text) Then
            MessageBox.Show("Please enter a Product Code/SKU.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Dim catId As Integer = Convert.ToInt32(cmbCategory.SelectedValue)
            Dim subId As Integer = Convert.ToInt32(cmbSubcategory.SelectedValue)
            Dim productId As Integer = ResolveOrCreateProduct(txtSKU.Text.Trim(), txtProductName.Text.Trim(), catId, subId)
            If productId > 0 Then
                txtProductID.Text = productId.ToString()
                ' Persist hierarchy
                SaveHierarchy(productId)
                ' Reload to ensure UI reflects DB order/state
                LoadHierarchy(productId)
                RecomputeCosts()
                ' Show preview with option to export to PDF
                Dim lines = BuildRecipeLinesData()
                Using preview As New RecipePreviewForm(txtSKU.Text.Trim(), txtProductName.Text.Trim(), lines, lblTotalCost.Text)
                    preview.ShowDialog(Me)
                End Using
                MessageBox.Show("Product and hierarchy saved.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show("Operation failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
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
        Dim code = txtSKU.Text.Trim()
        If String.IsNullOrWhiteSpace(code) Then Return
        Try
            Dim pid As Integer
            Dim pname As String = Nothing
            If TryResolveExistingProduct(code, pid, pname) AndAlso pid > 0 Then
                txtProductID.Text = pid.ToString()
                If Not String.IsNullOrWhiteSpace(pname) AndAlso String.IsNullOrWhiteSpace(txtProductName.Text) Then
                    txtProductName.Text = pname
                End If
                LoadHierarchy(pid)
            Else
                treeRecipe.Nodes.Clear()
            End If
        Catch
            ' ignore non-critical lookup errors
        End Try
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
            If hasSku Then
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("IF EXISTS (SELECT 1 FROM dbo.Products WHERE SKU=@sku) SELECT ProductID FROM dbo.Products WHERE SKU=@sku ELSE BEGIN INSERT INTO dbo.Products (SKU, ProductName, DefaultUoMID, IsActive) VALUES (@sku, @pname, (SELECT TOP 1 UoMID FROM dbo.UoM WHERE UoMCode='ea'), 1); SELECT SCOPE_IDENTITY(); END", cn)
                    cmd.Parameters.AddWithValue("@sku", code)
                    cmd.Parameters.AddWithValue("@pname", name)
                    Dim obj = cmd.ExecuteScalar()
                    Return Convert.ToInt32(obj)
                End Using
            Else
                ' ProductCode schema: create if missing using selected Category/Subcategory and defaults
                ' Always use new master tables: dbo.Categories and dbo.Subcategories
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("IF EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode=@code) SELECT ProductID FROM dbo.Products WHERE ProductCode=@code ELSE BEGIN INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, BaseUoM, IsActive) VALUES (@code, @pname, @cid, @scid, 'Finished', 'ea', 1); SELECT SCOPE_IDENTITY(); END", cn)
                    cmd.Parameters.AddWithValue("@code", code)
                    cmd.Parameters.AddWithValue("@pname", name)
                    cmd.Parameters.AddWithValue("@cid", categoryId)
                    If subcategoryId.HasValue Then
                        cmd.Parameters.AddWithValue("@scid", subcategoryId.Value)
                    Else
                        cmd.Parameters.AddWithValue("@scid", DBNull.Value)
                    End If
                    Dim obj = cmd.ExecuteScalar()
                    Return Convert.ToInt32(obj)
                End Using
            End If
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
            Dim kind = If(TryCast(bag.GetValueOrDefault("Type"), String), Nothing)
            If Not String.IsNullOrEmpty(kind) AndAlso Not String.Equals(kind, "Component", StringComparison.OrdinalIgnoreCase) Then
                Dim lineType = kind
                Dim qty As Decimal = 1D
                Dim qObj = bag.GetValueOrDefault("Qty")
                If qObj IsNot Nothing Then Decimal.TryParse(qObj.ToString(), qty)
                Dim unitCost As Decimal = GetLatestCost(lineType, bag)
                Dim lineCost As Decimal = unitCost * qty
                total += lineCost
                If String.Equals(lineType, "Raw Material", StringComparison.OrdinalIgnoreCase) Then
                    raw += lineCost
                ElseIf String.Equals(lineType, "SubAssembly", StringComparison.OrdinalIgnoreCase) Then
                    subasm += lineCost
                End If
            End If
        End If
        For Each c As TreeNode In n.Nodes
            AccumulateCostsRecursive(c, total, raw, subasm)
        Next
    End Sub

    Private Function GetLatestCost(itemType As String, bag As Dictionary(Of String, Object)) As Decimal
        Dim id As Integer = 0
        If String.Equals(itemType, "Raw Material", StringComparison.OrdinalIgnoreCase) Then
            If bag.ContainsKey("MaterialID") AndAlso bag("MaterialID") IsNot Nothing Then
                Integer.TryParse(bag("MaterialID").ToString(), id)
            End If
        ElseIf String.Equals(itemType, "SubAssembly", StringComparison.OrdinalIgnoreCase) Then
            ' SubAssemblyProductID maps to Products.ProductID
            If bag.ContainsKey("SubAssemblyProductID") AndAlso bag("SubAssemblyProductID") IsNot Nothing Then
                Integer.TryParse(bag("SubAssemblyProductID").ToString(), id)
            End If
        End If
        If id <= 0 Then Return 0D
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                ' InventoryCatalogItems may not have CurrentCost/LastPaidCost in some schemas
                Dim hasCurrent As Boolean = ColumnExists(cn, Nothing, "InventoryCatalogItems", "CurrentCost")
                Dim hasLastPaid As Boolean = ColumnExists(cn, Nothing, "InventoryCatalogItems", "LastPaidCost")
                Dim selectExpr As String
                If hasCurrent AndAlso hasLastPaid Then
                    selectExpr = "ISNULL(CurrentCost, ISNULL(LastPaidCost, 0))"
                ElseIf hasCurrent Then
                    selectExpr = "ISNULL(CurrentCost, 0)"
                ElseIf hasLastPaid Then
                    selectExpr = "ISNULL(LastPaidCost, 0)"
                Else
                    selectExpr = Nothing
                End If

                Dim viewCost As Decimal = 0D
                If Not String.IsNullOrEmpty(selectExpr) Then
                    Dim sql As String = $"SELECT TOP 1 {selectExpr} FROM dbo.InventoryCatalogItems WHERE ItemType=@t AND ItemID=@id"
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, cn)
                        cmd.Parameters.AddWithValue("@t", If(String.Equals(itemType, "Raw Material", StringComparison.OrdinalIgnoreCase), "RawMaterial", itemType))
                        cmd.Parameters.AddWithValue("@id", id)
                        Dim obj = cmd.ExecuteScalar()
                        If obj IsNot Nothing AndAlso Not IsDBNull(obj) Then
                            Decimal.TryParse(obj.ToString(), viewCost)
                        End If
                    End Using
                End If

                If viewCost > 0D Then Return viewCost

                ' Fallbacks by type
                If String.Equals(itemType, "Raw Material", StringComparison.OrdinalIgnoreCase) Then
                    Return GetRawMaterialFallbackCost(cn, id)
                ElseIf String.Equals(itemType, "SubAssembly", StringComparison.OrdinalIgnoreCase) Then
                    Return GetSubAssemblyCost(cn, id)
                Else
                    Return 0D
                End If
            End Using
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

        Private Sub SubcategoryDropDownRefresh(sender As Object, e As EventArgs)
            Dim catId As Integer = 0
            If cmbCategory IsNot Nothing AndAlso cmbCategory.SelectedValue IsNot Nothing Then Integer.TryParse(cmbCategory.SelectedValue.ToString(), catId)
            Dim prev As Integer = 0
            If cmbSubcategory.SelectedValue IsNot Nothing Then Integer.TryParse(cmbSubcategory.SelectedValue.ToString(), prev)
            LoadSubcategories(catId)
            If prev > 0 Then
                For i As Integer = 0 To cmbSubcategory.Items.Count - 1
                    Dim drv = TryCast(cmbSubcategory.Items(i), DataRowView)
                    If drv IsNot Nothing AndAlso Convert.ToInt32(drv("SubcategoryID")) = prev Then
                        cmbSubcategory.SelectedIndex = i
                        Exit For
                    End If
                Next
            End If
        End Sub

    End Class

End Namespace
