-- Comprehensive User Management System Database Schema
-- For Oven Delights ERP - Azure SQL Server
-- Version 4: Fixed column names to match actual database schema

USE [OvenDelightsERP]
GO

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

-- Drop tables in reverse order of dependency
IF OBJECT_ID('dbo.UserSessions', 'U') IS NOT NULL
    DROP TABLE [dbo].[UserSessions];

IF OBJECT_ID('dbo.UserNotifications', 'U') IS NOT NULL
    DROP TABLE [dbo].[UserNotifications];

IF OBJECT_ID('dbo.Notifications', 'U') IS NOT NULL
    DROP TABLE [dbo].[Notifications];

IF OBJECT_ID('dbo.AuditLog', 'U') IS NOT NULL
    DROP TABLE [dbo].[AuditLog];

IF OBJECT_ID('dbo.UserPreferences', 'U') IS NOT NULL
    DROP TABLE [dbo].[UserPreferences];

IF OBJECT_ID('dbo.PasswordHistory', 'U') IS NOT NULL
    DROP TABLE [dbo].[PasswordHistory];

IF OBJECT_ID('dbo.RolePermissions', 'U') IS NOT NULL
    DROP TABLE [dbo].[RolePermissions];

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL
    DROP TABLE [dbo].[Users];

IF OBJECT_ID('dbo.Permissions', 'U') IS NOT NULL
    DROP TABLE [dbo].[Permissions];

IF OBJECT_ID('dbo.Roles', 'U') IS NOT NULL
    DROP TABLE [dbo].[Roles];

IF OBJECT_ID('dbo.Branches', 'U') IS NOT NULL
    DROP TABLE [dbo].[Branches];

-- Now create tables in dependency order

-- Create Branches table first as it has no dependencies
CREATE TABLE [dbo].[Branches] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] [nvarchar](100) NOT NULL,
    [Address] [nvarchar](255) NULL,
    [Phone] [nvarchar](20) NULL,
    [Email] [nvarchar](128) NULL,
    [Manager] [nvarchar](100) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CostCenterCode] [nvarchar](20) NULL,
    [Prefix] [nvarchar](10) NULL
);

-- Create Roles table before Users since Users references it
CREATE TABLE [dbo].[Roles] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RoleName] [nvarchar](50) NOT NULL UNIQUE,
    [Description] [nvarchar](255) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
);

-- Create Users table with proper foreign key to Roles
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
);

-- Create Permissions table
CREATE TABLE [dbo].[Permissions] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PermissionName] [nvarchar](100) NOT NULL UNIQUE,
    [Module] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1
);

-- Create RolePermissions table
CREATE TABLE [dbo].[RolePermissions] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RoleID] [int] NOT NULL,
    [PermissionID] [int] NOT NULL,
    [CanCreate] [bit] NOT NULL DEFAULT 0,
    [CanRead] [bit] NOT NULL DEFAULT 0,
    [CanUpdate] [bit] NOT NULL DEFAULT 0,
    [CanDelete] [bit] NOT NULL DEFAULT 0,
    CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [Permissions]([ID]) ON DELETE CASCADE
);

-- Create other tables with proper foreign key relationships
CREATE TABLE [dbo].[UserSessions] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [SessionToken] [nvarchar](255) NOT NULL UNIQUE,
    [LoginTime] [datetime] NOT NULL DEFAULT GETDATE(),
    [LogoutTime] [datetime] NULL,
    [IPAddress] [nvarchar](45) NULL,
    [UserAgent] [nvarchar](500) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    CONSTRAINT [FK_UserSessions_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([ID]) ON DELETE CASCADE
);

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
    CONSTRAINT [FK_AuditLog_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([ID]) ON DELETE SET NULL
);

