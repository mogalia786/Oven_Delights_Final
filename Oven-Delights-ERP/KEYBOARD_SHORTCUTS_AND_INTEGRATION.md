# Keyboard Shortcuts & Integration Guide

## Overview
This document provides keyboard shortcuts and integration instructions for Custom Orders functionality.

---

## Keyboard Shortcuts for POS

Add these keyboard shortcuts to POSForm.vb:

### Step 1: Override ProcessCmdKey Method

Add this method to POSForm.vb class:

```vb
Protected Overrides Function ProcessCmdKey(ByRef msg As Message, keyData As Keys) As Boolean
    ' F9 - Custom Order / Cake Build
    If keyData = Keys.F9 Then
        btnCustomOrder.PerformClick()
        Return True
    End If
    
    ' F10 - Recall Custom Order
    If keyData = Keys.F10 Then
        OpenRecallCustomOrder()
        Return True
    End If
    
    ' F11 - View All Orders
    If keyData = Keys.F11 Then
        OpenOrdersManagement()
        Return True
    End If
    
    ' F12 - Finalize Sale (existing)
    If keyData = Keys.F12 Then
        btnFinalizeSale.PerformClick()
        Return True
    End If
    
    Return MyBase.ProcessCmdKey(msg, keyData)
End Function

Private Sub OpenRecallCustomOrder()
    Try
        Dim recallForm As New RecallCustomOrderForm(_currentBranchId, AppSession.CurrentUser?.Username)
        recallForm.ShowDialog()
    Catch ex As Exception
        MessageBox.Show("Error opening recall form: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Try
End Sub

Private Sub OpenOrdersManagement()
    Try
        Dim ordersForm As New OrdersManagementForm(_currentBranchId, AppSession.CurrentUser?.Username, _isSuperAdmin)
        ordersForm.ShowDialog()
    Catch ex As Exception
        MessageBox.Show("Error opening orders management: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Try
End Sub
```

---

## Complete Keyboard Shortcut Map

| Key | Function | Description |
|-----|----------|-------------|
| **F1** | Help | Show help/shortcuts |
| **F2** | Quantity | Quick quantity entry |
| **F3** | Search | Focus on search box |
| **F4** | Discount | Apply discount |
| **F5** | Hold Transaction | Hold current transaction |
| **F6** | Recall Transaction | Recall held transaction |
| **F7** | Returns | Process return |
| **F8** | Clear Cart | Clear current cart |
| **F9** | **Custom Order** | **Create custom order/cake build** |
| **F10** | **Recall Order** | **Recall & collect custom order** |
| **F11** | **View Orders** | **View all custom orders** |
| **F12** | Finalize Sale | Complete sale |
| **Shift+F1** | Cash Payment | Quick cash payment |
| **Shift+F2** | Card Payment | Quick card payment |
| **Shift+F3** | EFT Payment | Quick EFT payment |
| **Ctrl+P** | Print Receipt | Reprint last receipt |
| **Ctrl+N** | New Sale | Start new sale |
| **Esc** | Cancel | Cancel current action |

---

## Integration with Main Dashboard

### Option 1: Add to Retail Menu

In MainDashboard.vb, add menu items:

```vb
' In the Retail menu section
Dim mnuCustomOrders As New ToolStripMenuItem("Custom Orders")
mnuCustomOrders.Image = My.Resources.cake_icon ' Add icon if available

Dim mnuCreateOrder As New ToolStripMenuItem("Create Custom Order (F9)")
AddHandler mnuCreateOrder.Click, Sub() OpenPOSWithCustomOrder()
mnuCustomOrders.DropDownItems.Add(mnuCreateOrder)

Dim mnuRecallOrder As New ToolStripMenuItem("Recall Order (F10)")
AddHandler mnuRecallOrder.Click, Sub() OpenRecallCustomOrder()
mnuCustomOrders.DropDownItems.Add(mnuRecallOrder)

Dim mnuViewOrders As New ToolStripMenuItem("View All Orders (F11)")
AddHandler mnuViewOrders.Click, Sub() OpenOrdersManagement()
mnuCustomOrders.DropDownItems.Add(mnuViewOrders)

' Add to Retail menu
mnuRetail.DropDownItems.Add(mnuCustomOrders)
```

### Option 2: Add Dashboard Tiles

Add these tiles to the main dashboard:

