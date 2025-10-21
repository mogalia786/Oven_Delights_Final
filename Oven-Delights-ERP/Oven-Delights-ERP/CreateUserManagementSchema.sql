-- Comprehensive User Management System Database Schema
-- For Oven Delights ERP - Azure SQL Server
-- Tables are created in dependency order to ensure foreign key constraints work properly

USE [OvenDelightsERP]
GO

-- Create Branches table first as it has no dependencies
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Branches' AND xtype='U')
CREATE TABLE [dbo].[Branches] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] [nvarchar](100) NOT NULL,
    [Address] [nvarchar](255) NULL,
    [Phone] [nvarchar](20) NULL,
    [Email] [nvarchar](128) NULL,
    [Manager] [nvarchar](100) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CostCenterCode] [nvarchar](20) NULL
)
GO

-- Create Roles table before Users since Users references it
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Roles' AND xtype='U')
CREATE TABLE [dbo].[Roles] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RoleName] [nvarchar](50) NOT NULL UNIQUE,
    [Description] [nvarchar](255) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
)
GO

-- Create Users table with proper foreign key to Roles
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
CREATE TABLE [dbo].[Users] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Username] [nvarchar](50) NOT NULL UNIQUE,
    [Password] [nvarchar](255) NOT NULL,
    [Email] [nvarchar](128) NOT NULL UNIQUE,
    [FirstName] [nvarchar](50) NOT NULL,
    [LastName] [nvarchar](50) NOT NULL,
    [RoleID] [int] NOT NULL,
    [BranchID] [int] NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [LastLogin] [datetime] NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [PasswordHash] [nvarchar](255) NULL,
    [Salt] [nvarchar](100) NULL,
    [FailedLoginAttempts] [int] NOT NULL DEFAULT 0,
    [LastFailedLogin] [datetime] NULL,
    [PasswordLastChanged] [datetime] NULL,
    [TwoFactorEnabled] [bit] NOT NULL DEFAULT 0,
    [TwoFactorSecret] [nvarchar](100) NULL,
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([ID]),
    CONSTRAINT [FK_Users_Branches] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([ID])
)
GO

-- UserSessions Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserSessions' AND xtype='U')
CREATE TABLE [dbo].[UserSessions] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [SessionToken] [nvarchar](255) NOT NULL UNIQUE,
    [LoginTime] [datetime] NOT NULL DEFAULT GETDATE(),
    [LogoutTime] [datetime] NULL,
    [IPAddress] [nvarchar](45) NULL,
    [UserAgent] [nvarchar](500) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    FOREIGN KEY ([UserID]) REFERENCES [Users]([ID])
)
GO

-- AuditLog Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='AuditLog' AND xtype='U')
CREATE TABLE [dbo].[AuditLog] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NULL,
    [Action] [nvarchar](100) NOT NULL,
    [TableName] [nvarchar](50) NULL,
    [RecordID] [int] NULL,
    [OldValues] [nvarchar](max) NULL,
    [NewValues] [nvarchar](max) NULL,
    [Timestamp] [datetime] NOT NULL DEFAULT GETDATE(),
    [IPAddress] [nvarchar](45) NULL,
    [Details] [nvarchar](500) NULL,
    FOREIGN KEY ([UserID]) REFERENCES [Users]([ID])
)
GO

-- Ensure Roles table exists first
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Roles' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Roles] (
        [RoleID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RoleName] [nvarchar](50) NOT NULL UNIQUE,
        [Description] [nvarchar](255) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
    );
    PRINT 'Roles table created successfully.';
END

-- Drop Permissions table if it exists with the wrong structure
IF EXISTS (SELECT * FROM sysobjects WHERE name='Permissions' AND xtype='U')
BEGIN
    -- Check if the table has the correct structure
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Permissions') AND name = 'PermissionID')
    BEGIN
        -- Drop any foreign key constraints first
        DECLARE @sql NVARCHAR(MAX) = '';
        SELECT @sql = @sql + 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name + ';'
        FROM sys.foreign_keys 
        WHERE referenced_object_id = OBJECT_ID('Permissions');
        
        IF LEN(@sql) > 0
            EXEC sp_executesql @sql;
            
        -- Now drop the table
        DROP TABLE [dbo].[Permissions];
        PRINT 'Dropped existing Permissions table for recreation.';
    END
END

