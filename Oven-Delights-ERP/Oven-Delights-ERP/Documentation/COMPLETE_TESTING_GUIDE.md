# COMPLETE TESTING GUIDE - ACCOUNTING MODULE

## 📋 **PRE-TESTING SETUP**

### **STEP 1: Run Database Scripts (IN ORDER)**

Execute these scripts in SQL Server Management Studio:

```sql
-- 1. Enhance Chart of Accounts with subsidiary ledger support
-- File: 01_ENHANCE_CHART_OF_ACCOUNTS.sql

-- 2. Create supplier ledger accounts for all existing suppliers
-- File: 02_CREATE_SUPPLIER_LEDGER_ACCOUNTS.sql

-- 3. Fix AP_Invoices table (add SupplierID and LedgerAccountCode)
-- File: 03_FIX_AP_INVOICES_TABLE.sql

-- 4. Create reconciliation views
-- File: 04_CREATE_RECONCILIATION_VIEWS.sql

-- 5. Create accounting stored procedures
-- File: 05_CREATE_ACCOUNTING_PROCEDURES.sql

-- 6. Create all subsidiary ledgers (customers, tenants, landlords)
-- File: 06_CREATE_ALL_SUBSIDIARY_LEDGERS.sql

-- 7. Update reconciliation views for all ledger types
-- File: 07_UPDATE_RECONCILIATION_VIEWS_ALL.sql

-- 8. Create all posting procedures
-- File: 08_CREATE_ALL_POSTING_PROCEDURES.sql

-- 9. Create simple expense/income accounts
-- File: 09_CREATE_SIMPLE_EXPENSE_INCOME_ACCOUNTS.sql
```

---

### **STEP 2: Verify Database Setup**

Run these queries to confirm everything is set up correctly:

#### **A. Check Chart of Accounts Structure**
```sql
-- Should show hierarchical structure with parent/child relationships
SELECT 
    AccountCode,
    AccountName,
    ParentAccountCode,
    AccountType,
    IsSubsidiaryLedger,
    SupplierID,
    CustomerID
FROM ChartOfAccounts
ORDER BY AccountCode;
```

**Expected Results:**
- Main accounts: 1000, 2000, 3000, 4000, 5000
- Subsidiary ledgers: 2100-001, 2100-002, etc. (suppliers)
- Customer ledgers: 1200-001, 1200-002, etc.

---

#### **B. Check Supplier Ledger Accounts Created**
```sql
-- Should show one ledger account per supplier
SELECT 
    coa.AccountCode,
    coa.AccountName,
    s.CompanyName,
    coa.IsSubsidiaryLedger
FROM ChartOfAccounts coa
INNER JOIN Suppliers s ON coa.SupplierID = s.SupplierID
WHERE coa.ParentAccountCode = '2100'
ORDER BY coa.AccountCode;
```

**Expected Results:**
- One row per supplier
- AccountCode format: 2100-001, 2100-002, etc.
- IsSubsidiaryLedger = 1

---

#### **C. Check Stored Procedures Exist**
```sql
-- Should show all accounting procedures
SELECT 
    ROUTINE_NAME,
    ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME LIKE 'sp_Post%' OR ROUTINE_NAME LIKE 'sp_Create%'
ORDER BY ROUTINE_NAME;
```

**Expected Procedures:**
- sp_PostSupplierInvoice
- sp_PostSupplierPayment
- sp_PostCustomerInvoice
- sp_PostCustomerPayment
- sp_CreateSupplierLedgerAccount
- sp_CreateCustomerLedgerAccount

---

#### **D. Check Views Exist**
```sql
-- Should show all reconciliation views
SELECT 
    TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME LIKE 'vw_%'
ORDER BY TABLE_NAME;
```

**Expected Views:**
- vw_SupplierBalances
- vw_CustomerBalances
- vw_SubsidiaryLedgerReconciliation
- vw_TrialBalance
- vw_DetailedLedgerTransactions

