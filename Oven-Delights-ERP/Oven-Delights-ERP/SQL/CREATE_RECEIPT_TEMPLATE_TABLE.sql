-- Receipt Template Configuration Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReceiptTemplateConfig') AND type in (N'U'))
BEGIN
    CREATE TABLE ReceiptTemplateConfig (
        ConfigID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        FieldName NVARCHAR(100) NOT NULL,
        XPosition INT NOT NULL DEFAULT 0,
        YPosition INT NOT NULL DEFAULT 0,
        FontSize INT NOT NULL DEFAULT 8,
        IsBold BIT NOT NULL DEFAULT 0,
        IsEnabled BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_ReceiptTemplate_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    PRINT 'ReceiptTemplateConfig table created';
END

-- Printer Configuration Table
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PrinterConfig') AND type in (N'U'))
BEGIN
    CREATE TABLE PrinterConfig (
        PrinterID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        PrinterName NVARCHAR(200),
        PrinterIPAddress NVARCHAR(50),
        PrinterType NVARCHAR(50) DEFAULT 'DotMatrix',
        PaperWidth INT DEFAULT 220, -- mm
        IsDefault BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Printer_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    PRINT 'PrinterConfig table created';
END
GO
