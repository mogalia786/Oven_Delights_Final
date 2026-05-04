# ACCRUAL ACCOUNTING IMPLEMENTATION GUIDE

## YOUR ACCOUNTING MODEL - CONFIRMED

**Bank Statement = Source of Truth for Monetary Transactions**

All payments and receipts complete their double-entry ONLY when the bank statement confirms the transaction.

---

## WHAT TO KEEP (Working Correctly)

### ✅ POS Procedures - KEEP AS-IS
**Reason:** POS sales are immediate settlement (cash/card) - complete double-entry posted immediately

**Procedures to KEEP:**
- `sp_POS_PostSaleToGL` - Posts complete entry: DR Bank/Cash / CR Sales+VAT
- `sp_POS_PostOrderDepositToGL` - Posts deposit: DR Bank/Cash / CR Customer Deposits
- `sp_POS_PostOrderCollectionToGL` - Posts completion: DR Customer Deposits+Bank/Cash / CR Sales+VAT
- `sp_POS_PostRefundToGL` - Posts refund: DR Sales Returns+VAT / CR Bank/Cash
- `sp_POS_PostCashDepositToGL` - Posts transfer: DR Bank / CR Cash
- `sp_POS_PostEFTClearingToGL` - Posts clearing: DR Bank / CR EFT Debtors

**Bank Reconciliation for POS:**
- Bank statement MATCHES existing POS entries
- Does NOT create new entries (would be duplicates)
- Only marks as reconciled

---

## WHAT TO REPLACE (Accrual Model)

### ❌ REPLACE: Old Supplier Payment Procedures

**Old Model (WRONG for your system):**
```sql
sp_AP_PostSinglePaymentToGL
-- Posted: DR AP / CR Bank immediately
-- Problem: Bank touched before bank statement confirms
```

**New Model (CORRECT for your system):**
```sql
-- Step 1: Invoice received
sp_AP_PostInvoiceAccrual
-- Posts: DR Expense+VAT / CR AP (bank NOT touched)

-- Step 2: Bank statement confirms payment
sp_BankStatement_CompletePayment
-- Posts: DR AP / CR Bank (completes double-entry)
```

---

### ❌ REPLACE: Old Purchase Order Procedures

**Old Model (WRONG for your system):**
```sql
sp_PO_PostInvoiceToGL
-- Posted: DR GRIR+VAT / CR AP
-- Then sp_AP_PostSinglePaymentToGL touched bank immediately
```

**New Model (CORRECT for your system):**
```sql
-- Step 1: GRV received
sp_PO_PostGRVAccrual
-- Posts: DR Inventory / CR GRIR (bank NOT touched)

-- Step 2: Invoice matched
sp_PO_MatchInvoiceToGRV
-- Posts: DR GRIR+VAT / CR AP (bank NOT touched)

-- Step 3: Bank statement confirms payment
sp_BankStatement_CompletePayment
-- Posts: DR AP / CR Bank (completes double-entry)
```

---

## DEPLOYMENT STEPS

### Step 1: Run Accrual System Script
```sql
-- This creates the new accrual procedures
EXEC [path]\ACCRUAL_ACCOUNTING_SYSTEM.sql
```

**Creates:**
- `sp_AP_PostInvoiceAccrual` - Post invoice without touching bank
- `sp_PO_PostGRVAccrual` - Post GRV without touching bank
- `sp_PO_MatchInvoiceToGRV` - Match invoice to GRV
- `sp_BankStatement_CompletePayment` - Complete payment when bank confirms
- `sp_BankStatement_CompleteReceipt` - Complete receipt when bank confirms

---

### Step 2: Run Bank Reconciliation Solution
```sql
-- This adds IsMapped column and matching logic
EXEC [path]\BANK_RECONCILIATION_SOLUTION.sql
```

**Creates:**
- `sp_ReconcileBankStatement` - Match bank to existing GL entries
- `sp_PostUnmatchedBankItems` - Post bank fees, interest
- `sp_AutoMapBankTransactions` - Mark transactions ready for reconciliation

---

### Step 3: Keep Existing POS Procedures
**DO NOT RUN** any scripts that drop/replace POS procedures. They are working correctly.

**Existing POS procedures remain unchanged:**
- `10_POS_GL_COMPLETE_INTEGRATION.sql` - Already deployed, keep as-is

---

### Step 4: Update Application Code

**For Supplier Invoices (Electricity, Rent, etc.):**
```vb
' OLD CODE (remove):
' Call sp_AP_PostSinglePaymentToGL when payment initiated

' NEW CODE:
' When invoice received:
Call sp_AP_PostInvoiceAccrual(invoiceID, expenseAccountCode, totalAmount)

' When bank statement processed:
Call sp_BankStatement_CompletePayment(transactionID, amount, supplierName)
```

