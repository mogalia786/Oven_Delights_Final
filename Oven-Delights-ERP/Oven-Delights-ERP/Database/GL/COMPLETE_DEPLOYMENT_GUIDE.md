# COMPLETE GL INTEGRATION DEPLOYMENT GUIDE
## Systematic Implementation with Testing & Verification

**Date:** January 28, 2026  
**Objective:** Deploy complete GL integration across all ERP modules with proper double-entry accounting

---

## 📋 PRE-DEPLOYMENT CHECKLIST

Before starting deployment, ensure:
- [ ] Database backup completed
- [ ] All users logged out of ERP system
- [ ] SQL Server Management Studio open and connected
- [ ] This guide printed or available on second screen

---

## 🚀 PHASE 1: CREATE MISSING GL ACCOUNTS

### Step 1.1: Run Account Creation Script

**File:** `PHASE1_CREATE_MISSING_ACCOUNTS.sql`

**What it does:**
- Creates account 1050 (Debtors - Uncleared EFT)
- Creates account 2030 (Accounts Payable - Trade Creditors)
- Creates account 5020 (Direct Labor)
- Creates accounts 6010-6070 (Various expenses)

**Execute:**
```sql
-- Open and run: PHASE1_CREATE_MISSING_ACCOUNTS.sql
```

**Expected Output:**
```
✓ Created 1050 - Debtors (Uncleared EFT)
✓ Created 2030 - Accounts Payable (Trade Creditors)
✓ Created 5020 - Direct Labor
✓ Created 6010 - Rent Expense
✓ Created 6020 - Utilities Expense
✓ Created 6030 - Telephone & Internet
✓ Created 6040 - Office Supplies
✓ Created 6050 - Inventory Variance
✓ Created 6060 - Wastage Expense
✓ Created 6070 - Manufacturing Overhead
```

**Verification:**
- Check that all accounts appear in the output table
- Verify all accounts show as "Active"

---

## 🔧 PHASE 2: FIX ACCOUNTS PAYABLE (CRITICAL)

### Step 2.1: Update AP Procedures to Use Account 2030

**File:** `PHASE1_2_FIX_AP_ACCOUNT_2030.sql`

**What it does:**
- Drops old AP procedures that used account 2010
- Recreates all 4 AP procedures to use account 2030
- Separates Customer Deposits (2010) from Accounts Payable (2030)

**Execute:**
```sql
-- Open and run: PHASE1_2_FIX_AP_ACCOUNT_2030.sql
```

**Expected Output:**
```
✓ Dropped old AP procedures
✓ Created sp_AP_PostAdhocInvoiceToGL (using 2030)
✓ Created sp_AP_PostSinglePaymentToGL (using 2030)
✓ Created sp_AP_PostBatchPaymentToGL (using 2030)
✓ Created sp_AP_PostCreditNoteToGL (using 2030)
```

**Verification:**
- All 4 procedures should be created successfully
- No errors should appear

---

### Step 2.2: Test AP Workflow

**File:** `PHASE1_3_TEST_AP_WORKFLOW.sql`

**What it does:**
- Creates test adhoc invoices (Rent, Utilities)
- Creates test payment
- Creates test credit note
- Verifies double-entry accounting (Debits = Credits)
- Confirms account 2010 has NO AP transactions
- Confirms account 2030 has AP transactions

**Execute:**
```sql
-- Open and run: PHASE1_3_TEST_AP_WORKFLOW.sql
```

**Expected Output:**
```
TEST 1: Adhoc Invoice - Rent Expense
✓ BALANCED

TEST 2: Adhoc Invoice - Utilities
✓ BALANCED

TEST 3: Single Payment - EFT
✓ BALANCED

TEST 4: Credit Note - Utilities Reversal
✓ BALANCED

✓ CORRECT: Account 2010 has no AP transactions
✓ CORRECT: Account 2030 has AP transactions
✓ Trial Balance is BALANCED
```

**Verification:**
- All 4 tests should show "✓ BALANCED"
- Account 2010 should have NO AP transactions
- Account 2030 should have AP transactions
- Trial balance should be balanced

**If any test fails:**
- Do NOT proceed to next phase
- Review error messages
- Check that accounts were created correctly
- Re-run PHASE1_2 if needed

---

