-- Check if AP_Categories table exists and its structure
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Categories')
BEGIN
    PRINT 'AP_Categories table exists'
    
    -- Get column information
    SELECT 
        c.name AS ColumnName,
        t.name AS DataType,
        c.max_length AS MaxLength,
        c.is_nullable AS IsNullable,
        c.is_identity AS IsIdentity
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('AP_Categories')
    ORDER BY c.column_id
    
    -- Show sample data
    PRINT ''
    PRINT 'Sample data from AP_Categories:'
    SELECT TOP 5 * FROM AP_Categories
END
ELSE
BEGIN
    PRINT 'AP_Categories table does NOT exist'
END
GO
