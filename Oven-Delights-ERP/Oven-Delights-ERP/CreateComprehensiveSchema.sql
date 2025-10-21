-- COMPREHENSIVE USER MANAGEMENT SYSTEM DATABASE SCHEMA
-- Drop existing tables if they exist
IF OBJECT_ID('UserNotifications', 'U') IS NOT NULL DROP TABLE UserNotifications;
IF OBJECT_ID('Notifications', 'U') IS NOT NULL DROP TABLE Notifications;
IF OBJECT_ID('PasswordHistory', 'U') IS NOT NULL DROP TABLE PasswordHistory;
IF OBJECT_ID('UserPreferences', 'U') IS NOT NULL DROP TABLE UserPreferences;
IF OBJECT_ID('RolePermissions', 'U') IS NOT NULL DROP TABLE RolePermissions;
IF OBJECT_ID('Permissions', 'U') IS NOT NULL DROP TABLE Permissions;
IF OBJECT_ID('AuditLog', 'U') IS NOT NULL DROP TABLE AuditLog;
IF OBJECT_ID('UserSessions', 'U') IS NOT NULL DROP TABLE UserSessions;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
IF OBJECT_ID('Branches', 'U') IS NOT NULL DROP TABLE Branches;
IF OBJECT_ID('SystemSettings', 'U') IS NOT NULL DROP TABLE SystemSettings;
IF OBJECT_ID('AccountingJournals', 'U') IS NOT NULL DROP TABLE AccountingJournals;

-- Create Branches table
CREATE TABLE Branches (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName NVARCHAR(100) NOT NULL,
    BranchCode NVARCHAR(20) UNIQUE NOT NULL,
    Address NVARCHAR(255),
    City NVARCHAR(100),
    Province NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Manager NVARCHAR(100),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME,
    ModifiedBy INT,
    CostCenterCode NVARCHAR(20) -- For accounting integration
);

-- Create Roles table
CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME,
    ModifiedBy INT
);

-- Create Users table with comprehensive fields
CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Password NVARCHAR(255), -- For backward compatibility
    PasswordHash NVARCHAR(255) NOT NULL,
    Salt NVARCHAR(255),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Phone NVARCHAR(20),
    ProfilePicture NVARCHAR(255),
    RoleID INT NOT NULL,
    BranchID INT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    ModifiedDate DATETIME,
    ModifiedBy INT,
    LastLoginDate DATETIME,
    FailedLoginAttempts INT DEFAULT 0,
    IsLocked BIT DEFAULT 0,
    LockoutEndDate DATETIME,
    PasswordLastChanged DATETIME DEFAULT GETDATE(),
    TwoFactorEnabled BIT DEFAULT 0,
    TwoFactorSecret NVARCHAR(255),
    EmailVerified BIT DEFAULT 0,
    PhoneVerified BIT DEFAULT 0,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);