-- Create Permissions Table with correct structure
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Permissions' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Permissions] (
        [PermissionID] [int] IDENTITY(1,1) NOT NULL,
        [PermissionName] [nvarchar](100) NOT NULL,
        [Module] [nvarchar](50) NOT NULL,
        [Description] [nvarchar](255) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        CONSTRAINT [PK_Permissions] PRIMARY KEY CLUSTERED ([PermissionID] ASC),
        CONSTRAINT [UQ_PermissionName] UNIQUE NONCLUSTERED ([PermissionName] ASC)
    );
    PRINT 'Permissions table created successfully with correct structure.';
END

-- Drop RolePermissions table if it exists with the wrong structure
IF EXISTS (SELECT * FROM sysobjects WHERE name='RolePermissions' AND xtype='U')
BEGIN
    -- Drop foreign key constraints first
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RolePermissions_Roles')
        ALTER TABLE [dbo].[RolePermissions] DROP CONSTRAINT [FK_RolePermissions_Roles];
    
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_RolePermissions_Permissions')
        ALTER TABLE [dbo].[RolePermissions] DROP CONSTRAINT [FK_RolePermissions_Permissions];
    
    -- Drop indexes
    IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_RolePermissions_RoleID')
        DROP INDEX [IX_RolePermissions_RoleID] ON [dbo].[RolePermissions];
        
    IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_RolePermissions_PermissionID')
        DROP INDEX [IX_RolePermissions_PermissionID] ON [dbo].[RolePermissions];
    
    -- Now drop the table
    DROP TABLE [dbo].[RolePermissions];
    PRINT 'Dropped existing RolePermissions table for recreation.';
END
GO

-- Create RolePermissions Table with explicit constraint names
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='RolePermissions' AND xtype='U')
BEGIN
    -- Create the RolePermissions table
    CREATE TABLE [dbo].[RolePermissions] (
        [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RoleID] [int] NOT NULL,
        [PermissionID] [int] NOT NULL,
        [CanCreate] [bit] NOT NULL DEFAULT 0,
        [CanRead] [bit] NOT NULL DEFAULT 0,
        [CanUpdate] [bit] NOT NULL DEFAULT 0,
        [CanDelete] [bit] NOT NULL DEFAULT 0
    )
    
    -- Add foreign key constraints after table creation
    ALTER TABLE [dbo].[RolePermissions] WITH CHECK 
        ADD CONSTRAINT [FK_RolePermissions_Roles] 
        FOREIGN KEY([RoleID]) REFERENCES [dbo].[Roles] ([RoleID]) ON DELETE CASCADE;
        
    ALTER TABLE [dbo].[RolePermissions] WITH CHECK 
        ADD CONSTRAINT [FK_RolePermissions_Permissions] 
        FOREIGN KEY([PermissionID]) REFERENCES [dbo].[Permissions] ([PermissionID]) ON DELETE CASCADE;
    
    -- Create index on foreign key columns for better performance
    CREATE INDEX [IX_RolePermissions_RoleID] ON [RolePermissions] ([RoleID]);
    CREATE INDEX [IX_RolePermissions_PermissionID] ON [RolePermissions] ([PermissionID]);
    
    PRINT 'RolePermissions table created successfully with proper constraints.';
END
ELSE
BEGIN
    PRINT 'RolePermissions table already exists with the correct structure.';
END
GO

-- UserPreferences Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserPreferences' AND xtype='U')
CREATE TABLE [dbo].[UserPreferences] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [PreferenceName] [nvarchar](50) NOT NULL,
    [PreferenceValue] [nvarchar](255) NULL,
    [LastUpdated] [datetime] NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY ([UserID]) REFERENCES [Users]([ID])
)
GO

-- PasswordHistory Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='PasswordHistory' AND xtype='U')
CREATE TABLE [dbo].[PasswordHistory] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [PasswordHash] [nvarchar](255) NOT NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY ([UserID]) REFERENCES [Users]([ID])
)
GO

-- Notifications Table
-- Drop Notifications table if it exists with the wrong structure
IF EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U' AND NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Notifications') AND name = 'NotificationID'))
BEGIN
    -- Drop any foreign key constraints first
    DECLARE @sql1 NVARCHAR(MAX) = '';
    SELECT @sql1 = @sql1 + 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name + ';'
    FROM sys.foreign_keys 
    WHERE referenced_object_id = OBJECT_ID('Notifications');
    
    IF LEN(@sql1) > 0
        EXEC sp_executesql @sql1;
    
    DROP TABLE [dbo].[Notifications];
    PRINT 'Dropped Notifications table with incorrect structure.';
END

