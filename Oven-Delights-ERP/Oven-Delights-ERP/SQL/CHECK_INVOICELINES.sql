-- Check InvoiceLines structure
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'InvoiceLines'
ORDER BY ORDINAL_POSITION;

-- Check row count
SELECT 'InvoiceLines' AS TableName, COUNT(*) AS RecordCount FROM InvoiceLines
UNION ALL
SELECT 'Sales', COUNT(*) FROM Sales;
