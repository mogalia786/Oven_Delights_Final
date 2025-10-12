-- =============================================
-- Oven Delights ERP - Database Schema
-- Part 1: Drop and Recreate Database
-- =============================================

-- Set NOCOUNT to prevent extra result sets
SET NOCOUNT ON;
GO

-- Check if database exists and needs to be recreated
DECLARE @databaseName NVARCHAR(128) = 'Oven_Delights_Main';
DECLARE @sql NVARCHAR(MAX);

-- If database exists, set it to single user mode and drop it
IF DB_ID(@databaseName) IS NOT NULL
BEGIN
    -- Set database to single user mode to drop connections
    SET @sql = 'ALTER DATABASE [' + @databaseName + '] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;';
    EXEC sp_executesql @sql;
    
    -- Drop the database
    SET @sql = 'DROP DATABASE [' + @databaseName + '];';
    EXEC sp_executesql @sql;
    
    PRINT 'Dropped existing database: ' + @databaseName;
END
ELSE
BEGIN
    PRINT 'Database ' + @databaseName + ' does not exist, will be created.';
END

-- Create the database
SET @sql = 'CREATE DATABASE [' + @databaseName + '] ON PRIMARY (NAME = Oven_Delights_Main_Data, FILENAME = ''C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Database\Oven_Delights_Main.mdf'') LOG ON (NAME = Oven_Delights_Main_Log, FILENAME = ''C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Database\Oven_Delights_Main.ldf'');';
EXEC sp_executesql @sql;

PRINT 'Created database: ' + @databaseName;
GO

-- Set the database to use
USE [Oven_Delights_Main];
GO

-- Enable error handling
SET XACT_ABORT ON;
GO

