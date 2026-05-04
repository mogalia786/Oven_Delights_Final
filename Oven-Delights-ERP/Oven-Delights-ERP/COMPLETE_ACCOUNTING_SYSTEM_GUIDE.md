# COMPLETE ACCOUNTING SYSTEM - IMPLEMENTATION GUIDE

## 🎯 OVERVIEW

This comprehensive accounting system handles:
- ✅ **Customer Ledgers** (Accounts Receivable) - Cake orders, adhoc invoices, payments
- ✅ **Supplier Ledgers** (Accounts Payable) - Purchase orders, supplier invoices, payments
- ✅ **Bank Reconciliation** - FNB integration for matching bank statements
- ✅ **General Ledger** - All financial transactions with double-entry bookkeeping
- ✅ **Cash on Hand vs Bank** - Proper separation of physical cash and deposited funds

---

## 📦 IMPLEMENTATION STEPS

### Step 1: Execute Database Schema Scripts

Execute these SQL scripts in order:

1. **CREATE_ACCOUNTING_SYSTEM.sql**
   - Creates: ChartOfAccounts, GeneralLedger, CustomerLedger, CashRegister, BankDeposits
   - Creates: Stored procedures and views for customer accounting
   - Location: `Database\CREATE_ACCOUNTING_SYSTEM.sql`

2. **EXTEND_ACCOUNTING_SYSTEM.sql**
   - Creates: SupplierLedger, AdhocInvoices, AdhocPayments, BankStatementReconciliation, SupplierPayments
   - Adds: Additional accounts to Chart of Accounts
   - Creates: Stored procedures and views for supplier accounting and bank reconciliation
   - Location: `Database\EXTEND_ACCOUNTING_SYSTEM.sql`

### Step 2: Wire Accounting Menus in ERP

Add this line to `MainDashboard.vb` constructor (after existing menu wiring):
```vb
WireAccountingMenus()
```

This will add the **Accounting** menu with:
- Financial Dashboard
- General Ledger
- Customer Ledgers
- Supplier Ledgers
- Bank Reconciliation

### Step 3: Verify Installation

Run these verification queries:

```sql
-- Check all tables created
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME IN (
    'ChartOfAccounts', 'GeneralLedger', 'CustomerLedger', 
    'SupplierLedger', 'AdhocInvoices', 'AdhocPayments',
    'BankStatementReconciliation', 'SupplierPayments'
)
ORDER BY TABLE_NAME

-- Verify double-entry balance (should = 0)
SELECT SUM(DebitAmount) - SUM(CreditAmount) AS Balance
FROM GeneralLedger WHERE IsReversed = 0
```

---

## 🏦 ACCOUNTING WORKFLOWS

### 1. CAKE ORDER ACCOUNTING (POS → ERP)

#### A. New Order with Deposit
**POS Action**: Customer places order, pays R50 deposit on R300 order

**Accounting (Automatic)**:
```
IF CASH:
  DR: Cash on Hand (1110)     R50
  CR: Customer Deposits (2120) R50

IF CARD:
  DR: Bank (1120)              R50
  CR: Customer Deposits (2120) R50

Customer Ledger:
  DR: Customer Account         R300  (total owed)
  CR: Customer Account         R50   (deposit paid)
  Running Balance:             R250  (customer owes)
```

**Key Point**: NO REVENUE RECORDED - Deposit is a liability until order is completed.

#### B. Order Collection (Balance Payment)
**POS Action**: Customer collects order, pays R250 balance

**Accounting (Automatic)**:
```
DR: Cash/Bank (1110/1120)      R250  (balance payment)
DR: Customer Deposits (2120)   R50   (clear liability)
CR: Cake Sales Revenue (4110)  R300  (REVENUE RECOGNIZED)

Customer Ledger:
  CR: Customer Account         R250  (balance payment)
  CR: Customer Account         R50   (deposit applied)
  DR: Customer Account         R300  (order completed)
  Running Balance:             R0    (settled)
```

