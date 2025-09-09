-- Script to fix the Users table schema for login functionality
-- This script ensures the Users table has all required columns with correct data types

-- First, check if the Users table exists and has the correct columns
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    -- Create the Users table if it doesn't exist
    CREATE TABLE [dbo].[Users] (
        [UserID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL UNIQUE,
        [Email] NVARCHAR(128) NOT NULL UNIQUE,
        [PasswordHash] NVARCHAR(255) NOT NULL,
        [Salt] NVARCHAR(100) NULL,
        [FirstName] NVARCHAR(50) NULL,
        [LastName] NVARCHAR(50) NULL,
        [RoleID] INT NOT NULL,
        [BranchID] INT NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [LastLogin] DATETIME NULL,
        [FailedLoginAttempts] INT NOT NULL DEFAULT 0,
        [IsLockedOut] BIT NOT NULL DEFAULT 0,
        [LockoutEnd] DATETIME NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastModifiedDate] DATETIME NULL,
        CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID])
    )
    PRINT 'Created Users table with required columns.'
END
ELSE
BEGIN
    -- Add missing columns if they don't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'UserID')
    BEGIN
        -- If ID column exists, rename it to UserID
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'ID')
        BEGIN
            EXEC sp_rename 'Users.ID', 'UserID', 'COLUMN';
            PRINT 'Renamed ID column to UserID in Users table.'
        END
        ELSE
        BEGIN
            ALTER TABLE [Users] ADD [UserID] INT IDENTITY(1,1) NOT NULL;
            PRINT 'Added UserID column to Users table.'
        END
        
        -- Set UserID as primary key
        IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
                      WHERE TABLE_NAME = 'Users' AND CONSTRAINT_TYPE = 'PRIMARY KEY')
        BEGIN
            ALTER TABLE [Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY ([UserID]);
            PRINT 'Set UserID as primary key in Users table.';
        END
    END

    -- Add Username column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'Username')
    BEGIN
        -- If Email exists, copy its value to Username
        IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'Email')
        BEGIN
            ALTER TABLE [Users] ADD [Username] NVARCHAR(50) NULL;
            UPDATE [Users] SET [Username] = [Email];
            ALTER TABLE [Users] ALTER COLUMN [Username] NVARCHAR(50) NOT NULL;
            PRINT 'Added Username column and copied values from Email.';
        END
        ELSE
        BEGIN
            ALTER TABLE [Users] ADD [Username] NVARCHAR(50) NOT NULL;
            PRINT 'Added Username column to Users table.';
        END
        
        -- Add unique constraint on Username
        IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Users_Username' AND object_id = OBJECT_ID('Users'))
        BEGIN
            CREATE UNIQUE INDEX [IX_Users_Username] ON [Users]([Username]);
            PRINT 'Added unique index on Username column.';
        END
    END

    -- Add other required columns if they don't exist
    DECLARE @SQL NVARCHAR(MAX);
    
    -- Add Email column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'Email')
    BEGIN
        ALTER TABLE [Users] ADD [Email] NVARCHAR(128) NOT NULL;
        PRINT 'Added Email column to Users table.';
    END
    
    -- Add PasswordHash column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'PasswordHash')
    BEGIN
        ALTER TABLE [Users] ADD [PasswordHash] NVARCHAR(255) NOT NULL;
        PRINT 'Added PasswordHash column to Users table.';
    END
    
    -- Add Salt column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'Salt')
    BEGIN
        ALTER TABLE [Users] ADD [Salt] NVARCHAR(100) NULL;
        PRINT 'Added Salt column to Users table.';
    END
    
    -- Add RoleID column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'RoleID')
    BEGIN
        ALTER TABLE [Users] ADD [RoleID] INT NOT NULL DEFAULT 1; -- Default to 1 (Admin)
        PRINT 'Added RoleID column to Users table with default value 1 (Admin).';
        
        -- Add foreign key constraint if it doesn't exist
        IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Users_Roles')
        BEGIN
            -- First, make sure the Roles table exists and has a RoleID column
            IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Roles')
            AND EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Roles' AND COLUMN_NAME = 'RoleID')
            BEGIN
                ALTER TABLE [Users] WITH CHECK ADD CONSTRAINT [FK_Users_Roles] 
                FOREIGN KEY([RoleID]) REFERENCES [Roles] ([RoleID]);
                PRINT 'Added foreign key constraint FK_Users_Roles.';
            END
            ELSE
            BEGIN
                PRINT 'Warning: Could not add foreign key constraint - Roles table or RoleID column does not exist.';
            END
        END
    END
    
    -- Add other optional columns with default values if they don't exist
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'IsActive')
    BEGIN
        ALTER TABLE [Users] ADD [IsActive] BIT NOT NULL DEFAULT 1;
        PRINT 'Added IsActive column to Users table with default value 1.';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'FailedLoginAttempts')
    BEGIN
        ALTER TABLE [Users] ADD [FailedLoginAttempts] INT NOT NULL DEFAULT 0;
        PRINT 'Added FailedLoginAttempts column to Users table with default value 0.';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'IsLockedOut')
    BEGIN
        ALTER TABLE [Users] ADD [IsLockedOut] BIT NOT NULL DEFAULT 0;
        PRINT 'Added IsLockedOut column to Users table with default value 0.';
    END
    
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Users' AND COLUMN_NAME = 'LockoutEnd')
    BEGIN
        ALTER TABLE [Users] ADD [LockoutEnd] DATETIME NULL;
        PRINT 'Added LockoutEnd column to Users table.';
    END
    
    PRINT 'Users table schema verification and update completed successfully.';
END
GO

-- Create a default admin user if no users exist
IF NOT EXISTS (SELECT 1 FROM [Users])
BEGIN
    -- Generate a random salt
    DECLARE @Salt NVARCHAR(100) = NEWID();
    DECLARE @Password NVARCHAR(100) = 'Admin@123'; -- Default password
    DECLARE @HashedPassword NVARCHAR(255);
    
    -- In a real application, use proper password hashing (e.g., bcrypt)
    -- For this example, we'll use a simple hash (not secure for production)
    SET @HashedPassword = HASHBYTES('SHA2_256', @Password + @Salt);
    
    -- Get the Admin RoleID
    DECLARE @AdminRoleID INT;
    SELECT @AdminRoleID = RoleID FROM [Roles] WHERE [RoleName] = 'Administrator';
    
    IF @AdminRoleID IS NULL
    BEGIN
        -- If no Admin role exists, create one
        INSERT INTO [Roles] ([RoleName], [Description], [IsSystemRole], [CreatedDate])
        VALUES ('Administrator', 'System administrator with full access', 1, GETDATE());
        
        SET @AdminRoleID = SCOPE_IDENTITY();
    END
    
    -- Insert the default admin user
    INSERT INTO [Users] (
        [Username], 
        [Email], 
        [PasswordHash], 
        [Salt], 
        [FirstName], 
        [LastName], 
        [RoleID], 
        [IsActive],
        [CreatedDate]
    )
    VALUES (
        'admin', 
        'admin@ovendelights.com', 
        @HashedPassword, 
        @Salt, 
        'System', 
        'Administrator', 
        @AdminRoleID, 
        1,
        GETDATE()
    );
    
    PRINT 'Created default admin user with username: admin and password: Admin@123';
    PRINT 'IMPORTANT: Change the default password after first login!';
END
ELSE
BEGIN
    PRINT 'Users already exist in the database. No default user was created.';
END
GO
