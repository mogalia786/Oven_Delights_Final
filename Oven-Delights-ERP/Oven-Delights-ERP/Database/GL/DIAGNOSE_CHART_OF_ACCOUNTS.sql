-- =============================================
-- DIAGNOSE CHART OF ACCOUNTS ISSUES
-- =============================================
-- Check for duplicate accounts, wrong flags, and data inconsistencies
-- =============================================

PRINT '========================================='
PRINT 'CHART OF ACCOUNTS DIAGNOSTIC'
PRINT '========================================='
PRINT ''

-- Check for duplicate account codes
PRINT '1. CHECKING FOR DUPLICATE ACCOUNT CODES:'
PRINT '-----------------------------------------'
SELECT AccountCode, COUNT(*) AS DuplicateCount
FROM ChartOfAccounts
GROUP BY AccountCode
HAVING COUNT(*) > 1
PRINT ''

-- Check accounts 1010 and 1110
PRINT '2. BANK ACCOUNTS (1010, 1110):'
PRINT '-----------------------------------------'
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    IsControlAccount,
    IsSubsidiaryLedger,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode IN ('1010', '1110')
ORDER BY AccountCode
PRINT ''

-- Check account 2100
PRINT '3. ACCOUNTS PAYABLE (2100):'
PRINT '-----------------------------------------'
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    IsControlAccount,
    IsSubsidiaryLedger,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode = '2100'
PRINT ''

-- Check all accounts with IsSubsidiaryLedger = 0 (what the form shows)
PRINT '4. ALL PARENT ACCOUNTS (IsSubsidiaryLedger = 0):'
PRINT '-----------------------------------------'
SELECT 
    AccountCode,
    AccountName,
    IsControlAccount,
    IsActive
FROM ChartOfAccounts
WHERE IsSubsidiaryLedger = 0 AND IsActive = 1
ORDER BY AccountCode
PRINT ''

-- Check for accounts with IsSubsidiaryLedger = 1
PRINT '5. SUBSIDIARY LEDGER ACCOUNTS (IsSubsidiaryLedger = 1):'
PRINT '-----------------------------------------'
SELECT 
    AccountCode,
    AccountName,
    IsControlAccount,
    IsActive
FROM ChartOfAccounts
WHERE IsSubsidiaryLedger = 1 AND IsActive = 1
ORDER BY AccountCode
PRINT ''

-- Check total count
PRINT '6. ACCOUNT COUNTS:'
PRINT '-----------------------------------------'
SELECT 
    'Total Active Accounts' AS Category,
    COUNT(*) AS Count
FROM ChartOfAccounts
WHERE IsActive = 1
UNION ALL
SELECT 
    'Parent Accounts (IsSubsidiaryLedger=0)',
    COUNT(*)
FROM ChartOfAccounts
WHERE IsActive = 1 AND IsSubsidiaryLedger = 0
UNION ALL
SELECT 
    'Subsidiary Accounts (IsSubsidiaryLedger=1)',
    COUNT(*)
FROM ChartOfAccounts
WHERE IsActive = 1 AND IsSubsidiaryLedger = 1
PRINT ''

-- Check for NULL values in critical fields
PRINT '7. NULL VALUE CHECK:'
PRINT '-----------------------------------------'
SELECT 
    'Accounts with NULL IsSubsidiaryLedger' AS Issue,
    COUNT(*) AS Count
FROM ChartOfAccounts
WHERE IsSubsidiaryLedger IS NULL
UNION ALL
SELECT 
    'Accounts with NULL IsActive',
    COUNT(*)
FROM ChartOfAccounts
WHERE IsActive IS NULL
UNION ALL
SELECT 
    'Accounts with NULL IsControlAccount',
    COUNT(*)
FROM ChartOfAccounts
WHERE IsControlAccount IS NULL
PRINT ''

PRINT '========================================='
PRINT 'DIAGNOSTIC COMPLETE'
PRINT '========================================='
