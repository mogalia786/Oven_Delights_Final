-- Check the actual schema of Demo_Retail_Product table
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;

-- Also check what the actual data looks like for the missing ProductIDs
SELECT * FROM Demo_Retail_Product WHERE ProductID IN (56791, 56893);
