-- Check if InternalOrderHeader table exists and its structure
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'InternalOrderHeader')
BEGIN
    PRINT '✅ InternalOrderHeader table exists';
    
    -- Show columns
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'InternalOrderHeader'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT '❌ InternalOrderHeader table does NOT exist';
    PRINT 'You need to run Create_InternalOrder_Tables.sql first';
END
GO
