-- =============================================
-- STOCK TRACKING SYSTEM
-- 3 Separate Tables: Stockroom, Manufacturing, Retail
-- Full Movement Tracking with Requestor/Receiver/Dates
-- =============================================

-- =============================================
-- 1. STOCKROOM STOCK (Raw Materials/Ingredients)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'StockroomStock')
BEGIN
    CREATE TABLE StockroomStock (
        StockroomStockID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        BranchID INT NOT NULL,
        Quantity DECIMAL(18,3) NOT NULL DEFAULT 0,
        UnitOfMeasure NVARCHAR(20) NULL,
        Location NVARCHAR(100) NULL, -- Shelf/Bin location
        BatchNumber NVARCHAR(50) NULL,
        ExpiryDate DATE NULL,
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedBy NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_StockroomStock_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_StockroomStock_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_StockroomStock_Product ON StockroomStock(ProductID);
    CREATE INDEX IX_StockroomStock_Branch ON StockroomStock(BranchID);
    
    PRINT '✅ StockroomStock table created';
END
ELSE
    PRINT '⚠️ StockroomStock table already exists';
GO

-- =============================================
-- 2. MANUFACTURING STOCK (Work-in-Progress)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ManufacturingStock')
BEGIN
    CREATE TABLE ManufacturingStock (
        ManufacturingStockID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        BranchID INT NOT NULL,
        Quantity DECIMAL(18,3) NOT NULL DEFAULT 0,
        UnitOfMeasure NVARCHAR(20) NULL,
        BOMID INT NULL, -- Link to Bill of Materials
        ProductionBatchNumber NVARCHAR(50) NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'In Progress', -- 'In Progress', 'Completed', 'Scrapped'
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedBy NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_ManufacturingStock_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_ManufacturingStock_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_ManufacturingStock_Product ON ManufacturingStock(ProductID);
    CREATE INDEX IX_ManufacturingStock_Branch ON ManufacturingStock(BranchID);
    CREATE INDEX IX_ManufacturingStock_Status ON ManufacturingStock(Status);
    
    PRINT '✅ ManufacturingStock table created';
END
ELSE
    PRINT '⚠️ ManufacturingStock table already exists';
GO

-- =============================================
-- 3. RETAIL STOCK (Finished Goods - Internal & External)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
BEGIN
    CREATE TABLE RetailStock (
        RetailStockID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        BranchID INT NOT NULL,
        Quantity DECIMAL(18,3) NOT NULL DEFAULT 0,
        StockType NVARCHAR(20) NOT NULL, -- 'Internal' (produced) or 'External' (purchased)
        UnitOfMeasure NVARCHAR(20) NULL,
        BatchNumber NVARCHAR(50) NULL,
        ExpiryDate DATE NULL,
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        UpdatedBy NVARCHAR(100) NOT NULL,
        CONSTRAINT FK_RetailStock_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_RetailStock_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CK_RetailStock_Type CHECK (StockType IN ('Internal', 'External'))
    );
    
    CREATE INDEX IX_RetailStock_Product ON RetailStock(ProductID);
    CREATE INDEX IX_RetailStock_Branch ON RetailStock(BranchID);
    CREATE INDEX IX_RetailStock_Type ON RetailStock(StockType);
    
    PRINT '✅ RetailStock table created';
END
ELSE
    PRINT '⚠️ RetailStock table already exists';
GO

-- =============================================
-- 4. STOCK MOVEMENT TRACKING (Full Audit Trail)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'StockMovements')
BEGIN
    CREATE TABLE StockMovements (
        MovementID INT IDENTITY(1,1) PRIMARY KEY,
        MovementDate DATETIME NOT NULL DEFAULT GETDATE(),
        ProductID INT NOT NULL,
        BranchID INT NOT NULL,
        
        -- Movement Details
        MovementType NVARCHAR(50) NOT NULL, -- 'PO Receipt', 'Transfer to Manufacturing', 'Production Complete', 'Sale', 'Adjustment', 'Return'
        FromLocation NVARCHAR(50) NULL, -- 'Stockroom', 'Manufacturing', 'Retail', 'Supplier', 'Customer'
        ToLocation NVARCHAR(50) NULL, -- 'Stockroom', 'Manufacturing', 'Retail', 'Customer'
        
        -- Quantity
        Quantity DECIMAL(18,3) NOT NULL,
        UnitOfMeasure NVARCHAR(20) NULL,
        
        -- References
        ReferenceType NVARCHAR(50) NULL, -- 'PO', 'BOM', 'Sale', 'Transfer', 'Adjustment'
        ReferenceID INT NULL, -- ID of PO, BOM, Sale, etc.
        ReferenceNumber NVARCHAR(50) NULL, -- PO Number, BOM Number, Invoice Number
        
        -- People Involved
        RequestedBy NVARCHAR(100) NULL, -- Who requested the movement
        RequestedDate DATETIME NULL,
        ApprovedBy NVARCHAR(100) NULL, -- Who approved
        ApprovedDate DATETIME NULL,
        ReceivedBy NVARCHAR(100) NULL, -- Who received/processed
        ReceivedDate DATETIME NULL,
        
        -- Additional Info
        Notes NVARCHAR(500) NULL,
        CostPerUnit DECIMAL(18,2) NULL,
        TotalCost DECIMAL(18,2) NULL,
        
        -- Audit
        CreatedBy NVARCHAR(100) NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        CONSTRAINT FK_StockMovements_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_StockMovements_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_StockMovements_Product ON StockMovements(ProductID);
    CREATE INDEX IX_StockMovements_Date ON StockMovements(MovementDate);
    CREATE INDEX IX_StockMovements_Type ON StockMovements(MovementType);
    CREATE INDEX IX_StockMovements_Reference ON StockMovements(ReferenceType, ReferenceID);
    
    PRINT '✅ StockMovements table created';
END
ELSE
    PRINT '⚠️ StockMovements table already exists';
GO

-- =============================================
-- 5. STOCK TRANSFER REQUESTS (For Workflow)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'StockTransferRequests')
BEGIN
    CREATE TABLE StockTransferRequests (
        TransferRequestID INT IDENTITY(1,1) PRIMARY KEY,
        RequestNumber NVARCHAR(50) NOT NULL UNIQUE,
        RequestDate DATETIME NOT NULL DEFAULT GETDATE(),
        
        -- Transfer Details
        ProductID INT NOT NULL,
        FromLocation NVARCHAR(50) NOT NULL, -- 'Stockroom', 'Manufacturing', 'Retail'
        ToLocation NVARCHAR(50) NOT NULL,
        FromBranchID INT NOT NULL,
        ToBranchID INT NOT NULL,
        
        -- Quantity
        RequestedQuantity DECIMAL(18,3) NOT NULL,
        ApprovedQuantity DECIMAL(18,3) NULL,
        TransferredQuantity DECIMAL(18,3) NULL,
        UnitOfMeasure NVARCHAR(20) NULL,
        
        -- Workflow
        Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Approved', 'Rejected', 'In Transit', 'Completed', 'Cancelled'
        Priority NVARCHAR(20) NOT NULL DEFAULT 'Normal', -- 'Low', 'Normal', 'High', 'Urgent'
        
        -- People
        RequestedBy NVARCHAR(100) NOT NULL,
        RequestedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ApprovedBy NVARCHAR(100) NULL,
        ApprovedDate DATETIME NULL,
        ProcessedBy NVARCHAR(100) NULL,
        ProcessedDate DATETIME NULL,
        ReceivedBy NVARCHAR(100) NULL,
        ReceivedDate DATETIME NULL,
        
        -- Additional
        Purpose NVARCHAR(200) NULL,
        Notes NVARCHAR(500) NULL,
        
        CONSTRAINT FK_TransferRequest_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_TransferRequest_FromBranch FOREIGN KEY (FromBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_TransferRequest_ToBranch FOREIGN KEY (ToBranchID) REFERENCES Branches(BranchID),
        CONSTRAINT CK_TransferRequest_Status CHECK (Status IN ('Pending', 'Approved', 'Rejected', 'In Transit', 'Completed', 'Cancelled')),
        CONSTRAINT CK_TransferRequest_Priority CHECK (Priority IN ('Low', 'Normal', 'High', 'Urgent'))
    );
    
    CREATE INDEX IX_TransferRequest_Status ON StockTransferRequests(Status);
    CREATE INDEX IX_TransferRequest_Date ON StockTransferRequests(RequestDate);
    
    PRINT '✅ StockTransferRequests table created';
END
ELSE
    PRINT '⚠️ StockTransferRequests table already exists';
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ STOCK TRACKING SYSTEM CREATED!';
PRINT '   - StockroomStock (Raw Materials)';
PRINT '   - ManufacturingStock (Work-in-Progress)';
PRINT '   - RetailStock (Finished Goods)';
PRINT '   - StockMovements (Full Audit Trail)';
PRINT '   - StockTransferRequests (Workflow)';
PRINT '═══════════════════════════════════════════════';
