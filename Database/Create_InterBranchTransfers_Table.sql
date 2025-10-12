-- =============================================
-- Inter-Branch Transfers Table
-- Tracks stock transfers between branches
-- =============================================

IF OBJECT_ID('dbo.InterBranchTransfers','U') IS NULL
BEGIN
    CREATE TABLE dbo.InterBranchTransfers (
        TransferID INT IDENTITY(1,1) PRIMARY KEY,
        TransferNumber NVARCHAR(50) NOT NULL UNIQUE,
        FromBranchID INT NOT NULL,
        ToBranchID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity DECIMAL(18,4) NOT NULL,
        UnitCost DECIMAL(18,4) NOT NULL DEFAULT(0),
        TotalValue DECIMAL(18,4) NOT NULL DEFAULT(0),
        TransferDate DATETIME NOT NULL,
        Reference NVARCHAR(200) NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT('Pending'), -- Pending, Completed, Cancelled
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        CompletedBy INT NULL,
        CompletedDate DATETIME NULL,
        CONSTRAINT FK_InterBranchTransfers_FromBranch FOREIGN KEY (FromBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InterBranchTransfers_ToBranch FOREIGN KEY (ToBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InterBranchTransfers_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT CHK_InterBranchTransfers_DifferentBranches CHECK (FromBranchID <> ToBranchID)
    );
    
    CREATE INDEX IX_InterBranchTransfers_FromBranch ON dbo.InterBranchTransfers(FromBranchID);
    CREATE INDEX IX_InterBranchTransfers_ToBranch ON dbo.InterBranchTransfers(ToBranchID);
    CREATE INDEX IX_InterBranchTransfers_Product ON dbo.InterBranchTransfers(ProductID);
    CREATE INDEX IX_InterBranchTransfers_Date ON dbo.InterBranchTransfers(TransferDate);
    CREATE INDEX IX_InterBranchTransfers_Status ON dbo.InterBranchTransfers(Status);
    
    PRINT 'Created table: InterBranchTransfers';
END
ELSE
BEGIN
    PRINT 'Table InterBranchTransfers already exists';
END
GO

PRINT 'Inter-Branch Transfers table creation completed';
