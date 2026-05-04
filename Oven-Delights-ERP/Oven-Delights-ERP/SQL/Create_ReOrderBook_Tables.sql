-- =============================================
-- RE-ORDER BOOK SYSTEM TABLES
-- Baker daily production orders with ingredient tracking
-- =============================================

-- =============================================
-- 1. REORDER BOOK HEADER
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReOrderBooks') AND type in (N'U'))
BEGIN
    CREATE TABLE ReOrderBooks (
        ReOrderBookID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderNumber NVARCHAR(50) NOT NULL UNIQUE, -- BranchCode-RO-i-BakerName format
        BranchID INT NOT NULL,
        ManufacturerUserID INT NOT NULL, -- Baker/Manufacturer
        ManufacturerName NVARCHAR(100) NOT NULL,
        OrderDate DATE NOT NULL,
        RequiredDate DATE NOT NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Draft', -- Draft, Posted, InProgress, Completed, Cancelled
        Priority NVARCHAR(20) NOT NULL DEFAULT 'Normal', -- Normal, Urgent
        
        -- Totals
        TotalProducts INT NOT NULL DEFAULT 0,
        TotalQuantity DECIMAL(18,2) NOT NULL DEFAULT 0,
        EstimatedCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        
        -- Workflow
        CreatedBy NVARCHAR(100) NOT NULL, -- Admin/Retail Manager
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        PostedBy NVARCHAR(100) NULL,
        PostedDate DATETIME NULL,
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
    CREATE INDEX IX_ReOrderBooks_Number ON ReOrderBooks(ReOrderNumber);
    
    PRINT '✅ ReOrderBooks table created';
END
ELSE
    PRINT '⚠️ ReOrderBooks table already exists';
GO

-- =============================================
-- 2. REORDER BOOK LINES (Products to Bake)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReOrderBookLines') AND type in (N'U'))
BEGIN
    CREATE TABLE ReOrderBookLines (
        ReOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(200) NOT NULL,
        SKU NVARCHAR(50) NULL,
        
        -- Quantity
        QuantityOrdered DECIMAL(18,2) NOT NULL,
        QuantityCompleted DECIMAL(18,2) NOT NULL DEFAULT 0,
        UnitOfMeasure NVARCHAR(20) NOT NULL DEFAULT 'Each',
        
        -- BOM Reference
        BOMHeaderID INT NULL, -- Link to BOM for ingredient calculation
        
        -- Costing
        EstimatedCostPerUnit DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalEstimatedCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        ActualCostPerUnit DECIMAL(18,2) NULL,
        TotalActualCost DECIMAL(18,2) NULL,
        
        -- Status
        LineStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending', -- Pending, InProgress, Completed
        CompletedDate DATETIME NULL,
        
        -- Additional
        Notes NVARCHAR(500) NULL,
        LineNumber INT NOT NULL,
        
        CONSTRAINT FK_ReOrderBookLines_Header FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID) ON DELETE CASCADE,
        CONSTRAINT FK_ReOrderBookLines_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_ReOrderBookLines_BOM FOREIGN KEY (BOMHeaderID) REFERENCES BOMHeader(BOMHeaderID)
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
-- 3. REORDER BOOK INGREDIENTS (Auto-calculated from BOM)
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReOrderBookIngredients') AND type in (N'U'))
BEGIN
    CREATE TABLE ReOrderBookIngredients (
        IngredientID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        ReOrderLineID INT NOT NULL,
        
        -- Ingredient Details
        MaterialID INT NOT NULL, -- Raw material/ingredient ProductID
        MaterialName NVARCHAR(200) NOT NULL,
        MaterialSKU NVARCHAR(50) NULL,
        
        -- Quantity (calculated from BOM * product quantity)
        QuantityRequired DECIMAL(18,2) NOT NULL,
        UnitOfMeasure NVARCHAR(20) NOT NULL,
        
        -- Stock Availability
        QuantityAvailable DECIMAL(18,2) NOT NULL DEFAULT 0,
        QuantityShortfall DECIMAL(18,2) NOT NULL DEFAULT 0,
        IsAvailable BIT NOT NULL DEFAULT 0,
        
        -- Costing
        UnitCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalCost DECIMAL(18,2) NOT NULL DEFAULT 0,
        
        -- Fulfillment
        QuantityIssued DECIMAL(18,2) NOT NULL DEFAULT 0,
        IssuedDate DATETIME NULL,
        IssuedBy NVARCHAR(100) NULL,
        
        CONSTRAINT FK_ReOrderBookIngredients_Header FOREIGN KEY (ReOrderBookID) REFERENCES ReOrderBooks(ReOrderBookID) ON DELETE CASCADE,
        CONSTRAINT FK_ReOrderBookIngredients_Line FOREIGN KEY (ReOrderLineID) REFERENCES ReOrderBookLines(ReOrderLineID),
        CONSTRAINT FK_ReOrderBookIngredients_Material FOREIGN KEY (MaterialID) REFERENCES Products(ProductID)
    );
    
    CREATE INDEX IX_ReOrderBookIngredients_Header ON ReOrderBookIngredients(ReOrderBookID);
    CREATE INDEX IX_ReOrderBookIngredients_Line ON ReOrderBookIngredients(ReOrderLineID);
    CREATE INDEX IX_ReOrderBookIngredients_Material ON ReOrderBookIngredients(MaterialID);
    
    PRINT '✅ ReOrderBookIngredients table created';
END
ELSE
    PRINT '⚠️ ReOrderBookIngredients table already exists';
GO

-- =============================================
-- 4. REORDER BOOK AUDIT LOG
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ReOrderBookAudit') AND type in (N'U'))
BEGIN
    CREATE TABLE ReOrderBookAudit (
        AuditID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        ActionType NVARCHAR(50) NOT NULL, -- Created, Modified, Posted, Started, Completed, Cancelled, Printed
        ActionBy NVARCHAR(100) NOT NULL,
        ActionDate DATETIME NOT NULL DEFAULT GETDATE(),
        OldStatus NVARCHAR(20) NULL,
        NewStatus NVARCHAR(20) NULL,
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
PRINT '✅ RE-ORDER BOOK TABLES CREATED!';
PRINT '   - ReOrderBooks (Header with baker assignment)';
PRINT '   - ReOrderBookLines (Products to bake)';
PRINT '   - ReOrderBookIngredients (Auto-calculated from BOM)';
PRINT '   - ReOrderBookAudit (Full audit trail)';
PRINT '';
PRINT '📋 PO Format: BranchCode-RO-i-BakerName';
PRINT '📊 Status Flow: Draft → Posted → InProgress → Completed';
PRINT '🎯 WOW FACTOR: Ready for implementation!';
PRINT '═══════════════════════════════════════════════';
