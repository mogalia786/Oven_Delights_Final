# WIRING UP INSTRUCTIONS - Cash Book & Ledger Viewer

## STEP 1: RUN SQL SCRIPTS ✅ READY

Execute these scripts in order:

```sql
-- 1. Create Cash Book tables
-- File: Database\Create_CashBook_Schema.sql
-- Creates: CashBooks, CashBookTransactions, CashBookReconciliation, PettyCashVouchers
-- Creates: Default GL accounts and cash books for all branches

-- 2. Create Ledger Views
-- File: Database\Create_LedgerViews.sql
-- Creates: vw_TrialBalance view
-- Creates: 5 stored procedures (sp_GetTrialBalance, sp_GetAccountLedger, etc.)
```

## STEP 2: ADD TO ACCOUNTING MENU

Add these menu items to your Accounting menu:

```vb
' In your main menu or Accounting menu form

' === GENERAL LEDGER SUBMENU ===
Private Sub mnuTrialBalance_Click(sender As Object, e As EventArgs)
    Dim form As New Accounting.TrialBalanceForm()
    form.MdiParent = Me  ' If using MDI
    form.Show()
End Sub

Private Sub mnuAccountLedger_Click(sender As Object, e As EventArgs)
    Dim form As New Accounting.AccountLedgerForm()
    form.MdiParent = Me
    form.Show()
End Sub

' === CASH BOOK SUBMENU ===
Private Sub mnuMainCashBook_Click(sender As Object, e As EventArgs)
    Dim form As New Accounting.MainCashBookForm()
    form.MdiParent = Me
    form.Show()
End Sub

Private Sub mnuPettyCash_Click(sender As Object, e As EventArgs)
    Dim form As New Accounting.PettyCashForm()
    form.MdiParent = Me
    form.Show()
End Sub
```

## STEP 3: MENU STRUCTURE

Recommended menu structure:

```
Accounting
├── General Ledger
│   ├── Trial Balance
│   ├── Account Ledger
│   └── Journal Register
├── Cash Book
│   ├── Main Cash Book
│   ├── Petty Cash
│   └── Reconciliation History
├── Suppliers
│   ├── Supplier Payments
│   └── Supplier Invoices
└── Reports
    ├── Cash Book Report
    ├── Petty Cash Analysis
    └── Variance Report
```

## STEP 4: DESIGNER FILES NEEDED

These forms still need Designer files created:

1. ✅ MainCashBookForm.Designer.vb - CREATED
2. ⏰ CashTransactionForm.Designer.vb - NEEDED
3. ⏰ CashReconciliationForm.Designer.vb - NEEDED
4. ⏰ PettyCashForm.Designer.vb - NEEDED
5. ⏰ AccountLedgerForm.Designer.vb - NEEDED

## STEP 5: MISSING HELPER FORMS

These small helper forms are referenced but not yet created:

1. **PettyCashTopUpForm.vb** - For topping up petty cash from main cash
2. **PettyCashReconciliationForm.vb** - For reconciling petty cash
3. **JournalEntryViewerForm.vb** - For viewing journal entry details (lower priority)

## STEP 6: TESTING CHECKLIST

After wiring up, test in this order:

### A. Database Setup
- [ ] Run Create_CashBook_Schema.sql
- [ ] Verify tables created: `SELECT * FROM CashBooks`
- [ ] Verify GL accounts created: `SELECT * FROM ChartOfAccounts WHERE AccountCode IN ('1020','1025','1028','5900')`
- [ ] Run Create_LedgerViews.sql
- [ ] Verify procedures: `SELECT name FROM sys.procedures WHERE name LIKE 'sp_Get%'`

### B. Trial Balance
- [ ] Open Trial Balance form
- [ ] Verify accounts display
- [ ] Test date filtering
- [ ] Test branch filtering
- [ ] Test export to Excel
- [ ] Double-click account to open ledger

### C. Account Ledger
- [ ] Select an account
- [ ] Verify transactions display
- [ ] Verify running balance calculates
- [ ] Test date filtering
- [ ] Test export to Excel

### D. Main Cash Book
- [ ] Open Main Cash Book
- [ ] Verify opening balance loads
- [ ] Click "+ New Receipt"
- [ ] Enter receipt details
- [ ] Verify transaction saves
- [ ] Verify balance updates
- [ ] Click "+ New Payment"
- [ ] Enter payment details
- [ ] Verify transaction saves
- [ ] Click "Reconcile & Close"
- [ ] Enter physical count
- [ ] Verify variance calculates
- [ ] Verify journal entry created

