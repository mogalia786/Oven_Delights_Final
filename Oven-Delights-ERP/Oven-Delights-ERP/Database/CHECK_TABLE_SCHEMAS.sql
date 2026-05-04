-- Check actual column names in Demo_Retail_Product
SELECT TOP 1 * FROM Demo_Retail_Product;

-- Check actual column names in Demo_SubRecipe_Master
SELECT TOP 1 * FROM Demo_SubRecipe_Master;

-- Check actual column names in Demo_SubRecipe_BOM
SELECT TOP 1 * FROM Demo_SubRecipe_BOM;

-- Get column names for Demo_Retail_Product
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;

-- Get column names for Demo_SubRecipe_Master
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_Master'
ORDER BY ORDINAL_POSITION;

-- Get column names for Demo_SubRecipe_BOM
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_BOM'
ORDER BY ORDINAL_POSITION;
