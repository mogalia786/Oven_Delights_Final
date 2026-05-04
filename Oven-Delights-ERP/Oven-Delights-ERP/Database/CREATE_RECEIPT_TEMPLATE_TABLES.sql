-- Create ReceiptTemplateConfig table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReceiptTemplateConfig')
BEGIN
    CREATE TABLE ReceiptTemplateConfig (
        ConfigID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        FieldName NVARCHAR(50) NOT NULL,
        XPosition INT NOT NULL,
        YPosition INT NOT NULL,
        FontSize INT NOT NULL DEFAULT 8,
        IsBold BIT NOT NULL DEFAULT 0,
        IsEnabled BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_ReceiptTemplate_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    )
    
    CREATE INDEX IX_ReceiptTemplate_Branch ON ReceiptTemplateConfig(BranchID)
    
    PRINT 'ReceiptTemplateConfig table created successfully'
END
ELSE
BEGIN
    PRINT 'ReceiptTemplateConfig table already exists'
END
GO

-- Create PrinterConfig table
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PrinterConfig')
BEGIN
    CREATE TABLE PrinterConfig (
        PrinterConfigID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        PrinterName NVARCHAR(200) NULL,
        PrinterIPAddress NVARCHAR(50) NULL,
        IsNetworkPrinter BIT NOT NULL DEFAULT 0,
        PaperWidth INT NOT NULL DEFAULT 220, -- mm
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedDate DATETIME NULL,
        CONSTRAINT FK_PrinterConfig_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    )
    
    CREATE INDEX IX_PrinterConfig_Branch ON PrinterConfig(BranchID)
    
    PRINT 'PrinterConfig table created successfully'
END
ELSE
BEGIN
    PRINT 'PrinterConfig table already exists'
END
GO
