-- Check actual table schemas to fix import script
USE OvenDelightsERP;
GO

PRINT '========================================';
PRINT 'Products Table Columns:';
PRINT '========================================';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;
GO

PRINT '';
PRINT '========================================';
PRINT 'ProductInventory Table Columns:';
PRINT '========================================';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'ProductInventory'
ORDER BY ORDINAL_POSITION;
GO

PRINT '';
PRINT '========================================';
PRINT 'Demo_Retail_Product Table Columns:';
PRINT '========================================';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;
GO

PRINT '';
PRINT '========================================';
PRINT 'Demo_Retail_Variant Table Columns:';
PRINT '========================================';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Variant'
ORDER BY ORDINAL_POSITION;
GO

PRINT '';
PRINT '========================================';
PRINT 'Demo_Retail_Price Table Columns:';
PRINT '========================================';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Price'
ORDER BY ORDINAL_POSITION;
GO

PRINT '';
PRINT '========================================';
PRINT 'Demo_Retail_Stock Table Columns:';
PRINT '========================================';
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Stock'
ORDER BY ORDINAL_POSITION;
GO
