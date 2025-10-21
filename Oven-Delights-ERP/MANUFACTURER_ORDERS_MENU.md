# Manufacturer Orders Menu - ERP Solution

## Overview
This is for the **Oven-Delights-ERP** solution (Backend/Manufacturing).

---

## Menu Structure

**Manufacturing Menu → Orders**
- View New Orders (notification badge)
- View Ready Orders
- View All Orders
- Order Details

---

## Order Status Flow (ERP Side)

1. **New** - Just received from POS, manufacturer notified
2. **Ready** - Manufacturer completed, ready for collection
3. **Delivered** - Customer collected (updated by POS)

---

## Implementation

### Step 1: Add Menu to MainDashboard

In `MainDashboard.vb`, add Manufacturing menu:

```vb
Private Sub InitializeManufacturingMenu()
    ' Find or create Manufacturing menu
    Dim mnuManufacturing As ToolStripMenuItem = Nothing
    
    For Each item As ToolStripItem In MenuStrip1.Items
        If TypeOf item Is ToolStripMenuItem AndAlso item.Text = "Manufacturing" Then
            mnuManufacturing = CType(item, ToolStripMenuItem)
            Exit For
        End If
    Next
    
    If mnuManufacturing Is Nothing Then
        mnuManufacturing = New ToolStripMenuItem("Manufacturing")
        MenuStrip1.Items.Add(mnuManufacturing)
    End If
    
    ' Clear existing items
    mnuManufacturing.DropDownItems.Clear()
    
    ' Orders submenu
    Dim mnuOrders As New ToolStripMenuItem("Orders")
    mnuOrders.Image = My.Resources.orders_icon ' Add icon if available
    
    ' New Orders (with notification badge)
    Dim mnuNewOrders As New ToolStripMenuItem("New Orders")
    AddHandler mnuNewOrders.Click, Sub() OpenManufacturerOrders("New")
    mnuOrders.DropDownItems.Add(mnuNewOrders)
    
    ' Ready Orders
    Dim mnuReadyOrders As New ToolStripMenuItem("Ready Orders")
    AddHandler mnuReadyOrders.Click, Sub() OpenManufacturerOrders("Ready")
    mnuOrders.DropDownItems.Add(mnuReadyOrders)
    
    mnuOrders.DropDownItems.Add(New ToolStripSeparator())
    
    ' All Orders
    Dim mnuAllOrders As New ToolStripMenuItem("All Orders")
    AddHandler mnuAllOrders.Click, Sub() OpenManufacturerOrders("All")
    mnuOrders.DropDownItems.Add(mnuAllOrders)
    
    mnuManufacturing.DropDownItems.Add(mnuOrders)
    
    ' Update notification badge
    UpdateOrderNotificationBadge(mnuNewOrders)
End Sub

Private Sub OpenManufacturerOrders(status As String)
    Try
        Dim ordersForm As New ManufacturerOrdersForm(status)
        ordersForm.ShowDialog()
        
        ' Refresh badge after closing
        InitializeManufacturingMenu()
    Catch ex As Exception
        MessageBox.Show("Error opening orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Try
End Sub

Private Sub UpdateOrderNotificationBadge(menuItem As ToolStripMenuItem)
    Try
        Dim connString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim cmd As New SqlCommand("
                SELECT COUNT(*) 
                FROM POS_CustomOrders 
                WHERE OrderStatus = 'New'", conn)
            
            Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
            
            If count > 0 Then
                menuItem.Text = $"New Orders ({count})"
                menuItem.BackColor = Color.Orange
                menuItem.ForeColor = Color.White
            Else
                menuItem.Text = "New Orders"
                menuItem.BackColor = Color.Transparent
                menuItem.ForeColor = Color.Black
            End If
        End Using
    Catch ex As Exception
        ' Silent fail
    End Try
End Sub
```

### Step 2: Create ManufacturerOrdersForm.vb

