# Cancel Cake Order Workflow

## Overview
This document describes the complete workflow for cancelling cake orders with deposit refunds and cancellation fee processing.

## Business Rules

### Cancellable Orders
- **Status**: Only orders with status "New" or "Ready" can be cancelled
- **Delivered Orders**: Cannot be cancelled (already completed)
- **Already Cancelled**: System prevents duplicate cancellations

### Financial Calculation
```
Refund Amount = Deposit Paid - Cancellation Fee
```

### Payment Method Matching
- Refund is issued using the **same payment method** as the original deposit
- Cash deposit → Cash refund
- Card deposit → Card refund
- EFT deposit → EFT refund
- Split payment → Proportional refund to each method

## Workflow Steps

### 1. Access Cancel Order Form
**Location**: POS Main Form → Cancel Order (Shortcut Key: TBD)

**User Action**: Click "Cancel Order" button or press shortcut key

### 2. Order Lookup
**Input**: Order Number (e.g., O-AC-CAKE-000001)

**System Actions**:
- Query `POS_CustomOrders` table for order details
- Query `Demo_Sales` table for deposit payment details (WHERE SaleType = 'OrderDeposit')
- Validate order status (must be New or Ready)
- Display order information:
  - Customer name and phone
  - Order date
  - Order status
  - Deposit amount
  - Payment method used

**Validation**:
- Order must exist
- Order must not be Delivered
- Order must not already be Cancelled
- Deposit must have been recorded

### 3. Select Cancellation Fee
**Input**: 
- Select cancellation fee item from dropdown
- System auto-populates fee amount from product price
- User can adjust fee amount if needed

**System Actions**:
- Load cancellation fee items from `Demo_Retail_Product` (WHERE Name LIKE '%cancellation%')
- Retrieve selling price from `Demo_Retail_Price` for selected branch
- Calculate refund amount in real-time

**Validation**:
- Cancellation fee cannot exceed deposit amount
- Refund amount must be >= 0

### 4. Review Cancellation Summary
**Display**:
- Deposit Amount: R XXX.XX
- Cancellation Fee: R XXX.XX
- **Refund Amount**: R XXX.XX (highlighted in green)
- Payment Method: Cash/Card/EFT

**User Action**: Click "Process Cancellation"

**Confirmation Dialog**:
```
Cancel Order: O-AC-CAKE-000001
Customer: John Doe
Deposit: R 500.00
Cancellation Fee: R 100.00
Refund Amount: R 400.00

Are you sure you want to cancel this order?
[Yes] [No]
```

### 5. Process Cancellation (Database Transaction)

**Transaction Steps** (All or Nothing):

#### 5.1 Update Order Status
```sql
UPDATE POS_CustomOrders 
SET OrderStatus = 'Cancelled',
    ModifiedDate = GETDATE()
WHERE OrderNumber = @orderNumber
```

#### 5.2 Record Cancellation Fee as Revenue
```sql
INSERT INTO Demo_Sales 
(InvoiceNumber, BranchID, TotalAmount, PaymentMethod, 
 SaleType, SaleDate, CashierID, CustomerName)
VALUES 
('CANCEL-20260223120000-1234', @branchId, @cancellationFee, 'Cash', 
 'CancellationFee', GETDATE(), @cashierId, @customerName)
```

**SaleType**: `'CancellationFee'` (new sale type)

#### 5.3 Record Refund Transaction
```sql
INSERT INTO Demo_Sales 
(InvoiceNumber, BranchID, TotalAmount, PaymentMethod, 
 SaleType, SaleDate, CashierID, CustomerName)
VALUES 
('CANCEL-20260223120001-5678', @branchId, -@refundAmount, @originalPaymentMethod, 
 'OrderRefund', GETDATE(), @cashierId, @customerName)
```

**SaleType**: `'OrderRefund'` (new sale type)
**TotalAmount**: Negative value to represent money going out

### 6. Print Documentation

#### 6.1 Cancellation Slip (Internal Record)
```
═══════════════════════════════════
    ORDER CANCELLATION SLIP
═══════════════════════════════════

Order Number: O-AC-CAKE-000001
Customer: John Doe
Phone: 0821234567
Order Date: 20 Feb 2026

FINANCIAL SUMMARY
─────────────────────────────────
Deposit Paid:        R 500.00
Cancellation Fee:    R 100.00
─────────────────────────────────
Refund Amount:       R 400.00
Refund Method:       Cash

Cancelled By: cashier01
Date/Time: 23 Feb 2026 12:00
═══════════════════════════════════
```

