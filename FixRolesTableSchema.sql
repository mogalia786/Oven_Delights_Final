-- Script to fix the Roles table schema
-- This ensures the Roles table has all required columns with correct data types

-- Check if the Roles table exists and has the correct columns
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Roles')
BEGIN
    -- Create the Roles table if it doesn't exist
    CREATE TABLE [dbo].[Roles] (
        [RoleID] INT IDENTITY(1,1) PRIMARY KEY,
        [RoleName] NVARCHAR(50) NOT NULL UNIQUE,
        [Description] NVARCHAR(255) NULL,
        [IsSystemRole] BIT NOT NULL DEFAULT 0,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastModifiedDate] DATETIME NULL
    )
    PRINT 'Created Roles table with required columns.'
    
    -- Insert default roles
    INSERT INTO [Roles] ([RoleName], [Description], [IsSystemRole])
    VALUES 
        ('Administrator', 'System administrator with full access', 1),
        ('Manager', 'Branch manager with elevated permissions', 1),
        ('Staff', 'Regular staff member with standard permissions', 1);
        
    PRINT 'Added default roles: Administrator, Manager, Staff';
END
ELSE
BEGIN
    -- Add missing columns if they don't exist
    
    -- Check if RoleID exists, if not add it or rename from ID
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'RoleID')
    BEGIN
        -- If ID column exists, rename it to RoleID
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'ID')
        BEGIN
            EXEC sp_rename 'Roles.ID', 'RoleID', 'COLUMN';
            PRINT 'Renamed ID column to RoleID in Roles table.';
        END
        ELSE
        BEGIN
            ALTER TABLE [Roles] ADD [RoleID] INT IDENTITY(1,1) NOT NULL;
            PRINT 'Added RoleID column to Roles table.';
        END
        
        -- Set RoleID as primary key
        IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
                      WHERE TABLE_NAME = 'Roles' AND CONSTRAINT_TYPE = 'PRIMARY KEY')
        BEGIN
            ALTER TABLE [Roles] ADD CONSTRAINT [PK_Roles] PRIMARY KEY ([RoleID]);
            PRINT 'Set RoleID as primary key in Roles table.';
        END
    END
    
    -- Add RoleName column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'RoleName')
    BEGIN
        -- If Name column exists, rename it to RoleName
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'Name')
        BEGIN
            EXEC sp_rename 'Roles.Name', 'RoleName', 'COLUMN';
            PRINT 'Renamed Name column to RoleName in Roles table.';
        END
        ELSE
        BEGIN
            ALTER TABLE [Roles] ADD [RoleName] NVARCHAR(50) NOT NULL;
            PRINT 'Added RoleName column to Roles table.';
        END
        
        -- Add unique constraint on RoleName
        IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Roles_RoleName' AND object_id = OBJECT_ID('Roles'))
        BEGIN
            CREATE UNIQUE INDEX [IX_Roles_RoleName] ON [Roles]([RoleName]);
            PRINT 'Added unique index on RoleName column.';
        END
    END
    
    -- Add other required columns if they don't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'Description')
    BEGIN
        ALTER TABLE [Roles] ADD [Description] NVARCHAR(255) NULL;
        PRINT 'Added Description column to Roles table.';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'IsSystemRole')
    BEGIN
        ALTER TABLE [Roles] ADD [IsSystemRole] BIT NOT NULL DEFAULT 0;
        PRINT 'Added IsSystemRole column to Roles table with default value 0.';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'CreatedDate')
    BEGIN
        ALTER TABLE [Roles] ADD [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE();
        PRINT 'Added CreatedDate column to Roles table with default value GETDATE().';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'LastModifiedDate')
    BEGIN
        ALTER TABLE [Roles] ADD [LastModifiedDate] DATETIME NULL;
        PRINT 'Added LastModifiedDate column to Roles table.';
    END
    
    -- Insert default roles if they don't exist
    IF NOT EXISTS (SELECT 1 FROM [Roles] WHERE [RoleName] = 'Administrator')
    BEGIN
        INSERT INTO [Roles] ([RoleName], [Description], [IsSystemRole])
        VALUES ('Administrator', 'System administrator with full access', 1);
        PRINT 'Added Administrator role.';
    END
    
    IF NOT EXISTS (SELECT 1 FROM [Roles] WHERE [RoleName] = 'Manager')
    BEGIN
        INSERT INTO [Roles] ([RoleName], [Description], [IsSystemRole])
        VALUES ('Manager', 'Branch manager with elevated permissions', 1);
        PRINT 'Added Manager role.';
    END
    
    IF NOT EXISTS (SELECT 1 FROM [Roles] WHERE [RoleName] = 'Staff')
    BEGIN
        INSERT INTO [Roles] ([RoleName], [Description], [IsSystemRole])
        VALUES ('Staff', 'Regular staff member with standard permissions', 1);
        PRINT 'Added Staff role.';
    END
    
    PRINT 'Roles table schema verification and update completed successfully.';
END
GO
