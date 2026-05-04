# Accounting Database Schema Reference

## Key Tables for Ledger Hierarchy

### 1. SupplierLedger
**Purpose:** Tracks all supplier transactions (Accounts Payable subsidiary ledger)

| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| LedgerID | int | NO | Primary key |
| SupplierID | int | NO | Links to Suppliers table |
| SupplierName | nvarchar(200) | NO | Denormalized for performance |
| SupplierCode | nvarchar(50) | YES | Supplier reference code |
| TransactionDate | datetime | NO | When transaction occurred |
| TransactionType | nvarchar(50) | NO | e.g., 'Invoice', 'Payment', 'Credit Note' |
| ReferenceNumber | nvarchar(100) | YES | Invoice/payment reference |
| Description | nvarchar(500) | YES | Transaction description |
| DebitAmount | decimal | NO | Amount debited (reduces liability) |
| CreditAmount | decimal | NO | Amount credited (increases liability) |
| RunningBalance | decimal | NO | Current balance for supplier |
| BranchID | int | NO | Branch where transaction occurred |
| CreatedBy | nvarchar(100) | YES | User who created entry |
| CreatedDate | datetime | NO | When entry was created |

**Query Pattern for LoadLedgers (Accounts Payable):**
```sql
SELECT 
    sl.SupplierID AS LedgerID,
    'Supplier' AS LedgerType,
    sl.SupplierCode AS LedgerCode,
    sl.SupplierName AS LedgerName,
    ISNULL(SUM(sl.DebitAmount), 0) AS TotalDebit,
    ISNULL(SUM(sl.CreditAmount), 0) AS TotalCredit,
    ISNULL(MAX(sl.RunningBalance), 0) AS Balance
FROM SupplierLedger sl
GROUP BY sl.SupplierID, sl.SupplierCode, sl.SupplierName
ORDER BY sl.SupplierName
```

**Query Pattern for LoadLedgerDetails (Supplier drill-down):**
```sql
SELECT 
    TransactionDate,
    TransactionType,
    ReferenceNumber AS Reference,
    Description,
    DebitAmount,
    CreditAmount,
    RunningBalance AS Balance
FROM SupplierLedger
WHERE SupplierID = @SupplierID
    AND TransactionDate BETWEEN @FromDate AND @ToDate
ORDER BY TransactionDate, LedgerID
```

---

### 2. CustomerLedger
**Purpose:** Tracks all customer transactions (Accounts Receivable subsidiary ledger)

| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| LedgerID | bigint | NO | Primary key |
| CustomerID | int | NO | Links to POS_Customers table |
| CustomerName | nvarchar(200) | NO | Denormalized for performance |
| AccountNumber | nvarchar(50) | NO | Customer account number |
| TransactionDate | datetime | NO | When transaction occurred |
| TransactionType | nvarchar(50) | NO | e.g., 'Sale', 'Payment', 'Credit' |
| ReferenceNumber | nvarchar(100) | NO | Invoice/payment reference |
| Description | nvarchar(500) | NO | Transaction description |
| DebitAmount | decimal | NO | Amount debited (increases receivable) |
| CreditAmount | decimal | NO | Amount credited (reduces receivable) |
| RunningBalance | decimal | NO | Current balance for customer |
| BranchID | int | NO | Branch where transaction occurred |
| CreatedBy | nvarchar(100) | NO | User who created entry |
| CreatedDate | datetime | NO | When entry was created |

**Query Pattern for LoadLedgers (Accounts Receivable):**
```sql
SELECT 
    cl.CustomerID AS LedgerID,
    'Customer' AS LedgerType,
    cl.AccountNumber AS LedgerCode,
    cl.CustomerName AS LedgerName,
    ISNULL(SUM(cl.DebitAmount), 0) AS TotalDebit,
    ISNULL(SUM(cl.CreditAmount), 0) AS TotalCredit,
    ISNULL(MAX(cl.RunningBalance), 0) AS Balance
FROM CustomerLedger cl
GROUP BY cl.CustomerID, cl.AccountNumber, cl.CustomerName
ORDER BY cl.CustomerName
```

