-- =============================================
-- Update Products Table ItemType and Add LastPaidPrice
-- =============================================

-- 1. Update ItemType constraint to include 'Manufactured' and 'External'
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_Products_ItemType')
BEGIN
    ALTER TABLE dbo.Products DROP CONSTRAINT CK_Products_ItemType;
    PRINT 'Dropped old ItemType constraint';
END
GO

-- Add new constraint with correct values
ALTER TABLE dbo.Products
ADD CONSTRAINT CK_Products_ItemType CHECK (ItemType IN ('Manufactured', 'External', 'Finished', 'SemiFinished'));
PRINT 'Added new ItemType constraint with Manufactured and External';
GO

-- 2. Add SKU (barcode) column to Products table if not exists
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Products') AND name = 'SKU')
BEGIN
    ALTER TABLE dbo.Products
    ADD SKU NVARCHAR(50) NULL;
    PRINT 'Added SKU column to Products table';
END
ELSE
BEGIN
    PRINT 'SKU column already exists in Products table';
END
GO

-- 3. Add LastPaidPrice column to Products table if not exists
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Products') AND name = 'LastPaidPrice')
BEGIN
    ALTER TABLE dbo.Products
    ADD LastPaidPrice DECIMAL(18,4) NULL;
    PRINT 'Added LastPaidPrice column to Products table';
END
ELSE
BEGIN
    PRINT 'LastPaidPrice column already exists in Products table';
END
GO

-- 4. Add AverageCost column to Products table if not exists (for cost tracking)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Products') AND name = 'AverageCost')
BEGIN
    ALTER TABLE dbo.Products
    ADD AverageCost DECIMAL(18,4) NULL;
    PRINT 'Added AverageCost column to Products table';
END
ELSE
BEGIN
    PRINT 'AverageCost column already exists in Products table';
END
GO

-- 5. Add LastPaidPrice column to RawMaterials table if not exists
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.RawMaterials') AND name = 'LastPaidPrice')
BEGIN
    ALTER TABLE dbo.RawMaterials
    ADD LastPaidPrice DECIMAL(18,4) NULL;
    PRINT 'Added LastPaidPrice column to RawMaterials table';
END
ELSE
BEGIN
    PRINT 'LastPaidPrice column already exists in RawMaterials table';
END
GO

-- 6. Add AverageCost column to Retail_Stock if not exists (for branch-specific cost tracking)
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Retail_Stock') AND name = 'AverageCost')
BEGIN
    ALTER TABLE dbo.Retail_Stock
    ADD AverageCost DECIMAL(18,4) NULL DEFAULT(0);
    PRINT 'Added AverageCost column to Retail_Stock table';
END
ELSE
BEGIN
    PRINT 'AverageCost column already exists in Retail_Stock table';
END
GO

-- 7. Update existing 'Finished' products to 'Manufactured' (default assumption)
UPDATE dbo.Products
SET ItemType = 'Manufactured'
WHERE ItemType = 'Finished';
PRINT 'Updated Finished products to Manufactured';
GO

-- 8. Create index on ItemType for better query performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Products_ItemType' AND object_id = OBJECT_ID('dbo.Products'))
BEGIN
    CREATE INDEX IX_Products_ItemType ON dbo.Products(ItemType);
    PRINT 'Created index on Products.ItemType';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Products table updates completed';
PRINT '========================================';
PRINT '';
PRINT 'COLUMNS ADDED:';
PRINT '1. Products.SKU (barcode) - NVARCHAR(50)';
PRINT '2. Products.LastPaidPrice - For External products only';
PRINT '3. Products.AverageCost - For cost tracking';
PRINT '4. RawMaterials.LastPaidPrice - Tracks supplier prices';
PRINT '5. Retail_Stock.AverageCost - Branch-specific cost per product';
PRINT '';
PRINT 'ITEMTYPE VALUES:';
PRINT '- Manufactured: Products made from ingredients (via BOM)';
PRINT '- External: Products purchased complete (Coke, Bread)';
PRINT '- Finished/SemiFinished: Legacy (kept for compatibility)';
PRINT '';
PRINT 'STOCK LEVELS STORED IN:';
PRINT '- Retail_Stock table (VariantID, BranchID, QtyOnHand, AverageCost)';
PRINT '- Stock is BRANCH-SPECIFIC for all products';
PRINT '';
PRINT 'COST OF SALES TRACKING:';
PRINT '- External Products: LastPaidPrice updated on invoice capture';
PRINT '- Manufactured Products: AverageCost calculated from BOM';
PRINT '- History tracked in Retail_StockMovements table';
PRINT '- Ledger entries: DR Cost of Sales, CR Inventory (on sale)';
GO