---

### **STEP 3: Rebuild Application**

1. Open solution in Visual Studio
2. Build → Rebuild Solution
3. Fix any compilation errors (should be none)
4. Run application to verify it starts

---

## 🧪 **TEST SCENARIO 1: SUPPLIER INVOICE CAPTURE**

### **Test Steps:**

1. **Launch Application**
2. **Navigate:** Stockroom → Invoice & GRV Processing
3. **Select Supplier:** Choose "To Shop" (or any supplier)
4. **Select Purchase Order:** Choose an existing PO
5. **Capture Invoice:**
   - Invoice Number: INV-TEST-001
   - Invoice Date: Today
   - Amount: R5,000.00
6. **Save Invoice**

---

### **Verification Queries:**

#### **A. Check Invoice Saved**
```sql
SELECT TOP 1 
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    TotalAmount,
    InvoiceDate
FROM SupplierInvoices
WHERE InvoiceNumber = 'INV-TEST-001'
ORDER BY InvoiceID DESC;
```

**Expected:** One row with invoice details

---

#### **B. Check Journal Entry Created**
```sql
-- Get the journal entry for this invoice
SELECT 
    jh.JournalID,
    jh.JournalNumber,
    jh.JournalDate,
    jh.Description,
    jh.JournalType
FROM JournalHeaders jh
WHERE jh.Description LIKE '%INV-TEST-001%'
ORDER BY jh.JournalID DESC;
```

**Expected:** One journal header with description containing invoice number

---

#### **C. Check Journal Lines (Detailed Entries)**
```sql
-- Replace @JournalID with the JournalID from previous query
DECLARE @JournalID INT = (SELECT TOP 1 JournalID FROM JournalHeaders WHERE Description LIKE '%INV-TEST-001%' ORDER BY JournalID DESC);

SELECT 
    jl.LineNumber,
    coa.AccountCode,
    coa.AccountName,
    jl.Debit,
    jl.Credit,
    jl.Description
FROM JournalLines jl
INNER JOIN ChartOfAccounts coa ON jl.AccountID = coa.AccountID
WHERE jl.JournalID = @JournalID
ORDER BY jl.LineNumber;
```

**Expected Results:**
```
Line 1: DR 1200 - Inventory          R4,347.83
Line 2: DR 1300 - VAT Input          R652.17
Line 3: CR 2100-XXX - Supplier       R5,000.00
```

---

#### **D. Check Supplier Ledger Balance**
```sql
-- Check supplier balance increased
SELECT 
    SupplierName,
    TotalInvoices,
    TotalPayments,
    Balance
FROM vw_SupplierBalances
WHERE SupplierName LIKE '%To Shop%';
```

**Expected:** Balance = R5,000.00 CR (you owe supplier)

---

## 🧪 **TEST SCENARIO 2: BULK PAYMENT PROCESSING**

### **Test Steps:**

1. **Navigate:** Accounting → Batch Payments
2. **Select Invoices:** Check the invoice created in Test 1
3. **Create Batch:** Click "Create Payment Batch"
4. **Submit to FNB:** Click "Submit Batch"
5. **Wait for Confirmation:** FNB should confirm payment sent
6. **Check Status:** Should show "Completed - Awaiting bank statement"

---

### **Verification Queries:**

#### **A. Check Payment Batch Created**
```sql
SELECT TOP 1
    BatchID,
    BatchNumber,
    TotalAmount,
    Status,
    CreatedDate
FROM AP_PaymentBatches
ORDER BY BatchID DESC;
```

**Expected:** Status = "Completed"

---

#### **B. Check NO Journal Entry Created Yet**
```sql
-- Should NOT find journal entry for payment yet
SELECT COUNT(*) AS PaymentJournalCount
FROM JournalHeaders
WHERE Description LIKE '%Payment%' 
  AND JournalDate = CAST(GETDATE() AS DATE)
  AND Description LIKE '%INV-TEST-001%';
```

