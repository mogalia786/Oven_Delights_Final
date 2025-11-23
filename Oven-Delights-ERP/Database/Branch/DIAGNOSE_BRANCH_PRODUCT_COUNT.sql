-- =============================================
-- DIAGNOSE WHY BRANCHES HAVE DIFFERENT PRODUCT COUNTS
-- =============================================

PRINT '========================================';
PRINT 'PRODUCT COUNT ANALYSIS';
PRINT '========================================';
PRINT '';

-- 1. Products master table by ItemType
PRINT '1. PRODUCTS MASTER TABLE BY ITEMTYPE:';
SELECT 
    ItemType,
    COUNT(*) AS ProductCount
FROM Products
WHERE IsActive = 1
GROUP BY ItemType
ORDER BY ItemType;

PRINT '';

-- 2. Demo_Retail_Product count
PRINT '2. DEMO_RETAIL_PRODUCT TOTAL:';
SELECT 
    COUNT(*) AS TotalProducts,
    COUNT(DISTINCT SKU) AS UniqueSKUs
FROM Demo_Retail_Product
WHERE IsActive = 1;

PRINT '';

-- 3. Price records per branch
PRINT '3. PRICE RECORDS PER BRANCH:';
SELECT 
    price.BranchID,
    COUNT(DISTINCT drp.SKU) AS UniqueProducts,
    COUNT(*) AS TotalPriceRecords
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
GROUP BY price.BranchID
ORDER BY price.BranchID;

PRINT '';

-- 4. Check if Demo_Retail_Product has products that shouldn't be there
PRINT '4. DEMO_RETAIL_PRODUCT VS PRODUCTS MASTER:';
SELECT 
    'Products in Demo_Retail but NOT in Products master' AS Issue,
    COUNT(*) AS Count
FROM Demo_Retail_Product drp
WHERE NOT EXISTS (
    SELECT 1 FROM Products p 
    WHERE p.ProductCode = drp.SKU
);

SELECT 
    'Raw materials in Demo_Retail (should be 0)' AS Issue,
    COUNT(*) AS Count
FROM Demo_Retail_Product drp
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.ItemType = 'RawMaterial';

PRINT '';

-- 5. Sample products in Demo_Retail_Product
PRINT '5. SAMPLE DEMO_RETAIL_PRODUCT WITH ITEMTYPE:';
SELECT TOP 20
    drp.SKU,
    drp.Name,
    drp.Category,
    p.ItemType,
    p.ProductName
FROM Demo_Retail_Product drp
LEFT JOIN Products p ON p.ProductCode = drp.SKU
ORDER BY drp.SKU;

PRINT '';
PRINT '========================================';
PRINT 'SUMMARY:';
PRINT '========================================';
PRINT 'Branch 4 & 6 have 741 products (original setup)';
PRINT 'Branch 9 & 10 have 2254 products (created by sp_CreateNewBranch)';
PRINT '';
PRINT 'If 2254 is correct: Demo_Retail_Product contains ALL products';
PRINT 'If 741 is correct: sp_CreateNewBranch is adding too many products';
