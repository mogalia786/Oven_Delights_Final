-- ========================================
-- CHECK TILL AND SALES TABLE SCHEMA
-- Identify correct column names
-- ========================================

PRINT '========================================';
PRINT 'CHECKING TILL TABLES SCHEMA';
PRINT '========================================';
PRINT '';

-- Check if TillPoints table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'TillPoints')
BEGIN
    PRINT 'TillPoints table columns:';
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'TillPoints'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT '❌ TillPoints table does NOT exist';
END

PRINT '';
PRINT '========================================';

-- Check for alternative till table names
PRINT 'Searching for Till-related tables...';
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Till%' OR TABLE_NAME LIKE '%Register%' OR TABLE_NAME LIKE '%POS%'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '========================================';

-- Check Demo_Sales table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Demo_Sales')
BEGIN
    PRINT 'Demo_Sales table columns:';
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Demo_Sales'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT '❌ Demo_Sales table does NOT exist';
END

PRINT '';
PRINT '========================================';

-- Check for alternative sales table names
PRINT 'Searching for Sales-related tables...';
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Sale%' OR TABLE_NAME LIKE '%Transaction%' OR TABLE_NAME LIKE '%Invoice%'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '========================================';

-- Check Users table for cashier info
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    PRINT 'Users table columns (for cashier lookup):';
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Users'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT '❌ Users table does NOT exist';
END

PRINT '';
PRINT '========================================';
PRINT 'SCHEMA CHECK COMPLETE';
PRINT '========================================';
GO
