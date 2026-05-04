-- =============================================
-- Add Cost Tracking Columns to Demo_Retail_Product
-- Required for GL integration and cost tracking
-- =============================================

PRINT '========================================';
PRINT 'Adding Cost Columns to Demo_Retail_Product';
PRINT '========================================';
PRINT '';

-- Add AverageCost column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'AverageCost')
BEGIN
    ALTER TABLE Demo_Retail_Product ADD AverageCost DECIMAL(18,2) NULL DEFAULT 0;
    PRINT '✓ Added AverageCost column';
END
ELSE
BEGIN
    PRINT '  AverageCost column already exists';
END
GO

-- Add LastPaidPrice column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'LastPaidPrice')
BEGIN
    ALTER TABLE Demo_Retail_Product ADD LastPaidPrice DECIMAL(18,2) NULL DEFAULT 0;
    PRINT '✓ Added LastPaidPrice column';
END
ELSE
BEGIN
    PRINT '  LastPaidPrice column already exists';
END
GO

-- Add LastUpdated column
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'LastUpdated')
BEGIN
    ALTER TABLE Demo_Retail_Product ADD LastUpdated DATETIME NULL DEFAULT GETDATE();
    PRINT '✓ Added LastUpdated column';
END
ELSE
BEGIN
    PRINT '  LastUpdated column already exists';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Cost Columns Added Successfully';
PRINT '========================================';
PRINT '';
PRINT 'The following columns are now available:';
PRINT '  - AverageCost: Tracks average cost of product';
PRINT '  - LastPaidPrice: Tracks last paid/manufactured cost';
PRINT '  - LastUpdated: Timestamp of last cost update';
PRINT '';
PRINT 'These columns will be used by:';
PRINT '  - sp_AddSubRecipeToInventory (updates sub-recipe costs)';
PRINT '  - sp_CompleteProductManufacturing (updates product costs)';
PRINT '  - sp_ProcessPOSSaleLineItem (reads product cost for COGS)';
PRINT '';
GO
