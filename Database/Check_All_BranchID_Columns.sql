-- Check which tables have BranchID column
-- This helps diagnose the BOM fulfillment error

PRINT '=== Checking BranchID columns in all relevant tables ===';
PRINT '';

-- Manufacturing_Inventory
IF OBJECT_ID('dbo.Manufacturing_Inventory','U') IS NOT NULL
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Manufacturing_Inventory') AND name = 'BranchID')
        PRINT '✓ Manufacturing_Inventory HAS BranchID';
    ELSE
        PRINT '✗ Manufacturing_Inventory MISSING BranchID';
END
ELSE
    PRINT '✗ Manufacturing_Inventory table does not exist';

-- Manufacturing_InventoryMovements
IF OBJECT_ID('dbo.Manufacturing_InventoryMovements','U') IS NOT NULL
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Manufacturing_InventoryMovements') AND name = 'BranchID')
        PRINT '✓ Manufacturing_InventoryMovements HAS BranchID';
    ELSE
        PRINT '✗ Manufacturing_InventoryMovements MISSING BranchID';
END
ELSE
    PRINT '✗ Manufacturing_InventoryMovements table does not exist';

-- StockMovements
IF OBJECT_ID('dbo.StockMovements','U') IS NOT NULL
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.StockMovements') AND name = 'BranchID')
        PRINT '✓ StockMovements HAS BranchID';
    ELSE
        PRINT '✗ StockMovements MISSING BranchID';
END
ELSE
    PRINT '✗ StockMovements table does not exist';

-- Inventory
IF OBJECT_ID('dbo.Inventory','U') IS NOT NULL
BEGIN
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Inventory') AND name = 'BranchID')
        PRINT '✓ Inventory HAS BranchID';
    ELSE
        PRINT '✗ Inventory MISSING BranchID';
END
ELSE
    PRINT '✗ Inventory table does not exist';

-- RawMaterials
IF OBJECT_ID('dbo.RawMaterials','U') IS NOT NULL
BEGIN
    PRINT '✓ RawMaterials table exists (uses CurrentStock, no BranchID needed)';
END
ELSE
    PRINT '✗ RawMaterials table does not exist';

PRINT '';
PRINT '=== Check complete ===';
PRINT '';
PRINT 'If any table is MISSING BranchID, run the corresponding fix script.';
