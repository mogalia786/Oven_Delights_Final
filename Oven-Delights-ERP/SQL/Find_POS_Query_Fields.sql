-- Check all columns in Demo_Retail_Product to see what POS might be using
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;

-- Check if there are any views the POS might be using
SELECT TABLE_NAME, TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Demo_Retail%' OR TABLE_NAME LIKE '%POS%' OR TABLE_NAME LIKE '%Product%'
ORDER BY TABLE_TYPE, TABLE_NAME;

-- Check for stored procedures the POS might call
SELECT ROUTINE_NAME, ROUTINE_TYPE
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME LIKE '%Product%' OR ROUTINE_NAME LIKE '%POS%' OR ROUTINE_NAME LIKE '%Retail%'
ORDER BY ROUTINE_TYPE, ROUTINE_NAME;

-- Sample the actual data to see what's populated
SELECT TOP 5
    ProductID,
    Code,
    Name,
    Description,
    ProductType,
    Category,
    BranchID,
    SKU,
    ExternalBarcode,
    IsActive
FROM Demo_Retail_Product
WHERE BranchID = 6;