-- Create Notifications table with correct structure
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[Notifications] (
        [NotificationID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [Title] [nvarchar](100) NOT NULL,
        [Message] [nvarchar](500) NOT NULL,
        [NotificationType] [nvarchar](50) NOT NULL,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [IsActive] [bit] NOT NULL DEFAULT 1
    );
    PRINT 'Created Notifications table with correct structure.';
END
GO

-- Drop UserNotifications table if it exists with the wrong structure
IF EXISTS (SELECT * FROM sysobjects WHERE name='UserNotifications' AND xtype='U')
BEGIN
    -- Check if the table has the wrong structure
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('UserNotifications') AND name = 'UserNotificationID')
    BEGIN
        -- Drop any foreign key constraints first
        DECLARE @sql2 NVARCHAR(MAX) = '';
        SELECT @sql2 = @sql2 + 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + ' DROP CONSTRAINT ' + name + ';'
        FROM sys.foreign_keys 
        WHERE parent_object_id = OBJECT_ID('UserNotifications');
        
        IF LEN(@sql2) > 0
            EXEC sp_executesql @sql2;
        
        DROP TABLE [dbo].[UserNotifications];
        PRINT 'Dropped UserNotifications table with incorrect structure.';
    END
END

-- Create UserNotifications table with correct structure
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserNotifications' AND xtype='U')
BEGIN
    CREATE TABLE [dbo].[UserNotifications] (
        [UserNotificationID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [UserID] [int] NOT NULL,
        [NotificationID] [int] NOT NULL,
        [IsRead] [bit] NOT NULL DEFAULT 0,
        [ReadDate] [datetime] NULL,
        CONSTRAINT [FK_UserNotifications_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE,
        CONSTRAINT [FK_UserNotifications_Notifications] FOREIGN KEY ([NotificationID]) REFERENCES [Notifications]([NotificationID]) ON DELETE CASCADE
    );
    
    -- Create indexes for better performance
    CREATE INDEX [IX_UserNotifications_UserID] ON [UserNotifications]([UserID]);
    CREATE INDEX [IX_UserNotifications_NotificationID] ON [UserNotifications]([NotificationID]);
    
    PRINT 'Created UserNotifications table with correct structure and constraints.';
END
GO

-- First, check if Roles table exists and has the correct structure
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Roles' AND xtype='U')
BEGIN
    -- Create the table if it doesn't exist
    CREATE TABLE [dbo].[Roles] (
        [RoleID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [RoleName] [nvarchar](50) NOT NULL UNIQUE,
        [Description] [nvarchar](255) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
    );
    
    PRINT 'Roles table created successfully.';
END
ELSE
BEGIN
    -- Check if the table has the correct structure
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Roles') AND name = 'RoleID')
    BEGIN
        -- If the table exists but has the wrong structure, drop and recreate it
        PRINT 'Dropping existing Roles table with incorrect structure...';
        DROP TABLE [dbo].[Roles];
        
        CREATE TABLE [dbo].[Roles] (
            [RoleID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
            [RoleName] [nvarchar](50) NOT NULL UNIQUE,
            [Description] [nvarchar](255) NULL,
            [IsActive] [bit] NOT NULL DEFAULT 1,
            [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
        );
        
        PRINT 'Recreated Roles table with correct structure.';
    END
END

-- Now insert default roles if they don't exist
IF NOT EXISTS (SELECT 1 FROM [Roles] WHERE [RoleName] = 'SuperAdmin')
BEGIN
    SET IDENTITY_INSERT [dbo].[Roles] ON;
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName], [Description], [IsActive])
    VALUES (1, 'SuperAdmin', 'Super Administrator with full access', 1);
    SET IDENTITY_INSERT [dbo].[Roles] OFF;
    PRINT 'Added SuperAdmin role.';
END

IF NOT EXISTS (SELECT 1 FROM [Roles] WHERE [RoleName] = 'BranchAdmin')
BEGIN
    SET IDENTITY_INSERT [dbo].[Roles] ON;
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName], [Description], [IsActive])
    VALUES (2, 'BranchAdmin', 'Branch Administrator with branch-level access', 1);
    SET IDENTITY_INSERT [dbo].[Roles] OFF;
    PRINT 'Added BranchAdmin role.';
END

IF NOT EXISTS (SELECT 1 FROM [Roles] WHERE [RoleName] = 'User')
BEGIN
    SET IDENTITY_INSERT [dbo].[Roles] ON;
    INSERT INTO [dbo].[Roles] ([RoleID], [RoleName], [Description], [IsActive])
    VALUES (3, 'User', 'Standard user with limited access', 1);
    SET IDENTITY_INSERT [dbo].[Roles] OFF;
    PRINT 'Added User role.';
END

PRINT 'Verified all default roles exist in the Roles table.';

-- Insert default permissions for all modules if they don't exist
MERGE INTO [dbo].[Permissions] AS target
USING (VALUES 
    ('UserManagement', 'Administrator', 'Manage users and accounts'),
    ('BranchManagement', 'Administrator', 'Manage branches and locations'),
    ('AuditLog', 'Administrator', 'View audit logs and security reports'),
    ('SystemSettings', 'Administrator', 'Configure system settings'),
    ('Inventory', 'Stockroom', 'Manage inventory and stock'),
    ('StockTransfers', 'Stockroom', 'Handle stock transfers'),
    ('BOMManagement', 'Manufacturing', 'Manage Bills of Materials'),
    ('ProductionOrders', 'Manufacturing', 'Create and manage production orders'),
    ('POS', 'Retail', 'Point of Sale operations'),
    ('Sales', 'Retail', 'Sales management'),
    ('GeneralLedger', 'Accounting', 'General Ledger operations'),
    ('AccountsReceivable', 'Accounting', 'Accounts Receivable management'),
    ('AccountsPayable', 'Accounting', 'Accounts Payable management'),
    ('ProductCatalog', 'E-commerce', 'Manage product catalog'),
    ('Orders', 'E-commerce', 'Manage e-commerce orders'),
    ('FinancialReports', 'Reporting', 'Generate financial reports'),
    ('InventoryReports', 'Reporting', 'Generate inventory reports'),
    ('Themes', 'Branding', 'Manage themes and branding')
) AS source ([PermissionName], [Module], [Description])
ON (target.[PermissionName] = source.[PermissionName])
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([PermissionName], [Module], [Description], [IsActive])
    VALUES (source.[PermissionName], source.[Module], source.[Description], 1);

-- Assign all permissions to SuperAdmin role
INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [CanCreate], [CanRead], [CanUpdate], [CanDelete])
SELECT 
    r.[ID] AS RoleID,
    p.[ID] AS PermissionID,
    1 AS [CanCreate],
    1 AS [CanRead],
    1 AS [CanUpdate],
    1 AS [CanDelete]
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'SuperAdmin'
AND NOT EXISTS (
    SELECT 1 
    FROM [dbo].[RolePermissions] rp 
    WHERE rp.[RoleID] = r.[ID] 
    AND rp.[PermissionID] = p.[ID]
);