**Expected:** PaymentJournalCount = 0 (no payment journal yet)

---

#### **C. Check Supplier Balance Unchanged**
```sql
-- Supplier balance should still show amount owed
SELECT 
    SupplierName,
    Balance
FROM vw_SupplierBalances
WHERE SupplierName LIKE '%To Shop%';
```

**Expected:** Balance = R5,000.00 CR (still owe - no change yet)

---

## 🧪 **TEST SCENARIO 3: BANK STATEMENT IMPORT**

### **Test Steps:**

1. **Navigate:** Accounting → Bank Statement Viewer
2. **Import Statement:** Click "Import from FNB"
3. **Wait for Import:** Statement transactions loaded
4. **Auto-Map:** Click "Auto-Map Transactions"
5. **Verify Mapping:** Check that payment to supplier was mapped

---

### **Verification Queries:**

#### **A. Check Bank Statement Transactions Imported**
```sql
SELECT TOP 10
    TransactionID,
    TransactionDate,
    Description,
    Reference,
    Amount,
    CreditDebitIndicator,
    IsMapped,
    MappedLedgerAccount
FROM AP_StatementTransactions
ORDER BY TransactionID DESC;
```

**Expected:** Transactions imported with IsMapped = 0 initially

---

#### **B. Check Payment Transaction Mapped**
```sql
-- Find the payment transaction
SELECT 
    TransactionID,
    Description,
    Reference,
    Amount,
    IsMapped,
    MappedLedgerAccount,
    MappedBy
FROM AP_StatementTransactions
WHERE Description LIKE '%To Shop%' 
   OR Reference LIKE '%INV-TEST-001%'
ORDER BY TransactionID DESC;
```

**Expected:** 
- IsMapped = 1
- MappedLedgerAccount = "2100-XXX - To Shop"

---

#### **C. Check Payment Journal Entry Created**
```sql
-- Now payment journal should exist
SELECT 
    jh.JournalID,
    jh.JournalNumber,
    jh.JournalDate,
    jh.Description,
    jh.Reference
FROM JournalHeaders jh
WHERE jh.Reference LIKE '%BANK-%'
  AND jh.JournalDate = CAST(GETDATE() AS DATE)
ORDER BY jh.JournalID DESC;
```

**Expected:** Journal entry created with reference "BANK-{TransactionID}"

---

#### **D. Check Payment Journal Lines**
```sql
-- Get journal lines for bank statement payment
DECLARE @JournalID INT = (
    SELECT TOP 1 JournalID 
    FROM JournalHeaders 
    WHERE Reference LIKE '%BANK-%' 
    ORDER BY JournalID DESC
);

SELECT 
    jl.LineNumber,
    coa.AccountCode,
    coa.AccountName,
    jl.Debit,
    jl.Credit,
    jl.Description
FROM JournalLines jl
INNER JOIN ChartOfAccounts coa ON jl.AccountID = coa.AccountID
WHERE jl.JournalID = @JournalID
ORDER BY jl.LineNumber;
```

**Expected Results:**
```
Line 1: DR 2100-XXX - To Shop    R5,000.00
Line 2: CR 1120 - Bank Account   R5,000.00
```

---

#### **E. Check Supplier Balance Now Zero**
```sql
-- Supplier balance should now be zero
SELECT 
    SupplierName,
    TotalInvoices,
    TotalPayments,
    Balance
FROM vw_SupplierBalances
WHERE SupplierName LIKE '%To Shop%';
```

**Expected:** 
- TotalInvoices = R5,000.00
- TotalPayments = R5,000.00
- Balance = R0.00 ✅

---

## 🧪 **TEST SCENARIO 4: RECONCILIATION**

### **Verification Queries:**

