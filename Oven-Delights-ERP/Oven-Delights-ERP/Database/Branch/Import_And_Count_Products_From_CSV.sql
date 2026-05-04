-- =============================================
-- Import products from CSV and show counts with categories
-- File: ITEM_LIST_WITH_CATEGORY_IDS.csv
-- Columns: ITEM CCODE, BARCODE, ITEM DESCRIPTION, CATERGORY, item catergory, unit of measure
-- =============================================

-- Step 1: Create staging table
IF OBJECT_ID('tempdb..#ProductImport') IS NOT NULL DROP TABLE #ProductImport;
CREATE TABLE #ProductImport (
    ItemCode NVARCHAR(50),
    Barcode NVARCHAR(50),
    ItemDescription NVARCHAR(200),
    CategoryID INT,
    ItemCategory NVARCHAR(50),
    UnitOfMeasure NVARCHAR(20)
);

-- Step 2: Import from CSV
-- NOTE: You need to run this BULK INSERT command with the correct file path
-- Adjust the path to match your actual file location
BULK INSERT #ProductImport
FROM 'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\ITEM_LIST_WITH_CATEGORY_IDS.csv'
WITH (
    FIRSTROW = 2,  -- Skip header row
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

-- Step 3: Show total count from CSV
SELECT 'CSV Import' AS Source, COUNT(*) AS TotalProducts
FROM #ProductImport;

-- Step 4: Show count by CategoryID from CSV
SELECT 
    'CSV by CategoryID' AS Source,
    CategoryID,
    COUNT(*) AS ProductCount
FROM #ProductImport
GROUP BY CategoryID
ORDER BY CategoryID;

-- Step 5: Show count by ItemCategory (internal/external) from CSV
SELECT 
    'CSV by ItemCategory' AS Source,
    ItemCategory,
    COUNT(*) AS ProductCount
FROM #ProductImport
GROUP BY ItemCategory
ORDER BY ItemCategory;

-- Step 6: Compare with current Products table
SELECT 'Current Products Table' AS Source, COUNT(*) AS TotalProducts
FROM Products;

SELECT 'Current Demo_Retail_Product' AS Source, COUNT(*) AS TotalProducts
FROM Demo_Retail_Product;

-- Step 7: Show sample of CSV data
SELECT TOP 20 * FROM #ProductImport ORDER BY ItemCode;

-- Step 8: Check which products from CSV exist in Products table
SELECT 
    'Products Matching CSV' AS Info,
    COUNT(*) AS MatchingProducts
FROM #ProductImport csv
INNER JOIN Products p ON p.ProductCode = csv.ItemCode;

SELECT 
    'Products NOT in CSV' AS Info,
    COUNT(*) AS MissingProducts
FROM Products p
WHERE NOT EXISTS (SELECT 1 FROM #ProductImport WHERE ItemCode = p.ProductCode);

-- Step 9: Show products that need CategoryID update
SELECT TOP 20
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.CategoryID AS Current_CategoryID,
    csv.CategoryID AS CSV_CategoryID,
    csv.ItemCategory AS CSV_ItemType
FROM Products p
INNER JOIN #ProductImport csv ON csv.ItemCode = p.ProductCode
WHERE p.CategoryID IS NULL OR p.CategoryID != csv.CategoryID
ORDER BY p.ProductCode;

-- Cleanup
DROP TABLE #ProductImport;
