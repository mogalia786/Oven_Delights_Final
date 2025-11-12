-- Check the ReOrderBookLines table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ReOrderBookLines'
ORDER BY ORDINAL_POSITION;

-- Check the stored procedure that inserts into ReOrderBookLines
EXEC sp_helptext 'sp_AddProductToReOrderBook';
