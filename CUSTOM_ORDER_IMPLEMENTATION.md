# Custom Order / Cake Build Implementation Guide

## Overview
This document provides step-by-step instructions to add Custom Order functionality to the POS system.

## Files Created
1. `SQL/Create_CustomOrders_Table.sql` - Database tables
2. `CustomerOrderDialog.vb` - Customer details dialog
3. `CustomerOrderDialog.Designer.vb` - Dialog UI design

## Implementation Steps

### Step 1: Run SQL Script
Execute the `Create_CustomOrders_Table.sql` script in your database to create:
- `POS_CustomOrders` table
- `POS_CustomOrderItems` table
- `fn_GetNextOrderNumber` function

### Step 2: Add Button to POSForm.Designer.vb

Add this button declaration after line 45 (after `btnClearCart`):

```vb
Me.btnCustomOrder = New System.Windows.Forms.Button()
```

Add button initialization in InitializeComponent (around line 200):

```vb
'
' btnCustomOrder
'
Me.btnCustomOrder.BackColor = System.Drawing.Color.FromArgb(CType(CType(255, Byte), Integer), CType(CType(193, Byte), Integer), CType(CType(7, Byte), Integer))
Me.btnCustomOrder.FlatStyle = System.Windows.Forms.FlatStyle.Flat
Me.btnCustomOrder.Font = New System.Drawing.Font("Segoe UI", 12.0!, System.Drawing.FontStyle.Bold)
Me.btnCustomOrder.ForeColor = System.Drawing.Color.White
Me.btnCustomOrder.Location = New System.Drawing.Point(10, 520)
Me.btnCustomOrder.Name = "btnCustomOrder"
Me.btnCustomOrder.Size = New System.Drawing.Size(380, 50)
Me.btnCustomOrder.TabIndex = 8
Me.btnCustomOrder.Text = "Custom Order / Cake Build"
Me.btnCustomOrder.UseVisualStyleBackColor = False
```

Add to pnlTender controls:

```vb
Me.pnlTender.Controls.Add(Me.btnCustomOrder)
```

Add Friend declaration at the end:

```vb
Friend WithEvents btnCustomOrder As Button
```

### Step 3: Add Event Handler to POSForm.vb

In `SetupEventHandlers()` method (around line 67), add:

```vb
AddHandler btnCustomOrder.Click, AddressOf btnCustomOrder_Click
```

### Step 4: Add Custom Order Method to POSForm.vb

Add this method after `btnClearCart_Click` (around line 370):

```vb
Private Sub btnCustomOrder_Click(sender As Object, e As EventArgs)
    Try
        If _cartItems.Rows.Count = 0 Then
            MessageBox.Show("Cart is empty. Please add items before creating a custom order.", "Custom Order", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            Return
        End If
        
        ' Get branch prefix from database
        Dim branchPrefix As String = GetBranchPrefix(_currentBranchId)
        Dim branchName As String = GetBranchName(_currentBranchId)
        
        ' Convert cart items to list
        Dim orderItems As New List(Of CartItem)()
        For Each row As DataRow In _cartItems.Rows
            orderItems.Add(New CartItem With {
                .ProductID = Convert.ToInt32(row("ProductID")),
                .ProductName = row("ProductName").ToString(),
                .Quantity = Convert.ToDecimal(row("Quantity")),
                .UnitPrice = Convert.ToDecimal(row("UnitPrice")),
                .LineTotal = Convert.ToDecimal(row("LineTotal"))
            })
        Next
        
        ' Show custom order dialog
        Dim orderDialog As New CustomerOrderDialog()
        orderDialog.OrderItems = orderItems
        orderDialog.TotalAmount = _currentTotal
        orderDialog.BranchID = _currentBranchID
        orderDialog.BranchName = branchName
        orderDialog.BranchPrefix = branchPrefix
        orderDialog.CurrentUser = AppSession.CurrentUser?.Username
        
        If orderDialog.ShowDialog() = DialogResult.OK Then
            ' Clear cart after successful order
            _cartItems.Clear()
            UpdateCartTotals()
            txtScanSKU.Clear()
            txtScanSKU.Focus()
            
            MessageBox.Show($"Custom order {orderDialog.OrderNumber} created successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
        End If
        
    Catch ex As Exception
        MessageBox.Show("Error creating custom order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Try
End Sub

Private Function GetBranchPrefix(branchId As Integer) As String
    Try
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Dim cmd As New SqlCommand("SELECT BranchCode FROM Branches WHERE BranchID = @bid", conn)
            cmd.Parameters.AddWithValue("@bid", branchId)
            Dim result = cmd.ExecuteScalar()
            Return If(result IsNot Nothing, result.ToString(), "BR")
        End Using
    Catch
        Return "BR"
    End Try
End Function

Private Function GetBranchName(branchId As Integer) As String
    Try
        Using conn As New SqlConnection(_connString)
            conn.Open()
            Dim cmd As New SqlCommand("SELECT BranchName FROM Branches WHERE BranchID = @bid", conn)
            cmd.Parameters.AddWithValue("@bid", branchId)
            Dim result = cmd.ExecuteScalar()
            Return If(result IsNot Nothing, result.ToString(), "Unknown Branch")
        End Using
    Catch
        Return "Unknown Branch"
    End Try
End Function
```

