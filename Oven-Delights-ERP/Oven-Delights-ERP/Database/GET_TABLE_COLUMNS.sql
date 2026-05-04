-- Get Demo_SubRecipe_Master columns
SELECT 'Demo_SubRecipe_Master' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_Master'
ORDER BY ORDINAL_POSITION;

-- Get Demo_Retail_Product columns
SELECT 'Demo_Retail_Product' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;

-- Get Demo_SubRecipe_Ingredients columns
SELECT 'Demo_SubRecipe_Ingredients' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_Ingredients'
ORDER BY ORDINAL_POSITION;