**Key Point**: Revenue is ONLY recognized when order is completed and fully paid.

#### C. Order Cancellation
**POS Action**: Customer cancels, R30 cancellation fee, R20 refund

**Accounting (Automatic)**:
```
DR: Customer Deposits (2120)        R50   (clear liability)
CR: Cancellation Fee Revenue (4130) R30   (revenue)
CR: Cash/Bank (1110/1120)           R20   (refund)

Customer Ledger:
  DR: Customer Account         R30   (cancellation fee)
  CR: Customer Account         R20   (refund)
  Running Balance:             R0    (settled)
```

---

### 2. ADHOC INVOICE & PAYMENT ACCOUNTING

#### A. Create Adhoc Invoice
**ERP Action**: Create invoice for customer (outside of cake orders)

**Accounting**:
```
Customer Ledger:
  DR: Customer Account         R500  (invoice amount)
  Running Balance:             R500  (customer owes)

General Ledger:
  DR: Accounts Receivable      R500
  CR: Adhoc Sales Revenue      R500
```

**Where to Do**: ERP → Accounting → Create Adhoc Invoice (coming soon)

#### B. Receive Adhoc Payment (CASH)
**ERP Action**: Customer pays invoice with cash

**Accounting (Immediate)**:
```
DR: Cash on Hand (1110)        R500
CR: Accounts Receivable        R500

Customer Ledger:
  CR: Customer Account         R500  (payment)
  Running Balance:             R0    (settled)
```

**Key Point**: Cash payments update Cash on Hand IMMEDIATELY.

#### C. Receive Adhoc Payment (CARD/EFT)
**ERP Action**: Customer pays invoice via card/EFT

**Accounting (PENDING Reconciliation)**:
```
Customer Ledger:
  CR: Customer Account         R500  (payment pending)
  Running Balance:             R0    (settled)

Payment Status: PENDING (awaiting bank confirmation)
```

**Key Point**: Bank account is NOT updated until reconciled with FNB statement.

---

### 3. SUPPLIER ACCOUNTING

#### A. Receive Supplier Invoice
**ERP Action**: Receive invoice from supplier for R1000

**Accounting**:
```
General Ledger:
  DR: Expense/Asset Account    R1000
  CR: Accounts Payable (2110)  R1000

Supplier Ledger:
  DR: Supplier Account         R1000  (we owe)
  Running Balance:             R1000  (we owe supplier)
```

**Where to Do**: ERP → Accounting → Supplier Ledgers → Record Invoice (coming soon)

#### B. Pay Supplier (CASH)
**ERP Action**: Pay supplier with cash

**Accounting (Immediate)**:
```
DR: Accounts Payable (2110)    R1000
CR: Cash on Hand (1110)        R1000

Supplier Ledger:
  CR: Supplier Account         R1000  (payment)
  Running Balance:             R0     (settled)
```

#### C. Pay Supplier (EFT)
**ERP Action**: Pay supplier via EFT

**Accounting (PENDING Reconciliation)**:
```
Supplier Ledger:
  CR: Supplier Account         R1000  (payment pending)
  Running Balance:             R0     (settled)

Payment Status: PENDING (awaiting bank confirmation)
```

**Key Point**: Bank account is NOT updated until reconciled with FNB statement.

---

### 4. BANK RECONCILIATION WORKFLOW

#### Purpose
Match internal transactions (card/EFT payments) with actual FNB bank statement entries.

#### Process

**Step 1: Import FNB Statement**
- ERP → Accounting → Bank Reconciliation
- Click "📥 Import FNB Statement"
- Import CSV/Excel from FNB (coming soon)
- Unreconciled transactions appear in top grid

**Step 2: Match Transactions**
- Top Grid: Unreconciled bank statement entries
- Bottom Grid: Pending payments (awaiting confirmation)
- Select one from each grid
- Click "✅ Reconcile Selected"

**Step 3: System Updates Bank Account**
```
General Ledger:
  DR: Bank (1120)              R500  (if deposit)
  CR: Bank (1120)              R500  (if payment)

Payment Status: RECONCILED
```

