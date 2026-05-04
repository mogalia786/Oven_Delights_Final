-- =============================================
-- FIX CHART OF ACCOUNTS
-- Ensure all required accounts exist and are active
-- =============================================

PRINT '========================================='
PRINT 'CHECKING AND FIXING CHART OF ACCOUNTS'
PRINT '========================================='
PRINT ''

-- Check for required accounts
PRINT 'Checking required accounts...'
PRINT ''

-- Cash on Hand (1110)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1110' AND IsActive = 1)
BEGIN
    IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1110')
    BEGIN
        UPDATE ChartOfAccounts SET IsActive = 1 WHERE AccountCode = '1110'
        PRINT '✓ Activated Cash on Hand (1110)'
    END
    ELSE
    BEGIN
        INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
        VALUES ('1110', 'Cash on Hand', 'Asset', 1)
        PRINT '✓ Created Cash on Hand (1110)'
    END
END
ELSE
    PRINT '✓ Cash on Hand (1110) exists and is active'

-- Bank Account (1120)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1120' AND IsActive = 1)
BEGIN
    IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1120')
    BEGIN
        UPDATE ChartOfAccounts SET IsActive = 1 WHERE AccountCode = '1120'
        PRINT '✓ Activated Bank Account (1120)'
    END
    ELSE
    BEGIN
        INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
        VALUES ('1120', 'Bank Account - FNB', 'Asset', 1)
        PRINT '✓ Created Bank Account (1120)'
    END
END
ELSE
    PRINT '✓ Bank Account (1120) exists and is active'

-- Accounts Receivable (1200)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200' AND IsActive = 1)
BEGIN
    IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200')
    BEGIN
        UPDATE ChartOfAccounts SET IsActive = 1 WHERE AccountCode = '1200'
        PRINT '✓ Activated Accounts Receivable (1200)'
    END
    ELSE
    BEGIN
        INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
        VALUES ('1200', 'Accounts Receivable', 'Asset', 1)
        PRINT '✓ Created Accounts Receivable (1200)'
    END
END
ELSE
    PRINT '✓ Accounts Receivable (1200) exists and is active'

-- Accounts Payable (2100)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1)
BEGIN
    IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2100')
    BEGIN
        UPDATE ChartOfAccounts SET IsActive = 1 WHERE AccountCode = '2100'
        PRINT '✓ Activated Accounts Payable (2100)'
    END
    ELSE
    BEGIN
        INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
        VALUES ('2100', 'Accounts Payable', 'Liability', 1)
        PRINT '✓ Created Accounts Payable (2100)'
    END
END
ELSE
    PRINT '✓ Accounts Payable (2100) exists and is active'

-- Interest Income (4300)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4300' AND IsActive = 1)
BEGIN
    IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4300')
    BEGIN
        UPDATE ChartOfAccounts SET IsActive = 1 WHERE AccountCode = '4300'
        PRINT '✓ Activated Interest Income (4300)'
    END
    ELSE
    BEGIN
        INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
        VALUES ('4300', 'Interest Income', 'Revenue', 1)
        PRINT '✓ Created Interest Income (4300)'
    END
END
ELSE
    PRINT '✓ Interest Income (4300) exists and is active'

-- Bank Charges (6080)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080' AND IsActive = 1)
BEGIN
    IF EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080')
    BEGIN
        UPDATE ChartOfAccounts SET IsActive = 1 WHERE AccountCode = '6080'
        PRINT '✓ Activated Bank Charges (6080)'
    END
    ELSE
    BEGIN
        INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
        VALUES ('6080', 'Bank Charges', 'Expense', 1)
        PRINT '✓ Created Bank Charges (6080)'
    END
END
ELSE
    PRINT '✓ Bank Charges (6080) exists and is active'

PRINT ''
PRINT '========================================='
PRINT 'VERIFICATION'
PRINT '========================================='
PRINT ''

-- Show all required accounts with their IDs
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    AccountType,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode IN ('1110', '1120', '1200', '2100', '4300', '6080')
ORDER BY AccountCode

PRINT ''
PRINT 'Chart of Accounts fixed successfully'
PRINT 'All required accounts are now active'
GO
