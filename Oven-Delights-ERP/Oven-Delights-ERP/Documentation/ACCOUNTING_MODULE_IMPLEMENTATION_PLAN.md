# COMPREHENSIVE ACCOUNTING MODULE - IMPLEMENTATION PLAN
## Oven Delights ERP System

**Version:** 1.0  
**Date:** March 12, 2026  
**Status:** Implementation Phase  

---

## EXECUTIVE SUMMARY

This document outlines the complete implementation of a proper accounting module based on **existing tables** in the database. No reinventing the wheel - we're building on what exists and fixing what's broken.

### Key Principles
1. **NO SHORTCUTS** - Proper double-entry accounting
2. **USE EXISTING TABLES** - JournalHeaders, JournalLines, ChartOfAccounts already exist
3. **ADD SUBSIDIARY LEDGERS** - Individual supplier/customer accounts
4. **MAINTAIN DATA INTEGRITY** - Every transaction must balance (DR = CR)
5. **FULL AUDIT TRAIL** - Complete history of all transactions

---

## EXISTING DATABASE STRUCTURE

### Tables That Already Exist

#### 1. **JournalHeaders**
```sql
Columns:
- JournalID (int, PK, Identity)
- JournalNumber (varchar(20), NOT NULL)
- JournalDate (date, NOT NULL)
- Reference (nvarchar(50), NULL)
- Description (nvarchar(255), NULL)
- FiscalPeriodID (int, NOT NULL)
- CreatedBy (int, NOT NULL)
- BranchID (int, NOT NULL)
- IsPosted (bit, NULL)
- PostedDate (datetime, NULL)
- PostedBy (int, NULL)
```

#### 2. **JournalLines** (also called JournalDetails in some places)
```sql
Columns:
- JournalLineID (int, PK, Identity)
- JournalID (int, NOT NULL, FK to JournalHeaders)
- LineNumber (int, NOT NULL)
- AccountID (int, NOT NULL, FK to ChartOfAccounts)
- Debit (decimal, NOT NULL)
- Credit (decimal, NOT NULL)
- LineDescription (varchar(256), NULL)
- Reference1 (varchar(100), NULL)
- Reference2 (varchar(100), NULL)
- CostCenterID (int, NULL)
- ProjectID (int, NULL)
- ClearedFlag (bit, NOT NULL)
- StatementRef (varchar(100), NULL)
```

#### 3. **ChartOfAccounts**
```sql
Columns:
- AccountID (int, PK, Identity)
- AccountCode (nvarchar(20), NOT NULL, UNIQUE)
- AccountName (nvarchar(200), NOT NULL)
- AccountType (nvarchar(50), NOT NULL) -- Asset, Liability, Equity, Revenue, Expense
- ParentAccountID (int, NULL)
- IsActive (bit, NOT NULL, DEFAULT 1)
- CreatedDate (datetime, NOT NULL)
- CreatedBy (nvarchar(100), NULL)
- ModifiedDate (datetime, NULL)
- ModifiedBy (nvarchar(100), NULL)
```

#### 4. **SupplierInvoices**
```sql
Columns:
- InvoiceID (int, PK, Identity)
- InvoiceNumber (nvarchar(50), NOT NULL)
- SupplierID (int, NOT NULL) ✅ THIS EXISTS!
- InvoiceDate (date, NOT NULL)
- DueDate (date, NULL)
- TotalAmount (decimal(18,2), NOT NULL)
- AmountPaid (decimal(18,2), NOT NULL, DEFAULT 0)
- AmountDue (computed: TotalAmount - AmountPaid)
- Status (nvarchar(20), NOT NULL, DEFAULT 'Unpaid')
- CreatedBy (nvarchar(100), NOT NULL)
- CreatedDate (datetime, NOT NULL)
```

#### 5. **AP_Invoices** (Accounts Payable Invoices)
```sql
Note: This table exists but does NOT have SupplierID column
Used by the AP module for invoice capture
Needs to be linked to SupplierInvoices or enhanced
```

#### 6. **AP_StatementTransactions** (Bank Statement Transactions)
```sql
Columns include:
- TransactionID
- Description
- Reference
- Amount
- CreditDebitIndicator
- IsMapped (bit)
- MappedLedgerAccount (nvarchar)
- MappedDate (datetime)
- MappedBy (nvarchar)
```