**Key Point**: Bank account is ONLY updated when reconciled with actual bank statement.

---

## 📊 ERP DASHBOARD GUIDE

### Financial Dashboard
**Access**: Accounting → Financial Dashboard

**Features**:
- 💵 **Cash on Hand**: Physical cash in register
- 🏦 **Bank Balance**: Deposited funds + card payments (after reconciliation)
- 📊 **Accounts Receivable**: Customers who owe us
- 💳 **Customer Deposits**: Deposits we're holding (liability)
- 📦 **Accounts Payable**: Suppliers we owe
- Recent transactions grid
- Customer/Supplier balances grid

### General Ledger
**Access**: Accounting → General Ledger

**Features**:
- View all accounting transactions
- Filter by date range
- Filter by account
- Shows debits, credits, descriptions, references
- Running totals at bottom

### Customer Ledgers
**Access**: Accounting → Customer Ledgers

**Features**:
- View all customer balances
- Search by name or account number
- Color-coded: Orange (they owe us), Red (we owe them), Green (settled)
- Double-click to view detailed transaction history
- Total Receivables and Payables summary

### Supplier Ledgers
**Access**: Accounting → Supplier Ledgers

**Features**:
- View all supplier balances
- Search by name or supplier code
- Color-coded: Red (we owe them), Green (prepaid), Grey (settled)
- Double-click to view detailed transaction history
- Total Payables and Prepaid summary

### Bank Reconciliation
**Access**: Accounting → Bank Reconciliation

**Features**:
- Import FNB bank statements
- Match unreconciled bank entries with pending payments
- Verify amounts before reconciliation
- Updates Bank account when reconciled
- Shows days unreconciled

---

## ✅ DAILY VERIFICATION CHECKLIST

### 1. Check Cash on Hand vs Physical Cash
```sql
SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) AS CashOnHand
FROM GeneralLedger gl
INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode = '1110' AND gl.IsReversed = 0
```
**Action**: Compare to physical cash count in register. Should match exactly.

### 2. Check Bank Balance
```sql
SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) AS BankBalance
FROM GeneralLedger gl
INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode = '1120' AND gl.IsReversed = 0
```
**Action**: Compare to bank statement. Differences = unreconciled transactions.

### 3. Verify Customer Deposits Match Orders
```sql
-- Total deposits held (liability)
SELECT ISNULL(SUM(CreditAmount - DebitAmount), 0) AS TotalDepositsHeld
FROM GeneralLedger gl
INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode = '2120' AND gl.IsReversed = 0

-- Total deposits from active orders
SELECT SUM(DepositPaid) AS TotalOrderDeposits
FROM POS_CustomOrders
WHERE OrderStatus IN ('New', 'InProgress', 'Ready')
```
**Action**: These two amounts should match. If not, investigate discrepancies.

### 4. Check Double-Entry Balance
```sql
SELECT SUM(DebitAmount) - SUM(CreditAmount) AS Balance
FROM GeneralLedger WHERE IsReversed = 0
```
**Action**: This should ALWAYS equal 0. If not, there's an accounting error.

### 5. Review Unreconciled Bank Transactions
```sql
SELECT COUNT(*) AS UnreconciledCount,
       SUM(Amount) AS UnreconciledAmount
FROM BankStatementReconciliation
WHERE IsReconciled = 0
```
**Action**: Reconcile pending transactions daily. Old unreconciled items need investigation.

### 6. Check Accounts Receivable Aging
```sql
SELECT 
    AccountNumber,
    CustomerName,
    RunningBalance,
    DATEDIFF(DAY, MAX(TransactionDate), GETDATE()) AS DaysSinceLastTransaction
FROM CustomerLedger
WHERE RunningBalance > 0
GROUP BY AccountNumber, CustomerName, RunningBalance
HAVING DATEDIFF(DAY, MAX(TransactionDate), GETDATE()) > 30
ORDER BY DaysSinceLastTransaction DESC
```
**Action**: Follow up on customers with balances older than 30 days.

