-- Check what StockID and VariantID reference

-- Check for foreign keys on Retail_Stock
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys AS fk
INNER JOIN sys.foreign_key_columns AS fc ON fk.object_id = fc.constraint_object_id
WHERE OBJECT_NAME(fk.parent_object_id) = 'Retail_Stock';

PRINT '';
PRINT '--- Checking possible tables ---';
PRINT '';

-- Check if ProductVariants table exists
IF OBJECT_ID('dbo.ProductVariants', 'U') IS NOT NULL
BEGIN
    PRINT 'ProductVariants table EXISTS';
    SELECT TOP 5 VariantID, VariantName, ProductID FROM dbo.ProductVariants;
END
ELSE
    PRINT 'ProductVariants table does NOT exist';

PRINT '';

-- Check if Products table exists
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
BEGIN
    PRINT 'Products table EXISTS';
    SELECT TOP 5 ProductID, ProductName FROM dbo.Products;
END
ELSE
    PRINT 'Products table does NOT exist';

PRINT '';

-- Try to join Retail_Stock with possible tables
PRINT '--- Sample join to get product names ---';
SELECT TOP 10
    rs.StockID,
    rs.VariantID,
    rs.QtyOnHand,
    pv.VariantName,
    p.ProductName
FROM dbo.Retail_Stock rs
LEFT JOIN dbo.ProductVariants pv ON rs.VariantID = pv.VariantID
LEFT JOIN dbo.Products p ON pv.ProductID = p.ProductID;
