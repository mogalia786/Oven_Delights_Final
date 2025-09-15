-- Sync existing Manufacturing_Product records to Retail_Product table
-- This fixes the broken stock on hand and reports functionality

PRINT 'Starting sync of Manufacturing_Product to Retail_Product...';

-- Insert Manufacturing products into Retail_Product if they don't exist
INSERT INTO dbo.Retail_Product (SKU, Name, IsActive, CreatedAt)
SELECT 
    mp.SKU,
    mp.ProductName,
    mp.IsActive,
    ISNULL(mp.CreatedDate, GETDATE())
FROM dbo.Manufacturing_Product mp
WHERE mp.IsActive = 1
AND NOT EXISTS (
    SELECT 1 FROM dbo.Retail_Product rp 
    WHERE rp.SKU = mp.SKU 
    OR (rp.SKU IS NULL AND mp.SKU IS NULL AND rp.Name = mp.ProductName)
);

PRINT 'Synced ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' products to Retail_Product table';

-- Create default variants for new retail products that don't have variants
INSERT INTO dbo.Retail_Variant (ProductID, VariantName, IsActive, CreatedAt)
SELECT 
    rp.ProductID,
    'Default',
    1,
    GETDATE()
FROM dbo.Retail_Product rp
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.Retail_Variant rv 
    WHERE rv.ProductID = rp.ProductID
);

PRINT 'Created ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' default variants';

-- Show results
PRINT 'Current product counts:';
SELECT 
    'Manufacturing_Product' AS TableName, 
    COUNT(*) AS ProductCount 
FROM dbo.Manufacturing_Product 
WHERE IsActive = 1

UNION ALL

SELECT 
    'Retail_Product' AS TableName, 
    COUNT(*) AS ProductCount 
FROM dbo.Retail_Product 
WHERE IsActive = 1;

PRINT 'Product sync completed successfully!';
