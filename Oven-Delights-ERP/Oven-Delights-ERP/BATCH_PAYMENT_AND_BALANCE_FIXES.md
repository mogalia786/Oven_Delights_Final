# Batch Payment & Bank Statement Balance Fixes

## Overview
Fixed two critical issues identified by the user:
1. **BatchPaymentForm** was missing the BatchPayment checkbox
2. **Bank Statement Balance** information from FNB was not being saved to database

---

## Issue 1: BatchPaymentForm Missing BatchPayment Checkbox

### Problem
The `BatchPaymentForm.vb` submits payments to FNB via `FNBPaymentExecutionService.CreateAndSubmitPaymentBatch()` but was not passing the `batchPayment` parameter, meaning all payments were defaulting to `batchBooking = false`.

### Solution
Added BatchPayment checkbox to `BatchPaymentForm.vb`:

**Changes Made:**
1. Added private field: `Private chkBatchPayment As CheckBox`
2. Initialized checkbox in `BatchPaymentForm_Load`:
   ```vb
   chkBatchPayment = New CheckBox() With {
       .Text = "Batch Payment (Show as 1 line on FNB statement)",
       .Location = New Point(20, 280),
       .Checked = False,  ' Default to False
       .Font = New Font("Segoe UI", 9)
   }
   ```
3. Added tooltip explaining the options
4. Updated payment line creation to include BatchPayment value:
   ```vb
   .BatchPayment = If(chkBatchPayment IsNot Nothing, chkBatchPayment.Checked, False)
   ```

### Result
Both payment forms now support the BatchPayment option:
- ✅ **APPaymentProcessingForm** (already fixed)
- ✅ **BatchPaymentForm** (now fixed)

---

## Issue 2: Bank Statement Balance Not Being Saved

### Problem
FNB statement API returns balance information in the response:
```json
"balance": [
    {
        "typeCode": "OPBD",
        "amountValue": 98491876.59,
        "amountCurrency": "ZAR",
        "creditDebitIndicator": "Credit",
        "date": "2026-04-03"
    },
    {
        "typeCode": "CLBD",
        "amountValue": 98479020.07,
        "amountCurrency": "ZAR",
        "creditDebitIndicator": "Credit",
        "date": "2026-04-04"
    }
]
```

But `FNBStatementService.SaveStatementToDatabase()` was only saving transaction entries, not the balance information.

### Solution

#### 1. Created Database Table
**File:** `Database\CREATE_AP_STATEMENT_BALANCES_TABLE.sql`

**Table Structure:**
```sql
CREATE TABLE AP_StatementBalances (
    BalanceID int IDENTITY(1,1) PRIMARY KEY,
    AccountNumber nvarchar(50) NOT NULL,
    BalanceType nvarchar(10),        -- OPBD, CLBD, etc.
    Amount decimal(18, 2) NOT NULL,
    Currency nvarchar(3) DEFAULT 'ZAR',
    CreditDebitIndicator nvarchar(10), -- Credit or Debit
    BalanceDate date,
    FetchedBy nvarchar(100),
    FetchedDate datetime DEFAULT GETDATE()
)
```

**View for Latest Balances:**
```sql
CREATE VIEW vw_AP_LatestAccountBalances
-- Returns latest opening and closing balance per account
```

#### 2. Updated FNBStatementService.vb
Modified `SaveStatementToDatabase()` method to save balance information:

```vb
' Save balance information if available
If statement.statement.balance IsNot Nothing AndAlso statement.statement.balance.Count > 0 Then
    For Each bal In statement.statement.balance
        ' Insert into AP_StatementBalances table
        ' Log: "Saved balance: OPBD - Credit R98491876.59 on 2026-04-03"
    Next
End If
```

### Balance Types
- **OPBD** = Opening Balance (balance at start of period)
- **CLBD** = Closing Balance (balance at end of period)

