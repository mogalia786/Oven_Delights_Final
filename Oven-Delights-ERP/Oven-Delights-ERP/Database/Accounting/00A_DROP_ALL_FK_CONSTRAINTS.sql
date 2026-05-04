-- =============================================
-- DROP ALL FOREIGN KEY CONSTRAINTS REFERENCING ChartOfAccounts
-- Run this FIRST to allow table recreation
-- =============================================

-- Find and drop all foreign keys referencing ChartOfAccounts
DECLARE @SQL NVARCHAR(MAX) = '';

SELECT @SQL = @SQL + 
    'ALTER TABLE [' + OBJECT_SCHEMA_NAME(parent_object_id) + '].[' + OBJECT_NAME(parent_object_id) + '] ' +
    'DROP CONSTRAINT [' + name + '];' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('ChartOfAccounts')
   OR parent_object_id = OBJECT_ID('ChartOfAccounts');

IF @SQL <> ''
BEGIN
    PRINT 'Dropping foreign key constraints...';
    PRINT @SQL;
    EXEC sp_executesql @SQL;
    PRINT '✓ All foreign key constraints dropped';
END
ELSE
BEGIN
    PRINT 'No foreign key constraints found';
END
GO

PRINT '';
PRINT 'NEXT STEP: Run 00_CREATE_CHART_OF_ACCOUNTS_TABLE.sql';
GO
