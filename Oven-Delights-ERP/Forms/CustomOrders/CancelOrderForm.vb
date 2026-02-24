Imports System.Data.SqlClient
Imports System.Configuration

Public Class CancelOrderForm
    Private ReadOnly _connString As String
    Private _orderData As DataRow
    Private _depositData As DataRow
    Private _cancellationFeeAmount As Decimal = 0
    Private _refundAmount As Decimal = 0
    
    Public Sub New()
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
    End Sub
    
    Private Sub CancelOrderForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        LoadCancellationFeeItems()
        SetupUI()
    End Sub
    
    Private Sub SetupUI()
        txtOrderNumber.Focus()
        btnLoadOrder.Enabled = True
        btnProcessCancellation.Enabled = False
        
        lblDepositAmount.Text = "R 0.00"
        lblCancellationFee.Text = "R 0.00"
        lblRefundAmount.Text = "R 0.00"
        lblPaymentMethod.Text = "N/A"
    End Sub
    
    Private Sub LoadCancellationFeeItems()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql = "SELECT DISTINCT Name, ProductID 
                          FROM Demo_Retail_Product 
                          WHERE (Name LIKE '%cancellation%' OR Name LIKE '%cancel%fee%')
                          AND IsActive = 1
                          ORDER BY Name"
                
                Using cmd As New SqlCommand(sql, conn)
                    Using reader = cmd.ExecuteReader()
                        cboCancellationFee.Items.Clear()
                        cboCancellationFee.Items.Add("-- Select Cancellation Fee --")
                        
                        While reader.Read()
                            cboCancellationFee.Items.Add(New With {
                                .Text = reader("Name").ToString(),
                                .Value = reader("ProductID")
                            })
                        End While
                    End Using
                End Using
            End Using
            
            cboCancellationFee.DisplayMember = "Text"
            cboCancellationFee.ValueMember = "Value"
            cboCancellationFee.SelectedIndex = 0
            
        Catch ex As Exception
            MessageBox.Show($"Error loading cancellation fees: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnLoadOrder_Click(sender As Object, e As EventArgs) Handles btnLoadOrder.Click
        If String.IsNullOrWhiteSpace(txtOrderNumber.Text) Then
            MessageBox.Show("Please enter an order number.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        LoadOrderDetails(txtOrderNumber.Text.Trim())
    End Sub
    
    Private Sub LoadOrderDetails(orderNumber As String)
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Load order details
                Dim sqlOrder = "SELECT * FROM POS_CustomOrders WHERE OrderNumber = @orderNumber"
                Using cmd As New SqlCommand(sqlOrder, conn)
                    cmd.Parameters.AddWithValue("@orderNumber", orderNumber)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        
                        If dt.Rows.Count = 0 Then
                            MessageBox.Show("Order not found.", "Not Found", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                            Return
                        End If
                        
                        _orderData = dt.Rows(0)
                        
                        ' Check if order can be cancelled
                        Dim status = _orderData("OrderStatus").ToString()
                        If status = "Delivered" Then
                            MessageBox.Show("Cannot cancel a delivered order.", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                            Return
                        End If
                        
                        If status = "Cancelled" Then
                            MessageBox.Show("This order is already cancelled.", "Already Cancelled", MessageBoxButtons.OK, MessageBoxIcon.Information)
                            Return
                        End If
                    End Using
                End Using
                
                ' Load deposit payment details
                Dim sqlDeposit = "SELECT * FROM Demo_Sales 
                                 WHERE InvoiceNumber = @orderNumber 
                                 AND SaleType = 'OrderDeposit'
                                 ORDER BY SaleDate DESC"
                
                Using cmd As New SqlCommand(sqlDeposit, conn)
                    cmd.Parameters.AddWithValue("@orderNumber", orderNumber)
                    
                    Using adapter As New SqlDataAdapter(cmd)
                        Dim dt As New DataTable()
                        adapter.Fill(dt)
                        
                        If dt.Rows.Count = 0 Then
                            MessageBox.Show("No deposit found for this order.", "No Deposit", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                            Return
                        End If
                        
                        _depositData = dt.Rows(0)
                    End Using
                End Using
            End Using
            
            ' Display order information
            DisplayOrderInfo()
            btnProcessCancellation.Enabled = True
            
        Catch ex As Exception
            MessageBox.Show($"Error loading order: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub DisplayOrderInfo()
        ' Order details
        txtCustomerName.Text = _orderData("CustomerName").ToString() & " " & _orderData("CustomerSurname").ToString()
        txtCustomerPhone.Text = _orderData("CustomerPhone").ToString()
        txtOrderDate.Text = Convert.ToDateTime(_orderData("OrderDate")).ToString("dd MMM yyyy")
        txtOrderStatus.Text = _orderData("OrderStatus").ToString()
        
        ' Deposit details
        Dim depositAmount = CDec(_depositData("TotalAmount"))
        lblDepositAmount.Text = depositAmount.ToString("C2")
        lblPaymentMethod.Text = _depositData("PaymentMethod").ToString()
        
        ' Enable cancellation fee selection
        cboCancellationFee.Enabled = True
        numCancellationFee.Enabled = True
    End Sub
    
    Private Sub cboCancellationFee_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboCancellationFee.SelectedIndexChanged
        If cboCancellationFee.SelectedIndex > 0 Then
            ' Get price for selected cancellation fee item
            Dim selectedItem = cboCancellationFee.SelectedItem
            Dim productId = selectedItem.Value
            
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    
                    Dim sql = "SELECT TOP 1 SellingPrice 
                              FROM Demo_Retail_Price 
                              WHERE ProductID = @productId 
                              AND BranchID = @branchId
                              ORDER BY EffectiveFrom DESC"
                    
                    Using cmd As New SqlCommand(sql, conn)
                        cmd.Parameters.AddWithValue("@productId", productId)
                        cmd.Parameters.AddWithValue("@branchId", _orderData("BranchID"))
                        
                        Dim price = cmd.ExecuteScalar()
                        If price IsNot Nothing Then
                            numCancellationFee.Value = CDec(price)
                        End If
                    End Using
                End Using
            Catch ex As Exception
                MessageBox.Show($"Error loading cancellation fee price: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub
    
    Private Sub numCancellationFee_ValueChanged(sender As Object, e As EventArgs) Handles numCancellationFee.ValueChanged
        CalculateRefund()
    End Sub
    
    Private Sub CalculateRefund()
        If _depositData Is Nothing Then Return
        
        Dim depositAmount = CDec(_depositData("TotalAmount"))
        _cancellationFeeAmount = numCancellationFee.Value
        _refundAmount = depositAmount - _cancellationFeeAmount
        
        lblCancellationFee.Text = _cancellationFeeAmount.ToString("C2")
        lblRefundAmount.Text = _refundAmount.ToString("C2")
        
        If _refundAmount < 0 Then
            lblRefundAmount.ForeColor = Color.Red
            MessageBox.Show("Cancellation fee cannot exceed deposit amount.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            numCancellationFee.Value = depositAmount
        Else
            lblRefundAmount.ForeColor = Color.Green
        End If
    End Sub
    
    Private Sub btnProcessCancellation_Click(sender As Object, e As EventArgs) Handles btnProcessCancellation.Click
        If _orderData Is Nothing OrElse _depositData Is Nothing Then
            MessageBox.Show("Please load an order first.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If cboCancellationFee.SelectedIndex = 0 Then
            MessageBox.Show("Please select a cancellation fee item.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If _refundAmount < 0 Then
            MessageBox.Show("Invalid refund amount. Please adjust the cancellation fee.", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        ' Confirm cancellation
        Dim result = MessageBox.Show(
            $"Cancel Order: {txtOrderNumber.Text}{vbCrLf}" &
            $"Customer: {txtCustomerName.Text}{vbCrLf}" &
            $"Deposit: {lblDepositAmount.Text}{vbCrLf}" &
            $"Cancellation Fee: {lblCancellationFee.Text}{vbCrLf}" &
            $"Refund Amount: {lblRefundAmount.Text}{vbCrLf}{vbCrLf}" &
            $"Are you sure you want to cancel this order?",
            "Confirm Cancellation",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            ProcessCancellation()
        End If
    End Sub
    
    Private Sub ProcessCancellation()
        Try
            ' Open refund tender dialog first
            Dim originalPaymentMethod = _depositData("PaymentMethod").ToString()
            Dim refundDialog As New RefundTenderDialog(_refundAmount, originalPaymentMethod)
            
            If refundDialog.ShowDialog(Me) <> DialogResult.OK Then
                MessageBox.Show("Refund cancelled. Order cancellation aborted.", "Cancelled", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If
            
            Dim selectedRefundMethod = refundDialog.RefundMethod
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Using transaction = conn.BeginTransaction()
                    Try
                        ' 1. Update order status to Cancelled
                        Dim sqlUpdateOrder = "UPDATE POS_CustomOrders 
                                             SET OrderStatus = 'Cancelled',
                                                 ModifiedDate = GETDATE()
                                             WHERE OrderNumber = @orderNumber"
                        
                        Using cmd As New SqlCommand(sqlUpdateOrder, conn, transaction)
                            cmd.Parameters.AddWithValue("@orderNumber", txtOrderNumber.Text.Trim())
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' 2. Record cancellation fee as revenue (GL: DR Customer Deposits, CR Cancellation Fee Revenue)
                        Dim cancellationInvoice = GenerateInvoiceNumber()
                        Dim sqlCancellationSale = "INSERT INTO Demo_Sales 
                                                  (InvoiceNumber, BranchID, TotalAmount, PaymentMethod, 
                                                   SaleType, SaleDate, CashierID, CustomerName)
                                                  VALUES 
                                                  (@invoice, @branchId, @amount, 'Cash', 
                                                   'CancellationFee', GETDATE(), @cashierId, @customerName)"
                        
                        Using cmd As New SqlCommand(sqlCancellationSale, conn, transaction)
                            cmd.Parameters.AddWithValue("@invoice", cancellationInvoice)
                            cmd.Parameters.AddWithValue("@branchId", _orderData("BranchID"))
                            cmd.Parameters.AddWithValue("@amount", _cancellationFeeAmount)
                            cmd.Parameters.AddWithValue("@cashierId", AppSession.CurrentUser.UserID)
                            cmd.Parameters.AddWithValue("@customerName", txtCustomerName.Text)
                            cmd.ExecuteNonQuery()
                        End Using
                        
                        ' GL Posting for Cancellation Fee
                        PostToGeneralLedger(conn, transaction, "Customer Deposits", _cancellationFeeAmount, "Debit", cancellationInvoice, "Cancellation fee charged")
                        PostToGeneralLedger(conn, transaction, "Cancellation Fee Revenue", _cancellationFeeAmount, "Credit", cancellationInvoice, "Cancellation fee revenue")
                        
                        ' 3. Record refund transaction (GL: DR Customer Deposits, CR Bank/Cash)
                        If _refundAmount > 0 Then
                            Dim refundInvoice = GenerateInvoiceNumber()
                            
                            Dim sqlRefund = "INSERT INTO Demo_Sales 
                                           (InvoiceNumber, BranchID, TotalAmount, PaymentMethod, 
                                            SaleType, SaleDate, CashierID, CustomerName)
                                           VALUES 
                                           (@invoice, @branchId, @amount, @paymentMethod, 
                                            'OrderRefund', GETDATE(), @cashierId, @customerName)"
                            
                            Using cmd As New SqlCommand(sqlRefund, conn, transaction)
                                cmd.Parameters.AddWithValue("@invoice", refundInvoice)
                                cmd.Parameters.AddWithValue("@branchId", _orderData("BranchID"))
                                cmd.Parameters.AddWithValue("@amount", -_refundAmount) ' Negative for refund
                                cmd.Parameters.AddWithValue("@paymentMethod", selectedRefundMethod)
                                cmd.Parameters.AddWithValue("@cashierId", AppSession.CurrentUser.UserID)
                                cmd.Parameters.AddWithValue("@customerName", txtCustomerName.Text)
                                cmd.ExecuteNonQuery()
                            End Using
                            
                            ' GL Posting for Refund (DR Customer Deposits, CR Bank/Cash)
                            PostToGeneralLedger(conn, transaction, "Customer Deposits", _refundAmount, "Debit", refundInvoice, "Refund of deposit")
                            
                            ' Determine bank account based on refund method
                            Dim bankAccount As String = If(selectedRefundMethod = "Cash", "Cash on Hand", "Bank Account")
                            PostToGeneralLedger(conn, transaction, bankAccount, _refundAmount, "Credit", refundInvoice, $"Refund via {selectedRefundMethod}")
                        End If
                        
                        transaction.Commit()
                        
                        ' Print cancellation slip and refund receipt
                        PrintCancellationDocuments()
                        
                        MessageBox.Show(
                            $"Order cancelled successfully!{vbCrLf}" &
                            $"Refund Amount: {_refundAmount.ToString("C2")}{vbCrLf}" &
                            $"Payment Method: {lblPaymentMethod.Text}",
                            "Success",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Information)
                        
                        ' Reset form
                        ResetForm()
                        
                    Catch ex As Exception
                        transaction.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show($"Error processing cancellation: {ex.Message}", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Function GenerateInvoiceNumber() As String
        Return $"CANCEL-{DateTime.Now:yyyyMMddHHmmss}-{New Random().Next(1000, 9999)}"
    End Function
    
    Private Sub PrintCancellationDocuments()
        ' TODO: Implement printing logic
        ' This will print:
        ' 1. Cancellation Slip with order details, deposit, cancellation fee, refund
        ' 2. Refund Receipt for customer
        
        Dim doc As New System.Drawing.Printing.PrintDocument()
        AddHandler doc.PrintPage, AddressOf PrintCancellationSlip
        
        Try
            doc.Print()
        Catch ex As Exception
            MessageBox.Show($"Error printing: {ex.Message}", "Print Error", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End Try
    End Sub
    
    Private Sub PrintCancellationSlip(sender As Object, e As System.Drawing.Printing.PrintPageEventArgs)
        Dim font As New Font("Courier New", 10)
        Dim boldFont As New Font("Courier New", 10, FontStyle.Bold)
        Dim y As Integer = 50
        Dim lineHeight As Integer = 20
        
        ' Header
        e.Graphics.DrawString("ORDER CANCELLATION SLIP", boldFont, Brushes.Black, 100, y)
        y += lineHeight * 2
        
        ' Order details
        e.Graphics.DrawString($"Order Number: {txtOrderNumber.Text}", font, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Customer: {txtCustomerName.Text}", font, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Phone: {txtCustomerPhone.Text}", font, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Order Date: {txtOrderDate.Text}", font, Brushes.Black, 50, y)
        y += lineHeight * 2
        
        ' Financial details
        e.Graphics.DrawString("FINANCIAL SUMMARY", boldFont, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Deposit Paid: {lblDepositAmount.Text}", font, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Cancellation Fee: {lblCancellationFee.Text}", font, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString("─────────────────────────────", font, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Refund Amount: {lblRefundAmount.Text}", boldFont, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Refund Method: {lblPaymentMethod.Text}", font, Brushes.Black, 50, y)
        y += lineHeight * 2
        
        ' Footer
        e.Graphics.DrawString($"Cancelled By: {AppSession.CurrentUser.Username}", font, Brushes.Black, 50, y)
        y += lineHeight
        e.Graphics.DrawString($"Date/Time: {DateTime.Now:dd MMM yyyy HH:mm}", font, Brushes.Black, 50, y)
        
        e.HasMorePages = False
    End Sub
    
    Private Sub ResetForm()
        txtOrderNumber.Clear()
        txtCustomerName.Clear()
        txtCustomerPhone.Clear()
        txtOrderDate.Clear()
        txtOrderStatus.Clear()
        cboCancellationFee.SelectedIndex = 0
        numCancellationFee.Value = 0
        
        _orderData = Nothing
        _depositData = Nothing
        _cancellationFeeAmount = 0
        _refundAmount = 0
        
        SetupUI()
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
    
    ''' <summary>
    ''' Posts transaction to General Ledger for double-entry accounting
    ''' </summary>
    Private Sub PostToGeneralLedger(conn As SqlConnection, transaction As SqlTransaction, 
                                   accountName As String, amount As Decimal, 
                                   debitCredit As String, reference As String, description As String)
        Try
            ' Get account ID from chart of accounts
            Dim accountId As Integer = 0
            Dim sqlGetAccount = "SELECT AccountID FROM ChartOfAccounts WHERE AccountName = @accountName"
            
            Using cmd As New SqlCommand(sqlGetAccount, conn, transaction)
                cmd.Parameters.AddWithValue("@accountName", accountName)
                Dim result = cmd.ExecuteScalar()
                
                If result IsNot Nothing Then
                    accountId = CInt(result)
                Else
                    ' Account doesn't exist - log warning but don't fail transaction
                    Debug.WriteLine($"Warning: GL Account '{accountName}' not found")
                    Return
                End If
            End Using
            
            ' Post to general ledger
            Dim sqlPostGL = "INSERT INTO GeneralLedger 
                           (AccountID, TransactionDate, DebitAmount, CreditAmount, 
                            Reference, Description, BranchID, CreatedBy, CreatedDate)
                           VALUES 
                           (@accountId, GETDATE(), @debit, @credit, 
                            @reference, @description, @branchId, @userId, GETDATE())"
            
            Using cmd As New SqlCommand(sqlPostGL, conn, transaction)
                cmd.Parameters.AddWithValue("@accountId", accountId)
                cmd.Parameters.AddWithValue("@debit", If(debitCredit = "Debit", amount, 0))
                cmd.Parameters.AddWithValue("@credit", If(debitCredit = "Credit", amount, 0))
                cmd.Parameters.AddWithValue("@reference", reference)
                cmd.Parameters.AddWithValue("@description", description)
                cmd.Parameters.AddWithValue("@branchId", AppSession.CurrentUser.BranchID)
                cmd.Parameters.AddWithValue("@userId", AppSession.CurrentUser.UserID)
                cmd.ExecuteNonQuery()
            End Using
            
        Catch ex As Exception
            ' Log error but don't fail the entire transaction
            Debug.WriteLine($"GL Posting Error: {ex.Message}")
            ' In production, you might want to log this to an error table
        End Try
    End Sub
End Class
