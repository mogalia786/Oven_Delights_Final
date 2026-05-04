-- =============================================
-- CHECK AND FIX BANK ACCOUNT CODE
-- Determine which bank account code is being used
-- =============================================

PRINT ''
PRINT '========================================='
PRINT 'BANK ACCOUNT CODE CHECK'
PRINT '========================================='
PRINT ''

-- Check which bank accounts exist
PRINT 'Bank accounts in ChartOfAccounts:'
SELECT 
    AccountCode,
    AccountName,
    AccountType,
    IsActive
FROM ChartOfAccounts
WHERE (AccountCode LIKE '10%' AND AccountName LIKE '%bank%')
   OR AccountCode IN ('1010', '1120', '1100')
ORDER BY AccountCode

PRINT ''

-- Check which account code is used in GeneralLedger
PRINT 'Bank account codes used in GeneralLedger:'
SELECT DISTINCT
    AccountID,
    COUNT(*) AS TransactionCount
FROM GeneralLedger
WHERE AccountID LIKE '1%'
GROUP BY AccountID
ORDER BY TransactionCount DESC

PRINT ''

-- Check AP_StatementTransactions account
PRINT 'Bank account from AP_StatementTransactions:'
SELECT DISTINCT AccountNumber
FROM AP_StatementTransactions

PRINT ''
PRINT '========================================='
PRINT 'RECOMMENDATION'
PRINT '========================================='
PRINT ''
PRINT 'Based on the results above:'
PRINT '1. If you see 1120 in GeneralLedger, update procedures to use 1120'
PRINT '2. If you see 1010 in GeneralLedger, procedures are correct'
PRINT '3. If you see both, consolidate to one account code'
PRINT ''
