# BANK RECONCILIATION - FINAL INSTALLATION STEPS

## ⚠️ CRITICAL ISSUE IDENTIFIED

**The `BankStatementTransactions` table was created with incorrect structure or already exists with wrong columns.**

The error shows:
- ✗ Column 'Status' does not exist
- ✗ Column 'PostedToGL' does not exist  
- ✗ Column 'BankAccountID' does not exist
- ✗ Column 'StatementLineID' does not exist

This means an old/incomplete version of the table exists in your database.

---

## 🔍 STEP 1: DIAGNOSE THE PROBLEM

**Execute this script first to see what's wrong:**
```sql
-- Execute: CHECK_EXISTING_TABLES.sql
```

This will show you:
- Which tables exist
- What columns they have
- What's missing

---

## 🧹 STEP 2: CLEAN UP (IF NEEDED)

**If tables exist with wrong structure, drop them:**
```sql
-- Execute: DROP_AND_RECREATE_BANK_TABLES.sql
```

**⚠️ WARNING:** This deletes all data in bank reconciliation tables!

---

## ✅ STEP 3: FRESH INSTALLATION

**Now execute scripts in this exact order:**

### 3.1 GLBatches Table
```sql
-- Execute: CREATE_GLBATCHES_TABLE.sql
```

### 3.2 Bank Reconciliation Tables (UPDATED - all USE statements removed)
```sql
-- Execute: CREATE_BANK_RECONCILIATION_SYSTEM.sql
```

**Expected Output:**
```
Table Beneficiaries created successfully
Table BeneficiaryPayments created successfully
Table PaymentBatches created successfully
Table PaymentBatchItems created successfully
Table BankAccounts created successfully
Table BankStatementTransactions created successfully  ← MUST SEE THIS
Table BankStatementImportLog created successfully
✓ Added PaymentReference column to SupplierInvoices
✓ Added Status column to SupplierInvoices
... (more success messages)
=========================================
Bank Reconciliation System Schema Created Successfully
=========================================
```

### 3.3 Stored Procedures (UPDATED - all USE statements removed)
```sql
-- Execute in order:
1. sp_GeneratePaymentReference.sql
2. sp_AutoMatchBankTransactions.sql  ← Should now work without errors
3. sp_PostBankTransactionsToGL.sql
```

**Expected Output for sp_AutoMatchBankTransactions:**
```
sp_AutoMatchBankTransactions created successfully
```
**NO ERRORS about invalid columns!**

### 3.4 Validation
```sql
-- Execute: TEST_BANK_RECONCILIATION.sql
```

All 6 tests should pass ✓

---

## 🎯 WHAT WAS FIXED IN ALL SCRIPTS

### All SQL Files Updated:
1. ✅ `CREATE_BANK_RECONCILIATION_SYSTEM.sql` - Removed USE, fixed indexes
2. ✅ `sp_GeneratePaymentReference.sql` - Removed USE statement
3. ✅ `sp_AutoMatchBankTransactions.sql` - Removed USE statement
4. ✅ `sp_PostBankTransactionsToGL.sql` - Removed USE statement

**All scripts are now Azure SQL compatible!**

---

## 🔧 TROUBLESHOOTING

### Error: "Invalid column name 'Status'"
**Cause:** Old version of BankStatementTransactions table exists
**Solution:** 
1. Run `CHECK_EXISTING_TABLES.sql` to confirm
2. Run `DROP_AND_RECREATE_BANK_TABLES.sql` to clean up
3. Re-run `CREATE_BANK_RECONCILIATION_SYSTEM.sql`

### Error: "USE statement not supported"
**Cause:** Using Azure SQL or restricted environment
**Solution:** All scripts updated - just connect to database first

### Error: "Table already exists"
**Cause:** Partial installation from previous attempts
**Solution:** Either:
- Option A: Drop tables with `DROP_AND_RECREATE_BANK_TABLES.sql`
- Option B: Continue - scripts check for existence

---

## 📋 VERIFICATION CHECKLIST

After installation, verify:

### Database Objects:
```sql
-- Check tables exist
SELECT name FROM sys.tables 
WHERE name IN (
    'Beneficiaries',
    'BeneficiaryPayments', 
    'PaymentBatches',
    'PaymentBatchItems',
    'BankAccounts',
    'BankStatementTransactions',  ← CRITICAL
    'BankStatementImportLog',
    'GLBatches'
)
ORDER BY name

-- Should return 8 rows
```

### Check BankStatementTransactions columns:
```sql
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BankStatementTransactions'
ORDER BY ORDINAL_POSITION

-- Should include: StatementLineID, BankAccountID, Status, PostedToGL, etc.
```

### Stored Procedures:
```sql
SELECT name FROM sys.procedures
WHERE name IN (
    'sp_GeneratePaymentReference',
    'sp_AutoMatchBankTransactions',
    'sp_PostBankTransactionsToGL'
)

-- Should return 3 rows
```

---

## 🚀 AFTER SUCCESSFUL INSTALLATION

### 1. Rebuild ERP Application
- Open solution in Visual Studio
- Build → Rebuild Solution
- Verify no compilation errors

### 2. Test Financial Dashboard
- Login to ERP
- Accounting → Financial Dashboard
- Verify 6 cards display (including Expenses MTD and Payables)

### 3. Test Bank Reconciliation
- Accounting → Bank Reconciliation
- Import CSV file
- Run Auto-Match
- Post to GL
- Verify transactions appear in General Ledger

---

## 📞 IF STILL HAVING ISSUES

**Run this diagnostic query:**
```sql
-- Show me everything about BankStatementTransactions
SELECT 
    'Table exists' AS CheckType,
    CASE WHEN EXISTS (SELECT * FROM sys.tables WHERE name = 'BankStatementTransactions') 
         THEN 'YES' ELSE 'NO' END AS Result
UNION ALL
SELECT 
    'Column: ' + COLUMN_NAME,
    DATA_TYPE + 
    CASE WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
         THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR) + ')' 
         ELSE '' END
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'BankStatementTransactions'
ORDER BY CheckType
```

**Share the output if you need help.**

---

## ✅ SUCCESS CRITERIA

Installation is complete when:
- [ ] All 8 tables created with correct structure
- [ ] All 3 stored procedures created without errors
- [ ] TEST_BANK_RECONCILIATION.sql passes all 6 tests
- [ ] ERP compiles without errors
- [ ] Financial Dashboard shows Expenses and Payables
- [ ] Bank Reconciliation menu appears and opens

---

**The root cause is an existing BankStatementTransactions table with wrong structure. Drop and recreate it using the scripts provided.**
