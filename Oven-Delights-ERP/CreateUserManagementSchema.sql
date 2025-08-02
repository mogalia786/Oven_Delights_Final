-- Comprehensive User Management System Database Schema
-- For Oven Delights ERP - Azure SQL Server

USE [OvenDelightsERP]
GO

-- Users Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Users' AND xtype='U')
CREATE TABLE [dbo].[Users] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Username] [nvarchar](50) NOT NULL UNIQUE,
    [Password] [nvarchar](255) NOT NULL,
    [Email] [nvarchar](100) NOT NULL UNIQUE,
    [FirstName] [nvarchar](50) NOT NULL,
    [LastName] [nvarchar](50) NOT NULL,
    [Role] [nvarchar](50) NOT NULL DEFAULT 'User',
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
    [TwoFactorSecret] [nvarchar](100) NULL
)
GO

-- Branches Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Branches' AND xtype='U')
CREATE TABLE [dbo].[Branches] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Name] [nvarchar](100) NOT NULL,
    [Address] [nvarchar](255) NULL,
    [Phone] [nvarchar](20) NULL,
    [Email] [nvarchar](100) NULL,
    [Manager] [nvarchar](100) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [CostCenterCode] [nvarchar](20) NULL
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

-- Roles Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Roles' AND xtype='U')
CREATE TABLE [dbo].[Roles] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RoleName] [nvarchar](50) NOT NULL UNIQUE,
    [Description] [nvarchar](255) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
)
GO

-- Permissions Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Permissions' AND xtype='U')
CREATE TABLE [dbo].[Permissions] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [PermissionName] [nvarchar](100) NOT NULL UNIQUE,
    [Module] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [IsActive] [bit] NOT NULL DEFAULT 1
)
GO

-- RolePermissions Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='RolePermissions' AND xtype='U')
CREATE TABLE [dbo].[RolePermissions] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [RoleID] [int] NOT NULL,
    [PermissionID] [int] NOT NULL,
    [CanCreate] [bit] NOT NULL DEFAULT 0,
    [CanRead] [bit] NOT NULL DEFAULT 0,
    [CanUpdate] [bit] NOT NULL DEFAULT 0,
    [CanDelete] [bit] NOT NULL DEFAULT 0,
    FOREIGN KEY ([RoleID]) REFERENCES [Roles]([ID]),
    FOREIGN KEY ([PermissionID]) REFERENCES [Permissions]([ID])
)
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
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Notifications' AND xtype='U')
CREATE TABLE [dbo].[Notifications] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Title] [nvarchar](100) NOT NULL,
    [Message] [nvarchar](500) NOT NULL,
    [NotificationType] [nvarchar](50) NOT NULL,
    [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
    [IsActive] [bit] NOT NULL DEFAULT 1
)
GO

-- UserNotifications Table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='UserNotifications' AND xtype='U')
CREATE TABLE [dbo].[UserNotifications] (
    [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [UserID] [int] NOT NULL,
    [NotificationID] [int] NOT NULL,
    [IsRead] [bit] NOT NULL DEFAULT 0,
    [ReadDate] [datetime] NULL,
    FOREIGN KEY ([UserID]) REFERENCES [Users]([ID]),
    FOREIGN KEY ([NotificationID]) REFERENCES [Notifications]([ID])
)
GO

-- Insert default roles
IF NOT EXISTS (SELECT * FROM Roles WHERE RoleName = 'SuperAdmin')
INSERT INTO [Roles] ([RoleName], [Description]) VALUES ('SuperAdmin', 'Super Administrator with full access')

IF NOT EXISTS (SELECT * FROM Roles WHERE RoleName = 'BranchAdmin')
INSERT INTO [Roles] ([RoleName], [Description]) VALUES ('BranchAdmin', 'Branch Administrator with branch-level access')

IF NOT EXISTS (SELECT * FROM Roles WHERE RoleName = 'User')
INSERT INTO [Roles] ([RoleName], [Description]) VALUES ('User', 'Standard user with limited access')

-- Insert default permissions for all modules
INSERT INTO [Permissions] ([PermissionName], [Module], [Description]) VALUES 
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

PRINT 'User Management System database schema created successfully!'
