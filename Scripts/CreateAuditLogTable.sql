-- Create AuditLog table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLog')
BEGIN
    CREATE TABLE [dbo].[AuditLog] (
        [AuditLogID] INT IDENTITY(1,1) PRIMARY KEY,
        [UserID] INT NULL,
        [Action] NVARCHAR(100) NOT NULL,
        [TableName] NVARCHAR(100) NOT NULL,
        [RecordID] INT NULL,
        [OldValues] NVARCHAR(MAX) NULL,
        [NewValues] NVARCHAR(MAX) NULL,
        [ActionDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [IPAddress] NVARCHAR(50) NULL,
        [MachineName] NVARCHAR(100) NULL,
        [Details] NVARCHAR(MAX) NULL,
        CONSTRAINT [FK_AuditLog_User] FOREIGN KEY ([UserID]) REFERENCES [User]([UserID])
    )
    
    PRINT 'AuditLog table created successfully.'
END
ELSE
BEGIN
    PRINT 'AuditLog table already exists.'
END

-- Add any missing columns if the table exists but is missing some columns
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'AuditLog')
BEGIN
    -- Add UserID column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'UserID')
    BEGIN
        ALTER TABLE [AuditLog] ADD [UserID] INT NULL
        ALTER TABLE [AuditLog] ADD CONSTRAINT [FK_AuditLog_User] FOREIGN KEY ([UserID]) REFERENCES [User]([UserID])
        PRINT 'Added UserID column to AuditLog table.'
    END
    
    -- Add other columns if they don't exist
    DECLARE @sql NVARCHAR(MAX)
    
    -- Add Action column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'Action')
    BEGIN
        ALTER TABLE [AuditLog] ADD [Action] NVARCHAR(100) NOT NULL DEFAULT 'Unknown'
        PRINT 'Added Action column to AuditLog table.'
    END
    
    -- Add TableName column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'TableName')
    BEGIN
        ALTER TABLE [AuditLog] ADD [TableName] NVARCHAR(100) NOT NULL DEFAULT 'Unknown'
        PRINT 'Added TableName column to AuditLog table.'
    END
    
    -- Add RecordID column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'RecordID')
    BEGIN
        ALTER TABLE [AuditLog] ADD [RecordID] INT NULL
        PRINT 'Added RecordID column to AuditLog table.'
    END
    
    -- Add OldValues column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'OldValues')
    BEGIN
        ALTER TABLE [AuditLog] ADD [OldValues] NVARCHAR(MAX) NULL
        PRINT 'Added OldValues column to AuditLog table.'
    END
    
    -- Add NewValues column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'NewValues')
    BEGIN
        ALTER TABLE [AuditLog] ADD [NewValues] NVARCHAR(MAX) NULL
        PRINT 'Added NewValues column to AuditLog table.'
    END
    
    -- Add ActionDate column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'ActionDate')
    BEGIN
        ALTER TABLE [AuditLog] ADD [ActionDate] DATETIME NOT NULL DEFAULT GETDATE()
        PRINT 'Added ActionDate column to AuditLog table.'
    END
    
    -- Add IPAddress column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'IPAddress')
    BEGIN
        ALTER TABLE [AuditLog] ADD [IPAddress] NVARCHAR(50) NULL
        PRINT 'Added IPAddress column to AuditLog table.'
    END
    
    -- Add MachineName column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'MachineName')
    BEGIN
        ALTER TABLE [AuditLog] ADD [MachineName] NVARCHAR(100) NULL
        PRINT 'Added MachineName column to AuditLog table.'
    END
    
    -- Add Details column if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('AuditLog') AND name = 'Details')
    BEGIN
        ALTER TABLE [AuditLog] ADD [Details] NVARCHAR(MAX) NULL
        PRINT 'Added Details column to AuditLog table.'
    END
    
    -- Add primary key if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'PK_AuditLog' AND object_id = OBJECT_ID('AuditLog'))
    BEGIN
        ALTER TABLE [AuditLog] ADD CONSTRAINT [PK_AuditLog] PRIMARY KEY CLUSTERED ([AuditLogID])
        PRINT 'Added primary key to AuditLog table.'
    END
    
    PRINT 'AuditLog table structure verified and updated if necessary.'
END
