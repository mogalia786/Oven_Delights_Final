-- =============================================
-- CREATE SIMPLE EXPENSE AND INCOME ACCOUNTS
-- These are for immediate expenses/income that appear on bank statements
-- NO subsidiary ledgers needed - just simple accounts
-- =============================================
-- Run this AFTER 08_CREATE_ALL_POSTING_PROCEDURES.sql
-- =============================================

PRINT '=========================================='
PRINT 'CREATING SIMPLE EXPENSE/INCOME ACCOUNTS'
PRINT 'For Bank Statement Posting'
PRINT '=========================================='
PRINT ''

-- =============================================
-- PART 1: ASSET ACCOUNTS
-- =============================================
PRINT 'PART 1: ASSET ACCOUNTS'
PRINT '----------------------'

-- Cash on Hand (critical for balance sheet reconciliation)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1100')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '1100', 'Cash on Hand', 'Asset', 1, 0,
        'DR', 'Physical cash not yet banked', GETDATE(), 1
    );
    PRINT '✓ Created 1100 - Cash on Hand';
END
ELSE
    PRINT '- 1100 - Cash on Hand already exists';

-- Bank Accounts
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1120')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '1120', 'Bank Account - FNB', 'Asset', 1, 0,
        'DR', 'FNB Business Account', GETDATE(), 1
    );
    PRINT '✓ Created 1120 - Bank Account - FNB';
END
ELSE
    PRINT '- 1120 - Bank Account already exists';

PRINT ''

-- =============================================
-- PART 2: INCOME ACCOUNTS (Simple - No Subsidiaries)
-- =============================================
PRINT 'PART 2: INCOME ACCOUNTS'
PRINT '-----------------------'

-- Sales Revenue
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4000')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '4000', 'Sales Revenue', 'Revenue', 1, 0,
        'CR', 'General sales revenue', GETDATE(), 1
    );
    PRINT '✓ Created 4000 - Sales Revenue';
END
ELSE
    PRINT '- 4000 - Sales Revenue already exists';

-- Sales - Cash
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4100')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '4100', 'Sales - Cash', 'Revenue', 1, 0,
        'CR', 'Cash sales', GETDATE(), 1
    );
    PRINT '✓ Created 4100 - Sales - Cash';
END
ELSE
    PRINT '- 4100 - Sales - Cash already exists';

-- Sales - Card
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4110')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '4110', 'Sales - Card', 'Revenue', 1, 0,
        'CR', 'Card sales', GETDATE(), 1
    );
    PRINT '✓ Created 4110 - Sales - Card';
END
ELSE
    PRINT '- 4110 - Sales - Card already exists';

-- Interest Income
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4300')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '4300', 'Interest Income', 'Revenue', 1, 0,
        'CR', 'Interest earned on bank accounts', GETDATE(), 1
    );
    PRINT '✓ Created 4300 - Interest Income';
END
ELSE
    PRINT '- 4300 - Interest Income already exists';

-- Other Income
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4400')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '4400', 'Other Income', 'Revenue', 1, 0,
        'CR', 'Miscellaneous income', GETDATE(), 1
    );
    PRINT '✓ Created 4400 - Other Income';
END
ELSE
    PRINT '- 4400 - Other Income already exists';

PRINT ''

-- =============================================
-- PART 3: EXPENSE ACCOUNTS (Simple - No Subsidiaries)
-- =============================================
PRINT 'PART 3: EXPENSE ACCOUNTS'
PRINT '------------------------'

-- Salaries & Wages
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5100')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5100', 'Salaries & Wages', 'Expense', 1, 0,
        'DR', 'Employee salaries and wages', GETDATE(), 1
    );
    PRINT '✓ Created 5100 - Salaries & Wages';
END
ELSE
    PRINT '- 5100 - Salaries & Wages already exists';

-- Fuel Expense
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5300')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5300', 'Fuel Expense', 'Expense', 1, 0,
        'DR', 'Vehicle fuel purchases', GETDATE(), 1
    );
    PRINT '✓ Created 5300 - Fuel Expense';
END
ELSE
    PRINT '- 5300 - Fuel Expense already exists';

-- Repairs & Maintenance
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5400')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5400', 'Repairs & Maintenance', 'Expense', 1, 0,
        'DR', 'Repairs and maintenance expenses', GETDATE(), 1
    );
    PRINT '✓ Created 5400 - Repairs & Maintenance';
END
ELSE
    PRINT '- 5400 - Repairs & Maintenance already exists';

-- Utilities - Electricity
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5500')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5500', 'Utilities - Electricity', 'Expense', 1, 0,
        'DR', 'Electricity expenses', GETDATE(), 1
    );
    PRINT '✓ Created 5500 - Utilities - Electricity';
