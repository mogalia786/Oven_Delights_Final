Imports System.Data.SqlClient
Imports System.Configuration

Public Class EditSubRecipeForm

    Private ReadOnly _connectionString As String
    Private _recipeService As RecipeCostCalculationService
    Private _currentBranchID As Integer
    Private _currentUserID As Integer
    Private _subRecipeID As Integer
    Private _subRecipeName As String

    Public Sub New(subRecipeID As Integer, subRecipeName As String)
        InitializeComponent()
        _connectionString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
        _recipeService = New RecipeCostCalculationService()
        _currentBranchID = AppSession.CurrentUser.BranchID
        _currentUserID = AppSession.CurrentUser.UserID
        _subRecipeID = subRecipeID
        _subRecipeName = subRecipeName
        
        ' Setup grid columns immediately
        SetupGridColumns()
    End Sub

    Private Sub EditSubRecipeForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        SetupForm()
        LoadIngredients()
        LoadExistingSubRecipe()
    End Sub
    
    Private Sub SetupGridColumns()
        dgvIngredients.AutoGenerateColumns = False
        dgvIngredients.AllowUserToAddRows = False
        dgvIngredients.Columns.Clear()
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "IngredientLineID", .HeaderText = "ID", .Visible = False})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "IngredientID", .HeaderText = "Ingredient ID", .Visible = False})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "IngredientName", .HeaderText = "Ingredient", .Width = 300, .ReadOnly = True})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "Quantity", .HeaderText = "Quantity", .Width = 100, .ReadOnly = False})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitOfMeasure", .HeaderText = "Unit", .Width = 100, .ReadOnly = False})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "PackageSize", .HeaderText = "Package Size", .Width = 100, .ReadOnly = True})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CostPerUnit", .HeaderText = "Cost/Unit", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C6"}})
        dgvIngredients.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "TotalCost", .HeaderText = "Total Cost", .Width = 120, .ReadOnly = True, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "C2"}})
        dgvIngredients.Columns.Add(New DataGridViewButtonColumn With {.Name = "Delete", .HeaderText = "Delete", .Text = "Delete", .UseColumnTextForButtonValue = True, .Width = 70})
    End Sub

    Private Sub SetupForm()
        Me.Text = $"Edit Sub-Recipe: {_subRecipeName}"
        Me.WindowState = FormWindowState.Maximized
        Me.BackColor = Color.FromArgb(240, 240, 245)
        
        lblSubRecipeName.Text = _subRecipeName
        lblSubRecipeName.Font = New Font("Segoe UI", 14, FontStyle.Bold)
        lblSubRecipeName.ForeColor = Color.FromArgb(52, 73, 94)
        
        ApplyGridStyling()
        txtMethod.Font = New Font("Segoe UI", 10)
    End Sub
    
    Private Sub ApplyGridStyling()
        dgvIngredients.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvIngredients.MultiSelect = False
        dgvIngredients.RowHeadersVisible = False
        dgvIngredients.BackgroundColor = Color.White
        dgvIngredients.BorderStyle = BorderStyle.None
        dgvIngredients.CellBorderStyle = DataGridViewCellBorderStyle.SingleHorizontal
        dgvIngredients.DefaultCellStyle.SelectionBackColor = Color.FromArgb(52, 152, 219)
        dgvIngredients.DefaultCellStyle.SelectionForeColor = Color.White
        dgvIngredients.EnableHeadersVisualStyles = False
        dgvIngredients.ColumnHeadersDefaultCellStyle.BackColor = Color.FromArgb(39, 174, 96)
        dgvIngredients.ColumnHeadersDefaultCellStyle.ForeColor = Color.White
        dgvIngredients.ColumnHeadersDefaultCellStyle.Font = New Font("Segoe UI", 10, FontStyle.Bold)
        dgvIngredients.ColumnHeadersHeight = 40
    End Sub

    Private Sub LoadIngredients()
        Dim dt As New DataTable()
        dt.Columns.Add("ProductID", GetType(Integer))
        dt.Columns.Add("Name", GetType(String))
        dt.Columns.Add("Category", GetType(String))

        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "
                SELECT DISTINCT MIN(ProductID) AS ProductID, Name, Category
                FROM Demo_Retail_Product
                WHERE IsActive = 1
                  AND (Category LIKE '%ingredient%' 
                       OR Category LIKE '%consumable%' 
                       OR Category LIKE '%pack%' 
                       OR Category LIKE '%misce%')
                GROUP BY Name, Category
                ORDER BY Name"

            Using cmd As New SqlCommand(query, conn)
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        dt.Rows.Add(reader.GetInt32(0), reader.GetString(1), reader.GetString(2))
                    End While
                End Using
            End Using
        End Using

        cboIngredient.DataSource = Nothing
        cboIngredient.DisplayMember = "Name"
        cboIngredient.ValueMember = "ProductID"
        cboIngredient.DataSource = dt
    End Sub

    Private Sub LoadExistingSubRecipe()
        Dim details = _recipeService.GetSubRecipeDetails(_subRecipeID)
        If details IsNot Nothing Then
            txtMethod.Text = If(IsDBNull(details("Method")), "", details("Method").ToString())
            txtBatchQty.Text = details("BatchQty").ToString()
        End If

        Dim dt = _recipeService.GetSubRecipeIngredients(_subRecipeID)
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
        If cboIngredient.SelectedValue Is Nothing Then
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

        For Each row As DataGridViewRow In dgvIngredients.Rows
            If row.Cells("IngredientID").Value IsNot Nothing AndAlso CInt(row.Cells("IngredientID").Value) = ingredientID Then
                MessageBox.Show("This ingredient is already added.", "Duplicate", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
        Next

        ' Get ingredient details from Demo_Retail_Product
        Using conn As New SqlConnection(_connectionString)
            Dim query As String = "SELECT TOP 1 AverageCost, LastPaidPrice FROM Demo_Retail_Product WHERE ProductID = @ProductID AND BranchID = @BranchID"
            Using cmd As New SqlCommand(query, conn)
                cmd.Parameters.AddWithValue("@ProductID", ingredientID)
                cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
                conn.Open()
                
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    If reader.Read() Then
                        Dim costPerUnit As Decimal = If(IsDBNull(reader("AverageCost")), If(IsDBNull(reader("LastPaidPrice")), 0D, CDec(reader("LastPaidPrice"))), CDec(reader("AverageCost")))
                        Dim totalCost As Decimal = quantity * costPerUnit

                        ' Default values for unit and package size
                        dgvIngredients.Rows.Add(0, ingredientID, ingredientName, quantity, "kg", 1D, costPerUnit, totalCost)
                        CalculateTotalCost()

                        cboIngredient.SelectedIndex = -1
                        txtQuantity.Clear()
                    End If
                End Using
            End Using
        End Using
    End Sub

    Private Sub dgvIngredients_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvIngredients.CellContentClick
        If e.RowIndex < 0 Then Return

        If dgvIngredients.Columns(e.ColumnIndex).Name = "Delete" Then
            Dim ingredientName As String = dgvIngredients.Rows(e.RowIndex).Cells("IngredientName").Value.ToString()
            Dim result = MessageBox.Show($"Are you sure you want to delete '{ingredientName}'?", "Confirm Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            If result = DialogResult.Yes Then
                dgvIngredients.Rows.RemoveAt(e.RowIndex)
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub dgvIngredients_CellEndEdit(sender As Object, e As DataGridViewCellEventArgs) Handles dgvIngredients.CellEndEdit
        If e.RowIndex < 0 Then Return

        Dim row = dgvIngredients.Rows(e.RowIndex)

        If dgvIngredients.Columns(e.ColumnIndex).Name = "Quantity" Then
            If IsNumeric(row.Cells("Quantity").Value) AndAlso IsNumeric(row.Cells("CostPerUnit").Value) Then
                Dim quantity As Decimal = CDec(row.Cells("Quantity").Value)
                Dim costPerUnit As Decimal = CDec(row.Cells("CostPerUnit").Value)
                row.Cells("TotalCost").Value = quantity * costPerUnit
                CalculateTotalCost()
            End If
        End If
    End Sub

    Private Sub CalculateTotalCost()
        Dim totalCost As Decimal = 0
        For Each row As DataGridViewRow In dgvIngredients.Rows
            If row.Cells("TotalCost").Value IsNot Nothing Then
                totalCost += CDec(row.Cells("TotalCost").Value)
            End If
        Next

        Dim batchQty As Decimal = If(IsNumeric(txtBatchQty.Text), CDec(txtBatchQty.Text), 1)
        Dim costPerUnit As Decimal = totalCost / batchQty
        Dim vat As Decimal = totalCost * 0.15D
        Dim totalWithVAT As Decimal = totalCost + vat
        Dim adhocCost As Decimal = totalCost * 1.15D
        Dim adhocVAT As Decimal = adhocCost * 0.15D
        Dim adhocWithVAT As Decimal = adhocCost + adhocVAT

        lblTotalCost.Text = $"1 UNIT: Excl VAT: {costPerUnit:C2} | VAT (15%): {(costPerUnit * 0.15D):C2} | Incl VAT: {(costPerUnit * 1.15D):C2}"
        lblTotalCost.ForeColor = Color.FromArgb(39, 174, 96)

        lblBatchCost.Text = $"BATCH ({batchQty} units): Excl VAT: {totalCost:C2} | VAT (15%): {vat:C2} | Incl VAT: {totalWithVAT:C2}"
        lblBatchCost.ForeColor = Color.FromArgb(52, 152, 219)

        lblAdhocCost.Text = $"WITH ADHOC (+15%): Excl VAT: {adhocCost:C2} | VAT (15%): {adhocVAT:C2} | Incl VAT: {adhocWithVAT:C2}"
        lblAdhocCost.ForeColor = Color.FromArgb(230, 126, 34)
    End Sub

    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        If dgvIngredients.Rows.Count = 0 Then
            MessageBox.Show("Please add at least one ingredient.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        If Not IsNumeric(txtBatchQty.Text) OrElse CDec(txtBatchQty.Text) <= 0 Then
            MessageBox.Show("Please enter a valid batch quantity.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If

        Try
            Using conn As New SqlConnection(_connectionString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        Dim batchQty As Decimal = CDec(txtBatchQty.Text)
                        Dim totalCost As Decimal = 0
                        For Each row As DataGridViewRow In dgvIngredients.Rows
                            If row.Cells("TotalCost").Value IsNot Nothing Then
                                totalCost += CDec(row.Cells("TotalCost").Value)
                            End If
                        Next

                        Dim updateMaster As String = "UPDATE Demo_SubRecipe_Master SET Method = @Method, BatchQty = @BatchQty, TotalCost = @TotalCost, LastUpdated = GETDATE() WHERE SubRecipeID = @SubRecipeID"
                        Using cmd As New SqlCommand(updateMaster, conn, trans)
                            cmd.Parameters.AddWithValue("@Method", If(String.IsNullOrWhiteSpace(txtMethod.Text), DBNull.Value, txtMethod.Text))
                            cmd.Parameters.AddWithValue("@BatchQty", batchQty)
                            cmd.Parameters.AddWithValue("@TotalCost", totalCost)
                            cmd.Parameters.AddWithValue("@SubRecipeID", _subRecipeID)
                            cmd.ExecuteNonQuery()
                        End Using

                        Dim deleteIngredients As String = "DELETE FROM Demo_SubRecipe_Ingredients WHERE SubRecipeID = @SubRecipeID"
                        Using cmd As New SqlCommand(deleteIngredients, conn, trans)
                            cmd.Parameters.AddWithValue("@SubRecipeID", _subRecipeID)
                            cmd.ExecuteNonQuery()
                        End Using

                        For Each row As DataGridViewRow In dgvIngredients.Rows
                            Dim insertIngredient As String = "INSERT INTO Demo_SubRecipe_Ingredients (SubRecipeID, IngredientID, Quantity, UnitOfMeasure, CostPerUnit, IsActive, CreatedDate) VALUES (@SubRecipeID, @IngredientID, @Quantity, @Unit, @CostPerUnit, 1, GETDATE())"
                            Using cmd As New SqlCommand(insertIngredient, conn, trans)
                                cmd.Parameters.AddWithValue("@SubRecipeID", _subRecipeID)
                                cmd.Parameters.AddWithValue("@IngredientID", row.Cells("IngredientID").Value)
                                cmd.Parameters.AddWithValue("@Quantity", row.Cells("Quantity").Value)
                                cmd.Parameters.AddWithValue("@Unit", row.Cells("UnitOfMeasure").Value)
                                cmd.Parameters.AddWithValue("@CostPerUnit", row.Cells("CostPerUnit").Value)
                                cmd.ExecuteNonQuery()
                            End Using
                        Next

                        trans.Commit()
                        MessageBox.Show("Sub-recipe updated successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                        Me.DialogResult = DialogResult.OK
                        Me.Close()

                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using

        Catch ex As Exception
            MessageBox.Show("Error saving sub-recipe: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub

End Class
