-- =============================================
-- CLEANUP AND SYNC PRODUCTS
-- Fix the huge discrepancies between CSV (1,587) and Database (2,106+)
-- =============================================

-- Step 1: Find duplicates in Demo_Retail_Product
SELECT 'Duplicate SKUs in Demo_Retail_Product' AS Issue;
SELECT 
    SKU,
    COUNT(*) AS DuplicateCount
FROM Demo_Retail_Product
GROUP BY SKU
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC;

-- Step 2: Find products in Demo_Retail_Product but NOT in CSV
-- First, create staging table for CSV
IF OBJECT_ID('tempdb..#CSVProducts') IS NOT NULL DROP TABLE #CSVProducts;
CREATE TABLE #CSVProducts (
    ItemCode NVARCHAR(50),
    Barcode NVARCHAR(50),
    ItemDescription NVARCHAR(200),
    CategoryID INT,
    ItemCategory NVARCHAR(50),
    UnitOfMeasure NVARCHAR(20)
);

-- Import CSV
BULK INSERT #CSVProducts
FROM 'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\ITEM_LIST_WITH_CATEGORY_IDS.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Step 3: Products in Demo_Retail_Product but NOT in CSV (these are extras)
SELECT 'Products in DB but NOT in CSV (EXTRAS)' AS Issue;
SELECT 
    drp.ProductID,
    drp.SKU,
    drp.Name,
    drp.CategoryID,
    drp.IsActive
FROM Demo_Retail_Product drp
WHERE NOT EXISTS (
    SELECT 1 FROM #CSVProducts csv 
    WHERE csv.ItemCode = drp.SKU
)
ORDER BY drp.SKU;

SELECT 'Count of EXTRA products' AS Info, COUNT(*) AS ExtraCount
FROM Demo_Retail_Product drp
WHERE NOT EXISTS (
    SELECT 1 FROM #CSVProducts csv 
    WHERE csv.ItemCode = drp.SKU
);

-- Step 4: Products in CSV but NOT in Demo_Retail_Product (these are missing)
SELECT 'Products in CSV but NOT in DB (MISSING)' AS Issue;
SELECT 
    csv.ItemCode,
    csv.ItemDescription,
    csv.CategoryID,
    csv.ItemCategory
FROM #CSVProducts csv
WHERE NOT EXISTS (
    SELECT 1 FROM Demo_Retail_Product drp 
    WHERE drp.SKU = csv.ItemCode
)
ORDER BY csv.ItemCode;

SELECT 'Count of MISSING products' AS Info, COUNT(*) AS MissingCount
FROM #CSVProducts csv
WHERE NOT EXISTS (
    SELECT 1 FROM Demo_Retail_Product drp 
    WHERE drp.SKU = csv.ItemCode
);

-- Step 5: Check Products table vs CSV
SELECT 'Products Table vs CSV' AS Info;
SELECT 
    (SELECT COUNT(*) FROM Products) AS Products_Total,
    (SELECT COUNT(*) FROM #CSVProducts) AS CSV_Total,
    (SELECT COUNT(*) FROM Products) - (SELECT COUNT(*) FROM #CSVProducts) AS Difference;

-- Step 6: Recommendation
SELECT '=== RECOMMENDED ACTIONS ===' AS Action;
SELECT 
    '1. DELETE duplicate products from Demo_Retail_Product' AS Step1,
    '2. DELETE products NOT in CSV (extras)' AS Step2,
    '3. INSERT products from CSV that are missing' AS Step3,
    '4. UPDATE CategoryID for all products from CSV' AS Step4,
    '5. SYNC Products table with Demo_Retail_Product' AS Step5;

-- Cleanup
DROP TABLE #CSVProducts;
