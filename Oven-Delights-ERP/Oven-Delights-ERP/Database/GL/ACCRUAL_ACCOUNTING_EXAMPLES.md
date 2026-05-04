# ACCRUAL ACCOUNTING SYSTEM - COMPLETE EXAMPLES

## PRINCIPLE: Bank Statement Completes Double-Entry

**All monetary transactions complete their double-entry ONLY when the bank statement confirms the transaction.**

---

## EXAMPLE 1: Electricity Invoice & Payment

### Step 1: Invoice Received (Accrual Entry)
**Date:** 2026-04-01  
**Action:** Electricity company sends invoice for R1,150 (R1,000 + R150 VAT)  
**GL Entry:**
```
DR Electricity Expense (6020)    R1,000
DR VAT Input (2021)              R150
CR Accounts Payable (2010)       R1,150
```
**Result:** 
- Expense recognized
- Liability created (you owe R1,150)
- **Bank account NOT touched** (no payment made yet)

**Procedure:** `EXEC sp_AP_PostInvoiceAccrual @ExpenseAccountCode = '6020', @TotalAmount = 1150`

---

### Step 2: Initiate Payment
**Date:** 2026-04-05  
**Action:** You initiate EFT payment to electricity company  
**GL Entry:** **NONE**  
**Result:** 
- Payment instruction sent to bank
- Waiting for bank confirmation
- **No GL entry made**

---

### Step 3: Bank Statement Confirms Payment
**Date:** 2026-04-06  
**Action:** Bank statement shows debit of R1,150 to electricity company  
**GL Entry:**
```
DR Accounts Payable (2010)       R1,150
CR Bank (1010)                   R1,150
```
**Result:**
- Liability cleared (AP reduced from R1,150 to R0)
- Bank reduced by R1,150
- **DOUBLE-ENTRY NOW COMPLETE**

**Procedure:** `EXEC sp_BankStatement_CompletePayment @TransactionID = 123, @Amount = 1150`

---

### Complete Ledger View After Step 3:

**Electricity Expense (6020):**
- DR R1,000 (expense recognized)

**VAT Input (2021):**
- DR R150 (VAT claimable)

**Accounts Payable (2010):**
- CR R1,150 (liability created)
- DR R1,150 (liability cleared)
- **Balance: R0**

**Bank (1010):**
- CR R1,150 (payment confirmed)

**Total Effect:** Expense R1,000, VAT R150, Bank reduced R1,150 ✓

---

## EXAMPLE 2: Purchase Order, GRV, Invoice & Payment

### Step 1: GRV Received (Goods In)
**Date:** 2026-04-01  
**Action:** Receive 100 units of flour @ R50 each = R5,000  
**GL Entry:**
```
DR Inventory (1220)              R5,000
CR GRIR (2050)                   R5,000
```
**Result:**
- Inventory increased by R5,000
- GRIR liability created (goods received, invoice pending)
- **Bank account NOT touched**

**Procedure:** `EXEC sp_PO_PostGRVAccrual @TotalCost = 5000`

---

### Step 2: Supplier Invoice Received
**Date:** 2026-04-03  
**Action:** Supplier sends invoice for R5,750 (R5,000 + R750 VAT)  
**GL Entry:**
```
DR GRIR (2050)                   R5,000
DR VAT Input (2021)              R750
CR Accounts Payable (2010)       R5,750
```
**Result:**
- GRIR cleared (invoice received)
- AP liability created (you owe R5,750)
- **Bank account NOT touched**

**Procedure:** `EXEC sp_PO_MatchInvoiceToGRV @TotalAmount = 5750`

---

### Step 3: Initiate Payment
**Date:** 2026-04-10  
**Action:** You initiate EFT payment to supplier  
**GL Entry:** **NONE**  
**Result:** Waiting for bank confirmation

---

### Step 4: Bank Statement Confirms Payment
**Date:** 2026-04-11  
**Action:** Bank statement shows debit of R5,750 to supplier  
**GL Entry:**
```
DR Accounts Payable (2010)       R5,750
CR Bank (1010)                   R5,750
```
**Result:**
- AP liability cleared
- Bank reduced by R5,750
- **DOUBLE-ENTRY NOW COMPLETE**

**Procedure:** `EXEC sp_BankStatement_CompletePayment @TransactionID = 124, @Amount = 5750`

---

### Complete Ledger View After Step 4:

**Inventory (1220):**
- DR R5,000 (goods received)

**GRIR (2050):**
- CR R5,000 (goods received, invoice pending)
- DR R5,000 (invoice received, cleared)
- **Balance: R0**

**VAT Input (2021):**
- DR R750 (VAT claimable)

**Accounts Payable (2010):**
- CR R5,750 (invoice received)
- DR R5,750 (payment made)
- **Balance: R0**

**Bank (1010):**
- CR R5,750 (payment confirmed)

**Total Effect:** Inventory +R5,000, VAT +R750, Bank -R5,750 ✓

---

## EXAMPLE 3: Customer Invoice & Receipt (Accounts Receivable)

### Step 1: Customer Invoice Issued
**Date:** 2026-04-01  
**Action:** Issue invoice to customer for R2,300 (R2,000 + R300 VAT)  
**GL Entry:**
```
DR Accounts Receivable (1200)    R2,300
CR Sales Revenue (4010)          R2,000
CR VAT Output (2020)             R300
```
**Result:**
- Asset created (customer owes you R2,300)
- Revenue recognized
- **Bank account NOT touched** (payment not received yet)

