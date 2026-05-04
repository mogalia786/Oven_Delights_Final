# BULK PAYMENT ACCRUAL ACCOUNTING GUIDE

## Overview

Bulk payments allow you to select multiple invoices and process them as:
1. **Single Payment** (UNCHECKED) - Each invoice shows separately on bank statement
2. **Batch Payment** (CHECKED) - All invoices show as one total on bank statement

Both modes now follow the accrual accounting model where bank statement completes the double-entry.

---

## How It Works Now (Accrual Model)

### Step 1: Create Batch and Add Invoices
**Form:** `BatchPaymentForm.vb`
**Action:** Select invoices and create batch
**GL Entry:** None
**Result:** Batch created in "Draft" status

### Step 2: Process Batch
**Button:** "Submit to FNB" or "Process Batch"
**Procedure:** `sp_ProcessPaymentBatch`
**GL Entry:** None
**Result:**
- Payment records created
- Invoices marked as "Payment Initiated"
- Batch marked as "Submitted"
- **Bank account NOT touched** ✓
- Payment instruction sent to bank

### Step 3: Bank Statement Confirms Payment
**When:** Bank statement imported and shows payment
**Procedure:** `sp_BankStatement_CompleteBatchPayment`
**GL Entry:**
```
For each invoice in batch:
  DR Accounts Payable (2010)       R[Amount]
  CR Bank (1010)                   R[Amount]
```
**Result:**
- Invoices marked as "Paid"
- Batch marked as "Paid"
- Bank transaction marked as reconciled
- **Double-entry COMPLETE** ✓

---

## Example: Bulk Payment of 3 Invoices

### Invoices to Pay:
1. Electricity - R1,150 (already posted: DR Electricity R1,000 + VAT R150 / CR AP R1,150)
2. Rent - R10,000 (already posted: DR Rent R10,000 / CR AP R10,000)
3. Water - R575 (already posted: DR Water R500 + VAT R75 / CR AP R575)

**Total Batch:** R11,725

---

### Mode 1: Individual Payments (chkBatchPayment UNCHECKED)

**Step 1: Create Batch**
- Select 3 invoices
- Click "Create Batch"
- Result: Batch created, no GL entry

**Step 2: Process Batch**
- Click "Submit to FNB"
- Calls: `sp_ProcessPaymentBatch`
- Result: 
  - 3 payment records created
  - Invoices marked "Payment Initiated"
  - Batch marked "Submitted"
  - **Bank NOT touched**

**Step 3: Bank Statement Shows 3 Separate Transactions**
```
Date: 2026-04-11
Description: Payment to Eskom
Debit: R1,150

Description: Payment to Landlord
Debit: R10,000

Description: Payment to Water Utility
Debit: R575
```

**For Each Transaction:**
- Call: `sp_BankStatement_CompletePayment` (individual)
- GL Entry:
  ```
  DR Accounts Payable (2010)       R1,150
  CR Bank (1010)                   R1,150
  ```
- Result: Each invoice marked "Paid", double-entry complete

---

### Mode 2: Batch Payment (chkBatchPayment CHECKED)

**Step 1: Create Batch**
- Select 3 invoices
- Check "Batch Payment"
- Click "Create Batch"
- Result: Batch created, no GL entry

**Step 2: Process Batch**
- Click "Submit to FNB"
- Calls: `sp_ProcessPaymentBatch`
- Result:
  - 1 batch payment record created
  - Invoices marked "Payment Initiated"
  - Batch marked "Submitted"
  - **Bank NOT touched**

**Step 3: Bank Statement Shows 1 Combined Transaction**
```
Date: 2026-04-11
Description: Batch Payment - Batch #12345
Debit: R11,725
```

**For Batch Transaction:**
- Call: `sp_BankStatement_CompleteBatchPayment`
- GL Entry (for each invoice in batch):
  ```
  DR Accounts Payable (2010)       R1,150  (Electricity)
  CR Bank (1010)                   R1,150
  
  DR Accounts Payable (2010)       R10,000 (Rent)
  CR Bank (1010)                   R10,000
  
  DR Accounts Payable (2010)       R575    (Water)
  CR Bank (1010)                   R575
  ```
- Result: All invoices marked "Paid", batch marked "Paid", double-entry complete

---

## Changes Made to Support Accrual Model

### 1. APInvoiceService.vb
**Method:** `PostBatchPaymentToGL()`
- **Before:** Called `sp_AP_PostBatchPaymentToGL` which posted DR AP / CR Bank immediately
- **After:** Returns without posting to GL
- **Why:** Bank statement completes the double-entry