CREATE TABLE [dbo].[UserPreferences] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [PreferenceName] [nvarchar](50) NOT NULL,
    [PreferenceValue] [nvarchar](255) NULL,
    [LastUpdated] [datetime] NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_UserPreferences_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([ID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[PasswordHistory] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [PasswordHash] [nvarchar](255) NOT NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_PasswordHistory_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([ID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[Notifications] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Title] [nvarchar](100) NOT NULL,
    [Message] [nvarchar](500) NOT NULL,
    [NotificationType] [nvarchar](50) NOT NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [IsActive] [bit] NOT NULL DEFAULT 1
);

CREATE TABLE [dbo].[UserNotifications] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [NotificationID] [int] NOT NULL,
    [IsRead] [bit] NOT NULL DEFAULT 0,
    [ReadDate] [datetime] NULL,
    CONSTRAINT [FK_UserNotifications_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserNotifications_Notifications] FOREIGN KEY ([NotificationID]) REFERENCES [Notifications]([ID]) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX [IX_UserSessions_UserID] ON [UserSessions]([UserID]);
CREATE INDEX [IX_UserPreferences_UserID] ON [UserPreferences]([UserID]);
CREATE INDEX [IX_PasswordHistory_UserID] ON [PasswordHistory]([UserID]);
CREATE INDEX [IX_UserNotifications_UserID] ON [UserNotifications]([UserID]);
CREATE INDEX [IX_UserNotifications_NotificationID] ON [UserNotifications]([NotificationID]);
CREATE INDEX [IX_RolePermissions_RoleID] ON [RolePermissions]([RoleID]);
CREATE INDEX [IX_RolePermissions_PermissionID] ON [RolePermissions]([PermissionID]);

-- Insert default roles
SET IDENTITY_INSERT [dbo].[Roles] ON;
INSERT INTO [dbo].[Roles] ([ID], [RoleName], [Description], [IsActive]) VALUES 
(1, 'SuperAdmin', 'Super Administrator with full access', 1),
(2, 'BranchAdmin', 'Branch Administrator with branch-level access', 1),
(3, 'User', 'Standard user with limited access', 1);
SET IDENTITY_INSERT [dbo].[Roles] OFF;

-- Insert default permissions
INSERT INTO [dbo].[Permissions] ([PermissionName], [Module], [Description], [IsActive])
VALUES 
    ('UserManagement', 'Administrator', 'Manage users and accounts', 1),
    ('BranchManagement', 'Administrator', 'Manage branches and locations', 1),
    ('AuditLog', 'Administrator', 'View audit logs and security reports', 1),
    ('SystemSettings', 'Administrator', 'Configure system settings', 1),
    ('Inventory', 'Stockroom', 'Manage inventory and stock', 1),
    ('StockTransfers', 'Stockroom', 'Handle stock transfers', 1),
    ('BOMManagement', 'Manufacturing', 'Manage Bills of Materials', 1),
    ('ProductionOrders', 'Manufacturing', 'Create and manage production orders', 1),
    ('POS', 'Retail', 'Point of Sale operations', 1),
    ('Sales', 'Retail', 'Sales management', 1),
    ('GeneralLedger', 'Accounting', 'General Ledger operations', 1),
    ('AccountsReceivable', 'Accounting', 'Accounts Receivable management', 1),
    ('AccountsPayable', 'Accounting', 'Accounts Payable management', 1),
    ('ProductCatalog', 'E-commerce', 'Manage product catalog', 1),
    ('Orders', 'E-commerce', 'Manage e-commerce orders', 1),
    ('FinancialReports', 'Reporting', 'Generate financial reports', 1),
    ('InventoryReports', 'Reporting', 'Generate inventory reports', 1),
    ('Themes', 'Branding', 'Manage themes and branding', 1);

-- Assign all permissions to SuperAdmin role
INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [CanCreate], [CanRead], [CanUpdate], [CanDelete])
SELECT 
    r.[ID],
    p.[ID],
    1, 1, 1, 1
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'SuperAdmin';

-- Assign basic permissions to BranchAdmin role
INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [CanCreate], [CanRead], [CanUpdate], [CanDelete])
SELECT 
    r.[ID],
    p.[ID],
    CASE 
        WHEN p.[PermissionName] IN ('UserManagement', 'SystemSettings', 'BranchManagement') THEN 0
        WHEN p.[Module] = 'Administrator' THEN 0
        ELSE 1 
    END,
    1,
    CASE 
        WHEN p.[PermissionName] IN ('UserManagement', 'SystemSettings', 'BranchManagement') THEN 0
        WHEN p.[Module] = 'Administrator' THEN 0
        ELSE 1 
    END,
    CASE 
        WHEN p.[PermissionName] IN ('UserManagement', 'SystemSettings', 'BranchManagement') THEN 0
        WHEN p.[Module] = 'Administrator' THEN 0
        ELSE 1 
    END
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'BranchAdmin'
AND p.[PermissionName] NOT IN ('UserManagement', 'SystemSettings', 'BranchManagement');

