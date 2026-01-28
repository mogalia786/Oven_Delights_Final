-- =============================================
-- Create Missing GL Accounts for Complete Integration
-- =============================================

-- Check and create missing accounts
-- Only insert if account doesn't already exist

-- Inter-Branch Creditors (Receiving branch owes sending branch)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1610')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, OpeningBalance, CurrentBalance
    )
    VALUES (
        '1610', 'Inter-Branch Creditors', 'Liability', NULL,
        1, 0, 0
    )
    PRINT 'Created account 1610 - Inter-Branch Creditors'
END

-- VAT Input (Purchase VAT claimable from SARS)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2021')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, OpeningBalance, CurrentBalance
    )
    VALUES (
        '2021', 'VAT Input (Purchase VAT)', 'Asset', NULL,
        1, 0, 0
    )
    PRINT 'Created account 2021 - VAT Input (Purchase VAT)'
END

-- Other Income (Found stock, miscellaneous income)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4030')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, OpeningBalance, CurrentBalance
    )
    VALUES (
        '4030', 'Other Income', 'Revenue', NULL,
        1, 0, 0
    )
    PRINT 'Created account 4030 - Other Income'
END

-- Stock Loss/Shrinkage (Inventory losses)
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080')
BEGIN
    INSERT INTO ChartOfAccounts (
        AccountCode, AccountName, AccountType, ParentAccountID, 
        IsActive, OpeningBalance, CurrentBalance
    )
    VALUES (
        '6080', 'Stock Loss/Shrinkage', 'Expense', NULL,
        1, 0, 0
    )
    PRINT 'Created account 6080 - Stock Loss/Shrinkage'
END

-- Verify all critical accounts exist
PRINT ''
PRINT '=== Verification of Critical GL Accounts ==='

DECLARE @MissingAccounts TABLE (AccountCode NVARCHAR(20), AccountName NVARCHAR(200))

-- Check all required accounts
IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1010', 'Bank Account')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1025' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1025', 'Petty Cash')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1030', 'Cash on Hand')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1210' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1210', 'Finished Goods Inventory')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1220' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1220', 'Retail Inventory')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1600' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1600', 'Inter-Branch Debtors')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1610' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('1610', 'Inter-Branch Creditors')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2010', 'Accounts Payable')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2020' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2020', 'VAT Output')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2021', 'VAT Input')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '2050' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('2050', 'GRIR')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('4010', 'Sales Revenue')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '4030' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('4030', 'Other Income')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '5010' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('5010', 'Cost of Goods Sold')

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '6080' AND IsActive = 1)
    INSERT INTO @MissingAccounts VALUES ('6080', 'Stock Loss/Shrinkage')

-- Display results
IF EXISTS (SELECT 1 FROM @MissingAccounts)
BEGIN
    PRINT 'WARNING: The following critical accounts are missing or inactive:'
    SELECT AccountCode, AccountName FROM @MissingAccounts
END
ELSE
BEGIN
    PRINT 'SUCCESS: All critical GL accounts exist and are active'
END

PRINT ''
PRINT 'Missing GL Accounts creation script completed'
GO
