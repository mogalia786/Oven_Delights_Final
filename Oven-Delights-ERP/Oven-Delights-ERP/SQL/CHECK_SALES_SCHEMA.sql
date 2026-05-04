-- ========================================
-- CHECK SALES TABLE SCHEMA
-- Identify correct column names for sales data
-- ========================================

PRINT '========================================';
PRINT 'CHECKING SALES TABLE SCHEMA';
PRINT '========================================';
PRINT '';

-- Check if Sales table exists
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Sales')
BEGIN
    PRINT 'Sales table columns:';
    SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Sales'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT '❌ Sales table does NOT exist';
END

PRINT '';
PRINT '========================================';

-- Check for alternative sales table names
PRINT 'Searching for Sales/Transaction tables...';
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Sale%' 
   OR TABLE_NAME LIKE '%Transaction%' 
   OR TABLE_NAME LIKE '%Invoice%'
   OR TABLE_NAME LIKE '%Receipt%'
   OR TABLE_NAME LIKE '%POS%'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '========================================';
PRINT 'SCHEMA CHECK COMPLETE';
PRINT '========================================';
PRINT '';
PRINT 'Please share a screenshot of the results above';
PRINT 'so I can create the correct stored procedure.';
GO