-- Assign basic read-only permissions to User role
INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [CanCreate], [CanRead], [CanUpdate], [CanDelete])
SELECT 
    r.[ID],
    p.[ID],
    0, 1, 0, 0
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'User'
AND p.[PermissionName] NOT IN ('UserManagement', 'SystemSettings', 'BranchManagement');

-- Create default branch if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM [dbo].[Branches] WHERE [Name] = 'Head Office')
BEGIN
    INSERT INTO [dbo].[Branches] (
        [Name],
        [Address],
        [Phone],
        [Email],
        [Manager],
        [IsActive],
        [Prefix]
    ) VALUES (
        'Head Office',
        '123 Main Street, City',
        '0123456789',
        'info@ovendelights.com',
        'System Administrator',
        1,
        'HO'
    );
END

-- Create default admin user (password: admin123)
IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE [Username] = 'admin')
BEGIN
    DECLARE @salt NVARCHAR(100) = NEWID();
    DECLARE @passwordHash NVARCHAR(255) = CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', 'admin123' + @salt), 2);
    DECLARE @branchId INT = (SELECT TOP 1 [ID] FROM [dbo].[Branches] WHERE [Name] = 'Head Office');
    
    IF @branchId IS NULL
    BEGIN
        -- If no branch exists, create one
        INSERT INTO [dbo].[Branches] ([Name], [IsActive], [Prefix])
        VALUES ('Head Office', 1, 'HO');
        
        SET @branchId = SCOPE_IDENTITY();
    END
    
    INSERT INTO [dbo].[Users] (
        [Username], 
        [Password], 
        [Email], 
        [FirstName], 
        [LastName], 
        [RoleID],
        [BranchID],
        [IsActive],
        [PasswordHash],
        [Salt],
        [PasswordLastChanged]
    )
    SELECT 
        'admin',
        'admin123', -- This is just a fallback, the hashed password is used for actual authentication
        'admin@ovendelights.com',
        'System',
        'Administrator',
        [ID],
        @branchId,
        1,
        @passwordHash,
        @salt,
        GETDATE()
    FROM [dbo].[Roles] 
    WHERE [RoleName] = 'SuperAdmin';
    
    -- Create a sample notification
    DECLARE @notificationId INT;
    
    INSERT INTO [dbo].[Notifications] (
        [Title],
        [Message],
        [NotificationType],
        [IsActive]
    ) VALUES (
        'Welcome to Oven Delights ERP',
        'The system has been successfully initialized. Please change your default password.',
        'System',
        1
    );
    
    SET @notificationId = SCOPE_IDENTITY();
    
    -- Assign notification to admin user
    INSERT INTO [dbo].[UserNotifications] (
        [UserID],
        [NotificationID],
        [IsRead]
    )
    SELECT 
        [ID],
        @notificationId,
        0
    FROM [dbo].[Users]
    WHERE [Username] = 'admin';
END

-- Re-enable all constraints
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

PRINT 'User Management System database schema created and seeded successfully!';
GO