## 💳 PHASE 3: EFT CLEARING FUNCTIONALITY

### Step 3.1: Create EFT Clearing Procedures

**File:** `PHASE2_1_EFT_CLEARING_PROCEDURES.sql`

**What it does:**
- Creates `sp_AP_PostEFTClearingToGL` for AP EFT clearing
- Creates `sp_EFT_GetUnclearedTransactions` to view pending EFTs
- Creates `sp_EFT_GetClearingHistory` to view cleared EFTs

**Execute:**
```sql
-- Open and run: PHASE2_1_EFT_CLEARING_PROCEDURES.sql
```

**Expected Output:**
```
✓ Created sp_AP_PostEFTClearingToGL
✓ Created sp_EFT_GetUnclearedTransactions
✓ Created sp_EFT_GetClearingHistory
```

**Verification:**
- All 3 procedures created successfully
- No errors

---

### Step 3.2: Add EFT Clearing Form to ERP

**File:** `Forms\Accounting\EFTClearingForm.vb`

**What it does:**
- Provides UI to view uncleared EFTs (POS and AP)
- Allows marking EFTs as cleared
- Shows clearing history
- Posts GL entries when EFTs are cleared

**Manual Steps:**
1. Open Visual Studio
2. Right-click on `Forms\Accounting` folder
3. Add → Existing Item
4. Select `EFTClearingForm.vb`
5. Rebuild solution

**Add to Main Menu:**
```vb
' In MainForm.vb or AccountingMenuForm.vb
Private Sub btnEFTClearing_Click(sender As Object, e As EventArgs)
    Dim form As New EFTClearingForm()
    form.ShowDialog()
End Sub
```

**Test:**
1. Run ERP application
2. Navigate to Accounting → EFT Clearing
3. Form should open without errors
4. Should show "No uncleared EFTs" (if none exist)

---

## 📦 PHASE 4: INVENTORY GL INTEGRATION

### Step 4.1: Create Inventory GL Procedures

**File:** `PHASE3_INVENTORY_GL_INTEGRATION.sql`

**What it does:**
- Creates `sp_Inventory_PostAdjustmentToGL` for stock adjustments
- Creates `sp_Inventory_PostWastageToGL` for wastage

**Execute:**
```sql
-- Open and run: PHASE3_INVENTORY_GL_INTEGRATION.sql
```

**Expected Output:**
```
✓ Created sp_Inventory_PostAdjustmentToGL
✓ Created sp_Inventory_PostWastageToGL
```

**Journal Entry Examples Shown:**
```
Stock Increase:
  DR 1220 Inventory           R500
  CR 6050 Inventory Variance       R500

Stock Decrease:
  DR 6050 Inventory Variance  R500
  CR 1220 Inventory                R500

Wastage:
  DR 6060 Wastage Expense     R300
  CR 1220 Inventory                R300
```

---

### Step 4.2: Update Inventory Forms (Manual)

**Forms to Update:**
1. Stock Adjustment Form
2. Wastage Form
3. Stock Take Form

**Add GL Posting Calls:**
```vb
' In Stock Adjustment Form - After saving adjustment
Using conn As New SqlConnection(_connString)
    conn.Open()
    Using cmd As New SqlCommand("sp_Inventory_PostAdjustmentToGL", conn)
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Parameters.AddWithValue("@AdjustmentID", adjustmentID)
        cmd.Parameters.AddWithValue("@AdjustmentNumber", adjustmentNumber)
        cmd.Parameters.AddWithValue("@AdjustmentDate", DateTime.Today)
        cmd.Parameters.AddWithValue("@BranchID", _currentBranchID)
        cmd.Parameters.AddWithValue("@ProductID", productID)
        cmd.Parameters.AddWithValue("@ProductName", productName)
        cmd.Parameters.AddWithValue("@AdjustmentType", "Increase") ' or "Decrease"
        cmd.Parameters.AddWithValue("@Quantity", quantity)
        cmd.Parameters.AddWithValue("@UnitCost", unitCost)
        cmd.Parameters.AddWithValue("@TotalValue", totalValue)
        cmd.Parameters.AddWithValue("@Reason", reason)
        cmd.Parameters.AddWithValue("@CreatedBy", _currentUserID)
        cmd.ExecuteNonQuery()
    End Using
End Using
```

