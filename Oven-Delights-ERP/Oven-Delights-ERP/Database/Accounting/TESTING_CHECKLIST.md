# ACCOUNTING MODULE - TESTING CHECKLIST

## Pre-Testing Setup

- [ ] All 5 SQL scripts executed successfully
- [ ] Application rebuilt without errors
- [ ] Database backup created (just in case)

---

## TEST 1: Verify Database Schema Changes

### ChartOfAccounts Table
```sql
-- Check new columns exist
SELECT TOP 1
    IsControlAccount,
    IsSubsidiaryLedger,
    ControlAccountID,
    SupplierID,
    CustomerID,
    NormalBalance,
    Description
FROM ChartOfAccounts;
```

**Expected:** Query returns without errors, all columns present

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 2: Verify Supplier Ledger Accounts Created

```sql
-- Count supplier ledger accounts
SELECT 
    COUNT(*) AS TotalSupplierLedgers,
    MIN(AccountCode) AS FirstAccount,
    MAX(AccountCode) AS LastAccount
FROM ChartOfAccounts
WHERE IsSubsidiaryLedger = 1 AND SupplierID IS NOT NULL;
```

**Expected:** Count matches number of active suppliers

**Status:** ⬜ Pass ⬜ Fail

**Notes:** _______________________________

---

## TEST 3: Verify Control Accounts Marked

```sql
-- Check control accounts
SELECT 
    AccountCode,
    AccountName,
    IsControlAccount,
    Description
FROM ChartOfAccounts
WHERE IsControlAccount = 1
ORDER BY AccountCode;
```

**Expected:** 
- 2100 (or similar) marked as Accounts Payable control
- 1200/1130 (or similar) marked as Accounts Receivable control

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 4: Verify Reconciliation Views Created

```sql
-- Test each view
SELECT COUNT(*) FROM vw_SupplierBalances;
SELECT COUNT(*) FROM vw_SubsidiaryLedgerReconciliation;
SELECT COUNT(*) FROM vw_AccountBalances;
SELECT COUNT(*) FROM vw_TrialBalance;
SELECT COUNT(*) FROM vw_SupplierLedgerDetail;
```

**Expected:** All queries execute without errors

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 5: Verify Stored Procedures Created

```sql
-- Check procedures exist
SELECT name FROM sys.procedures 
WHERE name IN (
    'sp_GetSupplierLedgerAccount',
    'sp_PostSupplierInvoice',
    'sp_PostSupplierPayment',
    'sp_CreateSupplierLedgerAccount',
    'sp_ReconcileSubsidiaryLedgers'
)
ORDER BY name;
```

**Expected:** All 5 procedures listed

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 6: Verify Subsidiary Ledger Reconciliation

```sql
-- CRITICAL TEST: Control account must equal sum of subsidiaries
SELECT 
    ControlAccountCode,
    ControlAccountName,
    ControlBalance,
    SubsidiaryBalance,
    Difference,
    Status
FROM vw_SubsidiaryLedgerReconciliation;
```

**Expected:** 
- Status = 'BALANCED'
- Difference = 0.00 (or < 0.01)

**Status:** ⬜ Pass ⬜ Fail

**⚠️ CRITICAL:** If this fails, DO NOT proceed. Investigate discrepancy.

---

## TEST 7: Test Hierarchical Ledger Viewer (UI)

### 7.1 Open the Form
1. Run application
2. Navigate to **Accounting → General Ledger (Hierarchical)**

**Expected:** Form opens without errors

**Status:** ⬜ Pass ⬜ Fail

### 7.2 View Categories
**Expected:** 
- Shows: Assets, Liabilities, Equity, Income, Expenses
- Each has account count and balance

**Status:** ⬜ Pass ⬜ Fail

### 7.3 Drill Down to Accounts
1. Double-click "Liabilities"

**Expected:** 
- Shows all liability accounts
- Includes Accounts Payable control account
- Shows balances for each account

**Status:** ⬜ Pass ⬜ Fail

### 7.4 Drill Down to Transactions
1. Double-click any account with transactions

