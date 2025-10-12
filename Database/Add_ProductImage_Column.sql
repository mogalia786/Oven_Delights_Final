-- Add ProductImage column to Products table if it doesn't exist

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Products') AND name = 'ProductImage')
BEGIN
    PRINT 'Adding ProductImage column to Products table...';
    ALTER TABLE dbo.Products ADD ProductImage VARBINARY(MAX) NULL;
    PRINT 'ProductImage column added successfully!';
END
ELSE
BEGIN
    PRINT 'ProductImage column already exists in Products table.';
END

GO

-- Verify the column was added
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Products')
AND c.name = 'ProductImage';

PRINT '';
PRINT 'ProductImage column is ready for storing images as BLOB!';
