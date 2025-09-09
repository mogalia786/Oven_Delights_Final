-- Check the structure of the Roles table
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable,
    ISNULL(i.is_primary_key, 0) AS IsPrimaryKey,
    c.is_identity AS IsIdentity,
    ISNULL(OBJECT_DEFINITION(dc.object_id), '') AS DefaultValue
FROM 
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id AND i.is_primary_key = 1
LEFT OUTER JOIN
    sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE 
    c.object_id = OBJECT_ID('Roles')
ORDER BY 
    c.column_id;
