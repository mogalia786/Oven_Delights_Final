-- Script to update Users table to match application requirements

-- First, check if the table exists
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Users')
BEGIN
    PRINT 'Users table does not exist. Creating it...';
    
    CREATE TABLE [dbo].[Users] (
        [UserID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Username] [nvarchar](50) NOT NULL UNIQUE,
        [Email] [nvarchar](128) NOT NULL UNIQUE,
        [PasswordHash] [nvarchar](255) NOT NULL,
        [FirstName] [nvarchar](50) NOT NULL,
        [LastName] [nvarchar](50) NOT NULL,
        [Phone] [nvarchar](20) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [RoleID] [int] NOT NULL,
        [BranchID] [int] NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [CreatedBy] [int] NULL,
        [ModifiedDate] [datetime] NULL,
        [ModifiedBy] [int] NULL,
        [LastLogin] [datetime] NULL,
        [FailedLoginAttempts] [int] NOT NULL DEFAULT 0,
        [IsLocked] [bit] NOT NULL DEFAULT 0,
        [LockoutEndDate] [datetime] NULL,
        [ProfilePicture] [nvarchar](255) NULL,
        [TwoFactorEnabled] [bit] NOT NULL DEFAULT 0,
        [TwoFactorSecret] [nvarchar](100) NULL,
        [EmailVerified] [bit] NOT NULL DEFAULT 0,
        [PhoneVerified] [bit] NOT NULL DEFAULT 0,
        CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]),
        CONSTRAINT [FK_Users_Branches] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([BranchID])
    );
    
    PRINT 'Users table created successfully.';
END
ELSE
BEGIN
    PRINT 'Users table exists. Checking for required columns...';
    
    -- Add missing columns if they don't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'UserID')
    BEGIN
        PRINT 'Adding UserID column...';
        ALTER TABLE [dbo].[Users] ADD [UserID] [int] IDENTITY(1,1) NOT NULL;
        ALTER TABLE [dbo].[Users] ADD CONSTRAINT [PK_Users] PRIMARY KEY ([UserID]);
    END
    
    -- Add other columns with appropriate data types and constraints
    -- Username
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'Username')
    BEGIN
        PRINT 'Adding Username column...';
        ALTER TABLE [dbo].[Users] ADD [Username] [nvarchar](50) NOT NULL;
        ALTER TABLE [dbo].[Users] ADD CONSTRAINT [UQ_Users_Username] UNIQUE ([Username]);
    END
    
    -- Email
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'Email')
    BEGIN
        PRINT 'Adding Email column...';
        ALTER TABLE [dbo].[Users] ADD [Email] [nvarchar](128) NOT NULL;
        ALTER TABLE [dbo].[Users] ADD CONSTRAINT [UQ_Users_Email] UNIQUE ([Email]);
    END
    
    -- Add other columns following the same pattern...
    -- [Previous columns...]
    
    -- RoleID (as foreign key to Roles table)
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'RoleID')
    BEGIN
        PRINT 'Adding RoleID column...';
        ALTER TABLE [dbo].[Users] ADD [RoleID] [int] NOT NULL;
        
        -- Add foreign key constraint if Roles table exists
        IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
        BEGIN
            ALTER TABLE [dbo].[Users] ADD CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]);
        END
    END
    
    -- Add other required columns...
    
    PRINT 'Schema update check completed.';
END

-- Check if we need to update any column data types
DECLARE @sql NVARCHAR(MAX);

-- Example: Update Email column length if it's too short
IF EXISTS (
    SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'Users' 
    AND COLUMN_NAME = 'Email' 
    AND CHARACTER_MAXIMUM_LENGTH < 128
)
BEGIN
    PRINT 'Updating Email column length to 128...';
    SET @sql = 'ALTER TABLE [dbo].[Users] ALTER COLUMN [Email] NVARCHAR(128) NOT NULL;';
    EXEC sp_executesql @sql;
END

-- Add similar checks for other columns as needed...

-- Verify foreign key constraints
IF NOT EXISTS (
    SELECT * FROM sys.foreign_keys 
    WHERE name = 'FK_Users_Roles' 
    AND parent_object_id = OBJECT_ID('Users')
)
BEGIN
    PRINT 'Adding foreign key constraint FK_Users_Roles...';
    ALTER TABLE [dbo].[Users] ADD CONSTRAINT [FK_Users_Roles] 
    FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]);
END

-- Add other foreign key constraints as needed...

PRINT 'Database schema update completed successfully.';
