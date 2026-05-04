-- =============================================
-- SIMPLIFIED RE-ORDER BOOK SYSTEM
-- Production instruction list for bakers
-- =============================================

-- =============================================
-- 1. REORDER BOOK HEADER (Production Instructions)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReOrderBooks') AND type in (N'U'))
BEGIN
    CREATE TABLE ReOrderBooks (
        ReOrderBookID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderNumber NVARCHAR(50) NOT NULL UNIQUE, -- BranchCode-RO-i-BakerName
        BranchID INT NOT NULL,
        ManufacturerUserID INT NOT NULL, -- Baker
        ManufacturerName NVARCHAR(100) NOT NULL,
        OrderDate DATE NOT NULL,
        RequiredDate DATE NOT NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Draft', -- Draft, Posted, InProgress, Completed
        Priority NVARCHAR(20) NOT NULL DEFAULT 'Normal', -- Normal, Urgent
        
        -- Totals
        TotalProducts INT NOT NULL DEFAULT 0,
        TotalQuantity DECIMAL(18,2) NOT NULL DEFAULT 0,
        
        -- Workflow
        CreatedBy NVARCHAR(100) NOT NULL, -- Admin/Retail Manager
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        PostedBy NVARCHAR(100) NULL,
        PostedDate DATETIME NULL,
        StartedBy NVARCHAR(100) NULL,
        StartedDate DATETIME NULL,
        CompletedBy NVARCHAR(100) NULL,
        CompletedDate DATETIME NULL,
        
        -- Additional
        Notes NVARCHAR(MAX) NULL,
        IsUrgent BIT NOT NULL DEFAULT 0,
        IsPrinted BIT NOT NULL DEFAULT 0,
        LastPrintedDate DATETIME NULL,
        
        CONSTRAINT FK_ReOrderBooks_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT FK_ReOrderBooks_Manufacturer FOREIGN KEY (ManufacturerUserID) REFERENCES Users(UserID),
        CONSTRAINT CHK_ReOrderBooks_Status CHECK (Status IN ('Draft', 'Posted', 'InProgress', 'Completed', 'Cancelled'))
    );
    
    CREATE INDEX IX_ReOrderBooks_Manufacturer ON ReOrderBooks(ManufacturerUserID, OrderDate);
    CREATE INDEX IX_ReOrderBooks_Branch ON ReOrderBooks(BranchID, OrderDate);
    CREATE INDEX IX_ReOrderBooks_Status ON ReOrderBooks(Status, OrderDate);
    
    PRINT '✅ ReOrderBooks table created';
END
ELSE
    PRINT '⚠️ ReOrderBooks table already exists';
GO

-- =============================================
-- 2. REORDER BOOK LINES (Products to Make)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReOrderBookLines') AND type in (N'U'))
BEGIN
    CREATE TABLE ReOrderBookLines (
        ReOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(200) NOT NULL,
        SKU NVARCHAR(50) NULL,
        Barcode NVARCHAR(50) NULL,
        ItemCode NVARCHAR(50) NULL,
        
        -- Quantity
        QuantityOrdered DECIMAL(18,2) NOT NULL,
        QuantityCompleted DECIMAL(18,2) NOT NULL DEFAULT 0,
        UnitOfMeasure NVARCHAR(20) NOT NULL DEFAULT 'Each',
        
        -- BOM Reference (Baker will create BOM from this)
        BOMHeaderID INT NULL,
        BOMCreated BIT NOT NULL DEFAULT 0,
        BOMCreatedDate DATETIME NULL,
        
        -- Completion Tracking
        LineStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, InProgress, Completed
        StartedDate DATETIME NULL,
        CompletedDate DATETIME NULL,
        CompletedBy NVARCHAR(100) NULL,
        
        -- Retail Stock Update
        RetailStockUpdated BIT NOT NULL DEFAULT 0,
        RetailStockUpdateDate DATETIME NULL,
        
        -- Additional
        Notes NVARCHAR(500) NULL,
        LineNumber INT NOT NULL,
        
        CONSTRAINT FK_ReOrderBookLines_Header FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID) ON DELETE CASCADE,
        CONSTRAINT FK_ReOrderBookLines_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
    );
    
    CREATE INDEX IX_ReOrderBookLines_Header ON ReOrderBookLines(ReOrderBookID);
    CREATE INDEX IX_ReOrderBookLines_Product ON ReOrderBookLines(ProductID);
    CREATE INDEX IX_ReOrderBookLines_Status ON ReOrderBookLines(LineStatus);
    
    PRINT '✅ ReOrderBookLines table created';
END
ELSE
    PRINT '⚠️ ReOrderBookLines table already exists';
GO

-- =============================================
-- 3. REORDER BOOK AUDIT LOG
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReOrderBookAudit') AND type in (N'U'))
BEGIN
    CREATE TABLE ReOrderBookAudit (
        AuditID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        ActionType NVARCHAR(50) NOT NULL, -- Created, Modified, Posted, Started, ProductCompleted, Completed, Cancelled, Printed
        ActionBy NVARCHAR(100) NOT NULL,
        ActionDate DATETIME NOT NULL DEFAULT GETDATE(),
        OldStatus NVARCHAR(20) NULL,
        NewStatus NVARCHAR(20) NULL,
        ProductID INT NULL,
        Quantity DECIMAL(18,2) NULL,
        Notes NVARCHAR(500) NULL,
        
        CONSTRAINT FK_ReOrderBookAudit_Header FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID) ON DELETE CASCADE
    );
    
    CREATE INDEX IX_ReOrderBookAudit_Header ON ReOrderBookAudit(ReOrderBookID, ActionDate);
    
    PRINT '✅ ReOrderBookAudit table created';
END
ELSE
    PRINT '⚠️ ReOrderBookAudit table already exists';
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ SIMPLIFIED RE-ORDER BOOK TABLES CREATED!';
PRINT '   - ReOrderBooks (Production instruction header)';
PRINT '   - ReOrderBookLines (Products to bake with completion tracking)';
PRINT '   - ReOrderBookAudit (Full audit trail)';
PRINT '';
PRINT '📋 Workflow: Admin creates → Baker receives → Baker creates BOM';
PRINT '🎯 Baker completes → System updates Retail stock with timestamp';
PRINT '═══════════════════════════════════════════════';
