-- Create SystemSettings table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'SystemSettings' AND type = 'U')
BEGIN
    CREATE TABLE [dbo].[SystemSettings] (
        [SettingID] INT IDENTITY(1,1) NOT NULL,
        [SettingName] NVARCHAR(100) NOT NULL,
        [SettingValue] NVARCHAR(MAX) NULL,
        [DataType] NVARCHAR(50) NOT NULL DEFAULT 'String',
        [Category] NVARCHAR(50) NOT NULL,
        [Description] NVARCHAR(500) NULL,
        [IsEncrypted] BIT NOT NULL DEFAULT 0,
        [DisplayOrder] INT NOT NULL DEFAULT 0,
        [CreatedBy] INT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [ModifiedBy] INT NULL,
        [ModifiedDate] DATETIME NULL,
        CONSTRAINT [PK_SystemSettings] PRIMARY KEY CLUSTERED ([SettingID] ASC),
        CONSTRAINT [UQ_SystemSettings_Category_Name] UNIQUE NONCLUSTERED ([Category] ASC, [SettingName] ASC),
        CONSTRAINT [FK_SystemSettings_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]),
        CONSTRAINT [FK_SystemSettings_Users_ModifiedBy] FOREIGN KEY ([ModifiedBy]) REFERENCES [dbo].[Users] ([UserID])
    );
    
    -- Create index for faster lookups by category
    CREATE NONCLUSTERED INDEX [IX_SystemSettings_Category] ON [dbo].[SystemSettings] ([Category] ASC);
    
    -- Create index for faster lookups by setting name
    CREATE NONCLUSTERED INDEX [IX_SystemSettings_SettingName] ON [dbo].[SystemSettings] ([SettingName] ASC);
    
    -- Insert default system settings
    -- Security Settings
    INSERT INTO [dbo].[SystemSettings] (
        [SettingName], [SettingValue], [DataType], [Category], [Description], [DisplayOrder]
    ) VALUES 
        ('SessionTimeout', '30', 'Integer', 'Security', 'User session timeout in minutes', 10),
        ('MaxLoginAttempts', '5', 'Integer', 'Security', 'Maximum number of failed login attempts before account is locked', 20),
        ('PasswordExpiryDays', '90', 'Integer', 'Security', 'Number of days until password expires', 30),
        ('TwoFactorRequired', '0', 'Boolean', 'Security', 'Whether two-factor authentication is required', 40),
        ('IPWhitelisting', '0', 'Boolean', 'Security', 'Whether IP whitelisting is enabled', 50),
        ('PasswordComplexity', '2', 'Integer', 'Security', 'Password complexity level (1=Low, 2=Medium, 3=High)', 60),
        ('InactiveSessionTimeout', '15', 'Integer', 'Security', 'Inactive session timeout in minutes', 70);
    
    -- Backup Settings
    INSERT INTO [dbo].[SystemSettings] (
        [SettingName], [SettingValue], [DataType], [Category], [Description], [DisplayOrder]
    ) VALUES 
        ('AutoBackup', '1', 'Boolean', 'Backup', 'Whether automatic backups are enabled', 10),
        ('BackupFrequency', 'Daily', 'String', 'Backup', 'Frequency of automatic backups', 20),
        ('BackupPath', '', 'String', 'Backup', 'Path where backups are stored', 30),
        ('KeepBackupDays', '30', 'Integer', 'Backup', 'Number of days to keep backup files', 40),
        ('CompressBackup', '1', 'Boolean', 'Backup', 'Whether to compress backup files', 50),
        ('LastBackup', NULL, 'DateTime', 'Backup', 'Date and time of last successful backup', 60);
    
    -- Email Settings
    INSERT INTO [dbo].[SystemSettings] (
        [SettingName], [SettingValue], [DataType], [Category], [Description], [DisplayOrder]
    ) VALUES 
        ('SmtpServer', '', 'String', 'Email', 'SMTP server address', 10),
        ('SmtpPort', '587', 'Integer', 'Email', 'SMTP server port', 20),
        ('SmtpUsername', '', 'String', 'Email', 'SMTP username', 30),
        ('SmtpPassword', '', 'String', 'Email', 'SMTP password (encrypted)', 40),
        ('EnableSsl', '1', 'Boolean', 'Email', 'Whether to use SSL/TLS for SMTP', 50),
        ('FromEmail', 'noreply@ovendelights.com', 'String', 'Email', 'Default sender email address', 60),
        ('FromName', 'Oven Delights ERP', 'String', 'Email', 'Default sender name', 70);
    
    -- General Settings
    INSERT INTO [dbo].[SystemSettings] (
        [SettingName], [SettingValue], [DataType], [Category], [Description], [DisplayOrder]
    ) VALUES 
        ('CompanyName', 'Oven Delights', 'String', 'General', 'Company name', 10),
        ('DefaultBranchId', '1', 'Integer', 'General', 'Default branch ID', 20),
        ('DefaultCurrency', 'ZAR', 'String', 'General', 'Default currency code', 30),
        ('DateFormat', 'yyyy-MM-dd', 'String', 'General', 'Default date format', 40),
        ('TimeFormat', 'HH:mm', 'String', 'General', 'Default time format', 50),
        ('ItemsPerPage', '50', 'Integer', 'General', 'Default number of items per page', 60),
        ('EnableAuditLog', '1', 'Boolean', 'General', 'Whether to enable audit logging', 70),
        ('AuditLogRetentionDays', '365', 'Integer', 'General', 'Number of days to retain audit logs', 80);
    
    PRINT 'SystemSettings table created successfully with default settings.';