**Query Pattern for LoadLedgerDetails (Customer drill-down):**
```sql
SELECT 
    TransactionDate,
    TransactionType,
    ReferenceNumber AS Reference,
    Description,
    DebitAmount,
    CreditAmount,
    RunningBalance AS Balance
FROM CustomerLedger
WHERE CustomerID = @CustomerID
    AND TransactionDate BETWEEN @FromDate AND @ToDate
ORDER BY TransactionDate, LedgerID
```

---

### 3. JournalHeaders
**Purpose:** Header information for journal entries

| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| JournalID | int | NO | Primary key |
| JournalNumber | varchar(20) | NO | Unique journal number |
| JournalDate | date | NO | Date of journal entry |
| Reference | nvarchar(50) | YES | External reference (e.g., invoice number) |
| Description | nvarchar(255) | YES | Journal entry description |
| FiscalPeriodID | int | NO | Links to fiscal period |
| CreatedBy | int | NO | User who created entry |
| BranchID | int | NO | Branch where entry was created |
| IsPosted | bit | YES | Whether entry is posted |
| PostedDate | datetime | YES | When entry was posted |
| PostedBy | int | YES | User who posted entry |

---

### 4. JournalDetails
**Purpose:** Line items for journal entries (debits and credits)

| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| JournalDetailID | int | NO | Primary key |
| JournalID | int | NO | Links to JournalHeaders |
| LineNumber | int | NO | Line sequence number |
| AccountID | int | NO | Links to ChartOfAccounts |
| Debit | decimal | YES | Debit amount (NULL = 0) |
| Credit | decimal | YES | Credit amount (NULL = 0) |
| Description | nvarchar(255) | YES | Line description |
| Reference1 | nvarchar(50) | YES | Additional reference |
| Reference2 | nvarchar(50) | YES | Additional reference |
| CostCenterID | int | YES | Cost center allocation |
| ProjectID | int | YES | Project allocation |

**Query Pattern for LoadTransactions (Non-control accounts):**
```sql
SELECT 
    jh.JournalID,
    jh.JournalDate,
    jh.JournalNumber,
    jh.Reference,
    jh.Description,
    jd.Debit AS DebitAmount,
    jd.Credit AS CreditAmount
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jd.AccountID = @AccountID
    AND jh.JournalDate BETWEEN @FromDate AND @ToDate
ORDER BY jh.JournalDate, jh.JournalID, jd.LineNumber
```

---

### 5. ChartOfAccounts
**Purpose:** Master list of all general ledger accounts

| Column | Type | Nullable | Notes |
|--------|------|----------|-------|
| AccountID | int | NO | Primary key |
| AccountCode | nvarchar(20) | NO | Unique account code (e.g., '2100', '5220') |
| AccountName | nvarchar(200) | NO | Account name (e.g., 'Accounts Payable', 'Rent Expense') |
| AccountType | nvarchar(50) | NO | Asset, Liability, Equity, Income, Expense |
| ParentAccountCode | nvarchar(20) | YES | Parent account for hierarchy |
| IsActive | bit | NO | Whether account is active |
| IsSubsidiaryLedger | bit | NO | Whether this is a subsidiary ledger account |
| IsControlAccount | bit | NO | **CRITICAL:** Whether this account has subsidiary ledgers |
| NormalBalance | nvarchar(2) | YES | 'DR' or 'CR' |
| Description | nvarchar(500) | YES | Account description |

**Key Control Accounts:**
- **2100** - Accounts Payable (IsControlAccount = 1) → Uses SupplierLedger
- **1200** - Accounts Receivable (IsControlAccount = 1) → Uses CustomerLedger
- **All others** - Non-control accounts → Use JournalDetails

---

## Critical Rules for Ledger Hierarchy Form

