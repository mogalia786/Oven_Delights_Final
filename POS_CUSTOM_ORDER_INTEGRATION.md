# POS Custom Order Integration - Direct Workflow

## Overview
This integrates custom order recall DIRECTLY into the POS workflow, not as a separate form.

---

## User Workflow

### Scenario: Customer arrives to collect order

1. **Cashier enters order number in scan box**
   - Type: `ORDER:O-JHB-000001` or just `O-JHB-000001`
   - Press Enter

2. **POS automatically:**
   - Recognizes it's an order number
   - Loads order details
   - Displays customer info banner
   - Populates cart with order items
   - Sets tender amount to BALANCE DUE (not total)
   - Shows "CUSTOM ORDER COLLECTION" mode

3. **Cashier processes payment:**
   - Customer pays balance
   - Click Finalize Sale
   - Order marked as Collected
   - Receipt shows collection details

4. **Cash-up shows correctly:**
   - Separate line: "Custom Order Collections"
   - Not mixed with regular sales
   - Shows order numbers collected

---

## Implementation

### Step 1: Add Order Recognition to POSForm.vb

In the `LookupProduct()` method, add order detection:

```vb
Private Sub LookupProduct()
    Try
        Dim input As String = txtScanSKU.Text.Trim().ToUpper()
        
        ' Check if it's an order number
        If input.StartsWith("ORDER:") OrElse input.StartsWith("O-") Then
            LoadCustomOrder(input.Replace("ORDER:", ""))
            Return
        End If
        
        ' ... existing product lookup code ...
        
    Catch ex As Exception
        MessageBox.Show("Error: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Try
End Sub
```

### Step 2: Add LoadCustomOrder Method

