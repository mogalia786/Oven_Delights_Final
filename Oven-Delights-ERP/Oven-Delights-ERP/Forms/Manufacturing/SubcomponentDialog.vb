Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing

    Public Class SubcomponentDialog
        Inherits Form

        Private cmbType As ComboBox
        Private cmbItem As ComboBox
        Private txtSearch As TextBox
        Private numQty As NumericUpDown
        Private cmbUoM As ComboBox
        Private txtFlavor As TextBox
        Private txtNotes As TextBox
        Private btnOk As Button
        Private btnCancel As Button

        Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        Private uomDt As DataTable
        Private currentItemsDataTable As DataTable

        Public ReadOnly Property SubcomponentDisplayName As String
            Get
                Dim t = If(cmbType.SelectedItem, "").ToString()
                Dim i = If(cmbItem.Text, "").ToString()
                Return $"{t}: {i}"
            End Get
        End Property

        Public Sub New()
            Me.Text = "Add Subcomponent"
            Me.FormBorderStyle = FormBorderStyle.FixedDialog
            Me.StartPosition = FormStartPosition.CenterParent
            Me.MinimizeBox = False
            Me.MaximizeBox = False
            Me.Width = 540
            Me.Height = 320

            Dim y As Integer = 16
            Dim lblType As New Label() With {.Text = "Type:", .Left = 16, .Top = y, .AutoSize = True}
            cmbType = New ComboBox() With {.Left = 120, .Top = y - 3, .Width = 380, .DropDownStyle = ComboBoxStyle.DropDownList}
            cmbType.Items.AddRange(New Object() {"Raw Material", "SubAssembly", "Decoration", "Toppings", "Accessories", "Packaging"})
            AddHandler cmbType.SelectedIndexChanged, AddressOf OnTypeChanged

            y += 32
            Dim lblSearch As New Label() With {.Text = "Search:", .Left = 16, .Top = y, .AutoSize = True}
            txtSearch = New TextBox() With {.Left = 120, .Top = y - 3, .Width = 380}
            AddHandler txtSearch.TextChanged, AddressOf OnSearchTextChanged
            
            y += 32
            Dim lblItem As New Label() With {.Text = "Item:", .Left = 16, .Top = y, .AutoSize = True}
            cmbItem = New ComboBox() With {.Left = 120, .Top = y - 3, .Width = 380}
            AddHandler cmbItem.SelectedIndexChanged, AddressOf OnItemChanged

            y += 32
            Dim lblQty As New Label() With {.Text = "Quantity:", .Left = 16, .Top = y, .AutoSize = True}
            numQty = New NumericUpDown() With {.Left = 120, .Top = y - 3, .Width = 120, .Minimum = 0, .Maximum = 1000000, .DecimalPlaces = 3, .Value = 0}

            Dim lblUoM As New Label() With {.Text = "UoM:", .Left = 260, .Top = y, .AutoSize = True}
            cmbUoM = New ComboBox() With {.Left = 300, .Top = y - 3, .Width = 200, .DropDownStyle = ComboBoxStyle.DropDownList}

            y += 32
            Dim lblFlavor As New Label() With {.Text = "Flavor:", .Left = 16, .Top = y, .AutoSize = True}
            txtFlavor = New TextBox() With {.Left = 120, .Top = y - 3, .Width = 380}

            y += 32
            Dim lblNotes As New Label() With {.Text = "Notes:", .Left = 16, .Top = y, .AutoSize = True}
            txtNotes = New TextBox() With {.Left = 120, .Top = y - 3, .Width = 380}

            btnOk = New Button() With {.Text = "OK", .Left = 320, .Top = 210, .Width = 80}
            btnCancel = New Button() With {.Text = "Cancel", .Left = 410, .Top = 210, .Width = 80}
            AddHandler btnOk.Click, Sub()
                                        If cmbType.SelectedIndex < 0 OrElse String.IsNullOrWhiteSpace(cmbItem.Text) Then
                                            MessageBox.Show("Please select a type and item.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                            Return
                                        End If
                                        Me.DialogResult = DialogResult.OK
                                    End Sub
            AddHandler btnCancel.Click, Sub()
                                            Me.DialogResult = DialogResult.Cancel
                                        End Sub

            Me.Controls.AddRange(New Control() {lblType, cmbType, lblSearch, txtSearch, lblItem, cmbItem, lblQty, numQty, lblUoM, cmbUoM, lblFlavor, txtFlavor, lblNotes, txtNotes, btnOk, btnCancel})

            ' Load static lists
            Try
                LoadUoM()
            Catch
            End Try
        End Sub

        Public Function GetCreatedSubcomponentTag() As Object
            Dim bag As New Dictionary(Of String, Object)()
            bag("Type") = If(cmbType.SelectedItem, "").ToString()
            bag("Item") = cmbItem.Text
            bag("Qty") = numQty.Value
            bag("UoM") = cmbUoM.Text
            If cmbUoM.SelectedValue IsNot Nothing Then
                Dim uomId As Integer
                If Integer.TryParse(cmbUoM.SelectedValue.ToString(), uomId) Then
                    bag("UoMID") = uomId
                End If
            End If
            
            ' Store IDs based on type
            Dim selType = bag("Type").ToString()
            If cmbItem.SelectedValue IsNot Nothing Then
                Dim itemId As Integer
                If Integer.TryParse(cmbItem.SelectedValue.ToString(), itemId) Then
                    Select Case selType
                        Case "Raw Material"
                            bag("MaterialID") = itemId
                        Case "SubAssembly"
                            bag("SubAssemblyID") = itemId
                        Case "Decoration"
                            bag("DecorationID") = itemId
                        Case "Toppings"
                            bag("ToppingID") = itemId
                        Case "Accessories"
                            bag("AccessoryID") = itemId
                        Case "Packaging"
                            bag("PackagingID") = itemId
                    End Select
                End If
            End If
            
            bag("Flavor") = txtFlavor.Text
            bag("Notes") = txtNotes.Text
            Return bag
        End Function

        Private Sub LoadUoM()
            uomDt = New DataTable()
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT UoMID, UoMCode FROM dbo.UoM ORDER BY UoMCode", cn)
                    uomDt.Load(cmd.ExecuteReader())
                End Using
            End Using
            cmbUoM.DisplayMember = "UoMCode"
            cmbUoM.ValueMember = "UoMID"
            cmbUoM.DataSource = uomDt
        End Sub

        Private Sub OnTypeChanged(sender As Object, e As EventArgs)
            Dim t = If(cmbType.SelectedItem, "").ToString()
            Select Case t
                Case "Raw Material"
                    BindRawMaterials()
                Case "SubAssembly"
                    BindSubAssemblies()
                Case "Decoration"
                    BindDecorations()
                Case "Toppings"
                    BindToppings()
                Case "Accessories"
                    BindAccessories()
                Case "Packaging"
                    BindPackaging()
                Case Else
                    cmbItem.DataSource = Nothing
                    cmbItem.DropDownStyle = ComboBoxStyle.DropDown
            End Select
        End Sub

        Private Sub BindRawMaterials()
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                currentItemsDataTable = New DataTable()
                ' Filter by category: Ingredients, Consumables, Packaging, Miscellaneous
                Dim sql As String = "SELECT m.MaterialID, " & _
                    "(ISNULL(m.MaterialCode,'') + CASE WHEN ISNULL(m.MaterialCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(m.MaterialName,'')) AS Display, " & _
                    "u.UoMID AS DefaultUoMID, m.MaterialName " & _
                    "FROM dbo.RawMaterials m " & _
                    "LEFT JOIN dbo.UoM u ON u.UoMCode = m.BaseUnit " & _
                    "LEFT JOIN dbo.ProductCategories pc ON m.CategoryID = pc.CategoryID " & _
                    "WHERE m.IsActive=1 " & _
                    "  AND (pc.CategoryName LIKE '%ingredient%' " & _
                    "       OR pc.CategoryName LIKE '%consumable%' " & _
                    "       OR pc.CategoryName LIKE '%packaging%' " & _
                    "       OR pc.CategoryName LIKE '%misce%') " & _
                    "ORDER BY m.MaterialName"
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, cn)
                    currentItemsDataTable.Load(cmd.ExecuteReader())
                End Using
                ' Clear previous binding first to avoid ValueMember validation against old schema
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "MaterialID"
                cmbItem.DataSource = currentItemsDataTable
                cmbItem.DropDownStyle = ComboBoxStyle.DropDown
                cmbItem.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cmbItem.AutoCompleteSource = AutoCompleteSource.ListItems
            End Using
        End Sub

        Private Sub BindSubAssemblies()
            ' Show catalog of Sub-Assemblies filtered by "sub recipe" category
            Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
                cn.Open()
                currentItemsDataTable = New DataTable()
                Dim sql As String = "SELECT s.SubAssemblyID, " & _
                    "(ISNULL(s.SubAssemblyCode,'') + CASE WHEN ISNULL(s.SubAssemblyCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(s.SubAssemblyName,'')) AS Display, " & _
                    "s.DefaultUoMID, s.SubAssemblyName " & _
                    "FROM dbo.SubAssemblies s " & _
                    "LEFT JOIN dbo.ProductCategories pc ON s.CategoryID = pc.CategoryID " & _
                    "WHERE ISNULL(s.IsActive,1)=1 " & _
                    "  AND (pc.CategoryName LIKE '%sub%recipe%' OR pc.CategoryName LIKE '%subrecipe%') " & _
                    "ORDER BY s.SubAssemblyName"
                Using cmd As New Microsoft.Data.SqlClient.SqlCommand(sql, cn)
                    currentItemsDataTable.Load(cmd.ExecuteReader())
                End Using
                ' Clear previous binding first to avoid ValueMember validation against old schema
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "SubAssemblyID"
                cmbItem.DataSource = currentItemsDataTable
                cmbItem.DropDownStyle = ComboBoxStyle.DropDown
                cmbItem.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cmbItem.AutoCompleteSource = AutoCompleteSource.ListItems
            End Using
        End Sub

        Private Sub BindDecorations()
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                currentItemsDataTable = New DataTable()
                ' Filter by consumables/miscellaneous category
                Dim sql As String = "SELECT d.DecorationID, " & _
                    "(ISNULL(d.DecorationCode,'') + CASE WHEN ISNULL(d.DecorationCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(d.DecorationName,'')) AS Display, " & _
                    "d.DefaultUoMID, d.DecorationName " & _
                    "FROM dbo.Decorations d " & _
                    "LEFT JOIN dbo.ProductCategories pc ON d.CategoryID = pc.CategoryID " & _
                    "WHERE ISNULL(d.IsActive,1)=1 " & _
                    "  AND (pc.CategoryName LIKE '%consumable%' OR pc.CategoryName LIKE '%misce%') " & _
                    "ORDER BY d.DecorationName"
                Using cmd As New SqlCommand(sql, cn)
                    currentItemsDataTable.Load(cmd.ExecuteReader())
                End Using
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "DecorationID"
                cmbItem.DataSource = currentItemsDataTable
                cmbItem.DropDownStyle = ComboBoxStyle.DropDown
                cmbItem.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cmbItem.AutoCompleteSource = AutoCompleteSource.ListItems
            End Using
        End Sub

        Private Sub BindToppings()
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                currentItemsDataTable = New DataTable()
                ' Filter by consumables/miscellaneous category
                Dim sql As String = "SELECT t.ToppingID, " & _
                    "(ISNULL(t.ToppingCode,'') + CASE WHEN ISNULL(t.ToppingCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(t.ToppingName,'')) AS Display, " & _
                    "t.DefaultUoMID, t.ToppingName " & _
                    "FROM dbo.Toppings t " & _
                    "LEFT JOIN dbo.ProductCategories pc ON t.CategoryID = pc.CategoryID " & _
                    "WHERE ISNULL(t.IsActive,1)=1 " & _
                    "  AND (pc.CategoryName LIKE '%consumable%' OR pc.CategoryName LIKE '%misce%') " & _
                    "ORDER BY t.ToppingName"
                Using cmd As New SqlCommand(sql, cn)
                    currentItemsDataTable.Load(cmd.ExecuteReader())
                End Using
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "ToppingID"
                cmbItem.DataSource = currentItemsDataTable
                cmbItem.DropDownStyle = ComboBoxStyle.DropDown
                cmbItem.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cmbItem.AutoCompleteSource = AutoCompleteSource.ListItems
            End Using
        End Sub

        Private Sub BindAccessories()
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                currentItemsDataTable = New DataTable()
                ' Filter by consumables/miscellaneous category
                Dim sql As String = "SELECT a.AccessoryID, " & _
                    "(ISNULL(a.AccessoryCode,'') + CASE WHEN ISNULL(a.AccessoryCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(a.AccessoryName,'')) AS Display, " & _
                    "a.DefaultUoMID, a.AccessoryName " & _
                    "FROM dbo.Accessories a " & _
                    "LEFT JOIN dbo.ProductCategories pc ON a.CategoryID = pc.CategoryID " & _
                    "WHERE ISNULL(a.IsActive,1)=1 " & _
                    "  AND (pc.CategoryName LIKE '%consumable%' OR pc.CategoryName LIKE '%misce%') " & _
                    "ORDER BY a.AccessoryName"
                Using cmd As New SqlCommand(sql, cn)
                    currentItemsDataTable.Load(cmd.ExecuteReader())
                End Using
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "AccessoryID"
                cmbItem.DataSource = currentItemsDataTable
                cmbItem.DropDownStyle = ComboBoxStyle.DropDown
                cmbItem.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cmbItem.AutoCompleteSource = AutoCompleteSource.ListItems
            End Using
        End Sub

        Private Sub BindPackaging()
            Using cn As New SqlConnection(_connectionString)
                cn.Open()
                currentItemsDataTable = New DataTable()
                ' Filter by packaging category
                Dim sql As String = "SELECT p.PackagingID, " & _
                    "(ISNULL(p.PackagingCode,'') + CASE WHEN ISNULL(p.PackagingCode,'')<>'' THEN ' - ' ELSE '' END + ISNULL(p.PackagingName,'')) AS Display, " & _
                    "p.DefaultUoMID, p.PackagingName " & _
                    "FROM dbo.Packaging p " & _
                    "LEFT JOIN dbo.ProductCategories pc ON p.CategoryID = pc.CategoryID " & _
                    "WHERE ISNULL(p.IsActive,1)=1 " & _
                    "  AND pc.CategoryName LIKE '%packaging%' " & _
                    "ORDER BY p.PackagingName"
                Using cmd As New SqlCommand(sql, cn)
                    currentItemsDataTable.Load(cmd.ExecuteReader())
                End Using
                cmbItem.DataSource = Nothing
                cmbItem.DisplayMember = "Display"
                cmbItem.ValueMember = "PackagingID"
                cmbItem.DataSource = currentItemsDataTable
                cmbItem.DropDownStyle = ComboBoxStyle.DropDown
                cmbItem.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                cmbItem.AutoCompleteSource = AutoCompleteSource.ListItems
            End Using
        End Sub

        Private Sub OnItemChanged(sender As Object, e As EventArgs)
            Dim t = If(cmbType.SelectedItem, "").ToString()
            If cmbItem.SelectedValue Is Nothing Then Return
            Dim drv = TryCast(cmbItem.SelectedItem, DataRowView)
            If drv IsNot Nothing AndAlso drv.Row.Table.Columns.Contains("DefaultUoMID") AndAlso Not IsDBNull(drv("DefaultUoMID")) Then
                cmbUoM.SelectedValue = CInt(drv("DefaultUoMID"))
            End If
        End Sub

        Private Sub OnSearchTextChanged(sender As Object, e As EventArgs)
            If currentItemsDataTable Is Nothing OrElse currentItemsDataTable.Rows.Count = 0 Then Return
            
            Dim searchText = txtSearch.Text.Trim()
            If String.IsNullOrEmpty(searchText) Then
                ' Show all items
                cmbItem.DataSource = currentItemsDataTable
                Return
            End If
            
            ' Filter with wildcards on both sides
            Try
                Dim filterExpression = $"Display LIKE '%{searchText.Replace("'", "''")}%'"
                Dim filteredView = currentItemsDataTable.DefaultView
                filteredView.RowFilter = filterExpression
                
                ' Update combobox with filtered results
                cmbItem.DataSource = filteredView.ToTable()
            Catch ex As Exception
                ' If filter fails, show all
                cmbItem.DataSource = currentItemsDataTable
            End Try
        End Sub

    End Class

End Namespace
