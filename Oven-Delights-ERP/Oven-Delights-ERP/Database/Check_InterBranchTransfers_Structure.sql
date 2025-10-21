-- Check InterBranchTransfers table structure

IF OBJECT_ID('dbo.InterBranchTransfers', 'U') IS NOT NULL
BEGIN
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE,
        COLUMN_DEFAULT
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'InterBranchTransfers'
    ORDER BY ORDINAL_POSITION;
END
ELSE
BEGIN
    PRINT 'InterBranchTransfers table does NOT exist!';
    PRINT 'The table needs to be created.';
END