```vb
Private _isCustomOrderMode As Boolean = False
Private _currentOrderID As Integer = 0
Private _currentOrderNumber As String = ""
Private _orderDepositPaid As Decimal = 0
Private _orderTotalAmount As Decimal = 0

Private Sub LoadCustomOrder(orderNumber As String)
    Try
        Using conn As New SqlConnection(_connString)
            conn.Open()
            
            ' Load order details
            Dim cmdOrder As New SqlCommand("
                SELECT 
                    OrderID, OrderNumber, BranchID, BranchName,
                    CustomerName, CustomerSurname, CustomerPhone,
                    TotalAmount, DepositPaid, BalanceDue,
                    OrderStatus, ReadyDate, ReadyTime
                FROM POS_CustomOrders
                WHERE OrderNumber = @orderNumber
                AND BranchID = @branchId
                AND OrderStatus IN ('Pending', 'Ready')", conn)
            
            cmdOrder.Parameters.AddWithValue("@orderNumber", orderNumber)
            cmdOrder.Parameters.AddWithValue("@branchId", _currentBranchId)
            
            Using reader = cmdOrder.ExecuteReader()
                If Not reader.Read() Then
                    MessageBox.Show($"Order {orderNumber} not found or already collected.", "Order Not Found", MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    txtScanSKU.Clear()
                    Return
                End If
                
                ' Store order info
                _currentOrderID = Convert.ToInt32(reader("OrderID"))
                _currentOrderNumber = reader("OrderNumber").ToString()
                _orderTotalAmount = Convert.ToDecimal(reader("TotalAmount"))
                _orderDepositPaid = Convert.ToDecimal(reader("DepositPaid"))
                Dim balanceDue As Decimal = Convert.ToDecimal(reader("BalanceDue"))
                Dim customerName As String = $"{reader("CustomerName")} {reader("CustomerSurname")}"
                Dim customerPhone As String = reader("CustomerPhone").ToString()
                Dim orderStatus As String = reader("OrderStatus").ToString()
                
                reader.Close()
                
                ' Load order items
                Dim cmdItems As New SqlCommand("
                    SELECT ProductID, ProductName, Quantity, UnitPrice, LineTotal
                    FROM POS_CustomOrderItems
                    WHERE OrderID = @orderId", conn)
                
                cmdItems.Parameters.AddWithValue("@orderId", _currentOrderID)
                
                ' Clear cart and load order items
                _cartItems.Clear()
                
                Using itemReader = cmdItems.ExecuteReader()
                    While itemReader.Read()
                        Dim newRow = _cartItems.NewRow()
                        newRow("Code") = ""
                        newRow("SKU") = ""
                        newRow("ProductName") = itemReader("ProductName").ToString()
                        newRow("Quantity") = Convert.ToDecimal(itemReader("Quantity"))
                        newRow("UnitPrice") = Convert.ToDecimal(itemReader("UnitPrice"))
                        newRow("LineTotal") = Convert.ToDecimal(itemReader("LineTotal"))
                        newRow("ProductID") = Convert.ToInt32(itemReader("ProductID"))
                        _cartItems.Rows.Add(newRow)
                    End While
                End Using
                
                ' Enable custom order mode
                _isCustomOrderMode = True
                
                ' Update totals (balance due, not full amount)
                UpdateCartTotals()
                
                ' Override tender amount to balance due
                txtTenderAmount.Text = balanceDue.ToString("N2")
                
                ' Show customer info banner
                ShowCustomOrderBanner(customerName, customerPhone, orderStatus, balanceDue)
                
                ' Clear scan box
                txtScanSKU.Clear()
                txtScanSKU.Focus()
                
                MessageBox.Show(
                    $"Order {_currentOrderNumber} loaded!" & vbCrLf & vbCrLf &
                    $"Customer: {customerName}" & vbCrLf &
                    $"Phone: {customerPhone}" & vbCrLf & vbCrLf &
                    $"Total: R{_orderTotalAmount:N2}" & vbCrLf &
                    $"Deposit Paid: R{_orderDepositPaid:N2}" & vbCrLf &
                    $"BALANCE DUE: R{balanceDue:N2}" & vbCrLf & vbCrLf &
                    "Please collect balance payment.",
                    "Custom Order Collection",
                    MessageBoxButtons.OK,
                    MessageBoxIcon.Information)
            End Using
        End Using
        
    Catch ex As Exception
        MessageBox.Show("Error loading order: " & ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ExitCustomOrderMode()
    End Try
End Sub

Private Sub ShowCustomOrderBanner(customerName As String, phone As String, status As String, balance As Decimal)
    ' Create or update banner panel
    If Not Me.Controls.Contains(pnlOrderBanner) Then
        pnlOrderBanner = New Panel()
        pnlOrderBanner.BackColor = Color.FromArgb(255, 193, 7) ' Orange
        pnlOrderBanner.Dock = DockStyle.Top
        pnlOrderBanner.Height = 60
        pnlOrderBanner.BringToFront()
        
        lblOrderBanner = New Label()
        lblOrderBanner.Dock = DockStyle.Fill
        lblOrderBanner.Font = New Font("Segoe UI", 12, FontStyle.Bold)
        lblOrderBanner.ForeColor = Color.White
        lblOrderBanner.TextAlign = ContentAlignment.MiddleCenter
        
        pnlOrderBanner.Controls.Add(lblOrderBanner)
        Me.Controls.Add(pnlOrderBanner)
    End If
    
    lblOrderBanner.Text = $"🎂 CUSTOM ORDER COLLECTION | Order: {_currentOrderNumber} | Customer: {customerName} | Phone: {phone} | BALANCE DUE: R{balance:N2}"
    pnlOrderBanner.Visible = True
End Sub

Private Sub ExitCustomOrderMode()
    _isCustomOrderMode = False
    _currentOrderID = 0
    _currentOrderNumber = ""
    _orderDepositPaid = 0
    _orderTotalAmount = 0
    
    If pnlOrderBanner IsNot Nothing Then
        pnlOrderBanner.Visible = False
    End If
End Sub

Private pnlOrderBanner As Panel
Private lblOrderBanner As Label
```

### Step 3: Modify ProcessSale to Handle Custom Orders

