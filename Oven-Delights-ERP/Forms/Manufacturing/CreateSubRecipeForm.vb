Imports System.Data.SqlClient
Imports System.Configuration

Public Class CreateSubRecipeForm

    Private ReadOnly _connectionString As String
    Private _recipeService As RecipeCostCalculationService
    Private _currentBranchID As Integer
    Private _currentUserID As Integer
    Private _selectedSubRecipeID As Integer = 0

    Public Sub New()
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _recipeService = New RecipeCostCalculationService()
        _currentBranchID = AppSession.CurrentUser.BranchID
        _currentUserID = AppSession.CurrentUser.UserID
    End Sub

    Private Sub CreateSubRecipeForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        SetupForm()
        LoadSubRecipes()
        LoadIngredients()
        LoadUnitsOfMeasure()
        AddHandler txtBatchQty.TextChanged, AddressOf txtBatchQty_TextChanged
    End Sub
    
    Private Sub txtBatchQty_TextChanged(sender As Object, e As EventArgs)
        CalculateTotalCost()
    End Sub

    Private Sub SetupForm()
        Me.Text = "Create Sub-Recipe - WOW FACTOR"
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = Color.FromArgb(240, 240, 245)

        dgvIngredients.AutoGenerateColumns = False
        dgvIngredients.AllowUserToAddRows = False
        dgvIngredients.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvIngredients.MultiSelect = False
        dgvIngredients.RowHeadersVisible = False
        dgvIngredients.BackgroundColor = Color.White
        dgvIngredients.BorderStyle = BorderStyle.None
        dgvIngredients.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        dgvIngredients.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
        dgvIngredients.DefaultCellStyle.SelectionForeColor = Color.White
        dgvIngredients.EnableHeadersVisualStyles = False
        dgvIngredients.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(41, 128, 185)
        dgvIngredients.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvIngredients.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvIngredients.ColumnHeadersHeight = 40

        dgvIngredients.Columns.Clear()
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "BOMLineID", .HeaderText = "ID", .Visible = False})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "IngredientID", .HeaderText = "Ingredient ID", .Visible = False})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "IngredientName", .HeaderText = "Ingredient", .Width = 250, .ReadOnly = True})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Quantity", .Width = 100})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitOfMeasure", .HeaderText = "Unit", .Width = 100})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "PackageSize", .HeaderText = "Package Size", .Width = 120})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost/Unit", .Width = 120, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C6"}})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})

        Dim btnDelete As New DataGridViewButtonColumn With {
            .Name = "Delete",
            .HeaderText = "Action",
            .Text = "Delete",
            .UseColumnTextForButtonValue = True,
            .Width = 80
        }
        dgvIngredients.Columns.Add(btnDelete)

        txtBatchQty.Text = "1"
        txtMethod.Font = New Font("Segoe UI", 10)
    End Sub

    Private Sub LoadSubRecipes()
        Dim dt As New DataTable()
        dt.Columns.Add("ProductID", GetType(Integer))
        dt.Columns.Add("Name", GetType(String))

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT MIN(ProductID) AS ProductID, Name
                FROM Demo_Retail_Product
                WHERE IsActive = 1
                  AND (Category LIKE '%sub%recipe%' OR Category LIKE '%subrecipe%')
                GROUP BY Name
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
        
        cboSubRecipe.DataSource = Nothing
        cboSubRecipe.DisplayMember = "Name"
        cboSubRecipe.ValueMember = "ProductID"
        cboSubRecipe.DataSource = dt
    End Sub

    Private Sub LoadIngredients()
        Dim dt As New DataTable()
        dt.Columns.Add("ProductID", GetType(Integer))
        dt.Columns.Add("Name", GetType(String))

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT MIN(ProductID) AS ProductID, Name
                FROM Demo_Retail_Product
                WHERE IsActive = 1
                  AND Category LIKE '%ingredient%'
                GROUP BY Name
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
        
        cboIngredient.DataSource = Nothing
        cboIngredient.DisplayMember = "Name"
        cboIngredient.ValueMember = "ProductID"
        cboIngredient.DataSource = dt
    End Sub

    Private Sub LoadUnitsOfMeasure()
        cboUnit.Items.Clear()
        cboUnit.Items.AddRange({"g", "kg", "ml", "L", "unit", "dozen", "tsp", "tbsp", "cup"})
        cboUnit.AutoCompleteMode = AutoCompleteMode.SuggestAppend
        cboUnit.AutoCompleteSource = AutoCompleteSource.ListItems
        cboUnit.SelectedItem = "kg"
    End Sub

    Private Function ConvertToBaseUnit(quantity As Decimal, unit As String) As Decimal
        ' Convert to base units: kg for weight, L for volume
        Select Case unit.ToLower()
            Case "g"
                Return quantity / 1000 ' grams to kg
            Case "kg"
                Return quantity
            Case "ml"
                Return quantity / 1000 ' milliliters to L
            Case "l"
                Return quantity
            Case "tsp"
                Return (quantity * 5) / 1000 ' teaspoon to L (5ml)
            Case "tbsp"
                Return (quantity * 15) / 1000 ' tablespoon to L (15ml)
            Case "cup"
                Return (quantity * 250) / 1000 ' cup to L (250ml)
            Case Else
                Return quantity ' unit, dozen, etc. - no conversion
        End Select
    End Function

    Private Sub cboSubRecipe_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSubRecipe.SelectedIndexChanged
        If cboSubRecipe.SelectedValue Is Nothing Then Return
        If TypeOf cboSubRecipe.SelectedValue Is DataRowView Then Return
        If Not IsNumeric(cboSubRecipe.SelectedValue) Then Return

        _selectedSubRecipeID = CInt(cboSubRecipe.SelectedValue)

        If _recipeService.CheckSubRecipeExists(_selectedSubRecipeID) Then
            Dim result = MessageBox.Show(
                "A recipe already exists for this sub-recipe. Do you want to edit it?",
                "Recipe Exists",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question
            )
            If result = DialogResult.Yes Then
                LoadExistingSubRecipe(_selectedSubRecipeID)
            Else
                _selectedSubRecipeID = 0
                cboSubRecipe.SelectedIndex = -1
            End If
        End If
    End Sub

    Private Sub LoadExistingSubRecipe(subRecipeID As Integer)
        _selectedSubRecipeID = subRecipeID
        
        Dim details = _recipeService.GetSubRecipeDetails(_selectedSubRecipeID)
        If details IsNot Nothing Then
            txtMethod.Text = If(IsDBNull(details("Method")), "", details("Method").ToString())
            txtBatchQty.Text = details("BatchQty").ToString()
        End If

        Dim dt = _recipeService.GetSubRecipeIngredients(_selectedSubRecipeID)
        dgvIngredients.Rows.Clear()

        For Each row As DataRow In dt.Rows
            dgvIngredients.Rows.Add(
                row("BOMLineID"),
                row("IngredientID"),
                row("IngredientName"),
                row("Quantity"),
                row("UnitOfMeasure"),
                row("PackageSize"),
                row("CostPerUnit"),
                row("TotalCost")
            )
        Next

        CalculateTotalCost()
    End Sub

    Private Sub btnAddIngredient_Click(sender As Object, e As EventArgs) Handles btnAddIngredient.Click
        If cboIngredient.SelectedItem Is Nothing Then
            MessageBox.Show("Please select an ingredient.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If Not IsNumeric(txtQuantity.Text) OrElse CDec(txtQuantity.Text) <= 0 Then
            MessageBox.Show("Please enter a valid quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Dim ingredientID As Integer = CInt(cboIngredient.SelectedValue)
        Dim ingredientName As String = cboIngredient.Text
        Dim quantity As Decimal = CDec(txtQuantity.Text)
        Dim unit As String = cboUnit.Text
        Dim packageSize As Decimal = 1

        ' Convert quantity to base unit (kg or L) for cost calculation
        Dim quantityInBaseUnit As Decimal = ConvertToBaseUnit(quantity, unit)
        
        ' Get cost per base unit (kg or L)
        Dim costPerUnit As Decimal = _recipeService.GetIngredientCostPerUnit(ingredientID, _currentBranchID, packageSize)
        Dim totalCost As Decimal = quantityInBaseUnit * costPerUnit

        For Each row As DataGridViewRow In dgvIngredients.Rows
            If row.Cells("IngredientID").Value IsNot Nothing AndAlso CInt(row.Cells("IngredientID").Value) = ingredientID Then
                MessageBox.Show("This ingredient is already added. Please edit the existing entry.", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
        Next

        dgvIngredients.Rows.Add(0, ingredientID, ingredientName, quantity, unit, packageSize, costPerUnit, totalCost)

        txtQuantity.Clear()
        cboIngredient.SelectedIndex = -1

        CalculateTotalCost()
    End Sub

    Private Sub dgvIngredients_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvIngredients.CellContentClick
        If e.RowIndex < 0 Then Return

        If dgvIngredients.Columns(e.ColumnIndex).Name = "Delete" Then
            Dim result = MessageBox.Show("Are you sure you want to delete this ingredient?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                dgvIngredients.Rows.RemoveAt(e.RowIndex)
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub dgvIngredients_CellEndEdit(sender As Object, e As DataGridViewCellEventArgs) Handles dgvIngredients.CellEndEdit
        If e.RowIndex < 0 Then Return

        Dim row = dgvIngredients.Rows(e.RowIndex)

        If dgvIngredients.Columns(e.ColumnIndex).Name = "Quantity" OrElse
           dgvIngredients.Columns(e.ColumnIndex).Name = "PackageSize" Then

            If IsNumeric(row.Cells("Quantity").Value) AndAlso IsNumeric(row.Cells("PackageSize").Value) AndAlso
               IsNumeric(row.Cells("CostPerUnit").Value) Then

                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)
                row.Cells("TotalCost").Value = quantity * costPerUnit

                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub CalculateTotalCost()
        Dim total As Decimal = 0

        For Each row As DataGridViewRow In dgvIngredients.Rows
            If row.Cells("TotalCost").Value IsNot Nothing AndAlso IsNumeric(row.Cells("TotalCost").Value) Then
                total += CDec(row.Cells("TotalCost").Value)
            End If
        Next

        ' Divide by batch quantity to get cost per 1 sub-recipe
        Dim batchQty As Decimal = 1
        If IsNumeric(txtBatchQty.Text) AndAlso CDec(txtBatchQty.Text) > 0 Then
            batchQty = CDec(txtBatchQty.Text)
        End If
        
        Dim costPerUnit As Decimal = total / batchQty
        Dim vatRate As Decimal = 0.15D ' 15% VAT
        
        ' Calculate VAT for single unit
        Dim unitVAT As Decimal = costPerUnit * vatRate
        Dim unitInclVAT As Decimal = costPerUnit + unitVAT
        
        ' Calculate VAT for full batch
        Dim batchVAT As Decimal = total * vatRate
        Dim batchInclVAT As Decimal = total + batchVAT

        ' Line 1: Single Unit Cost (Green)
        lblTotalCost.Text = $"1 UNIT: Excl VAT: {costPerUnit.ToString("C2")} | VAT (15%): {unitVAT.ToString("C2")} | Incl VAT: {unitInclVAT.ToString("C2")}"
        lblTotalCost.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        lblTotalCost.ForeColor = Color.FromArgb(39, 174, 96) ' Green
        
        ' Line 2: Full Batch Cost (Blue)
        lblAdhocCost.Text = $"BATCH ({batchQty} units): Excl VAT: {total.ToString("C2")} | VAT (15%): {batchVAT.ToString("C2")} | Incl VAT: {batchInclVAT.ToString("C2")}"
        lblAdhocCost.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        lblAdhocCost.ForeColor = Color.FromArgb(41, 128, 185) ' Blue
        lblAdhocCost.Visible = True
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If _selectedSubRecipeID = 0 Then
            MessageBox.Show("Please select a sub-recipe.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If dgvIngredients.Rows.Count = 0 Then
            MessageBox.Show("Please add at least one ingredient.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
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

            Dim result = _recipeService.SaveSubRecipe(_selectedSubRecipeID, method, batchQty, _currentUserID)

            If Not result.Item1 Then
                MessageBox.Show($"Error saving sub-recipe: {result.Item2}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Return
            End If

            For Each row As DataGridViewRow In dgvIngredients.Rows
                Dim ingredientID As Integer = CInt(row.Cells("IngredientID").Value)
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim unit As String = row.Cells("UnitOfMeasure").Value.ToString()
                Dim packageSize As Decimal = CDec(row.Cells("PackageSize").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)

                Dim ingredientResult = _recipeService.SaveSubRecipeIngredient(_selectedSubRecipeID, ingredientID, quantity, unit, packageSize, costPerUnit)

                If Not ingredientResult.Item1 Then
                    MessageBox.Show($"Error saving ingredient: {ingredientResult.Item2}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                    Return
                End If
            Next

            _recipeService.UpdateSubRecipeTotalCost(_selectedSubRecipeID)

            MessageBox.Show("Sub-recipe saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)

            LoadExistingSubRecipe(_selectedSubRecipeID)

        Catch ex As Exception
            MessageBox.Show($"Error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnPrint_Click(sender As Object, e As EventArgs) Handles btnPrint.Click
        If _selectedSubRecipeID = 0 Then
            MessageBox.Show("Please select a sub-recipe first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        PrintSubRecipe()
    End Sub

    Private Sub PrintSubRecipe()
        Dim printDoc As New Printing.PrintDocument()
        AddHandler printDoc.PrintPage, AddressOf PrintPage
        printDoc.Print()
    End Sub

    Private Sub PrintPage(sender As Object, e As Printing.PrintPageEventArgs)
        Dim font As New Font("Courier New", 10)
        Dim boldFont As New Font("Courier New", 12, FontStyle.Bold)
        Dim y As Integer = 50

        e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
        y += 30
        e.Graphics.DrawString("OVEN DELIGHTS - SUB-RECIPE PRODUCTION SHEET", boldFont, Brushes.Black, 100, y)
        y += 30
        e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
        y += 40

        Dim subRecipeName As String = CType(cboSubRecipe.SelectedItem, Object).Name
        e.Graphics.DrawString($"Sub-Recipe: {subRecipeName}", boldFont, Brushes.Black, 50, y)
        y += 30
        e.Graphics.DrawString($"Batch Qty: {txtBatchQty.Text}", font, Brushes.Black, 50, y)
        y += 25
        e.Graphics.DrawString($"Date: {DateTime.Now:dd MMM yyyy}", font, Brushes.Black, 50, y)
        y += 40

        e.Graphics.DrawString("INGREDIENTS:", boldFont, Brushes.Black, 50, y)
        y += 30

        For Each row As DataGridViewRow In dgvIngredients.Rows
            Dim ingredientName As String = row.Cells("IngredientName").Value.ToString().PadRight(30)
            Dim quantity As String = $"{row.Cells("Quantity").Value} {row.Cells("UnitOfMeasure").Value}".PadRight(15)
            Dim cost As String = CDec(row.Cells("TotalCost").Value).ToString("C2")

            e.Graphics.DrawString($"{ingredientName} {quantity} {cost}", font, Brushes.Black, 50, y)
            y += 25
        Next

        y += 20
        e.Graphics.DrawString($"TOTAL COST: {lblTotalCost.Text.Replace("Total Cost Per Sub-Recipe: ", "")}", boldFont, Brushes.Black, 50, y)
        y += 40

        e.Graphics.DrawString("METHOD:", boldFont, Brushes.Black, 50, y)
        y += 30

        Dim methodLines = txtMethod.Text.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
        For Each line In methodLines
            e.Graphics.DrawString(line, font, Brushes.Black, 50, y)
            y += 25
        Next

        y += 40
        e.Graphics.DrawString("Baker: ________________  Date: ________  Time: ______", font, Brushes.Black, 50, y)
        y += 30
        e.Graphics.DrawString("Checked By: ________________", font, Brushes.Black, 50, y)
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ClearForm()
    End Sub

    Private Sub ClearForm()
        cboSubRecipe.SelectedIndex = -1
        txtMethod.Clear()
        txtBatchQty.Text = "1"
        dgvIngredients.Rows.Clear()
        lblTotalCost.Text = "1 UNIT: Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        lblAdhocCost.Text = "BATCH (1 units): Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
        lblAdhocCost.Visible = True
        _selectedSubRecipeID = 0
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

    Public Sub LoadSubRecipeForEditing(subRecipeID As Integer)
        ' Directly load the sub-recipe without requiring dropdown selection
        _selectedSubRecipeID = subRecipeID
        
        ' Hide and disable the dropdown to prevent accidental changes
        cboSubRecipe.Enabled = False
        
        ' Set the dropdown to the correct sub-recipe for display purposes
        For i As Integer = 0 To cboSubRecipe.Items.Count - 1
            cboSubRecipe.SelectedIndex = i
            If cboSubRecipe.SelectedValue IsNot Nothing AndAlso IsNumeric(cboSubRecipe.SelectedValue) Then
                If CInt(cboSubRecipe.SelectedValue) = subRecipeID Then
                    Exit For
                End If
            End If
        Next
        
        ' Load the sub-recipe data directly
        LoadExistingSubRecipe(subRecipeID)
    End Sub

End Class
