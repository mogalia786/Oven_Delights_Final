-- =============================================
-- Expand Chart of Accounts - Part 3: Revenue
-- =============================================

-- =============================================
-- REVENUE (4000-4999)
-- =============================================

-- Sales Revenue
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4010')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4010', 'Sales - Retail', 'Revenue', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4020')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4020', 'Sales - Wholesale', 'Revenue', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4030')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4030', 'Sales - Manufacturing', 'Revenue', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4040')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4040', 'Sales - Online', 'Revenue', NULL, 1, 'System', GETDATE())

-- Sales Deductions
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4090')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4090', 'Sales Returns & Allowances', 'Revenue', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4091')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4091', 'Sales Discounts', 'Revenue', NULL, 1, 'System', GETDATE())

-- Other Income
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4900')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4900', 'Other Income', 'Revenue', NULL, 1, 'System', GETDATE())

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4910')
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, ParentAccountID, IsActive, CreatedBy, CreatedDate)
    VALUES ('4910', 'Interest Income', 'Revenue', NULL, 1, 'System', GETDATE())

PRINT 'Revenue accounts created successfully'
GO
