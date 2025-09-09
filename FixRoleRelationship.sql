-- First, check if the foreign key constraint exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Users_Roles')
BEGIN
    -- Drop the existing foreign key constraint
    ALTER TABLE Users
    DROP CONSTRAINT FK_Users_Roles;
    
    PRINT 'Dropped existing foreign key constraint FK_Users_Roles';
END

-- Check if RoleID column exists in Users table
IF EXISTS (SELECT * FROM sys.columns 
           WHERE object_id = OBJECT_ID('Users') 
           AND name = 'RoleID')
BEGIN
    -- Add the foreign key constraint
    ALTER TABLE Users
    ADD CONSTRAINT FK_Users_Roles
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID);
    
    PRINT 'Added foreign key constraint FK_Users_Roles from Users.RoleID to Roles.RoleID';
    
    -- Set default role for existing users if needed
    DECLARE @defaultRoleID INT;
    SELECT @defaultRoleID = MIN(RoleID) FROM Roles;
    
    UPDATE Users
    SET RoleID = @defaultRoleID
    WHERE RoleID IS NULL;
    
    PRINT 'Updated existing users with default role.';
END
ELSE
BEGIN
    -- If RoleID column doesn't exist, add it with the foreign key constraint
    ALTER TABLE Users
    ADD RoleID INT NOT NULL
    CONSTRAINT DF_Users_RoleID DEFAULT (1)
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID);
    
    PRINT 'Added RoleID column to Users table with foreign key constraint.';
END

-- Verify the changes
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
    tp.name = 'Users' AND tr.name = 'Roles';