END
ELSE
BEGIN
    PRINT 'SystemSettings table already exists.';
END

-- Create stored procedure for getting system settings by category
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetSystemSettingsByCategory')
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[sp_GetSystemSettingsByCategory]
        @Category NVARCHAR(50)
    AS
    BEGIN
        SET NOCOUNT ON;
        
        SELECT 
            SettingName,
            SettingValue,
            DataType,
            Category,
            Description,
            IsEncrypted,
            DisplayOrder
        FROM 
            [dbo].[SystemSettings]
        WHERE 
            Category = @Category
        ORDER BY 
            DisplayOrder, SettingName;
    END');
    
    PRINT 'Stored procedure sp_GetSystemSettingsByCategory created successfully.';
END
ELSE
BEGIN
    PRINT 'Stored procedure sp_GetSystemSettingsByCategory already exists.';
END

-- Create stored procedure for saving system settings
IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_SaveSystemSetting')
BEGIN
    EXEC('CREATE PROCEDURE [dbo].[sp_SaveSystemSetting]
        @SettingName NVARCHAR(100),
        @SettingValue NVARCHAR(MAX),
        @Category NVARCHAR(50),
        @DataType NVARCHAR(50) = ''String'',
        @Description NVARCHAR(500) = NULL,
        @IsEncrypted BIT = 0,
        @DisplayOrder INT = 0,
        @UserId INT
    AS
    BEGIN
        SET NOCOUNT ON;
        
        IF EXISTS (SELECT 1 FROM [dbo].[SystemSettings] WHERE SettingName = @SettingName AND Category = @Category)
        BEGIN
            -- Update existing setting
            UPDATE [dbo].[SystemSettings]
            SET 
                SettingValue = @SettingValue,
                DataType = @DataType,
                Description = ISNULL(@Description, Description),
                IsEncrypted = @IsEncrypted,
                DisplayOrder = @DisplayOrder,
                ModifiedBy = @UserId,
                ModifiedDate = GETDATE()
            WHERE 
                SettingName = @SettingName 
                AND Category = @Category;
        END
        ELSE
        BEGIN
            -- Insert new setting
            INSERT INTO [dbo].[SystemSettings] (
                SettingName, SettingValue, DataType, Category, 
                Description, IsEncrypted, DisplayOrder, CreatedBy
            )
            VALUES (
                @SettingName, @SettingValue, @DataType, @Category,
                @Description, @IsEncrypted, @DisplayOrder, @UserId
            );
        END
        
        SELECT SCOPE_IDENTITY() AS SettingID;
    END');
    
    PRINT 'Stored procedure sp_SaveSystemSetting created successfully.';
END
ELSE
BEGIN
    PRINT 'Stored procedure sp_SaveSystemSetting already exists.';
END
