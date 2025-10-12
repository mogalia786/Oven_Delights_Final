-- Check Retail_Variant table structure and data

SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Retail_Variant')
ORDER BY c.column_id;

PRINT '';
PRINT '--- All Retail_Variant records ---';
SELECT * FROM dbo.Retail_Variant;

PRINT '';
PRINT '--- Join Retail_Stock with Retail_Variant and Products ---';
SELECT 
    rs.StockID,
    rs.VariantID,
    rs.QtyOnHand,
    rv.*,
    p.ProductName
FROM dbo.Retail_Stock rs
LEFT JOIN dbo.Retail_Variant rv ON rs.VariantID = rv.VariantID
LEFT JOIN dbo.Products p ON rv.ProductID = p.ProductID
WHERE rs.StockID = 7;