---

## PROBLEMS IDENTIFIED

### 1. **No Subsidiary Ledger System**
- **Problem:** All supplier invoices map to generic "Accounts Payable" control account
- **Impact:** Cannot answer "How much do I owe ABC Suppliers?"
- **Solution:** Create individual supplier ledger accounts (2000-001, 2000-002, etc.)

### 2. **AP_Invoices Missing SupplierID**
- **Problem:** AP_Invoices table has no SupplierID column
- **Impact:** Cannot link invoices to specific suppliers
- **Solution:** Add SupplierID column to AP_Invoices OR use SupplierInvoices table instead

### 3. **Bank Statement Mapping to Categories**
- **Problem:** Bank transactions map to category names, not ledger accounts
- **Impact:** No proper double-entry accounting for bank transactions
- **Solution:** Map to individual supplier ledger accounts

### 4. **LedgerHierarchyForm Using Wrong Column Names**
- **Problem:** Form expects "AccountCode" but table uses "AccountID"
- **Impact:** Hierarchical ledger viewer crashes on load
- **Solution:** Fix queries to use correct column names from existing tables

### 5. **No Control Account Reconciliation**
- **Problem:** No way to verify subsidiary ledgers = control account
- **Impact:** Data integrity cannot be verified
- **Solution:** Create reconciliation views and reports

---

## SOLUTION ARCHITECTURE

### Phase 1: Enhance Chart of Accounts (IMMEDIATE)

**Add columns to ChartOfAccounts:**
```sql
- IsControlAccount (bit) -- TRUE for 2000 Accounts Payable
- IsSubsidiaryLedger (bit) -- TRUE for 2000-001, 2000-002, etc.
- ControlAccountID (int) -- Links subsidiary to control account
- SupplierID (int, NULL) -- Links ledger account to supplier
- CustomerID (int, NULL) -- Links ledger account to customer
```

**Create subsidiary ledger accounts for each supplier:**
```sql
-- Example:
-- 2000 - Accounts Payable (Control Account)
-- 2000-001 - ABC Suppliers (Subsidiary Ledger, linked to SupplierID=1)
-- 2000-002 - XYZ Trading (Subsidiary Ledger, linked to SupplierID=2)
-- 2000-003 - Eskom (Subsidiary Ledger, linked to SupplierID=3)
```

### Phase 2: Fix AP_Invoices Table (IMMEDIATE)

**Option A: Add SupplierID to AP_Invoices**
```sql
ALTER TABLE AP_Invoices ADD SupplierID INT NULL
ALTER TABLE AP_Invoices ADD CONSTRAINT FK_APInvoices_Supplier 
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
```

**Option B: Use SupplierInvoices table (RECOMMENDED)**
- SupplierInvoices already has SupplierID
- Already has proper structure
- Migrate AP_Invoices data to SupplierInvoices

### Phase 3: Create Supplier Ledger Accounts (IMMEDIATE)

**Stored Procedure: sp_CreateSupplierLedgerAccount**
```sql
-- Automatically creates ledger account for new supplier
-- Format: 2000-XXX where XXX is sequential
-- Links to SupplierID
-- Sets IsSubsidiaryLedger = 1
-- Sets ControlAccountID = (AccountID of 2000)
```

### Phase 4: Update Bank Statement Integration (IMMEDIATE)

**Fix BankStatementViewerForm.vb:**
1. When invoice matched, get supplier's ledger account
2. Create journal entry:
   ```
   DR 2000-001 - ABC Suppliers (Supplier's ledger)
   CR 1120 - Bank Account
   ```
3. Post to both General Ledger and update supplier balance

### Phase 5: Fix Hierarchical Ledger Viewer (IMMEDIATE)

**Update LedgerHierarchyForm.vb:**
1. Use correct column names (AccountID, not AccountCode)
2. Query JournalLines properly
3. Show drill-down:
   - Level 1: Categories (Assets, Liabilities, etc.)
   - Level 2: Accounts (with balances from JournalLines)
   - Level 3: Transactions (from JournalLines with JournalHeaders)

### Phase 6: Create Reconciliation Views (NEXT)

**View: vw_SubsidiaryLedgerReconciliation**
```sql
-- Shows control account balance vs sum of subsidiary ledgers
-- Must always balance!
```

