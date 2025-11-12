-- ========================================
-- SETUP INVENTORY LEDGERS
-- Links inventory tables to GL accounts
-- ========================================

-- Note: USE statement removed for Azure SQL compatibility
-- Ensure you are connected to the correct database before running

PRINT '========================================';
PRINT 'SETTING UP INVENTORY LEDGER LINKS';
PRINT '========================================';
PRINT '';

-- ========================================
-- 1. Ensure Ledgers table exists
-- ========================================
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Ledgers')
BEGIN
    PRINT 'Creating Ledgers table...';
    
    CREATE TABLE Ledgers (
        LedgerID INT IDENTITY(1,1) PRIMARY KEY,
        LedgerCode NVARCHAR(20) NOT NULL UNIQUE,
        LedgerName NVARCHAR(200) NOT NULL,
        AccountID INT NULL,
        AccountCode NVARCHAR(20) NULL,
        AccountName NVARCHAR(200) NULL,
        LedgerType NVARCHAR(50) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy NVARCHAR(100) NULL,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedBy NVARCHAR(100) NULL,
        ModifiedDate DATETIME NULL
    );
    
    PRINT '✓ Ledgers table created';
END
ELSE
BEGIN
    PRINT '✓ Ledgers table exists';
END
GO

-- ========================================
-- 2. Link Inventory Accounts to Ledgers
-- ========================================
PRINT '';
PRINT 'Creating inventory ledger links...';

-- Stockroom Inventory Ledger
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'INV-STOCKROOM')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'INV-STOCKROOM',
        'Stockroom Inventory',
        AccountCode,
        AccountName,
        'Inventory',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1400';
    
    PRINT '  ✓ Stockroom Inventory ledger created';
END

-- Manufacturing Inventory (WIP) Ledger
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'INV-MANUFACTURING')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'INV-MANUFACTURING',
        'Manufacturing Inventory (WIP)',
        AccountCode,
        AccountName,
        'Inventory',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1410';
    
    PRINT '  ✓ Manufacturing Inventory ledger created';
END

-- Finished Goods Inventory Ledger
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'INV-FINISHED')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'INV-FINISHED',
        'Finished Goods Inventory',
        AccountCode,
        AccountName,
        'Inventory',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1420';
    
    PRINT '  ✓ Finished Goods Inventory ledger created';
END

-- Raw Materials Inventory Ledger
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'INV-RAWMATERIALS')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'INV-RAWMATERIALS',
        'Raw Materials Inventory',
        AccountCode,
        AccountName,
        'Inventory',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1430';
    
    PRINT '  ✓ Raw Materials Inventory ledger created';
END

-- ========================================
-- 3. Create Cash Ledgers
-- ========================================
PRINT '';
PRINT 'Creating cash ledgers...';

-- Cash on Hand
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'CASH-ONHAND')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'CASH-ONHAND',
        'Cash on Hand',
        AccountCode,
        AccountName,
        'Cash',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1100';
    
    PRINT '  ✓ Cash on Hand ledger created';
END

-- Petty Cash
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'CASH-PETTY')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'CASH-PETTY',
        'Petty Cash',
        AccountCode,
        AccountName,
        'Cash',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1110';
    
    PRINT '  ✓ Petty Cash ledger created';
END

-- Cash Over/Short
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'CASH-OVERSHORT')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'CASH-OVERSHORT',
        'Cash Over/Short',
        AccountCode,
        AccountName,
        'Cash',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1120';
    
    PRINT '  ✓ Cash Over/Short ledger created';
END

-- Sundries Cash
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'CASH-SUNDRIES')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'CASH-SUNDRIES',
        'Sundries Cash',
        AccountCode,
        AccountName,
        'Cash',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '1130';
    
    PRINT '  ✓ Sundries Cash ledger created';
END

-- ========================================
-- 4. Create Sales & COGS Ledgers
-- ========================================
PRINT '';
PRINT 'Creating sales and COGS ledgers...';

-- Sales Revenue
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'SALES-REVENUE')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'SALES-REVENUE',
        'Sales Revenue',
        AccountCode,
        AccountName,
        'Revenue',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '4000';
    
    PRINT '  ✓ Sales Revenue ledger created';
END

-- Cost of Sales
IF NOT EXISTS (SELECT 1 FROM Ledgers WHERE LedgerCode = 'COGS')
BEGIN
    INSERT INTO Ledgers (LedgerCode, LedgerName, AccountCode, AccountName, LedgerType, IsActive, CreatedDate)
    SELECT 
        'COGS',
        'Cost of Sales',
        AccountCode,
        AccountName,
        'Expense',
        1,
        GETDATE()
    FROM ChartOfAccounts
    WHERE AccountCode = '5000';
    
    PRINT '  ✓ Cost of Sales ledger created';
END

-- ========================================
-- 5. Update AccountID in Ledgers
-- ========================================
PRINT '';
PRINT 'Linking ledgers to chart of accounts...';

UPDATE L
SET L.AccountID = COA.AccountID
FROM Ledgers L
INNER JOIN ChartOfAccounts COA ON L.AccountCode = COA.AccountCode
WHERE L.AccountID IS NULL;

PRINT '  ✓ Ledgers linked to accounts';

-- ========================================
-- VERIFICATION
-- ========================================
PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

SELECT 
    L.LedgerCode,
    L.LedgerName,
    L.AccountCode,
    COA.AccountName,
    L.LedgerType
FROM Ledgers L
LEFT JOIN ChartOfAccounts COA ON L.AccountID = COA.AccountID
WHERE L.IsActive = 1
ORDER BY L.LedgerCode;

PRINT '';
PRINT '✓ INVENTORY LEDGERS SETUP COMPLETE!';
PRINT '';
PRINT 'Key Ledgers Created:';
PRINT '  INV-STOCKROOM - Stockroom Inventory (1400)';
PRINT '  INV-MANUFACTURING - Manufacturing WIP (1410)';
PRINT '  INV-FINISHED - Finished Goods (1420)';
PRINT '  INV-RAWMATERIALS - Raw Materials (1430)';
PRINT '  CASH-ONHAND - Cash on Hand (1100)';
PRINT '  CASH-PETTY - Petty Cash (1110)';
PRINT '  CASH-OVERSHORT - Cash Over/Short (1120)';
PRINT '  CASH-SUNDRIES - Sundries Cash (1130)';
PRINT '  SALES-REVENUE - Sales Revenue (4000)';
PRINT '  COGS - Cost of Sales (5000)';
PRINT '';
PRINT 'These ledgers will be used for:';
PRINT '  - Purchase Order posting';
PRINT '  - Manufacturing transactions';
PRINT '  - Sales transactions';
PRINT '  - Cash management';
GO
