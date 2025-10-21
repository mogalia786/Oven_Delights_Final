Imports System.Data.SqlClient
Imports System.Configuration

Public Class ManufacturerOrdersForm
    Private ReadOnly _connString As String
    Private ReadOnly _filterStatus As String
    Private ReadOnly _orderType As String ' "Cake" or "General"
    
    Public Sub New(filterStatus As String, Optional orderType As String = "All")
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _filterStatus = filterStatus
        _orderType = orderType
    End Sub
    
    Private Sub ManufacturerOrdersForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        LoadOrders()
        
        Dim typeLabel As String = If(_orderType = "Cake", "Cake ", If(_orderType = "General", "General ", ""))
        
        Select Case _filterStatus
            Case "New"
                Me.Text = $"New {typeLabel}Orders - Manufacturing"
                pnlTop.BackColor = Color.Orange
                btnMarkReady.Visible = True
                btnMarkReady.Text = "Mark as Ready"
            Case "Ready"
                Me.Text = $"Ready {typeLabel}Orders - Manufacturing"
                pnlTop.BackColor = Color.Green
                btnMarkReady.Visible = False ' Hide button for Ready orders
            Case Else
                Me.Text = $"All {typeLabel}Orders - Manufacturing"
                pnlTop.BackColor = Color.FromArgb(0, 122, 204)
                btnMarkReady.Visible = True
                btnMarkReady.Text = "Mark as Ready"
        End Select
    End Sub
    
    Private Sub LoadOrders()
        Try
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                Dim sql As String = "
                    SELECT 
                        o.OrderID,
                        o.OrderNumber AS [Order #],
                        b.BranchName AS Branch,
                        o.CustomerName + ' ' + o.CustomerSurname AS Customer,
                        o.CustomerPhone AS Phone,
                        CONVERT(VARCHAR, o.OrderDate, 106) AS [Order Date],
                        CONVERT(VARCHAR, o.ReadyDate, 106) + ' ' + CONVERT(VARCHAR, o.ReadyTime, 108) AS [Due Date/Time],
                        o.TotalAmount AS Total,
                        o.OrderStatus AS Status,
                        CASE 
                            WHEN o.ReadyDate < CAST(GETDATE() AS DATE) THEN 'OVERDUE'
                            WHEN o.ReadyDate = CAST(GETDATE() AS DATE) THEN 'DUE TODAY'
                            ELSE 'ON TIME'
                        END AS Priority
                    FROM POS_CustomOrders o
                    INNER JOIN Branches b ON o.BranchID = b.BranchID
                    WHERE 1=1"
                
                ' Filter by order type (Cake or General)
                If _orderType = "Cake" Then
                    sql &= " AND OrderNumber LIKE '%-CAKE-%'"
                ElseIf _orderType = "General" Then
                    sql &= " AND OrderNumber NOT LIKE '%-CAKE-%'"
                End If
                
                If _filterStatus <> "All" Then
                    sql &= " AND OrderStatus = @status"
                End If
                
                sql &= " ORDER BY ReadyDate, ReadyTime"
                
                Using da As New SqlDataAdapter(sql, conn)
                    If _filterStatus <> "All" Then
                        da.SelectCommand.Parameters.AddWithValue("@status", _filterStatus)
                    End If
                    
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    dgvOrders.DataSource = dt
                    
                    If dgvOrders.Columns.Contains("OrderID") Then
                        dgvOrders.Columns("OrderID").Visible = False
                    End If
                    
                    If dgvOrders.Columns.Contains("Total") Then
                        dgvOrders.Columns("Total").DefaultCellStyle.Format = "N2"
                    End If
                    
                    For Each row As DataGridViewRow In dgvOrders.Rows
                        Dim priority As String = row.Cells("Priority").Value.ToString()
                        Select Case priority
                            Case "OVERDUE"
                                row.DefaultCellStyle.BackColor = Color.LightCoral
                            Case "DUE TODAY"
                                row.DefaultCellStyle.BackColor = Color.LightYellow
                            Case "ON TIME"
                                row.DefaultCellStyle.BackColor = Color.LightGreen
                        End Select
                    Next
                    
                    lblCount.Text = $"{dt.Rows.Count} orders"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub dgvOrders_CellDoubleClick(sender As Object, e As DataGridViewCellEventArgs) Handles dgvOrders.CellDoubleClick
        If e.RowIndex >= 0 Then
            ShowDetails(e.RowIndex)
        End If
    End Sub
    
    Private Sub ShowDetails(rowIndex As Integer)
        Try
            Dim orderId As Integer = Convert.ToInt32(dgvOrders.Rows(rowIndex).Cells("OrderID").Value)
            
            Using conn As New SqlConnection(_connString)
                conn.Open()
                
                ' Get order details with branch info
                Dim cmdOrder As New SqlCommand("
                    SELECT o.*, b.BranchName
                    FROM POS_CustomOrders o
                    INNER JOIN Branches b ON o.BranchID = b.BranchID
                    WHERE o.OrderID = @id", conn)
                cmdOrder.Parameters.AddWithValue("@id", orderId)
                
                Dim details As New System.Text.StringBuilder()
                Dim orderNumber As String = ""
                Dim isCakeOrder As Boolean = False
                
                Using reader = cmdOrder.ExecuteReader()
                    If reader.Read() Then
                        orderNumber = reader("OrderNumber").ToString()
                        isCakeOrder = orderNumber.Contains("-CAKE-")
                        
                        details.AppendLine("═══════════════════════════════════════")
                        details.AppendLine($"ORDER: {orderNumber}")
                        details.AppendLine($"Type: {If(isCakeOrder, "CAKE ORDER", "GENERAL ORDER")}")
                        details.AppendLine($"Status: {reader("OrderStatus")}")
                        details.AppendLine("═══════════════════════════════════════")
                        details.AppendLine()
                        details.AppendLine("PICKUP BRANCH:")
                        details.AppendLine($"  {reader("BranchName")}")
                        details.AppendLine()
                        details.AppendLine("CUSTOMER:")
                        details.AppendLine($"  Name: {reader("CustomerName")} {reader("CustomerSurname")}")
                        details.AppendLine($"  Phone: {reader("CustomerPhone")}")
                        details.AppendLine()
                        details.AppendLine("DUE DATE:")
                        details.AppendLine($"  {Convert.ToDateTime(reader("ReadyDate")):dd MMM yyyy} at {CType(reader("ReadyTime"), TimeSpan):hh\:mm}")
                        details.AppendLine()
                        details.AppendLine("FINANCIAL:")
                        details.AppendLine($"  Total: R{Convert.ToDecimal(reader("TotalAmount")):N2}")
                        details.AppendLine($"  Deposit: R{Convert.ToDecimal(reader("DepositPaid")):N2}")
                        details.AppendLine($"  Balance: R{Convert.ToDecimal(reader("BalanceDue")):N2}")
                        details.AppendLine()
                        
                        ' Show manufacturing instructions if available (for cake orders)
                        If Not IsDBNull(reader("ManufacturingInstructions")) Then
                            Dim instructions As String = reader("ManufacturingInstructions").ToString()
                            If Not String.IsNullOrWhiteSpace(instructions) Then
                                details.AppendLine("───────────────────────────────────────")
                                details.AppendLine(instructions)
                                details.AppendLine("───────────────────────────────────────")
                                details.AppendLine()
                            End If
                        End If
                    End If
                End Using
                
                ' Get order items
                Dim cmdItems As New SqlCommand("
                    SELECT ProductName, Quantity, UnitPrice, LineTotal 
                    FROM POS_CustomOrderItems 
                    WHERE OrderID = @id
                    ORDER BY ProductName", conn)
                cmdItems.Parameters.AddWithValue("@id", orderId)
                
                details.AppendLine("ORDER ITEMS:")
                Dim itemTotal As Decimal = 0
                Using reader = cmdItems.ExecuteReader()
                    While reader.Read()
                        Dim qty = Convert.ToDecimal(reader("Quantity"))
                        Dim product = reader("ProductName").ToString()
                        Dim price = Convert.ToDecimal(reader("UnitPrice"))
                        Dim lineTotal = Convert.ToDecimal(reader("LineTotal"))
                        itemTotal += lineTotal
                        details.AppendLine($"  {qty:0.00} x {product}")
                        details.AppendLine($"      @ R{price:N2} = R{lineTotal:N2}")
                    End While
                End Using
                details.AppendLine($"  ─────────────────────")
                details.AppendLine($"  TOTAL: R{itemTotal:N2}")
                
                MessageBox.Show(details.ToString(), $"Order Details - {orderNumber}", MessageBoxButtons.OK, MessageBoxIcon.Information)
            End Using
        Catch ex As Exception
            MessageBox.Show("Error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub btnMarkReady_Click(sender As Object, e As EventArgs) Handles btnMarkReady.Click
        If dgvOrders.SelectedRows.Count = 0 Then Return
        
        Dim orderId As Integer = Convert.ToInt32(dgvOrders.SelectedRows(0).Cells("OrderID").Value)
        Dim orderNumber As String = dgvOrders.SelectedRows(0).Cells("Order #").Value.ToString()
        Dim status As String = dgvOrders.SelectedRows(0).Cells("Status").Value.ToString()
        
        If status <> "New" Then
            MessageBox.Show("Only NEW orders can be marked as ready", "Invalid", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        If MessageBox.Show($"Mark order {orderNumber} as READY?", "Confirm", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim cmd As New SqlCommand("UPDATE POS_CustomOrders SET OrderStatus = 'Ready' WHERE OrderID = @id", conn)
                    cmd.Parameters.AddWithValue("@id", orderId)
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show("Order marked as READY!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadOrders()
                End Using
            Catch ex As Exception
                MessageBox.Show("Error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub
    
    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadOrders()
    End Sub
    
    Private Sub btnClose_Click(sender As Object, e As EventArgs) Handles btnClose.Click
        Me.Close()
    End Sub
End Class