#### **A. Check Control Account Reconciliation**
```sql
-- Control account should equal sum of all supplier ledgers
SELECT 
    ControlAccountCode,
    ControlAccountName,
    ControlAccountBalance,
    SubsidiaryLedgerTotal,
    Difference,
    IsReconciled
FROM vw_SubsidiaryLedgerReconciliation
WHERE ControlAccountCode = '2100';
```

**Expected:** 
- Difference = 0
- IsReconciled = 1 (True)

---

#### **B. Check Trial Balance**
```sql
-- Total debits should equal total credits
SELECT 
    AccountCode,
    AccountName,
    DebitBalance,
    CreditBalance
FROM vw_TrialBalance
ORDER BY AccountCode;

-- Summary
SELECT 
    SUM(DebitBalance) AS TotalDebits,
    SUM(CreditBalance) AS TotalCredits,
    SUM(DebitBalance) - SUM(CreditBalance) AS Difference
FROM vw_TrialBalance;
```

**Expected:** Difference = 0 (debits = credits)

---

#### **C. Check Detailed Ledger Transactions**
```sql
-- View all transactions for a specific supplier
SELECT 
    TransactionDate,
    AccountCode,
    AccountName,
    Description,
    Debit,
    Credit,
    RunningBalance
FROM vw_DetailedLedgerTransactions
WHERE AccountCode LIKE '2100-%'
  AND AccountName LIKE '%To Shop%'
ORDER BY TransactionDate, TransactionID;
```

**Expected:** Shows invoice (credit) and payment (debit) with running balance

---

## 🧪 **TEST SCENARIO 5: ADHOC INVOICE (UTILITIES)**

### **Test Steps:**

1. **Navigate:** Accounting → Accounts Payable → New Invoice
2. **Create Invoice:**
   - Supplier: Eskom
   - GL Account: 5400 - Utilities
   - Amount: R1,200.00
   - Description: Electricity - March 2026
3. **Save Invoice**

---

### **Verification Queries:**

#### **A. Check Invoice Saved**
```sql
SELECT TOP 1
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    Amount,
    Description
FROM AdhocInvoices
ORDER BY InvoiceID DESC;
```

**Expected:** Invoice saved with details

---

#### **B. Check NO Journal Entry Created**
```sql
-- Should NOT create journal entry for adhoc invoice
SELECT COUNT(*) AS AdhocJournalCount
FROM JournalHeaders
WHERE Description LIKE '%Electricity%'
  AND JournalDate = CAST(GETDATE() AS DATE);
```

**Expected:** AdhocJournalCount = 0 (no journal yet - awaiting bank statement)

---

#### **C. After Bank Statement Import - Check Journal Created**
```sql
-- After importing bank statement with Eskom payment
SELECT 
    jh.JournalID,
    jh.Description,
    jl.LineNumber,
    coa.AccountCode,
    coa.AccountName,
    jl.Debit,
    jl.Credit
FROM JournalHeaders jh
INNER JOIN JournalLines jl ON jh.JournalID = jl.JournalID
INNER JOIN ChartOfAccounts coa ON jl.AccountID = coa.AccountID
WHERE jh.Description LIKE '%Eskom%'
ORDER BY jh.JournalID DESC, jl.LineNumber;
```

**Expected Results:**
```
Line 1: DR 5400 - Utilities      R1,200.00
Line 2: CR 1120 - Bank Account   R1,200.00
```

---

## 🧪 **COMPLETE VERIFICATION CHECKLIST**

### **✅ Database Setup**
- [ ] All 9 scripts executed successfully
- [ ] Chart of Accounts has subsidiary ledgers
- [ ] Supplier ledger accounts created (2100-001, 2100-002, etc.)
- [ ] Customer ledger accounts created (1200-001, 1200-002, etc.)
- [ ] All stored procedures exist
- [ ] All views exist

### **✅ Supplier Invoice Flow**
- [ ] Invoice captured and saved
- [ ] Journal entry created immediately
- [ ] Inventory account debited
- [ ] VAT Input account debited
- [ ] Supplier ledger account credited
- [ ] Supplier balance increased

