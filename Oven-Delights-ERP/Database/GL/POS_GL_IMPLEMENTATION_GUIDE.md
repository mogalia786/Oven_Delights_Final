# POS GL INTEGRATION - COMPLETE IMPLEMENTATION GUIDE

## 📋 OVERVIEW

Complete GL integration for all POS transactions with proper accounting treatment:
- **Cash sales** → Cash on Hand (1030)
- **Card sales** → Bank (1010) 
- **EFT sales** → Debtors - Uncleared EFT (1050)
- **Order deposits** → Customer Deposits Liability (2010)
- **Order collections** → Clear deposit + record sale
- **Refunds** → Sales Returns (4020) + VAT Input (2021)
- **Cash deposits** → Transfer Cash on Hand → Bank
- **EFT clearing** → Transfer Uncleared EFT → Bank

---

## 🗂️ FILES CREATED/MODIFIED

### Database Files:
1. **`10_POS_GL_COMPLETE_INTEGRATION.sql`** - All 6 GL procedures
2. **`11_TEST_POS_GL_PROCEDURES.sql`** - Test scripts for all transaction types
3. **`POS_GL_COMPLETE_DESIGN.md`** - Complete design with journal entry examples
4. **`CHECK_MISSING_ACCOUNTS.sql`** - Verify required GL accounts exist

### POS Code Modified:
1. **`PaymentTenderForm.vb`** (Line 772-805) - Updated to pass @EFTAmount parameter

---

## 🏦 GL ACCOUNTS REQUIRED

| Code | Account Name | Type | Purpose |
|------|-------------|------|---------|
| **1010** | Bank - Current Account | Asset | Card payments, cleared EFTs, deposited cash |
| **1030** | Cash on Hand | Asset | Cash sales (until deposited) |
| **1050** | Debtors - Uncleared EFT | Asset | EFT payments (until bank confirms) |
| **1220** | Inventory - Retail Stock | Asset | Product inventory value |
| **2010** | Customer Deposits | Liability | Order deposits received |
| **2020** | VAT Output (Payable) | Liability | VAT collected on sales |
| **2021** | VAT Input (Receivable) | Asset | VAT paid on refunds |
| **4010** | Sales Revenue - Retail | Revenue | Sales income |
| **4020** | Sales Returns | Contra-Revenue | Refunds |
| **5010** | Cost of Goods Sold | Expense | Cost of products sold |

---

## 📝 STORED PROCEDURES CREATED

### 1. sp_POS_PostSaleToGL
**Purpose:** Post sales to GL with proper Cash/Card/EFT treatment

**Parameters:**
- `@InvoiceNumber` - POS invoice number
- `@SaleDate` - Date of sale
- `@BranchID` - Branch ID
- `@CashierID` - Cashier ID
- `@Subtotal` - Amount excluding VAT
- `@TaxAmount` - VAT amount
- `@TotalAmount` - Total including VAT
- `@CashAmount` - Cash portion (→ 1030)
- `@CardAmount` - Card portion (→ 1010)
- `@EFTAmount` - EFT portion (→ 1050)
- `@TotalCost` - COGS
- `@CreatedBy` - User ID

**Journal Entry Example (R115 cash sale, R60 cost):**
```
DR 1030 Cash on Hand         115.00
CR 4010 Sales Revenue                100.00
CR 2020 VAT Output                    15.00
DR 5010 COGS                  60.00
CR 1220 Inventory                     60.00
```

---

### 2. sp_POS_PostOrderDepositToGL
**Purpose:** Record customer order deposits as liability

**Parameters:**
- `@OrderNumber` - Order number
- `@DepositDate` - Date of deposit
- `@BranchID` - Branch ID
- `@CashierID` - Cashier ID
- `@DepositAmount` - Deposit amount
- `@PaymentMethod` - Cash/Card/EFT
- `@CreatedBy` - User ID

**Journal Entry Example (R200 cash deposit):**
```
DR 1030 Cash on Hand         200.00
CR 2010 Customer Deposits            200.00
```

**Note:** No revenue recognized, no VAT, no inventory movement until order collected.

---

### 3. sp_POS_PostOrderCollectionToGL
**Purpose:** Clear deposit liability and record sale when order collected

