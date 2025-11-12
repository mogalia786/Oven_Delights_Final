-- Check which tables have actual data
SELECT 'Demo_Sales' AS TableName, COUNT(*) AS RecordCount FROM Demo_Sales
UNION ALL
SELECT 'Demo_SalesDetails', COUNT(*) FROM Demo_SalesDetails
UNION ALL
SELECT 'POS_InvoiceLines', COUNT(*) FROM POS_InvoiceLines
UNION ALL
SELECT 'Demo_HeldSaleItems', COUNT(*) FROM Demo_HeldSaleItems
UNION ALL
SELECT 'Sales', COUNT(*) FROM Sales;

-- Check POS_InvoiceLines structure (likely has the actual sales data)
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'POS_InvoiceLines'
ORDER BY ORDINAL_POSITION;
