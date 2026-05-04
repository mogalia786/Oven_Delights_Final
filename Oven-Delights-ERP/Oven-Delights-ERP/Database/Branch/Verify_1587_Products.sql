-- =============================================
-- VERIFY: Products table should have exactly 1,587 products
-- Based on ITEM_LIST_WITH_CATEGORY_IDS.csv from yesterday
-- =============================================

-- Step 1: Check current count in Products table
SELECT 'Products Table - Current Count' AS CheckType;
SELECT 
    COUNT(*) AS TotalProducts,
    1587 AS ExpectedProducts,
    COUNT(*) - 1587 AS Difference,
    CASE 
        WHEN COUNT(*) = 1587 THEN '✓ CORRECT'
        WHEN COUNT(*) < 1587 THEN '✗ MISSING ' + CAST(1587 - COUNT(*) AS VARCHAR) + ' products'
        WHEN COUNT(*) > 1587 THEN '✗ EXTRA ' + CAST(COUNT(*) - 1587 AS VARCHAR) + ' products'
    END AS Status
FROM Products;

-- Step 2: Check unique products in Demo_Retail_Product
SELECT 'Demo_Retail_Product - Unique Products' AS CheckType;
SELECT 
    COUNT(DISTINCT SKU) AS UniqueProducts,
    1587 AS ExpectedProducts,
    COUNT(DISTINCT SKU) - 1587 AS Difference,
    CASE 
        WHEN COUNT(DISTINCT SKU) = 1587 THEN '✓ CORRECT'
        WHEN COUNT(DISTINCT SKU) < 1587 THEN '✗ MISSING ' + CAST(1587 - COUNT(DISTINCT SKU) AS VARCHAR) + ' products'
        WHEN COUNT(DISTINCT SKU) > 1587 THEN '✗ EXTRA ' + CAST(COUNT(DISTINCT SKU) - 1587 AS VARCHAR) + ' products'
    END AS Status
FROM Demo_Retail_Product
WHERE IsActive = 1;

-- Step 3: Import CSV and compare
IF OBJECT_ID('tempdb..#CSV1587') IS NOT NULL DROP TABLE #CSV1587;
CREATE TABLE #CSV1587 (
    ItemCode NVARCHAR(50),
    Barcode NVARCHAR(50),
    ItemDescription NVARCHAR(200),
    CategoryID INT,
    ItemCategory NVARCHAR(50),
    UnitOfMeasure NVARCHAR(20)
);

BULK INSERT #CSV1587
FROM 'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\ITEM_LIST_WITH_CATEGORY_IDS.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Step 4: Verify CSV has 1,587 records
SELECT 'CSV File - Record Count' AS CheckType;
SELECT 
    COUNT(*) AS CSVRecords,
    1587 AS ExpectedRecords,
    CASE 
        WHEN COUNT(*) = 1587 THEN '✓ CSV is correct'
        ELSE '✗ CSV has ' + CAST(COUNT(*) AS VARCHAR) + ' records'
    END AS Status
FROM #CSV1587;

-- Step 5: Find products in CSV but NOT in Products table (MISSING)
SELECT 'Products MISSING from Products Table' AS Issue;
SELECT 
    csv.ItemCode,
    csv.ItemDescription,
    csv.CategoryID,
    csv.ItemCategory
FROM #CSV1587 csv
WHERE NOT EXISTS (
    SELECT 1 FROM Products p 
    WHERE p.ProductCode = csv.ItemCode
)
ORDER BY csv.ItemCode;

SELECT 'Count of MISSING products' AS Summary, COUNT(*) AS MissingCount
FROM #CSV1587 csv
WHERE NOT EXISTS (
    SELECT 1 FROM Products p 
    WHERE p.ProductCode = csv.ItemCode
);

-- Step 6: Find products in Products table but NOT in CSV (EXTRA)
SELECT 'EXTRA Products in Products Table (not in CSV)' AS Issue;
SELECT 
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.CategoryID
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM #CSV1587 csv 
    WHERE csv.ItemCode = p.ProductCode
)
ORDER BY p.ProductCode;

SELECT 'Count of EXTRA products' AS Summary, COUNT(*) AS ExtraCount
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM #CSV1587 csv 
    WHERE csv.ItemCode = p.ProductCode
);

-- Step 7: Summary
SELECT '=== SUMMARY ===' AS Report;
SELECT 
    (SELECT COUNT(*) FROM Products) AS Products_Table_Count,
    (SELECT COUNT(*) FROM #CSV1587) AS CSV_Count,
    (SELECT COUNT(DISTINCT SKU) FROM Demo_Retail_Product WHERE IsActive = 1) AS Demo_Unique_Count,
    CASE 
        WHEN (SELECT COUNT(*) FROM Products) = 1587 THEN 'Products table is CORRECT'
        ELSE 'Products table needs SYNC with CSV'
    END AS Action_Required;

-- Cleanup
DROP TABLE #CSV1587;