**Parameters:**
- `@OrderNumber` - Order number
- `@InvoiceNumber` - Invoice number
- `@CollectionDate` - Date collected
- `@BranchID` - Branch ID
- `@CashierID` - Cashier ID
- `@TotalAmount` - Total order value (incl VAT)
- `@Subtotal` - Excl VAT
- `@TaxAmount` - VAT amount
- `@DepositAmount` - Previously paid deposit
- `@BalanceAmount` - Balance due
- `@BalancePaymentMethod` - How balance paid (Cash/Card/EFT)
- `@TotalCost` - COGS
- `@CreatedBy` - User ID

**Journal Entry Example (R500 total, R200 deposit, R300 card balance, R250 cost):**
```
DR 2010 Customer Deposits    200.00
DR 1010 Bank                 300.00
CR 4010 Sales Revenue                434.78
CR 2020 VAT Output                    65.22
DR 5010 COGS                 250.00
CR 1220 Inventory                    250.00
```

---

### 4. sp_POS_PostRefundToGL
**Purpose:** Reverse sale and return payment

**Parameters:**
- `@ReturnNumber` - Return number
- `@RefundDate` - Date of refund
- `@BranchID` - Branch ID
- `@CashierID` - Cashier ID
- `@Subtotal` - Excl VAT
- `@TaxAmount` - VAT amount
- `@TotalAmount` - Incl VAT
- `@RefundMethod` - Cash or Card
- `@TotalCost` - COGS to reverse
- `@CreatedBy` - User ID

**Journal Entry Example (R115 cash refund, R60 cost):**
```
DR 4020 Sales Returns        100.00
DR 2021 VAT Input             15.00
DR 1220 Inventory             60.00
CR 1030 Cash on Hand                 115.00
CR 5010 COGS                          60.00
```

---

### 5. sp_POS_PostCashDepositToGL
**Purpose:** Transfer Cash on Hand to Bank (end of day deposit)

**Parameters:**
- `@DepositReference` - Deposit reference number
- `@DepositDate` - Date of deposit
- `@BranchID` - Branch ID
- `@DepositAmount` - Amount deposited
- `@CreatedBy` - User ID

**Journal Entry Example (R5000 deposit):**
```
DR 1010 Bank                5,000.00
CR 1030 Cash on Hand                5,000.00
```

---

### 6. sp_POS_PostEFTClearingToGL
**Purpose:** Transfer Uncleared EFT to Bank (when bank confirms)

**Parameters:**
- `@ClearingReference` - Clearing reference
- `@ClearingDate` - Date cleared
- `@BranchID` - Branch ID
- `@ClearingAmount` - Amount cleared
- `@CreatedBy` - User ID

**Journal Entry Example (R2300 cleared):**
```
DR 1010 Bank                2,300.00
CR 1050 Debtors (Uncleared EFT)     2,300.00
```

---

## 🚀 DEPLOYMENT STEPS

### Step 1: Run Diagnostic
```sql
:r "Database\GL\TOMORROW_DIAGNOSTIC_PLAN.sql"
```
This checks current state and identifies issues.

---

### Step 2: Create Missing GL Accounts
```sql
:r "Database\GL\CHECK_MISSING_ACCOUNTS.sql"
```
This shows which accounts need to be created and provides SQL to create them.

---

### Step 3: Deploy GL Procedures
```sql
:r "Database\GL\10_POS_GL_COMPLETE_INTEGRATION.sql"
```
This creates all 6 GL procedures with proper accounting treatment.

---

### Step 4: Test Procedures
```sql
:r "Database\GL\11_TEST_POS_GL_PROCEDURES.sql"
```
This tests all transaction types and shows journal entries.

---

### Step 5: Rebuild POS
1. Open POS solution in Visual Studio
2. Build → Rebuild Solution
3. Deploy to POS terminals
4. Verify `PaymentTenderForm.vb` has updated GL posting code (line 772-805)

---

### Step 6: Test Real Transactions

**Test 1: Cash Sale**
1. Do a small cash sale (e.g., R10)
2. Note invoice number (e.g., 620062)
3. Check GL journal:
```sql
SELECT jh.JournalNumber, coa.AccountCode, coa.AccountName, jd.Debit, jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber = 'POS-620062'
ORDER BY jd.LineNumber
```

**Test 2: Card Sale**
1. Do a card sale
2. Verify journal shows Bank (1010) debit

**Test 3: EFT Sale**
1. Do an EFT sale
2. Verify journal shows Debtors - Uncleared EFT (1050) debit

**Test 4: Order Deposit**
1. Create customer order with deposit
2. Verify journal shows Customer Deposits (2010) credit

**Test 5: Order Collection**
1. Collect order
2. Verify journal clears deposit and records sale

