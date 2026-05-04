-- Check all columns in Demo_Retail_Product to find required (NOT NULL) columns
SELECT 
    c.name AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType,
    c.max_length,
    c.is_nullable,
    c.is_identity,
    ISNULL(dc.definition, '') AS DefaultValue
FROM sys.columns c
INNER JOIN sys.tables t ON c.object_id = t.object_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE t.name = 'Demo_Retail_Product'
ORDER BY c.column_id;
