-- =============================================
-- Add IsVatable column to Products and Demo_Retail_Product tables
-- Default to TRUE for all products (most items are vatable in SA)
-- Staple goods like brown bread, maize meal, etc. can be set to FALSE
-- =============================================

PRINT '=== Adding IsVatable column to Products table ==='
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'IsVatable')
BEGIN
    ALTER TABLE Products
    ADD IsVatable BIT NOT NULL DEFAULT 1
    
    PRINT '✓ IsVatable column added to Products with default value TRUE'
END
ELSE
BEGIN
    PRINT '✓ IsVatable column already exists in Products'
END
GO

-- Update existing products to TRUE (default)
UPDATE Products
SET IsVatable = 1
WHERE IsVatable IS NULL
GO

PRINT ''
PRINT '=== Adding IsVatable column to Demo_Retail_Product table ==='
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'IsVatable')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD IsVatable BIT NOT NULL DEFAULT 1
    
    PRINT '✓ IsVatable column added to Demo_Retail_Product with default value TRUE'
END
ELSE
BEGIN
    PRINT '✓ IsVatable column already exists in Demo_Retail_Product'
END
GO

-- Update existing products to TRUE (default)
UPDATE Demo_Retail_Product
SET IsVatable = 1
WHERE IsVatable IS NULL
GO

PRINT ''
PRINT '✓ All products set to vatable by default.'
PRINT 'Update specific staple goods to IsVatable = 0 as needed.'
GO
