-- Check Products table structure for stock tracking
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;

-- Check if there's a separate stock tracking table
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Stock%'
ORDER BY TABLE_NAME;

-- Sample product data
SELECT TOP 5 
    ProductID, ProductName, CategoryID, StockLevel, 
    UnitOfMeasure, IsActive
FROM Products;