### **✅ Payment Flow**
- [ ] Payment batch created
- [ ] Submitted to FNB successfully
- [ ] NO journal entry created on submission
- [ ] Supplier balance unchanged after submission

### **✅ Bank Statement Flow**
- [ ] Bank statement imported
- [ ] Transactions auto-mapped to supplier ledgers
- [ ] Journal entries created for payments
- [ ] Supplier ledger debited
- [ ] Bank account credited
- [ ] Supplier balance reduced to zero

### **✅ Reconciliation**
- [ ] Control account = sum of subsidiary ledgers
- [ ] Trial balance: debits = credits
- [ ] Detailed ledger shows all transactions
- [ ] Running balances correct

---

## 📊 **QUICK REFERENCE QUERIES**

### **Check All Supplier Balances**
```sql
SELECT * FROM vw_SupplierBalances ORDER BY SupplierName;
```

### **Check All Customer Balances**
```sql
SELECT * FROM vw_CustomerBalances ORDER BY CustomerName;
```

### **Check Today's Journal Entries**
```sql
SELECT 
    jh.JournalNumber,
    jh.JournalDate,
    jh.Description,
    coa.AccountCode,
    coa.AccountName,
    jl.Debit,
    jl.Credit
FROM JournalHeaders jh
INNER JOIN JournalLines jl ON jh.JournalID = jl.JournalID
INNER JOIN ChartOfAccounts coa ON jl.AccountID = coa.AccountID
WHERE jh.JournalDate = CAST(GETDATE() AS DATE)
ORDER BY jh.JournalID, jl.LineNumber;
```

### **Check Unmapped Bank Transactions**
```sql
SELECT 
    TransactionID,
    TransactionDate,
    Description,
    Amount,
    CreditDebitIndicator
FROM AP_StatementTransactions
WHERE IsMapped = 0 OR IsMapped IS NULL
ORDER BY TransactionDate DESC;
```

### **Check Trial Balance**
```sql
SELECT 
    SUM(DebitBalance) AS TotalDebits,
    SUM(CreditBalance) AS TotalCredits,
    SUM(DebitBalance) - SUM(CreditBalance) AS Difference
FROM vw_TrialBalance;
```

---

## 🚨 **TROUBLESHOOTING**

### **Issue: Supplier ledger account not found**
```sql
-- Manually create supplier ledger account
DECLARE @SupplierID INT = 1; -- Replace with actual SupplierID
DECLARE @AccountCode NVARCHAR(20);
DECLARE @AccountID INT;

EXEC sp_CreateSupplierLedgerAccount 
    @SupplierID = @SupplierID,
    @AccountCode = @AccountCode OUTPUT,
    @AccountID = @AccountID OUTPUT;

SELECT @AccountCode AS CreatedAccountCode, @AccountID AS CreatedAccountID;
```

### **Issue: Journal entry not created**
```sql
-- Check if stored procedure exists
SELECT * FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_NAME = 'sp_PostSupplierInvoice';

-- Check for errors in application log
SELECT TOP 20 * FROM ErrorLog ORDER BY ErrorID DESC;
```

### **Issue: Reconciliation doesn't balance**
```sql
-- Find discrepancies
SELECT 
    coa.AccountCode,
    coa.AccountName,
    SUM(jl.Debit) AS TotalDebits,
    SUM(jl.Credit) AS TotalCredits,
    SUM(jl.Debit) - SUM(jl.Credit) AS NetBalance
FROM JournalLines jl
INNER JOIN ChartOfAccounts coa ON jl.AccountID = coa.AccountID
GROUP BY coa.AccountCode, coa.AccountName
HAVING SUM(jl.Debit) - SUM(jl.Credit) <> 0
ORDER BY coa.AccountCode;
```

---

## ✅ **TESTING COMPLETE**

Once all tests pass, your accounting module is fully functional and ready for production use.