```vb
Imports System.Data.SqlClient
Imports System.Configuration

Public Class ManufacturerOrdersForm
    Private ReadOnly _connString As String
    Private ReadOnly _filterStatus As String
    Private _selectedOrderId As Integer = 0
    
    Public Sub New(filterStatus As String)
        InitializeComponent()
        _connString = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        _filterStatus = filterStatus
    End Sub
    
    Private Sub ManufacturerOrdersForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        LoadOrders()
        SetupDataGridView()
        
        ' Set title based on filter
        Select Case _filterStatus
            Case "New"
                lblTitle.Text = "New Orders - Manufacturing"
                lblTitle.BackColor = Color.Orange
            Case "Ready"
                lblTitle.Text = "Ready Orders - Manufacturing"
                lblTitle.BackColor = Color.Green
            Case Else
                lblTitle.Text = "All Orders - Manufacturing"
                lblTitle.BackColor = Color.FromArgb(0, 122, 204)
        End Select
    End Sub
    
    Private Sub SetupDataGridView()
        dgvOrders.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill
        dgvOrders.SelectionMode = DataGridViewSelectionMode.FullRowSelect
        dgvOrders.MultiSelect = False
        dgvOrders.ReadOnly = True
        
        ' Add context menu
        Dim contextMenu As New ContextMenuStrip()
        contextMenu.Items.Add("View Details", Nothing, AddressOf ViewDetails)
        contextMenu.Items.Add("Mark as Ready", Nothing, AddressOf MarkAsReady)
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
                        CONVERT(VARCHAR, ReadyDate, 106) + ' ' + CONVERT(VARCHAR, ReadyTime, 108) AS [Due Date/Time],
                        TotalAmount AS Total,
                        DepositPaid AS Deposit,
                        BalanceDue AS Balance,
                        OrderStatus AS Status,
                        CASE 
                            WHEN ReadyDate < CAST(GETDATE() AS DATE) THEN 'OVERDUE'
                            WHEN ReadyDate = CAST(GETDATE() AS DATE) THEN 'DUE TODAY'
                            ELSE 'ON TIME'
                        END AS Priority
                    FROM POS_CustomOrders
                    WHERE 1=1"
                
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
                    
                    ' Hide OrderID
                    If dgvOrders.Columns.Contains("OrderID") Then
                        dgvOrders.Columns("OrderID").Visible = False
                    End If
                    
                    ' Format currency
                    If dgvOrders.Columns.Contains("Total") Then
                        dgvOrders.Columns("Total").DefaultCellStyle.Format = "N2"
                    End If
                    If dgvOrders.Columns.Contains("Deposit") Then
                        dgvOrders.Columns("Deposit").DefaultCellStyle.Format = "N2"
                    End If
                    If dgvOrders.Columns.Contains("Balance") Then
                        dgvOrders.Columns("Balance").DefaultCellStyle.Format = "N2"
                    End If
                    
                    ' Color code by priority
                    For Each row As DataGridViewRow In dgvOrders.Rows
                        Dim priority As String = row.Cells("Priority").Value.ToString()
                        Select Case priority
                            Case "OVERDUE"
                                row.DefaultCellStyle.BackColor = Color.LightCoral
                                row.DefaultCellStyle.Font = New Font(dgvOrders.Font, FontStyle.Bold)
                            Case "DUE TODAY"
                                row.DefaultCellStyle.BackColor = Color.LightYellow
                            Case "ON TIME"
                                row.DefaultCellStyle.BackColor = Color.LightGreen
                        End Select
                        
                        ' Status color
                        Dim status As String = row.Cells("Status").Value.ToString()
                        If status = "New" Then
                            row.Cells("Status").Style.BackColor = Color.Orange
                            row.Cells("Status").Style.ForeColor = Color.White
                        ElseIf status = "Ready" Then
                            row.Cells("Status").Style.BackColor = Color.Green
                            row.Cells("Status").Style.ForeColor = Color.White
                        End If
                    Next
                    
                    lblOrderCount.Text = $"{dt.Rows.Count} orders"
                End Using
            End Using
        Catch ex As Exception
            MessageBox.Show("Error loading orders: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub
    
    Private Sub ViewDetails(sender As Object, e As EventArgs)
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
                Dim sqlItems As String = "SELECT ProductName, Quantity, UnitPrice, LineTotal, SpecialInstructions FROM POS_CustomOrderItems WHERE OrderID = @orderId"
                Dim itemsData As New DataTable()
                
                Using da As New SqlDataAdapter(sqlItems, conn)
                    da.SelectCommand.Parameters.AddWithValue("@orderId", orderId)
                    da.Fill(itemsData)
                End Using
                
                ' Build details
                Dim details As New System.Text.StringBuilder()
                details.AppendLine($"ORDER: {orderData("OrderNumber")}")
                details.AppendLine($"Branch: {orderData("BranchName")}")
                details.AppendLine($"Status: {orderData("OrderStatus")}")
                details.AppendLine()
                details.AppendLine($"Customer: {orderData("CustomerName")} {orderData("CustomerSurname")}")
                details.AppendLine($"Phone: {orderData("CustomerPhone")}")
                details.AppendLine()
                details.AppendLine($"Order Date: {Convert.ToDateTime(orderData("OrderDate")):dd MMM yyyy HH:mm}")
                details.AppendLine($"DUE: {Convert.ToDateTime(orderData("ReadyDate")):dd MMM yyyy} at {CType(orderData("ReadyTime"), TimeSpan):hh\:mm}")
                details.AppendLine()
                details.AppendLine("ITEMS TO PREPARE:")
                details.AppendLine(New String("-"c, 50))
                
                For Each item As DataRow In itemsData.Rows
                    details.AppendLine($"{item("Quantity")} x {item("ProductName")}")
                    If Not IsDBNull(item("SpecialInstructions")) AndAlso Not String.IsNullOrWhiteSpace(item("SpecialInstructions").ToString()) Then
                        details.AppendLine($"   Note: {item("SpecialInstructions")}")
                    End If
                Next
                
                details.AppendLine(New String("-"c, 50))
                details.AppendLine($"Total: R{Convert.ToDecimal(orderData("TotalAmount")):N2}")
                details.AppendLine($"Deposit Paid: R{Convert.ToDecimal(orderData("DepositPaid")):N2}")
                details.AppendLine($"Balance Due: R{Convert.ToDecimal(orderData("BalanceDue")):N2}")
                
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
        
        If status <> "New" Then
            MessageBox.Show("Only NEW orders can be marked as ready", "Invalid Status", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        Dim result = MessageBox.Show(
            $"Mark order {orderNumber} as READY for collection?" & vbCrLf & vbCrLf &
            "This will notify the POS that the order is ready.",
            "Confirm Ready",
            MessageBoxButtons.YesNo,
            MessageBoxIcon.Question)
        
        If result = DialogResult.Yes Then
            Try
                Using conn As New SqlConnection(_connString)
                    conn.Open()
                    Dim cmd As New SqlCommand("UPDATE POS_CustomOrders SET OrderStatus = 'Ready' WHERE OrderID = @orderId", conn)
                    cmd.Parameters.AddWithValue("@orderId", orderId)
                    cmd.ExecuteNonQuery()
                    
                    MessageBox.Show($"Order {orderNumber} marked as READY!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    LoadOrders()
                End Using
            Catch ex As Exception
                MessageBox.Show("Error updating order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            End Try
        End If
    End Sub
    
    Private Sub btnRefresh_Click(sender As Object, e As EventArgs) Handles btnRefresh.Click
        LoadOrders()
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
```

