-- Get the ACTUAL schema of Products table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;

-- Show sample data to see actual column names
SELECT TOP 5 * FROM Products;
