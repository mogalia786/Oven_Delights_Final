Imports System.Data.SqlClient
Imports System.Configuration

Public Class OrdersManagementForm
    Private ReadOnly _connString As String
    Private ReadOnly _currentBranchId As Integer
    Private ReadOnly _currentUser As String
    Private _isSuperAdmin As Boolean
    
    Public Sub New(branchId As Integer, username As String, isSuperAdmin As Boolean)
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _currentBranchId = branchId
        _currentUser = username
        _isSuperAdmin = isSuperAdmin
    End Sub
    
    Private Sub OrdersManagementForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        LoadStatusFilter()
        LoadOrders()
        SetupDataGridView()
        
        ' Set date filters to show last 30 days by default
        dtpFrom.Value = DateTime.Today.AddDays(-30)
        dtpTo.Value = DateTime.Today
    End Sub
    
    Private Sub LoadStatusFilter()
        cboStatusFilter.Items.Clear()
        cboStatusFilter.Items.Add("All")
        cboStatusFilter.Items.Add("Pending")
        cboStatusFilter.Items.Add("Ready")
        cboStatusFilter.Items.Add("Collected")
        cboStatusFilter.Items.Add("Cancelled")
        cboStatusFilter.SelectedIndex = 0
    End Sub
    
    Private Sub SetupDataGridView()
        dgvOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvOrders.MultiSelect = False
        dgvOrders.ReadOnly = True
        
        ' Add context menu for row actions
        Dim contextMenu As New ContextMenuStrip()
        contextMenu.Items.Add("View Details", Nothing, AddressOf ViewOrderDetails)
        contextMenu.Items.Add("Mark as Ready", Nothing, AddressOf MarkAsReady)
        contextMenu.Items.Add("Cancel Order", Nothing, AddressOf CancelOrder)
        contextMenu.Items.Add(New ToolStripSeparator())
        contextMenu.Items.Add("Print Order", Nothing, AddressOf PrintOrder)
        dgvOrders.ContextMenuStrip = contextMenu
    End Sub
    
    Private Sub LoadOrders()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT 
                        OrderID,
                        OrderNumber AS [Order #],
                        BranchName AS Branch,
                        CustomerName + ' ' + CustomerSurname AS Customer,
                        CustomerPhone AS Phone,
                        CONVERT(VARCHAR, OrderDate, 106) AS [Order Date],
                        CONVERT(VARCHAR, ReadyDate, 106) + ' ' + CONVERT(VARCHAR, ReadyTime, 108) AS [Ready Date/Time],
                        TotalAmount AS Total,
                        DepositPaid AS Deposit,
                        BalanceDue AS Balance,
                        OrderStatus AS Status,
                        CreatedBy AS [Created By]
                    FROM POS_CustomOrders
                    WHERE 1=1"
                
                ' Add branch filter for non-super admin
                If Not _isSuperAdmin Then
                    sql &= " AND BranchID = @branchId"
                End If
                
                ' Add status filter
                If cboStatusFilter.SelectedIndex > 0 Then
                    sql &= " AND OrderStatus = @status"
                End If
                
                ' Add date filter
                sql &= " AND OrderDate BETWEEN @fromDate AND @toDate"
                
                ' Add search filter
                If Not String.IsNullOrWhiteSpace(txtSearch.Text) Then
                    sql &= " AND (OrderNumber LIKE @search OR CustomerName LIKE @search OR CustomerSurname LIKE @search OR CustomerPhone LIKE @search)"
                End If
                
                sql &= " ORDER BY OrderDate DESC, ReadyDate, ReadyTime"
                
                Using da As New SqlDataAdapter(sql, conn)
                    If Not _isSuperAdmin Then
                        da.SelectCommand.Parameters.AddWithValue("@branchId", _currentBranchId)
                    End If
                    
                    If cboStatusFilter.SelectedIndex > 0 Then
                        da.SelectCommand.Parameters.AddWithValue("@status", cboStatusFilter.SelectedItem.ToString())
                    End If
                    
                    da.SelectCommand.Parameters.AddWithValue("@fromDate", dtpFrom.Value.Date)
                    da.SelectCommand.Parameters.AddWithValue("@toDate", dtpTo.Value.Date.AddDays(1).AddSeconds(-1))
                    
                    If Not String.IsNullOrWhiteSpace(txtSearch.Text) Then
                        da.SelectCommand.Parameters.AddWithValue("@search", $"%{txtSearch.Text.Trim()}%")
                    End If
                    
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvOrders.DataSource = dt
                    
                    ' Hide OrderID column
                    If dgvOrders.Columns.Contains("OrderID") Then
                        dgvOrders.Columns("OrderID").Visible = False
                    End If
                    
                    ' Format currency columns
                    If dgvOrders.Columns.Contains("Total") Then
                        dgvOrders.Columns("Total").DefaultCellStyle.Format = "N2"
                        dgvOrders.Columns("Total").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    If dgvOrders.Columns.Contains("Deposit") Then
                        dgvOrders.Columns("Deposit").DefaultCellStyle.Format = "N2"
                        dgvOrders.Columns("Deposit").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    If dgvOrders.Columns.Contains("Balance") Then
                        dgvOrders.Columns("Balance").DefaultCellStyle.Format = "N2"
                        dgvOrders.Columns("Balance").DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight
                    End If
                    
                    ' Color code by status
                    For Each row As DataGridViewRow In dgvOrders.Rows
                        Dim status As String = row.Cells("Status").Value.ToString()
                        Select Case status
                            Case "Pending"
                                row.DefaultCellStyle.BackColor = Color.LightYellow
                            Case "Ready"
                                row.DefaultCellStyle.BackColor = Color.LightGreen
                            Case "Collected"
                                row.DefaultCellStyle.BackColor = Color.LightGray
                            Case "Cancelled"
                                row.DefaultCellStyle.BackColor = Color.LightCoral
                        End Select
                    Next
                    
                    lblOrderCount.Text = $"{dt.Rows.Count} orders"
                    
                    ' Calculate totals
                    Dim totalAmount As Decimal = 0
                    Dim totalDeposit As Decimal = 0
                    Dim totalBalance As Decimal = 0
                    
                    For Each row As DataRow In dt.Rows
                        totalAmount += Convert.ToDecimal(row("Total"))
                        totalDeposit += Convert.ToDecimal(row("Deposit"))
                        totalBalance += Convert.ToDecimal(row("Balance"))
                    Next
                    
                    lblTotals.Text = $"Totals: R{totalAmount:N2} | Deposits: R{totalDeposit:N2} | Balance: R{totalBalance:N2}"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnSearch_Click(sender As Object, e As EventArgs) Handles btnSearch.Click
        LoadOrders()
    End Sub
    
    Private Sub cboStatusFilter_SelectedIndexChanged(sender As Object, e As EventArgs) Handles cboStatusFilter.SelectedIndexChanged
        LoadOrders()
    End Sub
    
    Private Sub dtpFrom_ValueChanged(sender As Object, e As EventArgs) Handles dtpFrom.ValueChanged
        LoadOrders()
    End Sub
    
    Private Sub dtpTo_ValueChanged(sender As Object, e As EventArgs) Handles dtpTo.ValueChanged
        LoadOrders()
    End Sub
    
    Private Sub ViewOrderDetails(sender As Object, e As EventArgs)
        If dgvOrders.SelectedRows.Count = 0 Then Return
        
        Dim orderId As Integer = Convert.ToInt32(dgvOrders.SelectedRows(0).Cells("OrderID").Value)
        ShowOrderDetails(orderId)
    End Sub
    
    Private Sub ShowOrderDetails(orderId As Integer)
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Get order details
                Dim sqlOrder As String = "SELECT * FROM POS_CustomOrders WHERE OrderID = @orderId"
                Dim orderData As DataRow = Nothing
                
                Using cmd As New SqlCommand(sqlOrder, conn)
                    cmd.Parameters.AddWithValue("@orderId", orderId)
                    Using reader = cmd.ExecuteReader()
                        If reader.Read() Then
                            Dim dt As New DataTable()
                            dt.Load(reader)
                            orderData = dt.Rows(0)
                        End If
                    End Using
                End Using
                
                If orderData Is Nothing Then Return
                
                ' Get order items
                Dim sqlItems As String = "SELECT ProductName, Quantity, UnitPrice, LineTotal FROM POS_CustomOrderItems WHERE OrderID = @orderId"
                Dim itemsData As New DataTable()
                
                Using da As New SqlDataAdapter(sqlItems, conn)
                    da.SelectCommand.Parameters.AddWithValue("@orderId", orderId)
                    da.Fill(itemsData)
                End Using
                
                ' Build details message
                Dim details As New System.Text.StringBuilder()
                details.AppendLine($"ORDER: {orderData("OrderNumber")}")
                details.AppendLine($"Branch: {orderData("BranchName")}")
                details.AppendLine()
                details.AppendLine($"Customer: {orderData("CustomerName")} {orderData("CustomerSurname")}")
                details.AppendLine($"Phone: {orderData("CustomerPhone")}")
                details.AppendLine()
                details.AppendLine($"Order Date: {Convert.ToDateTime(orderData("OrderDate")):dd MMM yyyy HH:mm}")
                details.AppendLine($"Ready: {Convert.ToDateTime(orderData("ReadyDate")):dd MMM yyyy} at {CType(orderData("ReadyTime"), TimeSpan):hh\:mm}")
                details.AppendLine()
                details.AppendLine("ITEMS:")
                details.AppendLine(New String("-"c, 50))
                
                For Each item As DataRow In itemsData.Rows
                    details.AppendLine($"{item("Quantity")} x {item("ProductName")} @ R{Convert.ToDecimal(item("UnitPrice")):N2} = R{Convert.ToDecimal(item("LineTotal")):N2}")
                Next
                
                details.AppendLine(New String("-"c, 50))
                details.AppendLine($"Total: R{Convert.ToDecimal(orderData("TotalAmount")):N2}")
                details.AppendLine($"Deposit Paid: R{Convert.ToDecimal(orderData("DepositPaid")):N2}")
                details.AppendLine($"Balance Due: R{Convert.ToDecimal(orderData("BalanceDue")):N2}")
                details.AppendLine()
                details.AppendLine($"Status: {orderData("OrderStatus")}")
                details.AppendLine($"Created By: {orderData("CreatedBy")}")
                
                If orderData("CollectedDate") IsNot DBNull.Value Then
                    details.AppendLine($"Collected: {Convert.ToDateTime(orderData("CollectedDate")):dd MMM yyyy HH:mm}")
                End If
                
                MessageBox.Show(details.ToString(), "Order Details", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading order details: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub MarkAsReady(sender As Object, e As EventArgs)
        If dgvOrders.SelectedRows.Count = 0 Then Return
        
        Dim orderId As Integer = Convert.ToInt32(dgvOrders.SelectedRows(0).Cells("OrderID").Value)
        Dim orderNumber As String = dgvOrders.SelectedRows(0).Cells("Order #").Value.ToString()
        Dim status As String = dgvOrders.SelectedRows(0).Cells("Status").Value.ToString()
        
        If status <> "Pending" Then
            MessageBox.Show("Only pending orders can be marked as ready", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show($"Mark order {orderNumber} as READY for collection?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim cmd As New SqlCommand("UPDATE POS_CustomOrders SET OrderStatus = 'Ready' WHERE OrderID = @orderId", conn)
                    cmd.Parameters.AddWithValue("@orderId", orderId)
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show($"Order {orderNumber} marked as READY", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadOrders()
                End Using
            Catch ex As Exception
                MessageBox.Show("Error updating order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub
    
    Private Sub CancelOrder(sender As Object, e As EventArgs)
        If dgvOrders.SelectedRows.Count = 0 Then Return
        
        Dim orderId As Integer = Convert.ToInt32(dgvOrders.SelectedRows(0).Cells("OrderID").Value)
        Dim orderNumber As String = dgvOrders.SelectedRows(0).Cells("Order #").Value.ToString()
        Dim status As String = dgvOrders.SelectedRows(0).Cells("Status").Value.ToString()
        
        If status = "Collected" OrElse status = "Cancelled" Then
            MessageBox.Show("Cannot cancel collected or already cancelled orders", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show($"Cancel order {orderNumber}?" & vbCrLf & vbCrLf & "This action cannot be undone.", "Confirm Cancellation", MessageBoxButtons.YesNo, MessageBoxIcon.Warning)
        
        If result = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim cmd As New SqlCommand("UPDATE POS_CustomOrders SET OrderStatus = 'Cancelled' WHERE OrderID = @orderId", conn)
                    cmd.Parameters.AddWithValue("@orderId", orderId)
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show($"Order {orderNumber} cancelled", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadOrders()
                End Using
            Catch ex As Exception
                MessageBox.Show("Error cancelling order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub
    
    Private Sub PrintOrder(sender As Object, e As EventArgs)
        If dgvOrders.SelectedRows.Count = 0 Then Return
        
        Dim orderId As Integer = Convert.ToInt32(dgvOrders.SelectedRows(0).Cells("OrderID").Value)
        ' TODO: Implement print functionality
        MessageBox.Show("Print functionality to be implemented", "Print Order", MessageBoxButtons.OK, MessageBoxIcon.Information)
    End Sub
    
    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        ' Export to CSV
        Try
            Dim saveDialog As New SaveFileDialog()
            saveDialog.Filter = "CSV files (*.csv)|*.csv"
            saveDialog.FileName = $"CustomOrders_{DateTime.Now:yyyyMMdd_HHmmss}.csv"
            
            If saveDialog.ShowDialog() = DialogResult.OK Then
                ExportToCSV(saveDialog.FileName)
                MessageBox.Show("Orders exported successfully!", "Export", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End If
        Catch ex As Exception
            MessageBox.Show("Error exporting orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub ExportToCSV(filePath As String)
        Dim dt As DataTable = CType(dgvOrders.DataSource, DataTable)
        
        Using writer As New System.IO.StreamWriter(filePath)
            ' Write headers
            Dim headers As New List(Of String)()
            For Each column As DataColumn In dt.Columns
                If column.ColumnName <> "OrderID" Then
                    headers.Add(column.ColumnName)
                End If
            Next
            writer.WriteLine(String.Join(",", headers))
            
            ' Write data
            For Each row As DataRow In dt.Rows
                Dim values As New List(Of String)()
                For Each column As DataColumn In dt.Columns
                    If column.ColumnName <> "OrderID" Then
                        values.Add($"""{row(column).ToString().Replace("""", """""")}""")
                    End If
                Next
                writer.WriteLine(String.Join(",", values))
            Next
        End Using
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
    
    Private Sub dgvOrders_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvOrders.CellDoubleClick
        If e.RowIndex >= 0 Then
            Dim orderId As Integer = Convert.ToInt32(dgvOrders.Rows(e.RowIndex).Cells("OrderID").Value)
            ShowOrderDetails(orderId)
        End If
    End Sub
End Class
