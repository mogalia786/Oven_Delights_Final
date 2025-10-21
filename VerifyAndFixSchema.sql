-- Check the current structure of the Users table
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length,
    c.is_nullable,
    c.is_identity,
    ISNULL(i.is_primary_key, 0) AS is_primary_key
FROM 
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN 
    sys.index_columns ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
LEFT JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id AND i.is_primary_key = 1
WHERE 
    c.object_id = OBJECT_ID('Users');

-- Check for any role-related columns in the Users table
SELECT 
    c.name AS ColumnName,
    t.name AS DataType
FROM 
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
WHERE 
    c.object_id = OBJECT_ID('Users')
    AND (c.name LIKE '%Role%' OR c.name LIKE '%role%' OR c.name = 'Role');

-- Check the foreign key constraints on the Users table
SELECT 
    fk.name AS ForeignKeyName,
    tp.name AS ParentTable,
    cp.name AS ParentColumn,
    tr.name AS ReferencedTable,
    cr.name AS ReferencedColumn
FROM 
    sys.foreign_keys fk
INNER JOIN 
    sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
INNER JOIN 
    sys.tables tp ON fkc.parent_object_id = tp.object_id
INNER JOIN 
    sys.tables tr ON fkc.referenced_object_id = tr.object_id
INNER JOIN 
    sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
INNER JOIN 
    sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
WHERE 
    tp.name = 'Users' OR tr.name = 'Users';
