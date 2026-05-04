-- =============================================
-- SIMPLE VERIFICATION: Products table should have exactly 1,587 products
-- No CSV import required - just check current state
-- =============================================

-- Step 1: Check current count in Products table
SELECT 'Products Table - Current Count' AS CheckType;
SELECT 
    COUNT(*) AS TotalProducts,
    1587 AS ExpectedProducts,
    COUNT(*) - 1587 AS Difference,
    CASE 
        WHEN COUNT(*) = 1587 THEN '✓ CORRECT - Products table has exactly 1,587 products'
        WHEN COUNT(*) < 1587 THEN '✗ MISSING ' + CAST(1587 - COUNT(*) AS VARCHAR) + ' products - Need to import from CSV'
        WHEN COUNT(*) > 1587 THEN '✗ EXTRA ' + CAST(COUNT(*) - 1587 AS VARCHAR) + ' products - Need to clean up duplicates'
    END AS Status
FROM Products;

-- Step 2: Check unique products in Demo_Retail_Product
SELECT 'Demo_Retail_Product - Unique Products (by SKU)' AS CheckType;
SELECT 
    COUNT(DISTINCT SKU) AS UniqueProducts,
    1587 AS ExpectedProducts,
    COUNT(DISTINCT SKU) - 1587 AS Difference,
    CASE 
        WHEN COUNT(DISTINCT SKU) = 1587 THEN '✓ CORRECT - Demo has exactly 1,587 unique products'
        WHEN COUNT(DISTINCT SKU) < 1587 THEN '✗ MISSING ' + CAST(1587 - COUNT(DISTINCT SKU) AS VARCHAR) + ' unique products'
        WHEN COUNT(DISTINCT SKU) > 1587 THEN '✗ EXTRA ' + CAST(COUNT(DISTINCT SKU) - 1587 AS VARCHAR) + ' unique products'
    END AS Status
FROM Demo_Retail_Product
WHERE IsActive = 1;

-- Step 3: Total records in Demo_Retail_Product (includes all branches)
SELECT 'Demo_Retail_Product - Total Records (all branches)' AS CheckType;
SELECT 
    COUNT(*) AS TotalRecords,
    COUNT(DISTINCT SKU) AS UniqueProducts,
    COUNT(DISTINCT BranchID) AS TotalBranches,
    COUNT(*) / NULLIF(COUNT(DISTINCT BranchID), 0) AS AvgProductsPerBranch
FROM Demo_Retail_Product
WHERE IsActive = 1;

-- Step 4: Products per branch breakdown
SELECT 'Products per Branch' AS CheckType;
SELECT 
    BranchID,
    COUNT(*) AS ProductCount,
    COUNT(DISTINCT SKU) AS UniqueProducts
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY BranchID
ORDER BY BranchID;

-- Step 5: Check Products with CategoryID
SELECT 'Products with CategoryID' AS CheckType;
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN CategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithCategoryID,
    SUM(CASE WHEN CategoryID IS NULL THEN 1 ELSE 0 END) AS WithoutCategoryID,
    CAST(SUM(CASE WHEN CategoryID IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS PercentWithCategory
FROM Products;

-- Step 6: Check Demo_Retail_Product with CategoryID
SELECT 'Demo_Retail_Product with CategoryID' AS CheckType;
SELECT 
    COUNT(DISTINCT SKU) AS UniqueProducts,
    SUM(CASE WHEN CategoryID IS NOT NULL THEN 1 ELSE 0 END) AS RecordsWithCategoryID,
    COUNT(DISTINCT CASE WHEN CategoryID IS NOT NULL THEN SKU END) AS UniqueProductsWithCategory
FROM Demo_Retail_Product
WHERE IsActive = 1;

-- Step 7: Summary and Action Required
SELECT '=== SUMMARY ===' AS Report;
SELECT 
    (SELECT COUNT(*) FROM Products) AS Products_Table_Count,
    1587 AS Expected_CSV_Count,
    (SELECT COUNT(DISTINCT SKU) FROM Demo_Retail_Product WHERE IsActive = 1) AS Demo_Unique_Count,
    CASE 
        WHEN (SELECT COUNT(*) FROM Products) = 1587 THEN '✓ Products table is CORRECT'
        WHEN (SELECT COUNT(*) FROM Products) < 1587 THEN '⚠ Products table needs IMPORT from CSV'
        WHEN (SELECT COUNT(*) FROM Products) > 1587 THEN '⚠ Products table needs CLEANUP (remove duplicates)'
    END AS Action_Required;

-- Step 8: Show sample products to verify data
SELECT 'Sample Products from Products Table' AS Info;
SELECT TOP 20
    ProductID,
    ProductCode,
    ProductName,
    CategoryID,
    SubcategoryID,
    ItemType,
    IsActive
FROM Products
ORDER BY ProductID;

SELECT 'Sample Products from Demo_Retail_Product' AS Info;
SELECT TOP 20
    ProductID,
    SKU,
    Name,
    CategoryID,
    SubcategoryID,
    ProductType,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE IsActive = 1
ORDER BY SKU, BranchID;
