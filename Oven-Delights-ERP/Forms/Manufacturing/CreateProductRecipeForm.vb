Imports System.Data.SqlClient
Imports System.Configuration

Public Class CreateProductRecipeForm

    Private ReadOnly _connectionString As String
    Private _recipeService As RecipeCostCalculationService
    Private _currentBranchID As Integer
    Private _currentUserID As Integer
    Private _selectedProductID As Integer = 0

    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _recipeService = New RecipeCostCalculationService()
        _currentBranchID = AppSession.CurrentUser.BranchID
        _currentUserID = AppSession.CurrentUser.UserID
    End Sub

    Private Sub CreateProductRecipeForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        SetupForm()
        LoadProducts()
        LoadSubRecipes()
        LoadPackaging()
    End Sub

    Private Sub SetupForm()
        Me.Text = "Create Product Recipe - WOW FACTOR"
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = Color.FromArgb(240, 240, 245)

        SetupGrid(dgvSubRecipes, "SubRecipes")
        SetupGrid(dgvPackaging, "Packaging")
        SetupGrid(dgvConsolidatedBOM, "Consolidated")

        txtBatchQty.Text = "1"
        txtMethod.Font = New Font("Segoe UI", 10)
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
        grid.ColumnHeadersDefaultCellStyle.BackColor = If(gridType = "SubRecipes", Color.FromArgb(39, 174, 96), If(gridType = "Packaging", Color.FromArgb(230, 126, 34), Color.FromArgb(52, 73, 94)))
        grid.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        grid.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        grid.ColumnHeadersHeight = 40

        grid.Columns.Clear()

        If gridType = "SubRecipes" Then
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "BOMLineID", .HeaderText = "ID", .Visible = False})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentID", .HeaderText = "Sub-Recipe ID", .Visible = False})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentName", .HeaderText = "Sub-Recipe", .Width = 300, .ReadOnly = True})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Quantity", .Width = 100})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost Per Unit", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
            Dim btnDelete As New DataGridViewButtonColumn With {.Name = "Delete", .HeaderText = "Action", .Text = "Delete", .UseColumnTextForButtonValue = True, .Width = 80}
            grid.Columns.Add(btnDelete)
        ElseIf gridType = "Packaging" Then
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "BOMLineID", .HeaderText = "ID", .Visible = False})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentID", .HeaderText = "Packaging ID", .Visible = False})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ComponentName", .HeaderText = "Packaging/Decoration", .Width = 300, .ReadOnly = True})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Quantity", .Width = 100})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost Per Unit", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
            grid.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
            Dim btnDelete As New DataGridViewButtonColumn With {.Name = "Delete", .HeaderText = "Action", .Text = "Delete", .UseColumnTextForButtonValue = True, .Width = 80}
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
        cboProduct.Items.Clear()
        cboProduct.DisplayMember = "Name"
        cboProduct.ValueMember = "ProductID"

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT DISTINCT ProductID, Name
                FROM Demo_Retail_Product
                WHERE IsActive = 1
                  AND ProductType = 'Internal'
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
                        cboProduct.Items.Add(New With {
                            .ProductID = reader.GetInt32(0),
                            .Name = reader.GetString(1)
                        })
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadSubRecipes()
        cboSubRecipe.Items.Clear()
        cboSubRecipe.DisplayMember = "Name"
        cboSubRecipe.ValueMember = "ProductID"

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT DISTINCT p.ProductID, p.Name
                FROM Demo_Retail_Product p
                INNER JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID
                WHERE p.IsActive = 1
                  AND sr.IsActive = 1
                  AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%')
                ORDER BY p.Name"

            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        cboSubRecipe.Items.Add(New With {
                            .ProductID = reader.GetInt32(0),
                            .Name = reader.GetString(1)
                        })
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub LoadPackaging()
        cboPackaging.Items.Clear()
        cboPackaging.DisplayMember = "Name"
        cboPackaging.ValueMember = "ProductID"

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT DISTINCT ProductID, Name
                FROM Demo_Retail_Product
                WHERE IsActive = 1
                  AND (Category LIKE '%pack%' OR Category LIKE '%misce%')
                ORDER BY Name"

            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        cboPackaging.Items.Add(New With {
                            .ProductID = reader.GetInt32(0),
                            .Name = reader.GetString(1)
                        })
                    End While
                End Using
            End Using
        End Using
    End Sub

    Private Sub cboProduct_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboProduct.SelectedIndexChanged
        If cboProduct.SelectedItem Is Nothing Then Return

        _selectedProductID = CType(cboProduct.SelectedItem, Object).ProductID

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
        Else
            ClearForm()
        End If
    End Sub

    Private Sub LoadExistingRecipe()
        Dim details = _recipeService.GetProductRecipeDetails(_selectedProductID)
        If details IsNot Nothing Then
            txtMethod.Text = If(IsDBNull(details("Method")), "", details("Method").ToString())
            txtBatchQty.Text = details("BatchQty").ToString()
        End If

        Dim dt = _recipeService.GetProductBOMComponents(_selectedProductID)
        dgvSubRecipes.Rows.Clear()
        dgvPackaging.Rows.Clear()

        For Each row As DataRow In dt.Rows
            If row("ComponentType").ToString() = "SubRecipe" Then
                dgvSubRecipes.Rows.Add(
                    row("BOMLineID"),
                    row("ComponentID"),
                    row("ComponentName"),
                    row("Quantity"),
                    row("CostPerUnit"),
                    row("TotalCost")
                )
            Else
                dgvPackaging.Rows.Add(
                    row("BOMLineID"),
                    row("ComponentID"),
                    row("ComponentName"),
                    row("Quantity"),
                    row("CostPerUnit"),
                    row("TotalCost")
                )
            End If
        Next

        LoadConsolidatedBOM()
        CalculateTotalCost()
    End Sub

    Private Sub btnAddSubRecipe_Click(sender As Object, e As EventArgs) Handles btnAddSubRecipe.Click
        If cboSubRecipe.SelectedItem Is Nothing Then
            MessageBox.Show("Please select a sub-recipe.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If Not IsNumeric(txtSubRecipeQty.Text) OrElse CDec(txtSubRecipeQty.Text) <= 0 Then
            MessageBox.Show("Please enter a valid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim subRecipeID As Integer = CType(cboSubRecipe.SelectedItem, Object).ProductID
        Dim subRecipeName As String = CType(cboSubRecipe.SelectedItem, Object).Name
        Dim quantity As Decimal = CDec(txtSubRecipeQty.Text)

        If Not _recipeService.CheckSubRecipeExists(subRecipeID) Then
            MessageBox.Show($"Recipe for '{subRecipeName}' has not been created yet.{Environment.NewLine}{Environment.NewLine}Please create the sub-recipe first before adding it to the product.",
                "Sub-Recipe Not Found", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return
        End If

        For Each row As DataGridViewRow In dgvSubRecipes.Rows
            If row.Cells("ComponentID").Value IsNot Nothing AndAlso CInt(row.Cells("ComponentID").Value) = subRecipeID Then
                MessageBox.Show("This sub-recipe is already added. Please edit the existing entry.", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
        Next

        Dim costPerUnit As Decimal = _recipeService.CalculateSubRecipeTotalCost(subRecipeID)
        Dim totalCost As Decimal = quantity * costPerUnit

        dgvSubRecipes.Rows.Add(0, subRecipeID, subRecipeName, quantity, costPerUnit, totalCost)

        txtSubRecipeQty.Clear()
        cboSubRecipe.SelectedIndex = -1

        LoadConsolidatedBOM()
        CalculateTotalCost()
    End Sub

    Private Sub btnAddPackaging_Click(sender As Object, e As EventArgs) Handles btnAddPackaging.Click
        If cboPackaging.SelectedItem Is Nothing Then
            MessageBox.Show("Please select a packaging/decoration item.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If Not IsNumeric(txtPackagingQty.Text) OrElse CDec(txtPackagingQty.Text) <= 0 Then
            MessageBox.Show("Please enter a valid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim packagingID As Integer = CType(cboPackaging.SelectedItem, Object).ProductID
        Dim packagingName As String = CType(cboPackaging.SelectedItem, Object).Name
        Dim quantity As Decimal = CDec(txtPackagingQty.Text)

        For Each row As DataGridViewRow In dgvPackaging.Rows
            If row.Cells("ComponentID").Value IsNot Nothing AndAlso CInt(row.Cells("ComponentID").Value) = packagingID Then
                MessageBox.Show("This item is already added. Please edit the existing entry.", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
        Next

        Dim costPerUnit As Decimal = GetPackagingCost(packagingID)
        Dim totalCost As Decimal = quantity * costPerUnit

        dgvPackaging.Rows.Add(0, packagingID, packagingName, quantity, costPerUnit, totalCost)

        txtPackagingQty.Clear()
        cboPackaging.SelectedIndex = -1

        CalculateTotalCost()
    End Sub

    Private Function GetPackagingCost(packagingID As Integer) As Decimal
        Dim cost As Decimal = 0

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT TOP 1 ISNULL(CostPrice, 0)
                FROM Demo_Retail_Price
                WHERE ProductID = @ProductID AND BranchID = @BranchID
                ORDER BY EffectiveFrom DESC"

            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ProductID", packagingID)
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

    Private Sub dgvSubRecipes_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvSubRecipes.CellContentClick
        If e.RowIndex < 0 Then Return

        If dgvSubRecipes.Columns(e.ColumnIndex).Name = "Delete" Then
            Dim result = MessageBox.Show("Are you sure you want to delete this sub-recipe?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                dgvSubRecipes.Rows.RemoveAt(e.RowIndex)
                LoadConsolidatedBOM()
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub dgvPackaging_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvPackaging.CellContentClick
        If e.RowIndex < 0 Then Return

        If dgvPackaging.Columns(e.ColumnIndex).Name = "Delete" Then
            Dim result = MessageBox.Show("Are you sure you want to delete this item?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                dgvPackaging.Rows.RemoveAt(e.RowIndex)
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub dgvSubRecipes_CellEndEdit(sender As Object, e As DataGridViewCellEventArgs) Handles dgvSubRecipes.CellEndEdit
        If e.RowIndex < 0 Then Return

        Dim row = dgvSubRecipes.Rows(e.RowIndex)

        If dgvSubRecipes.Columns(e.ColumnIndex).Name = "Quantity" Then
            If IsNumeric(row.Cells("Quantity").Value) AndAlso IsNumeric(row.Cells("CostPerUnit").Value) Then
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)
                row.Cells("TotalCost").Value = quantity * costPerUnit

                LoadConsolidatedBOM()
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub dgvPackaging_CellEndEdit(sender As Object, e As DataGridViewCellEventArgs) Handles dgvPackaging.CellEndEdit
        If e.RowIndex < 0 Then Return

        Dim row = dgvPackaging.Rows(e.RowIndex)

        If dgvPackaging.Columns(e.ColumnIndex).Name = "Quantity" Then
            If IsNumeric(row.Cells("Quantity").Value) AndAlso IsNumeric(row.Cells("CostPerUnit").Value) Then
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)
                row.Cells("TotalCost").Value = quantity * costPerUnit

                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub LoadConsolidatedBOM()
        dgvConsolidatedBOM.Rows.Clear()

        Dim consolidatedIngredients As New Dictionary(Of Integer, ConsolidatedIngredient)

        For Each row As DataGridViewRow In dgvSubRecipes.Rows
            Dim subRecipeID As Integer = CInt(row.Cells("ComponentID").Value)
            Dim subRecipeQty As Decimal = CDec(row.Cells("Quantity").Value)

            Dim ingredients = _recipeService.GetSubRecipeIngredients(subRecipeID)

            For Each ingredientRow As DataRow In ingredients.Rows
                Dim ingredientID As Integer = CInt(ingredientRow("IngredientID"))
                Dim ingredientName As String = ingredientRow("IngredientName").ToString()
                Dim quantity As Decimal = CDec(ingredientRow("Quantity")) * subRecipeQty
                Dim unit As String = ingredientRow("UnitOfMeasure").ToString()
                Dim costPerUnit As Decimal = CDec(ingredientRow("CostPerUnit"))

                If consolidatedIngredients.ContainsKey(ingredientID) Then
                    consolidatedIngredients(ingredientID).TotalQuantity += quantity
                    consolidatedIngredients(ingredientID).TotalCost = consolidatedIngredients(ingredientID).TotalQuantity * costPerUnit
                Else
                    consolidatedIngredients.Add(ingredientID, New ConsolidatedIngredient With {
                        .IngredientID = ingredientID,
                        .IngredientName = ingredientName,
                        .TotalQuantity = quantity,
                        .UnitOfMeasure = unit,
                        .CostPerUnit = costPerUnit,
                        .TotalCost = quantity * costPerUnit
                    })
                End If
            Next
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

        For Each row As DataGridViewRow In dgvSubRecipes.Rows
            If row.Cells("TotalCost").Value IsNot Nothing AndAlso IsNumeric(row.Cells("TotalCost").Value) Then
                total += CDec(row.Cells("TotalCost").Value)
            End If
        Next

        For Each row As DataGridViewRow In dgvPackaging.Rows
            If row.Cells("TotalCost").Value IsNot Nothing AndAlso IsNumeric(row.Cells("TotalCost").Value) Then
                total += CDec(row.Cells("TotalCost").Value)
            End If
        Next

        lblTotalCost.Text = $"Total Cost Per Product: {total.ToString("C2")}"
        lblTotalCost.Font = New Font("Segoe UI", 14, FontStyle.Bold)
        lblTotalCost.ForeColor = Color.FromArgb(39, 174, 96)
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If _selectedProductID = 0 Then
            MessageBox.Show("Please select a product.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If dgvSubRecipes.Rows.Count = 0 Then
            MessageBox.Show("Please add at least one sub-recipe.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
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

            For Each row As DataGridViewRow In dgvSubRecipes.Rows
                Dim componentID As Integer = CInt(row.Cells("ComponentID").Value)
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)

                Dim componentResult = _recipeService.SaveProductBOMComponent(_selectedProductID, "SubRecipe", componentID, quantity, costPerUnit)

                If Not componentResult.Item1 Then
                    MessageBox.Show($"Error saving sub-recipe: {componentResult.Item2}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
            Next

            For Each row As DataGridViewRow In dgvPackaging.Rows
                Dim componentID As Integer = CInt(row.Cells("ComponentID").Value)
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)

                Dim componentResult = _recipeService.SaveProductBOMComponent(_selectedProductID, "Packaging", componentID, quantity, costPerUnit)

                If Not componentResult.Item1 Then
                    MessageBox.Show($"Error saving packaging: {componentResult.Item2}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
            Next

            _recipeService.UpdateProductRecipeTotalCost(_selectedProductID)

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

    Private Sub PrintProductRecipe()
        Dim printDoc As New Printing.PrintDocument()
        AddHandler printDoc.PrintPage, AddressOf PrintPage
        printDoc.Print()
    End Sub

    Private Sub PrintPage(sender As Object, e As Printing.PrintPageEventArgs)
        Dim font As New Font("Courier New", 9)
        Dim boldFont As New Font("Courier New", 11, FontStyle.Bold)
        Dim y As Integer = 30

        e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
        y += 25
        e.Graphics.DrawString("OVEN DELIGHTS - PRODUCT RECIPE PRODUCTION SHEET", boldFont, Brushes.Black, 80, y)
        y += 25
        e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
        y += 35

        Dim productName As String = CType(cboProduct.SelectedItem, Object).Name
        e.Graphics.DrawString($"Product: {productName}", boldFont, Brushes.Black, 50, y)
        y += 25
        e.Graphics.DrawString($"Batch Qty: {txtBatchQty.Text}", font, Brushes.Black, 50, y)
        y += 20
        e.Graphics.DrawString($"Date: {DateTime.Now:dd MMM yyyy}", font, Brushes.Black, 50, y)
        y += 35

        e.Graphics.DrawString("SUB-RECIPES REQUIRED:", boldFont, Brushes.Black, 50, y)
        y += 25

        For Each row As DataGridViewRow In dgvSubRecipes.Rows
            Dim subRecipeName As String = row.Cells("ComponentName").Value.ToString().PadRight(35)
            Dim quantity As String = $"{row.Cells("Quantity").Value}".PadRight(10)
            Dim cost As String = CDec(row.Cells("TotalCost").Value).ToString("C2")

            e.Graphics.DrawString($"{subRecipeName} {quantity} {cost}", font, Brushes.Black, 50, y)
            y += 20
        Next

        y += 25
        e.Graphics.DrawString("PACKAGING & DECORATIONS:", boldFont, Brushes.Black, 50, y)
        y += 25

        For Each row As DataGridViewRow In dgvPackaging.Rows
            Dim packagingName As String = row.Cells("ComponentName").Value.ToString().PadRight(35)
            Dim quantity As String = $"{row.Cells("Quantity").Value}".PadRight(10)
            Dim cost As String = CDec(row.Cells("TotalCost").Value).ToString("C2")

            e.Graphics.DrawString($"{packagingName} {quantity} {cost}", font, Brushes.Black, 50, y)
            y += 20
        Next

        y += 25
        e.Graphics.DrawString("CONSOLIDATED INGREDIENTS (BOM):", boldFont, Brushes.Black, 50, y)
        y += 25

        For Each row As DataGridViewRow In dgvConsolidatedBOM.Rows
            Dim ingredientName As String = row.Cells("IngredientName").Value.ToString().PadRight(30)
            Dim quantity As String = $"{row.Cells("TotalQuantity").Value} {row.Cells("UnitOfMeasure").Value}".PadRight(15)
            Dim cost As String = CDec(row.Cells("TotalCost").Value).ToString("C2")

            e.Graphics.DrawString($"{ingredientName} {quantity} {cost}", font, Brushes.Black, 50, y)
            y += 20
        Next

        y += 20
        e.Graphics.DrawString($"TOTAL COST: {lblTotalCost.Text.Replace("Total Cost Per Product: ", "")}", boldFont, Brushes.Black, 50, y)
        y += 35

        e.Graphics.DrawString("ASSEMBLY METHOD:", boldFont, Brushes.Black, 50, y)
        y += 25

        Dim methodLines = txtMethod.Text.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
        For Each line In methodLines
            e.Graphics.DrawString(line, font, Brushes.Black, 50, y)
            y += 20
        Next

        y += 30
        e.Graphics.DrawString("Baker: ________________  Date: ________  Time: ______", font, Brushes.Black, 50, y)
        y += 25
        e.Graphics.DrawString("Checked By: ________________", font, Brushes.Black, 50, y)
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ClearForm()
    End Sub

    Private Sub ClearForm()
        cboProduct.SelectedIndex = -1
        txtMethod.Clear()
        txtBatchQty.Text = "1"
        dgvSubRecipes.Rows.Clear()
        dgvPackaging.Rows.Clear()
        dgvConsolidatedBOM.Rows.Clear()
        lblTotalCost.Text = "Total Cost Per Product: R0.00"
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
