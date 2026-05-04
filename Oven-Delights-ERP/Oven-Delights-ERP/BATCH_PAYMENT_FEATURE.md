# FNB Batch Payment Feature Implementation

## Overview
Added support for FNB's `batchBooking` parameter to control how payments appear on bank statements.

## FNB Requirement
As per FNB's email from Tshepo Kgasoane (Implementation Manager):
- **batchBooking = false** (default): Each invoice shows as a separate line on the FNB statement
- **batchBooking = true**: All invoices in the batch show as one total line on the FNB statement

## Changes Made

### 1. **PaymentLineInfo Class** (`FNBPaymentExecutionService.vb`)
Added `BatchPayment` property:
```vb
Public Property BatchPayment As Boolean = False ' False = show each invoice separately on statement, True = show total as one line
```

### 2. **FNBPaymentExecutionService.vb**
Updated `BuildPaymentRequest` method to use the `BatchPayment` value from payment lines:
```vb
' Use BatchPayment setting from first payment line (all lines in batch should have same setting)
Dim batchBookingSetting As Boolean = If(paymentLines.Count > 0, paymentLines(0).BatchPayment, False)

Dim paymentInfo As New PaymentInformation() With {
    .batchBooking = batchBookingSetting,
    ' ... other properties
}
```

### 3. **APPaymentService.vb**
- Updated `SubmitPaymentBatchToFNB` method signature to accept `batchPayment` parameter
- Updated `BuildFNBPaymentRequest` method to accept and use `batchPayment` parameter
- Changed hardcoded `batchBooking = False` to use the parameter value

### 4. **APPaymentProcessingForm.vb** (UI)
Added checkbox control to the toolbar:
```vb
chkBatchPayment = New CheckBox() With {
    .Text = "Batch Payment (Show as 1 line on statement)",
    .Location = New Point(1130, 20),
    .Checked = False,  ' Default to False
    .Font = New Font("Segoe UI", 9)
}
```

Added tooltip:
```
UNCHECKED (default): Each invoice shows separately on FNB statement
CHECKED: All invoices show as one total line on FNB statement
```

Updated both submission paths to pass the checkbox value:
- Existing batch submission: `_paymentService.SubmitPaymentBatchToFNB(_currentBatchId.Value, dtpPaymentDate.Value, chkBatchPayment.Checked)`
- New batch submission: `_paymentService.SubmitPaymentBatchToFNB(_currentBatchId.Value, dtpPaymentDate.Value, chkBatchPayment.Checked)`

## How to Use

1. **Open Accounts Payable Payment Processing Form**
2. **Select invoices** to pay
3. **Set Payment Date** using the date picker
4. **Choose Batch Payment Option:**
   - **Leave UNCHECKED** (default): Each invoice will appear as a separate transaction on your FNB statement
   - **CHECK the box**: All invoices will appear as ONE total line on your FNB statement
5. **Click "Submit Payment Batch"**

## Testing with FNB

To test both scenarios as requested by FNB:

### Test 1: Batch Payment = FALSE
1. Select multiple invoices (e.g., INV-003, TP-INV004, TP-INV5)
2. Leave "Batch Payment" checkbox **UNCHECKED**
3. Submit batch
4. Check FNB statement - should see separate lines for each invoice

### Test 2: Batch Payment = TRUE
1. Select multiple invoices
2. **CHECK** the "Batch Payment" checkbox
3. Submit batch
4. Check FNB statement - should see ONE line with total amount

## FNB Statement Example (from email)

**With batchBooking = false** (separate lines):
```json
{
  "entry": [
    {"amountValue": 11500.00, "referenceEndToEndId": "INV-20260304220245"},
    {"amountValue": 450.00, "referenceEndToEndId": "T--INV-003"},
    {"amountValue": 477.02, "referenceEndToEndId": "TP-INV004"},
    {"amountValue": 429.50, "referenceEndToEndId": "TP-INV5"}
  ]
}
```

**With batchBooking = true** (single line):
```json
{
  "entry": [
    {"amountValue": 12856.52, "referenceEndToEndId": "BATCH-12345"}
  ]
}
```

## Files Modified
1. `Services\FNBPaymentExecutionService.vb` - Added BatchPayment property and logic
2. `Services\APPaymentService.vb` - Updated methods to accept and use batchPayment parameter
3. `Forms\Accounting\APPaymentProcessingForm.vb` - Added UI checkbox and wired up to service calls

## Default Behavior
- **Default is FALSE** (unchecked) - Each invoice shows separately
- This matches the current behavior and is the safer default
- Users can opt-in to batch booking by checking the box

## Notes
- All invoices in a batch use the same batchBooking setting
- The setting is taken from the first payment line in the batch
- The checkbox value is passed when submitting the payment to FNB
