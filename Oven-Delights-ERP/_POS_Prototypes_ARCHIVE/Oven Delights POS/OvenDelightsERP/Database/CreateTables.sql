-- ===================================================================
-- OVEN DELIGHTS ERP - USER MANAGEMENT SYSTEM DATABASE SCHEMA
-- Administrator Module - Task 1: User Management System
-- Created: 2025-01-29
-- ===================================================================

USE [OvenDelightsERP]
GO

-- ===================================================================
-- 1. BRANCHES TABLE - Multi-branch support with hierarchy
-- ===================================================================
CREATE TABLE [dbo].[Branches] (
    [ID] INT IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR(100) NOT NULL,
    [Address] NVARCHAR(500) NULL,
    [Phone] NVARCHAR(20) NULL,
    [Email] NVARCHAR(100) NULL,
    [Manager] NVARCHAR(100) NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [ModifiedDate] DATETIME2 NULL,
    [ParentBranchID] INT NULL,
    [BranchCode] NVARCHAR(10) NOT NULL UNIQUE,
    [TaxNumber] NVARCHAR(20) NULL,
    [RegistrationNumber] NVARCHAR(20) NULL,
    
    CONSTRAINT [FK_Branches_ParentBranch] FOREIGN KEY ([ParentBranchID]) 
        REFERENCES [dbo].[Branches]([ID])
)
GO

-- Create indexes for performance
CREATE INDEX [IX_Branches_IsActive] ON [dbo].[Branches] ([IsActive])
CREATE INDEX [IX_Branches_ParentBranchID] ON [dbo].[Branches] ([ParentBranchID])
GO

