-- Check if SellingPrice column allows NULL
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.is_nullable AS AllowsNull,
    c.max_length AS MaxLength
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Demo_Retail_Price')
AND c.name = 'SellingPrice'

PRINT ''
PRINT 'If AllowsNull = 0, then the column does NOT allow NULL values'
PRINT 'If AllowsNull = 1, then the column DOES allow NULL values'
PRINT ''

-- If needed, make SellingPrice nullable
-- ALTER TABLE Demo_Retail_Price ALTER COLUMN SellingPrice DECIMAL(18,2) NULL
