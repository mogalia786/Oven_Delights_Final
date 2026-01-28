-- =============================================
-- PHASE 1.1: CREATE MISSING GL ACCOUNTS
-- Proper Chart of Accounts Structure
-- =============================================

PRINT '========================================='
PRINT 'PHASE 1.1: CREATING MISSING GL ACCOUNTS'
PRINT '========================================='
PRINT ''

-- =============================================
-- ASSET ACCOUNTS (1xxx)
-- =============================================
PRINT 'Creating Asset Accounts...'
PRINT '-------------------------'

-- 1050 - Debtors (Uncleared EFT)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1050')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('1050', 'Debtors - Uncleared EFT', 'Asset', 1)
    PRINT '✓ Created 1050 - Debtors (Uncleared EFT)'
END
ELSE
    PRINT '✓ 1050 - Debtors (Uncleared EFT) already exists'

PRINT ''

-- =============================================
-- LIABILITY ACCOUNTS (2xxx)
-- =============================================
PRINT 'Creating Liability Accounts...'
PRINT '------------------------------'

-- 2030 - Accounts Payable (Trade Creditors)
-- This is SEPARATE from 2010 (Customer Deposits)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2030')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('2030', 'Accounts Payable - Trade Creditors', 'Liability', 1)
    PRINT '✓ Created 2030 - Accounts Payable (Trade Creditors)'
END
ELSE
    PRINT '✓ 2030 - Accounts Payable already exists'

PRINT ''

-- =============================================
-- EXPENSE ACCOUNTS (5xxx & 6xxx)
-- =============================================
PRINT 'Creating Expense Accounts...'
PRINT '---------------------------'

-- 5020 - Direct Labor (Manufacturing)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5020')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('5020', 'Direct Labor', 'Expense', 1)
    PRINT '✓ Created 5020 - Direct Labor'
END
ELSE
    PRINT '✓ 5020 - Direct Labor already exists'

-- 6010 - Rent Expense
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6010')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6010', 'Rent Expense', 'Expense', 1)
    PRINT '✓ Created 6010 - Rent Expense'
END
ELSE
    PRINT '✓ 6010 - Rent Expense already exists'

-- 6020 - Utilities Expense
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6020')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6020', 'Utilities Expense', 'Expense', 1)
    PRINT '✓ Created 6020 - Utilities Expense'
END
ELSE
    PRINT '✓ 6020 - Utilities Expense already exists'

-- 6030 - Telephone & Internet
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6030')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6030', 'Telephone & Internet', 'Expense', 1)
    PRINT '✓ Created 6030 - Telephone & Internet'
END
ELSE
    PRINT '✓ 6030 - Telephone & Internet already exists'

-- 6040 - Office Supplies
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6040')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6040', 'Office Supplies', 'Expense', 1)
    PRINT '✓ Created 6040 - Office Supplies'
END
ELSE
    PRINT '✓ 6040 - Office Supplies already exists'

-- 6050 - Inventory Variance (Stock Adjustments)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6050')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6050', 'Inventory Variance', 'Expense', 1)
    PRINT '✓ Created 6050 - Inventory Variance'
END
ELSE
    PRINT '✓ 6050 - Inventory Variance already exists'

-- 6060 - Wastage Expense (Damaged/Expired Stock)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6060')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6060', 'Wastage Expense', 'Expense', 1)
    PRINT '✓ Created 6060 - Wastage Expense'
END
ELSE
    PRINT '✓ 6060 - Wastage Expense already exists'

-- 6070 - Manufacturing Overhead
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6070')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive)
    VALUES ('6070', 'Manufacturing Overhead', 'Expense', 1)
    PRINT '✓ Created 6070 - Manufacturing Overhead'
END
ELSE
    PRINT '✓ 6070 - Manufacturing Overhead already exists'

PRINT ''
PRINT '========================================='
PRINT 'VERIFICATION: ALL GL ACCOUNTS'
PRINT '========================================='
PRINT ''

-- Display complete Chart of Accounts
SELECT 
    AccountCode,
    AccountName,
    AccountType,
    CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS Status
FROM ChartOfAccounts
WHERE AccountCode IN (
    '1010', '1030', '1050', '1220', '1600', '1610',
    '2010', '2020', '2021', '2030',
    '4010', '4020',
    '5010', '5020',
    '6010', '6020', '6030', '6040', '6050', '6060', '6070'
)
ORDER BY AccountCode

PRINT ''
PRINT '========================================='
PRINT 'PHASE 1.1 COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'Summary:'
PRINT '- Asset Accounts: 1010, 1030, 1050, 1220, 1600, 1610'
PRINT '- Liability Accounts: 2010 (Customer Deposits), 2020, 2021, 2030 (AP)'
PRINT '- Revenue Accounts: 4010, 4020'
PRINT '- Expense Accounts: 5010, 5020, 6010-6070'
PRINT ''
PRINT 'CRITICAL NOTE:'
PRINT '- Account 2010 = Customer Deposits (POS orders only)'
PRINT '- Account 2030 = Accounts Payable (Supplier invoices only)'
PRINT '- These MUST remain separate for accurate financial statements'
PRINT ''
