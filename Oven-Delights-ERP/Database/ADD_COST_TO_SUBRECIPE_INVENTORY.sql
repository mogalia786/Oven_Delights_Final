-- =============================================
-- Add Cost Tracking to Sub-Recipe Inventory
-- =============================================

PRINT '========================================';
PRINT 'Adding Cost Columns to Demo_SubRecipe_Inventory';
PRINT '========================================';
PRINT '';

-- Add UnitCost column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_SubRecipe_Inventory') AND name = 'UnitCost')
BEGIN
    ALTER TABLE Demo_SubRecipe_Inventory ADD UnitCost DECIMAL(18,2) NULL DEFAULT 0;
    PRINT '✓ Added UnitCost column';
END
ELSE
BEGIN
    PRINT '  UnitCost column already exists';
END
GO

-- Add TotalCost column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_SubRecipe_Inventory') AND name = 'TotalCost')
BEGIN
    ALTER TABLE Demo_SubRecipe_Inventory ADD TotalCost DECIMAL(18,2) NULL DEFAULT 0;
    PRINT '✓ Added TotalCost column';
END
ELSE
BEGIN
    PRINT '  TotalCost column already exists';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Cost Columns Added Successfully';
PRINT '========================================';
PRINT '';
PRINT 'The following columns are now available:';
PRINT '  - UnitCost: Cost per unit of sub-recipe';
PRINT '  - TotalCost: Total cost (UnitCost × Quantity)';
PRINT '';
PRINT 'These columns will be populated by:';
PRINT '  - sp_AddSubRecipeToInventory_WITH_GL';
PRINT '';
GO