### Step 5: Add CartItem Class

Add this class at the end of POSForm.vb (outside the POSForm class):

```vb
Public Class CartItem
    Public Property ProductID As Integer
    Public Property ProductName As String
    Public Property Quantity As Decimal
    Public Property UnitPrice As Decimal
    Public Property LineTotal As Decimal
End Class
```

### Step 6: Add CustomerOrderDialog files to project

1. Copy `CustomerOrderDialog.vb` to your Forms/Retail folder
2. Copy `CustomerOrderDialog.Designer.vb` to your Forms/Retail folder
3. Add both files to your project in Visual Studio
4. Build the project

### Step 7: Update Connection String

Make sure `CustomerOrderDialog.vb` has access to the connection string. Add this property at the top of the class:

```vb
Private ReadOnly ConnectionString As String = ConfigurationManager.ConnectionStrings("OvenDelightsERPConnectionString")?.ConnectionString
```

## Testing

1. Run the POS application
2. Add items to cart
3. Click "Custom Order / Cake Build" button
4. Fill in customer details:
   - Name: John
   - Surname: Doe
   - Phone: 0821234567
   - Ready Date: Tomorrow
   - Ready Time: 14:00
   - Deposit: 50% of total
5. Click "Proceed to Payment"
6. Complete payment
7. Verify order is saved in database
8. Check receipt displays correctly with branch name

## Database Queries for Testing

```sql
-- View all custom orders
SELECT * FROM POS_CustomOrders ORDER BY OrderDate DESC;

-- View order items
SELECT co.OrderNumber, co.CustomerName, co.CustomerSurname, 
       coi.ProductName, coi.Quantity, coi.UnitPrice, coi.LineTotal
FROM POS_CustomOrders co
JOIN POS_CustomOrderItems coi ON co.OrderID = coi.OrderID
ORDER BY co.OrderDate DESC;

-- View orders by branch
SELECT OrderNumber, BranchName, CustomerName, CustomerSurname, 
       TotalAmount, DepositPaid, BalanceDue, OrderStatus, ReadyDate
FROM POS_CustomOrders
WHERE BranchID = 1
ORDER BY OrderDate DESC;
```

## Features Implemented

✅ Customer details capture (name, surname, phone)
✅ Ready date and time selection
✅ Deposit amount calculation
✅ Balance due calculation
✅ Payment processing (Cash/Card/EFT/Split)
✅ Order number generation: O-[BranchPrefix]-000001
✅ Order saved to database with branch info
✅ Receipt/slip display with:
   - Branch name prominently displayed
   - Customer details
   - Items ordered
   - Deposit paid
   - Balance due
   - Ready date/time
✅ Cart cleared after successful order

## Order Number Format

- Format: `O-[BranchPrefix]-000001`
- Example: `O-JHB-000001` (Johannesburg branch)
- Example: `O-CPT-000001` (Cape Town branch)
- Auto-increments per branch

## Notes

- Deposit defaults to 50% but can be changed
- Minimum ready date is tomorrow
- Default ready time is 2 PM
- Branch name appears on receipt
- Order status defaults to "Pending"
- Balance is calculated automatically
- Payment methods support split payments
