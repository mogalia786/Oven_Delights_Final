-- =============================================
-- CLEAN UP DEMO_RETAIL_PRODUCT - REMOVE RAW MATERIALS
-- Demo_Retail_Product should ONLY contain retail products (internal/external/Manufactured)
-- NOT raw materials (ingredients)
-- =============================================

PRINT '========================================';
PRINT 'CLEANING UP DEMO_RETAIL_PRODUCT';
PRINT '========================================';
PRINT '';

-- Check current state
PRINT 'CURRENT STATE:';
SELECT 
    'Total products in Demo_Retail_Product' AS Info,
    COUNT(*) AS Count
FROM Demo_Retail_Product;

SELECT 
    'Raw materials in Demo_Retail_Product (should be 0)' AS Info,
    COUNT(*) AS Count
FROM Demo_Retail_Product drp
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.ItemType = 'RawMaterial';

PRINT '';
PRINT '========================================';
PRINT 'REMOVING RAW MATERIALS FROM DEMO_RETAIL_PRODUCT';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

-- Delete prices for raw materials first (foreign key constraint)
DELETE price
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.ItemType = 'RawMaterial';

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' price records for raw materials';

-- Delete stock for raw materials
DELETE stock
FROM Demo_Retail_Stock stock
INNER JOIN Demo_Retail_Variant variant ON variant.VariantID = stock.VariantID
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = variant.ProductID
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.ItemType = 'RawMaterial';

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' stock records for raw materials';

-- Delete variants for raw materials
DELETE variant
FROM Demo_Retail_Variant variant
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = variant.ProductID
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.ItemType = 'RawMaterial';

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' variant records for raw materials';

-- Delete raw materials from Demo_Retail_Product
DELETE drp
FROM Demo_Retail_Product drp
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.ItemType = 'RawMaterial';

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' raw material products from Demo_Retail_Product';

COMMIT TRANSACTION;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION:';
PRINT '========================================';

-- Check updated state
SELECT 
    'Total products in Demo_Retail_Product (after cleanup)' AS Info,
    COUNT(*) AS Count
FROM Demo_Retail_Product;

SELECT 
    'Raw materials remaining (should be 0)' AS Info,
    COUNT(*) AS Count
FROM Demo_Retail_Product drp
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.ItemType = 'RawMaterial';

-- Price records per branch after cleanup
SELECT 
    BranchID,
    COUNT(*) AS TotalPrices
FROM Demo_Retail_Price
GROUP BY BranchID
ORDER BY BranchID;

PRINT '';
PRINT '========================================';
PRINT '✅ DEMO_RETAIL_PRODUCT CLEANED UP!';
PRINT '========================================';
PRINT '';
PRINT 'Demo_Retail_Product now contains ONLY retail products';
PRINT 'Raw materials removed (they belong in Stockroom only)';