### 7. Check Accounts Payable Aging
```sql
SELECT 
    SupplierCode,
    SupplierName,
    RunningBalance,
    DATEDIFF(DAY, MAX(TransactionDate), GETDATE()) AS DaysSinceLastTransaction
FROM SupplierLedger
WHERE RunningBalance > 0
GROUP BY SupplierCode, SupplierName, RunningBalance
HAVING DATEDIFF(DAY, MAX(TransactionDate), GETDATE()) > 30
ORDER BY DaysSinceLastTransaction DESC
```
**Action**: Prioritize paying suppliers with overdue balances.

---

## 🔧 TROUBLESHOOTING

### Issue: Accounting entries not appearing
**Causes**:
- Database scripts not executed
- POS connection string incorrect
- AccountingService not initialized

**Solution**:
1. Verify tables exist: `SELECT * FROM ChartOfAccounts`
2. Check POS App.config connection string
3. Check for errors in POS when creating orders

### Issue: Bank balance doesn't match statement
**Causes**:
- Unreconciled card/EFT payments
- Missing bank statement imports
- Reconciliation not performed

**Solution**:
1. Open Bank Reconciliation form
2. Import latest FNB statement
3. Reconcile all pending transactions
4. Verify amounts match

### Issue: Customer balance incorrect
**Causes**:
- Duplicate transactions
- Missing payment entries
- Incorrect order amounts

**Solution**:
1. Open Customer Ledger Detail for customer
2. Review transaction history chronologically
3. Check running balance progression
4. Verify against POS_CustomOrders table

### Issue: Supplier balance incorrect
**Causes**:
- Missing invoice entries
- Duplicate payment entries
- Incorrect reconciliation

**Solution**:
1. Open Supplier Ledger Detail for supplier
2. Review transaction history
3. Verify against purchase orders
4. Check for unreconciled payments

---

## 📈 CHART OF ACCOUNTS

### Assets (1xxx)
- **1110** - Cash on Hand (physical cash)
- **1120** - Bank (deposited funds)
- **1130** - Unreconciled Bank Transactions (suspense)

### Liabilities (2xxx)
- **2110** - Accounts Payable - Suppliers
- **2120** - Customer Deposits

### Revenue (4xxx)
- **4110** - Cake Sales Revenue
- **4120** - Adhoc Sales Revenue
- **4130** - Cancellation Fee Revenue

### Expenses (6xxx)
- **6110** - Bank Charges

---

## 🎓 KEY ACCOUNTING PRINCIPLES

### 1. Revenue Recognition
**Rule**: Revenue is ONLY recognized when:
- Order is completed AND
- Full payment is received

**NOT when**:
- Deposit is paid (deposit = liability)
- Order is created

### 2. Cash vs Bank
**Cash on Hand**:
- Physical cash in register
- Updated immediately on cash transactions
- Should match physical count

**Bank**:
- Deposited funds + card payments
- Updated ONLY after bank reconciliation
- Should match bank statement (after reconciliation)

### 3. Double-Entry Bookkeeping
**Rule**: Every transaction has equal debits and credits

**Verify**: `SUM(Debits) - SUM(Credits) = 0` always

### 4. Customer Deposits
**Rule**: Deposits are LIABILITIES until earned

**Accounting**:
- Receive deposit: CR Customer Deposits (liability increases)
- Complete order: DR Customer Deposits (liability decreases)

### 5. Bank Reconciliation
**Rule**: Bank account updated ONLY when matched to bank statement

**Process**:
1. Transaction initiated (payment pending)
2. Bank statement received
3. Match transaction to statement
4. Update Bank account

---

## 📞 SUPPORT

For accounting questions:
1. Review this guide
2. Check verification queries
3. Review transaction in General Ledger
4. Check Customer/Supplier Ledger Detail
5. Verify bank reconciliation status

**Remember**: All accounting is on the ERP, not the POS. The POS only posts transactions to the ERP database.
