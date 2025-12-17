-- Create table for accounting entries (journal entries)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AccountingEntries')
BEGIN
    CREATE TABLE AccountingEntries (
        EntryID INT IDENTITY(1,1) PRIMARY KEY,
        EntryDate DATETIME NOT NULL DEFAULT GETDATE(),
        EntryType NVARCHAR(50) NOT NULL, -- 'Production', 'StockAdjustment', 'Sale', etc.
        ReferenceID INT NULL, -- ReOrderBookID, AdjustmentID, etc.
        ReferenceNumber NVARCHAR(50) NULL,
        AccountCode NVARCHAR(20) NOT NULL, -- '5000' = Cost of Sales, '1300' = Inventory, etc.
        AccountName NVARCHAR(100) NOT NULL,
        DebitAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
        CreditAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
        Description NVARCHAR(500) NULL,
        BranchID INT NOT NULL,
        CreatedBy NVARCHAR(100) NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    )
    
    CREATE INDEX IX_AccountingEntries_Date ON AccountingEntries(EntryDate)
    CREATE INDEX IX_AccountingEntries_Type ON AccountingEntries(EntryType)
    CREATE INDEX IX_AccountingEntries_Branch ON AccountingEntries(BranchID)
    
    PRINT 'AccountingEntries table created successfully'
END
ELSE
BEGIN
    PRINT 'AccountingEntries table already exists'
END
GO
