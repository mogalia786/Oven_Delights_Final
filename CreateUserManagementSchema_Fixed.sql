-- Comprehensive User Management System Database Schema
-- For Oven Delights ERP - Azure SQL Server
-- Fixed version with consistent ID naming

USE [OvenDelightsERP]
GO

-- Create Branches table first as it has no dependencies
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Branches' AND xtype='U')
CREATE TABLE [dbo].[Branches] (
    [BranchID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] [nvarchar](100) NOT NULL,
    [Address] [nvarchar](255) NULL,
    [Phone] [nvarchar](20) NULL,
    [Email] [nvarchar](128) NULL,
    [Manager] [nvarchar](100) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CostCenterCode] [nvarchar](20) NULL,
    [Prefix] [nvarchar](10) NULL
)
GO

-- Drop existing tables in the correct order to avoid FK constraint issues
IF EXISTS (SELECT * FROM sysobjects WHERE name='UserSessions' AND xtype='U')
    DROP TABLE [dbo].[UserSessions];

IF EXISTS (SELECT * FROM sysobjects WHERE name='AuditLog' AND xtype='U')
    DROP TABLE [dbo].[AuditLog];

IF EXISTS (SELECT * FROM sysobjects WHERE name='UserPreferences' AND xtype='U')
    DROP TABLE [dbo].[UserPreferences];

IF EXISTS (SELECT * FROM sysobjects WHERE name='PasswordHistory' AND xtype='U')
    DROP TABLE [dbo].[PasswordHistory];

IF EXISTS (SELECT * FROM sysobjects WHERE name='UserNotifications' AND xtype='U')
    DROP TABLE [dbo].[UserNotifications];

IF EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
    DROP TABLE [dbo].[Notifications];

IF EXISTS (SELECT * FROM sysobjects WHERE name='RolePermissions' AND xtype='U')
    DROP TABLE [dbo].[RolePermissions];

IF EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
    DROP TABLE [dbo].[Users];

IF EXISTS (SELECT * FROM sysobjects WHERE name='Permissions' AND xtype='U')
    DROP TABLE [dbo].[Permissions];

IF EXISTS (SELECT * FROM sysobjects WHERE name='Roles' AND xtype='U')
    DROP TABLE [dbo].[Roles];

-- Create Roles table with consistent ID naming
CREATE TABLE [dbo].[Roles] (
    [RoleID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RoleName] [nvarchar](50) NOT NULL UNIQUE,
    [Description] [nvarchar](255) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
);
GO

-- Create Users table with consistent ID naming
CREATE TABLE [dbo].[Users] (
    [UserID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
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
    CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]),
    CONSTRAINT [FK_Users_Branches] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([BranchID])
);
GO

-- Create Permissions table with consistent ID naming
CREATE TABLE [dbo].[Permissions] (
    [PermissionID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PermissionName] [nvarchar](100) NOT NULL UNIQUE,
    [Module] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1
);
GO

-- Create RolePermissions table with consistent ID naming
CREATE TABLE [dbo].[RolePermissions] (
    [RolePermissionID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RoleID] [int] NOT NULL,
    [PermissionID] [int] NOT NULL,
    [CanCreate] [bit] NOT NULL DEFAULT 0,
    [CanRead] [bit] NOT NULL DEFAULT 0,
    [CanUpdate] [bit] NOT NULL DEFAULT 0,
    [CanDelete] [bit] NOT NULL DEFAULT 0,
    CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]) ON DELETE CASCADE,
    CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [Permissions]([PermissionID]) ON DELETE CASCADE
);
GO

-- Create indexes for better performance
CREATE INDEX [IX_RolePermissions_RoleID] ON [RolePermissions]([RoleID]);
CREATE INDEX [IX_RolePermissions_PermissionID] ON [RolePermissions]([PermissionID]);

-- Create other tables with consistent ID naming
CREATE TABLE [dbo].[UserSessions] (
    [SessionID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [SessionToken] [nvarchar](255) NOT NULL UNIQUE,
    [LoginTime] [datetime] NOT NULL DEFAULT GETDATE(),
    [LogoutTime] [datetime] NULL,
    [IPAddress] [nvarchar](45) NULL,
    [UserAgent] [nvarchar](500) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    CONSTRAINT [FK_UserSessions_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[AuditLog] (
    [AuditLogID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NULL,
    [Action] [nvarchar](100) NOT NULL,
    [TableName] [nvarchar](50) NULL,
    [RecordID] [int] NULL,
    [OldValues] [nvarchar](max) NULL,
    [NewValues] [nvarchar](max) NULL,
    [Timestamp] [datetime] NOT NULL DEFAULT GETDATE(),
    [IPAddress] [nvarchar](45) NULL,
    [Details] [nvarchar](500) NULL,
    CONSTRAINT [FK_AuditLog_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE SET NULL
);

CREATE TABLE [dbo].[UserPreferences] (
    [UserPreferenceID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [PreferenceName] [nvarchar](50) NOT NULL,
    [PreferenceValue] [nvarchar](255) NULL,
    [LastUpdated] [datetime] NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_UserPreferences_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[PasswordHistory] (
    [PasswordHistoryID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [PasswordHash] [nvarchar](255) NOT NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_PasswordHistory_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE
);

CREATE TABLE [dbo].[Notifications] (
    [NotificationID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Title] [nvarchar](100) NOT NULL,
    [Message] [nvarchar](500) NOT NULL,
    [NotificationType] [nvarchar](50) NOT NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [IsActive] [bit] NOT NULL DEFAULT 1
);

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
CREATE INDEX [IX_UserSessions_UserID] ON [UserSessions]([UserID]);
CREATE INDEX [IX_UserPreferences_UserID] ON [UserPreferences]([UserID]);
CREATE INDEX [IX_PasswordHistory_UserID] ON [PasswordHistory]([UserID]);
CREATE INDEX [IX_UserNotifications_UserID] ON [UserNotifications]([UserID]);
CREATE INDEX [IX_UserNotifications_NotificationID] ON [UserNotifications]([NotificationID]);

-- Insert default roles
SET IDENTITY_INSERT [dbo].[Roles] ON;
INSERT INTO [dbo].[Roles] ([RoleID], [RoleName], [Description], [IsActive]) VALUES 
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
    r.[RoleID],
    p.[PermissionID],
    1, 1, 1, 1
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'SuperAdmin';

-- Assign basic permissions to BranchAdmin role
INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [CanCreate], [CanRead], [CanUpdate], [CanDelete])
SELECT 
    r.[RoleID],
    p.[PermissionID],
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
    r.[RoleID],
    p.[PermissionID],
    0, 1, 0, 0
FROM [dbo].[Roles] r
CROSS JOIN [dbo].[Permissions] p
WHERE r.[RoleName] = 'User'
AND p.[PermissionName] NOT IN ('UserManagement', 'SystemSettings', 'BranchManagement');

-- Create default admin user (password: admin123)
INSERT INTO [dbo].[Users] (
    [Username], 
    [Password], 
    [Email], 
    [FirstName], 
    [LastName], 
    [RoleID], 
    [IsActive],
    [PasswordHash],
    [Salt]
)
SELECT 
    'admin',
    'admin123', -- This should be hashed in a real application
    'admin@ovendelights.com',
    'System',
    'Administrator',
    [RoleID],
    1,
    'hashed_password_here', -- Replace with actual hashed password
    'salt_here' -- Replace with actual salt
FROM [dbo].[Roles] 
WHERE [RoleName] = 'SuperAdmin';

PRINT 'User Management System database schema created and seeded successfully!';
GO
