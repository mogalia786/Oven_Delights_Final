-- Check the structure of the Users table
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length,
    c.is_nullable
FROM 
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
WHERE 
    c.object_id = OBJECT_ID('Users')
ORDER BY 
    c.column_id;

-- Check the structure of the Roles table
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length,
    c.is_nullable
FROM 
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
WHERE 
    c.object_id = OBJECT_ID('Roles')
ORDER BY 
    c.column_id;

-- Check for any user-role mapping tables
SELECT 
    t.name AS TableName,
    c.name AS ColumnName,
    ty.name AS DataType,
    c.max_length,
    c.is_nullable
FROM 
    sys.tables t
INNER JOIN 
    sys.columns c ON t.object_id = c.object_id
INNER JOIN 
    sys.types ty ON c.user_type_id = ty.user_type_id
WHERE 
    t.name LIKE '%User%Role%' OR
    t.name LIKE '%Role%User%' OR
    t.name LIKE '%UserRole%' OR
    t.name LIKE '%RoleUser%'
ORDER BY 
    t.name, c.column_id;

-- Check for any foreign key relationships between Users and Roles
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
    (tp.name = 'Users' AND tr.name = 'Roles') OR
    (tp.name = 'Roles' AND tr.name = 'Users');