**Test 6: Refund**
1. Process refund
2. Verify journal shows Sales Returns (4020) and VAT Input (2021)

---

## 📊 VERIFYING GL INTEGRATION

### Check GL Inquiry
1. Open ERP → Accounting → GL Inquiry
2. Select account **4010** (Sales Revenue)
3. Set date range to include today
4. Click Search
5. Should see POS sales with journal numbers like "POS-620062"

### Check Account Balances
```sql
SELECT 
    coa.AccountCode,
    coa.AccountName,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Balance
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE coa.AccountCode IN ('1010', '1030', '1050', '4010', '2020', '5010', '1220')
    AND jh.JournalNumber LIKE 'POS-%'
GROUP BY coa.AccountCode, coa.AccountName
ORDER BY coa.AccountCode
```

### Expected Balances After Sales:
- **1030 (Cash on Hand)**: Positive (Debit balance) - Cash received
- **1010 (Bank)**: Positive (Debit balance) - Card payments
- **1050 (Debtors - EFT)**: Positive (Debit balance) - Pending EFTs
- **4010 (Sales Revenue)**: Negative (Credit balance) - Revenue earned
- **2020 (VAT Output)**: Negative (Credit balance) - VAT owed to SARS
- **5010 (COGS)**: Positive (Debit balance) - Cost of sales
- **1220 (Inventory)**: Negative (Credit balance) - Stock reduction

---

## 🔄 ONGOING OPERATIONS

### Daily Cash Deposit
When depositing cash to bank:
```sql
EXEC sp_POS_PostCashDepositToGL
    @DepositReference = '20260128-001',
    @DepositDate = '2026-01-28',
    @BranchID = 2,
    @DepositAmount = 5000.00,
    @CreatedBy = 1
```

### EFT Clearing
When bank confirms EFT received:
```sql
EXEC sp_POS_PostEFTClearingToGL
    @ClearingReference = '20260128-EFT-001',
    @ClearingDate = '2026-01-28',
    @BranchID = 2,
    @ClearingAmount = 2300.00,
    @CreatedBy = 1
```

---

## ✅ BENEFITS

1. **Accurate Cash Flow** - Know exactly how much cash vs bank balance
2. **EFT Tracking** - See pending EFTs vs cleared funds
3. **Proper VAT** - Separate VAT Output (sales) from VAT Input (refunds)
4. **Inventory Control** - Real-time COGS and inventory valuation
5. **Deposit Management** - Track customer deposits as liabilities
6. **Audit Trail** - Every transaction has complete double-entry journal
7. **Financial Reporting** - Accurate P&L and Balance Sheet

---

## 🐛 TROUBLESHOOTING

### Issue: No GL journals created
**Solution:** 
1. Check if procedures deployed: Run `CHECK_MISSING_ACCOUNTS.sql`
2. Check if POS rebuilt: Verify `PaymentTenderForm.vb` line 772-805
3. Check for errors: Look for error popup after sale

### Issue: GL posting error popup
**Solution:**
1. Note exact error message
2. Check if fiscal period function exists
3. Check if all GL accounts exist
4. Run manual test: `11_TEST_POS_GL_PROCEDURES.sql`

### Issue: Wrong account balances
**Solution:**
1. Verify journal entries are correct
2. Check if COGS calculation is working
3. Review `POS_GL_COMPLETE_DESIGN.md` for expected journal format

### Issue: EFT showing as Card
**Solution:**
1. Verify POS code updated (line 780-783)
2. Check if @EFTAmount parameter passed correctly
3. Rebuild POS application

---

## 📞 SUPPORT

If issues persist after following this guide:
1. Run `TOMORROW_DIAGNOSTIC_PLAN.sql` and share output
2. Share error message from POS (if any)
3. Share screenshot of GL Inquiry showing no results
4. Share journal details query results

---

## 🎯 NEXT PHASE (Future Enhancement)

### Phase 1: UI for Banking Operations
- Cash Deposit Entry Form (ERP)
- EFT Clearing Entry Form (ERP)
- Bank Reconciliation Report

### Phase 2: Advanced Features
- Multi-currency support
- Credit note handling
- Layby/payment plan integration
- Gift voucher GL posting

### Phase 3: Reporting
- Daily Cash-Up Report with GL reconciliation
- VAT Return Report (Output vs Input)
- Cash Flow Statement
- Inventory Valuation Report

---

**Implementation Date:** January 28, 2026
**Version:** 1.0
**Status:** Ready for Deployment