-- Start transaction for the entire schema creation
BEGIN TRY
    BEGIN TRANSACTION;
    
    PRINT 'Starting database schema creation...';
    
    -- =============================================
    -- Create Tables
    -- =============================================
    
    -- Create Branches table
    CREATE TABLE [dbo].[Branches] (
        [BranchID] INT IDENTITY(1,1) PRIMARY KEY,
        [BranchName] NVARCHAR(100) NOT NULL,
        [BranchCode] NVARCHAR(20) UNIQUE NOT NULL,
        [Address] NVARCHAR(255),
        [City] NVARCHAR(100),
        [Province] NVARCHAR(100),
        [PostalCode] NVARCHAR(20),
        [Phone] NVARCHAR(20),
        [Email] NVARCHAR(100),
        [Manager] NVARCHAR(100),
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [ModifiedDate] DATETIME,
        [ModifiedBy] INT,
        [CostCenterCode] NVARCHAR(20)
    );
    
    PRINT 'Created table: Branches';
    
    -- Create Roles table
    CREATE TABLE [dbo].[Roles] (
        [RoleID] INT IDENTITY(1,1) PRIMARY KEY,
        [RoleName] NVARCHAR(50) NOT NULL UNIQUE,
        [Description] NVARCHAR(255),
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [ModifiedDate] DATETIME,
        [ModifiedBy] INT
    );
    
    PRINT 'Created table: Roles';
    
    -- Create Users table
    CREATE TABLE [dbo].[Users] (
        [UserID] INT IDENTITY(1,1) PRIMARY KEY,
        [Username] NVARCHAR(50) NOT NULL UNIQUE,
        [PasswordHash] NVARCHAR(255) NOT NULL,
        [Salt] NVARCHAR(100) NOT NULL,
        [Email] NVARCHAR(128) NOT NULL UNIQUE,
        [FirstName] NVARCHAR(50) NOT NULL,
        [LastName] NVARCHAR(50) NOT NULL,
        [RoleID] INT NOT NULL,
        [BranchID] INT,
        [Phone] NVARCHAR(20),
        [IsActive] BIT DEFAULT 1,
        [LastLogin] DATETIME,
        [PasswordLastChanged] DATETIME DEFAULT GETDATE(),
        [MustChangePassword] BIT DEFAULT 0,
        [FailedLoginAttempts] INT DEFAULT 0,
        [IsLockedOut] BIT DEFAULT 0,
        [LockoutEnd] DATETIME,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [ModifiedDate] DATETIME,
        [ModifiedBy] INT,
        CONSTRAINT [FK_Users_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]),
        CONSTRAINT [FK_Users_Branches] FOREIGN KEY ([BranchID]) REFERENCES [Branches]([BranchID])
    );
    
    PRINT 'Created table: Users';
    
    -- Create Permissions table
    CREATE TABLE [dbo].[Permissions] (
        [PermissionID] INT IDENTITY(1,1) PRIMARY KEY,
        [PermissionName] NVARCHAR(100) NOT NULL UNIQUE,
        [Category] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(255),
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT
    );
    
    PRINT 'Created table: Permissions';
    
    -- Create RolePermissions table
    CREATE TABLE [dbo].[RolePermissions] (
        [RolePermissionID] INT IDENTITY(1,1) PRIMARY KEY,
        [RoleID] INT NOT NULL,
        [PermissionID] INT NOT NULL,
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        CONSTRAINT [FK_RolePermissions_Roles] FOREIGN KEY ([RoleID]) REFERENCES [Roles]([RoleID]) ON DELETE CASCADE,
        CONSTRAINT [FK_RolePermissions_Permissions] FOREIGN KEY ([PermissionID]) REFERENCES [Permissions]([PermissionID]) ON DELETE CASCADE,
        CONSTRAINT [UQ_RolePermissions_RoleID_PermissionID] UNIQUE ([RoleID], [PermissionID])
    );
    
    PRINT 'Created table: RolePermissions';
    
    -- Create PasswordHistory table
    CREATE TABLE [dbo].[PasswordHistory] (
        [PasswordHistoryID] INT IDENTITY(1,1) PRIMARY KEY,
        [UserID] INT NOT NULL,
        [PasswordHash] NVARCHAR(255) NOT NULL,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        CONSTRAINT [FK_PasswordHistory_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE
    );
    
    PRINT 'Created table: PasswordHistory';
    
    -- Create UserPreferences table
    CREATE TABLE [dbo].[UserPreferences] (
        [PreferenceID] INT IDENTITY(1,1) PRIMARY KEY,
        [UserID] INT NOT NULL,
        [PreferenceName] NVARCHAR(100) NOT NULL,
        [PreferenceValue] NVARCHAR(MAX),
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [ModifiedDate] DATETIME,
        CONSTRAINT [FK_UserPreferences_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE,
        CONSTRAINT [UQ_UserPreferences_UserID_PreferenceName] UNIQUE ([UserID], [PreferenceName])
    );
    
    PRINT 'Created table: UserPreferences';
    
    -- Create AuditLog table
    CREATE TABLE [dbo].[AuditLog] (
        [AuditLogID] BIGINT IDENTITY(1,1) PRIMARY KEY,
        [UserID] INT,
        [Action] NVARCHAR(50) NOT NULL,
        [TableName] NVARCHAR(100) NOT NULL,
        [RecordID] NVARCHAR(100) NOT NULL,
        [OldValues] NVARCHAR(MAX),
        [NewValues] NVARCHAR(MAX),
        [IPAddress] NVARCHAR(50),
        [UserAgent] NVARCHAR(255),
        [Timestamp] DATETIME DEFAULT GETDATE(),
        CONSTRAINT [FK_AuditLog_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE SET NULL
    );
    
    PRINT 'Created table: AuditLog';
    
    -- Create Notifications table
    CREATE TABLE [dbo].[Notifications] (
        [NotificationID] INT IDENTITY(1,1) PRIMARY KEY,
        [Title] NVARCHAR(255) NOT NULL,
        [Message] NVARCHAR(MAX) NOT NULL,
        [Type] NVARCHAR(50) NOT NULL,
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [ExpiryDate] DATETIME,
        CONSTRAINT [FK_Notifications_Users] FOREIGN KEY ([CreatedBy]) REFERENCES [Users]([UserID]) ON DELETE SET NULL
    );
    
    PRINT 'Created table: Notifications';
    
    -- Create UserNotifications table
    CREATE TABLE [dbo].[UserNotifications] (
        [UserNotificationID] INT IDENTITY(1,1) PRIMARY KEY,
        [UserID] INT NOT NULL,
        [NotificationID] INT NOT NULL,
        [IsRead] BIT DEFAULT 0,
        [ReadDate] DATETIME,
        CONSTRAINT [FK_UserNotifications_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE,
        CONSTRAINT [FK_UserNotifications_Notifications] FOREIGN KEY ([NotificationID]) REFERENCES [Notifications]([NotificationID]) ON DELETE CASCADE
    );
    
    PRINT 'Created table: UserNotifications';
    
    -- Create UserSessions table
    CREATE TABLE [dbo].[UserSessions] (
        [SessionID] INT IDENTITY(1,1) PRIMARY KEY,
        [UserID] INT NOT NULL,
        [SessionToken] NVARCHAR(255) NOT NULL UNIQUE,
        [LoginTime] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastActivity] DATETIME NOT NULL DEFAULT GETDATE(),
        [ExpiryTime] DATETIME NOT NULL,
        [IPAddress] NVARCHAR(50),
        [UserAgent] NVARCHAR(255),
        [IsActive] BIT DEFAULT 1,
        CONSTRAINT [FK_UserSessions_Users] FOREIGN KEY ([UserID]) REFERENCES [Users]([UserID]) ON DELETE CASCADE
    );
    
    PRINT 'Created table: UserSessions';
    
    -- Create SystemSettings table
    CREATE TABLE [dbo].[SystemSettings] (
        [SettingID] INT IDENTITY(1,1) PRIMARY KEY,
        [SettingKey] NVARCHAR(100) NOT NULL UNIQUE,
        [SettingValue] NVARCHAR(MAX),
        [DataType] NVARCHAR(20) DEFAULT 'string',
        [Category] NVARCHAR(50),
        [Description] NVARCHAR(255),
        [IsActive] BIT DEFAULT 1,
        [CreatedDate] DATETIME DEFAULT GETDATE(),
        [CreatedBy] INT,
        [ModifiedDate] DATETIME,
        [ModifiedBy] INT
    );
    
    PRINT 'Created table: SystemSettings';
    
    -- =============================================
    -- Create Indexes
    -- =============================================
    
    -- Indexes for Users table
    CREATE NONCLUSTERED INDEX [IX_Users_Email] ON [dbo].[Users] ([Email]);
    CREATE NONCLUSTERED INDEX [IX_Users_RoleID] ON [dbo].[Users] ([RoleID]);
    CREATE NONCLUSTERED INDEX [IX_Users_BranchID] ON [dbo].[Users] ([BranchID]);
    
    -- Indexes for RolePermissions table
    CREATE NONCLUSTERED INDEX [IX_RolePermissions_RoleID] ON [dbo].[RolePermissions] ([RoleID]);
    CREATE NONCLUSTERED INDEX [IX_RolePermissions_PermissionID] ON [dbo].[RolePermissions] ([PermissionID]);
    
    -- Indexes for AuditLog table
    CREATE NONCLUSTERED INDEX [IX_AuditLog_UserID] ON [dbo].[AuditLog] ([UserID]);
    CREATE NONCLUSTERED INDEX [IX_AuditLog_Timestamp] ON [dbo].[AuditLog] ([Timestamp]);
    
    -- Indexes for UserSessions table
    CREATE NONCLUSTERED INDEX [IX_UserSessions_UserID] ON [dbo].[UserSessions] ([UserID]);
    CREATE NONCLUSTERED INDEX [IX_UserSessions_SessionToken] ON [dbo].[UserSessions] ([SessionToken]);
    
    -- Indexes for UserNotifications table
    CREATE NONCLUSTERED INDEX [IX_UserNotifications_UserID] ON [dbo].[UserNotifications] ([UserID]);
    CREATE NONCLUSTERED INDEX [IX_UserNotifications_NotificationID] ON [dbo].[UserNotifications] ([NotificationID]);
    
    -- Indexes for PasswordHistory table
    CREATE NONCLUSTERED INDEX [IX_PasswordHistory_UserID] ON [dbo].[PasswordHistory] ([UserID]);
    
    PRINT 'Created all indexes.';
    
    -- =============================================
    -- Insert Default Data
    -- =============================================
    
    -- Insert default branch
    DECLARE @HeadOfficeID INT;
    
    INSERT INTO [dbo].[Branches] (
        [BranchName], [BranchCode], [Address], [City], [Province], [PostalCode], 
        [Phone], [Email], [Manager], [IsActive], [CostCenterCode]
    ) VALUES (
        'Head Office', 'HO', '123 Main Street', 'Johannesburg', 'Gauteng', '2000',
        '+27111234567', 'info@ovendelights.com', 'System Administrator', 1, 'HO-CC-001'
    );
    
    SET @HeadOfficeID = SCOPE_IDENTITY();
    PRINT 'Inserted default Head Office branch.';
    
    -- Insert default roles
    DECLARE @AdminRoleID INT, @ManagerRoleID INT, @UserRoleID INT;
    
    -- Administrator role
    INSERT INTO [dbo].[Roles] ([RoleName], [Description], [IsActive])
    VALUES ('Administrator', 'System administrator with full access', 1);
    
    SET @AdminRoleID = SCOPE_IDENTITY();
    PRINT 'Inserted Administrator role.';
    
    -- Manager role
    INSERT INTO [dbo].[Roles] ([RoleName], [Description], [IsActive])
    VALUES ('Manager', 'Branch manager with elevated privileges', 1);
    
    SET @ManagerRoleID = SCOPE_IDENTITY();
    PRINT 'Inserted Manager role.';
    
    -- User role
    INSERT INTO [dbo].[Roles] ([RoleName], [Description], [IsActive])
    VALUES ('User', 'Standard user with basic access', 1);
    
    SET @UserRoleID = SCOPE_IDENTITY();
    PRINT 'Inserted User role.';
    
    -- Insert default admin user
    DECLARE @salt NVARCHAR(100) = NEWID();
    DECLARE @passwordHash NVARCHAR(255) = CONVERT(NVARCHAR(255), HASHBYTES('SHA2_256', 'Admin@123' + @salt), 2);
    DECLARE @adminUserID INT;
    
    INSERT INTO [dbo].[Users] (
        [Username], [PasswordHash], [Salt], [Email], [FirstName], [LastName],
        [RoleID], [BranchID], [Phone], [IsActive], [PasswordLastChanged],
        [CreatedDate]
    ) VALUES (
        'admin', @passwordHash, @salt, 'admin@ovendelights.com', 'System', 'Administrator',
        @AdminRoleID, @HeadOfficeID, '+27123456789', 1, GETDATE(),
        GETDATE()
    );
    
    SET @adminUserID = SCOPE_IDENTITY();
    
    -- Update CreatedBy to reference the admin user
    UPDATE [dbo].[Users] SET [CreatedBy] = @adminUserID WHERE [UserID] = @adminUserID;
    
    -- Update Branches.CreatedBy
    UPDATE [dbo].[Branches] SET [CreatedBy] = @adminUserID;
    
    -- Update Roles.CreatedBy
    UPDATE [dbo].[Roles] SET [CreatedBy] = @adminUserID;
    
    PRINT 'Inserted default admin user with username: admin and password: Admin@123';
    
    -- Insert default permissions
    DECLARE @PermissionID INT;
    
    -- User Management permissions
    INSERT INTO [dbo].[Permissions] ([PermissionName], [Category], [Description], [IsActive], [CreatedBy])
    VALUES ('UserManagement', 'Administration', 'Manage users and accounts', 1, @adminUserID);
    
    SET @PermissionID = SCOPE_IDENTITY();
    
    -- Assign to Administrator role
    INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [IsActive], [CreatedBy])
    VALUES (@AdminRoleID, @PermissionID, 1, @adminUserID);
    
    -- Role Management permissions
    INSERT INTO [dbo].[Permissions] ([PermissionName], [Category], [Description], [IsActive], [CreatedBy])
    VALUES ('RoleManagement', 'Administration', 'Manage roles and permissions', 1, @adminUserID);
    
    SET @PermissionID = SCOPE_IDENTITY();
    
    -- Assign to Administrator role
    INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [IsActive], [CreatedBy])
    VALUES (@AdminRoleID, @PermissionID, 1, @adminUserID);
    
    -- Branch Management permissions
    INSERT INTO [dbo].[Permissions] ([PermissionName], [Category], [Description], [IsActive], [CreatedBy])
    VALUES ('BranchManagement', 'Administration', 'Manage branches and locations', 1, @adminUserID);
    
    SET @PermissionID = SCOPE_IDENTITY();
    
    -- Assign to Administrator and Manager roles
    INSERT INTO [dbo].[RolePermissions] ([RoleID], [PermissionID], [IsActive], [CreatedBy])
    VALUES 
        (@AdminRoleID, @PermissionID, 1, @adminUserID),
        (@ManagerRoleID, @PermissionID, 1, @adminUserID);
    
    -- Insert system settings
    INSERT INTO [dbo].[SystemSettings] (
        [SettingKey], [SettingValue], [DataType], [Category], [Description], [IsActive], [CreatedBy]
    ) VALUES 
        ('SystemName', 'Oven Delights ERP', 'string', 'General', 'The name of the system', 1, @adminUserID),
        ('DefaultPageSize', '20', 'number', 'UI', 'Default number of items per page', 1, @adminUserID),
        ('SessionTimeoutMinutes', '30', 'number', 'Security', 'User session timeout in minutes', 1, @adminUserID);
    
    PRINT 'Inserted default system settings.';
    
    -- Log the creation of the admin user
    INSERT INTO [dbo].[AuditLog] (
        [UserID], [Action], [TableName], [RecordID], [NewValues], [IPAddress], [UserAgent]
    ) VALUES (
        @adminUserID, 'INSERT', 'Users', CAST(@adminUserID AS NVARCHAR(50)),
        '{"Username":"admin", "Email":"admin@ovendelights.com", "FirstName":"System", "LastName":"Administrator"}',
        '127.0.0.1', 'SQL Script'
    );
    
    PRINT 'Default data inserted successfully.';
    
    -- Commit the transaction
    COMMIT TRANSACTION;
    
    PRINT 'Database schema created successfully.';
    PRINT 'Default admin credentials:';
    PRINT '  Username: admin';
    PRINT '  Password: Admin@123';
    PRINT '';
    PRINT 'Please change the default password after first login.';
    
END TRY
BEGIN CATCH
    -- If there's an error, roll back the transaction
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    -- Log the error
    DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
    DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
    DECLARE @ErrorState INT = ERROR_STATE();
    
    RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    
    PRINT 'Error creating database schema. Changes have been rolled back.';
END CATCH;
GO

-- Set the recovery model to SIMPLE to reduce log growth during development
-- In production, consider using FULL recovery model with proper backup strategy
ALTER DATABASE [Oven_Delights_Main] SET RECOVERY SIMPLE;
GO

PRINT 'Database setup completed successfully.';
GO