---

## Database Update

Update order status values:

```sql
-- Update Create_CustomOrders_Table.sql
-- Change default status from 'Pending' to 'New'

ALTER TABLE POS_CustomOrders
ADD CONSTRAINT CHK_OrderStatus 
CHECK (OrderStatus IN ('New', 'Ready', 'Delivered', 'Cancelled'));

-- Update existing orders
UPDATE POS_CustomOrders 
SET OrderStatus = 'New' 
WHERE OrderStatus = 'Pending';
```

---

## Notification System

Add timer to MainDashboard to check for new orders:

```vb
Private WithEvents orderNotificationTimer As New Timer()

Private Sub InitializeOrderNotifications()
    orderNotificationTimer.Interval = 60000 ' 1 minute
    orderNotificationTimer.Start()
End Sub

Private Sub orderNotificationTimer_Tick(sender As Object, e As EventArgs) Handles orderNotificationTimer.Tick
    CheckNewOrders()
End Sub

Private Sub CheckNewOrders()
    Try
        Dim connString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
        
        Using conn As New SqlConnection(connString)
            conn.Open()
            Dim cmd As New SqlCommand("
                SELECT COUNT(*) 
                FROM POS_CustomOrders 
                WHERE OrderStatus = 'New'
                AND DATEDIFF(MINUTE, OrderDate, GETDATE()) <= 5", conn) ' New in last 5 minutes
            
            Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
            
            If count > 0 Then
                ' Show notification
                NotifyIcon1.ShowBalloonTip(5000, "New Orders!", $"You have {count} new order(s) to prepare", ToolTipIcon.Info)
                
                ' Play sound
                My.Computer.Audio.PlaySystemSound(System.Media.SystemSounds.Asterisk)
            End If
        End Using
    Catch ex As Exception
        ' Silent fail
    End Try
End Sub
```

---

## Summary

**ERP Solution (Manufacturing):**
- Manufacturing Menu → Orders
- View New Orders (with notification badge)
- View Ready Orders
- Mark orders as Ready
- Notification system for new orders
- Color-coded by priority (Overdue/Due Today/On Time)

**Status Flow:**
1. **New** - Just received from POS
2. **Ready** - Manufacturer completed
3. **Delivered** - Customer collected (POS updates this)
