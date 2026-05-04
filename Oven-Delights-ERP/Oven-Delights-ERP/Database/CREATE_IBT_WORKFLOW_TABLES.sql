-- =============================================
-- Inter-Branch Transfer Workflow Tables
-- =============================================

-- 1. Internal Purchase Orders (Requests from Branch A to Branch B)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InternalPurchaseOrders]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[InternalPurchaseOrders] (
        [InternalPOID] INT IDENTITY(1,1) PRIMARY KEY,
        [PONumber] NVARCHAR(50) NOT NULL UNIQUE,
        [RequestingBranchID] INT NOT NULL,
        [SupplyingBranchID] INT NOT NULL,
        [ProductID] INT NOT NULL,
        [Quantity] DECIMAL(18,2) NOT NULL,
        [RequestedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [RequiredByDate] DATETIME NULL,
        [Status] NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, Approved, Rejected, Fulfilled
        [Notes] NVARCHAR(500) NULL,
        [ApprovedBy] INT NULL,
        [ApprovedDate] DATETIME NULL,
        [RejectionReason] NVARCHAR(500) NULL,
        [CreatedBy] INT NOT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_InternalPO_RequestingBranch FOREIGN KEY (RequestingBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InternalPO_SupplyingBranch FOREIGN KEY (SupplyingBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InternalPO_Product FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID),
        CONSTRAINT FK_InternalPO_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
    );
    PRINT 'Table InternalPurchaseOrders created successfully';
END
ELSE
BEGIN
    PRINT 'Table InternalPurchaseOrders already exists';
END
GO

-- 2. Internal Delivery Notes (Deliveries from Branch B to Branch A)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InternalDeliveryNotes]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[InternalDeliveryNotes] (
        [DeliveryNoteID] INT IDENTITY(1,1) PRIMARY KEY,
        [DeliveryNoteNumber] NVARCHAR(50) NOT NULL UNIQUE,
        [InternalPOID] INT NOT NULL,
        [FromBranchID] INT NOT NULL,
        [FromBranchName] NVARCHAR(100) NULL,
        [FromBranchAddress] NVARCHAR(500) NULL,
        [ToBranchID] INT NOT NULL,
        [ToBranchName] NVARCHAR(100) NULL,
        [ToBranchAddress] NVARCHAR(500) NULL,
        [ProductID] INT NOT NULL,
        [Quantity] DECIMAL(18,2) NOT NULL,
        [UnitCost] DECIMAL(18,2) NOT NULL,
        [TotalValue] DECIMAL(18,2) NOT NULL,
        [DispatchDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [ReceiveDate] DATETIME NULL,
        [Status] NVARCHAR(20) NOT NULL DEFAULT 'In Transit', -- In Transit, Delivered, Cancelled
        [Notes] NVARCHAR(500) NULL,
        [ReceivedBy] INT NULL,
        [CreatedBy] INT NOT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_InternalDel_InternalPO FOREIGN KEY (InternalPOID) REFERENCES InternalPurchaseOrders(InternalPOID),
        CONSTRAINT FK_InternalDel_FromBranch FOREIGN KEY (FromBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InternalDel_ToBranch FOREIGN KEY (ToBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InternalDel_Product FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID),
        CONSTRAINT FK_InternalDel_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
    );
    PRINT 'Table InternalDeliveryNotes created successfully';
END
ELSE
BEGIN
    PRINT 'Table InternalDeliveryNotes already exists';
END
GO

-- 3. Inter-Branch Ledger (Debtor/Creditor tracking)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InterBranchLedger]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[InterBranchLedger] (
        [LedgerID] INT IDENTITY(1,1) PRIMARY KEY,
        [DebtorBranchID] INT NOT NULL, -- Branch that owes money
        [CreditorBranchID] INT NOT NULL, -- Branch that is owed money
        [DeliveryNoteID] INT NOT NULL,
        [Amount] DECIMAL(18,2) NOT NULL,
        [TransactionDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [Status] NVARCHAR(20) NOT NULL DEFAULT 'Outstanding', -- Outstanding, Settled
        [SettlementDate] DATETIME NULL,
        [SettlementReference] NVARCHAR(100) NULL,
        [Notes] NVARCHAR(500) NULL,
        [CreatedBy] INT NOT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_InterBranchLedger_DebtorBranch FOREIGN KEY (DebtorBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InterBranchLedger_CreditorBranch FOREIGN KEY (CreditorBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_InterBranchLedger_DeliveryNote FOREIGN KEY (DeliveryNoteID) REFERENCES InternalDeliveryNotes(DeliveryNoteID),
        CONSTRAINT FK_InterBranchLedger_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
    );
    PRINT 'Table InterBranchLedger created successfully';
END
ELSE
BEGIN
    PRINT 'Table InterBranchLedger already exists';
END
GO

PRINT 'IBT Workflow tables created successfully!';