```vb
Private Sub ProcessSale(tenderAmount As Decimal)
    Using conn As New SqlConnection(_connString)
        conn.Open()
        Using trans = conn.BeginTransaction()
            Try
                Dim saleId As Integer
                
                If _isCustomOrderMode Then
                    ' Process as custom order collection
                    saleId = CreateCustomOrderCollectionSale(conn, trans, tenderAmount)
                    
                    ' Mark order as collected
                    Dim cmdUpdate As New SqlCommand("
                        UPDATE POS_CustomOrders 
                        SET OrderStatus = 'Collected',
                            CollectedDate = GETDATE()
                        WHERE OrderID = @orderId", conn, trans)
                    cmdUpdate.Parameters.AddWithValue("@orderId", _currentOrderID)
                    cmdUpdate.ExecuteNonQuery()
                Else
                    ' Regular sale
                    saleId = CreateSaleHeader(conn, trans, tenderAmount)
                End If
                
                ' Create sale lines and update stock
                CreateSaleLines(conn, trans, saleId)
                
                trans.Commit()
                
                ' Show success and print receipt
                If _isCustomOrderMode Then
                    MessageBox.Show($"Order {_currentOrderNumber} collected successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    PrintCustomOrderCollectionReceipt(saleId)
                    ExitCustomOrderMode()
                Else
                    MessageBox.Show("Sale completed successfully!", "Success", MessageBoxButtons.OK, MessageBoxIcon.Information)
                    PrintReceipt(saleId)
                End If
                
                ' Clear cart
                _cartItems.Clear()
                UpdateCartTotals()
                txtScanSKU.Clear()
                txtScanSKU.Focus()
                
            Catch ex As Exception
                trans.Rollback()
                Throw
            End Try
        End Using
    End Using
End Sub

Private Function CreateCustomOrderCollectionSale(conn As SqlConnection, trans As SqlTransaction, tenderAmount As Decimal) As Integer
    ' Create sale with custom order reference
    Dim cmdSale As New SqlCommand("
        INSERT INTO Sales (
            BranchID, SaleDate, SaleType, ReferenceNumber,
            Subtotal, VAT, Total, TenderAmount, ChangeAmount,
            PaymentMethod, CashAmount, CardAmount, EFTAmount,
            CreatedBy, CreatedDate
        )
        VALUES (
            @branchId, GETDATE(), 'Custom Order Collection', @orderNumber,
            @subtotal, @vat, @total, @tenderAmount, @changeAmount,
            @paymentMethod, @cashAmount, @cardAmount, @eftAmount,
            @createdBy, GETDATE()
        );
        SELECT SCOPE_IDENTITY();", conn, trans)
    
    cmdSale.Parameters.AddWithValue("@branchId", _currentBranchId)
    cmdSale.Parameters.AddWithValue("@orderNumber", _currentOrderNumber)
    cmdSale.Parameters.AddWithValue("@subtotal", _currentSubtotal)
    cmdSale.Parameters.AddWithValue("@vat", _currentVAT)
    cmdSale.Parameters.AddWithValue("@total", _orderTotalAmount) ' Full amount
    cmdSale.Parameters.AddWithValue("@tenderAmount", tenderAmount)
    cmdSale.Parameters.AddWithValue("@changeAmount", tenderAmount - (_orderTotalAmount - _orderDepositPaid))
    cmdSale.Parameters.AddWithValue("@paymentMethod", _tenderType)
    cmdSale.Parameters.AddWithValue("@cashAmount", If(_tenderType = "Cash", tenderAmount, 0))
    cmdSale.Parameters.AddWithValue("@cardAmount", If(_tenderType = "Card", tenderAmount, 0))
    cmdSale.Parameters.AddWithValue("@eftAmount", If(_tenderType = "EFT", tenderAmount, 0))
    cmdSale.Parameters.AddWithValue("@createdBy", AppSession.CurrentUser?.Username)
    
    Return Convert.ToInt32(cmdSale.ExecuteScalar())
End Function

Private Sub PrintCustomOrderCollectionReceipt(saleId As Integer)
    ' Create collection receipt
    Dim receipt As New System.Text.StringBuilder()
    receipt.AppendLine("========================================")
    receipt.AppendLine("       OVEN DELIGHTS BAKERY")
    receipt.AppendLine("       COLLECTION RECEIPT")
    receipt.AppendLine("========================================")
    receipt.AppendLine()
    receipt.AppendLine($"ORDER NUMBER: {_currentOrderNumber}")
    receipt.AppendLine($"Sale ID: {saleId}")
    receipt.AppendLine($"Collection Date: {DateTime.Now:dd MMM yyyy HH:mm}")
    receipt.AppendLine($"Cashier: {AppSession.CurrentUser?.Username}")
    receipt.AppendLine("========================================")
    receipt.AppendLine()
    receipt.AppendLine("ITEMS COLLECTED:")
    receipt.AppendLine("----------------------------------------")
    
    For Each row As DataRow In _cartItems.Rows
        receipt.AppendLine($"{row("Quantity")} x {row("ProductName")}")
        receipt.AppendLine($"    @ R{Convert.ToDecimal(row("UnitPrice")):N2} = R{Convert.ToDecimal(row("LineTotal")):N2}")
    Next
    
    receipt.AppendLine("========================================")
    receipt.AppendLine($"Total Amount:   R{_orderTotalAmount,15:N2}")
    receipt.AppendLine($"Deposit Paid:   R{_orderDepositPaid,15:N2}")
    receipt.AppendLine($"Balance Paid:   R{(_orderTotalAmount - _orderDepositPaid),15:N2}")
    receipt.AppendLine("========================================")
    receipt.AppendLine()
    receipt.AppendLine($"Payment Method: {_tenderType}")
    receipt.AppendLine()
    receipt.AppendLine("Thank you for your business!")
    receipt.AppendLine("========================================")
    
    ' Display receipt (or send to printer)
    Dim receiptForm As New Form()
    receiptForm.Text = "Collection Receipt"
    receiptForm.Size = New Size(400, 600)
    receiptForm.StartPosition = FormStartPosition.CenterScreen
    
    Dim rtb As New RichTextBox()
    rtb.Dock = DockStyle.Fill
    rtb.Font = New Font("Courier New", 10)
    rtb.Text = receipt.ToString()
    rtb.ReadOnly = True
    
    receiptForm.Controls.Add(rtb)
    receiptForm.ShowDialog()
End Sub
```

