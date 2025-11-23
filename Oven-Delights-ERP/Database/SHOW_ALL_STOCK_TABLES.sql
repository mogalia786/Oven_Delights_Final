-- Show ALL tables with 'stock' in the name and their structures

SELECT t.name AS TableName
FROM sys.tables t
WHERE t.name LIKE '%stock%'
ORDER BY t.name

-- Show structure of each stock table
DECLARE @TableName NVARCHAR(128)
DECLARE table_cursor CURSOR FOR
SELECT name FROM sys.tables WHERE name LIKE '%stock%'

OPEN table_cursor
FETCH NEXT FROM table_cursor INTO @TableName

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT ''
    PRINT '=== TABLE: ' + @TableName + ' ==='
    
    SELECT c.name AS ColumnName, t.name AS DataType, c.max_length, c.is_nullable
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID(@TableName)
    ORDER BY c.column_id
    
    FETCH NEXT FROM table_cursor INTO @TableName
END

CLOSE table_cursor
DEALLOCATE table_cursor
