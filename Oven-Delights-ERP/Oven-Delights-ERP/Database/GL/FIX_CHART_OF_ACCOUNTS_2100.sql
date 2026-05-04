-- =============================================
-- FIX CHART OF ACCOUNTS - ACCOUNT 2100 NAME
-- =============================================
-- The ChartOfAccounts table has the wrong name for account 2100
-- This script corrects it to "Accounts Payable"
-- =============================================

PRINT '========================================='
PRINT 'FIXING CHART OF ACCOUNTS - ACCOUNT 2100'
PRINT '========================================='
PRINT ''

-- Check current state
PRINT 'Current state of account 2100:'
SELECT AccountCode, AccountName, IsControlAccount, IsActive
FROM ChartOfAccounts
WHERE AccountCode = '2100'
PRINT ''

-- Update account name
UPDATE ChartOfAccounts
SET AccountName = 'Accounts Payable',
    IsControlAccount = 1,
    IsActive = 1
WHERE AccountCode = '2100'

PRINT '✓ Updated account 2100 to "Accounts Payable"'
PRINT ''

-- Verify the fix
PRINT 'Updated state of account 2100:'
SELECT AccountCode, AccountName, IsControlAccount, IsActive
FROM ChartOfAccounts
WHERE AccountCode = '2100'
PRINT ''

-- Also check if 2030 exists (should not be used)
PRINT 'Checking if account 2030 exists (should be inactive):'
IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2030')
BEGIN
    SELECT AccountCode, AccountName, IsControlAccount, IsActive
    FROM ChartOfAccounts
    WHERE AccountCode = '2030'
    
    PRINT ''
    PRINT 'WARNING: Account 2030 exists. Consider deactivating it if not needed.'
    PRINT ''
END
ELSE
BEGIN
    PRINT '  No account 2030 found (good)'
    PRINT ''
END

PRINT '========================================='
PRINT 'FIX COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Next steps:'
PRINT '  1. Refresh the Ledger Hierarchy form'
PRINT '  2. Verify account 2100 now shows "Accounts Payable"'
PRINT ''
