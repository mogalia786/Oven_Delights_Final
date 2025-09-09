/* Upgrade: Manufacturing Module (BOM + MO)
   Safe to run multiple times (IF NOT EXISTS guards)
*/
SET NOCOUNT ON;

/* 1) Extend DocumentNumbering for Manufacturing docs */
IF NOT EXISTS (SELECT 1 FROM DocumentNumbering WHERE DocumentType = 'MO')
BEGIN
    INSERT INTO DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength, BranchSpecific)
    VALUES ('MO', 'MO-', 1, 6, 1);
END
IF NOT EXISTS (SELECT 1 FROM DocumentNumbering WHERE DocumentType = 'MI')
BEGIN
    INSERT INTO DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength, BranchSpecific)
    VALUES ('MI', 'MI-', 1, 6, 1);
END
IF NOT EXISTS (SELECT 1 FROM DocumentNumbering WHERE DocumentType = 'MR')
BEGIN
    INSERT INTO DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength, BranchSpecific)
    VALUES ('MR', 'MR-', 1, 6, 1);
END

/* 2) Ensure core GL accounts exist (WIP, Finished Goods, Mfg Variance) */
-- WIP Inventory (Asset)
IF NOT EXISTS (SELECT 1 FROM GLAccounts WHERE AccountNumber = '1310')
BEGIN
    INSERT INTO GLAccounts (AccountNumber, AccountName, AccountType, BalanceType, IsSystem, IsActive)
    VALUES ('1310', 'Work In Progress', 'Asset', 'D', 0, 1);
END
-- Finished Goods (Asset) - create if not using 1300 Inventory only
IF NOT EXISTS (SELECT 1 FROM GLAccounts WHERE AccountNumber = '1320')
BEGIN
    INSERT INTO GLAccounts (AccountNumber, AccountName, AccountType, BalanceType, IsSystem, IsActive)
    VALUES ('1320', 'Finished Goods', 'Asset', 'D', 0, 1);
END
-- Manufacturing Variance (Expense)
IF NOT EXISTS (SELECT 1 FROM GLAccounts WHERE AccountNumber = '5700')
BEGIN
    INSERT INTO GLAccounts (AccountNumber, AccountName, AccountType, BalanceType, IsSystem, IsActive)
    VALUES ('5700', 'Manufacturing Variance', 'Expense', 'D', 0, 1);
END

/* 3) Inventory classification (optional: add ItemType to existing master) */
IF COL_LENGTH('InventoryItems', 'ItemType') IS NULL
BEGIN
    ALTER TABLE InventoryItems ADD ItemType VARCHAR(20) NULL; -- Raw, SemiFinished, Finished
END

