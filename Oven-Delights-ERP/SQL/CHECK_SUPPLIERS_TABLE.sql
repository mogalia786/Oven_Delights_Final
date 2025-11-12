-- Check Suppliers table structure
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Suppliers'
ORDER BY ORDINAL_POSITION;

-- Check if Suppliers table exists and has data
SELECT COUNT(*) AS SupplierCount FROM Suppliers;

-- Sample data
SELECT TOP 5 * FROM Suppliers;