### 1. LoadCategories (Initial View)
Shows all Chart of Accounts with balances:
- **Accounts Payable (2100):** Balance from `SUM(CreditAmount - DebitAmount)` in SupplierLedger
- **Accounts Receivable (1200):** Balance from `SUM(DebitAmount - CreditAmount)` in CustomerLedger
- **All other accounts:** Balance from JournalDetails

### 2. LoadLedgers (Drill-down from account)
Determines routing based on `IsControlAccount`:
- **If IsControlAccount = 1 AND AccountCode = '2100':** Query SupplierLedger, group by SupplierID
- **If IsControlAccount = 1 AND AccountCode = '1200':** Query CustomerLedger, group by CustomerID
- **If IsControlAccount = 0:** Call LoadTransactions (show journal entries)

### 3. LoadLedgerDetails (Drill-down from supplier/customer)
Shows individual transactions:
- **For Supplier:** Query SupplierLedger WHERE SupplierID = @SupplierID
- **For Customer:** Query CustomerLedger WHERE CustomerID = @CustomerID

### 4. LoadTransactions (Non-control accounts)
Shows journal entries:
- Query JournalDetails + JournalHeaders WHERE AccountID = @AccountID
- Calculate running balance based on account's normal balance type

---

## Common Issues & Solutions

### Issue: Blank Screen
**Cause:** `dgvMain` not visible or behind other controls
**Solution:** Add `dgvMain.Visible = True` and `dgvMain.BringToFront()` after binding data

### Issue: Invalid Object Name 'Customers'
**Cause:** Table is named `POS_Customers`, not `Customers`
**Solution:** Use columns directly from CustomerLedger (CustomerName, AccountNumber already exist)

### Issue: Invalid Column Name 'Reference'
**Cause:** Column is named `ReferenceNumber` in SupplierLedger/CustomerLedger
**Solution:** Use `ReferenceNumber AS Reference` in SELECT

### Issue: Foreign Key Constraint on CategoryID
**Cause:** AP_Invoices.CategoryID has FK to AP_Categories, but we're passing AccountID
**Solution:** Drop FK constraint: `ALTER TABLE AP_Invoices DROP CONSTRAINT FK_Invoice_Category`

### Issue: VAT Input Account Not Found
**Cause:** sp_AP_PostAdhocInvoiceToGL requires account 2021, but only 2200 (VAT Output) exists
**Solution:** Make VAT posting conditional: `IF @VATAmount > 0 BEGIN ... END`

---

## Invoice Posting Flow

1. **Invoice Capture** → Saves to `AP_Invoices` with `AccountID` (from ChartOfAccounts)
2. **GL Posting** → Calls `sp_AP_PostAdhocInvoiceToGL`
3. **Journal Entry Created:**
   - DR: Expense Account (e.g., 5220 Rent Expense) - Subtotal
   - DR: VAT Account (2200) - VAT Amount (if > 0)
   - CR: Accounts Payable (2100) - Total Amount
4. **Supplier Ledger Updated** → SupplierLedger entry created with CreditAmount = Total

---

## Required Fields for Each Query

### SupplierLedger (LoadLedgers)
- SupplierID, SupplierCode, SupplierName, DebitAmount, CreditAmount, RunningBalance

### SupplierLedger (LoadLedgerDetails)
- TransactionDate, TransactionType, ReferenceNumber, Description, DebitAmount, CreditAmount, RunningBalance

### CustomerLedger (LoadLedgers)
- CustomerID, AccountNumber, CustomerName, DebitAmount, CreditAmount, RunningBalance

### CustomerLedger (LoadLedgerDetails)
- TransactionDate, TransactionType, ReferenceNumber, Description, DebitAmount, CreditAmount, RunningBalance

### JournalDetails (LoadTransactions)
- JournalID, JournalDate, JournalNumber, Reference, Description, Debit, Credit
- **Must calculate Balance column in code** (running balance based on normal balance type)
