-- =============================================
-- Expand Chart of Accounts - Part 4: Cost of Sales
-- =============================================

-- =============================================
-- COST OF SALES (5000-5999)
-- =============================================

-- Cost of Goods Sold
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5010', 'Cost of Goods Sold - Retail', 'Cost of Sales', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5020', 'Cost of Goods Sold - Manufacturing', 'Cost of Sales', NULL, 1, 'System', GETDATE())

-- Direct Costs
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5030', 'Direct Materials', 'Cost of Sales', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5040')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5040', 'Direct Labor', 'Cost of Sales', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5050')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5050', 'Manufacturing Overhead', 'Cost of Sales', NULL, 1, 'System', GETDATE())

-- Freight & Delivery
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5060')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('5060', 'Freight In', 'Cost of Sales', NULL, 1, 'System', GETDATE())

PRINT 'Cost of Sales accounts created successfully'
GO
