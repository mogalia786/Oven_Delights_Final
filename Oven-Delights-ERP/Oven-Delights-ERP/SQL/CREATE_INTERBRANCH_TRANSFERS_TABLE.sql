-- Create InterBranchTransfers table for proper workflow management
-- Status flow: Pending → In Transit → Received

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'InterBranchTransfers')
BEGIN
    CREATE TABLE InterBranchTransfers (
        TransferID INT IDENTITY(1,1) PRIMARY KEY,
        TransferNumber NVARCHAR(50) NOT NULL UNIQUE,
        FromBranchID INT NOT NULL,
        ToBranchID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity DECIMAL(18,2) NOT NULL,
        UnitCost DECIMAL(18,2) NOT NULL,
        TotalValue DECIMAL(18,2) NOT NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, In Transit, Received, Cancelled
        Notes NVARCHAR(MAX) NULL,
        
        -- Audit fields
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        DispatchedBy INT NULL,
        DispatchedDate DATETIME NULL,
        ReceivedBy INT NULL,
        ReceivedDate DATETIME NULL,
        
        -- Foreign keys
        CONSTRAINT FK_InterBranchTransfers_FromBranch FOREIGN KEY (FromBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InterBranchTransfers_ToBranch FOREIGN KEY (ToBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InterBranchTransfers_Product FOREIGN KEY (ProductID) REFERENCES demo_Retail_product(ProductID),
        CONSTRAINT FK_InterBranchTransfers_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
    );
    
    CREATE INDEX IX_InterBranchTransfers_Status ON InterBranchTransfers(Status);
    CREATE INDEX IX_InterBranchTransfers_FromBranch ON InterBranchTransfers(FromBranchID);
    CREATE INDEX IX_InterBranchTransfers_ToBranch ON InterBranchTransfers(ToBranchID);
    CREATE INDEX IX_InterBranchTransfers_TransferNumber ON InterBranchTransfers(TransferNumber);
    
    PRINT 'InterBranchTransfers table created successfully';
END
ELSE
BEGIN
    PRINT 'InterBranchTransfers table already exists';
END
GO

-- Add TransferID column to PurchaseOrders if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseOrders') AND name = 'TransferID')
BEGIN
    ALTER TABLE PurchaseOrders ADD TransferID INT NULL;
    ALTER TABLE PurchaseOrders ADD CONSTRAINT FK_PurchaseOrders_Transfer FOREIGN KEY (TransferID) REFERENCES InterBranchTransfers(TransferID);
    PRINT 'Added TransferID column to PurchaseOrders';
END
GO
