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
            ' ALWAYS use Branch 6 (master) ProductIDs for sub-recipes - recipes are universal
            Dim query As String = "
                SELECT ProductID, Name
                FROM Demo_Retail_Product
                WHERE IsActive = 1
                  AND BranchID = 6
                  AND (Category LIKE '%sub%recipe%' OR Category LIKE '%subrecipe%')
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

        ' Load ingredients - prices already updated by sp_RecalculateAllCosts
        For Each row As DataRow In dt.Rows
            Dim quantity As Decimal = CDec(row("Quantity"))
            Dim costPerUnit As Decimal = CDec(row("CostPerUnit"))
            Dim totalCost As Decimal = quantity * costPerUnit
            
            dgvIngredients.Rows.Add(
                row("BOMLineID"),
                row("IngredientID"),
                row("IngredientName"),
                quantity,
                row("UnitOfMeasure"),
                row("PackageSize"),
                costPerUnit,
                totalCost
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
        
        ' Get cost per base unit (kg or L) - use BranchID 6 for master products
        Dim costPerUnit As Decimal = _recipeService.GetIngredientCostPerUnit(ingredientID, 6, packageSize)
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
           dgvIngredients.Columns(e.ColumnIndex).Name = "PackageSize" OrElse
           dgvIngredients.Columns(e.ColumnIndex).Name = "CostPerUnit" Then

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

        ' Single line: Show both unit and batch cost (no adhoc charges)
        lblTotalCost.Text = $"1 UNIT: Excl VAT: {costPerUnit.ToString("C2")} | VAT (15%): {unitVAT.ToString("C2")} | Incl VAT: {unitInclVAT.ToString("C2")} || BATCH ({batchQty} units): Excl VAT: {total.ToString("C2")} | VAT (15%): {batchVAT.ToString("C2")} | Incl VAT: {batchInclVAT.ToString("C2")}"
        lblTotalCost.Font = New Font("Segoe UI", 11, FontStyle.Bold)
        lblTotalCost.ForeColor = Color.FromArgb(39, 174, 96) ' Green
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
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        Dim batchQty As Decimal = CDec(txtBatchQty.Text)
                        Dim method As String = txtMethod.Text.Trim()
                        Dim totalCost As Decimal = 0
                        
                        For Each row As DataGridViewRow In dgvIngredients.Rows
                            If row.Cells("TotalCost").Value IsNot Nothing Then
                                totalCost += CDec(row.Cells("TotalCost").Value)
                            End If
                        Next

                        ' Update or Insert sub-recipe master record
                        Dim cmdMaster As New SqlCommand(
                            "IF EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @SubRecipeID) " &
                            "  UPDATE Demo_SubRecipe_Master SET Method = @Method, BatchQty = @BatchQty, TotalCost = @TotalCost, LastUpdated = GETDATE() WHERE SubRecipeID = @SubRecipeID " &
                            "ELSE " &
                            "  INSERT INTO Demo_SubRecipe_Master (SubRecipeID, Method, BatchQty, TotalCost, IsActive, CreatedBy, CreatedDate) VALUES (@SubRecipeID, @Method, @BatchQty, @TotalCost, 1, @CreatedBy, GETDATE())", conn, trans)
                        cmdMaster.Parameters.AddWithValue("@SubRecipeID", _selectedSubRecipeID)
                        cmdMaster.Parameters.AddWithValue("@Method", If(String.IsNullOrWhiteSpace(method), DBNull.Value, method))
                        cmdMaster.Parameters.AddWithValue("@BatchQty", batchQty)
                        cmdMaster.Parameters.AddWithValue("@TotalCost", totalCost)
                        cmdMaster.Parameters.AddWithValue("@CreatedBy", _currentUserID)
                        cmdMaster.ExecuteNonQuery()

                        ' Delete all existing ingredients from CORRECT table
                        Dim cmdDelete As New SqlCommand("DELETE FROM Demo_SubRecipe_Ingredients WHERE SubRecipeID = @SubRecipeID", conn, trans)
                        cmdDelete.Parameters.AddWithValue("@SubRecipeID", _selectedSubRecipeID)
                        cmdDelete.ExecuteNonQuery()

                        ' Insert all ingredients into CORRECT table
                        For Each row As DataGridViewRow In dgvIngredients.Rows
                            Dim ingredientID As Integer = CInt(row.Cells("IngredientID").Value)
                            Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                            Dim unit As String = row.Cells("UnitOfMeasure").Value.ToString()
                            Dim packageSize As Decimal = CDec(row.Cells("PackageSize").Value)
                            Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)
                            Dim lineTotalCost As Decimal = quantity * costPerUnit

                            Dim cmdInsert As New SqlCommand(
                                "INSERT INTO Demo_SubRecipe_Ingredients (SubRecipeID, IngredientID, Quantity, UnitOfMeasure, PackageSize, CostPerUnit, IsActive, CreatedDate) " &
                                "VALUES (@SubRecipeID, @IngredientID, @Quantity, @UnitOfMeasure, @PackageSize, @CostPerUnit, 1, GETDATE())", conn, trans)
                            cmdInsert.Parameters.AddWithValue("@SubRecipeID", _selectedSubRecipeID)
                            cmdInsert.Parameters.AddWithValue("@IngredientID", ingredientID)
                            cmdInsert.Parameters.AddWithValue("@Quantity", quantity)
                            cmdInsert.Parameters.AddWithValue("@UnitOfMeasure", unit)
                            cmdInsert.Parameters.AddWithValue("@PackageSize", packageSize)
                            cmdInsert.Parameters.AddWithValue("@CostPerUnit", costPerUnit)
                            cmdInsert.ExecuteNonQuery()
                        Next

                        trans.Commit()
                        MessageBox.Show("Sub-recipe saved successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        LoadExistingSubRecipe(_selectedSubRecipeID)

                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using

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

    Private _printIngredientIndex As Integer = 0
    Private _printMethodLineIndex As Integer = 0
    Private _printSection As Integer = 0

    Private Sub PrintSubRecipe()
        _printIngredientIndex = 0
        _printMethodLineIndex = 0
        _printSection = 0
        Dim printDoc As New Printing.PrintDocument()
        AddHandler printDoc.PrintPage, AddressOf PrintPage
        printDoc.Print()
    End Sub

    Private Sub PrintPage(sender As Object, e As Printing.PrintPageEventArgs)
        Dim font As New Font("Courier New", 10)
        Dim boldFont As New Font("Courier New", 12, FontStyle.Bold)
        Dim y As Integer = 50
        Dim pageHeight As Integer = e.PageBounds.Height - 100
        Dim startNewPage As Boolean = False

        ' Print header on first page only
        If _printSection = 0 Then
            e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
            y += 30
            e.Graphics.DrawString("OVEN DELIGHTS - SUB-RECIPE PRODUCTION SHEET", boldFont, Brushes.Black, 100, y)
            y += 30
            e.Graphics.DrawString("═══════════════════════════════════════════════════════════", boldFont, Brushes.Black, 50, y)
            y += 40

            Dim subRecipeName As String = cboSubRecipe.Text
            e.Graphics.DrawString($"Sub-Recipe: {subRecipeName}", boldFont, Brushes.Black, 50, y)
            y += 30
            e.Graphics.DrawString($"Batch Qty: {txtBatchQty.Text}", font, Brushes.Black, 50, y)
            y += 25
            e.Graphics.DrawString($"Date: {DateTime.Now:dd MMM yyyy}", font, Brushes.Black, 50, y)
            y += 40

            e.Graphics.DrawString("INGREDIENTS:", boldFont, Brushes.Black, 50, y)
            y += 30
            _printSection = 1
        End If

        ' Print ingredients
        If _printSection = 1 Then
            While _printIngredientIndex < dgvIngredients.Rows.Count
                If y > pageHeight Then
                    startNewPage = True
                    Exit While
                End If
                Dim row As DataGridViewRow = dgvIngredients.Rows(_printIngredientIndex)
                Dim ingredientName As String = row.Cells("IngredientName").Value.ToString().PadRight(30)
                Dim quantity As String = $"{row.Cells("Quantity").Value} {row.Cells("UnitOfMeasure").Value}".PadRight(15)
                Dim cost As String = CDec(row.Cells("TotalCost").Value).ToString("C2")

                e.Graphics.DrawString($"{ingredientName} {quantity} {cost}", font, Brushes.Black, 50, y)
                y += 25
                _printIngredientIndex += 1
            End While

            If Not startNewPage Then
                y += 20
                If y > pageHeight Then
                    startNewPage = True
                Else
                    e.Graphics.DrawString($"TOTAL COST: {lblTotalCost.Text.Replace("Total Cost Per Sub-Recipe: ", "")}", boldFont, Brushes.Black, 50, y)
                    y += 40
                    If y > pageHeight Then
                        startNewPage = True
                    Else
                        e.Graphics.DrawString("METHOD:", boldFont, Brushes.Black, 50, y)
                        y += 30
                        _printSection = 2
                    End If
                End If
            End If
        End If

        ' Print method
        If _printSection = 2 And Not startNewPage Then
            Dim methodLines = txtMethod.Text.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
            While _printMethodLineIndex < methodLines.Length
                If y > pageHeight Then
                    startNewPage = True
                    Exit While
                End If
                e.Graphics.DrawString(methodLines(_printMethodLineIndex), font, Brushes.Black, 50, y)
                y += 25
                _printMethodLineIndex += 1
            End While

            If Not startNewPage Then
                y += 40
                If y + 55 > pageHeight Then
                    startNewPage = True
                Else
                    e.Graphics.DrawString("Baker: ________________  Date: ________  Time: ______", font, Brushes.Black, 50, y)
                    y += 30
                    e.Graphics.DrawString("Checked By: ________________", font, Brushes.Black, 50, y)
                    _printSection = 3
                End If
            End If
        End If

        ' Set HasMorePages if we need to continue printing
        e.HasMorePages = startNewPage Or _printSection < 3
    End Sub

    Private Sub btnClear_Click(sender As Object, e As EventArgs) Handles btnClear.Click
        ClearForm()
    End Sub

    Private Sub ClearForm()
        cboSubRecipe.SelectedIndex = -1
        txtMethod.Clear()
        txtBatchQty.Text = "1"
        dgvIngredients.Rows.Clear()
        lblTotalCost.Text = "1 UNIT: Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00 || BATCH (1 units): Excl VAT: R0.00 | VAT (15%): R0.00 | Incl VAT: R0.00"
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