**View: vw_SupplierBalances**
```sql
-- Shows each supplier's current balance from their ledger account
```

---

## IMPLEMENTATION STEPS

### Step 1: Enhance ChartOfAccounts Table
**File:** `Database/01_ENHANCE_CHART_OF_ACCOUNTS.sql`
- Add new columns
- Update existing accounts
- Mark 2000 as control account

### Step 2: Create Supplier Ledger Accounts
**File:** `Database/02_CREATE_SUPPLIER_LEDGER_ACCOUNTS.sql`
- Create ledger account for each existing supplier
- Format: 2000-001, 2000-002, etc.
- Link to SupplierID

### Step 3: Fix AP_Invoices Table
**File:** `Database/03_FIX_AP_INVOICES_TABLE.sql`
- Add SupplierID column
- Migrate data from SupplierInvoices if needed
- Add foreign key constraint

### Step 4: Update Bank Statement Service
**File:** `Forms/Accounting/BankStatementViewerForm.vb`
- Fix invoice matching to use supplier ledger accounts
- Update journal entry creation
- Post to correct accounts

### Step 5: Fix Hierarchical Ledger Viewer
**File:** `Forms/Accounting/LedgerHierarchyForm.vb`
- Use correct table/column names
- Fix queries for existing structure
- Implement proper drill-down

### Step 6: Create Reconciliation Views
**File:** `Database/04_CREATE_RECONCILIATION_VIEWS.sql`
- vw_SubsidiaryLedgerReconciliation
- vw_SupplierBalances
- vw_CustomerBalances

### Step 7: Create Stored Procedures
**File:** `Database/05_CREATE_ACCOUNTING_PROCEDURES.sql`
- sp_CreateSupplierLedgerAccount
- sp_PostSupplierInvoice
- sp_PostSupplierPayment
- sp_ReconcileSubsidiaryLedgers

---

## TESTING PLAN

### Test 1: Supplier Ledger Creation
1. Add new supplier
2. Verify ledger account created automatically
3. Verify link to SupplierID

### Test 2: Invoice Posting
1. Capture supplier invoice
2. Verify journal entry created
3. Verify posted to supplier's ledger account
4. Verify control account balance = sum of subsidiary ledgers

### Test 3: Bank Statement Matching
1. Import bank statement
2. Auto-map invoice payment
3. Verify journal entry created
4. Verify supplier ledger balance reduced
5. Verify bank account balance reduced

### Test 4: Hierarchical Ledger Viewer
1. Open ledger viewer
2. Drill down to Liabilities
3. Drill down to Accounts Payable
4. View individual supplier ledgers
5. View transaction detail

### Test 5: Reconciliation
1. Run reconciliation view
2. Verify control account = sum of subsidiaries
3. Identify any discrepancies

---

## SQL SCRIPTS TO RUN (IN ORDER)

1. **01_ENHANCE_CHART_OF_ACCOUNTS.sql** - Add columns to ChartOfAccounts
2. **02_CREATE_SUPPLIER_LEDGER_ACCOUNTS.sql** - Create ledger for each supplier
3. **03_FIX_AP_INVOICES_TABLE.sql** - Add SupplierID to AP_Invoices
4. **04_CREATE_RECONCILIATION_VIEWS.sql** - Create views for balances
5. **05_CREATE_ACCOUNTING_PROCEDURES.sql** - Create stored procedures

---

## SUCCESS CRITERIA

✅ Every supplier has individual ledger account  
✅ Bank payments post to supplier ledgers  
✅ Control account balance = sum of subsidiary ledgers  
✅ Hierarchical ledger viewer works without errors  
✅ Can drill down from categories to transactions  
✅ Full audit trail maintained  
✅ Double-entry accounting enforced (DR = CR)  

---

## NEXT STEPS AFTER IMPLEMENTATION

1. **Customer Ledgers** - Same pattern for Accounts Receivable
2. **Financial Statements** - Balance Sheet, Income Statement
3. **Trial Balance** - Verify all accounts balance
4. **Period Close** - Month-end/year-end procedures
5. **SARS Compliance** - VAT returns, tax reports

---

**STATUS: READY FOR IMPLEMENTATION**

All SQL scripts will be created and ready to run.
All code fixes will be implemented.
Full testing checklist provided.

**ESTIMATED TIME: 2-3 hours for complete implementation**
