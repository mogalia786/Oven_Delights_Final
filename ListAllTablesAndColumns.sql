-- List all tables and their columns in the database
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length AS MaxLength,
    c.precision AS Precision,
    c.scale AS Scale,
    c.is_nullable AS IsNullable,
    ISNULL(ix.is_primary_key, 0) AS IsPrimaryKey,
    c.is_identity AS IsIdentity
FROM 
    sys.tables t
INNER JOIN 
    sys.columns c ON t.object_id = c.object_id
INNER JOIN 
    sys.types ty ON c.user_type_id = ty.user_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
LEFT OUTER JOIN 
    sys.indexes ix ON ic.object_id = ix.object_id AND ic.index_id = ix.index_id AND ix.is_primary_key = 1
ORDER BY 
    t.name, c.column_id;
