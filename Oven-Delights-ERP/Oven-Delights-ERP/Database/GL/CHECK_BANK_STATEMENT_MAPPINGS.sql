-- =============================================
-- CHECK BANK STATEMENT MAPPINGS AND STATUS
-- =============================================

PRINT ''
PRINT '========================================='
PRINT 'BANK STATEMENT MAPPING STATUS'
PRINT '========================================='
PRINT ''

-- =============================================
-- 1. Check BankStatementMappingRules
-- =============================================
PRINT 'Step 1: Checking BankStatementMappingRules...'
PRINT ''

SELECT 
    COUNT(*) AS TotalRules,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveRules,
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END) AS InactiveRules
FROM BankStatementMappingRules

PRINT ''
PRINT 'Active Mapping Rules:'
SELECT 
    Keyword,
    AccountCode,
    AccountName,
    Priority,
    IsActive
FROM BankStatementMappingRules
WHERE IsActive = 1
ORDER BY AccountCode, Priority

PRINT ''

-- =============================================
-- 2. Check BankStatementTransactions Status
-- =============================================
PRINT 'Step 2: Checking BankStatementTransactions...'
PRINT ''

SELECT 
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN PostedToGL = 1 THEN 1 ELSE 0 END) AS PostedCount,
    SUM(CASE WHEN PostedToGL = 0 THEN 1 ELSE 0 END) AS NotPostedCount
FROM BankStatementTransactions

PRINT ''
PRINT 'Sample Posted Transactions:'
SELECT TOP 10
    StatementLineID,
    TransactionDate,
    Description,
    BankReference,
    DebitAmount,
    CreditAmount,
    PostedToGL,
    PostedDate
FROM BankStatementTransactions
WHERE PostedToGL = 1
ORDER BY TransactionDate DESC

PRINT ''

-- =============================================
-- 3. Check Chart of Accounts for Subsidiary Ledgers
-- =============================================
PRINT 'Step 3: Checking Chart of Accounts...'
PRINT ''

PRINT 'Key Accounts:'
SELECT 
    AccountCode,
    AccountName,
    AccountType,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode IN ('1010', '1020', '1030', '1200', '2100', '4010', '4300', '6010', '6020', '6021', '6023', '6030', '6050', '6060', '6080', '6090', '6100', '7010', '2030')
ORDER BY AccountCode

PRINT ''
PRINT 'Subsidiary Ledger Accounts (if any):'
SELECT 
    AccountCode,
    AccountName,
    AccountType,
    SupplierID,
    CustomerID,
    IsSubsidiaryLedger
FROM ChartOfAccounts
WHERE IsSubsidiaryLedger = 1
ORDER BY AccountCode

PRINT ''

-- =============================================
-- 4. Check Journal Entries
-- =============================================
PRINT 'Step 4: Checking Journal Entries...'
PRINT ''

SELECT 
    COUNT(*) AS TotalJournals
FROM JournalHeaders
WHERE Reference LIKE 'BANK-%'
   OR Description LIKE '%bank statement%'

PRINT ''
PRINT 'Recent Bank Statement Journal Entries:'
SELECT TOP 5
    jh.JournalID,
    jh.JournalDate,
    jh.Reference,
    jh.Description,
    jh.IsPosted
FROM JournalHeaders jh
WHERE jh.Reference LIKE 'BANK-%'
   OR jh.Description LIKE '%bank statement%'
ORDER BY jh.JournalDate DESC

PRINT ''
PRINT '========================================='
PRINT 'CHECK COMPLETE'
PRINT '========================================='