-- ===================================================================
-- 2. USERS TABLE - Complete user management with security
-- ===================================================================
CREATE TABLE [dbo].[Users] (
    [ID] INT IDENTITY(1,1) PRIMARY KEY,
    [Username] NVARCHAR(50) NOT NULL UNIQUE,
    [Password] NVARCHAR(255) NOT NULL, -- Will store BCrypt hash
    [Email] NVARCHAR(100) NOT NULL UNIQUE,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [Role] NVARCHAR(20) NOT NULL CHECK ([Role] IN ('SuperAdmin', 'BranchAdmin', 'Manager', 'Employee')),
    [BranchID] INT NOT NULL,
    [CreatedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [LastLogin] DATETIME2 NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [PasswordHash] NVARCHAR(255) NOT NULL, -- BCrypt hash
    [Salt] NVARCHAR(255) NOT NULL, -- Security salt
    [PasswordExpiry] DATETIME2 NULL,
    [FailedLoginAttempts] INT NOT NULL DEFAULT 0,
    [LastFailedLogin] DATETIME2 NULL,
    [IsLocked] BIT NOT NULL DEFAULT 0,
    [LockoutEnd] DATETIME2 NULL,
    [TwoFactorEnabled] BIT NOT NULL DEFAULT 0,
    [TwoFactorSecret] NVARCHAR(255) NULL,
    [ProfilePicture] NVARCHAR(500) NULL,
    [PhoneNumber] NVARCHAR(20) NULL,
    [Department] NVARCHAR(50) NULL,
    [JobTitle] NVARCHAR(50) NULL,
    [ModifiedDate] DATETIME2 NULL,
    [ModifiedBy] INT NULL,
    
    CONSTRAINT [FK_Users_Branch] FOREIGN KEY ([BranchID]) 
        REFERENCES [dbo].[Branches]([ID]),
    CONSTRAINT [FK_Users_ModifiedBy] FOREIGN KEY ([ModifiedBy]) 
        REFERENCES [dbo].[Users]([ID])
)
GO

-- Create indexes for performance and security
CREATE INDEX [IX_Users_Username] ON [dbo].[Users] ([Username])
CREATE INDEX [IX_Users_Email] ON [dbo].[Users] ([Email])
CREATE INDEX [IX_Users_BranchID] ON [dbo].[Users] ([BranchID])
CREATE INDEX [IX_Users_Role] ON [dbo].[Users] ([Role])
CREATE INDEX [IX_Users_IsActive] ON [dbo].[Users] ([IsActive])
CREATE INDEX [IX_Users_LastLogin] ON [dbo].[Users] ([LastLogin])
GO

-- ===================================================================
-- 3. USER SESSIONS TABLE - Session management and tracking
-- ===================================================================
CREATE TABLE [dbo].[UserSessions] (
    [ID] INT IDENTITY(1,1) PRIMARY KEY,
    [UserID] INT NOT NULL,
    [SessionToken] NVARCHAR(255) NOT NULL UNIQUE,
    [LoginTime] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [LogoutTime] DATETIME2 NULL,
    [IPAddress] NVARCHAR(45) NOT NULL, -- IPv6 support
    [UserAgent] NVARCHAR(500) NULL,
    [IsActive] BIT NOT NULL DEFAULT 1,
    [ExpiryTime] DATETIME2 NOT NULL,
    [RefreshToken] NVARCHAR(255) NULL,
    [DeviceInfo] NVARCHAR(200) NULL,
    [Location] NVARCHAR(100) NULL,
    [LastActivity] DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT [FK_UserSessions_User] FOREIGN KEY ([UserID]) 
        REFERENCES [dbo].[Users]([ID]) ON DELETE CASCADE
)
GO

-- Create indexes for session management
CREATE INDEX [IX_UserSessions_UserID] ON [dbo].[UserSessions] ([UserID])
CREATE INDEX [IX_UserSessions_SessionToken] ON [dbo].[UserSessions] ([SessionToken])
CREATE INDEX [IX_UserSessions_IsActive] ON [dbo].[UserSessions] ([IsActive])
CREATE INDEX [IX_UserSessions_ExpiryTime] ON [dbo].[UserSessions] ([ExpiryTime])
GO

-- ===================================================================
-- 4. AUDIT LOG TABLE - Complete audit trail
-- ===================================================================
CREATE TABLE [dbo].[AuditLog] (
    [ID] BIGINT IDENTITY(1,1) PRIMARY KEY,
    [UserID] INT NULL,
    [Action] NVARCHAR(50) NOT NULL,
    [TableName] NVARCHAR(50) NOT NULL,
    [RecordID] NVARCHAR(50) NULL,
    [OldValues] NVARCHAR(MAX) NULL, -- JSON format
    [NewValues] NVARCHAR(MAX) NULL, -- JSON format
    [Timestamp] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [IPAddress] NVARCHAR(45) NULL,
    [UserAgent] NVARCHAR(500) NULL,
    [SessionID] INT NULL,
    [ActionType] NVARCHAR(20) NOT NULL CHECK ([ActionType] IN ('CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'SECURITY')),
    [Severity] NVARCHAR(10) NOT NULL DEFAULT 'INFO' CHECK ([Severity] IN ('INFO', 'WARNING', 'ERROR', 'CRITICAL')),
    [Description] NVARCHAR(500) NULL,
    [ModuleName] NVARCHAR(50) NULL,
    
    CONSTRAINT [FK_AuditLog_User] FOREIGN KEY ([UserID]) 
        REFERENCES [dbo].[Users]([ID]),
    CONSTRAINT [FK_AuditLog_Session] FOREIGN KEY ([SessionID]) 
        REFERENCES [dbo].[UserSessions]([ID])
)
GO

-- Create indexes for audit log performance
CREATE INDEX [IX_AuditLog_UserID] ON [dbo].[AuditLog] ([UserID])
CREATE INDEX [IX_AuditLog_Timestamp] ON [dbo].[AuditLog] ([Timestamp])
CREATE INDEX [IX_AuditLog_Action] ON [dbo].[AuditLog] ([Action])
CREATE INDEX [IX_AuditLog_TableName] ON [dbo].[AuditLog] ([TableName])
CREATE INDEX [IX_AuditLog_ActionType] ON [dbo].[AuditLog] ([ActionType])
CREATE INDEX [IX_AuditLog_Severity] ON [dbo].[AuditLog] ([Severity])
GO

-- ===================================================================
-- 5. USER PERMISSIONS TABLE - Granular permission system
-- ===================================================================
CREATE TABLE [dbo].[UserPermissions] (
    [ID] INT IDENTITY(1,1) PRIMARY KEY,
    [UserID] INT NOT NULL,
    [ModuleName] NVARCHAR(50) NOT NULL,
    [PermissionType] NVARCHAR(20) NOT NULL CHECK ([PermissionType] IN ('READ', 'write', 'delete', 'admin')),
    [IsGranted] BIT NOT NULL DEFAULT 1,
    [GrantedBy] INT NOT NULL,
    [GrantedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    [ExpiryDate] DATETIME2 NULL,
    
    CONSTRAINT [FK_UserPermissions_User] FOREIGN KEY ([UserID]) 
        REFERENCES [dbo].[Users]([ID]) ON DELETE CASCADE,
    CONSTRAINT [FK_UserPermissions_GrantedBy] FOREIGN KEY ([GrantedBy]) 
        REFERENCES [dbo].[Users]([ID]),
    CONSTRAINT [UQ_UserPermissions] UNIQUE ([UserID], [ModuleName], [PermissionType])
)
GO

-- ===================================================================
-- 6. SYSTEM SETTINGS TABLE - Configuration management
-- ===================================================================
CREATE TABLE [dbo].[SystemSettings] (
    [ID] INT IDENTITY(1,1) PRIMARY KEY,
    [SettingKey] NVARCHAR(100) NOT NULL UNIQUE,
    [SettingValue] NVARCHAR(MAX) NULL,
    [SettingType] NVARCHAR(20) NOT NULL DEFAULT 'string',
    [Category] NVARCHAR(50) NOT NULL,
    [Description] NVARCHAR(500) NULL,
    [IsEncrypted] BIT NOT NULL DEFAULT 0,
    [ModifiedBy] INT NULL,
    [ModifiedDate] DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT [FK_SystemSettings_ModifiedBy] FOREIGN KEY ([ModifiedBy]) 
        REFERENCES [dbo].[Users]([ID])
)
GO

-- ===================================================================
-- 7. INSERT DEFAULT DATA
-- ===================================================================

-- Insert default branch
INSERT INTO [dbo].[Branches] ([Name], [Address], [Phone], [Email], [Manager], [BranchCode])
VALUES ('Head Office', '123 Main Street, Johannesburg', '+27 11 123 4567', 'info@ovendelights.co.za', 'System Administrator', 'HO001')
GO

-- Insert default super admin user (password will be hashed in application)
INSERT INTO [dbo].[Users] ([Username], [Password], [Email], [FirstName], [LastName], [Role], [BranchID], [PasswordHash], [Salt])
VALUES ('R@j3np1ll@y', 'TEMP_HASH', 'admin@ovendelights.co.za', 'System', 'Administrator', 'SuperAdmin', 1, 'TEMP_HASH', 'TEMP_SALT')
GO

-- Insert default system settings
INSERT INTO [dbo].[SystemSettings] ([SettingKey], [SettingValue], [SettingType], [Category], [Description])
VALUES 
    ('PasswordMinLength', '8', 'int', 'Security', 'Minimum password length requirement'),
    ('PasswordRequireSpecialChar', 'true', 'bool', 'Security', 'Require special characters in passwords'),
    ('SessionTimeoutMinutes', '30', 'int', 'Security', 'Session timeout in minutes'),
    ('MaxFailedLoginAttempts', '5', 'int', 'Security', 'Maximum failed login attempts before lockout'),
    ('LockoutDurationMinutes', '15', 'int', 'Security', 'Account lockout duration in minutes'),
    ('CompanyName', 'Oven Delights', 'string', 'General', 'Company name'),
    ('CompanyEmail', 'info@ovendelights.co.za', 'string', 'General', 'Company email address'),
    ('CompanyPhone', '+27 11 123 4567', 'string', 'General', 'Company phone number')
GO

-- ===================================================================
-- 8. CREATE VIEWS FOR REPORTING
-- ===================================================================

-- User activity summary view
CREATE VIEW [dbo].[vw_UserActivitySummary] AS
SELECT 
    u.ID,
    u.Username,
    u.FirstName + ' ' + u.LastName AS FullName,
    u.Email,
    u.Role,
    b.Name AS BranchName,
    u.LastLogin,
    u.IsActive,
    u.FailedLoginAttempts,
    u.IsLocked,
    CASE 
        WHEN u.LastLogin > DATEADD(day, -7, GETDATE()) THEN 'Active'
        WHEN u.LastLogin > DATEADD(day, -30, GETDATE()) THEN 'Inactive'
        ELSE 'Dormant'
    END AS ActivityStatus
FROM [dbo].[Users] u
INNER JOIN [dbo].[Branches] b ON u.BranchID = b.ID
GO

-- Session summary view
CREATE VIEW [dbo].[vw_SessionSummary] AS
SELECT 
    s.ID,
    u.Username,
    u.FirstName + ' ' + u.LastName AS FullName,
    s.LoginTime,
    s.LogoutTime,
    s.IPAddress,
    s.IsActive,
    DATEDIFF(minute, s.LoginTime, ISNULL(s.LogoutTime, GETDATE())) AS SessionDurationMinutes
FROM [dbo].[UserSessions] s
INNER JOIN [dbo].[Users] u ON s.UserID = u.ID
GO

PRINT 'Database schema created successfully!'
PRINT 'Default super admin user: R@j3np1ll@y (password will be set in application)'
PRINT 'Remember to update password hash using BCrypt in the application!'
