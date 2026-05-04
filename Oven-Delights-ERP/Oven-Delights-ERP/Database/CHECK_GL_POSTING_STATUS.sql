-- =============================================
-- Check GL Posting Status for AP Invoices
-- =============================================

PRINT '=============================================='
PRINT 'AP Invoice to GL Posting Status Check'
PRINT '=============================================='
PRINT ''

-- Check if invoices exist
PRINT 'AP Invoices:'
SELECT 
    InvoiceID,
    InvoiceNumber,
    InvoiceDate,
    TotalAmount,
    Status,
    CreatedDate
FROM AP_Invoices
ORDER BY InvoiceID DESC

PRINT ''
PRINT 'General Ledger Entries (Expense Accounts 5000-5999):'
SELECT 
    gl.EntryID,
    gl.TransactionDate,
    coa.AccountCode,
    coa.AccountName,
    gl.Description,
    gl.DebitAmount,
    gl.CreditAmount,
    gl.ReferenceID,
    gl.CreatedDate
FROM GeneralLedger gl
LEFT JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode >= '5000' AND coa.AccountCode < '6000'
ORDER BY gl.EntryID DESC

PRINT ''
PRINT 'General Ledger Entries (AP Account 2030):'
SELECT 
    gl.EntryID,
    gl.TransactionDate,
    coa.AccountCode,
    coa.AccountName,
    gl.Description,
    gl.DebitAmount,
    gl.CreditAmount,
    gl.ReferenceID,
    gl.CreatedDate
FROM GeneralLedger gl
LEFT JOIN ChartOfAccounts coa ON gl.AccountID = coa.AccountID
WHERE coa.AccountCode = '2030'
ORDER BY gl.EntryID DESC

PRINT ''
PRINT 'Chart of Accounts - Expense Accounts:'
SELECT 
    AccountCode,
    AccountName,
    AccountType,
    AccountCategory
FROM ChartOfAccounts
WHERE AccountCode >= '5000' AND AccountCode < '6000'
ORDER BY AccountCode

PRINT ''
PRINT 'AP Categories with GL Account Codes:'
SELECT 
    CategoryID,
    CategoryName,
    GLAccountCode,
    IsActive
FROM AP_Categories
ORDER BY CategoryID