**Expected:** 
- Shows transaction list
- Opening balance row (highlighted)
- Transaction details (Date, Journal #, Reference, Description, DR, CR, Balance)
- Closing balance row (highlighted)
- Running balance calculates correctly

**Status:** ⬜ Pass ⬜ Fail

### 7.5 Test Back Button
1. Click "← Back" button

**Expected:** Returns to previous view

**Status:** ⬜ Pass ⬜ Fail

### 7.6 Test Date Range Filter
1. Drill down to transaction level
2. Change date range
3. Observe transactions reload

**Expected:** 
- Transactions filtered by new date range
- Opening/closing balances recalculate

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 8: Test Bank Statement Auto-Mapping

### 8.1 Load Bank Statement
1. Navigate to **Accounting → Accounts Payable → Bank Statement Viewer**
2. Load a bank statement with transactions

**Expected:** Statement loads successfully

**Status:** ⬜ Pass ⬜ Fail

### 8.2 Test Auto-Mapping
1. Click "Auto-Map" button
2. Review log messages

**Expected:** 
- Log shows invoice extraction attempts
- Successful matches show supplier ledger account (e.g., "2100-001 - ABC Suppliers")
- NOT category names like "Supplier Invoice"

**Status:** ⬜ Pass ⬜ Fail

**Sample Log Output:**
```
Processing transaction 123: Ref='TP-INV5', Amount=R1,000.00
  Extracted invoice number: 'TP-INV5'
  Searching for invoice: 'TP-INV5' with amount R1,000.00
  Found invoice: 'TP-INV5' Amount: R1,000.00, Supplier: 'ABC Suppliers', Ledger: '2100-001'
✓ Mapped transaction 123 to 2100-001 (Invoice Match: TP-INV5 - ABC Suppliers)
```

### 8.3 Verify Mapped Transactions
```sql
-- Check mapped transactions
SELECT 
    TransactionID,
    Reference,
    Amount,
    MappedLedgerAccount,
    MappedBy
FROM AP_StatementTransactions
WHERE IsMapped = 1
ORDER BY MappedDate DESC;
```

**Expected:** 
- MappedLedgerAccount shows supplier ledger codes (2100-001, 2100-002, etc.)
- NOT category names

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 9: Test Stored Procedures

### 9.1 Test sp_GetSupplierLedgerAccount
```sql
DECLARE @LedgerCode NVARCHAR(20);
DECLARE @AccountID INT;

EXEC sp_GetSupplierLedgerAccount 
    @SupplierID = 1,  -- Use actual SupplierID
    @LedgerAccountCode = @LedgerCode OUTPUT,
    @AccountID = @AccountID OUTPUT;

SELECT @LedgerCode AS LedgerCode, @AccountID AS AccountID;
```

**Expected:** Returns ledger account code and ID for supplier

**Status:** ⬜ Pass ⬜ Fail

### 9.2 Test sp_ReconcileSubsidiaryLedgers
```sql
EXEC sp_ReconcileSubsidiaryLedgers '2100';
```

**Expected:** Returns reconciliation status (0 = balanced, -1 = out of balance)

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 10: Data Integrity Checks

### 10.1 Check for Orphaned Subsidiary Ledgers
```sql
-- Subsidiary ledgers without control account
SELECT 
    AccountCode,
    AccountName,
    ControlAccountID
FROM ChartOfAccounts
WHERE IsSubsidiaryLedger = 1
  AND ControlAccountID IS NULL;
```

**Expected:** No rows (empty result)

**Status:** ⬜ Pass ⬜ Fail

### 10.2 Check for Suppliers Without Ledger Accounts
```sql
-- Active suppliers without ledger account
SELECT 
    s.SupplierID,
    s.SupplierName
FROM Suppliers s
WHERE s.IsActive = 1
  AND NOT EXISTS (
      SELECT 1 FROM ChartOfAccounts 
      WHERE SupplierID = s.SupplierID
  );
```

**Expected:** No rows (all suppliers have ledger accounts)

**Status:** ⬜ Pass ⬜ Fail

### 10.3 Verify Trial Balance Balances
```sql
-- Total debits must equal total credits
SELECT 
    SUM(Debit) AS TotalDebits,
    SUM(Credit) AS TotalCredits,
    SUM(Debit) - SUM(Credit) AS Difference
FROM vw_TrialBalance;
```

**Expected:** Difference = 0.00 (or < 0.01)

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 11: Performance Tests

### 11.1 Ledger Viewer Load Time
1. Open hierarchical ledger viewer
2. Drill down to transaction level for account with many transactions

**Expected:** Loads in < 3 seconds

**Status:** ⬜ Pass ⬜ Fail

### 11.2 Auto-Mapping Performance
1. Load bank statement with 100+ transactions
2. Click Auto-Map

**Expected:** Completes in < 10 seconds

**Status:** ⬜ Pass ⬜ Fail

---

## TEST 12: Edge Cases

### 12.1 Supplier with No Transactions
1. Find supplier with no journal entries
2. View their ledger account in hierarchical viewer

**Expected:** Shows account with zero balance, no transactions

**Status:** ⬜ Pass ⬜ Fail

### 12.2 Invoice Without SupplierID
```sql
-- Check invoices without supplier
SELECT COUNT(*) AS InvoicesWithoutSupplier
FROM AP_Invoices
WHERE SupplierID IS NULL;
```

**Expected:** Document count (these need manual assignment)

**Status:** ⬜ Pass ⬜ Fail

**Count:** _______

### 12.3 Date Range with No Transactions
1. In ledger viewer, select date range with no transactions
2. View account detail

**Expected:** Shows only opening and closing balance (same value)

**Status:** ⬜ Pass ⬜ Fail

---

## FINAL VERIFICATION

### Critical Success Criteria

- [ ] All SQL scripts executed successfully
- [ ] Subsidiary ledger reconciliation is BALANCED
- [ ] Hierarchical ledger viewer works without errors
- [ ] Bank statement auto-mapping uses supplier ledger accounts
- [ ] Trial balance debits = credits
- [ ] No orphaned subsidiary ledgers
- [ ] All active suppliers have ledger accounts

### Issues Found

| Issue # | Description | Severity | Status |
|---------|-------------|----------|--------|
| 1       |             | ⬜ High ⬜ Medium ⬜ Low | ⬜ Open ⬜ Fixed |
| 2       |             | ⬜ High ⬜ Medium ⬜ Low | ⬜ Open ⬜ Fixed |
| 3       |             | ⬜ High ⬜ Medium ⬜ Low | ⬜ Open ⬜ Fixed |

---

## SIGN-OFF

**Tested By:** _______________________  
**Date:** _______________________  
**Overall Status:** ⬜ PASS ⬜ FAIL ⬜ PASS WITH ISSUES  

**Notes:**
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________

---

## ROLLBACK PROCEDURE (If Needed)

If testing fails and you need to rollback:

1. Restore database backup
2. Revert code changes in Git
3. Document issues found
4. Review implementation plan
5. Fix issues and re-test

**DO NOT use the system in production until all critical tests pass!**