-- Create UserSessions table
CREATE TABLE UserSessions (
    SessionID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    SessionToken NVARCHAR(255) UNIQUE NOT NULL,
    LoginTime DATETIME DEFAULT GETDATE(),
    LogoutTime DATETIME,
    LastActivity DATETIME DEFAULT GETDATE(),
    IPAddress NVARCHAR(45),
    UserAgent NVARCHAR(500),
    IsActive BIT DEFAULT 1,
    DeviceInfo NVARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create AuditLog table
CREATE TABLE AuditLog (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT,
    Action NVARCHAR(50) NOT NULL,
    TableName NVARCHAR(50),
    RecordID INT,
    OldValues NVARCHAR(MAX),
    NewValues NVARCHAR(MAX),
    Timestamp DATETIME DEFAULT GETDATE(),
    IPAddress NVARCHAR(45),
    UserAgent NVARCHAR(500),
    DeviceInfo NVARCHAR(255),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create Permissions table
CREATE TABLE Permissions (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    PermissionName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    Module NVARCHAR(50),
    IsActive BIT DEFAULT 1
);

-- Create RolePermissions table
CREATE TABLE RolePermissions (
    RolePermissionID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    PermissionID INT NOT NULL,
    CanCreate BIT DEFAULT 0,
    CanRead BIT DEFAULT 0,
    CanUpdate BIT DEFAULT 0,
    CanDelete BIT DEFAULT 0,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (PermissionID) REFERENCES Permissions(PermissionID),
    UNIQUE(RoleID, PermissionID)
);

-- Create UserPreferences table
CREATE TABLE UserPreferences (
    PreferenceID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PreferenceName NVARCHAR(100) NOT NULL,
    PreferenceValue NVARCHAR(500),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    UNIQUE(UserID, PreferenceName)
);

-- Create PasswordHistory table
CREATE TABLE PasswordHistory (
    HistoryID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Create Notifications table
CREATE TABLE Notifications (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Message NVARCHAR(500) NOT NULL,
    NotificationType NVARCHAR(50) DEFAULT 'INFO',
    CreatedDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    IsActive BIT DEFAULT 1,
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Create UserNotifications table
CREATE TABLE UserNotifications (
    UserNotificationID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    NotificationID INT NOT NULL,
    IsRead BIT DEFAULT 0,
    ReadDate DATETIME,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (NotificationID) REFERENCES Notifications(NotificationID)
);

-- Create SystemSettings table
CREATE TABLE SystemSettings (
    SettingID INT IDENTITY(1,1) PRIMARY KEY,
    SettingName NVARCHAR(100) NOT NULL UNIQUE,
    SettingValue NVARCHAR(500),
    Description NVARCHAR(255),
    Category NVARCHAR(50),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    ModifiedBy INT,
    FOREIGN KEY (ModifiedBy) REFERENCES Users(UserID)
);

-- Create AccountingJournals table for accounting integration
CREATE TABLE AccountingJournals (
    JournalID INT IDENTITY(1,1) PRIMARY KEY,
    JournalType NVARCHAR(50) NOT NULL, -- UserCreation, Login, BranchSetup, etc.
    ReferenceID INT NOT NULL, -- UserID, BranchID, etc.
    ReferenceTable NVARCHAR(50) NOT NULL,
    DebitAccount NVARCHAR(20),
    CreditAccount NVARCHAR(20),
    Amount DECIMAL(18,2) DEFAULT 0,
    Description NVARCHAR(255),
    TransactionDate DATETIME DEFAULT GETDATE(),
    CreatedBy INT,
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Insert default roles
INSERT INTO Roles (RoleName, Description) VALUES 
('Super Administrator', 'Full system access'),
('Branch Administrator', 'Branch-level administration'),
('Manager', 'Department management access'),
('User', 'Standard user access'),
('Viewer', 'Read-only access');

-- Insert default branch
INSERT INTO Branches (BranchName, BranchCode, Address, City, Province, Manager, CostCenterCode) VALUES 
('Head Office', 'HO001', '123 Main Street', 'Johannesburg', 'Gauteng', 'System Administrator', 'CC001');

-- Insert default permissions
INSERT INTO Permissions (PermissionName, Description, Module) VALUES 
('USER_MANAGEMENT', 'Manage users and roles', 'Administrator'),
('BRANCH_MANAGEMENT', 'Manage branches', 'Administrator'),
('SYSTEM_SETTINGS', 'Configure system settings', 'Administrator'),
('AUDIT_LOGS', 'View audit logs', 'Administrator'),
('REPORTS', 'Generate and view reports', 'Reporting'),
('STOCKROOM', 'Access stockroom module', 'Stockroom'),
('MANUFACTURING', 'Access manufacturing module', 'Manufacturing'),
('RETAIL_POS', 'Access retail and POS module', 'Retail'),
('ACCOUNTING', 'Access accounting module', 'Accounting'),
('ECOMMERCE', 'Access e-commerce module', 'E-commerce'),
('BRANDING', 'Access branding module', 'Branding');

-- Insert default system settings
INSERT INTO SystemSettings (SettingName, SettingValue, Description, Category) VALUES 
('SESSION_TIMEOUT', '480', 'Session timeout in minutes', 'Security'),
('MAX_LOGIN_ATTEMPTS', '5', 'Maximum failed login attempts', 'Security'),
('PASSWORD_EXPIRY_DAYS', '90', 'Password expiry in days', 'Security'),
('TWO_FACTOR_REQUIRED', 'false', 'Require two-factor authentication', 'Security'),
('IP_WHITELISTING_ENABLED', 'false', 'Enable IP whitelisting', 'Security'),
('EMAIL_NOTIFICATIONS', 'true', 'Enable email notifications', 'Notifications'),
('SMS_NOTIFICATIONS', 'false', 'Enable SMS notifications', 'Notifications'),
('AUTO_BACKUP', 'true', 'Enable automatic backup', 'Backup'),
('BACKUP_FREQUENCY', 'Daily', 'Backup frequency', 'Backup'),
('COMPANY_NAME', 'Oven Delights', 'Company name', 'General'),
('DEFAULT_LANGUAGE', 'English', 'Default system language', 'General'),
('DEFAULT_THEME', 'Light', 'Default UI theme', 'General');

-- Insert default super administrator user (password: 12345678)
-- BCrypt hash for "12345678"
INSERT INTO Users (Username, Email, PasswordHash, Password, FirstName, LastName, RoleID, BranchID, EmailVerified) 
VALUES ('R@j3np1ll@y', 'admin@ovendelights.com', '$2a$11$8gF7YQvnAb5rX9kL2mN3/.vQZJ8pK4tL6wE9sR2nM7cH1dF5gB3yO', '12345678', 'Super', 'Administrator', 1, 1, 1);

-- Grant all permissions to Super Administrator role
INSERT INTO RolePermissions (RoleID, PermissionID, CanCreate, CanRead, CanUpdate, CanDelete)
SELECT 1, PermissionID, 1, 1, 1, 1 FROM Permissions;

-- Create indexes for performance
CREATE INDEX IX_Users_Username ON Users(Username);
CREATE INDEX IX_Users_Email ON Users(Email);
CREATE INDEX IX_UserSessions_UserID ON UserSessions(UserID);
CREATE INDEX IX_UserSessions_SessionToken ON UserSessions(SessionToken);
CREATE INDEX IX_AuditLog_UserID ON AuditLog(UserID);
CREATE INDEX IX_AuditLog_Timestamp ON AuditLog(Timestamp);
CREATE INDEX IX_AccountingJournals_ReferenceID ON AccountingJournals(ReferenceID, ReferenceTable);

PRINT 'Comprehensive User Management System database schema created successfully!';
