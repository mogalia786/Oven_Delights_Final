Imports System.Data.SqlClient
Imports System.Configuration

Public Class RecallCustomOrderForm
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchId As Integer
    Private ReadOnly _currentUser As String
    Private _selectedOrder As DataRow = Nothing
    
    Public Sub New(branchId As Integer, username As String)
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchId = branchId
        _currentUser = username
    End Sub
    
    Private Sub RecallCustomOrderForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        LoadOrders()
        SetupDataGridView()
    End Sub
    
    Private Sub SetupDataGridView()
        ' Format columns
        If dgvOrders.Columns.Contains("OrderID") Then
            dgvOrders.Columns("OrderID").Visible = False
        End If
        
        If dgvOrders.Columns.Contains("TotalAmount") Then
            dgvOrders.Columns("TotalAmount").DefaultCellStyle.Format = "N2"
            dgvOrders.Columns("TotalAmount").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        End If
        
        If dgvOrders.Columns.Contains("DepositPaid") Then
            dgvOrders.Columns("DepositPaid").DefaultCellStyle.Format = "N2"
            dgvOrders.Columns("DepositPaid").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        End If
        
        If dgvOrders.Columns.Contains("BalanceDue") Then
            dgvOrders.Columns("BalanceDue").DefaultCellStyle.Format = "N2"
            dgvOrders.Columns("BalanceDue").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
        End If
        
        dgvOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvOrders.MultiSelect = False
    End Sub
    
    Private Sub LoadOrders()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT 
                        OrderID,
                        OrderNumber,
                        CustomerName + ' ' + CustomerSurname AS Customer,
                        CustomerPhone AS Phone,
                        CONVERT(VARCHAR, ReadyDate, 106) + ' ' + CONVERT(VARCHAR, ReadyTime, 108) AS ReadyDateTime,
                        TotalAmount,
                        DepositPaid,
                        BalanceDue,
                        OrderStatus AS Status
                    FROM POS_CustomOrders
                    WHERE BranchID = @branchId
                    AND OrderStatus IN ('Pending', 'Ready')
                    ORDER BY ReadyDate, ReadyTime"
                
                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@branchId", _currentBranchId)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvOrders.DataSource = dt
                    
                    lblOrderCount.Text = $"{dt.Rows.Count} orders found"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub txtSearch_TextChanged(sender As Object, e As EventArgs) Handles txtSearch.TextChanged
        SearchOrders()
    End Sub
    
    Private Sub SearchOrders()
        Try
            Dim searchText As String = txtSearch.Text.Trim()
            
            If String.IsNullOrWhiteSpace(searchText) Then
                LoadOrders()
                Return
            End If
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT 
                        OrderID,
                        OrderNumber,
                        CustomerName + ' ' + CustomerSurname AS Customer,
                        CustomerPhone AS Phone,
                        CONVERT(VARCHAR, ReadyDate, 106) + ' ' + CONVERT(VARCHAR, ReadyTime, 108) AS ReadyDateTime,
                        TotalAmount,
                        DepositPaid,
                        BalanceDue,
                        OrderStatus AS Status
                    FROM POS_CustomOrders
                    WHERE BranchID = @branchId
                    AND OrderStatus IN ('Pending', 'Ready')
                    AND (
                        OrderNumber LIKE @search
                        OR CustomerName LIKE @search
                        OR CustomerSurname LIKE @search
                        OR CustomerPhone LIKE @search
                    )
                    ORDER BY ReadyDate, ReadyTime"
                
                Using da As New SqlDataAdapter(sql, conn)
                    da.SelectCommand.Parameters.AddWithValue("@branchId", _currentBranchId)
                    da.SelectCommand.Parameters.AddWithValue("@search", $"%{searchText}%")
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvOrders.DataSource = dt
                    
                    lblOrderCount.Text = $"{dt.Rows.Count} orders found"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error searching orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub dgvOrders_SelectionChanged(sender As Object, e As EventArgs) Handles dgvOrders.SelectionChanged
        If dgvOrders.SelectedRows.Count > 0 Then
            Dim selectedRow = dgvOrders.SelectedRows(0)
            Dim orderId As Integer = Convert.ToInt32(selectedRow.Cells("OrderID").Value)
            LoadOrderDetails(orderId)
            btnProcessBalance.Enabled = True
        Else
            btnProcessBalance.Enabled = False
        End If
    End Sub
    
    Private Sub LoadOrderDetails(orderId As Integer)
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Load order header
                Dim sqlHeader As String = "SELECT * FROM POS_CustomOrders WHERE OrderID = @orderId"
                Using cmd As New SqlCommand(sqlHeader, conn)
                    cmd.Parameters.AddWithValue("@orderId", orderId)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            ' Store selected order
                            Dim dt As New DataTable()
                            dt.Load(reader)
                            _selectedOrder = dt.Rows(0)
                            
                            ' Display order details
                            txtOrderNumber.Text = _selectedOrder("OrderNumber").ToString()
                            txtCustomerName.Text = _selectedOrder("CustomerName").ToString() & " " & _selectedOrder("CustomerSurname").ToString()
                            txtCustomerPhone.Text = _selectedOrder("CustomerPhone").ToString()
                            txtReadyDate.Text = Convert.ToDateTime(_selectedOrder("ReadyDate")).ToString("dd MMM yyyy")
                            txtReadyTime.Text = CType(_selectedOrder("ReadyTime"), TimeSpan).ToString("hh\:mm")
                            txtTotalAmount.Text = "R" & Convert.ToDecimal(_selectedOrder("TotalAmount")).ToString("N2")
                            txtDepositPaid.Text = "R" & Convert.ToDecimal(_selectedOrder("DepositPaid")).ToString("N2")
                            txtBalanceDue.Text = "R" & Convert.ToDecimal(_selectedOrder("BalanceDue")).ToString("N2")
                        End If
                    End Using
                End Using
                
                ' Load order items
                Dim sqlItems As String = "
                    SELECT 
                        ProductName AS Product,
                        Quantity AS Qty,
                        UnitPrice AS Price,
                        LineTotal AS Total
                    FROM POS_CustomOrderItems
                    WHERE OrderID = @orderId"
                
                Using da As New SqlDataAdapter(sqlItems, conn)
                    da.SelectCommand.Parameters.AddWithValue("@orderId", orderId)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvOrderItems.DataSource = dt
                    
                    ' Format columns
                    If dgvOrderItems.Columns.Contains("Price") Then
                        dgvOrderItems.Columns("Price").DefaultCellStyle.Format = "N2"
                    End If
                    If dgvOrderItems.Columns.Contains("Total") Then
                        dgvOrderItems.Columns("Total").DefaultCellStyle.Format = "N2"
                    End If
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading order details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnProcessBalance_Click(sender As Object, e As EventArgs) Handles btnProcessBalance.Click
        If _selectedOrder Is Nothing Then
            MessageBox.Show("Please select an order first", "Validation", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim balanceDue As Decimal = Convert.ToDecimal(_selectedOrder("BalanceDue"))
        
        If balanceDue <= 0 Then
            MessageBox.Show("No balance due on this order", "Information", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Return
        End If
        
        ' Confirm collection
        Dim result = MessageBox.Show(
            $"Process balance payment of R{balanceDue:N2}?" & vbCrLf & vbCrLf &
            $"Order: {_selectedOrder("OrderNumber")}" & vbCrLf &
            $"Customer: {_selectedOrder("CustomerName")} {_selectedOrder("CustomerSurname")}" & vbCrLf & vbCrLf &
            "This will:" & vbCrLf &
            "1. Process the balance payment" & vbCrLf &
            "2. Convert order to a regular sale" & vbCrLf &
            "3. Mark order as Collected",
            "Confirm Collection",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            ProcessBalancePayment(balanceDue)
        End If
    End Sub
    
    Private Sub ProcessBalancePayment(balanceDue As Decimal)
        Try
            ' Show payment form
            Dim paymentForm As New PaymentForm()
            paymentForm.TotalAmount = balanceDue
            paymentForm.TransactionType = "Custom Order Balance"
            
            If paymentForm.ShowDialog() = DialogResult.OK Then
                ' Process the payment and convert to sale
                ConvertOrderToSale(paymentForm.PaymentMethod, paymentForm.CashAmount, paymentForm.CardAmount, paymentForm.EFTAmount)
            End If
            
        Catch ex As Exception
            MessageBox.Show("Error processing balance payment: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub ConvertOrderToSale(paymentMethod As String, cashAmount As Decimal, cardAmount As Decimal, eftAmount As Decimal)
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                Using trans = conn.BeginTransaction()
                    Try
                        Dim orderId As Integer = Convert.ToInt32(_selectedOrder("OrderID"))
                        Dim orderNumber As String = _selectedOrder("OrderNumber").ToString()
                        Dim totalAmount As Decimal = Convert.ToDecimal(_selectedOrder("TotalAmount"))
                        Dim depositPaid As Decimal = Convert.ToDecimal(_selectedOrder("DepositPaid"))
                        Dim balanceDue As Decimal = Convert.ToDecimal(_selectedOrder("BalanceDue"))
                        
                        ' Create sale record (you may need to adjust table name based on your schema)
                        Dim saleId As Integer = CreateSaleFromOrder(conn, trans, orderId, totalAmount, paymentMethod, cashAmount, cardAmount, eftAmount)
                        
                        ' Update order status
                        Dim cmdUpdate As New SqlCommand("
                            UPDATE POS_CustomOrders 
                            SET OrderStatus = 'Collected',
                                CollectedDate = GETDATE()
                            WHERE OrderID = @orderId", conn, trans)
                        cmdUpdate.Parameters.AddWithValue("@orderId", orderId)
                        cmdUpdate.ExecuteNonQuery()
                        
                        trans.Commit()
                        
                        ' Show success message
                        MessageBox.Show(
                            $"Order {orderNumber} collected successfully!" & vbCrLf & vbCrLf &
                            $"Balance Paid: R{balanceDue:N2}" & vbCrLf &
                            $"Total Paid: R{totalAmount:N2}" & vbCrLf &
                            $"Sale ID: {saleId}",
                            "Success",
                            MessageBoxButtons.OK,
                            MessageBoxIcon.Information)
                        
                        ' Print collection receipt
                        PrintCollectionReceipt(orderNumber, totalAmount, depositPaid, balanceDue, paymentMethod)
                        
                        ' Refresh orders list
                        LoadOrders()
                        ClearOrderDetails()
                        
                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
            
        Catch ex As Exception
            MessageBox.Show("Error converting order to sale: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Function CreateSaleFromOrder(conn As SqlConnection, trans As SqlTransaction, orderId As Integer, totalAmount As Decimal, paymentMethod As String, cashAmount As Decimal, cardAmount As Decimal, eftAmount As Decimal) As Integer
        ' Create sale header (adjust table/column names based on your schema)
        Dim cmdSale As New SqlCommand("
            INSERT INTO Sales (
                BranchID, SaleDate, TotalAmount, PaymentMethod, 
                CashAmount, CardAmount, EFTAmount, 
                SaleType, ReferenceNumber, CreatedBy
            )
            VALUES (
                @branchId, GETDATE(), @totalAmount, @paymentMethod,
                @cashAmount, @cardAmount, @eftAmount,
                'Custom Order', @orderNumber, @createdBy
            );
            SELECT SCOPE_IDENTITY();", conn, trans)
        
        cmdSale.Parameters.AddWithValue("@branchId", _currentBranchId)
        cmdSale.Parameters.AddWithValue("@totalAmount", totalAmount)
        cmdSale.Parameters.AddWithValue("@paymentMethod", paymentMethod)
        cmdSale.Parameters.AddWithValue("@cashAmount", cashAmount)
        cmdSale.Parameters.AddWithValue("@cardAmount", cardAmount)
        cmdSale.Parameters.AddWithValue("@eftAmount", eftAmount)
        cmdSale.Parameters.AddWithValue("@orderNumber", _selectedOrder("OrderNumber").ToString())
        cmdSale.Parameters.AddWithValue("@createdBy", _currentUser)
        
        Dim saleId As Integer = Convert.ToInt32(cmdSale.ExecuteScalar())
        
        ' Copy order items to sale items
        Dim cmdItems As New SqlCommand("
            INSERT INTO SaleItems (SaleID, ProductID, ProductName, Quantity, UnitPrice, LineTotal)
            SELECT @saleId, ProductID, ProductName, Quantity, UnitPrice, LineTotal
            FROM POS_CustomOrderItems
            WHERE OrderID = @orderId", conn, trans)
        
        cmdItems.Parameters.AddWithValue("@saleId", saleId)
        cmdItems.Parameters.AddWithValue("@orderId", orderId)
        cmdItems.ExecuteNonQuery()
        
        Return saleId
    End Function
    
    Private Sub PrintCollectionReceipt(orderNumber As String, totalAmount As Decimal, depositPaid As Decimal, balancePaid As Decimal, paymentMethod As String)
        ' Create receipt form
        Dim receiptForm As New Form()
        receiptForm.Text = "Collection Receipt - " & orderNumber
        receiptForm.Size = New Size(400, 600)
        receiptForm.StartPosition = FormStartPosition.CenterScreen
        
        Dim rtbReceipt As New RichTextBox()
        rtbReceipt.Dock = DockStyle.Fill
        rtbReceipt.Font = New Font("Courier New", 10)
        rtbReceipt.ReadOnly = True
        
        Dim receipt As New System.Text.StringBuilder()
        receipt.AppendLine("========================================")
        receipt.AppendLine("       OVEN DELIGHTS BAKERY")
        receipt.AppendLine("       COLLECTION RECEIPT")
        receipt.AppendLine("========================================")
        receipt.AppendLine()
        receipt.AppendLine($"ORDER NUMBER: {orderNumber}")
        receipt.AppendLine($"Collection Date: {DateTime.Now:dd MMM yyyy HH:mm}")
        receipt.AppendLine($"Cashier: {_currentUser}")
        receipt.AppendLine("========================================")
        receipt.AppendLine()
        receipt.AppendLine($"Customer: {_selectedOrder("CustomerName")} {_selectedOrder("CustomerSurname")}")
        receipt.AppendLine($"Phone: {_selectedOrder("CustomerPhone")}")
        receipt.AppendLine("========================================")
        receipt.AppendLine()
        receipt.AppendLine($"Total Amount:   R{totalAmount,15:N2}")
        receipt.AppendLine($"Deposit Paid:   R{depositPaid,15:N2}")
        receipt.AppendLine($"Balance Paid:   R{balancePaid,15:N2}")
        receipt.AppendLine("========================================")
        receipt.AppendLine()
        receipt.AppendLine($"Payment Method: {paymentMethod}")
        receipt.AppendLine()
        receipt.AppendLine("Thank you for your business!")
        receipt.AppendLine("========================================")
        
        rtbReceipt.Text = receipt.ToString()
        
        receiptForm.Controls.Add(rtbReceipt)
        receiptForm.ShowDialog()
    End Sub
    
    Private Sub ClearOrderDetails()
        txtOrderNumber.Clear()
        txtCustomerName.Clear()
        txtCustomerPhone.Clear()
        txtReadyDate.Clear()
        txtReadyTime.Clear()
        txtTotalAmount.Clear()
        txtDepositPaid.Clear()
        txtBalanceDue.Clear()
        dgvOrderItems.DataSource = Nothing
        _selectedOrder = Nothing
        btnProcessBalance.Enabled = False
    End Sub
    
    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadOrders()
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
