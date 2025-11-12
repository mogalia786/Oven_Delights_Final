-- ========================================
-- POPULATE CHART OF ACCOUNTS
-- Complete accounting structure for Oven Delights
-- ========================================

-- Note: USE statement removed for Azure SQL compatibility
-- Ensure you are connected to the correct database before running

-- First ensure the table exists with all required columns
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'CreatedBy')
BEGIN
    PRINT 'ERROR: Run ADD_MISSING_COLUMNS.sql first!';
    RETURN;
END
GO

PRINT '========================================';
PRINT 'POPULATING CHART OF ACCOUNTS';
PRINT '========================================';
PRINT '';

-- Clear existing data (optional - comment out if you want to keep existing)
-- DELETE FROM ChartOfAccounts;

-- ========================================
-- 1000-1999: ASSETS
-- ========================================
PRINT '1. Creating ASSET accounts...';

-- 1100: Current Assets - Cash & Bank
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1100', 'Cash on Hand', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1110')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1110', 'Petty Cash', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1120')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1120', 'Cash Over/Short', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1130')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1130', 'Sundries Cash', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1200', 'Bank - Current Account', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1210')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1210', 'Bank - Savings Account', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

-- 1300: Accounts Receivable
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1300', 'Accounts Receivable', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1310')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1310', 'Debtors Control', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1320')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1320', 'Inter-Branch Debtors', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

-- 1400: Inventory
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1400')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1400', 'Stockroom Inventory', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1410')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1410', 'Manufacturing Inventory (WIP)', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1420')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1420', 'Finished Goods Inventory', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1430')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1430', 'Raw Materials Inventory', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

-- 1500: Fixed Assets
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1500')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1500', 'Equipment & Machinery', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1510')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1510', 'Furniture & Fixtures', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1520')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1520', 'Vehicles', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1530')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1530', 'Accumulated Depreciation', 'Asset', NULL, 1, 'SYSTEM', GETDATE());

-- ========================================
-- 2000-2999: LIABILITIES
-- ========================================
PRINT '2. Creating LIABILITY accounts...';

-- 2100: Current Liabilities
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2100', 'Accounts Payable', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2110')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2110', 'Creditors Control', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2120')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2120', 'Inter-Branch Creditors', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

-- 2200: Tax Liabilities
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2200', 'VAT Output', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2210')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2210', 'VAT Input', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2220')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2220', 'PAYE Payable', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2230')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2230', 'UIF Payable', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

-- 2300: Long-term Liabilities
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2300', 'Long-term Loans', 'Liability', NULL, 1, 'SYSTEM', GETDATE());

-- ========================================
-- 3000-3999: EQUITY
-- ========================================
PRINT '3. Creating EQUITY accounts...';

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('3000', 'Owner''s Equity', 'Equity', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('3100', 'Retained Earnings', 'Equity', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('3200', 'Current Year Earnings', 'Equity', NULL, 1, 'SYSTEM', GETDATE());

-- ========================================
-- 4000-4999: REVENUE
-- ========================================
PRINT '4. Creating REVENUE accounts...';

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4000', 'Sales Revenue', 'Revenue', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4100', 'Retail Sales', 'Revenue', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4200', 'Custom Order Sales', 'Revenue', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4300', 'Cake Order Sales', 'Revenue', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4900')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4900', 'Other Income', 'Revenue', NULL, 1, 'SYSTEM', GETDATE());

-- ========================================
-- 5000-5999: COST OF SALES
-- ========================================
PRINT '5. Creating COST OF SALES accounts...';

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5000', 'Cost of Sales', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5100', 'Cost of Goods Sold - Retail', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5200', 'Cost of Goods Sold - Manufacturing', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5300', 'Direct Materials', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5400')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5400', 'Direct Labor', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- ========================================
-- 6000-6999: OPERATING EXPENSES
-- ========================================
PRINT '6. Creating OPERATING EXPENSE accounts...';

-- Salaries & Wages
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6000')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6000', 'Salaries & Wages', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Rent & Utilities
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6100', 'Rent Expense', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6110')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6110', 'Electricity', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6120')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6120', 'Water & Sewerage', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6130')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6130', 'Telephone & Internet', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Administrative
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6200', 'Office Supplies', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6210')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6210', 'Printing & Stationery', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Marketing & Advertising
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6300', 'Advertising & Marketing', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Vehicle & Transport
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6400')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6400', 'Fuel & Oil', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6410')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6410', 'Vehicle Maintenance', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Insurance & Licenses
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6500')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6500', 'Insurance', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6510')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6510', 'Licenses & Permits', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Repairs & Maintenance
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6600')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6600', 'Repairs & Maintenance', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Depreciation
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6700')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6700', 'Depreciation Expense', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Bank Charges & Interest
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6800')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6800', 'Bank Charges', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6810')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6810', 'Interest Expense', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

-- Miscellaneous
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6900')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6900', 'Sundry Expenses', 'Expense', NULL, 1, 'SYSTEM', GETDATE());

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

SELECT 
    AccountType,
    COUNT(*) AS AccountCount
FROM ChartOfAccounts
WHERE IsActive = 1
GROUP BY AccountType
ORDER BY AccountType;

PRINT '';
PRINT '✓ CHART OF ACCOUNTS POPULATED!';
PRINT '';
PRINT 'Key Accounts Created:';
PRINT '  1100 - Cash on Hand';
PRINT '  1110 - Petty Cash';
PRINT '  1120 - Cash Over/Short';
PRINT '  1130 - Sundries Cash';
PRINT '  1400 - Stockroom Inventory';
PRINT '  1410 - Manufacturing Inventory (WIP)';
PRINT '  1420 - Finished Goods Inventory';
PRINT '  4000 - Sales Revenue';
PRINT '  5000 - Cost of Sales';
PRINT '';
PRINT 'You can now:';
PRINT '  - View Chart of Accounts in ERP';
PRINT '  - Post journal entries';
PRINT '  - Generate financial reports';
GO
