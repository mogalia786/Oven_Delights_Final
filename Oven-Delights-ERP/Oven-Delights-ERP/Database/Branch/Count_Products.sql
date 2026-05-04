-- Total count of products in each table

-- Products table (Master)
SELECT 'Products Table' AS TableName, COUNT(*) AS TotalCount
FROM Products;

-- Demo_Retail_Product table
SELECT 'Demo_Retail_Product Table' AS TableName, COUNT(*) AS TotalCount
FROM Demo_Retail_Product;

-- Active products only
SELECT 'Products (Active)' AS TableName, COUNT(*) AS TotalCount
FROM Products
WHERE IsActive = 1;

SELECT 'Demo_Retail_Product (Active)' AS TableName, COUNT(*) AS TotalCount
FROM Demo_Retail_Product
WHERE IsActive = 1;

-- Products with CategoryID
SELECT 'Products with CategoryID' AS TableName, COUNT(*) AS TotalCount
FROM Products
WHERE CategoryID IS NOT NULL;

SELECT 'Demo_Retail_Product with CategoryID' AS TableName, COUNT(*) AS TotalCount
FROM Demo_Retail_Product
WHERE CategoryID IS NOT NULL;

-- =============================================
-- CSV Item List Information
-- File: ITEM_LIST_WITH_CATEGORY_IDS.csv
-- Total items in your Excel/CSV: 1,587 products
-- =============================================

SELECT '=== CSV ITEM LIST INFO ===' AS Info;
SELECT 'Total items in ITEM_LIST_WITH_CATEGORY_IDS.csv' AS Source, 1587 AS TotalProducts;

-- Show breakdown by category from your list
SELECT 'Categories in CSV' AS Info;
SELECT 
    'Category 14 (Biscuits)' AS Category,
    'Internal products' AS Type,
    'Approx 200-300 items' AS Count
UNION ALL
SELECT 'Category 15 (Biscuits)', 'Internal products', 'Approx 50-100 items'
UNION ALL
SELECT 'Category 16 (Candles)', 'External products', 'Approx 100-200 items'
UNION ALL
SELECT 'Other Categories', 'Mixed', 'Remaining items';

-- Note: To get exact counts, run Import_And_Count_Products_From_CSV.sql
