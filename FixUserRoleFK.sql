-- Check if the foreign key constraint exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Users_Roles')
BEGIN
    -- Drop the existing foreign key constraint if it exists
    ALTER TABLE Users
    DROP CONSTRAINT FK_Users_Roles;
    
    PRINT 'Dropped existing foreign key constraint FK_Users_Roles';
END

-- Add the foreign key constraint
ALTER TABLE Users
ADD CONSTRAINT FK_Users_Roles
FOREIGN KEY (RoleID) REFERENCES Roles(RoleID);

PRINT 'Added foreign key constraint FK_Users_Roles from Users.RoleID to Roles.RoleID';

-- Verify the foreign key was created
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

-- Check if there are any users with NULL RoleID
SELECT COUNT(*) AS UsersWithNullRoleID
FROM Users
WHERE RoleID IS NULL;

-- If there are users with NULL RoleID, set them to a default role (e.g., RoleID = 1)
-- Uncomment and modify the following lines if needed
/*
DECLARE @defaultRoleID INT = 1; -- Change this to the appropriate default role ID

UPDATE Users
SET RoleID = @defaultRoleID
WHERE RoleID IS NULL;

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' users with default role ID ' + CAST(@defaultRoleID AS VARCHAR(10));
*/
