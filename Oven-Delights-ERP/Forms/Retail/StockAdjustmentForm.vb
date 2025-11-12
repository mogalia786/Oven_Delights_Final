Imports System.Data.SqlClient
Imports System.Configuration

Namespace Retail
    Public Class StockAdjustmentForm
    Private connectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString
    Private currentBranchID As Integer = 0
    Private currentUserName As String = ""

    Private Sub StockAdjustmentForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            If AppSession.CurrentUser Is Nothing Then
                MessageBox.Show("User session not found. Please log in again.", "Authentication Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Me.Close()
                Return
            End If
            
            currentUserName = AppSession.CurrentUser.Username
            currentBranchID = AppSession.CurrentUser.BranchID
            
            SetupDataGridView()
            LoadInternalProducts()
            
            cmbReason.Items.AddRange({"Expired", "Damaged", "Stale", "Quality Issue", "Theft/Loss", "Other"})
            cmbReason.SelectedIndex = 0
            
        Catch ex As Exception
            MessageBox.Show("Error loading form: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub SetupDataGridView()
        dgvProducts.AutoGenerateColumns = False
        dgvProducts.Columns.Clear()
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductID", .DataPropertyName = "ProductID", .Visible = False})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Product Name", .DataPropertyName = "ProductName", .Width = 300})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "SKU", .HeaderText = "Barcode", .DataPropertyName = "SKU", .Width = 120})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "CurrentStock", .HeaderText = "Current Stock", .DataPropertyName = "CurrentStock", .Width = 100})
        dgvProducts.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitCost", .HeaderText = "Unit Cost", .DataPropertyName = "UnitCost", .Width = 100, .DefaultCellStyle = New DataGridViewCellStyle With {.Format = "N2"}})
    End Sub

    Private Sub LoadInternalProducts()
        Try
            Using conn As New SqlConnection(connectionString)
                ' Load only internal products (manufactured) with current stock
                Dim cmd As New SqlCommand("
                    SELECT 
                        p.ProductID,
                        p.Name AS ProductName,
                        p.SKU,
                        ISNULL(p.CurrentStock, 0) AS CurrentStock,
                        ISNULL((SELECT TOP 1 CostPrice FROM demo_Retail_price WHERE ProductID = p.ProductID AND BranchID = @BranchID ORDER BY EffectiveFrom DESC), 0) AS UnitCost
                    FROM demo_Retail_product p
                    WHERE p.IsActive = 1 AND p.BranchID = @BranchID
                    ORDER BY p.Name", conn)
                
                cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                conn.Open()
                
                Dim dt As New DataTable()
                dt.Load(cmd.ExecuteReader())
                
                dgvProducts.DataSource = dt
                lblProductCount.Text = $"Internal Products: {dt.Rows.Count}"
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading products: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub txtSearch_TextChanged(sender As Object, e As EventArgs) Handles txtSearch.TextChanged
        Try
            If dgvProducts.DataSource IsNot Nothing Then
                Dim dv As DataView = CType(dgvProducts.DataSource, DataTable).DefaultView
                dv.RowFilter = $"ProductName LIKE '%{txtSearch.Text}%' OR SKU LIKE '%{txtSearch.Text}%'"
            End If
        Catch ex As Exception
            ' Ignore filter errors
        End Try
    End Sub

    Private Sub dgvProducts_CellClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvProducts.CellClick
        If e.RowIndex >= 0 Then
            Dim row As DataGridViewRow = dgvProducts.Rows(e.RowIndex)
            
            txtProductName.Text = row.Cells("ProductName").Value.ToString()
            txtBarcode.Text = row.Cells("SKU").Value.ToString()
            txtCurrentStock.Text = row.Cells("CurrentStock").Value.ToString()
            txtUnitCost.Text = CDec(row.Cells("UnitCost").Value).ToString("N2")
            
            nudAdjustmentQty.Value = 0
            nudAdjustmentQty.Maximum = CDec(row.Cells("CurrentStock").Value)
            
            CalculateValue()
        End If
    End Sub

    Private Sub nudAdjustmentQty_ValueChanged(sender As Object, e As EventArgs) Handles nudAdjustmentQty.ValueChanged
        CalculateValue()
    End Sub

    Private Sub CalculateValue()
        Try
            Dim qty As Decimal = nudAdjustmentQty.Value
            Dim unitCost As Decimal = If(String.IsNullOrEmpty(txtUnitCost.Text), 0, CDec(txtUnitCost.Text))
            Dim totalValue As Decimal = qty * unitCost
            
            txtTotalValue.Text = totalValue.ToString("N2")
        Catch ex As Exception
            txtTotalValue.Text = "0.00"
        End Try
    End Sub

    Private Sub btnAdjust_Click(sender As Object, e As EventArgs) Handles btnAdjust.Click
        If dgvProducts.SelectedRows.Count = 0 Then
            MessageBox.Show("Please select a product", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If nudAdjustmentQty.Value <= 0 Then
            MessageBox.Show("Please enter adjustment quantity", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If String.IsNullOrWhiteSpace(txtNotes.Text) Then
            MessageBox.Show("Please enter notes/reason for adjustment", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim productID As Integer = CInt(dgvProducts.SelectedRows(0).Cells("ProductID").Value)
        Dim productName As String = txtProductName.Text
        Dim currentStock As Decimal = CDec(txtCurrentStock.Text)
        Dim adjustmentQty As Decimal = nudAdjustmentQty.Value
        Dim unitCost As Decimal = CDec(txtUnitCost.Text)
        Dim reason As String = If(cmbReason.SelectedItem IsNot Nothing, cmbReason.SelectedItem.ToString(), "")
        Dim notes As String = $"{reason}: {txtNotes.Text}"
        
        Dim result As DialogResult = MessageBox.Show(
            $"Adjust stock for:{vbCrLf}{productName}{vbCrLf}{vbCrLf}" &
            $"Current Stock: {currentStock}{vbCrLf}" &
            $"Adjustment: -{adjustmentQty}{vbCrLf}" &
            $"New Stock: {currentStock - adjustmentQty}{vbCrLf}" &
            $"Value: R{txtTotalValue.Text}{vbCrLf}{vbCrLf}" &
            $"Reason: {notes}{vbCrLf}{vbCrLf}" &
            "Confirm adjustment?",
            "Confirm Stock Adjustment",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(connectionString)
                    conn.Open()
                    
                    ' Update CurrentStock in demo_Retail_product
                    Dim newStock As Decimal = currentStock - adjustmentQty
                    Dim cmdUpdate As New SqlCommand("
                        UPDATE demo_Retail_product 
                        SET CurrentStock = @NewStock 
                        WHERE ProductID = @ProductID AND BranchID = @BranchID", conn)
                    
                    cmdUpdate.Parameters.AddWithValue("@NewStock", newStock)
                    cmdUpdate.Parameters.AddWithValue("@ProductID", productID)
                    cmdUpdate.Parameters.AddWithValue("@BranchID", currentBranchID)
                    cmdUpdate.ExecuteNonQuery()
                    
                    ' Create stock movement for adjustment (reduction)
                    Dim cmd As New SqlCommand("
                        INSERT INTO StockMovements (
                            MaterialID, MovementType, MovementDate,
                            QuantityOut, BalanceAfter, UnitCost, TotalValue,
                            InventoryArea, FromLocation, ToLocation,
                            ReferenceType, ReferenceNumber,
                            BranchID, CreatedBy, CreatedDate, Notes
                        )
                        VALUES (
                            @MaterialID, 'Stock Adjustment', GETDATE(),
                            @QuantityOut, @BalanceAfter, @UnitCost, @TotalValue,
                            'Retail', 'Retail', 'Adjustment',
                            'Adjustment', @ReferenceNumber,
                            @BranchID, @CreatedBy, GETDATE(), @Notes
                        )", conn)
                    
                    cmd.Parameters.AddWithValue("@MaterialID", productID)
                    cmd.Parameters.AddWithValue("@QuantityOut", adjustmentQty)
                    cmd.Parameters.AddWithValue("@BalanceAfter", newStock)
                    cmd.Parameters.AddWithValue("@UnitCost", unitCost)
                    cmd.Parameters.AddWithValue("@TotalValue", adjustmentQty * unitCost)
                    cmd.Parameters.AddWithValue("@ReferenceNumber", $"ADJ-{DateTime.Now:yyyyMMddHHmmss}")
                    cmd.Parameters.AddWithValue("@BranchID", currentBranchID)
                    cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
                    cmd.Parameters.AddWithValue("@Notes", notes)
                    
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show("Stock adjustment recorded successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    ' Refresh and reset
                    LoadInternalProducts()
                    ResetForm()
                End Using
            Catch ex As Exception
                MessageBox.Show("Error recording adjustment: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub

    Private Sub ResetForm()
        txtProductName.Text = ""
        txtBarcode.Text = ""
        txtCurrentStock.Text = ""
        txtUnitCost.Text = ""
        txtTotalValue.Text = ""
        nudAdjustmentQty.Value = 0
        txtNotes.Text = ""
        cmbReason.SelectedIndex = 0
    End Sub

    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadInternalProducts()
    End Sub

    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
    End Class
End Namespace