```vb
' Custom Orders Tile
Dim tileCustomOrders As New Panel()
tileCustomOrders.Size = New Size(200, 150)
tileCustomOrders.BackColor = Color.FromArgb(255, 193, 7) ' Orange
tileCustomOrders.Cursor = Cursors.Hand

Dim lblCustomOrders As New Label()
lblCustomOrders.Text = "Custom Orders" & vbCrLf & "Cake Builds"
lblCustomOrders.Font = New Font("Segoe UI", 14, FontStyle.Bold)
lblCustomOrders.ForeColor = Color.White
lblCustomOrders.TextAlign = ContentAlignment.MiddleCenter
lblCustomOrders.Dock = DockStyle.Fill

tileCustomOrders.Controls.Add(lblCustomOrders)
AddHandler tileCustomOrders.Click, Sub() OpenPOSWithCustomOrder()

' Recall Orders Tile
Dim tileRecallOrders As New Panel()
tileRecallOrders.Size = New Size(200, 150)
tileRecallOrders.BackColor = Color.FromArgb(40, 167, 69) ' Green

Dim lblRecallOrders As New Label()
lblRecallOrders.Text = "Recall Order" & vbCrLf & "Collection"
lblRecallOrders.Font = New Font("Segoe UI", 14, FontStyle.Bold)
lblRecallOrders.ForeColor = Color.White
lblRecallOrders.TextAlign = ContentAlignment.MiddleCenter
lblRecallOrders.Dock = DockStyle.Fill

tileRecallOrders.Controls.Add(lblRecallOrders)
AddHandler tileRecallOrders.Click, Sub() OpenRecallCustomOrder()
```

---

## Quick Access Buttons in POS

Add these buttons to the POS form for easy access:

### Button Layout (Right Panel):

```
┌─────────────────────────────┐
│  Cart Items                 │
│  [DataGridView]             │
│                             │
│  Subtotal:    R 100.00      │
│  VAT:         R  15.00      │
│  Total:       R 115.00      │
│                             │
│  ┌─────────┐ ┌─────────┐   │
│  │  Cash   │ │  Card   │   │
│  └─────────┘ └─────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │  Finalize Sale      │   │
│  │       (F12)         │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │  Custom Order       │   │
│  │  Cake Build (F9)    │   │
│  └─────────────────────┘   │
│                             │
│  ┌──────────┐ ┌──────────┐ │
│  │ Recall   │ │  View    │ │
│  │ Order    │ │  Orders  │ │
│  │  (F10)   │ │  (F11)   │ │
│  └──────────┘ └──────────┘ │
│                             │
│  ┌─────────────────────┐   │
│  │  Clear Cart         │   │
│  └─────────────────────┘   │
└─────────────────────────────┘
```

---

## Status Bar Shortcuts Display

Add a status bar to show available shortcuts:

```vb
Dim statusBar As New StatusStrip()
statusBar.Items.Add(New ToolStripStatusLabel("F9: Custom Order"))
statusBar.Items.Add(New ToolStripSeparator())
statusBar.Items.Add(New ToolStripStatusLabel("F10: Recall"))
statusBar.Items.Add(New ToolStripSeparator())
statusBar.Items.Add(New ToolStripStatusLabel("F11: View Orders"))
statusBar.Items.Add(New ToolStripSeparator())
statusBar.Items.Add(New ToolStripStatusLabel("F12: Finalize"))

Me.Controls.Add(statusBar)
```

---

## Notification System

### Show Pending Orders Count

Add this to POSForm_Load:

```vb
Private Sub ShowPendingOrdersNotification()
    Try
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Dim cmd As New SqlCommand("
                SELECT COUNT(*) 
                FROM POS_CustomOrders 
                WHERE BranchID = @branchId 
                AND OrderStatus IN ('Pending', 'Ready')
                AND ReadyDate <= GETDATE()", conn)
            cmd.Parameters.AddWithValue("@branchId", _currentBranchId)
            
            Dim count As Integer = Convert.ToInt32(cmd.ExecuteScalar())
            
            If count > 0 Then
                ' Show notification badge
                lblPendingOrders.Text = count.ToString()
                lblPendingOrders.Visible = True
                lblPendingOrders.BackColor = Color.Red
                lblPendingOrders.ForeColor = Color.White
                
                ' Optional: Show toast notification
                MessageBox.Show($"You have {count} orders ready for collection!", 
                               "Pending Orders", 
                               MessageBoxButtons.OK, 
                               MessageBoxIcon.Information)
            End If
        End Using
    Catch ex As Exception
        ' Silent fail - don't interrupt POS loading
    End Try
End Sub
```