END
ELSE
    PRINT '- 5500 - Utilities - Electricity already exists';

-- Utilities - Water
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5510')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5510', 'Utilities - Water', 'Expense', 1, 0,
        'DR', 'Water and sewerage expenses', GETDATE(), 1
    );
    PRINT '✓ Created 5510 - Utilities - Water';
END
ELSE
    PRINT '- 5510 - Utilities - Water already exists';

-- Utilities - Telephone & Internet
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5520')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5520', 'Utilities - Telephone & Internet', 'Expense', 1, 0,
        'DR', 'Telephone and internet expenses', GETDATE(), 1
    );
    PRINT '✓ Created 5520 - Utilities - Telephone & Internet';
END
ELSE
    PRINT '- 5520 - Utilities - Telephone & Internet already exists';

-- Bank Charges
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5600')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5600', 'Bank Charges', 'Expense', 1, 0,
        'DR', 'Bank fees and charges', GETDATE(), 1
    );
    PRINT '✓ Created 5600 - Bank Charges';
END
ELSE
    PRINT '- 5600 - Bank Charges already exists';

-- Insurance
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5700')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5700', 'Insurance', 'Expense', 1, 0,
        'DR', 'Insurance premiums', GETDATE(), 1
    );
    PRINT '✓ Created 5700 - Insurance';
END
ELSE
    PRINT '- 5700 - Insurance already exists';

-- Professional Fees
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5800')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5800', 'Professional Fees', 'Expense', 1, 0,
        'DR', 'Legal, accounting, consulting fees', GETDATE(), 1
    );
    PRINT '✓ Created 5800 - Professional Fees';
END
ELSE
    PRINT '- 5800 - Professional Fees already exists';

-- Stationery & Supplies
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5900')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '5900', 'Stationery & Supplies', 'Expense', 1, 0,
        'DR', 'Office stationery and supplies', GETDATE(), 1
    );
    PRINT '✓ Created 5900 - Stationery & Supplies';
END
ELSE
    PRINT '- 5900 - Stationery & Supplies already exists';

-- Depreciation
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6000')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '6000', 'Depreciation', 'Expense', 1, 0,
        'DR', 'Depreciation expense', GETDATE(), 1
    );
    PRINT '✓ Created 6000 - Depreciation';
END
ELSE
    PRINT '- 6000 - Depreciation already exists';

-- Bad Debts
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6100')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '6100', 'Bad Debts', 'Expense', 1, 0,
        'DR', 'Uncollectable debts written off', GETDATE(), 1
    );
    PRINT '✓ Created 6100 - Bad Debts';
END
ELSE
    PRINT '- 6100 - Bad Debts already exists';

-- Sundry Expenses
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6200')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, IsActive, IsControlAccount,
        NormalBalance, Description, CreatedDate, CreatedBy
    )
    VALUES (
        '6200', 'Sundry Expenses', 'Expense', 1, 0,
        'DR', 'Miscellaneous expenses', GETDATE(), 1
    );
    PRINT '✓ Created 6200 - Sundry Expenses';
END
ELSE
    PRINT '- 6200 - Sundry Expenses already exists';

PRINT ''

-- =============================================
-- VERIFICATION
-- =============================================
PRINT '=========================================='
PRINT 'VERIFICATION - SIMPLE ACCOUNTS'
PRINT '=========================================='
PRINT ''

PRINT 'Simple Income Accounts:'
SELECT AccountCode, AccountName, AccountType, NormalBalance
FROM ChartOfAccounts
WHERE AccountCode IN ('4000', '4100', '4110', '4300', '4400')
  AND IsControlAccount = 0
ORDER BY AccountCode;

PRINT ''
PRINT 'Simple Expense Accounts:'
SELECT AccountCode, AccountName, AccountType, NormalBalance
FROM ChartOfAccounts
WHERE AccountCode IN ('5100', '5300', '5400', '5500', '5510', '5520', '5600', '5700', '5800', '5900', '6000', '6100', '6200')
  AND IsControlAccount = 0
ORDER BY AccountCode;

PRINT ''
PRINT '=========================================='
PRINT 'SIMPLE ACCOUNTS CREATED!'
PRINT '=========================================='
PRINT ''
PRINT 'These accounts are for immediate expenses/income that appear'
PRINT 'on bank statements and do NOT require subsidiary ledgers.'
PRINT ''
PRINT 'Examples:'
PRINT '- Fuel purchase → 5300 - Fuel Expense'
PRINT '- Bank charges → 5600 - Bank Charges'
PRINT '- Interest earned → 4300 - Interest Income'
PRINT '- Cash deposit → 1100 - Cash on Hand'
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Update BankStatementViewerForm to use these accounts'
PRINT '2. Test bank statement auto-mapping'
PRINT '3. Verify journal entries post correctly'
PRINT ''
