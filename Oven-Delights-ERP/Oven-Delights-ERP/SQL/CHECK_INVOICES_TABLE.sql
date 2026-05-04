-- Check Invoices table structure
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Invoices'
ORDER BY ORDINAL_POSITION;

-- Check row count
SELECT COUNT(*) AS RecordCount FROM Invoices;

-- Sample data
SELECT TOP 5 * FROM Invoices ORDER BY SalesID, InvoiceLineID;
