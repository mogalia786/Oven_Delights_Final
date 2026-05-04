-- =============================================
-- FIX PARENT ACCOUNT NAMES AND FLAGS
-- =============================================
-- Fix account 1010 name and ensure all parent accounts are correct
-- =============================================

PRINT '========================================='
PRINT 'FIXING PARENT ACCOUNT NAMES'
PRINT '========================================='
PRINT ''

-- Fix account 1010 name
PRINT 'Fixing account 1010 name...'
UPDATE ChartOfAccounts
SET AccountName = 'Bank'
WHERE AccountCode = '1010' AND IsSubsidiaryLedger = 0

PRINT '✓ Account 1010 updated to "Bank"'
PRINT ''

-- Fix account 2100 name
PRINT 'Fixing account 2100 name...'
UPDATE ChartOfAccounts
SET AccountName = 'Accounts Payable',
    IsControlAccount = 1
WHERE AccountCode = '2100' AND IsSubsidiaryLedger = 0

PRINT '✓ Account 2100 updated to "Accounts Payable"'
PRINT ''

-- Verify all parent accounts
PRINT 'All parent accounts (IsSubsidiaryLedger = 0):'
SELECT 
    AccountCode,
    AccountName,
    IsControlAccount,
    IsActive
FROM ChartOfAccounts
WHERE IsSubsidiaryLedger = 0 AND IsActive = 1
ORDER BY AccountCode

PRINT ''
PRINT '========================================='
PRINT 'FIX COMPLETE'
PRINT '========================================='