---

## 📊 PHASE 5: DAILY POSTING REPORT

### Step 5.1: Create Reporting Procedures

**File:** `PHASE4_DAILY_POSTING_REPORT.sql`

**What it does:**
- Creates `sp_GL_DailyPostingReport` - View all GL postings
- Creates `sp_GL_TrialBalance` - Generate trial balance
- Creates `sp_GL_AccountLedger` - View account ledger

**Execute:**
```sql
-- Open and run: PHASE4_DAILY_POSTING_REPORT.sql
```

**Expected Output:**
```
✓ Created sp_GL_DailyPostingReport
✓ Created sp_GL_TrialBalance
✓ Created sp_GL_AccountLedger
```

---

### Step 5.2: Add Daily Posting Report Form

**File:** `Forms\Accounting\DailyPostingReportForm.vb`

**Manual Steps:**
1. Add form to Visual Studio project
2. Rebuild solution
3. Add menu item to access report

**Add to Main Menu:**
```vb
Private Sub btnDailyPostingReport_Click(sender As Object, e As EventArgs)
    Dim form As New DailyPostingReportForm()
    form.ShowDialog()
End Sub
```

**Test:**
1. Run ERP application
2. Navigate to Accounting → Daily Posting Report
3. Form should open and show today's postings
4. Verify totals: Total Debits = Total Credits
5. Status should show "✓ BALANCED"

---

## ✅ PHASE 6: COMPREHENSIVE TESTING

### Test 1: POS Transaction Flow

**Steps:**
1. Make a POS sale (cash, card, or EFT)
2. Open Daily Posting Report
3. Verify journal entry appears
4. Check accounts posted to:
   - Cash sale: DR 1030 (Cash), CR 4010 (Sales), DR 5010 (COGS), CR 1220 (Inventory)
   - Card sale: DR 1010 (Bank), CR 4010 (Sales), DR 5010 (COGS), CR 1220 (Inventory)
   - EFT sale: DR 1050 (Uncleared EFT), CR 4010 (Sales), DR 5010 (COGS), CR 1220 (Inventory)
5. Verify Debits = Credits

---

### Test 2: AP Invoice and Payment

**Steps:**
1. Create adhoc invoice (Accounting → Adhoc Invoices)
2. Open Daily Posting Report
3. Verify invoice journal:
   - DR 60xx (Expense), DR 2021 (VAT Input), CR 2030 (AP)
4. Make payment
5. Verify payment journal:
   - DR 2030 (AP), CR 1010 (Bank)
6. Check account 2030 balance = 0 (after payment)

---

### Test 3: EFT Clearing

**Steps:**
1. Make EFT payment (POS or AP)
2. Verify account 1050 has debit balance
3. Open EFT Clearing form
4. Mark EFT as cleared
5. Verify clearing journal:
   - DR 1010 (Bank), CR 1050 (Uncleared EFT)
6. Check account 1050 balance reduced

---

### Test 4: Stock Adjustment

**Steps:**
1. Create stock adjustment (increase or decrease)
2. Open Daily Posting Report
3. Verify adjustment journal:
   - Increase: DR 1220 (Inventory), CR 6050 (Variance)
   - Decrease: DR 6050 (Variance), CR 1220 (Inventory)
4. Verify Debits = Credits

---

### Test 5: Trial Balance

**Steps:**
1. Run: `EXEC sp_GL_TrialBalance`
2. Verify Total Debit Balances = Total Credit Balances
3. Check for abnormal balances:
   - Assets should have debit balances
   - Liabilities should have credit balances
   - Expenses should have debit balances
   - Revenue should have credit balances

---

## 🎯 PHASE 7: FINAL VERIFICATION

### Verification Checklist

Run these queries to verify everything is working:

```sql
-- 1. Check all GL accounts exist
SELECT AccountCode, AccountName, AccountType, IsActive
FROM ChartOfAccounts
WHERE AccountCode IN (
    '1010', '1030', '1050', '1220', '1600', '1610',
    '2010', '2020', '2021', '2030',
    '4010', '4020',
    '5010', '5020',
    '6010', '6020', '6030', '6040', '6050', '6060', '6070'
)
ORDER BY AccountCode

-- 2. Check all procedures exist
SELECT name, create_date, modify_date
FROM sys.objects
WHERE type = 'P'
    AND name LIKE '%GL%'
    OR name LIKE 'sp_AP_%'
    OR name LIKE 'sp_Inventory_%'
    OR name LIKE 'sp_EFT_%'
ORDER BY name

-- 3. Verify trial balance
EXEC sp_GL_TrialBalance

-- 4. View today's postings
EXEC sp_GL_DailyPostingReport

-- 5. Check for unbalanced journals
SELECT 
    jh.JournalNumber,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Difference
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
GROUP BY jh.JournalNumber
HAVING SUM(jd.Debit) <> SUM(jd.Credit)

-- Should return 0 rows if all journals are balanced
```

---

## 📚 DAILY OPERATIONS GUIDE

### For Cashiers (POS)

**End of Day:**
1. Count cash in till
2. Navigate to: Cashbook → Cash Deposit
3. Enter cash amount to deposit
4. System posts: DR 1010 (Bank), CR 1030 (Cash)

---

### For Accounts Payable Clerk

**Capturing Invoices:**
1. Navigate to: Accounting → Adhoc Invoices
2. Capture invoice details
3. Select expense account (6010, 6020, etc.)
4. System posts: DR Expense, DR VAT Input, CR 2030 (AP)

**Making Payments:**
1. Navigate to: Accounting → Supplier Payments
2. Select invoices to pay
3. Choose payment method (EFT, Cash, Cheque)
4. System posts: DR 2030 (AP), CR Bank/Cash

**Clearing EFTs:**
1. Import bank statement
2. Navigate to: Accounting → EFT Clearing
3. Mark EFTs as cleared
4. System posts: DR 1010 (Bank), CR 1050 (Uncleared EFT)

---

### For Inventory Manager

**Stock Adjustments:**
1. Navigate to: Inventory → Stock Adjustments
2. Enter adjustment details
3. System posts: DR/CR 1220 (Inventory), CR/DR 6050 (Variance)

**Wastage:**
1. Navigate to: Inventory → Wastage
2. Enter wastage details
3. System posts: DR 6060 (Wastage), CR 1220 (Inventory)

---

### For Accountant

**Daily Review:**
1. Open: Accounting → Daily Posting Report
2. Review all GL postings
3. Verify: Total Debits = Total Credits
4. Check for unbalanced entries (Tab 3)
5. Investigate any discrepancies

**Month-End:**
1. Run: `EXEC sp_GL_TrialBalance`
2. Verify trial balance balances
3. Generate financial statements
4. Close accounting period

---

## 🚨 TROUBLESHOOTING

### Issue: "Account not found or inactive"

**Solution:**
- Re-run `PHASE1_CREATE_MISSING_ACCOUNTS.sql`
- Check account is Active: `SELECT * FROM ChartOfAccounts WHERE AccountCode = 'xxxx'`

---

### Issue: "Journal out of balance"

**Solution:**
- Run verification query (see Phase 7)
- Identify unbalanced journal
- Check journal details: `SELECT * FROM JournalDetails WHERE JournalID = xxx`
- Contact system administrator

---

### Issue: "Procedure does not exist"

**Solution:**
- Re-run the relevant phase SQL script
- Verify procedure exists: `SELECT * FROM sys.objects WHERE name = 'sp_xxx'`

---

### Issue: "Trial balance doesn't balance"

**Solution:**
- Run: `EXEC sp_GL_DailyPostingReport` to find unbalanced journals
- Check Tab 3 (Verification) for out-of-balance entries
- Review and correct unbalanced journals

---

## 📞 SUPPORT

If you encounter issues not covered in this guide:

1. Check error message carefully
2. Review relevant phase in this guide
3. Run verification queries
4. Check system logs
5. Contact system administrator

---

## ✅ DEPLOYMENT COMPLETE

Once all phases are completed and verified:

- [ ] All GL accounts created
- [ ] All procedures created and tested
- [ ] AP workflow tested and verified
- [ ] EFT clearing functional
- [ ] Inventory GL integration working
- [ ] Daily Posting Report accessible
- [ ] Trial balance balances
- [ ] All users trained on new features

**System is ready for production use!**

---

**Deployed By:** ___________________  
**Date:** ___________________  
**Verified By:** ___________________  
**Date:** ___________________
