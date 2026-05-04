-- Check for adhoc cost fields in sub-recipe and product tables

-- Check Demo_SubRecipe_Master columns
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_Master'
ORDER BY ORDINAL_POSITION;

-- Check Demo_Product_Recipe_Master columns
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Product_Recipe_Master'
ORDER BY ORDINAL_POSITION;

-- Check if there's an adhoc cost or markup field
SELECT TOP 1 * FROM Demo_SubRecipe_Master;

SELECT TOP 1 * FROM Demo_Product_Recipe_Master;
