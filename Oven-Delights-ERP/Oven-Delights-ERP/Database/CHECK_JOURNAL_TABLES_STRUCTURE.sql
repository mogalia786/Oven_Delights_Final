-- Check JournalHeaders table structure
SELECT 
    'JournalHeaders' AS TableName,
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.JournalHeaders')
ORDER BY c.column_id;

PRINT '';
PRINT '-----------------------------------';
PRINT '';

-- Check JournalLines table structure
SELECT 
    'JournalLines' AS TableName,
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.JournalLines')
ORDER BY c.column_id;
