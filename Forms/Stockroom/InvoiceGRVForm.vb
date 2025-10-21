Imports System.Windows.Forms
Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration
Imports Oven_Delights_ERP.UI

Public Class InvoiceGRVForm
    Inherits System.Windows.Forms.Form
    Implements UI.ISidebarProvider

    Private ReadOnly stockroomService As New StockroomService()
    Private currentBranchId As Integer
    Private isSuperAdmin As Boolean
    Private selectedSupplierId As Integer = 0
    Private selectedPOId As Integer = 0

    Public Sub New()
        ' Initialize branch and role info
        currentBranchId = stockroomService.GetCurrentUserBranchId()
        isSuperAdmin = stockroomService.IsCurrentUserSuperAdmin()
        
        InitializeComponent()
        Me.Text = "Invoice & GRV Processing"
        Me.WindowState = FormWindowState.Maximized
        Me.StartPosition = FormStartPosition.CenterParent
    End Sub

    Private Sub InvoiceGRVForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Try
            LoadSuppliers()
            SetupGrid()
            ConfigureControls()
        Catch ex As Exception
            MessageBox.Show($"Form initialization error: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub LoadSuppliers()
        Try
            Dim suppliers = stockroomService.GetSuppliersLookup()
            cboSupplier.DataSource = suppliers
            cboSupplier.DisplayMember = "SupplierName"
            cboSupplier.ValueMember = "SupplierID"
            cboSupplier.SelectedIndex = -1
        Catch ex As Exception
            MessageBox.Show($"Error loading suppliers: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub SetupGrid()
        dgvLines.AutoGenerateColumns = False
        dgvLines.Columns.Clear()
        
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductCode", .HeaderText = "Product Code", .Width = 120, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductName", .HeaderText = "Product Name", .Width = 200, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "OrderedQty", .HeaderText = "Ordered", .Width = 80, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ReceivedQty", .HeaderText = "Received", .Width = 80})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitCost", .HeaderText = "Unit Cost", .Width = 100})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LineTotal", .HeaderText = "Line Total", .Width = 100, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ShortageQty", .HeaderText = "Shortage", .Width = 80, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewButtonColumn With {.Name = "CreditNote", .HeaderText = "Credit Note", .Width = 100, .Text = "Create Credit", .UseColumnTextForButtonValue = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductType", .HeaderText = "Type", .Visible = False})
    End Sub

    Private Sub ConfigureControls()
        txtSubTotal.ReadOnly = True
        txtVAT.ReadOnly = True
        txtTotal.ReadOnly = True
        dtpReceived.Value = DateTime.Now
    End Sub

    Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSupplier.SelectedIndexChanged
        If cboSupplier.SelectedIndex >= 0 Then
            selectedSupplierId = CInt(cboSupplier.SelectedValue)
            LoadPurchaseOrders()
        Else
            selectedSupplierId = 0
            cboPO.DataSource = Nothing
            dgvLines.Rows.Clear()
        End If
    End Sub

    Private Sub LoadPurchaseOrders()
        Try
            Dim pos = stockroomService.GetPurchaseOrdersForSupplier(selectedSupplierId)
            cboPO.DataSource = pos
            cboPO.DisplayMember = "PONumber"
            cboPO.ValueMember = "POID"
            cboPO.SelectedIndex = -1
        Catch ex As Exception
            MessageBox.Show($"Error loading purchase orders: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub cboPO_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboPO.SelectedIndexChanged
        If cboPO.SelectedIndex >= 0 Then
            selectedPOId = CInt(cboPO.SelectedValue)
            LoadPOLines()
        Else
            selectedPOId = 0
            dgvLines.Rows.Clear()
        End If
    End Sub

    Private Sub LoadPOLines()
        Try
            dgvLines.Rows.Clear()
            Dim lines = stockroomService.GetPurchaseOrderLines(selectedPOId)
            
            For Each line As DataRow In lines.Rows
                Dim row As Integer = dgvLines.Rows.Add()
                dgvLines.Rows(row).Cells("ProductCode").Value = line("ProductCode").ToString()
                dgvLines.Rows(row).Cells("ProductName").Value = line("ProductName").ToString()
                dgvLines.Rows(row).Cells("OrderedQty").Value = Convert.ToDecimal(line("OrderedQty"))
                dgvLines.Rows(row).Cells("ReceivedQty").Value = 0D
                dgvLines.Rows(row).Cells("UnitCost").Value = Convert.ToDecimal(line("UnitCost"))
                dgvLines.Rows(row).Cells("LineTotal").Value = 0D
                dgvLines.Rows(row).Cells("ShortageQty").Value = 0D
                dgvLines.Rows(row).Cells("ProductID").Value = line("ProductID")
                dgvLines.Rows(row).Cells("ProductType").Value = line("ProductType").ToString()
            Next
            
            CalculateTotals()
        Catch ex As Exception
            MessageBox.Show($"Error loading PO lines: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub

    Private Sub dgvLines_CellValueChanged(sender As Object, e As DataGridViewCellEventArgs) Handles dgvLines.CellValueChanged
        If e.RowIndex >= 0 AndAlso (e.ColumnIndex = dgvLines.Columns("ReceivedQty").Index OrElse e.ColumnIndex = dgvLines.Columns("UnitCost").Index) Then
            CalculateRowTotal(e.RowIndex)
            CalculateTotals()
        End If
    End Sub

    Private Sub CalculateRowTotal(rowIndex As Integer)
        Try
            Dim row = dgvLines.Rows(rowIndex)
            Dim receivedQty = Convert.ToDecimal(row.Cells("ReceivedQty").Value)
            Dim unitCost = Convert.ToDecimal(row.Cells("UnitCost").Value)
            Dim orderedQty = Convert.ToDecimal(row.Cells("OrderedQty").Value)
            
            row.Cells("LineTotal").Value = receivedQty * unitCost
            row.Cells("ShortageQty").Value = Math.Max(0, orderedQty - receivedQty)
        Catch
            ' Handle invalid input
        End Try
    End Sub

    Private Sub CalculateTotals()
        Try
            Dim subTotal As Decimal = 0
            For Each row As DataGridViewRow In dgvLines.Rows
                If row.Cells("LineTotal").Value IsNot Nothing Then
                    subTotal += Convert.ToDecimal(row.Cells("LineTotal").Value)
                End If
            Next
            
            Dim vat As Decimal = subTotal * 0.15D
            Dim total As Decimal = subTotal + vat
            
            txtSubTotal.Text = subTotal.ToString("F2")
            txtVAT.Text = vat.ToString("F2")
            txtTotal.Text = total.ToString("F2")
        Catch
            ' Handle calculation errors
        End Try
    End Sub

    Private Sub dgvLines_CellContentClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvLines.CellContentClick
        If e.RowIndex >= 0 AndAlso e.ColumnIndex = dgvLines.Columns("CreditNote").Index Then
            CreateCreditNote(e.RowIndex)
        End If
    End Sub

    Private Sub CreateCreditNote(rowIndex As Integer)
        Try
            Dim row = dgvLines.Rows(rowIndex)
            Dim shortageQty = Convert.ToDecimal(row.Cells("ShortageQty").Value)
            
            If shortageQty <= 0 Then
                MessageBox.Show("No shortage to create credit note for.", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim productCode = row.Cells("ProductCode").Value.ToString()
            Dim productName = row.Cells("ProductName").Value.ToString()
            Dim unitCost = Convert.ToDecimal(row.Cells("UnitCost").Value)
            Dim creditAmount = shortageQty * unitCost
            
            Dim result = MessageBox.Show($"Create credit note for {shortageQty} units of {productCode} - {productName}?" & vbCrLf & $"Credit Amount: R{creditAmount:F2}", "Confirm Credit Note", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
            
            If result = DialogResult.Yes Then
                Dim creditNoteId = stockroomService.CreateCreditNote(selectedSupplierId, Convert.ToInt32(row.Cells("ProductID").Value), shortageQty, unitCost, "Short supply", "")
                
                If creditNoteId > 0 Then
                    ' Prepare credit note data for printing
                    Dim creditNote As New CreditNoteData()
                    creditNote.CreditNoteNumber = "CN" & creditNoteId.ToString("D6")
                    creditNote.SupplierName = cboSupplier.Text
                    creditNote.SupplierAddress = "" ' Would need to get from supplier record
                    creditNote.SupplierEmail = "" ' Would need to get from supplier record
                    creditNote.IssueDate = DateTime.Now
                    creditNote.MaterialCode = productCode
                    creditNote.MaterialName = productName
                    creditNote.ReturnQuantity = shortageQty
                    creditNote.UnitCost = unitCost
                    creditNote.TotalAmount = creditAmount
                    creditNote.Reason = "Short supply"
                    creditNote.Comments = ""
                    creditNote.PONumber = cboPO.Text
                    creditNote.DeliveryNote = txtDeliveryNote.Text
                    
                    ' Open credit note print form
                    Dim printForm As New CreditNotePrintForm(creditNote)
                    printForm.ShowDialog()
                    
                    MessageBox.Show($"Credit Note {creditNote.CreditNoteNumber} created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                End If
            End If
        Catch ex As Exception
            MessageBox.Show($"Error creating credit note: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub


    Private Sub btnSave_Click(sender As Object, e As EventArgs) Handles btnSave.Click
        Try
            If selectedSupplierId <= 0 OrElse selectedPOId <= 0 Then
                MessageBox.Show("Please select a supplier and purchase order.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            If dgvLines.Rows.Count = 0 Then
                MessageBox.Show("No items to process.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            
            ProcessGRVAndInvoice()
            
        Catch ex As Exception
            MessageBox.Show($"Error saving: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub ProcessGRVAndInvoice()
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            conn.Open()
            Using trans = conn.BeginTransaction()
                Try
                    ' Create GRV
                    Dim grvId = CreateGRV(conn, trans)
                    
                    ' Create Invoice
                    Dim invoiceId = CreateInvoice(conn, trans)
                    
                    ' Update Stock Levels
                    UpdateStockLevels(conn, trans)
                    
                    ' Update Supplier Ledger
                    UpdateSupplierLedger(conn, trans, invoiceId)
                    
                    trans.Commit()
                    
                    MessageBox.Show($"GRV #{grvId} and Invoice #{invoiceId} created successfully.", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    
                    ClearForm()
                    
                Catch ex As Exception
                    trans.Rollback()
                    Throw
                End Try
            End Using
        End Using
    End Sub

    Private Function CreateGRV(conn As SqlConnection, trans As SqlTransaction) As Integer
        Dim cmd As New SqlCommand("INSERT INTO GoodsReceivedNotes (SupplierID, POID, ReceivedDate, DeliveryNote, SubTotal, VAT, Total, CreatedBy, CreatedDate) OUTPUT INSERTED.GRNID VALUES (@SupplierID, @POID, @ReceivedDate, @DeliveryNote, @SubTotal, @VAT, @Total, @CreatedBy, @CreatedDate)", conn, trans)
        
        cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
        cmd.Parameters.AddWithValue("@POID", selectedPOId)
        cmd.Parameters.AddWithValue("@ReceivedDate", dtpReceived.Value)
        cmd.Parameters.AddWithValue("@DeliveryNote", txtDeliveryNote.Text)
        cmd.Parameters.AddWithValue("@SubTotal", Convert.ToDecimal(txtSubTotal.Text))
        cmd.Parameters.AddWithValue("@VAT", Convert.ToDecimal(txtVAT.Text))
        cmd.Parameters.AddWithValue("@Total", Convert.ToDecimal(txtTotal.Text))
        cmd.Parameters.AddWithValue("@CreatedBy", 1) ' Current user ID
        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now)
        
        Dim grvId = Convert.ToInt32(cmd.ExecuteScalar())
        
        ' Add GRV Lines
        For Each row As DataGridViewRow In dgvLines.Rows
            If Convert.ToDecimal(row.Cells("ReceivedQty").Value) > 0 Then
                Dim lineCmd As New SqlCommand("INSERT INTO GRNLines (GRNID, ProductID, OrderedQty, ReceivedQty, UnitCost, LineTotal) VALUES (@GRVID, @ProductID, @OrderedQty, @ReceivedQty, @UnitCost, @LineTotal)", conn, trans)
                
                lineCmd.Parameters.AddWithValue("@GRVID", grvId)
                lineCmd.Parameters.AddWithValue("@ProductID", row.Cells("ProductID").Value)
                lineCmd.Parameters.AddWithValue("@OrderedQty", row.Cells("OrderedQty").Value)
                lineCmd.Parameters.AddWithValue("@ReceivedQty", row.Cells("ReceivedQty").Value)
                lineCmd.Parameters.AddWithValue("@UnitCost", row.Cells("UnitCost").Value)
                lineCmd.Parameters.AddWithValue("@LineTotal", row.Cells("LineTotal").Value)
                
                lineCmd.ExecuteNonQuery()
            End If
        Next
        
        Return grvId
    End Function

    Private Function CreateInvoice(conn As SqlConnection, trans As SqlTransaction) As Integer
        Dim cmd As New SqlCommand("INSERT INTO SupplierInvoices (SupplierID, BranchID, PurchaseOrderID, InvoiceNumber, InvoiceDate, DueDate, SubTotal, VATAmount, TotalAmount, Status, CreatedBy) OUTPUT INSERTED.InvoiceID VALUES (@SupplierID, @BranchID, @PurchaseOrderID, @InvoiceNumber, @InvoiceDate, @DueDate, @SubTotal, @VATAmount, @TotalAmount, @Status, @CreatedBy)", conn, trans)
        
        cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
        cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOId)
        cmd.Parameters.AddWithValue("@InvoiceNumber", $"GRV-{DateTime.Now:yyyyMMdd}-{selectedPOId}")
        cmd.Parameters.AddWithValue("@InvoiceDate", dtpReceived.Value)
        cmd.Parameters.AddWithValue("@DueDate", dtpReceived.Value.AddDays(30))
        cmd.Parameters.AddWithValue("@SubTotal", Convert.ToDecimal(txtSubTotal.Text))
        cmd.Parameters.AddWithValue("@VATAmount", Convert.ToDecimal(txtVAT.Text))
        cmd.Parameters.AddWithValue("@TotalAmount", Convert.ToDecimal(txtTotal.Text))
        cmd.Parameters.AddWithValue("@Status", "Unpaid")
        cmd.Parameters.AddWithValue("@CreatedBy", 1)
        
        Return Convert.ToInt32(cmd.ExecuteScalar())
    End Function

    Private Sub UpdateStockLevels(conn As SqlConnection, trans As SqlTransaction)
        For Each row As DataGridViewRow In dgvLines.Rows
            Dim receivedQty = Convert.ToDecimal(row.Cells("ReceivedQty").Value)
            If receivedQty > 0 Then
                Dim productId = Convert.ToInt32(row.Cells("ProductID").Value)
                Dim productType = row.Cells("ProductType").Value.ToString()
                
                If productType = "External" Then
                    ' Update Retail_Stock via Retail_Variant
                    Dim cmd As New SqlCommand("UPDATE rs SET rs.QtyOnHand = ISNULL(rs.QtyOnHand, 0) + @Qty FROM Retail_Stock rs INNER JOIN Retail_Variant rv ON rs.VariantID = rv.VariantID WHERE rv.ProductID = @ProductID; IF @@ROWCOUNT = 0 BEGIN DECLARE @vid INT; SELECT @vid = VariantID FROM Retail_Variant WHERE ProductID = @ProductID; IF @vid IS NOT NULL INSERT INTO Retail_Stock(VariantID, QtyOnHand, ReorderPoint, LocationKey, BranchKey) VALUES(@vid, @Qty, 0, 'MAIN', 1); END", conn, trans)
                    cmd.Parameters.AddWithValue("@Qty", receivedQty)
                    cmd.Parameters.AddWithValue("@ProductID", productId)
                    cmd.ExecuteNonQuery()
                ElseIf productType = "Internal" Then
                    ' Update RawMaterials stock - use CurrentStock not StockLevel
                    Dim cmd As New SqlCommand("UPDATE RawMaterials SET CurrentStock = ISNULL(CurrentStock, 0) + @Qty WHERE MaterialID = @MaterialID", conn, trans)
                    cmd.Parameters.AddWithValue("@Qty", receivedQty)
                    cmd.Parameters.AddWithValue("@MaterialID", productId)
                    cmd.ExecuteNonQuery()
                End If
                
                ' Create stock movement record
                Dim movCmd As New SqlCommand("INSERT INTO Stockroom_StockMovements (MaterialID, MovementType, Quantity, UnitCost, TotalValue, MovementDate, Reference, BranchID) VALUES (@MaterialID, @MovementType, @Quantity, @UnitCost, @TotalValue, @MovementDate, @Reference, @BranchID)", conn, trans)
                movCmd.Parameters.AddWithValue("@MaterialID", productId)
                movCmd.Parameters.AddWithValue("@MovementType", "Receipt")
                movCmd.Parameters.AddWithValue("@Quantity", receivedQty)
                movCmd.Parameters.AddWithValue("@UnitCost", row.Cells("UnitCost").Value)
                movCmd.Parameters.AddWithValue("@TotalValue", row.Cells("LineTotal").Value)
                movCmd.Parameters.AddWithValue("@MovementDate", dtpReceived.Value)
                movCmd.Parameters.AddWithValue("@Reference", $"GRV-{txtDeliveryNote.Text}")
                movCmd.Parameters.AddWithValue("@BranchID", 1)
                movCmd.ExecuteNonQuery()
            End If
        Next
    End Sub

    Private Sub UpdateSupplierLedger(conn As SqlConnection, trans As SqlTransaction, invoiceId As Integer)
        Try
            ' Create supplier ledger entry
            Dim cmd As New SqlCommand("INSERT INTO Stockroom_SupplierLedger (SupplierID, InvoiceID, TransactionType, Amount, TransactionDate, Description, Balance) VALUES (@SupplierID, @InvoiceID, @TransactionType, @Amount, @TransactionDate, @Description, @Balance)", conn, trans)
            
            cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
            cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
            cmd.Parameters.AddWithValue("@TransactionType", "Invoice")
            cmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtTotal.Text))
            cmd.Parameters.AddWithValue("@TransactionDate", dtpReceived.Value)
            cmd.Parameters.AddWithValue("@Description", $"GRV Invoice - {txtDeliveryNote.Text}")
            cmd.Parameters.AddWithValue("@Balance", Convert.ToDecimal(txtTotal.Text))
            
            cmd.ExecuteNonQuery()
            
            ' Update supplier balance
            Dim balCmd As New SqlCommand("UPDATE Suppliers SET Balance = ISNULL(Balance, 0) + @Amount WHERE SupplierID = @SupplierID", conn, trans)
            balCmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtTotal.Text))
            balCmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
            balCmd.ExecuteNonQuery()
        Catch ex As Exception
            ' Log error but don't fail transaction
            System.Diagnostics.Debug.WriteLine($"Supplier ledger update error: {ex.Message}")
        End Try
    End Sub

    Private Sub ClearForm()
        cboSupplier.SelectedIndex = -1
        cboPO.DataSource = Nothing
        dgvLines.Rows.Clear()
        txtDeliveryNote.Text = ""
        txtSubTotal.Text = "0.00"
        txtVAT.Text = "0.00"
        txtTotal.Text = "0.00"
        dtpReceived.Value = DateTime.Now
    End Sub

    Private Sub btnCancel_Click(sender As Object, e As EventArgs) Handles btnCancel.Click
        Me.Close()
    End Sub

    ' ISidebarProvider implementation
    Public Event SidebarContextChanged As EventHandler Implements UI.ISidebarProvider.SidebarContextChanged

    Public Function BuildSidebarPanel() As Panel Implements UI.ISidebarProvider.BuildSidebarPanel
        Dim panel As New Panel()
        Dim lbl As New Label() With {
            .Text = "Invoice & GRV Processing" & vbCrLf & "Process supplier invoices and goods received vouchers with automatic stock updates and ledger postings.",
            .Dock = DockStyle.Fill,
            .Padding = New Padding(8)
        }
        panel.Controls.Add(lbl)
        Return panel
    End Function

End Class