-- Assign basic permissions to BranchAdmin role
INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [CanCreate], [CanRead], [CanUpdate], [CanDelete])
SELECT 
    r.[ID] AS RoleID,
    p.[ID] AS PermissionID,
    CASE 
        WHEN p.[PermissionName] IN ('UserManagement', 'SystemSettings', 'BranchManagement') THEN 0
        WHEN p.[Module] = 'Administrator' THEN 0
        ELSE 1 
    END AS [CanCreate],
    1 AS [CanRead],
    CASE 
        WHEN p.[PermissionName] IN ('UserManagement', 'SystemSettings', 'BranchManagement') THEN 0
        WHEN p.[Module] = 'Administrator' THEN 0
        ELSE 1 
    END AS [CanUpdate],
    CASE 
        WHEN p.[PermissionName] IN ('UserManagement', 'SystemSettings', 'BranchManagement') THEN 0
        WHEN p.[Module] = 'Administrator' THEN 0
        ELSE 1 
    END AS [CanDelete]
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'BranchAdmin'
AND p.[PermissionName] NOT IN ('UserManagement', 'SystemSettings', 'BranchManagement')
AND NOT EXISTS (
    SELECT 1 
    FROM [dbo].[RolePermissions] rp 
    WHERE rp.[RoleID] = r.[ID] 
    AND rp.[PermissionID] = p.[ID]
);

-- Assign basic read-only permissions to User role
INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [CanCreate], [CanRead], [CanUpdate], [CanDelete])
SELECT 
    r.[ID] AS RoleID,
    p.[ID] AS PermissionID,
    0 AS [CanCreate],
    1 AS [CanRead],
    0 AS [CanUpdate],
    0 AS [CanDelete]
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'User'
AND p.[PermissionName] NOT IN ('UserManagement', 'SystemSettings', 'BranchManagement')
AND NOT EXISTS (
    SELECT 1 
    FROM [dbo].[RolePermissions] rp 
    WHERE rp.[RoleID] = r.[ID] 
    AND rp.[PermissionID] = p.[ID]
);

PRINT 'User Management System database schema created and seeded successfully!';
