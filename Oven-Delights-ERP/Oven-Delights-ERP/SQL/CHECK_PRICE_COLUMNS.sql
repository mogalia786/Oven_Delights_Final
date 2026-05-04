-- Check actual column names in Demo_Retail_Price table
SELECT 
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Price'
ORDER BY ORDINAL_POSITION;