**For Purchase Orders:**
```vb
' When GRV received:
Call sp_PO_PostGRVAccrual(grvID, totalCost)

' When invoice matched:
Call sp_PO_MatchInvoiceToGRV(invoiceID, totalAmount)

' When bank statement processed:
Call sp_BankStatement_CompletePayment(transactionID, amount, supplierName)
```

**For POS Sales (NO CHANGE):**
```vb
' Keep existing code - works correctly
Call sp_POS_PostSaleToGL(invoiceNumber, cashAmount, cardAmount, eftAmount)
```

**For Bank Statement Processing:**
```vb
' Step 1: Auto-map
Call sp_AutoMapBankTransactions()

' Step 2: Reconcile (match to existing entries)
Call sp_ReconcileBankStatement(postedBy)

' Step 3: For unmatched items (fees, interest):
Call sp_PostUnmatchedBankItems(transactionID, postedBy)

' Step 4: For matched payments/receipts that need completion:
If transactionType = "Payment to Supplier" Then
    Call sp_BankStatement_CompletePayment(transactionID, amount, supplierName)
ElseIf transactionType = "Receipt from Customer" Then
    Call sp_BankStatement_CompleteReceipt(transactionID, amount, customerName)
End If
```

---

## TRANSACTION FLOWS

### Flow 1: Electricity Invoice & Payment

**User Actions:**
1. Receive electricity invoice for R1,150
2. Capture invoice in system
3. Initiate EFT payment
4. Import bank statement

**System GL Postings:**

**Action 1: Capture Invoice**
```vb
Call sp_AP_PostInvoiceAccrual(
    @ExpenseAccountCode = "6020",  ' Electricity
    @SubtotalAmount = 1000,
    @VATAmount = 150,
    @TotalAmount = 1150
)
```
**GL Entry:**
```
DR Electricity Expense (6020)    R1,000
DR VAT Input (2021)              R150
CR Accounts Payable (2010)       R1,150
```
**Bank Balance:** No change (bank NOT touched)

**Action 2: Initiate Payment**
- No GL entry
- Payment instruction sent to bank

**Action 3: Process Bank Statement**
```vb
' Bank statement shows: DEBIT R1,150 to Eskom
Call sp_BankStatement_CompletePayment(
    @TransactionID = 123,
    @Amount = 1150,
    @SupplierName = "Eskom"
)
```
**GL Entry:**
```
DR Accounts Payable (2010)       R1,150
CR Bank (1010)                   R1,150
```
**Bank Balance:** Reduced by R1,150 (DOUBLE-ENTRY COMPLETE)

---

### Flow 2: Purchase Order & Payment

**User Actions:**
1. Create PO for 100 units flour @ R50 = R5,000
2. Receive goods (GRV)
3. Receive supplier invoice R5,750 (incl VAT)
4. Match invoice to GRV
5. Initiate payment
6. Import bank statement

**System GL Postings:**

**Action 1: Receive Goods (GRV)**
```vb
Call sp_PO_PostGRVAccrual(
    @GRVNumber = "GRV001",
    @TotalCost = 5000
)
```
**GL Entry:**
```
DR Inventory (1220)              R5,000
CR GRIR (2050)                   R5,000
```
**Bank Balance:** No change

**Action 2: Match Invoice to GRV**
```vb
Call sp_PO_MatchInvoiceToGRV(
    @InvoiceNumber = "INV123",
    @SubtotalAmount = 5000,
    @VATAmount = 750,
    @TotalAmount = 5750
)
```
**GL Entry:**
```
DR GRIR (2050)                   R5,000
DR VAT Input (2021)              R750
CR Accounts Payable (2010)       R5,750
```
**Bank Balance:** No change

**Action 3: Process Bank Statement**
```vb
' Bank statement shows: DEBIT R5,750 to supplier
Call sp_BankStatement_CompletePayment(
    @TransactionID = 124,
    @Amount = 5750,
    @SupplierName = "Flour Supplier"
)
```
**GL Entry:**
```
DR Accounts Payable (2010)       R5,750
CR Bank (1010)                   R5,750
```
**Bank Balance:** Reduced by R5,750 (DOUBLE-ENTRY COMPLETE)

---

### Flow 3: POS Card Sale (Exception - Immediate Settlement)

**User Actions:**
1. Customer pays R115 by card
2. Import bank statement

**System GL Postings:**

**Action 1: POS Sale**
```vb
Call sp_POS_PostSaleToGL(
    @CardAmount = 115,
    @Subtotal = 100,
    @TaxAmount = 15,
    @TotalCost = 60
)
```
**GL Entry (Complete Double-Entry Immediately):**
```
DR Bank (1010)                   R115
CR Sales Revenue (4010)          R100
CR VAT Output (2020)             R15
DR Cost of Goods Sold (5010)     R60
CR Inventory (1220)              R60
```
**Bank Balance:** Increased by R115 (immediate)

