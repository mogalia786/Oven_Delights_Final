-- =============================================
-- Query Schema for All Subcomponent Tables
-- This will show the actual column names and types
-- =============================================

PRINT '========================================';
PRINT 'RAWMATERIALS TABLE SCHEMA';
PRINT '========================================';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RawMaterials'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '========================================';
PRINT 'SUBASSEMBLIES TABLE SCHEMA';
PRINT '========================================';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SubAssemblies'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '========================================';
PRINT 'DECORATIONS TABLE SCHEMA';
PRINT '========================================';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Decorations'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '========================================';
PRINT 'TOPPINGS TABLE SCHEMA';
PRINT '========================================';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Toppings'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '========================================';
PRINT 'ACCESSORIES TABLE SCHEMA';
PRINT '========================================';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Accessories'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '========================================';
PRINT 'PACKAGING TABLE SCHEMA';
PRINT '========================================';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Packaging'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '========================================';
PRINT 'SAMPLE DATA FROM EACH TABLE';
PRINT '========================================';

PRINT '';
PRINT '--- RawMaterials Sample ---';
SELECT TOP 3 * FROM RawMaterials WHERE IsActive = 1;

PRINT '';
PRINT '--- SubAssemblies Sample ---';
SELECT TOP 3 * FROM SubAssemblies WHERE IsActive = 1;

PRINT '';
PRINT '--- Decorations Sample ---';
SELECT TOP 3 * FROM Decorations WHERE IsActive = 1;

PRINT '';
PRINT '--- Toppings Sample ---';
SELECT TOP 3 * FROM Toppings WHERE IsActive = 1;

PRINT '';
PRINT '--- Accessories Sample ---';
SELECT TOP 3 * FROM Accessories WHERE IsActive = 1;

PRINT '';
PRINT '--- Packaging Sample ---';
SELECT TOP 3 * FROM Packaging WHERE IsActive = 1;
