-- Script to update the Branches table with all necessary columns
-- First, check if the table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Branches')
BEGIN
    -- Create the table if it doesn't exist
    CREATE TABLE [dbo].[Branches](
        [ID] [int] IDENTITY(1,1) NOT NULL,
        [BranchName] [nvarchar](100) NOT NULL,
        [BranchCode] [nvarchar](20) NULL,
        [Prefix] [nvarchar](10) NOT NULL,
        [Address] [nvarchar](255) NULL,
        [City] [nvarchar](100) NULL,
        [Province] [nvarchar](100) NULL,
        [PostalCode] [nvarchar](20) NULL,
        [Phone] [nvarchar](20) NULL,
        [Email] [nvarchar](100) NULL,
        [ManagerName] [nvarchar](100) NULL,
        [IsActive] [bit] NOT NULL DEFAULT 1,
        [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE(),
        [ModifiedDate] [datetime] NULL,
        [CreatedBy] [int] NULL,
        [ModifiedBy] [int] NULL,
        CONSTRAINT [PK_Branches] PRIMARY KEY CLUSTERED ([ID] ASC)
    )
    PRINT 'Branches table created successfully.'
END
ELSE
BEGIN
    -- Table exists, check and add missing columns
    PRINT 'Branches table already exists. Checking for missing columns...'
    
    -- Add BranchCode if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'BranchCode')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [BranchCode] [nvarchar](20) NULL
        PRINT 'Added BranchCode column.'
    END
    
    -- Add Address if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'Address')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [Address] [nvarchar](255) NULL
        PRINT 'Added Address column.'
    END
    
    -- Add City if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'City')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [City] [nvarchar](100) NULL
        PRINT 'Added City column.'
    END
    
    -- Add Province if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'Province')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [Province] [nvarchar](100) NULL
        PRINT 'Added Province column.'
    END
    
    -- Add PostalCode if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'PostalCode')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [PostalCode] [nvarchar](20) NULL
        PRINT 'Added PostalCode column.'
    END
    
    -- Add Phone if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'Phone')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [Phone] [nvarchar](20) NULL
        PRINT 'Added Phone column.'
    END
    
    -- Add Email if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'Email')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [Email] [nvarchar](100) NULL
        PRINT 'Added Email column.'
    END
    
    -- Add ManagerName if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'ManagerName')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [ManagerName] [nvarchar](100) NULL
        PRINT 'Added ManagerName column.'
    END
    
    -- Add IsActive if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'IsActive')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [IsActive] [bit] NOT NULL DEFAULT 1
        PRINT 'Added IsActive column with default value 1.'
    END
    
    -- Add CreatedDate if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'CreatedDate')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [CreatedDate] [datetime] NOT NULL DEFAULT GETDATE()
        PRINT 'Added CreatedDate column with default value GETDATE().'
    END
    
    -- Add ModifiedDate if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'ModifiedDate')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [ModifiedDate] [datetime] NULL
        PRINT 'Added ModifiedDate column.'
    END
    
    -- Add CreatedBy if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'CreatedBy')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [CreatedBy] [int] NULL
        PRINT 'Added CreatedBy column.'
    END
    
    -- Add ModifiedBy if it doesn't exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Branches') AND name = 'ModifiedBy')
    BEGIN
        ALTER TABLE [dbo].[Branches] ADD [ModifiedBy] [int] NULL
        PRINT 'Added ModifiedBy column.'
    END
    
    -- Add any necessary constraints
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Branches_Users_CreatedBy')
    BEGIN
        ALTER TABLE [dbo].[Branches] WITH CHECK 
        ADD CONSTRAINT [FK_Branches_Users_CreatedBy] FOREIGN KEY([CreatedBy])
        REFERENCES [dbo].[Users] ([UserID])
        PRINT 'Added foreign key constraint FK_Branches_Users_CreatedBy.'
    END
    
    IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Branches_Users_ModifiedBy')
    BEGIN
        ALTER TABLE [dbo].[Branches] WITH CHECK 
        ADD CONSTRAINT [FK_Branches_Users_ModifiedBy] FOREIGN KEY([ModifiedBy])
        REFERENCES [dbo].[Users] ([UserID])
        PRINT 'Added foreign key constraint FK_Branches_Users_ModifiedBy.'
    END
    
    -- Add any necessary indexes
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Branches_BranchCode' AND object_id = OBJECT_ID('Branches'))
    BEGIN
        CREATE NONCLUSTERED INDEX [IX_Branches_BranchCode] ON [dbo].[Branches] ([BranchCode])
        PRINT 'Added index IX_Branches_BranchCode.'
    END
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Branches_IsActive' AND object_id = OBJECT_ID('Branches'))
    BEGIN
        CREATE NONCLUSTERED INDEX [IX_Branches_IsActive] ON [dbo].[Branches] ([IsActive])
        PRINT 'Added index IX_Branches_IsActive.'
    END
    
    PRINT 'Branches table update completed.'
END

-- Display the final table structure
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable,
    ISNULL(i.is_primary_key, 0) AS IsPrimaryKey
FROM 
    sys.columns c
INNER JOIN 
    sys.types t ON c.user_type_id = t.user_type_id
LEFT OUTER JOIN 
    sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
LEFT OUTER JOIN 
    sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
WHERE 
    c.object_id = OBJECT_ID('Branches')
ORDER BY 
    c.column_id;