**Procedure:** `EXEC sp_AR_PostCustomerInvoice @TotalAmount = 2300`

---

### Step 2: Customer Makes Payment
**Date:** 2026-04-15  
**Action:** Customer initiates EFT payment  
**GL Entry:** **NONE**  
**Result:** Waiting for bank confirmation

---

### Step 3: Bank Statement Confirms Receipt
**Date:** 2026-04-16  
**Action:** Bank statement shows credit of R2,300 from customer  
**GL Entry:**
```
DR Bank (1010)                   R2,300
CR Accounts Receivable (1200)    R2,300
```
**Result:**
- AR asset cleared (customer paid)
- Bank increased by R2,300
- **DOUBLE-ENTRY NOW COMPLETE**

**Procedure:** `EXEC sp_BankStatement_CompleteReceipt @TransactionID = 125, @Amount = 2300`

---

### Complete Ledger View After Step 3:

**Accounts Receivable (1200):**
- DR R2,300 (invoice issued)
- CR R2,300 (payment received)
- **Balance: R0**

**Sales Revenue (4010):**
- CR R2,000 (revenue recognized)

**VAT Output (2020):**
- CR R300 (VAT collected)

**Bank (1010):**
- DR R2,300 (receipt confirmed)

**Total Effect:** Sales +R2,000, VAT +R300, Bank +R2,300 ✓

---

## EXCEPTION: POS Sales (Immediate Settlement)

### POS Card Sale
**Date:** 2026-04-01  
**Action:** Customer pays R115 by card (R100 + R15 VAT)  
**GL Entry (Immediate - Complete Double-Entry):**
```
DR Bank (1010)                   R115
CR Sales Revenue (4010)          R100
CR VAT Output (2020)             R15
DR Cost of Goods Sold (5010)     R60
CR Inventory (1220)              R60
```
**Result:**
- Complete double-entry posted immediately
- Bank account touched immediately (card settlement is instant)

**Procedure:** `EXEC sp_POS_PostSaleToGL @CardAmount = 115`

---

### Bank Statement Reconciliation
**Date:** 2026-04-02  
**Action:** Bank statement shows credit of R115 (card settlement)  
**GL Entry:** **NONE - MATCH ONLY**  
**Result:**
- Bank reconciliation MATCHES existing GL entry
- Marks transaction as reconciled
- **Does NOT create new GL entry** (would be duplicate)

**Procedure:** `EXEC sp_ReconcileBankStatement` (matches existing entry)

---

## BANK STATEMENT DEBIT vs CREDIT

### Understanding Bank Statement Indicators

**Bank Statement shows DEBIT:**
- Money OUT of your bank account
- Your bank balance DECREASES
- **GL Entry:** CR Bank (1010) - credit reduces asset

**Bank Statement shows CREDIT:**
- Money INTO your bank account
- Your bank balance INCREASES
- **GL Entry:** DR Bank (1010) - debit increases asset

### Example: Bank Statement Line

```
Date: 2026-04-06
Description: ELECTRICITY PAYMENT
Reference: ESKOM123
Debit: R1,150
```

**This means:**
- R1,150 went OUT of your bank
- **GL Entry:** CR Bank (1010) R1,150
- **Contra Entry:** DR Accounts Payable (2010) R1,150

---

## SUMMARY OF POSTING RULES

| Transaction Type | Phase 1 (Accrual) | Phase 2 (Bank Confirms) |
|-----------------|-------------------|------------------------|
| **Supplier Invoice** | DR Expense / CR AP | DR AP / CR Bank |
| **Purchase Order** | DR Inventory / CR GRIR → DR GRIR+VAT / CR AP | DR AP / CR Bank |
| **Customer Invoice** | DR AR / CR Sales+VAT | DR Bank / CR AR |
| **POS Sale** | DR Bank / CR Sales+VAT (immediate) | Match only (no new entry) |
| **Bank Fee** | N/A | DR Bank Charges / CR Bank |
| **Interest Earned** | N/A | DR Bank / CR Interest Income |

---

## KEY PRINCIPLES

1. **Operational transactions** create accrual entries (single side of double-entry)
2. **Bank statement** completes the double-entry (touches bank account)
3. **POS sales** are exception - immediate settlement, complete double-entry
4. **Bank reconciliation** matches POS entries, completes accrual entries
5. **Bank account** is ONLY touched when bank statement confirms transaction

---

## WORKFLOW IN YOUR SYSTEM

### For Invoices/Expenses:
1. Receive invoice → Post accrual (DR Expense / CR AP)
2. Initiate payment → No GL entry
3. Bank statement → Complete double-entry (DR AP / CR Bank)

### For Customer Invoices:
1. Issue invoice → Post accrual (DR AR / CR Sales)
2. Customer pays → No GL entry
3. Bank statement → Complete double-entry (DR Bank / CR AR)

### For POS Sales:
1. Sale made → Post complete entry (DR Bank/Cash / CR Sales)
2. Bank statement → Match existing entry (no new entry)

### For Bank Fees/Interest:
1. Bank statement → Post complete entry (DR Expense / CR Bank or DR Bank / CR Income)

---

This system ensures:
- ✅ Bank account only updated when bank confirms
- ✅ Liabilities/receivables tracked accurately
- ✅ No duplicate entries
- ✅ Complete audit trail
- ✅ Proper accrual accounting