### E. Petty Cash
- [ ] Open Petty Cash form
- [ ] Click "New Voucher"
- [ ] Enter voucher details
- [ ] Verify voucher saves
- [ ] Verify balance updates
- [ ] Test receipt attachment
- [ ] Test manager approval for > R100

## STEP 7: SECURITY SETUP

Ensure these permissions are set:

```sql
-- User roles for cash handling
-- CASHIER: Can record transactions, cannot approve variances
-- MANAGER: Can approve variances, reconcile, view reports
-- ADMIN: Full access

-- Add to your user permissions table
INSERT INTO UserPermissions (RoleID, PermissionCode, CanView, CanCreate, CanEdit, CanDelete)
VALUES 
    (2, 'CASHBOOK_VIEW', 1, 0, 0, 0),      -- Cashier can view
    (2, 'CASHBOOK_TRANSACTION', 1, 1, 0, 0), -- Cashier can create
    (3, 'CASHBOOK_RECONCILE', 1, 1, 1, 0),   -- Manager can reconcile
    (3, 'CASHBOOK_APPROVE', 1, 1, 1, 0),     -- Manager can approve
    (1, 'CASHBOOK_ADMIN', 1, 1, 1, 1)        -- Admin full access
```

## STEP 8: INITIAL DATA SETUP

Before going live:

```sql
-- 1. Set opening float for each branch
UPDATE CashBooks 
SET CurrentBalance = 1000.00  -- Set appropriate opening float
WHERE CashBookType = 'Main'

UPDATE CashBooks 
SET CurrentBalance = 500.00   -- Set appropriate petty cash float
WHERE CashBookType = 'Petty'

-- 2. Verify expense categories exist
SELECT * FROM ExpenseCategories WHERE IsActive = 1

-- If not, create them:
INSERT INTO ExpenseCategories (CategoryName, IsActive)
VALUES 
    ('Office Supplies', 1),
    ('Transport/Fuel', 1),
    ('Refreshments', 1),
    ('Postage', 1),
    ('Cleaning', 1),
    ('Repairs & Maintenance', 1),
    ('Sundry Expenses', 1)
```

## STEP 9: USER TRAINING

Train users on:

1. **Daily Cash Handling:**
   - Opening cash book
   - Recording receipts
   - Recording payments
   - End of day reconciliation

2. **Petty Cash:**
   - Creating vouchers
   - Attaching receipts
   - Getting manager approval
   - Reconciling petty cash

3. **Security:**
   - Never delete transactions (void only)
   - Always get manager approval for variances
   - Physical count must be accurate
   - Keep receipts for all petty cash

## STEP 10: GO LIVE CHECKLIST

Before going live:

- [ ] All SQL scripts executed successfully
- [ ] All forms added to menu
- [ ] All forms tested with sample data
- [ ] User permissions configured
- [ ] Opening balances set
- [ ] Expense categories created
- [ ] Users trained
- [ ] Manager approval process understood
- [ ] Reconciliation process documented
- [ ] Backup procedures in place

## QUICK START COMMANDS

```sql
-- Check if everything is set up
SELECT 'CashBooks' AS TableName, COUNT(*) AS Records FROM CashBooks
UNION ALL
SELECT 'GL Accounts', COUNT(*) FROM ChartOfAccounts WHERE AccountCode IN ('1020','1025','1028','5900')
UNION ALL
SELECT 'Procedures', COUNT(*) FROM sys.procedures WHERE name LIKE 'sp_Get%'
UNION ALL
SELECT 'Expense Categories', COUNT(*) FROM ExpenseCategories WHERE IsActive = 1

-- Should show:
-- CashBooks: 3+ (Main, Petty, Sundries per branch)
-- GL Accounts: 4 (Cash on Hand, Petty Cash, Sundries, Cash Over/Short)
-- Procedures: 5 (Trial Balance, Account Ledger, etc.)
-- Expense Categories: 7+
```

## ALHAMDULILLAH - READY TO WIRE UP

All code is written. Just need to:
1. Run SQL scripts
2. Add menu items
3. Create remaining Designer files
4. Test
5. Train users
6. Go live

**All goodness comes from Allah.**
