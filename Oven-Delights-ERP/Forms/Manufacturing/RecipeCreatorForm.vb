Imports System.Windows.Forms
Imports System.Data
Imports Microsoft.Data.SqlClient
Imports System.Configuration

Namespace Manufacturing

Public Class RecipeCreatorForm
    Inherits Form

    Private ReadOnly _connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString

    Private cmbCategory As ComboBox
    Private cmbSubcategory As ComboBox
    Private txtProductName As TextBox
    Private txtSKU As TextBox
    Private txtProductID As TextBox

    Private numYield As NumericUpDown
    Private cmbYieldUoM As ComboBox

    Private chkUseLength As CheckBox
    Private chkUseWidth As CheckBox
    Private chkUseHeight As CheckBox
    Private chkUseDiameter As CheckBox
    Private chkUseLayers As CheckBox

    Private dgvComponents As DataGridView

    Private btnSave As Button
    Private btnClose As Button

    Public Sub New()
        Me.Text = "Recipe Creator"
        Me.Width = 1120
        Me.Height = 740
        Me.StartPosition = FormStartPosition.CenterParent
        InitializeUi()
        HookGridEvents()
        AddHandler Me.Load, AddressOf OnFormLoad
    End Sub

    Private Sub InitializeUi()
        ' Header panel
        Dim pnlHeader As New Panel() With {.Dock = DockStyle.Top, .Height = 120, .BackColor = Color.White}
        Dim header As New Label() With {
            .Text = "Create New Recipe & Product",
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

        Dim lblYield = New Label() With {.Text = "Default Yield:", .Left = 430, .Top = y, .AutoSize = True}
        numYield = New NumericUpDown() With {.Left = 520, .Top = y - 3, .Width = 100, .Minimum = 1, .Maximum = 100000, .DecimalPlaces = 2, .Value = 1}
        cmbYieldUoM = New ComboBox() With {.Left = 630, .Top = y - 3, .Width = 110, .DropDownStyle = ComboBoxStyle.DropDownList}

        pnlHeader.Controls.AddRange(New Control() {lblCategory, cmbCategory, lblSubcategory, cmbSubcategory, lblSKU, txtSKU, lblProductID, txtProductID, lblProduct, txtProductName, lblYield, numYield, cmbYieldUoM})

        ' Options panel
        Dim grpOptions As New GroupBox() With {.Text = "Dimensions / Layers", .Dock = DockStyle.Top, .Height = 58}
        chkUseLength = New CheckBox() With {.Text = "Length", .Left = 20, .Top = 22, .AutoSize = True}
        chkUseWidth = New CheckBox() With {.Text = "Width", .Left = 100, .Top = 22, .AutoSize = True}
        chkUseHeight = New CheckBox() With {.Text = "Height", .Left = 180, .Top = 22, .AutoSize = True}
        chkUseDiameter = New CheckBox() With {.Text = "Diameter", .Left = 260, .Top = 22, .AutoSize = True}
        chkUseLayers = New CheckBox() With {.Text = "Layers", .Left = 360, .Top = 22, .AutoSize = True}
        grpOptions.Controls.AddRange(New Control() {chkUseLength, chkUseWidth, chkUseHeight, chkUseDiameter, chkUseLayers})

        ' Components grid
        dgvComponents = New DataGridView() With {
            .Dock = DockStyle.Fill,
            .AllowUserToAddRows = True,
            .AllowUserToDeleteRows = True,
            .SelectionMode = DataGridViewSelectionMode.FullRowSelect,
            .MultiSelect = False,
            .AutoGenerateColumns = False,
            .BackgroundColor = Color.White
        }
        dgvComponents.ColumnHeadersDefaultCellStyle.BackColor = Color.Gainsboro
        dgvComponents.EnableHeadersVisualStyles = False

        Dim colType As New DataGridViewComboBoxColumn() With {.HeaderText = "Type", .Name = "ComponentType", .DataPropertyName = "ComponentType", .Width = 120}
        colType.Items.AddRange(New Object() {"Material", "SubAssembly", "Decoration"})
        dgvComponents.Columns.Add(colType)
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Component Ref (free text)", .Name = "ComponentRef", .DataPropertyName = "ComponentRef", .Width = 220})
        ' Dropdown for stockroom materials when Type = Material (strict, no free text)
        Dim colMaterial As New DataGridViewComboBoxColumn() With {
            .HeaderText = "Stockroom Material",
            .Name = "MaterialItem",
            .DataPropertyName = "MaterialItem",
            .Width = 260,
            .DisplayStyle = DataGridViewComboBoxDisplayStyle.DropDownButton
        }
        dgvComponents.Columns.Add(colMaterial)
        ' Dropdown for existing products when Type = SubAssembly (generic, optional)
        Dim colSubAsm As New DataGridViewComboBoxColumn() With {
            .HeaderText = "SubAssembly Product",
            .Name = "SubAssemblyProduct",
            .DataPropertyName = "SubAssemblyProduct",
            .Width = 240,
            .DisplayStyle = DataGridViewComboBoxDisplayStyle.DropDownButton
        }
        dgvComponents.Columns.Add(colSubAsm)
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Base Qty", .Name = "BaseQty", .DataPropertyName = "BaseQty", .Width = 90})
        dgvComponents.Columns.Add(New DataGridViewComboBoxColumn() With {.HeaderText = "UoM", .Name = "UoM", .DataPropertyName = "UoM", .Width = 90})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Scrap %", .Name = "ScrapPercent", .DataPropertyName = "ScrapPercent", .Width = 80})
        dgvComponents.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Optional", .Name = "IsOptional", .DataPropertyName = "IsOptional", .Width = 70})
        dgvComponents.Columns.Add(New DataGridViewCheckBoxColumn() With {.HeaderText = "Std Cost", .Name = "IncludeInStandardCost", .DataPropertyName = "IncludeInStandardCost", .Width = 70})
        Dim colScaling As New DataGridViewComboBoxColumn() With {.HeaderText = "Scaling", .Name = "ScalingRule", .DataPropertyName = "ScalingRule", .Width = 140}
        colScaling.Items.AddRange(New Object() {"FixedPerBatch", "PerUnit", "PerArea", "PerVolume", "PerLayer", "PerPerimeter"})
        dgvComponents.Columns.Add(colScaling)
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn() With {.HeaderText = "Notes", .Name = "Notes", .DataPropertyName = "Notes", .AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill})

        ' Footer panel
        Dim pnlFooter As New Panel() With {.Dock = DockStyle.Bottom, .Height = 56, .BackColor = Color.White}
        btnSave = New Button() With {.Text = "Save", .Width = 100, .Height = 32, .Left = Me.ClientSize.Width - 220, .Top = 12, .Anchor = AnchorStyles.Right Or AnchorStyles.Bottom}
        btnClose = New Button() With {.Text = "Close", .Width = 100, .Height = 32, .Left = Me.ClientSize.Width - 110, .Top = 12, .Anchor = AnchorStyles.Right Or AnchorStyles.Bottom}
        AddHandler btnClose.Click, Sub(s, e) Me.Close()
        AddHandler btnSave.Click, AddressOf OnSave
        pnlFooter.Controls.AddRange(New Control() {btnSave, btnClose})

        ' Compose
        Me.Controls.Add(dgvComponents)
        Me.Controls.Add(grpOptions)
        Me.Controls.Add(pnlHeader)
        Me.Controls.Add(pnlFooter)
    End Sub

    Private productsDt As DataTable

    Private Sub HookGridEvents()
        AddHandler dgvComponents.CurrentCellDirtyStateChanged, Sub()
            If dgvComponents.IsCurrentCellDirty Then dgvComponents.CommitEdit(DataGridViewDataErrorContexts.Commit)
        End Sub
        AddHandler dgvComponents.CellValueChanged, AddressOf OnGridCellValueChanged
    End Sub

    Private Sub OnFormLoad(sender As Object, e As EventArgs)
        Try
            LoadUoM()
            LoadCategories()
            LoadMaterials()
            LoadProducts()
            BindProductsToGrid()
            BindMaterialsToGrid()
        Catch ex As Exception
            MessageBox.Show("Failed to load lists: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadCategories()
        Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
            cn.Open()
            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT CategoryID, CategoryName FROM dbo.ProductCategories WHERE IsActive=1 ORDER BY CategoryName", cn)
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                cmbCategory.DisplayMember = "CategoryName"
                cmbCategory.ValueMember = "CategoryID"
                cmbCategory.DataSource = dt
            End Using
        End Using
        If cmbCategory.Items.Count > 0 Then cmbCategory.SelectedIndex = 0
    End Sub

    Private Sub LoadSubcategories(categoryId As Integer)
        Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
            cn.Open()
            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT SubcategoryID, SubcategoryName FROM dbo.ProductSubcategories WHERE IsActive=1 AND CategoryID=@cid ORDER BY SubcategoryName", cn)
                cmd.Parameters.AddWithValue("@cid", categoryId)
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                cmbSubcategory.DisplayMember = "SubcategoryName"
                cmbSubcategory.ValueMember = "SubcategoryID"
                cmbSubcategory.DataSource = dt
            End Using
        End Using
        If cmbSubcategory.Items.Count > 0 Then cmbSubcategory.SelectedIndex = 0
    End Sub

    Private Sub LoadUoM()
        Dim dt As New DataTable()
        Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
            cn.Open()
            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT UoMID, UoMCode FROM dbo.UoM ORDER BY UoMCode", cn)
                dt.Load(cmd.ExecuteReader())
            End Using
        End Using
        cmbYieldUoM.DisplayMember = "UoMCode"
        cmbYieldUoM.ValueMember = "UoMID"
        cmbYieldUoM.DataSource = dt.Copy()

        ' Also apply to grid UoM column
        Dim uomCol = TryCast(dgvComponents.Columns("UoM"), DataGridViewComboBoxColumn)
        If uomCol IsNot Nothing Then
            uomCol.DisplayMember = "UoMCode"
            uomCol.ValueMember = "UoMID"
            uomCol.DataSource = dt
        End If
    End Sub

    Private Sub LoadProducts()
        productsDt = New DataTable()
        Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
            cn.Open()
            ' Products table uses BaseUoM (varchar) not DefaultUoMID - always use fallback
            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT p.ProductID, ISNULL(p.SKU, p.ProductCode) AS SKU, p.ProductName, u.UoMID AS DefaultUoMID FROM dbo.Products p LEFT JOIN dbo.UoM u ON u.UoMCode = p.BaseUoM WHERE p.IsActive=1 ORDER BY p.ProductName", cn)
                productsDt.Load(cmd.ExecuteReader())
            End Using
        End Using
        ' Add display column: SKU - Name
        If Not productsDt.Columns.Contains("Display") Then
            productsDt.Columns.Add("Display", GetType(String))
        End If
        For Each r As DataRow In productsDt.Rows
            Dim sku As String = If(TryCast(r("SKU"), String), String.Empty)
            Dim name As String = If(TryCast(r("ProductName"), String), String.Empty)
            r("Display") = (If(String.IsNullOrWhiteSpace(sku), name, (sku & " - " & name))).Trim()
        Next
    End Sub

    Private Sub BindProductsToGrid()
        Dim col = TryCast(dgvComponents.Columns("SubAssemblyProduct"), DataGridViewComboBoxColumn)
        If col Is Nothing Then Return
        col.DisplayMember = "Display"
        col.ValueMember = "ProductID"
        col.DataSource = productsDt
    End Sub

    Private materialsDt As DataTable

    Private Sub LoadMaterials()
        materialsDt = New DataTable()
        Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
            cn.Open()
            ' Join to UoM to resolve DefaultUoMID from BaseUnit code if available
            Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT m.MaterialID, m.MaterialCode, m.MaterialName, u.UoMID AS DefaultUoMID FROM dbo.RawMaterials m LEFT JOIN dbo.UoM u ON u.UoMCode = m.BaseUnit WHERE m.IsActive = 1 ORDER BY m.MaterialName", cn)
                materialsDt.Load(cmd.ExecuteReader())
            End Using
        End Using
        If Not materialsDt.Columns.Contains("Display") Then materialsDt.Columns.Add("Display", GetType(String))
        For Each r As DataRow In materialsDt.Rows
            Dim code As String = If(TryCast(r("MaterialCode"), String), String.Empty)
            Dim name As String = If(TryCast(r("MaterialName"), String), String.Empty)
            r("Display") = (If(String.IsNullOrWhiteSpace(code), name, (code & " - " & name))).Trim()
        Next
    End Sub

    Private Sub BindMaterialsToGrid()
        Dim col = TryCast(dgvComponents.Columns("MaterialItem"), DataGridViewComboBoxColumn)
        If col Is Nothing Then Return
        col.DisplayMember = "Display"
        col.ValueMember = "MaterialID"
        col.DataSource = materialsDt
    End Sub

    Private Sub OnGridCellValueChanged(sender As Object, e As DataGridViewCellEventArgs)
        If e.RowIndex < 0 Then Return
        Dim row = dgvComponents.Rows(e.RowIndex)
        If dgvComponents.Columns(e.ColumnIndex).Name = "ComponentType" Then
            ' When type changes, clear SubAssembly selection if not SubAssembly
            Dim compType = Convert.ToString(row.Cells("ComponentType").Value)
            Dim isSubAsm As Boolean = String.Equals(compType, "SubAssembly", StringComparison.OrdinalIgnoreCase)
            If Not isSubAsm Then
                row.Cells("SubAssemblyProduct").Value = Nothing
            End If
            Dim isMaterial As Boolean = String.Equals(compType, "Material", StringComparison.OrdinalIgnoreCase)
            If Not isMaterial Then
                row.Cells("MaterialItem").Value = Nothing
            End If
        ElseIf dgvComponents.Columns(e.ColumnIndex).Name = "SubAssemblyProduct" Then
            ' If UoM not specified, set to product default UoM
            Dim uCell = row.Cells("UoM")
            Dim uomIsEmpty As Boolean = (uCell.Value Is Nothing OrElse (TypeOf uCell.Value Is String AndAlso String.IsNullOrWhiteSpace(CStr(uCell.Value))) OrElse (TypeOf uCell.Value Is DBNull))
            Dim val = row.Cells("SubAssemblyProduct").Value
            If uomIsEmpty AndAlso val IsNot Nothing AndAlso Integer.TryParse(val.ToString(), Nothing) Then
                Dim pid As Integer = CInt(val)
                Dim found = productsDt.Select("ProductID = " & pid)
                If found IsNot Nothing AndAlso found.Length > 0 Then
                    Dim defaultUom As Object = found(0)("DefaultUoMID")
                    If defaultUom IsNot Nothing AndAlso defaultUom IsNot DBNull.Value Then
                        uCell.Value = CInt(defaultUom)
                    End If
                End If
            End If
        ElseIf dgvComponents.Columns(e.ColumnIndex).Name = "MaterialItem" Then
            ' If UoM not specified, set to material base UoM
            Dim uCell = row.Cells("UoM")
            Dim uomIsEmpty As Boolean = (uCell.Value Is Nothing OrElse (TypeOf uCell.Value Is String AndAlso String.IsNullOrWhiteSpace(CStr(uCell.Value))) OrElse (TypeOf uCell.Value Is DBNull))
            Dim val = row.Cells("MaterialItem").Value
            If uomIsEmpty AndAlso val IsNot Nothing AndAlso Integer.TryParse(val.ToString(), Nothing) Then
                Dim mid As Integer = CInt(val)
                Dim found = materialsDt.Select("MaterialID = " & mid)
                If found IsNot Nothing AndAlso found.Length > 0 Then
                    Dim defaultUom As Object = found(0)("DefaultUoMID")
                    If defaultUom IsNot Nothing AndAlso defaultUom IsNot DBNull.Value Then
                        uCell.Value = CInt(defaultUom)
                    End If
                End If
            End If
        End If
    End Sub

    Private Sub OnCategoryChanged(sender As Object, e As EventArgs)
        If cmbCategory.SelectedValue Is Nothing Then Return
        Dim cid As Integer = CInt(cmbCategory.SelectedValue)
        LoadSubcategories(cid)
    End Sub

    Private Function GetCurrentUserId() As Integer
        Try
            Return If(AppSession.CurrentUserID > 0, AppSession.CurrentUserID, 0)
        Catch
            Return 0
        End Try
    End Function

    Private Sub OnSave(sender As Object, e As EventArgs)
        ' Basic validation
        If cmbCategory.SelectedValue Is Nothing OrElse cmbSubcategory.SelectedValue Is Nothing Then
            MessageBox.Show("Please select a Category and Subcategory.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If String.IsNullOrWhiteSpace(txtProductName.Text) Then
            MessageBox.Show("Please enter a Product name.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If String.IsNullOrWhiteSpace(txtSKU.Text) Then
            MessageBox.Show("Please enter an SKU.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        If cmbYieldUoM.SelectedValue Is Nothing Then
            MessageBox.Show("Please choose a Yield UoM.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim userId As Integer = GetCurrentUserId()
        If userId = 0 Then
            MessageBox.Show("No active user session found.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim subcategoryId As Integer = CInt(cmbSubcategory.SelectedValue)
        Dim productId As Integer
        Dim recipeTemplateId As Integer

        Using cn As New Microsoft.Data.SqlClient.SqlConnection(_connectionString)
            cn.Open()
            Using tx = cn.BeginTransaction()
                Try
                    ' 1) Ensure Product exists
                    Dim hasSku As Boolean
                    Using cmdCheck As New Microsoft.Data.SqlClient.SqlCommand("SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='Products' AND COLUMN_NAME='SKU') THEN 1 ELSE 0 END", cn, tx)
                        hasSku = (Convert.ToInt32(cmdCheck.ExecuteScalar()) = 1)
                    End Using
                    Dim uomCode As String = ""
                    Using cmdUom As New Microsoft.Data.SqlClient.SqlCommand("SELECT UoMCode FROM dbo.UoM WHERE UoMID=@id", cn, tx)
                        cmdUom.Parameters.AddWithValue("@id", CInt(cmbYieldUoM.SelectedValue))
                        Dim o = cmdUom.ExecuteScalar()
                        If o IsNot Nothing AndAlso o IsNot DBNull.Value Then uomCode = Convert.ToString(o)
                    End Using
                    If hasSku Then
                        ' Schema with SKU
                        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("IF EXISTS (SELECT 1 FROM dbo.Products WHERE SKU=@sku) SELECT ProductID FROM dbo.Products WHERE SKU=@sku ELSE BEGIN INSERT INTO dbo.Products (SKU, ProductName, BaseUoM, ItemType, CategoryID, SubcategoryID, IsActive) VALUES (@sku, @pname, @uom, 'Manufactured', @cid, @sid, 1); SELECT SCOPE_IDENTITY(); END", cn, tx)
                            cmd.Parameters.AddWithValue("@sku", txtSKU.Text.Trim())
                            cmd.Parameters.AddWithValue("@pname", txtProductName.Text.Trim())
                            cmd.Parameters.AddWithValue("@uom", If(String.IsNullOrWhiteSpace(uomCode), "ea", uomCode))
                            cmd.Parameters.AddWithValue("@cid", cmbCategory.SelectedValue)
                            cmd.Parameters.AddWithValue("@sid", cmbSubcategory.SelectedValue)
                            productId = Convert.ToInt32(cmd.ExecuteScalar())
                        End Using
                    Else
                        ' Schema with ProductCode and BaseUoM (cannot safely insert without ProductCategories mapping). Require pre-existing product.
                        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT ProductID FROM dbo.Products WHERE ProductCode=@code", cn, tx)
                            cmd.Parameters.AddWithValue("@code", txtSKU.Text.Trim())
                            Dim obj = cmd.ExecuteScalar()
                            If obj Is Nothing OrElse obj Is DBNull.Value Then
                                MessageBox.Show("Product not found in Products (by ProductCode). Please create the product first, or switch to a database schema with SKU.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                                tx.Rollback()
                                Return
                            End If
                            productId = Convert.ToInt32(obj)
                        End Using
                    End If

                    ' 2) Insert RecipeTemplate
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand("INSERT INTO dbo.RecipeTemplate (SubcategoryID, TemplateName, DefaultYieldQty, DefaultYieldUoMID, BranchID, IsActive, CreatedBy) VALUES (@sid, @tname, @yqty, @yuom, NULL, 1, @uid); SELECT SCOPE_IDENTITY();", cn, tx)
                        cmd.Parameters.AddWithValue("@sid", subcategoryId)
                        cmd.Parameters.AddWithValue("@tname", txtProductName.Text.Trim())
                        cmd.Parameters.AddWithValue("@yqty", Decimal.Parse(numYield.Value.ToString()))
                        cmd.Parameters.AddWithValue("@yuom", CInt(cmbYieldUoM.SelectedValue))
                        cmd.Parameters.AddWithValue("@uid", userId)
                        recipeTemplateId = Convert.ToInt32(cmd.ExecuteScalar())
                    End Using

                    ' 3) Insert RecipeParameters
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand("INSERT INTO dbo.RecipeParameters (RecipeTemplateID, UseLength, UseWidth, UseHeight, UseDiameter, UseLayers) VALUES (@rid, @ul, @uw, @uh, @ud, @uly)", cn, tx)
                        cmd.Parameters.AddWithValue("@rid", recipeTemplateId)
                        cmd.Parameters.AddWithValue("@ul", chkUseLength.Checked)
                        cmd.Parameters.AddWithValue("@uw", chkUseWidth.Checked)
                        cmd.Parameters.AddWithValue("@uh", chkUseHeight.Checked)
                        cmd.Parameters.AddWithValue("@ud", chkUseDiameter.Checked)
                        cmd.Parameters.AddWithValue("@uly", chkUseLayers.Checked)
                        cmd.ExecuteNonQuery()
                    End Using

                    ' 4) Insert components (if any rows)
                    Dim lineNo As Integer = 1
                    For Each row As DataGridViewRow In dgvComponents.Rows
                        If row.IsNewRow Then Continue For
                        Dim compType = Convert.ToString(row.Cells("ComponentType").Value)
                        If String.IsNullOrWhiteSpace(compType) Then Continue For

                        Dim baseQty As Decimal = 0
                        Decimal.TryParse(Convert.ToString(row.Cells("BaseQty").Value), baseQty)
                        Dim uomObj = row.Cells("UoM").Value
                        Dim uomId As Integer = If(uomObj IsNot Nothing AndAlso Integer.TryParse(uomObj.ToString(), Nothing), CInt(uomObj), 0)
                        If uomId = 0 Then uomId = CInt(cmbYieldUoM.SelectedValue)

                        Dim scrap As Decimal = 0
                        Decimal.TryParse(Convert.ToString(row.Cells("ScrapPercent").Value), scrap)
                        Dim isOpt As Boolean = False
                        If row.Cells("IsOptional").Value IsNot Nothing Then Boolean.TryParse(row.Cells("IsOptional").Value.ToString(), isOpt)
                        Dim inStd As Boolean = True
                        If row.Cells("IncludeInStandardCost").Value IsNot Nothing Then Boolean.TryParse(row.Cells("IncludeInStandardCost").Value.ToString(), inStd)
                        Dim scaling As String = If(TryCast(row.Cells("ScalingRule").Value, String), "FixedPerBatch")
                        Dim notes As String = If(TryCast(row.Cells("Notes").Value, String), Nothing)

                        ' Resolve IDs
                        Dim materialId As Object = DBNull.Value
                        Dim subAsmId As Object = DBNull.Value

                        Dim refText As String = Convert.ToString(row.Cells("ComponentRef").Value)
                        If compType IsNot Nothing Then
                            Dim c As String = compType.Trim().ToLowerInvariant()
                            If c = "subassembly" Then
                                ' Prefer dropdown selection; free text leaves SubAssemblyProductID NULL
                                Dim selected = row.Cells("SubAssemblyProduct").Value
                                If selected IsNot Nothing AndAlso Integer.TryParse(selected.ToString(), Nothing) Then
                                    Dim resolvedId As Integer = CInt(selected)
                                    subAsmId = resolvedId
                                    If uomId = 0 Then
                                        Dim found = productsDt.Select("ProductID = " & resolvedId)
                                        If found IsNot Nothing AndAlso found.Length > 0 Then
                                            Dim objU = found(0)("DefaultUoMID")
                                            If objU IsNot Nothing AndAlso objU IsNot DBNull.Value Then
                                                uomId = CInt(objU)
                                            End If
                                        End If
                                    End If
                                End If
                            ElseIf c = "material" Then
                                Dim selected = row.Cells("MaterialItem").Value
                                If selected IsNot Nothing AndAlso Integer.TryParse(selected.ToString(), Nothing) Then
                                    materialId = CInt(selected)
                                    ' Set UoM if still empty from material default
                                    If uomId = 0 Then
                                        Dim found = materialsDt.Select("MaterialID = " & CInt(selected))
                                        If found IsNot Nothing AndAlso found.Length > 0 Then
                                            Dim objU = found(0)("DefaultUoMID")
                                            If objU IsNot Nothing AndAlso objU IsNot DBNull.Value Then
                                                uomId = CInt(objU)
                                            End If
                                        End If
                                    End If
                                End If
                            End If
                        End If

                        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("INSERT INTO dbo.RecipeComponent (RecipeTemplateID, [LineNo], ComponentType, MaterialID, SubAssemblyProductID, BaseQty, UoMID, ScrapPercent, IsOptional, IncludeInStandardCost, ScalingRule, Notes) VALUES (@rid, @ln, @ctype, @mat, @sub, @bq, @uom, @scrap, @opt, @std, @sc, @notes)", cn, tx)
                            cmd.Parameters.AddWithValue("@rid", recipeTemplateId)
                            cmd.Parameters.AddWithValue("@ln", lineNo)
                            cmd.Parameters.AddWithValue("@ctype", compType)
                            cmd.Parameters.AddWithValue("@mat", materialId)
                            cmd.Parameters.AddWithValue("@sub", subAsmId)
                            cmd.Parameters.AddWithValue("@bq", baseQty)
                            cmd.Parameters.AddWithValue("@uom", uomId)
                            cmd.Parameters.AddWithValue("@scrap", scrap)
                            cmd.Parameters.AddWithValue("@opt", isOpt)
                            cmd.Parameters.AddWithValue("@std", inStd)
                            cmd.Parameters.AddWithValue("@sc", scaling)
                            cmd.Parameters.AddWithValue("@notes", If(notes, CType(DBNull.Value, Object)))
                            cmd.ExecuteNonQuery()
                        End Using
                        lineNo += 1
                    Next

                    ' 5) Link Product <-> RecipeTemplate
                    Using cmd As New Microsoft.Data.SqlClient.SqlCommand("IF NOT EXISTS (SELECT 1 FROM dbo.ProductRecipe WHERE ProductID=@pid AND RecipeTemplateID=@rid) INSERT INTO dbo.ProductRecipe (ProductID, RecipeTemplateID, CreatedBy) VALUES (@pid, @rid, @uid)", cn, tx)
                        cmd.Parameters.AddWithValue("@pid", productId)
                        cmd.Parameters.AddWithValue("@rid", recipeTemplateId)
                        cmd.Parameters.AddWithValue("@uid", userId)
                        cmd.ExecuteNonQuery()
                    End Using

                    ' Update ProductID field in UI
                    txtProductID.Text = productId.ToString()

                    tx.Commit()
                    MessageBox.Show("Recipe and Product saved successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    Me.Close()
                Catch ex As Microsoft.Data.SqlClient.SqlException
                    Try
                        tx.Rollback()
                    Catch
                    End Try
                    MessageBox.Show("Save failed: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                End Try
            End Using
        End Using
    End Sub

    Private Function ColumnExists(cn As Microsoft.Data.SqlClient.SqlConnection, tx As Microsoft.Data.SqlClient.SqlTransaction, tableName As String, columnName As String) As Boolean
        Using cmd As New Microsoft.Data.SqlClient.SqlCommand("SELECT CASE WHEN EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME=@t AND COLUMN_NAME=@c) THEN 1 ELSE 0 END", cn, tx)
            cmd.Parameters.AddWithValue("@t", tableName)
            cmd.Parameters.AddWithValue("@c", columnName)
            Return Convert.ToInt32(cmd.ExecuteScalar()) = 1
        End Using
    End Function
End Class

End Namespace
