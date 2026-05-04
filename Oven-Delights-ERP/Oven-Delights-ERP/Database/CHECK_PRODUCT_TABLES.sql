-- Check if Demo_Product_BOM exists and has data

-- Find all product-related tables
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Product%'
AND TABLE_NAME NOT LIKE '%Retail%'
ORDER BY TABLE_NAME;

-- Check Demo_Product_BOM structure
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Product_BOM'
ORDER BY ORDINAL_POSITION;

-- Check if Demo_Product_BOM has any data
SELECT COUNT(*) AS RowCount FROM Demo_Product_BOM;

-- Check a sample of Demo_Product_BOM data
SELECT TOP 5 * FROM Demo_Product_BOM;

-- Check Demo_Product_Recipe_Master
SELECT COUNT(*) AS RowCount FROM Demo_Product_Recipe_Master;
SELECT TOP 5 * FROM Demo_Product_Recipe_Master;
