# ACCOUNTING SYSTEM - USER INSTRUCTIONS

## Overview
The comprehensive accounting system tracks all cake order transactions using proper double-entry bookkeeping. All financial data is stored in the ERP database and viewed through the ERP application.

---

## SETUP INSTRUCTIONS

### Step 1: Create Database Schema
1. Open SQL Server Management Studio
2. Connect to your database server
3. Open the file: `Database\CREATE_ACCOUNTING_SYSTEM.sql`
4. Execute the script to create:
   - ChartOfAccounts table
   - GeneralLedger table
   - CustomerLedger table
   - CashRegister table
   - BankDeposits table
   - Stored procedures and views

### Step 2: Verify Schema Creation
Run this query to verify tables were created:
```sql
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME IN ('ChartOfAccounts', 'GeneralLedger', 'CustomerLedger', 'CashRegister', 'BankDeposits')
ORDER BY TABLE_NAME
```

You should see all 5 tables listed.

---

## HOW TO ACCESS FINANCIAL DASHBOARDS

### Option 1: From ERP Main Menu
1. Open Oven Delights ERP
2. Navigate to: **Accounting** → **Financial Dashboard**
3. The dashboard will display:
   - 💵 Cash on Hand (physical cash in register)
   - 🏦 Bank Balance (deposited funds + card payments)
   - 📊 Accounts Receivable (customers who owe us)
   - 💳 Customer Deposits (liability - deposits we're holding)

### Option 2: Direct Access
The Financial Dashboard shows:
- **Summary Cards**: Real-time balances for Cash, Bank, Receivables, Deposits
- **Recent Transactions**: Last 20 general ledger entries
- **Customer Balances**: All customers with outstanding balances

---

## VIEWING LEDGERS

### 1. GENERAL LEDGER
**Purpose**: View all accounting transactions across all accounts

**How to Access**:
1. From Financial Dashboard → Click **"📒 VIEW GENERAL LEDGER"**
2. Or from ERP menu: **Accounting** → **General Ledger**

**Features**:
- Filter by date range (From/To)
- Filter by specific account
- View debits, credits, descriptions, references
- See running totals at bottom
- Export to Excel (coming soon)

**Columns Displayed**:
- Date
- Journal Entry Number
- Account Code
- Account Name
- Description
- Debit Amount
- Credit Amount
- Transaction Type
- Reference Number
- User

### 2. CUSTOMER LEDGER
**Purpose**: View all customer account balances and who owes money

**How to Access**:
1. From Financial Dashboard → Click **"👥 CUSTOMER LEDGERS"**
2. Or from ERP menu: **Accounting** → **Customer Ledgers**

**Features**:
- Search by account number or customer name
- View current balance for each customer
- See status: Receivable (they owe us), Payable (we owe them), Settled
- View last activity date
- Transaction count per customer
- Totals: Total Receivables vs Total Payables

**Color Coding**:
- **Orange**: Customer owes us money (Receivable)
- **Red**: We owe customer money (Payable - rare, usually from overpayment or cancellation)
- **Green**: Account settled (balance = 0)

### 3. CUSTOMER LEDGER DETAIL
**Purpose**: View detailed transaction history for a specific customer

**How to Access**:
1. From Customer Ledger Viewer → **Double-click any customer row**
2. Or search for customer and double-click

**Features**:
- Complete transaction history in chronological order
- Running balance after each transaction
- Debits (charges to customer)
- Credits (payments from customer)
- Transaction types: Order, Deposit, Payment, Edit, Cancellation, Refund
- Reference numbers (order numbers)
- User who processed each transaction

**Print Statement**:
- Click **"🖨️ Print Statement"** to generate customer statement (coming soon)

---

## TRANSACTION TYPES EXPLAINED

### 1. NEW CAKE ORDER (Deposit Paid)
**What Happens**:
- Customer pays deposit (e.g., R50 on R300 order)
- POS records deposit in `POS_CustomOrders`
- Accounting Service posts to ERP:

**Accounting Entries**:
```
IF CASH:
  DR: Cash on Hand          R50
  CR: Customer Deposits     R50

IF CARD:
  DR: Bank                  R50
  CR: Customer Deposits     R50

Customer Ledger:
  DR: Customer Account      R300  (total order amount)
  CR: Customer Account      R50   (deposit paid)
  Running Balance:          R250  (customer owes)
```

**Where to View**:
- General Ledger: Shows Cash/Bank debit and Customer Deposits credit
- Customer Ledger: Shows customer owes R250 balance

### 2. ORDER EDIT (Price Change)
**What Happens**:
- Customer changes order (e.g., from R300 to R350)
- Accounting Service adjusts receivable

**Accounting Entries**:
```
Customer Ledger:
  DR: Customer Account      R50   (additional amount)
  Running Balance:          R300  (R250 + R50)
```

**Where to View**:
- Customer Ledger Detail: Shows "Edit" transaction with R50 debit

### 3. ORDER COLLECTION (Balance Payment)
**What Happens**:
- Customer collects order and pays balance (e.g., R250)
- Revenue is recognized (this is when the sale happens!)

**Accounting Entries**:
```
IF CASH:
  DR: Cash on Hand          R250
  DR: Customer Deposits     R50   (clear liability)
  CR: Cake Sales Revenue    R300  (full order amount)

IF CARD:
  DR: Bank                  R250
  DR: Customer Deposits     R50
  CR: Cake Sales Revenue    R300

Customer Ledger:
  CR: Customer Account      R250  (balance payment)
  CR: Customer Account      R50   (deposit applied)
  DR: Customer Account      R300  (order completed)
  Running Balance:          R0    (settled)
```

**Where to View**:
- General Ledger: Shows revenue recognition (CR: Cake Sales Revenue R300)
- Customer Ledger: Shows balance = R0 (settled)

### 4. ORDER CANCELLATION
**What Happens**:
- Customer cancels order
- Cancellation fee charged (e.g., R30)
- Refund or additional payment processed

**Scenario A: Refund to Customer** (Deposit R50, Fee R30, Refund R20)
```
DR: Customer Deposits     R50   (clear liability)
CR: Cancellation Fee Rev  R30   (revenue)
CR: Cash/Bank             R20   (refund)

Customer Ledger:
  DR: Customer Account      R30   (cancellation fee)
  CR: Customer Account      R20   (refund)
  Running Balance:          R0    (settled)
```

**Scenario B: Customer Pays More** (Deposit R50, Fee R80, Customer pays R30)
```
DR: Cash/Bank             R30   (additional payment)
DR: Customer Deposits     R50   (clear liability)
CR: Cancellation Fee Rev  R80   (revenue)

Customer Ledger:
  DR: Customer Account      R80   (cancellation fee)
  CR: Customer Account      R30   (payment)
  Running Balance:          R0    (settled)
```

**Where to View**:
- General Ledger: Shows cancellation fee revenue
- Customer Ledger: Shows cancellation and refund/payment

---

## VERIFYING TRANSACTIONS ARE CORRECT

### Daily Verification Checklist

#### 1. Check Cash on Hand vs Physical Cash
```sql
-- Run this query to get Cash on Hand balance
SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) AS CashOnHand
FROM GeneralLedger gl
INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode = '1110' AND gl.IsReversed = 0
```
- Compare to physical cash count in register
- Should match exactly

#### 2. Check Bank Balance
```sql
-- Run this query to get Bank balance
SELECT ISNULL(SUM(DebitAmount - CreditAmount), 0) AS BankBalance
FROM GeneralLedger gl
INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode = '1120' AND gl.IsReversed = 0
```
- Compare to bank statement
- Card payments go directly here

#### 3. Verify Customer Deposits Match Orders
```sql
-- Get total customer deposits (liability)
SELECT ISNULL(SUM(CreditAmount - DebitAmount), 0) AS TotalDepositsHeld
FROM GeneralLedger gl
INNER JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode = '2120' AND gl.IsReversed = 0

-- Get total deposits from active orders
SELECT SUM(DepositPaid) AS TotalOrderDeposits
FROM POS_CustomOrders
WHERE OrderStatus IN ('New', 'InProgress', 'Ready')
```
- These two amounts should match
- If not, investigate discrepancies

#### 4. Check Double-Entry Balance
```sql
-- This should ALWAYS equal 0 (debits = credits)
SELECT SUM(DebitAmount) - SUM(CreditAmount) AS Balance
FROM GeneralLedger
WHERE IsReversed = 0
```
- If not 0, there's an accounting error

#### 5. Verify Customer Balances
```sql
-- Get customers with outstanding balances
SELECT 
    AccountNumber,
    CustomerName,
    RunningBalance,
    CASE 
        WHEN RunningBalance > 0 THEN 'Customer Owes Us'
        WHEN RunningBalance < 0 THEN 'We Owe Customer'
        ELSE 'Settled'
    END AS Status
FROM (
    SELECT 
        AccountNumber,
        CustomerName,
        RunningBalance,
        ROW_NUMBER() OVER (PARTITION BY AccountNumber ORDER BY LedgerID DESC) AS rn
    FROM CustomerLedger
) AS Latest
WHERE rn = 1 AND RunningBalance <> 0
ORDER BY ABS(RunningBalance) DESC
```

---

## PRINTING REPORTS

### Financial Dashboard
1. Open Financial Dashboard
2. Click **"🔄 REFRESH"** to get latest data
3. Take screenshot or use Print Screen for management review

### General Ledger Report
1. Open General Ledger Viewer
2. Set date range (e.g., start of month to today)
3. Select account or leave as "All Accounts"
4. Click **"🔍 Filter"**
5. Click **"📊 Export"** (coming soon - will export to Excel)

### Customer Statement
1. Open Customer Ledger Viewer
2. Search for customer
3. Double-click customer row
4. Click **"🖨️ Print Statement"** (coming soon)

---

## TROUBLESHOOTING

### Issue: Accounting entries not appearing
**Solution**:
1. Check if `CREATE_ACCOUNTING_SYSTEM.sql` was executed
2. Verify POS has correct connection string to ERP database
3. Check for error messages in POS when creating/editing orders

### Issue: Balances don't match
**Solution**:
1. Run verification queries above
2. Check for duplicate entries (same journal number)
3. Look for reversed entries (IsReversed = 1)

### Issue: Customer balance incorrect
**Solution**:
1. Open Customer Ledger Detail for that customer
2. Review transaction history
3. Check running balance progression
4. Verify order amounts in `POS_CustomOrders`

---

## IMPORTANT NOTES

1. **Revenue Recognition**: Revenue is ONLY recognized when order is collected, NOT when deposit is paid
2. **Deposits are Liabilities**: Customer deposits are recorded as liabilities until order is completed
3. **Cash vs Bank**: Cash payments stay in "Cash on Hand" until deposited to bank
4. **Card Payments**: Card/EFT payments go directly to "Bank" account
5. **Customer Ledger**: Positive balance = customer owes us, Negative balance = we owe customer

---

## SUPPORT

For issues or questions:
1. Check this document first
2. Review transaction in General Ledger
3. Check Customer Ledger Detail for specific customer issues
4. Run verification queries to identify discrepancies
