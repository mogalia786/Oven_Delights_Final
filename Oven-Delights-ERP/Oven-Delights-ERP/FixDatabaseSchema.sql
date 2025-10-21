-- Comprehensive Database Schema Fix Script for Oven Delights ERP
-- This script ensures the database schema matches the application requirements

-- First, disable all foreign key constraints
DECLARE @sql NVARCHAR(MAX) = '';

-- Generate SQL to disable all constraints
SELECT @sql = @sql + 
    'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + 
    QUOTENAME(OBJECT_NAME(parent_object_id)) + ' NOCHECK CONSTRAINT ' + 
    QUOTENAME(name) + ';'
FROM sys.foreign_keys
WHERE is_disabled = 0;

-- Execute the SQL to disable constraints
EXEC sp_executesql @sql;

-- 1. Ensure Branches table exists and has correct structure
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Branches')
BEGIN
    CREATE TABLE [dbo].[Branches] (
        [BranchID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Name] [nvarchar](100) NOT NULL,
        [Address] [nvarchar](255) NULL,
        [Phone] [nvarchar](20) NULL,
        [Email] [nvarchar](128) NULL,
        [Manager] [nvarchar](100) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [ModifiedDate] [datetime] NULL,
        [ModifiedBy] [int] NULL,
        [CostCenterCode] [nvarchar](20) NULL,
        [Prefix] [nvarchar](10) NULL
    );
    
    PRINT 'Created Branches table.';
END
ELSE
BEGIN
    -- Add missing columns to Branches table if needed
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Branches]') AND name = 'Prefix')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [Prefix] [nvarchar](10) NULL;
        PRINT 'Added Prefix column to Branches table.';
    END
    
    -- Add other missing columns as needed...
END

-- 2. Ensure Roles table exists and has correct structure
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Roles')
BEGIN
    CREATE TABLE [dbo].[Roles] (
        [RoleID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RoleName] [nvarchar](50) NOT NULL UNIQUE,
        [Description] [nvarchar](255) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [CreatedBy] [int] NULL,
        [ModifiedDate] [datetime] NULL,
        [ModifiedBy] [int] NULL
    );
    
    PRINT 'Created Roles table.';
END

-- 3. Ensure Users table has correct structure
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Users')
BEGIN
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
    
    PRINT 'Created Users table.';
END
ELSE
BEGIN
    -- Add missing columns to Users table if needed
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'TwoFactorEnabled')
    BEGIN
        ALTER TABLE [dbo].[Users] ADD [TwoFactorEnabled] [bit] NOT NULL DEFAULT 0;
        PRINT 'Added TwoFactorEnabled column to Users table.';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND name = 'TwoFactorSecret')
    BEGIN
        ALTER TABLE [dbo].[Users] ADD [TwoFactorSecret] [nvarchar](100) NULL;
        PRINT 'Added TwoFactorSecret column to Users table.';
    END
    
    -- Add other missing columns as needed...
    
    -- Ensure foreign key constraints exist
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Users_Roles')
    BEGIN
        ALTER TABLE [dbo].[Users] ADD CONSTRAINT [FK_Users_Roles] 
        FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]);
        PRINT 'Added FK_Users_Roles constraint.';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Users_Branches')
    BEGIN
        ALTER TABLE [dbo].[Users] ADD CONSTRAINT [FK_Users_Branches] 
        FOREIGN KEY ([BranchID]) REFERENCES [Branches]([BranchID]);
        PRINT 'Added FK_Users_Branches constraint.';
    END
END

-- 4. Ensure Permissions table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Permissions')
BEGIN
    CREATE TABLE [dbo].[Permissions] (
        [PermissionID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Name] [nvarchar](100) NOT NULL UNIQUE,
        [Description] [nvarchar](255) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [CreatedBy] [int] NULL,
        [ModifiedDate] [datetime] NULL,
        [ModifiedBy] [int] NULL
    );
    
    PRINT 'Created Permissions table.';
END

-- 5. Ensure RolePermissions table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RolePermissions')
BEGIN
    CREATE TABLE [dbo].[RolePermissions] (
        [RoleID] [int] NOT NULL,
        [PermissionID] [int] NOT NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [CreatedBy] [int] NULL,
        PRIMARY KEY ([RoleID], [PermissionID]),
        CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]),
        CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [Permissions]([PermissionID])
    );
    
    PRINT 'Created RolePermissions table.';
END

-- 6. Create other supporting tables as needed (AuditLog, UserSessions, etc.)

-- Re-enable all foreign key constraints
SET @sql = '';

-- Generate SQL to enable all constraints
SELECT @sql = @sql + 
    'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' + 
    QUOTENAME(OBJECT_NAME(parent_object_id)) + ' WITH CHECK CHECK CONSTRAINT ' + 
    QUOTENAME(name) + ';'
FROM sys.foreign_keys
WHERE is_disabled = 1;

-- Execute the SQL to enable constraints
EXEC sp_executesql @sql;

-- 7. Insert default data if needed
-- First, ensure the Roles table has the required columns
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Roles]') AND name = 'Description')
BEGIN
    ALTER TABLE [dbo].[Roles] ADD [Description] [nvarchar](255) NULL;
    PRINT 'Added Description column to Roles table.';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Roles]') AND name = 'IsActive')
BEGIN
    ALTER TABLE [dbo].[Roles] ADD [IsActive] [bit] NOT NULL DEFAULT 1;
    PRINT 'Added IsActive column to Roles table.';
END

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID(N'[dbo].[Roles]') AND name = 'CreatedBy')
BEGIN
    ALTER TABLE [dbo].[Roles] ADD [CreatedBy] [int] NULL;
    PRINT 'Added CreatedBy column to Roles table.';
END

-- Now insert the default data
IF NOT EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE [RoleName] = 'Administrator')
BEGIN
    INSERT INTO [dbo].[Roles] ([RoleName], [Description])
    VALUES ('Administrator', 'System Administrator with full access');
    
    PRINT 'Added Administrator role.';
END

-- Add other default data as needed...

PRINT 'Database schema update completed successfully.';
