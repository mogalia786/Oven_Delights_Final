-- =============================================
-- Expand Chart of Accounts - Part 1: Assets
-- =============================================

-- Ensure ChartOfAccounts table has all necessary columns
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ChartOfAccounts') AND name = 'OpeningBalance')
BEGIN
    ALTER TABLE ChartOfAccounts ADD OpeningBalance DECIMAL(18,2) DEFAULT 0
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ChartOfAccounts') AND name = 'CurrentBalance')
BEGIN
    ALTER TABLE ChartOfAccounts ADD CurrentBalance DECIMAL(18,2) DEFAULT 0
END
GO

-- =============================================
-- ASSETS (1000-1999)
-- =============================================

-- Current Assets
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1010', 'Bank Account - Current', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1020', 'Petty Cash', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1030', 'Cash on Hand', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1100')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1100', 'Accounts Receivable', 'Asset', NULL, 1, 'System', GETDATE())

-- Inventory Accounts
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1200')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1200', 'Inventory - Raw Materials', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1210')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1210', 'Inventory - Finished Goods', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1220')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1220', 'Inventory - Retail Stock', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1230')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1230', 'Inventory - Work in Progress', 'Asset', NULL, 1, 'System', GETDATE())

-- Prepaid Expenses
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1300')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1300', 'Prepaid Expenses', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1310')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1310', 'Prepaid Rent', 'Asset', NULL, 1, 'System', GETDATE())

-- Fixed Assets
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1400')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1400', 'Property, Plant & Equipment', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1410')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1410', 'Accumulated Depreciation - PPE', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1420')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1420', 'Vehicles', 'Asset', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1430')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1430', 'Accumulated Depreciation - Vehicles', 'Asset', NULL, 1, 'System', GETDATE())

-- Inter-Branch Accounts
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1600')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('1600', 'Inter-Branch Debtors', 'Asset', NULL, 1, 'System', GETDATE())

PRINT 'Assets accounts created successfully'
GO
