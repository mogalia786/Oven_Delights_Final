-- =============================================
-- CHECK RETAIL_STOCK TABLE SCHEMA
-- =============================================

PRINT 'Checking Retail_Stock table schema...';
PRINT '';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Stock')
BEGIN
    PRINT '✅ Retail_Stock table exists';
    PRINT '';
    PRINT 'Columns:';
    
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Retail_Stock'
    ORDER BY ORDINAL_POSITION;
END
ELSE
    PRINT '❌ Retail_Stock table does not exist';

PRINT '';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
BEGIN
    PRINT '✅ RetailStock table exists';
    PRINT '';
    PRINT 'Columns:';
    
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'RetailStock'
    ORDER BY ORDINAL_POSITION;
END
ELSE
    PRINT '❌ RetailStock table does not exist';
