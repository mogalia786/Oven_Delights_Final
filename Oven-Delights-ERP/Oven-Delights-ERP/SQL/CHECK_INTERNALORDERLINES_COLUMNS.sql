-- Check the actual column names in InternalOrderLines table
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'InternalOrderLines'
ORDER BY ORDINAL_POSITION;

-- Show sample data
SELECT TOP 3 * FROM InternalOrderLines;