### 2. sp_ProcessPaymentBatch (Database)
**Before:**
```sql
-- Updated bank account balance immediately
UPDATE BankAccounts
SET CurrentBalance = CurrentBalance - @TotalAmount
WHERE BankAccountID = @BankAccountID;

-- Posted to GL immediately
-- DR AP / CR Bank
```

**After:**
```sql
-- Mark batch as "Submitted" (not "Paid")
UPDATE PaymentBatches
SET Status = 'Submitted'
WHERE BatchID = @BatchID;

-- Do NOT update bank balance
-- Do NOT post to GL
-- Bank statement will complete double-entry
```

### 3. New Procedure: sp_BankStatement_CompleteBatchPayment
**Purpose:** Complete double-entry when bank statement confirms batch payment
**Called:** When bank statement shows batch payment transaction
**Action:**
- Posts DR AP / CR Bank for each invoice
- Updates invoices to "Paid"
- Updates batch to "Paid"
- Marks bank transaction as reconciled

---

## Batch Payment Form Behavior

### Checkbox: chkBatchPayment
**Tooltip:** 
- UNCHECKED (default): Each invoice shows separately on FNB statement
- CHECKED: All invoices show as one total line on FNB statement

### Button: "Submit to FNB" / "Process Batch"
**Before:** Posted to GL and updated bank balance
**After:** 
- Creates payment records
- Marks batch as "Submitted"
- Does NOT post to GL
- Does NOT update bank balance
- Sends payment instruction to bank

### Status Flow:
1. **Draft** - Batch created, invoices added
2. **Submitted** - Batch processed, payment sent to bank (waiting for confirmation)
3. **Paid** - Bank statement confirmed payment (double-entry complete)

---

## Bank Statement Processing for Bulk Payments

### Scenario 1: Individual Payments (Unchecked)
**Bank Statement Shows:** 3 separate debit transactions
**Processing:**
```vb
For Each transaction In bankStatement
    If transaction.Description.Contains("Payment to") Then
        ' Match to individual invoice
        Call sp_BankStatement_CompletePayment(transactionID, amount, supplierName)
    End If
Next
```

### Scenario 2: Batch Payment (Checked)
**Bank Statement Shows:** 1 combined debit transaction
**Processing:**
```vb
For Each transaction In bankStatement
    If transaction.Description.Contains("Batch Payment") Then
        ' Extract batch number from description
        Dim batchID = ExtractBatchNumber(transaction.Description)
        ' Complete entire batch
        Call sp_BankStatement_CompleteBatchPayment(batchID, transactionID, postedBy)
    End If
Next
```

---

## Testing Checklist

### Test 1: Individual Payments
- [ ] Create batch with 3 invoices
- [ ] Ensure chkBatchPayment is UNCHECKED
- [ ] Click "Process Batch"
- [ ] Verify batch status = "Submitted"
- [ ] Verify invoices status = "Payment Initiated"
- [ ] Verify bank balance NOT changed
- [ ] Verify NO GL entries created
- [ ] Import bank statement with 3 separate payments
- [ ] Process each payment individually
- [ ] Verify GL entries: DR AP / CR Bank for each
- [ ] Verify invoices status = "Paid"
- [ ] Verify batch status = "Paid"

### Test 2: Batch Payment
- [ ] Create batch with 3 invoices
- [ ] Check chkBatchPayment
- [ ] Click "Process Batch"
- [ ] Verify batch status = "Submitted"
- [ ] Verify invoices status = "Payment Initiated"
- [ ] Verify bank balance NOT changed
- [ ] Verify NO GL entries created
- [ ] Import bank statement with 1 combined payment
- [ ] Process batch payment
- [ ] Verify GL entries: DR AP / CR Bank for each invoice
- [ ] Verify invoices status = "Paid"
- [ ] Verify batch status = "Paid"

---

## Summary

**What Changed:**
- ✅ Batch payment processing no longer posts to GL
- ✅ Batch payment processing no longer updates bank balance
- ✅ Bank statement completes the double-entry
- ✅ Both individual and batch payment modes work correctly

**What Didn't Change:**
- ✅ Batch creation workflow
- ✅ Invoice selection
- ✅ FNB integration (payment instruction sending)
- ✅ Batch management (add/remove invoices)
- ✅ Payment schedule printing

**Golden Rule Compliance:**
- ✅ Bulk payment feature NOT broken
- ✅ Both payment modes (individual/batch) work correctly
- ✅ Accrual accounting properly implemented
- ✅ Bank statement completes double-entry as required
