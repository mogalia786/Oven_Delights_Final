-- Check if SubcategoryID column allows NULL in Demo_Retail_Product
SELECT 
    c.name AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType,
    c.max_length,
    c.is_nullable,
    c.is_identity
FROM sys.columns c
INNER JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.name = 'Demo_Retail_Product'
    AND c.name = 'SubcategoryID';
