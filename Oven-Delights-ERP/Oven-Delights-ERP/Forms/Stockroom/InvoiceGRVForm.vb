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
            cboSupplier.DisplayMember = "CompanyName"
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
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "UnitCost", .HeaderText = "Unit Cost (Incl VAT)", .Width = 120})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "LineTotal", .HeaderText = "Line Total", .Width = 100, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ShortageQty", .HeaderText = "Shortage", .Width = 80, .ReadOnly = True})
        dgvLines.Columns.Add(New DataGridViewButtonColumn With {.Name = "CreditNote", .HeaderText = "Credit Note", .Width = 100, .Text = "Create Credit", .UseColumnTextForButtonValue = True})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductID", .HeaderText = "ProductID", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewTextBoxColumn With {.Name = "ProductType", .HeaderText = "Type", .Visible = False})
        dgvLines.Columns.Add(New DataGridViewCheckBoxColumn With {.Name = "IsVatable", .HeaderText = "VATable", .Visible = False})
    End Sub

    Private Sub ConfigureControls()
        txtSubTotal.ReadOnly = True
        txtVAT.ReadOnly = True
        txtTotal.ReadOnly = True
        dtpReceived.Value = DateTime.Now
    End Sub

    Private Sub cboSupplier_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboSupplier.SelectedIndexChanged
        Try
            If cboSupplier.SelectedIndex >= 0 AndAlso cboSupplier.SelectedValue IsNot Nothing Then
                ' Handle both Integer and DataRowView cases
                If TypeOf cboSupplier.SelectedValue Is DataRowView Then
                    Dim drv As DataRowView = CType(cboSupplier.SelectedValue, DataRowView)
                    selectedSupplierId = CInt(drv("SupplierID"))
                ElseIf IsNumeric(cboSupplier.SelectedValue) Then
                    selectedSupplierId = CInt(cboSupplier.SelectedValue)
                Else
                    selectedSupplierId = 0
                End If

                If selectedSupplierId > 0 Then
                    LoadPurchaseOrders()
                End If
            Else
                selectedSupplierId = 0
                cboPO.DataSource = Nothing
                dgvLines.Rows.Clear()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error selecting supplier: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            selectedSupplierId = 0
        End Try
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
        Try
            If cboPO.SelectedIndex >= 0 AndAlso cboPO.SelectedValue IsNot Nothing Then
                ' Handle both Integer and DataRowView cases
                If TypeOf cboPO.SelectedValue Is DataRowView Then
                    Dim drv As DataRowView = CType(cboPO.SelectedValue, DataRowView)
                    selectedPOId = CInt(drv("POID"))
                ElseIf IsNumeric(cboPO.SelectedValue) Then
                    selectedPOId = CInt(cboPO.SelectedValue)
                Else
                    selectedPOId = 0
                End If

                If selectedPOId > 0 Then
                    LoadPOLines()
                End If
            Else
                selectedPOId = 0
                dgvLines.Rows.Clear()
            End If
        Catch ex As Exception
            MessageBox.Show($"Error selecting purchase order: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            selectedPOId = 0
        End Try
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
                dgvLines.Rows(row).Cells("IsVatable").Value = If(line.Table.Columns.Contains("IsVatable"), line("IsVatable"), True)
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
            ' Unit Cost in grid is INCLUSIVE of VAT (from PO Line Total / Qty)
            ' Need to calculate backwards: SubTotal (excl), VAT, Total (incl)
            Dim totalIncl As Decimal = 0
            Dim subTotalExcl As Decimal = 0
            
            For Each row As DataGridViewRow In dgvLines.Rows
                If row.Cells("LineTotal").Value IsNot Nothing Then
                    Dim lineTotal = Convert.ToDecimal(row.Cells("LineTotal").Value)
                    Dim isVatable = If(row.Cells("IsVatable").Value IsNot Nothing, Convert.ToBoolean(row.Cells("IsVatable").Value), True)
                    
                    totalIncl += lineTotal
                    
                    ' If VATable, line total includes VAT, so excl = incl / 1.15
                    ' If not VATable, line total = excl (no VAT)
                    subTotalExcl += If(isVatable, lineTotal / 1.15D, lineTotal)
                End If
            Next
            
            Dim vat As Decimal = totalIncl - subTotalExcl
            
            txtSubTotal.Text = subTotalExcl.ToString("F2")
            txtVAT.Text = vat.ToString("F2")
            txtTotal.Text = totalIncl.ToString("F2")
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
            
            If String.IsNullOrWhiteSpace(txtDeliveryNote.Text) Then
                MessageBox.Show("Please enter an Invoice Number.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtDeliveryNote.Focus()
                Return
            End If
            
            ' Check for duplicate invoice number
            If CheckDuplicateInvoiceNumber(txtDeliveryNote.Text.Trim(), selectedSupplierId) Then
                MessageBox.Show($"[InvoiceGRVForm.vb Line 287] Invoice Number '{txtDeliveryNote.Text.Trim()}' already exists for this supplier. Please enter a unique invoice number.", "Duplicate Invoice", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                txtDeliveryNote.Focus()
                txtDeliveryNote.SelectAll()
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
    
    Private Function CheckDuplicateInvoiceNumber(invoiceNumber As String, supplierId As Integer) As Boolean
        Try
            Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
                conn.Open()
                Dim sql As String = "SELECT COUNT(*) FROM SupplierInvoices WHERE InvoiceNumber = @InvoiceNumber AND SupplierID = @SupplierID"
                Using cmd As New SqlCommand(sql, conn)
                    cmd.Parameters.AddWithValue("@InvoiceNumber", invoiceNumber)
                    cmd.Parameters.AddWithValue("@SupplierID", supplierId)
                    Dim count As Integer = CInt(cmd.ExecuteScalar())
                    Return count > 0
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show($"Error checking duplicate invoice: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End Try
    End Function

    Private Sub ProcessGRVAndInvoice()
        Using conn As New SqlConnection(ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString").ConnectionString)
            conn.Open()
            
            Using trans = conn.BeginTransaction()
                Try
                    ' Set QUOTED_IDENTIFIER ON within transaction
                    Using cmd As New SqlCommand("SET QUOTED_IDENTIFIER ON", conn, trans)
                        cmd.ExecuteNonQuery()
                    End Using
                    
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
        Dim cmd As New SqlCommand("INSERT INTO GoodsReceivedNotes (SupplierID, PurchaseOrderID, ReceivedDate, DeliveryNote, SubTotal, VAT, Total, CreatedBy, CreatedDate) OUTPUT INSERTED.GRNID VALUES (@SupplierID, @PurchaseOrderID, @ReceivedDate, @DeliveryNote, @SubTotal, @VAT, @Total, @CreatedBy, @CreatedDate)", conn, trans)

        cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
        cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOId)
        cmd.Parameters.AddWithValue("@ReceivedDate", dtpReceived.Value)
        cmd.Parameters.AddWithValue("@DeliveryNote", txtDeliveryNote.Text)
        cmd.Parameters.AddWithValue("@SubTotal", Convert.ToDecimal(txtSubTotal.Text))
        cmd.Parameters.AddWithValue("@VAT", Convert.ToDecimal(txtVAT.Text))
        cmd.Parameters.AddWithValue("@Total", Convert.ToDecimal(txtTotal.Text))
        cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
        cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now)

        Dim grvId = Convert.ToInt32(cmd.ExecuteScalar())

        ' Add GRV Lines
        For Each row As DataGridViewRow In dgvLines.Rows
            If Convert.ToDecimal(row.Cells("ReceivedQty").Value) > 0 Then
                Dim lineCmd As New SqlCommand("INSERT INTO GRNLines (GRNID, ProductID, OrderedQuantity, ReceivedQuantity, UnitCost, LineTotal) VALUES (@GRVID, @ProductID, @OrderedQuantity, @ReceivedQuantity, @UnitCost, @LineTotal)", conn, trans)

                lineCmd.Parameters.AddWithValue("@GRVID", grvId)
                lineCmd.Parameters.AddWithValue("@ProductID", row.Cells("ProductID").Value)
                lineCmd.Parameters.AddWithValue("@OrderedQuantity", row.Cells("OrderedQty").Value)
                lineCmd.Parameters.AddWithValue("@ReceivedQuantity", row.Cells("ReceivedQty").Value)
                lineCmd.Parameters.AddWithValue("@UnitCost", row.Cells("UnitCost").Value)
                lineCmd.Parameters.AddWithValue("@LineTotal", row.Cells("LineTotal").Value)

                lineCmd.ExecuteNonQuery()
            End If
        Next

        Return grvId
    End Function

    Private Function CreateInvoice(conn As SqlConnection, trans As SqlTransaction) As Integer
        Dim cmd As New SqlCommand("INSERT INTO SupplierInvoices (SupplierID, BranchID, PurchaseOrderID, InvoiceNumber, InvoiceDate, DueDate, SubTotal, VATAmount, TotalAmount, Status, CreatedBy) VALUES (@SupplierID, @BranchID, @PurchaseOrderID, @InvoiceNumber, @InvoiceDate, @DueDate, @SubTotal, @VATAmount, @TotalAmount, @Status, @CreatedBy); SELECT SCOPE_IDENTITY();", conn, trans)

        cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
        cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
        cmd.Parameters.AddWithValue("@PurchaseOrderID", selectedPOId)
        cmd.Parameters.AddWithValue("@InvoiceNumber", txtDeliveryNote.Text.Trim())
        cmd.Parameters.AddWithValue("@InvoiceDate", dtpReceived.Value)
        cmd.Parameters.AddWithValue("@DueDate", dtpReceived.Value.AddDays(30))
        cmd.Parameters.AddWithValue("@SubTotal", Convert.ToDecimal(txtSubTotal.Text))
        cmd.Parameters.AddWithValue("@VATAmount", Convert.ToDecimal(txtVAT.Text))
        cmd.Parameters.AddWithValue("@TotalAmount", Convert.ToDecimal(txtTotal.Text))
        cmd.Parameters.AddWithValue("@Status", "Unpaid")
        cmd.Parameters.AddWithValue("@CreatedBy", 1)

        Dim invoiceId = Convert.ToInt32(cmd.ExecuteScalar())
        
        ' Debug: Show grid state
        Dim debugMsg As String = $"Grid Rows: {dgvLines.Rows.Count}" & vbCrLf
        For i As Integer = 0 To Math.Min(2, dgvLines.Rows.Count - 1)
            Dim r = dgvLines.Rows(i)
            debugMsg &= $"Row {i}: Code={r.Cells("ProductCode").Value}, RecvQty={r.Cells("ReceivedQty").Value}" & vbCrLf
        Next
        MessageBox.Show(debugMsg, "DEBUG Grid State")
        
        ' Add Invoice Lines - same pattern as GRV lines
        Dim lineNumber As Integer = 1
        For Each row As DataGridViewRow In dgvLines.Rows
            If Convert.ToDecimal(row.Cells("ReceivedQty").Value) > 0 Then
                Dim lineCmd As New SqlCommand("INSERT INTO SupplierInvoiceLines (InvoiceID, LineNumber, ProductCode, ProductName, Quantity, UnitPrice, LineTotal) VALUES (@InvoiceID, @LineNumber, @ProductCode, @ProductName, @Quantity, @UnitPrice, @LineTotal)", conn, trans)
                
                lineCmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
                lineCmd.Parameters.AddWithValue("@LineNumber", lineNumber)
                lineCmd.Parameters.AddWithValue("@ProductCode", row.Cells("ProductCode").Value)
                lineCmd.Parameters.AddWithValue("@ProductName", row.Cells("ProductName").Value)
                lineCmd.Parameters.AddWithValue("@Quantity", row.Cells("ReceivedQty").Value)
                lineCmd.Parameters.AddWithValue("@UnitPrice", row.Cells("UnitCost").Value)
                lineCmd.Parameters.AddWithValue("@LineTotal", row.Cells("LineTotal").Value)
                
                lineCmd.ExecuteNonQuery()
                lineNumber += 1
            End If
        Next

        Return invoiceId
    End Function

    Private Sub UpdateStockLevels(conn As SqlConnection, trans As SqlTransaction)
        For Each row As DataGridViewRow In dgvLines.Rows
            Dim receivedQty = Convert.ToDecimal(row.Cells("ReceivedQty").Value)
            If receivedQty > 0 Then
                Dim productId = Convert.ToInt32(row.Cells("ProductID").Value)
                Dim productType = row.Cells("ProductType").Value.ToString()
                
                ' DEBUG: Show what we're about to update
                MessageBox.Show($"BEFORE UPDATE: ProductID={productId}, BranchID={currentBranchId}, Qty={receivedQty}, ProductName={row.Cells("ProductName").Value}", "DEBUG BEFORE", MessageBoxButtons.OK, MessageBoxIcon.Information)

                ' Update CurrentStock in Demo_Retail_Product for this branch
                Dim cmd As New SqlCommand(
                    "UPDATE Demo_Retail_Product SET CurrentStock = ISNULL(CurrentStock, 0) + @Qty " &
                    "WHERE ProductID = @ProductID AND BranchID = @BranchID", conn, trans)
                cmd.Parameters.AddWithValue("@Qty", receivedQty)
                cmd.Parameters.AddWithValue("@ProductID", productId)
                cmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                Dim rowsAffected = cmd.ExecuteNonQuery()
                
                ' DEBUG: Show what happened
                MessageBox.Show($"Stock Update: ProductID={productId}, BranchID={currentBranchId}, Qty={receivedQty}, RowsAffected={rowsAffected}", "DEBUG", MessageBoxButtons.OK, MessageBoxIcon.Information)
                
                ' Update Demo_Retail_Product AverageCost and LastPaidPrice
                ' NOTE: All master products are in BranchID=6, so update there regardless of current user branch
                Dim unitCost = Convert.ToDecimal(row.Cells("UnitCost").Value)
                Dim cmdProduct As New SqlCommand(
                    "UPDATE Demo_Retail_Product SET AverageCost = @UnitCost, LastPaidPrice = @UnitCost " &
                    "WHERE ProductID = @ProductID AND BranchID = 6", conn, trans)
                cmdProduct.Parameters.AddWithValue("@ProductID", productId)
                cmdProduct.Parameters.AddWithValue("@UnitCost", unitCost)
                cmdProduct.ExecuteNonQuery()
                
                ' Update Demo_Retail_Price with last paid price for this branch
                Dim cmdPrice As New SqlCommand(
                    "IF EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = @ProductID AND BranchID = @BranchID) " &
                    "  UPDATE Demo_Retail_Price SET CostPrice = @UnitCost WHERE ProductID = @ProductID AND BranchID = @BranchID " &
                    "ELSE " &
                    "  INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, EffectiveFrom) VALUES (@ProductID, @BranchID, @UnitCost, GETDATE())", conn, trans)
                cmdPrice.Parameters.AddWithValue("@ProductID", productId)
                cmdPrice.Parameters.AddWithValue("@BranchID", currentBranchId)
                cmdPrice.Parameters.AddWithValue("@UnitCost", unitCost)
                cmdPrice.ExecuteNonQuery()
                
                ' Record price history using stored procedure
                Try
                    Dim cmdHistory As New SqlCommand("sp_RecordProductPriceFromInvoice", conn, trans)
                    cmdHistory.CommandType = CommandType.StoredProcedure
                    cmdHistory.Parameters.AddWithValue("@ProductID", productId)
                    cmdHistory.Parameters.AddWithValue("@SKU", If(dgvLines.Columns.Contains("SKU") AndAlso row.Cells("SKU").Value IsNot Nothing, row.Cells("SKU").Value, DBNull.Value))
                    cmdHistory.Parameters.AddWithValue("@ProductName", row.Cells("ProductName").Value.ToString())
                    cmdHistory.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
                    cmdHistory.Parameters.AddWithValue("@SupplierName", cboSupplier.Text)
                    cmdHistory.Parameters.AddWithValue("@InvoiceNumber", $"GRV-{DateTime.Now:yyyyMMdd}-{selectedPOId}")
                    cmdHistory.Parameters.AddWithValue("@InvoiceDate", dtpReceived.Value)
                    cmdHistory.Parameters.AddWithValue("@CostPrice", unitCost)
                    cmdHistory.Parameters.AddWithValue("@Quantity", receivedQty)
                    cmdHistory.Parameters.AddWithValue("@UnitOfMeasure", If(dgvLines.Columns.Contains("UOM") AndAlso row.Cells("UOM").Value IsNot Nothing, row.Cells("UOM").Value, "Each"))
                    cmdHistory.Parameters.AddWithValue("@BranchID", currentBranchId)
                    cmdHistory.Parameters.AddWithValue("@CapturedBy", AppSession.CurrentUser.Username)
                    cmdHistory.ExecuteNonQuery()
                Catch ex As Exception
                    ' Price history is optional - don't fail if it errors
                    Debug.WriteLine($"Price history error: {ex.Message}")
                End Try

                ' Create stock movement record
                Dim movCmd As New SqlCommand("INSERT INTO StockMovements (MaterialID, MovementType, QuantityIn, UnitCost, TotalValue, MovementDate, ReferenceType, ReferenceNumber, BranchID, InventoryArea, CreatedBy, CreatedDate) VALUES (@MaterialID, @MovementType, @QuantityIn, @UnitCost, @TotalValue, @MovementDate, @ReferenceType, @ReferenceNumber, @BranchID, @InventoryArea, @CreatedBy, @CreatedDate)", conn, trans)
                movCmd.Parameters.AddWithValue("@MaterialID", productId)
                movCmd.Parameters.AddWithValue("@MovementType", "Receipt")
                movCmd.Parameters.AddWithValue("@QuantityIn", receivedQty)
                movCmd.Parameters.AddWithValue("@UnitCost", row.Cells("UnitCost").Value)
                movCmd.Parameters.AddWithValue("@TotalValue", row.Cells("LineTotal").Value)
                movCmd.Parameters.AddWithValue("@MovementDate", dtpReceived.Value)
                movCmd.Parameters.AddWithValue("@ReferenceType", "GRV")
                movCmd.Parameters.AddWithValue("@ReferenceNumber", txtDeliveryNote.Text)
                movCmd.Parameters.AddWithValue("@BranchID", currentBranchId)
                movCmd.Parameters.AddWithValue("@InventoryArea", If(productType = "External", "Retail", "Stockroom"))
                movCmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
                movCmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now)
                movCmd.ExecuteNonQuery()
            End If
        Next
        
        ' CRITICAL: Recalculate ALL sub-recipe and product costs after updating ingredient prices
        ' This runs on EVERY GRV to ensure costs are always accurate, regardless of price changes
        Dim cmdRecalc As New SqlCommand("sp_RecalculateAllCosts", conn, trans)
        cmdRecalc.CommandType = CommandType.StoredProcedure
        cmdRecalc.ExecuteNonQuery()
        
        MessageBox.Show("Stored procedure sp_RecalculateAllCosts executed successfully! All sub-recipe and product costs have been recalculated.", "Price Update", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub

    Private Sub UpdateSupplierLedger(conn As SqlConnection, trans As SqlTransaction, invoiceId As Integer)
        Try
            ' Create supplier ledger entry
            Dim cmd As New SqlCommand("INSERT INTO SupplierLedger (SupplierID, InvoiceID, TransactionType, Credit, TransactionDate, Description, Balance, Reference, IsReversed, CreatedBy, CreatedDate) VALUES (@SupplierID, @InvoiceID, @TransactionType, @Credit, @TransactionDate, @Description, @Balance, @Reference, @IsReversed, @CreatedBy, @CreatedDate)", conn, trans)

            cmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
            cmd.Parameters.AddWithValue("@InvoiceID", invoiceId)
            cmd.Parameters.AddWithValue("@TransactionType", "Invoice")
            cmd.Parameters.AddWithValue("@Credit", Convert.ToDecimal(txtTotal.Text))
            cmd.Parameters.AddWithValue("@TransactionDate", dtpReceived.Value)
            cmd.Parameters.AddWithValue("@Description", $"GRV Invoice - {txtDeliveryNote.Text}")
            cmd.Parameters.AddWithValue("@Balance", Convert.ToDecimal(txtTotal.Text))
            cmd.Parameters.AddWithValue("@Reference", txtDeliveryNote.Text)
            cmd.Parameters.AddWithValue("@IsReversed", 0)
            cmd.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
            cmd.Parameters.AddWithValue("@CreatedDate", DateTime.Now)

            cmd.ExecuteNonQuery()
            
            ' Update supplier balance
            Dim balCmd As New SqlCommand("UPDATE Suppliers SET Balance = ISNULL(Balance, 0) + @Amount WHERE SupplierID = @SupplierID", conn, trans)
            balCmd.Parameters.AddWithValue("@Amount", Convert.ToDecimal(txtTotal.Text))
            balCmd.Parameters.AddWithValue("@SupplierID", selectedSupplierId)
            balCmd.ExecuteNonQuery()
            
            ' Post to General Ledger - Inventory received (not paid yet)
            ' DR Inventory (Asset) - Stock value (SubTotal only, no VAT)
            ' CR Accounts Payable - Supplier (Liability) - Total including VAT
            PostInventoryToGL(conn, trans, invoiceId)
        Catch ex As Exception
            ' Temporarily show error to diagnose issue
            MessageBox.Show($"Supplier ledger update error: {ex.Message}", "DEBUG ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Throw ' Re-throw to see full error
        End Try
    End Sub
    
    Private Sub PostInventoryToGL(conn As SqlConnection, trans As SqlTransaction, invoiceId As Integer)
        Try
            Dim subTotal As Decimal = Convert.ToDecimal(txtSubTotal.Text)
            Dim vatAmount As Decimal = Convert.ToDecimal(txtVAT.Text)
            Dim totalAmount As Decimal = Convert.ToDecimal(txtTotal.Text)
            Dim transactionDate As Date = dtpReceived.Value
            Dim reference As String = txtDeliveryNote.Text
            Dim description As String = $"GRV - {cboSupplier.Text} - {reference}"
            
            ' DR Inventory (Asset) - Stock value only
            Dim cmdDebitInventory As New SqlCommand(
                "INSERT INTO GeneralLedger (AccountCode, TransactionDate, Description, Reference, Debit, Credit, BranchID, CreatedBy, CreatedDate) " &
                "VALUES (@AccountCode, @TransactionDate, @Description, @Reference, @Debit, 0, @BranchID, @CreatedBy, @CreatedDate)", conn, trans)
            cmdDebitInventory.Parameters.AddWithValue("@AccountCode", "1300") ' Inventory Asset
            cmdDebitInventory.Parameters.AddWithValue("@TransactionDate", transactionDate)
            cmdDebitInventory.Parameters.AddWithValue("@Description", description)
            cmdDebitInventory.Parameters.AddWithValue("@Reference", reference)
            cmdDebitInventory.Parameters.AddWithValue("@Debit", subTotal)
            cmdDebitInventory.Parameters.AddWithValue("@BranchID", currentBranchId)
            cmdDebitInventory.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
            cmdDebitInventory.Parameters.AddWithValue("@CreatedDate", DateTime.Now)
            cmdDebitInventory.ExecuteNonQuery()
            
            ' CR Accounts Payable - Supplier (Liability) - Total including VAT
            Dim cmdCreditAP As New SqlCommand(
                "INSERT INTO GeneralLedger (AccountCode, TransactionDate, Description, Reference, Debit, Credit, BranchID, CreatedBy, CreatedDate) " &
                "VALUES (@AccountCode, @TransactionDate, @Description, @Reference, 0, @Credit, @BranchID, @CreatedBy, @CreatedDate)", conn, trans)
            cmdCreditAP.Parameters.AddWithValue("@AccountCode", "2100") ' Accounts Payable
            cmdCreditAP.Parameters.AddWithValue("@TransactionDate", transactionDate)
            cmdCreditAP.Parameters.AddWithValue("@Description", description)
            cmdCreditAP.Parameters.AddWithValue("@Reference", reference)
            cmdCreditAP.Parameters.AddWithValue("@Credit", totalAmount)
            cmdCreditAP.Parameters.AddWithValue("@BranchID", currentBranchId)
            cmdCreditAP.Parameters.AddWithValue("@CreatedBy", AppSession.CurrentUserID)
            cmdCreditAP.Parameters.AddWithValue("@CreatedDate", DateTime.Now)
            cmdCreditAP.ExecuteNonQuery()
            
        Catch ex As Exception
            MessageBox.Show($"GL posting error: {ex.Message}", "DEBUG GL ERROR", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Throw ' Re-throw to see full error
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
