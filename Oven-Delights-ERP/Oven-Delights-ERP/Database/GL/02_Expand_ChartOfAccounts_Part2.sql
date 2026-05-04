-- =============================================
-- Expand Chart of Accounts - Part 2: Liabilities & Equity
-- =============================================

-- =============================================
-- LIABILITIES (2000-2999)
-- =============================================

-- Current Liabilities
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2010', 'Accounts Payable', 'Liability', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2020', 'VAT Payable', 'Liability', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2030', 'Salaries Payable', 'Liability', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2040')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2040', 'Loans Payable', 'Liability', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2050')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2050', 'GRIR - Goods Received Invoice Not Received', 'Liability', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2060')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2060', 'Accrued Expenses', 'Liability', NULL, 1, 'System', GETDATE())

-- Inter-Branch Liabilities
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2600')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('2600', 'Inter-Branch Creditors', 'Liability', NULL, 1, 'System', GETDATE())

-- =============================================
-- EQUITY (3000-3999)
-- =============================================

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('3010', 'Owner''s Capital', 'Equity', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('3020', 'Retained Earnings', 'Equity', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('3030', 'Current Year Profit/Loss', 'Equity', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '3040')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('3040', 'Owner''s Drawings', 'Equity', NULL, 1, 'System', GETDATE())

PRINT 'Liabilities and Equity accounts created successfully'
GO