**Action 2: Process Bank Statement**
```vb
Call sp_ReconcileBankStatement()
```
**GL Entry:** NONE (matches existing entry)
**Result:** Transaction marked as reconciled

---

## BANK STATEMENT PROCESSING LOGIC

### When Bank Statement Shows DEBIT (Money Out)

**Check 1: Is this a POS refund?**
- Match to existing `sp_POS_PostRefundToGL` entry
- Mark as reconciled
- No new GL entry

**Check 2: Is this a supplier payment?**
- Look for matching AP liability
- Call `sp_BankStatement_CompletePayment`
- Posts: DR AP / CR Bank

**Check 3: Is this a bank fee/charge?**
- No matching entry found
- Call `sp_PostUnmatchedBankItems`
- Posts: DR Bank Charges / CR Bank

---

### When Bank Statement Shows CREDIT (Money In)

**Check 1: Is this a POS sale?**
- Match to existing `sp_POS_PostSaleToGL` entry
- Mark as reconciled
- No new GL entry

**Check 2: Is this a customer payment?**
- Look for matching AR asset
- Call `sp_BankStatement_CompleteReceipt`
- Posts: DR Bank / CR AR

**Check 3: Is this interest earned?**
- No matching entry found
- Call `sp_PostUnmatchedBankItems`
- Posts: DR Bank / CR Interest Income

**Check 4: Is this a cash deposit?**
- Match to existing `sp_POS_PostCashDepositToGL` entry
- Mark as reconciled
- No new GL entry

---

## CRITICAL ACCOUNTS

Ensure these accounts exist in ChartOfAccounts:

| Code | Name | Type | Usage |
|------|------|------|-------|
| 1010 | Bank Account | Asset | All bank transactions |
| 1030 | Cash on Hand | Asset | POS cash sales |
| 1050 | Debtors - Uncleared EFT | Asset | POS EFT sales pending |
| 1200 | Accounts Receivable | Asset | Customer invoices |
| 1220 | Inventory | Asset | Stock on hand |
| 2010 | Accounts Payable | Liability | Supplier invoices |
| 2020 | VAT Output | Liability | VAT collected |
| 2021 | VAT Input | Asset | VAT claimable |
| 2050 | GRIR | Liability | Goods received, invoice pending |
| 4010 | Sales Revenue | Revenue | Sales income |
| 4300 | Interest Income | Revenue | Bank interest |
| 5010 | Cost of Goods Sold | Expense | COGS |
| 6010 | Rent Expense | Expense | Rent payments |
| 6020 | Utilities Expense | Expense | Electricity, water |
| 6030 | Salaries & Wages | Expense | Staff costs |
| 6080 | Bank Charges | Expense | Bank fees |

---

## TESTING CHECKLIST

### Test 1: Electricity Invoice
- [ ] Capture invoice - verify AP increased, bank unchanged
- [ ] Process bank statement - verify AP cleared, bank reduced
- [ ] Check GL: Expense DR, VAT DR, AP CR/DR balanced, Bank CR

### Test 2: Purchase Order
- [ ] Receive GRV - verify Inventory increased, GRIR increased, bank unchanged
- [ ] Match invoice - verify GRIR cleared, AP increased, bank unchanged
- [ ] Process bank statement - verify AP cleared, bank reduced
- [ ] Check GL: Inventory DR, VAT DR, GRIR CR/DR balanced, AP CR/DR balanced, Bank CR

### Test 3: POS Card Sale
- [ ] Make sale - verify Bank increased, Sales increased immediately
- [ ] Process bank statement - verify transaction matched (no new entry)
- [ ] Check GL: Bank DR, Sales CR, COGS DR, Inventory CR

### Test 4: Bank Fee
- [ ] Process bank statement - verify Bank Charges increased, Bank reduced
- [ ] Check GL: Bank Charges DR, Bank CR

---

## SUMMARY

**Your System Now Works Like This:**

1. **Operational Transactions** (invoices, GRVs) → Create accruals (bank NOT touched)
2. **Bank Statement** → Completes double-entry (bank touched)
3. **POS Sales** → Exception (immediate settlement, complete double-entry)
4. **Bank Reconciliation** → Matches POS entries, completes accrual entries

**Bank Account (1010) is ONLY updated when:**
- POS sale/refund (immediate settlement)
- Bank statement confirms payment/receipt
- Bank fee/interest appears on statement

**This ensures:**
- ✅ Bank balance always matches bank statement
- ✅ Liabilities/receivables tracked accurately
- ✅ No duplicate entries
- ✅ Complete audit trail
- ✅ Proper accrual accounting
