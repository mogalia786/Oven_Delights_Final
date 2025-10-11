-- Final comprehensive fix for all BranchID columns
-- Run this to ensure all tables are properly configured

PRINT '=== Starting comprehensive BranchID fix ===';
PRINT '';

-- 1. StockMovements
IF OBJECT_ID('dbo.StockMovements','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.StockMovements') AND name = 'BranchID')
    BEGIN
        ALTER TABLE dbo.StockMovements ADD BranchID INT NULL;
        PRINT '✓ Added BranchID to StockMovements';
    END
    ELSE
        PRINT '- StockMovements.BranchID already exists';
END

-- 2. Manufacturing_Inventory
IF OBJECT_ID('dbo.Manufacturing_Inventory','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Manufacturing_Inventory') AND name = 'BranchID')
    BEGIN
        ALTER TABLE dbo.Manufacturing_Inventory ADD BranchID INT NOT NULL DEFAULT 1;
        PRINT '✓ Added BranchID to Manufacturing_Inventory';
    END
    ELSE
        PRINT '- Manufacturing_Inventory.BranchID already exists';
END

-- 3. Manufacturing_InventoryMovements
IF OBJECT_ID('dbo.Manufacturing_InventoryMovements','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Manufacturing_InventoryMovements') AND name = 'BranchID')
    BEGIN
        ALTER TABLE dbo.Manufacturing_InventoryMovements ADD BranchID INT NOT NULL DEFAULT 1;
        PRINT '✓ Added BranchID to Manufacturing_InventoryMovements';
    END
    ELSE
        PRINT '- Manufacturing_InventoryMovements.BranchID already exists';
END

-- 4. Inventory (if it exists)
IF OBJECT_ID('dbo.Inventory','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Inventory') AND name = 'BranchID')
    BEGIN
        ALTER TABLE dbo.Inventory ADD BranchID INT NOT NULL DEFAULT 1;
        PRINT '✓ Added BranchID to Inventory';
    END
    ELSE
        PRINT '- Inventory.BranchID already exists';
END

PRINT '';
PRINT '=== Fix complete ===';
PRINT 'Please REBUILD your application to refresh schema cache.';
PRINT 'Then try BOM fulfillment again.';
