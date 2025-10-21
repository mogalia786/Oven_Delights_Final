-- Check if RoleID column already exists in Users table
IF NOT EXISTS (SELECT * FROM sys.columns 
               WHERE object_id = OBJECT_ID(N'[dbo].[Users]') 
               AND name = 'RoleID')
BEGIN
    -- Add RoleID column with a default value of 1 (for existing records)
    ALTER TABLE [dbo].[Users]
    ADD RoleID INT NOT NULL 
    CONSTRAINT DF_Users_RoleID DEFAULT 1
    WITH VALUES;
    
    PRINT 'Added RoleID column to Users table with default value 1';
    
    -- Add foreign key constraint to Roles table
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
    BEGIN
        ALTER TABLE [dbo].[Users]
        ADD CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RoleID) REFERENCES [dbo].[Roles](RoleID);
        
        PRINT 'Added foreign key constraint FK_Users_Roles';
    END
    ELSE
    BEGIN
        PRINT 'Warning: Roles table not found. Foreign key constraint not added.';
    END
END
ELSE
BEGIN
    PRINT 'RoleID column already exists in Users table';
    
    -- Check if the foreign key constraint exists
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys 
                  WHERE name = 'FK_Users_Roles')
    BEGIN
        -- Add foreign key constraint if it doesn't exist
        IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
        BEGIN
            ALTER TABLE [dbo].[Users]
            ADD CONSTRAINT FK_Users_Roles
            FOREIGN KEY (RoleID) REFERENCES [dbo].[Roles](RoleID);
            
            PRINT 'Added foreign key constraint FK_Users_Roles';
        END
        ELSE
        BEGIN
            PRINT 'Warning: Roles table not found. Foreign key constraint not added.';
        END
    END
    ELSE
    BEGIN
        PRINT 'Foreign key constraint FK_Users_Roles already exists';
    END
END

-- Verify the column was added
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
    AND c.name = 'RoleID';
