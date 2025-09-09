-- First, check if the foreign key constraint already exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Users_Roles')
BEGIN
    -- Drop the existing foreign key constraint if it exists
    ALTER TABLE Users
    DROP CONSTRAINT FK_Users_Roles;
    
    PRINT 'Dropped existing foreign key constraint FK_Users_Roles.';
END

-- Check if the RoleID column exists in the Users table
IF EXISTS (SELECT * FROM sys.columns 
           WHERE object_id = OBJECT_ID('Users') 
           AND name = 'RoleID')
BEGIN
    -- Ensure the RoleID column is not nullable
    ALTER TABLE Users
    ALTER COLUMN RoleID INT NOT NULL;
    
    -- Add the foreign key constraint
    ALTER TABLE Users
    ADD CONSTRAINT FK_Users_Roles
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID);
    
    PRINT 'Added foreign key constraint FK_Users_Roles from Users.RoleID to Roles.RoleID';
    
    -- Set a default role for existing users if needed
    DECLARE @defaultRoleID INT;
    SELECT @defaultRoleID = MIN(RoleID) FROM Roles;
    
    UPDATE Users
    SET RoleID = @defaultRoleID
    WHERE RoleID IS NULL;
    
    PRINT 'Updated existing users with default role.';
END
ELSE
BEGIN
    -- If RoleID column doesn't exist, add it
    ALTER TABLE Users
    ADD RoleID INT NOT NULL
    CONSTRAINT DF_Users_RoleID DEFAULT (1)  -- Default to role ID 1 (adjust as needed)
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID);
    
    PRINT 'Added RoleID column to Users table with foreign key constraint.';
END

-- Verify the changes
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

-- Show the foreign key constraint
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
    tp.name = 'Users' AND fk.name = 'FK_Users_Roles';
