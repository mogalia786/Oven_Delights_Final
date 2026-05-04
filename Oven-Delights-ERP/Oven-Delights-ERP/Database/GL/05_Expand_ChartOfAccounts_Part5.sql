-- =============================================
-- Expand Chart of Accounts - Part 5: Expenses
-- =============================================

-- =============================================
-- EXPENSES (6000-6999)
-- =============================================

-- Operating Expenses
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6010', 'Rent Expense', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6020', 'Utilities - Electricity', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6021')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6021', 'Utilities - Water', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6022')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6022', 'Utilities - Gas', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6023')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6023', 'Telephone & Internet', 'Expense', NULL, 1, 'System', GETDATE())

-- Salaries & Wages
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6030', 'Salaries & Wages', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6031')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6031', 'Employee Benefits', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6032')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6032', 'Payroll Taxes', 'Expense', NULL, 1, 'System', GETDATE())

-- Marketing & Advertising
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6040')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6040', 'Marketing & Advertising', 'Expense', NULL, 1, 'System', GETDATE())

-- Office & Administrative
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6050')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6050', 'Office Supplies', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6051')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6051', 'Printing & Stationery', 'Expense', NULL, 1, 'System', GETDATE())

-- Insurance
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6060')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6060', 'Insurance Expense', 'Expense', NULL, 1, 'System', GETDATE())

-- Depreciation
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6070')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6070', 'Depreciation Expense', 'Expense', NULL, 1, 'System', GETDATE())

-- Bank Charges
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6080', 'Bank Charges & Fees', 'Expense', NULL, 1, 'System', GETDATE())

-- Repairs & Maintenance
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6090')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6090', 'Repairs & Maintenance', 'Expense', NULL, 1, 'System', GETDATE())

-- Vehicle Expenses
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6100', 'Vehicle Fuel', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6101')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6101', 'Vehicle Maintenance', 'Expense', NULL, 1, 'System', GETDATE())

-- Professional Fees
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6110')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6110', 'Legal & Professional Fees', 'Expense', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6111')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6111', 'Accounting Fees', 'Expense', NULL, 1, 'System', GETDATE())

-- Miscellaneous
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6900')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('6900', 'Miscellaneous Expenses', 'Expense', NULL, 1, 'System', GETDATE())

PRINT 'Expense accounts created successfully'
PRINT 'Chart of Accounts expansion complete!'
GO
