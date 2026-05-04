-- Create ContinuousPrinterConfig table for network printer setup
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ContinuousPrinterConfig')
BEGIN
    CREATE TABLE dbo.ContinuousPrinterConfig (
        ConfigID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        PrinterName NVARCHAR(255) NOT NULL,
        PrinterPath NVARCHAR(500) NOT NULL, -- Network path like \\SERVER\LX350
        IsActive BIT DEFAULT 1,
        PaperWidth INT DEFAULT 80, -- mm
        PaperHeight INT DEFAULT 297, -- mm (continuous feed)
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME DEFAULT GETDATE()
        -- FK constraint removed - add manually after finding correct branch table
    );

    PRINT 'ContinuousPrinterConfig table created successfully';
    PRINT 'NOTE: Add FK constraint to branch table manually after confirming table name';
END
ELSE
BEGIN
    PRINT 'ContinuousPrinterConfig table already exists';
END
GO
