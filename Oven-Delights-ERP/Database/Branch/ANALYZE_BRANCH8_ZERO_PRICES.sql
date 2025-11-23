-- =============================================
-- ANALYZE BRANCH 8 ZERO PRICES
-- Find out what the 1590 zero-price products are
-- =============================================

PRINT '========================================';
PRINT 'ANALYZING BRANCH 8 ZERO PRICES';
PRINT '========================================';
PRINT '';

-- 1. Check if these products exist in other branches
PRINT '1. PRODUCTS IN BRANCH 8 BUT NOT IN OTHER BRANCHES:';
SELECT 
    COUNT(DISTINCT drp8.SKU) AS UniqueToB ranch8
FROM Demo_Retail_Product drp8
INNER JOIN Demo_Retail_Price price8 ON price8.ProductID = drp8.ProductID
WHERE price8.BranchID = 8
    AND price8.SellingPrice = 0
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Product drp_other
        WHERE drp_other.SKU = drp8.SKU
            AND drp_other.ProductID IN (
                SELECT ProductID FROM Demo_Retail_Price 
                WHERE BranchID IN (4, 6)
            )
    );

PRINT '';

-- 2. Check ItemType of zero-price products
PRINT '2. ZERO-PRICE PRODUCTS BY ITEMTYPE:';
SELECT 
    p.ItemType,
    COUNT(DISTINCT drp.SKU) AS ProductCount
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
LEFT JOIN Products p ON p.ProductCode = drp.SKU
WHERE price.BranchID = 8
    AND price.SellingPrice = 0
GROUP BY p.ItemType
ORDER BY ProductCount DESC;

PRINT '';

-- 3. Sample zero-price products
PRINT '3. SAMPLE ZERO-PRICE PRODUCTS (First 20):';
SELECT TOP 20
    drp.SKU,
    drp.Name,
    drp.Category,
    p.ItemType,
    price.SellingPrice
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
LEFT JOIN Products p ON p.ProductCode = drp.SKU
WHERE price.BranchID = 8
    AND price.SellingPrice = 0
ORDER BY drp.SKU;

PRINT '';

-- 4. Check if these are in Products master table
PRINT '4. ZERO-PRICE PRODUCTS IN MASTER TABLE:';
SELECT 
    'In Products master' AS Status,
    COUNT(DISTINCT drp.SKU) AS ProductCount
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE price.BranchID = 8
    AND price.SellingPrice = 0;

SELECT 
    'NOT in Products master' AS Status,
    COUNT(DISTINCT drp.SKU) AS ProductCount
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
WHERE price.BranchID = 8
    AND price.SellingPrice = 0
    AND NOT EXISTS (
        SELECT 1 FROM Products p 
        WHERE p.ProductCode = drp.SKU
    );

PRINT '';
PRINT '========================================';
PRINT 'RECOMMENDATION:';
PRINT '========================================';
PRINT '';
PRINT 'If zero-price products are:';
PRINT '- RawMaterial: This is CORRECT (ingredients don''t need prices)';
PRINT '- internal/external: Need to add prices manually or from CSV';
PRINT '- NOT in Products master: Need to sync Demo_Retail_Product → Products';
PRINT '';
