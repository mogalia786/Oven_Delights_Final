-- First, check if the RoleID column already exists in the Users table
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID('Users') 
               AND name = 'RoleID')
BEGIN
    -- Add the RoleID column to the Users table
    ALTER TABLE Users
    ADD RoleID INT NULL
    
    -- Add a default role (you may need to adjust this based on your requirements)
    DECLARE @defaultRoleID INT
    SELECT @defaultRoleID = MIN(RoleID) FROM Roles
    
    -- Update existing rows with a default role
    UPDATE Users
    SET RoleID = @defaultRoleID
    WHERE RoleID IS NULL
    
    -- Make the column NOT NULL after updating all rows
    ALTER TABLE Users
    ALTER COLUMN RoleID INT NOT NULL
    
    PRINT 'Added RoleID column to Users table and set default values.'
END
ELSE
BEGIN
    PRINT 'RoleID column already exists in the Users table.'
END

-- Verify the foreign key constraint
IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
               WHERE name = 'FK_Users_Roles')
BEGIN
    -- Add the foreign key constraint
    ALTER TABLE Users
    ADD CONSTRAINT FK_Users_Roles
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
    
    PRINT 'Added foreign key constraint FK_Users_Roles.'
END
ELSE
BEGIN
    PRINT 'Foreign key constraint FK_Users_Roles already exists.'
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