---

## Timer for Auto-Refresh

Add a timer to check for orders due today:

```vb
Private WithEvents orderCheckTimer As New Timer()

Private Sub InitializeOrderTimer()
    orderCheckTimer.Interval = 300000 ' 5 minutes
    orderCheckTimer.Start()
End Sub

Private Sub orderCheckTimer_Tick(sender As Object, e As EventArgs) Handles orderCheckTimer.Tick
    ShowPendingOrdersNotification()
End Sub
```

---

## Reports Integration

### Add to Reports Menu

```vb
' Custom Orders Report
Dim mnuCustomOrdersReport As New ToolStripMenuItem("Custom Orders Report")
AddHandler mnuCustomOrdersReport.Click, Sub() ShowCustomOrdersReport()

Private Sub ShowCustomOrdersReport()
    ' Generate report showing:
    ' - Orders by status
    ' - Revenue from custom orders
    ' - Popular items
    ' - Average order value
    ' - Deposit collection rate
End Sub
```

---

## Database Views for Reporting

Add these views to your SQL script:

```sql
-- View: Pending Orders Due Today
CREATE VIEW vw_OrdersDueToday AS
SELECT 
    OrderNumber,
    BranchName,
    CustomerName + ' ' + CustomerSurname AS Customer,
    CustomerPhone,
    ReadyTime,
    TotalAmount,
    BalanceDue,
    OrderStatus
FROM POS_CustomOrders
WHERE ReadyDate = CAST(GETDATE() AS DATE)
AND OrderStatus IN ('Pending', 'Ready');
GO

-- View: Custom Orders Summary
CREATE VIEW vw_CustomOrdersSummary AS
SELECT 
    BranchID,
    BranchName,
    OrderStatus,
    COUNT(*) AS OrderCount,
    SUM(TotalAmount) AS TotalRevenue,
    SUM(DepositPaid) AS TotalDeposits,
    SUM(BalanceDue) AS TotalBalance
FROM POS_CustomOrders
GROUP BY BranchID, BranchName, OrderStatus;
GO
```

---

## Testing Checklist

- [ ] F9 opens Custom Order dialog from POS
- [ ] F10 opens Recall Order form
- [ ] F11 opens Orders Management
- [ ] Custom order saves correctly
- [ ] Order number increments per branch
- [ ] Balance payment processes correctly
- [ ] Order converts to sale successfully
- [ ] Receipt prints with branch name
- [ ] Search works in Recall form
- [ ] Status filters work in Orders Management
- [ ] Export to CSV works
- [ ] Context menu actions work
- [ ] Notifications show for pending orders
- [ ] Timer refreshes pending count

---

## Quick Start Guide for Users

### Creating a Custom Order:
1. Add items to cart in POS
2. Press **F9** or click "Custom Order"
3. Enter customer details
4. Set ready date/time
5. Enter deposit amount
6. Process payment
7. Print receipt

### Collecting an Order:
1. Press **F10** or click "Recall Order"
2. Search for order (name, phone, or order #)
3. Select order from list
4. Click "Process Balance & Collect"
5. Complete payment
6. Print collection receipt

### Managing Orders:
1. Press **F11** or click "View Orders"
2. Filter by status/date
3. Right-click order for options:
   - View Details
   - Mark as Ready
   - Cancel Order
   - Print Order
4. Export to CSV for reporting

---

## Support & Troubleshooting

### Common Issues:

**Issue:** Order number not incrementing
**Solution:** Check fn_GetNextOrderNumber function exists

**Issue:** Branch name not showing on receipt
**Solution:** Verify BranchName is populated in POS_CustomOrders table

**Issue:** Payment not processing
**Solution:** Check PaymentForm is properly configured

**Issue:** Keyboard shortcuts not working
**Solution:** Verify ProcessCmdKey override is in POSForm.vb

---

## Future Enhancements

- [ ] SMS notifications when order is ready
- [ ] Email receipts
- [ ] WhatsApp integration
- [ ] Online order portal
- [ ] Calendar view of orders
- [ ] Automatic pricing for cake sizes
- [ ] Photo upload for custom designs
- [ ] Order templates for repeat customers
- [ ] Loyalty points for custom orders
- [ ] Batch order processing

---

**All shortcuts and integration points are now documented!** 🎯
