-- =============================================
-- Create JournalEntries Table
-- For tracking all ledger transactions
-- =============================================

IF OBJECT_ID('dbo.JournalEntries','U') IS NULL
BEGIN
    CREATE TABLE dbo.JournalEntries (
        JournalID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        AccountType NVARCHAR(100) NOT NULL, -- e.g., 'Inventory', 'Inter-Branch Debtors', 'Inter-Branch Creditors'
        LedgerCode NVARCHAR(50) NOT NULL, -- e.g., 'i-PROD-123' or 'x-PROD-456'
        DebitAmount DECIMAL(18,4) NOT NULL DEFAULT(0),
        CreditAmount DECIMAL(18,4) NOT NULL DEFAULT(0),
        Reference NVARCHAR(100) NULL, -- PO Number, Transfer Reference, etc.
        Description NVARCHAR(500) NULL,
        TransactionDate DATETIME NOT NULL,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        CONSTRAINT FK_JournalEntries_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CHK_JournalEntries_DebitOrCredit CHECK (DebitAmount > 0 OR CreditAmount > 0)
    );
    
    CREATE INDEX IX_JournalEntries_Branch ON dbo.JournalEntries(BranchID);
    CREATE INDEX IX_JournalEntries_LedgerCode ON dbo.JournalEntries(LedgerCode);
    CREATE INDEX IX_JournalEntries_TransactionDate ON dbo.JournalEntries(TransactionDate);
    CREATE INDEX IX_JournalEntries_Reference ON dbo.JournalEntries(Reference);
    
    PRINT '✓ Created table: JournalEntries';
END
ELSE
BEGIN
    PRINT 'Table JournalEntries already exists';
END
GO

PRINT 'JournalEntries table creation completed';