### Result
Now when fetching bank statements:
1. ✅ Transaction entries are saved to `AP_StatementTransactions`
2. ✅ Balance information is saved to `AP_StatementBalances`
3. ✅ Log shows: "Saved balance: OPBD - Credit R98491876.59 on 2026-04-03"
4. ✅ Can query latest balances using `vw_AP_LatestAccountBalances` view

---

## How to Use

### For BatchPayment Feature:
1. Open **Accounting > Batch Payment Form**
2. Create batch and add invoices
3. **Check or uncheck** "Batch Payment" checkbox:
   - **UNCHECKED** (default): Each invoice appears separately on FNB statement
   - **CHECKED**: All invoices appear as one total line on FNB statement
4. Click "Submit to FNB"

### For Bank Statement Balances:
1. Open **Accounting > Bank Statement Viewer**
2. Enter account ID and date range
3. Click "Fetch Statement"
4. Balances are automatically saved to database
5. Query balances:
   ```sql
   SELECT * FROM vw_AP_LatestAccountBalances
   WHERE AccountNumber = '63001723469'
   ```

---

## Database Setup Required

**Run this SQL script before using the balance feature:**
```
Database\CREATE_AP_STATEMENT_BALANCES_TABLE.sql
```

This creates:
- `AP_StatementBalances` table
- `vw_AP_LatestAccountBalances` view
- Index for performance

---

## Files Modified

### BatchPayment Checkbox:
1. ✅ `Forms\Accounting\BatchPaymentForm.vb` - Added checkbox and wired to payment lines

### Bank Statement Balance:
1. ✅ `Services\FNBStatementService.vb` - Added balance saving logic
2. ✅ `Database\CREATE_AP_STATEMENT_BALANCES_TABLE.sql` - New database table

### Previously Modified (from earlier fix):
1. ✅ `Services\FNBPaymentExecutionService.vb` - Added BatchPayment property
2. ✅ `Services\APPaymentService.vb` - Updated to use batchPayment parameter
3. ✅ `Forms\Accounting\APPaymentProcessingForm.vb` - Added checkbox

---

## Testing Checklist

### BatchPayment Feature:
- [ ] Open BatchPaymentForm
- [ ] Verify checkbox appears below bank account dropdown
- [ ] Test with checkbox UNCHECKED - verify separate lines on FNB statement
- [ ] Test with checkbox CHECKED - verify single line on FNB statement

### Bank Statement Balance:
- [ ] Run `CREATE_AP_STATEMENT_BALANCES_TABLE.sql`
- [ ] Fetch statement from FNB
- [ ] Verify balances are logged: "Saved balance: OPBD - Credit R..."
- [ ] Query `AP_StatementBalances` table - verify records exist
- [ ] Query `vw_AP_LatestAccountBalances` view - verify opening/closing balances

---

## FNB Response Example

**What FNB Sends:**
```json
{
  "statement": {
    "account": {
      "accountNumber": "63001723469"
    },
    "balance": [
      {"typeCode": "OPBD", "amountValue": 98491876.59, "creditDebitIndicator": "Credit", "date": "2026-04-03"},
      {"typeCode": "CLBD", "amountValue": 98479020.07, "creditDebitIndicator": "Credit", "date": "2026-04-04"}
    ],
    "entry": [
      {"amountValue": 11500.00, "referenceEndToEndId": "INV-20260304220245"},
      {"amountValue": 450.00, "referenceEndToEndId": "T--INV-003"}
    ]
  }
}
```

**What We Now Save:**
- ✅ Balance: OPBD (Opening) = R98,491,876.59 Credit on 2026-04-03
- ✅ Balance: CLBD (Closing) = R98,479,020.07 Credit on 2026-04-04
- ✅ Transaction: R11,500.00 for INV-20260304220245
- ✅ Transaction: R450.00 for T--INV-003

---

## Summary

Both issues are now resolved:
1. ✅ **BatchPaymentForm** has BatchPayment checkbox (defaults to False)
2. ✅ **Bank statement balances** are saved to database with proper logging
3. ✅ View available to query latest account balances
4. ✅ All payment forms now support FNB batch booking configuration

**Status:** Ready for testing with FNB