/* 4) BOM tables */
IF OBJECT_ID('dbo.BOMHeader', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.BOMHeader (
        BOMID INT IDENTITY(1,1) PRIMARY KEY,
        ItemID INT NOT NULL,               -- Finished or SemiFinished item
        Version INT NOT NULL DEFAULT 1,
        YieldQty DECIMAL(18,4) NOT NULL DEFAULT 1,
        UoM NVARCHAR(20) NULL,
        ScrapPct DECIMAL(9,4) NOT NULL DEFAULT 0,
        IsActive BIT NOT NULL DEFAULT 1,
        EffectiveFrom DATE NULL,
        EffectiveTo DATE NULL,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL
        -- FK ItemID to InventoryItems(ItemID) if present
    );
END

IF OBJECT_ID('dbo.BOMItems', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.BOMItems (
        BOMItemID INT IDENTITY(1,1) PRIMARY KEY,
        BOMID INT NOT NULL,
        ComponentItemID INT NOT NULL,      -- Raw or SemiFinished component
        QtyPer DECIMAL(18,4) NOT NULL,
        UoM NVARCHAR(20) NULL,
        SequenceNo INT NOT NULL DEFAULT 1,
        IsBackflush BIT NOT NULL DEFAULT 1,
        IsOptional BIT NOT NULL DEFAULT 0,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        FOREIGN KEY (BOMID) REFERENCES dbo.BOMHeader(BOMID) ON DELETE CASCADE
        -- FK ComponentItemID to InventoryItems(ItemID) if present
    );
END

/* 5) Manufacturing Orders and transactions */
IF OBJECT_ID('dbo.ManufacturingOrders', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ManufacturingOrders (
        MOID INT IDENTITY(1,1) PRIMARY KEY,
        MONumber VARCHAR(30) NOT NULL UNIQUE,
        BOMID INT NULL,
        ItemID INT NOT NULL,               -- Product to make
        PlannedQty DECIMAL(18,4) NOT NULL,
        UoM NVARCHAR(20) NULL,
        Status VARCHAR(20) NOT NULL DEFAULT 'Planned', -- Planned, Released, InProgress, Completed, Closed, Canceled
        BranchID INT NULL,
        RequestedBy INT NULL,
        RequestedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ReleasedDate DATETIME NULL,
        CompletedDate DATETIME NULL,
        ClosedDate DATETIME NULL,
        JournalID INT NULL,
        Remarks NVARCHAR(255) NULL,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        FOREIGN KEY (BOMID) REFERENCES dbo.BOMHeader(BOMID),
        FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID),
        FOREIGN KEY (BranchID) REFERENCES Branches(ID),
        FOREIGN KEY (RequestedBy) REFERENCES Users(UserID)
    );
END

IF OBJECT_ID('dbo.MOConsumption', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MOConsumption (
        MOConsID INT IDENTITY(1,1) PRIMARY KEY,
        MOID INT NOT NULL,
        ComponentItemID INT NOT NULL,
        QtyIssued DECIMAL(18,4) NOT NULL,
        UoM NVARCHAR(20) NULL,
        CostAtIssue DECIMAL(18,4) NULL,
        InventoryTxnID INT NULL,
        JournalID INT NULL,
        IssuedDate DATETIME NOT NULL DEFAULT GETDATE(),
        IssuedBy INT NULL,
        FOREIGN KEY (MOID) REFERENCES dbo.ManufacturingOrders(MOID) ON DELETE CASCADE,
        FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID),
        FOREIGN KEY (IssuedBy) REFERENCES Users(UserID)
        -- FK InventoryTxnID REFERENCES InventoryTransactions(ID) if exists
    );
END

IF OBJECT_ID('dbo.MOOutputs', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.MOOutputs (
        MOOutID INT IDENTITY(1,1) PRIMARY KEY,
        MOID INT NOT NULL,
        OutputItemID INT NOT NULL,
        QtyReceived DECIMAL(18,4) NOT NULL,
        UoM NVARCHAR(20) NULL,
        StdCost DECIMAL(18,4) NULL,
        ActualCost DECIMAL(18,4) NULL,
        InventoryTxnID INT NULL,
        JournalID INT NULL,
        ReceivedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ReceivedBy INT NULL,
        FOREIGN KEY (MOID) REFERENCES dbo.ManufacturingOrders(MOID) ON DELETE CASCADE,
        FOREIGN KEY (JournalID) REFERENCES JournalHeaders(JournalID),
        FOREIGN KEY (ReceivedBy) REFERENCES Users(UserID)
        -- FK InventoryTxnID REFERENCES InventoryTransactions(ID) if exists
    );
END

/* 6) Helper indexes */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BOMItems_BOMID' AND object_id = OBJECT_ID('dbo.BOMItems'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_BOMItems_BOMID ON dbo.BOMItems(BOMID);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MOConsumption_MOID' AND object_id = OBJECT_ID('dbo.MOConsumption'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_MOConsumption_MOID ON dbo.MOConsumption(MOID);
END
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_MOOutputs_MOID' AND object_id = OBJECT_ID('dbo.MOOutputs'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_MOOutputs_MOID ON dbo.MOOutputs(MOID);
END

/* 7) Optional: Status check constraint */
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints WHERE name = 'CHK_ManufacturingOrders_Status')
BEGIN
    ALTER TABLE dbo.ManufacturingOrders WITH NOCHECK
    ADD CONSTRAINT CHK_ManufacturingOrders_Status CHECK (Status IN ('Planned','Released','InProgress','Completed','Closed','Canceled'));
END

PRINT 'Manufacturing Module upgrade completed.';