#### 6.2 Refund Receipt (Customer Copy)
```
═══════════════════════════════════
         REFUND RECEIPT
═══════════════════════════════════

Order Number: O-AC-CAKE-000001
Customer: John Doe

Original Deposit:    R 500.00
Cancellation Fee:    R 100.00
─────────────────────────────────
REFUND AMOUNT:       R 400.00

Payment Method: Cash

Thank you for your understanding.
═══════════════════════════════════
```

### 7. Post-Cancellation

**System Actions**:
- Order status updated to "Cancelled"
- Order removed from active orders view
- Order archived (still visible in "All Orders" with Cancelled status)
- Financial transactions recorded in Demo_Sales
- GL postings updated (if applicable)

**User Actions**:
- Issue refund to customer (Cash/Card/EFT)
- Provide refund receipt to customer
- File cancellation slip for records

## Database Schema Requirements

### New SaleType Values
Add to `Demo_Sales.SaleType` column:
- `'CancellationFee'` - Revenue from order cancellations
- `'OrderRefund'` - Money refunded to customers

### Existing Tables Used
- `POS_CustomOrders` - Order details and status
- `Demo_Sales` - Deposit, cancellation fee, and refund transactions
- `Demo_Retail_Product` - Cancellation fee items
- `Demo_Retail_Price` - Cancellation fee pricing

### Optional: Deleted Orders Archive
```sql
CREATE TABLE POS_DeletedOrders (
    DeletedOrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    OrderNumber VARCHAR(50),
    CustomerName VARCHAR(100),
    DepositAmount DECIMAL(18,2),
    CancellationFee DECIMAL(18,2),
    RefundAmount DECIMAL(18,2),
    RefundMethod VARCHAR(20),
    CancelledBy INT,
    CancelledDate DATETIME,
    Reason VARCHAR(500)
)
```

## UI Integration

### POS Main Form (POSMainForm_REDESIGN.vb)
Add shortcut button similar to Edit Order:

**Location**: Action panel or function keys
**Shortcut Key**: F9 (suggested)
**Button Text**: "Cancel Order"
**Color**: Red (#C00000) to indicate destructive action

**Code**:
```vb
Private Sub btnCancelOrder_Click(sender As Object, e As EventArgs) Handles btnCancelOrder.Click
    Dim cancelForm As New CancelOrderForm()
    cancelForm.ShowDialog(Me)
End Sub
```

### Menu Integration
**Path**: Orders → Cancel Order

## Security & Permissions

### Required Permissions
- User must have "Cancel Orders" permission
- Consider requiring supervisor authentication for cancellations
- Log all cancellations with user ID and timestamp

### Audit Trail
- All cancellations logged in Demo_Sales with cashier ID
- Original order preserved with "Cancelled" status
- Optional: Store cancellation reason

## Error Handling

### Common Errors
1. **Order Not Found**: Display friendly message
2. **Order Already Delivered**: Cannot cancel
3. **Order Already Cancelled**: Prevent duplicate
4. **No Deposit Found**: Cannot process refund
5. **Cancellation Fee > Deposit**: Validation error
6. **Database Transaction Failure**: Rollback all changes

### Error Messages
- User-friendly messages
- No technical jargon
- Clear next steps

## Testing Scenarios

### Test Case 1: Cash Deposit Cancellation
- Create order with R500 cash deposit
- Cancel with R100 cancellation fee
- Verify R400 cash refund
- Verify order status = Cancelled

### Test Case 2: Card Deposit Cancellation
- Create order with R1000 card deposit
- Cancel with R150 cancellation fee
- Verify R850 card refund
- Verify transactions in Demo_Sales

### Test Case 3: Zero Refund
- Create order with R100 deposit
- Cancel with R100 cancellation fee
- Verify R0 refund
- Verify no refund transaction created

### Test Case 4: Validation Tests
- Attempt to cancel delivered order (should fail)
- Attempt to cancel already cancelled order (should fail)
- Attempt cancellation fee > deposit (should fail)

## Future Enhancements

1. **Partial Cancellations**: Cancel individual items, not entire order
2. **Cancellation Reasons**: Dropdown or text field for reason
3. **Email Notification**: Send cancellation confirmation to customer
4. **Refund Approval Workflow**: Require manager approval for large refunds
5. **Analytics**: Track cancellation rates and reasons

## Related Documentation
- Custom Orders Implementation (CUSTOM_ORDERS_IMPLEMENTATION.md)
- Payment Processing (PAYMENT_PROCESSING.md)
- Receipt Printing (RECEIPT_PRINTING.md)