### Step 4: Update Cash-Up Report

Add separate section for custom order collections:

```vb
Private Function GenerateCashUpReport() As String
    Dim report As New System.Text.StringBuilder()
    
    Using conn As New SqlConnection(_connString)
        conn.Open()
        
        ' Regular Sales
        Dim cmdSales As New SqlCommand("
            SELECT 
                COUNT(*) AS SaleCount,
                SUM(Total) AS TotalSales,
                SUM(CashAmount) AS CashSales,
                SUM(CardAmount) AS CardSales,
                SUM(EFTAmount) AS EFTSales
            FROM Sales
            WHERE BranchID = @branchId
            AND CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)
            AND (SaleType IS NULL OR SaleType = 'Regular')", conn)
        
        cmdSales.Parameters.AddWithValue("@branchId", _currentBranchId)
        
        ' Custom Order Collections
        Dim cmdOrders As New SqlCommand("
            SELECT 
                COUNT(*) AS OrderCount,
                SUM(Total) AS TotalAmount,
                SUM(CashAmount) AS CashAmount,
                SUM(CardAmount) AS CardAmount,
                SUM(EFTAmount) AS EFTAmount,
                STRING_AGG(ReferenceNumber, ', ') AS OrderNumbers
            FROM Sales
            WHERE BranchID = @branchId
            AND CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)
            AND SaleType = 'Custom Order Collection'", conn)
        
        cmdOrders.Parameters.AddWithValue("@branchId", _currentBranchId)
        
        report.AppendLine("========================================")
        report.AppendLine("       END OF DAY CASH-UP")
        report.AppendLine($"       {DateTime.Now:dd MMM yyyy}")
        report.AppendLine("========================================")
        report.AppendLine()
        
        ' Regular Sales Section
        Using reader = cmdSales.ExecuteReader()
            If reader.Read() Then
                report.AppendLine("REGULAR SALES:")
                report.AppendLine($"  Transactions: {reader("SaleCount")}")
                report.AppendLine($"  Total: R{Convert.ToDecimal(reader("TotalSales")):N2}")
                report.AppendLine($"  Cash: R{Convert.ToDecimal(reader("CashSales")):N2}")
                report.AppendLine($"  Card: R{Convert.ToDecimal(reader("CardSales")):N2}")
                report.AppendLine($"  EFT: R{Convert.ToDecimal(reader("EFTSales")):N2}")
            End If
        End Using
        
        report.AppendLine()
        report.AppendLine("----------------------------------------")
        report.AppendLine()
        
        ' Custom Order Collections Section
        Using reader = cmdOrders.ExecuteReader()
            If reader.Read() Then
                report.AppendLine("CUSTOM ORDER COLLECTIONS:")
                report.AppendLine($"  Orders Collected: {reader("OrderCount")}")
                report.AppendLine($"  Total: R{Convert.ToDecimal(reader("TotalAmount")):N2}")
                report.AppendLine($"  Cash: R{Convert.ToDecimal(reader("CashAmount")):N2}")
                report.AppendLine($"  Card: R{Convert.ToDecimal(reader("CardAmount")):N2}")
                report.AppendLine($"  EFT: R{Convert.ToDecimal(reader("EFTAmount")):N2}")
                
                If Not IsDBNull(reader("OrderNumbers")) Then
                    report.AppendLine($"  Orders: {reader("OrderNumbers")}")
                End If
            End If
        End Using
        
        report.AppendLine()
        report.AppendLine("========================================")
        
        ' Grand Total
        Dim cmdGrandTotal As New SqlCommand("
            SELECT 
                SUM(Total) AS GrandTotal,
                SUM(CashAmount) AS TotalCash,
                SUM(CardAmount) AS TotalCard,
                SUM(EFTAmount) AS TotalEFT
            FROM Sales
            WHERE BranchID = @branchId
            AND CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)", conn)
        
        cmdGrandTotal.Parameters.AddWithValue("@branchId", _currentBranchId)
        
        Using reader = cmdGrandTotal.ExecuteReader()
            If reader.Read() Then
                report.AppendLine()
                report.AppendLine("GRAND TOTAL:")
                report.AppendLine($"  Total Revenue: R{Convert.ToDecimal(reader("GrandTotal")):N2}")
                report.AppendLine($"  Total Cash: R{Convert.ToDecimal(reader("TotalCash")):N2}")
                report.AppendLine($"  Total Card: R{Convert.ToDecimal(reader("TotalCard")):N2}")
                report.AppendLine($"  Total EFT: R{Convert.ToDecimal(reader("TotalEFT")):N2}")
            End If
        End Using
        
        report.AppendLine("========================================")
    End Using
    
    Return report.ToString()
End Function
```

