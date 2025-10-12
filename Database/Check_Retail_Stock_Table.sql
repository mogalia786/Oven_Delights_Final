-- Check if Retail_Stock table exists and its structure

IF OBJECT_ID('dbo.Retail_Stock', 'U') IS NOT NULL
BEGIN
    PRINT 'Retail_Stock table EXISTS';
    PRINT '';
    PRINT 'Columns:';
    
    SELECT 
        c.name AS ColumnName,
        t.name AS DataType,
        c.max_length AS MaxLength,
        c.is_nullable AS IsNullable
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('dbo.Retail_Stock')
    ORDER BY c.column_id;
    
    PRINT '';
    PRINT 'Sample data:';
    SELECT TOP 10 * FROM dbo.Retail_Stock;
END
ELSE
BEGIN
    PRINT 'Retail_Stock table DOES NOT EXIST!';
    PRINT 'You need to create it first.';
END
