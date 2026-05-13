Imports System.Data.SqlClient
Imports System.Configuration

Public Class CreateProductRecipeForm

    Private ReadOnly _connectionString As String
    Private _recipeService As RecipeCostCalculationService
    Private _currentBranchID As Integer
    Private _currentUserID As Integer
    Private _selectedProductID As Integer = 0
    Private _isLoading As Boolean = True

    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _recipeService = New RecipeCostCalculationService()
        _currentBranchID = AppSession.CurrentUser.BranchID
        _currentUserID = AppSession.CurrentUser.UserID
        
        ' Setup grids immediately after InitializeComponent to ensure columns exist
        SetupGridColumns()
    End Sub

    Private Sub CreateProductRecipeForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        _isLoading = True
        SetupForm()
        LoadProducts()
        LoadComponents()
        AddHandler txtBatchQty.TextChanged, AddressOf txtBatchQty_TextChanged
        AddHandler chkShowConsolidated.CheckedChanged, AddressOf chkShowConsolidated_CheckedChanged
        _isLoading = False
    End Sub
    
    Private Sub chkShowConsolidated_CheckedChanged(sender As Object, e As EventArgs)
        grpConsolidated.Visible = chkShowConsolidated.Checked
    End Sub
    
    Private Sub SetupGridColumns()
        ' Setup dgvComponents columns
        dgvComponents.AutoGenerateColumns = False
        dgvComponents.AllowUserToAddRows = False
        dgvComponents.Columns.Clear()
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "BOMLineID", .HeaderText = "ID", .Visible = False})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentID", .HeaderText = "Component ID", .Visible = False})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentType", .HeaderText = "Type", .Visible = False})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentName", .HeaderText = "Component", .Width = 300, .ReadOnly = True})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Category", .HeaderText = "Category", .Width = 120, .ReadOnly = True})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Quantity", .Width = 100, .ReadOnly = False})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost Per Unit", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
        dgvComponents.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
        dgvComponents.Columns.Add(New DataGridViewButtonColumn With {.Name = "Edit", .HeaderText = "Edit", .Text = "Edit", .UseColumnTextForButtonValue = True, .Width = 70})
        dgvComponents.Columns.Add(New DataGridViewButtonColumn With {.Name = "Delete", .HeaderText = "Delete", .Text = "Delete", .UseColumnTextForButtonValue = True, .Width = 70})
        
        ' Setup dgvConsolidatedBOM columns
        dgvConsolidatedBOM.AutoGenerateColumns = False
        dgvConsolidatedBOM.AllowUserToAddRows = False
        dgvConsolidatedBOM.Columns.Clear()
        dgvConsolidatedBOM.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "IngredientName", .HeaderText = "Ingredient", .Width = 300, .ReadOnly = True})
        dgvConsolidatedBOM.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalQuantity", .HeaderText = "Total Quantity", .Width = 150, .ReadOnly = True})
        dgvConsolidatedBOM.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitOfMeasure", .HeaderText = "Unit", .Width = 100, .ReadOnly = True})
        dgvConsolidatedBOM.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost/Unit", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C6"}})
        dgvConsolidatedBOM.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
    End Sub
    
    Private Sub txtBatchQty_TextChanged(sender As Object, e As EventArgs)
        CalculateTotalCost()
    End Sub

    Private Sub SetupForm()
        Me.Text = "Create Product Recipe - WOW FACTOR"
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = Color.FromArgb(240, 240, 245)

        ' Apply styling to grids (columns already set up in constructor)
        ApplyGridStyling(dgvComponents, "Components")
        ApplyGridStyling(dgvConsolidatedBOM, "Consolidated")

        txtBatchQty.Text = "1"
        txtMethod.Font = New Font("Segoe UI", 10)
    End Sub
    
    Private Sub ApplyGridStyling(grid As DataGridView, gridType As String)
        ' Apply visual styling only - do NOT clear columns
        grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        grid.MultiSelect = False
        grid.RowHeadersVisible = False
        grid.BackgroundColor = Color.White
        grid.BorderStyle = BorderStyle.None
        grid.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        grid.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
        grid.DefaultCellStyle.SelectionForeColor = Color.White
        grid.EnableHeadersVisualStyles = False
        grid.ColumnHeadersDefaultCellStyle.BackColor = If(gridType = "Components", Color.FromArgb(39, 174, 96), Color.FromArgb(52, 73, 94))
        grid.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        grid.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        grid.ColumnHeadersHeight = 40
    End Sub

    Private Sub SetupGrid(grid As DataGridView, gridType As String)
        grid.AutoGenerateColumns = False
        grid.AllowUserToAddRows = False
        grid.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        grid.MultiSelect = False
        grid.RowHeadersVisible = False
        grid.BackgroundColor = Color.White
        grid.BorderStyle = BorderStyle.None
        grid.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        grid.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
        grid.DefaultCellStyle.SelectionForeColor = Color.White
        grid.EnableHeadersVisualStyles = False
        grid.ColumnHeadersDefaultCellStyle.BackColor = If(gridType = "Components", Color.FromArgb(39, 174, 96), Color.FromArgb(52, 73, 94))
        grid.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        grid.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        grid.ColumnHeadersHeight = 40

        grid.Columns.Clear()

        If gridType = "Components" Then
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "BOMLineID", .HeaderText = "ID", .Visible = False})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentID", .HeaderText = "Component ID", .Visible = False})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentType", .HeaderText = "Type", .Visible = False})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentName", .HeaderText = "Component", .Width = 300, .ReadOnly = True})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Category", .HeaderText = "Category", .Width = 120, .ReadOnly = True})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Quantity", .Width = 100})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost Per Unit", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
            Dim btnEdit As New DataGridViewButtonColumn With {.Name = "Edit", .HeaderText = "Edit", .Text = "Edit", .UseColumnTextForButtonValue = True, .Width = 70}
            grid.Columns.Add(btnEdit)
            Dim btnDelete As New DataGridViewButtonColumn With {.Name = "Delete", .HeaderText = "Delete", .Text = "Delete", .UseColumnTextForButtonValue = True, .Width = 70}
            grid.Columns.Add(btnDelete)
        Else
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "IngredientName", .HeaderText = "Ingredient", .Width = 300, .ReadOnly = True})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalQuantity", .HeaderText = "Total Quantity", .Width = 150, .ReadOnly = True})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitOfMeasure", .HeaderText = "Unit", .Width = 100, .ReadOnly = True})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost/Unit", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C6"}})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
        End If
    End Sub

    Private Sub LoadProducts()
        Dim dt As New DataTable()
        dt.Columns.Add("ProductID", GetType(Integer))
        dt.Columns.Add("Name", GetType(String))

        Using conn As New SqlConnection(_connectionString)
            ' ALWAYS use ProductID from Branch 6 (master branch) for recipes
            ' This makes recipes universal across all branches
            Dim query As String = "
                SELECT ProductID, Name
                FROM Demo_Retail_Product
                WHERE IsActive = 1
                  AND BranchID = 6
                  AND Category NOT LIKE '%ingredient%'
                  AND Category NOT LIKE '%sub%recipe%'
                  AND Category NOT LIKE '%subrecipe%'
                  AND Category NOT LIKE '%consumable%'
                  AND Category NOT LIKE '%pack%'
                  AND Category NOT LIKE '%misce%'
                ORDER BY Name"

            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        dt.Rows.Add(reader.GetInt32(0), reader.GetString(1))
                    End While
                End Using
            End Using
        End Using
        
        cboProduct.DataSource = Nothing
        cboProduct.DisplayMember = "Name"
        cboProduct.ValueMember = "ProductID"
        cboProduct.DataSource = dt
    End Sub

    Private Sub LoadComponents()
        Dim dt As New DataTable()
        dt.Columns.Add("ProductID", GetType(Integer))
        dt.Columns.Add("Name", GetType(String))
        dt.Columns.Add("Category", GetType(String))

        Using conn As New SqlConnection(_connectionString)
            ' Load ingredients/consumables from current branch, sub-recipes from Branch 6 (master)
            ' Recipes are universal across all branches
            Dim query As String = "
                SELECT p.ProductID, p.Name, p.Category
                FROM Demo_Retail_Product p
                LEFT JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%')
                WHERE p.IsActive = 1
                  AND (
                    (p.BranchID = @BranchID AND (p.Category LIKE '%ingredient%' OR p.Category LIKE '%consumable%' OR p.Category LIKE '%pack%' OR p.Category LIKE '%misce%')) OR
                    (p.BranchID = 6 AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%') AND sr.SubRecipeID IS NOT NULL)
                  )
                ORDER BY p.Category, p.Name"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        dt.Rows.Add(reader.GetInt32(0), reader.GetString(1), reader.GetString(2))
                    End While
                End Using
            End Using
        End Using
        
        cboComponent.DataSource = Nothing
        cboComponent.DisplayMember = "Name"
        cboComponent.ValueMember = "ProductID"
        cboComponent.DataSource = dt
    End Sub

    Private Sub cboProduct_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboProduct.SelectedIndexChanged
        If _isLoading Then Return
        If cboProduct.SelectedValue Is Nothing Then Return
        If Not IsNumeric(cboProduct.SelectedValue) Then Return

        _selectedProductID = CInt(cboProduct.SelectedValue)

        If _recipeService.CheckProductRecipeExists(_selectedProductID) Then
            Dim result = MessageBox.Show(
                "A recipe already exists for this product. Do you want to edit it?",
                "Recipe Exists",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question)

            If result = DialogResult.Yes Then
                LoadExistingRecipe()
            Else
                cboProduct.SelectedIndex = -1
                _selectedProductID = 0
            End If
        End If
    End Sub

    Private Sub LoadExistingRecipe()
        Dim details = _recipeService.GetProductRecipeDetails(_selectedProductID)
        If details IsNot Nothing Then
            txtMethod.Text = If(IsDBNull(details("Method")), "", details("Method").ToString())
            txtBatchQty.Text = details("BatchQty").ToString()
        End If

        Dim dt = _recipeService.GetProductBOMComponents(_selectedProductID)
        dgvComponents.Rows.Clear()

        For Each row As DataRow In dt.Rows
            Dim componentID As Integer = CInt(row("ComponentID"))
            Dim category As String = GetComponentCategory(componentID)
            Dim componentType As String = row("ComponentType").ToString()
            
            dgvComponents.Rows.Add(
                row("BOMLineID"),
                componentID,
                componentType,
                row("ComponentName"),
                category,
                row("Quantity"),
                row("CostPerUnit"),
                row("TotalCost")
            )
        Next

        LoadConsolidatedBOM()
        CalculateTotalCost()
    End Sub

    Private Function GetComponentCategory(componentID As Integer) As String
        Dim category As String = ""
        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "SELECT TOP 1 Category FROM Demo_Retail_Product WHERE ProductID = @ProductID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ProductID", componentID)
                conn.Open()
                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing Then
                    category = result.ToString()
                End If
            End Using
        End Using
        Return category
    End Function

    Private Sub btnAddComponent_Click(sender As Object, e As EventArgs) Handles btnAddComponent.Click
        If cboComponent.SelectedValue Is Nothing Then
            MessageBox.Show("Please select a component.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If Not IsNumeric(txtComponentQty.Text) OrElse CDec(txtComponentQty.Text) <= 0 Then
            MessageBox.Show("Please enter a valid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim componentID As Integer = CInt(cboComponent.SelectedValue)
        Dim componentName As String = cboComponent.Text
        Dim quantity As Decimal = CDec(txtComponentQty.Text)
        Dim category As String = CType(cboComponent.SelectedItem, DataRowView)("Category").ToString()

        ' Check if it's a sub-recipe and validate it has a recipe
        If category.ToLower().Contains("sub") AndAlso category.ToLower().Contains("recipe") Then
            If Not _recipeService.CheckSubRecipeExists(componentID) Then
                MessageBox.Show($"Recipe for '{componentName}' has not been created yet.{Environment.NewLine}{Environment.NewLine}Please create the sub-recipe first before adding it to the product.",
                    "Sub-Recipe Not Found", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If
        End If

        ' Check for duplicates
        For Each row As DataGridViewRow In dgvComponents.Rows
            If row.Cells("ComponentID").Value IsNot Nothing AndAlso CInt(row.Cells("ComponentID").Value) = componentID Then
                MessageBox.Show("This component is already added.", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
        Next

        ' Get cost based on component type
        Dim costPerUnit As Decimal = 0
        Dim componentType As String = ""
        
        If category.ToLower().Contains("sub") AndAlso category.ToLower().Contains("recipe") Then
            costPerUnit = _recipeService.GetSubRecipeCostPerUnit(componentID)
            componentType = "SubRecipe"
        Else
            costPerUnit = GetComponentCost(componentID)
            componentType = "Other"
        End If

        Dim totalCost As Decimal = quantity * costPerUnit

        dgvComponents.Rows.Add(0, componentID, componentType, componentName, category, quantity, costPerUnit, totalCost)

        txtComponentQty.Clear()
        cboComponent.SelectedIndex = -1

        LoadConsolidatedBOM()
        CalculateTotalCost()
    End Sub

    Private Function GetComponentCost(componentID As Integer) As Decimal
        Dim cost As Decimal = 0

        Using conn As New SqlConnection(_connectionString)
            ' Get cost from Demo_Retail_Price.CostPrice (same logic as EditPurchaseOrderForm)
            ' Use current user's BranchID to match the ProductID loaded from that branch
            Dim query As String = "
                SELECT TOP 1 ISNULL(rp.CostPrice, 0)
                FROM Demo_Retail_Product p
                LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
                WHERE p.ProductID = @ProductID
                  AND p.BranchID = @BranchID"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ProductID", componentID)
                cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                conn.Open()

                Dim result = cmd.ExecuteScalar()
                If result IsNot Nothing AndAlso Not IsDBNull(result) Then
                    cost = Convert.ToDecimal(result)
                End If
            End Using
        End Using

        Return cost
    End Function

    Private Sub dgvComponents_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvComponents.CellContentClick
        If e.RowIndex < 0 Then Return

        Dim row = dgvComponents.Rows(e.RowIndex)
        Dim componentType As String = row.Cells("ComponentType").Value.ToString()
        Dim componentID As Integer = CInt(row.Cells("ComponentID").Value)
        Dim componentName As String = row.Cells("ComponentName").Value.ToString()

        If dgvComponents.Columns(e.ColumnIndex).Name = "Edit" Then
            ' Only allow editing sub-recipes
            If componentType = "SubRecipe" Then
                Dim editForm As New EditSubRecipeForm(componentID, componentName)
                If editForm.ShowDialog() = DialogResult.OK Then
                    ' Refresh cost per unit after editing
                    Dim newCostPerUnit As Decimal = _recipeService.GetSubRecipeCostPerUnit(componentID)
                    Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                    row.Cells("CostPerUnit").Value = newCostPerUnit
                    row.Cells("TotalCost").Value = quantity * newCostPerUnit
                    
                    LoadConsolidatedBOM()
                    CalculateTotalCost()
                End If
            Else
                MessageBox.Show("Only sub-recipes can be edited from here.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        ElseIf dgvComponents.Columns(e.ColumnIndex).Name = "Delete" Then
            Dim result = MessageBox.Show($"Are you sure you want to delete '{componentName}'?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                dgvComponents.Rows.RemoveAt(e.RowIndex)
                LoadConsolidatedBOM()
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub dgvComponents_CellEndEdit(sender As Object, e As DataGridViewCellEventArgs) Handles dgvComponents.CellEndEdit
        If e.RowIndex < 0 Then Return

        Dim row = dgvComponents.Rows(e.RowIndex)

        If dgvComponents.Columns(e.ColumnIndex).Name = "Quantity" Then
            If IsNumeric(row.Cells("Quantity").Value) AndAlso IsNumeric(row.Cells("CostPerUnit").Value) Then
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)
                row.Cells("TotalCost").Value = quantity * costPerUnit

                LoadConsolidatedBOM()
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub LoadConsolidatedBOM()
        dgvConsolidatedBOM.Rows.Clear()

        Dim consolidatedIngredients As New Dictionary(Of Integer, ConsolidatedIngredient)

        ' Process all components
        For Each row As DataGridViewRow In dgvComponents.Rows
            Dim componentID As Integer = CInt(row.Cells("ComponentID").Value)
            Dim componentType As String = row.Cells("ComponentType").Value.ToString()
            Dim componentQty As Decimal = CDec(row.Cells("Quantity").Value)
            Dim componentName As String = row.Cells("ComponentName").Value.ToString()
            Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)

            If componentType = "SubRecipe" Then
                ' Expand sub-recipe into its ingredients
                Dim ingredients = _recipeService.GetSubRecipeIngredients(componentID)

                For Each ingredientRow As DataRow In ingredients.Rows
                    Dim ingredientID As Integer = CInt(ingredientRow("IngredientID"))
                    Dim ingredientName As String = ingredientRow("IngredientName").ToString()
                    ' Use QuantityPerUnit (ingredient qty / sub-recipe batch qty) * component qty requested
                    Dim quantityPerUnit As Decimal = CDec(ingredientRow("QuantityPerUnit"))
                    Dim quantity As Decimal = quantityPerUnit * componentQty
                    Dim unit As String = ingredientRow("UnitOfMeasure").ToString()
                    Dim ingredientCostPerUnit As Decimal = CDec(ingredientRow("CostPerUnit"))

                    If consolidatedIngredients.ContainsKey(ingredientID) Then
                        consolidatedIngredients(ingredientID).TotalQuantity += quantity
                        consolidatedIngredients(ingredientID).TotalCost = consolidatedIngredients(ingredientID).TotalQuantity * ingredientCostPerUnit
                    Else
                        consolidatedIngredients.Add(ingredientID, New ConsolidatedIngredient With {
                            .IngredientID = ingredientID,
                            .IngredientName = ingredientName,
                            .TotalQuantity = quantity,
                            .UnitOfMeasure = unit,
                            .CostPerUnit = ingredientCostPerUnit,
                            .TotalCost = quantity * ingredientCostPerUnit
                        })
                    End If
                Next
            Else
                ' Add direct component (ingredient, packaging, etc.)
                If consolidatedIngredients.ContainsKey(componentID) Then
                    consolidatedIngredients(componentID).TotalQuantity += componentQty
                    consolidatedIngredients(componentID).TotalCost = consolidatedIngredients(componentID).TotalQuantity * costPerUnit
                Else
                    consolidatedIngredients.Add(componentID, New ConsolidatedIngredient With {
                        .IngredientID = componentID,
                        .IngredientName = componentName,
                        .TotalQuantity = componentQty,
                        .UnitOfMeasure = "unit",
                        .CostPerUnit = costPerUnit,
                        .TotalCost = componentQty * costPerUnit
                    })
                End If
            End If
        Next

        For Each ingredient In consolidatedIngredients.Values.OrderBy(Function(i) i.IngredientName)
            dgvConsolidatedBOM.Rows.Add(
                ingredient.IngredientName,
                $"{ingredient.TotalQuantity:N2}",
                ingredient.UnitOfMeasure,
                ingredient.CostPerUnit,
                ingredient.TotalCost
            )
        Next
    End Sub

    Private Sub CalculateTotalCost()
        Dim total As Decimal = 0

        For Each row As DataGridViewRow In dgvComponents.Rows
            If row.Cells("TotalCost").Value IsNot Nothing AndAlso IsNumeric(row.Cells("TotalCost").Value) Then
                total += CDec(row.Cells("TotalCost").Value)
            End If
        Next

        ' Divide by batch quantity to get cost per 1 product
        Dim batchQty As Decimal = 1
        If IsNumeric(txtBatchQty.Text) AndAlso CDec(txtBatchQty.Text) > 0 Then
            batchQty = CDec(txtBatchQty.Text)
        End If
        
        Dim costPerUnit As Decimal = total / batchQty
        Dim vatRate As Decimal = 0.15D ' 15% VAT
        Dim adhocRate As Decimal = 0.15D ' 15% ADHOC
        
        ' Section 1: Per Unit Cost
        Dim unitVAT As Decimal = costPerUnit * vatRate
        Dim unitInclVAT As Decimal = costPerUnit + unitVAT
        
        ' Section 2: Full Batch Cost
        Dim batchVAT As Decimal = total * vatRate
        Dim batchInclVAT As Decimal = total + batchVAT
        
        ' Section 3: With 15% ADHOC
        Dim adhocCostPerUnit As Decimal = costPerUnit * (1 + adhocRate)
        Dim adhocVATPerUnit As Decimal = adhocCostPerUnit * vatRate
        Dim adhocInclVATPerUnit As Decimal = adhocCostPerUnit + adhocVATPerUnit
        
        Dim adhocBatchTotal As Decimal = total * (1 + adhocRate)
        Dim adhocBatchVAT As Decimal = adhocBatchTotal * vatRate
        Dim adhocBatchInclVAT As Decimal = adhocBatchTotal + adhocBatchVAT

        ' Line 1: Single Unit Cost (Green)
        lblTotalCost.Text = $"1 UNIT: Excl VAT: {costPerUnit.ToString("C2")} | VAT (15%): {unitVAT.ToString("C2")} | Incl VAT: {unitInclVAT.ToString("C2")}"
        lblTotalCost.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        lblTotalCost.ForeColor = Color.FromArgb(39, 174, 96) ' Green
        
        ' Line 2: Full Batch Cost (Blue)
        lblBatchCost.Text = $"BATCH ({batchQty} units): Excl VAT: {total.ToString("C2")} | VAT (15%): {batchVAT.ToString("C2")} | Incl VAT: {batchInclVAT.ToString("C2")}"
        lblBatchCost.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        lblBatchCost.ForeColor = Color.FromArgb(41, 128, 185) ' Blue
        lblBatchCost.Visible = True
        
        ' Line 3: With ADHOC Charges (Orange)
        lblAdhocCost.Text = $"WITH ADHOC (+15%): Excl VAT: {adhocCostPerUnit.ToString("C2")} | VAT (15%): {adhocVATPerUnit.ToString("C2")} | Incl VAT: {adhocInclVATPerUnit.ToString("C2")} per unit | Batch Total Incl VAT: {adhocBatchInclVAT.ToString("C2")}"
        lblAdhocCost.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        lblAdhocCost.ForeColor = Color.FromArgb(230, 126, 34) ' Orange
        lblAdhocCost.Visible = True
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If _selectedProductID = 0 Then
            MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If dgvComponents.Rows.Count = 0 Then
            MessageBox.Show("Please add at least one component.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If String.IsNullOrWhiteSpace(txtMethod.Text) Then
            MessageBox.Show("Please enter the method/instructions.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If Not IsNumeric(txtBatchQty.Text) OrElse CDec(txtBatchQty.Text) <= 0 Then
            MessageBox.Show("Please enter a valid batch quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Dim batchQty As Decimal = CDec(txtBatchQty.Text)
            Dim method As String = txtMethod.Text.Trim()

            Dim result = _recipeService.SaveProductRecipe(_selectedProductID, method, batchQty, _currentUserID)

            If Not result.Item1 Then
                MessageBox.Show($"Error saving product recipe: {result.Item2}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If

            ' DELETE all existing BOM components first so deleted items don't reappear
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Dim cmdDelete As New SqlCommand("UPDATE Demo_ProductRecipe_BOM SET IsActive = 0 WHERE ProductID = @ProductID", conn)
                cmdDelete.Parameters.AddWithValue("@ProductID", _selectedProductID)
                cmdDelete.ExecuteNonQuery()
            End Using

            For Each row As DataGridViewRow In dgvComponents.Rows
                Dim componentID As Integer = CInt(row.Cells("ComponentID").Value)
                Dim componentType As String = row.Cells("ComponentType").Value.ToString()
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)

                Dim componentResult = _recipeService.SaveProductBOMComponent(_selectedProductID, componentType, componentID, quantity, costPerUnit)

                If Not componentResult.Item1 Then
                    MessageBox.Show($"Error saving component: {componentResult.Item2}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
            Next

            Try
                _recipeService.UpdateProductRecipeTotalCost(_selectedProductID)
            Catch ex As Exception
                ' Log error but don't stop the process
                System.Diagnostics.Debug.WriteLine($"Warning: Could not update recipe total cost: {ex.Message}")
            End Try
            
            ' Update Recipe_Created flag for ALL branches of this product (by Name)
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                ' First get the product name
                Dim productName As String = ""
                Dim cmdGetName As New SqlCommand("SELECT Name FROM Demo_Retail_Product WHERE ProductID = @ProductID", conn)
                cmdGetName.Parameters.AddWithValue("@ProductID", _selectedProductID)
                productName = cmdGetName.ExecuteScalar()?.ToString()
                
                ' Update Recipe_Created for all branches with this product name
                If Not String.IsNullOrEmpty(productName) Then
                    Dim cmdUpdate As New SqlCommand("UPDATE Demo_Retail_Product SET Recipe_Created = 1 WHERE Name = @ProductName", conn)
                    cmdUpdate.Parameters.AddWithValue("@ProductName", productName)
                    cmdUpdate.ExecuteNonQuery()
                End If
            End Using

            MessageBox.Show("Product recipe saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

            LoadExistingRecipe()

        Catch ex As Exception
            MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        If _selectedProductID = 0 Then
            MessageBox.Show("Please select a product first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        PrintProductRecipe()
    End Sub

    Private _printComponentIndex As Integer = 0
    Private _printBOMIndex As Integer = 0
    Private _printMethodLineIndex As Integer = 0
    Private _printSection As Integer = 0

    Private Sub PrintProductRecipe()
        _printComponentIndex = 0
        _printBOMIndex = 0
        _printMethodLineIndex = 0
        _printSection = 0
        Dim printDoc As New Printing.PrintDocument()
        AddHandler printDoc.PrintPage, AddressOf PrintPage
        printDoc.Print()
    End Sub

    Private Sub PrintPage(sender As Object, e As Printing.PrintPageEventArgs)
        Dim font As New Font("Courier New", 9)
        Dim boldFont As New Font("Courier New", 11, FontStyle.Bold)
        Dim y As Integer = 30
        Dim pageHeight As Integer = e.PageBounds.Height - 100
        Dim startNewPage As Boolean = False

        ' Print header on first page only
        If _printSection = 0 Then
            e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString("OVEN DELIGHTS - PRODUCT RECIPE PRODUCTION SHEET", boldFont, Brushes.Black, 80, y)
            y += 25
            e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
            y += 35

            Dim productName As String = cboProduct.Text
            e.Graphics.DrawString($"Product: {productName}", boldFont, Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString($"Batch Qty: {txtBatchQty.Text}", font, Brushes.Black, 50, y)
            y += 20
            e.Graphics.DrawString($"Date: {DateTime.Now:dd MMM yyyy}", font, Brushes.Black, 50, y)
            y += 35

            e.Graphics.DrawString("COMPONENTS REQUIRED:", boldFont, Brushes.Black, 50, y)
            y += 25
            _printSection = 1
        End If

        ' Print components
        If _printSection = 1 Then
            While _printComponentIndex < dgvComponents.Rows.Count
                If y > pageHeight Then
                    startNewPage = True
                    Exit While
                End If
                Dim row As DataGridViewRow = dgvComponents.Rows(_printComponentIndex)
                Dim componentName As String = row.Cells("ComponentName").Value.ToString().PadRight(35)
                Dim category As String = row.Cells("Category").Value.ToString().PadRight(15)
                Dim quantity As String = $"{row.Cells("Quantity").Value}".PadRight(10)
                Dim cost As String = CDec(row.Cells("TotalCost").Value).ToString("C2")

                e.Graphics.DrawString($"{componentName} ({category}) {quantity} {cost}", font, Brushes.Black, 50, y)
                y += 20
                _printComponentIndex += 1
            End While

            If Not startNewPage Then
                y += 25
                If y > pageHeight Then
                    startNewPage = True
                Else
                    e.Graphics.DrawString("CONSOLIDATED INGREDIENTS (BOM):", boldFont, Brushes.Black, 50, y)
                    y += 25
                    _printSection = 2
                End If
            End If
        End If

        ' Print BOM
        If _printSection = 2 And Not startNewPage Then
            While _printBOMIndex < dgvConsolidatedBOM.Rows.Count
                If y > pageHeight Then
                    startNewPage = True
                    Exit While
                End If
                Dim row As DataGridViewRow = dgvConsolidatedBOM.Rows(_printBOMIndex)
                Dim ingredientName As String = row.Cells("IngredientName").Value.ToString().PadRight(30)
                Dim quantity As String = $"{row.Cells("TotalQuantity").Value} {row.Cells("UnitOfMeasure").Value}".PadRight(15)
                Dim cost As String = CDec(row.Cells("TotalCost").Value).ToString("C2")

                e.Graphics.DrawString($"{ingredientName} {quantity} {cost}", font, Brushes.Black, 50, y)
                y += 20
                _printBOMIndex += 1
            End While

            If Not startNewPage Then
                y += 20
                If y > pageHeight Then
                    startNewPage = True
                Else
                    e.Graphics.DrawString($"COST BREAKDOWN:", boldFont, Brushes.Black, 50, y)
                    y += 25
                    e.Graphics.DrawString($"{lblTotalCost.Text}", font, Brushes.Black, 50, y)
                    y += 20
                    e.Graphics.DrawString($"{lblBatchCost.Text}", font, Brushes.Black, 50, y)
                    y += 20
                    e.Graphics.DrawString($"{lblAdhocCost.Text}", font, Brushes.Black, 50, y)
                    y += 35
                    If y > pageHeight Then
                        startNewPage = True
                    Else
                        e.Graphics.DrawString("ASSEMBLY METHOD:", boldFont, Brushes.Black, 50, y)
                        y += 25
                        _printSection = 3
                    End If
                End If
            End If
        End If

        ' Print method
        If _printSection = 3 And Not startNewPage Then
            Dim methodLines = txtMethod.Text.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
            While _printMethodLineIndex < methodLines.Length
                If y > pageHeight Then
                    startNewPage = True
                    Exit While
                End If
                e.Graphics.DrawString(methodLines(_printMethodLineIndex), font, Brushes.Black, 50, y)
                y += 20
                _printMethodLineIndex += 1
            End While

            If Not startNewPage Then
                y += 30
                If y + 50 > pageHeight Then
                    startNewPage = True
                Else
                    e.Graphics.DrawString("Baker: ________________  Date: ________  Time: ______", font, Brushes.Black, 50, y)
                    y += 25
                    e.Graphics.DrawString("Checked By: ________________", font, Brushes.Black, 50, y)
                    _printSection = 4
                End If
            End If
        End If

        ' Set HasMorePages if we need to continue printing
        e.HasMorePages = startNewPage Or _printSection < 4
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ClearForm()
    End Sub

    Private Sub ClearForm()
        cboProduct.SelectedIndex = -1
        txtMethod.Clear()
        txtBatchQty.Text = "1"
        dgvComponents.Rows.Clear()
        dgvConsolidatedBOM.Rows.Clear()
        lblTotalCost.Text = "1 UNIT: Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        lblBatchCost.Text = "BATCH (1 units): Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        lblAdhocCost.Text = "WITH ADHOC (+15%): Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        _selectedProductID = 0
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Private Class ConsolidatedIngredient
        Public Property IngredientID As Integer
        Public Property IngredientName As String
        Public Property TotalQuantity As Decimal
        Public Property UnitOfMeasure As String
        Public Property CostPerUnit As Decimal
        Public Property TotalCost As Decimal
    End Class

End Class
