-- Verify Users table structure
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
    c.object_id = OBJECT_ID('Users')
ORDER BY 
    c.column_id;

-- Check foreign key constraints
SELECT 
    fk.name AS ConstraintName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTableName,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumnName
FROM 
    sys.foreign_keys fk
INNER JOIN 
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
WHERE 
    fk.parent_object_id = OBJECT_ID('Users');

-- Check indexes on the Users table
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_primary_key AS IsPrimaryKey,
    i.is_unique_constraint AS IsUniqueConstraint,
    i.is_unique AS IsUnique,
    STUFF((
        SELECT ', ' + c.name
        FROM sys.index_columns ic
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id
        ORDER BY ic.key_ordinal
        FOR XML PATH('')
    ), 1, 2, '') AS IndexedColumns
FROM 
    sys.indexes i
WHERE 
    i.object_id = OBJECT_ID('Users')
    AND i.type > 0  -- Exclude heap
ORDER BY 
    i.is_primary_key DESC, i.is_unique_constraint DESC, i.name;