---

## Usage Instructions

### For Cashiers:

**To collect a custom order:**

1. Customer arrives with order slip
2. Type order number in scan box: `O-JHB-000001`
3. Press Enter
4. Orange banner appears with customer info
5. Cart populates with order items
6. Tender amount shows BALANCE DUE (not full amount)
7. Collect payment (Cash/Card/EFT)
8. Click "Finalize Sale"
9. Order marked as collected
10. Print collection receipt

**Visual Indicators:**
- Orange banner at top = Custom Order Mode
- Shows customer name and phone
- Shows balance due prominently
- Cart items are from the order

**To exit without completing:**
- Click "Clear Cart"
- Custom order mode exits
- Banner disappears

---

## Database Changes Needed

Add columns to Sales table:

```sql
ALTER TABLE Sales
ADD SaleType NVARCHAR(50) NULL,
    ReferenceNumber NVARCHAR(100) NULL;

-- Update existing sales
UPDATE Sales SET SaleType = 'Regular' WHERE SaleType IS NULL;
```

---

## Testing

1. Create custom order (F9)
2. Note order number
3. Clear cart
4. Type order number in scan box
5. Verify items load
6. Verify balance due is correct
7. Complete payment
8. Check order marked as Collected
9. Check cash-up shows separately

---

## Benefits

✅ No separate form needed
✅ Uses existing POS workflow
✅ Cashiers don't change process
✅ Balance payment only (not full amount)
✅ Separate in cash-up report
✅ Order numbers tracked
✅ Collection receipts printed
✅ Audit trail maintained

---

This is the **POS-integrated version** you requested!
