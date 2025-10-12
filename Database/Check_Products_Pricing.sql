-- Check Products table for pricing columns

SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Products')
ORDER BY c.column_id;

PRINT '';
PRINT '--- Sample Products with pricing ---';
SELECT TOP 10 
    ProductID,
    ProductName,
    *
FROM dbo.Products;

PRINT '';
PRINT '--- Check Retail_Stock for pricing columns ---';
SELECT 
    c.name AS ColumnName,
    t.name AS DataType
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Retail_Stock')
AND (c.name LIKE '%price%' OR c.name LIKE '%cost%')
ORDER BY c.column_id;
