-- Quick check to see actual column names in Products table
SELECT TOP 5 * FROM Products;

-- Check specific columns
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Products' 
  AND COLUMN_NAME LIKE '%Active%';

-- Check if there's a status or active-like column
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Products' 
  AND (COLUMN_NAME LIKE '%Status%' OR COLUMN_NAME LIKE '%Active%' OR COLUMN_NAME LIKE '%Enabled%');
