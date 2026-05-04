-- =============================================
-- CORRECT Product Count - Accounting for Multi-Branch Structure
-- Demo_Retail_Product has same product repeated per branch
-- =============================================

-- Step 1: Count UNIQUE products (by SKU)
SELECT 'UNIQUE Products (by SKU)' AS Metric, COUNT(DISTINCT SKU) AS Count
FROM Demo_Retail_Product
WHERE IsActive = 1;

-- Step 2: Count TOTAL records (includes all branches)
SELECT 'TOTAL Records (all branches)' AS Metric, COUNT(*) AS Count
FROM Demo_Retail_Product
WHERE IsActive = 1;

-- Step 3: Count products per branch
SELECT 'Products per Branch' AS Metric;
SELECT 
    BranchID,
    COUNT(*) AS ProductCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY BranchID
ORDER BY BranchID;

-- Step 4: Count how many branches exist
SELECT 'Total Branches' AS Metric, COUNT(DISTINCT BranchID) AS Count
FROM Demo_Retail_Product;

-- Step 5: Expected vs Actual
SELECT 'Expected Calculation' AS Info;
SELECT 
    (SELECT COUNT(DISTINCT SKU) FROM Demo_Retail_Product WHERE IsActive = 1) AS UniqueProducts,
    (SELECT COUNT(DISTINCT BranchID) FROM Demo_Retail_Product) AS TotalBranches,
    (SELECT COUNT(DISTINCT SKU) FROM Demo_Retail_Product WHERE IsActive = 1) * 
    (SELECT COUNT(DISTINCT BranchID) FROM Demo_Retail_Product) AS ExpectedTotalRecords,
    (SELECT COUNT(*) FROM Demo_Retail_Product WHERE IsActive = 1) AS ActualTotalRecords;

-- Step 6: Products table (Master - no branch duplication)
SELECT 'Products Table (Master)' AS Metric;
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN CategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithCategoryID,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProducts
FROM Products;

-- Step 7: Demo_Retail_Price per branch
SELECT 'Demo_Retail_Price per Branch' AS Metric;
SELECT 
    BranchID,
    COUNT(*) AS PriceRecords
FROM Demo_Retail_Price
GROUP BY BranchID
ORDER BY BranchID;

-- Step 8: Demo_Retail_Stock per branch (if exists)
IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
BEGIN
    SELECT 'Demo_Retail_Stock per Branch' AS Metric;
    SELECT 
        BranchID,
        COUNT(*) AS StockRecords,
        SUM(Quantity) AS TotalQuantity
    FROM Demo_Retail_Stock
    GROUP BY BranchID
    ORDER BY BranchID;
END
ELSE
BEGIN
    SELECT 'Demo_Retail_Stock table does not exist' AS Info;
END

-- Step 9: CSV Comparison
SELECT '=== CSV COMPARISON ===' AS Info;
SELECT 
    'CSV has 1,587 unique products' AS Source,
    (SELECT COUNT(DISTINCT SKU) FROM Demo_Retail_Product WHERE IsActive = 1) AS DB_UniqueProducts,
    1587 - (SELECT COUNT(DISTINCT SKU) FROM Demo_Retail_Product WHERE IsActive = 1) AS Difference;
