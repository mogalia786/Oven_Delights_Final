-- =============================================
-- PHASE 1: Create Unified Purchase Order System
-- =============================================

-- Step 1: Create PurchaseOrders table
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PurchaseOrders')
BEGIN
    CREATE TABLE dbo.PurchaseOrders (
        POID INT IDENTITY(1,1) PRIMARY KEY,
        PONumber VARCHAR(50) NOT NULL UNIQUE,
        POType VARCHAR(50) NOT NULL, -- 'Manufacturer Internal', 'Stockroom External', 'IBT Internal'
        BranchID INT NOT NULL,
        RequestDate DATETIME NOT NULL DEFAULT GETDATE(),
        ExpectedDate DATETIME NULL,
        Status VARCHAR(20) NOT NULL DEFAULT 'Pending', -- 'Pending', 'Completed'
        RequestedBy INT NULL, -- UserID
        CompletedDate DATETIME NULL,
        CompletedBy INT NULL, -- UserID
        Notes NVARCHAR(500) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_PO_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_PO_Number ON dbo.PurchaseOrders(PONumber);
    CREATE INDEX IX_PO_Status ON dbo.PurchaseOrders(Status, BranchID);
    CREATE INDEX IX_PO_Type ON dbo.PurchaseOrders(POType);
    
    PRINT 'PurchaseOrders table created successfully';
END
ELSE
BEGIN
    PRINT 'PurchaseOrders table already exists';
END
GO

-- Step 2: Create POSequences table for sequential numbering
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'POSequences')
BEGIN
    CREATE TABLE dbo.POSequences (
        SequenceID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        POType VARCHAR(50) NOT NULL, -- 'i-m', 'e-st', 'i-ibt'
        LastNumber INT NOT NULL DEFAULT 0,
        CONSTRAINT UQ_POSequence UNIQUE (BranchID, POType)
    );
    
    PRINT 'POSequences table created successfully';
END
ELSE
BEGIN
    PRINT 'POSequences table already exists';
END
GO

-- Step 3: Add RecipeCreated and RecommendedSellingPrice to Products table
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'RecipeCreated')
BEGIN
    ALTER TABLE dbo.Products ADD RecipeCreated VARCHAR(3) NULL DEFAULT 'No';
    PRINT 'Added RecipeCreated column to Products table';
    
    -- Update existing manufactured products
    UPDATE dbo.Products 
    SET RecipeCreated = 'No' 
    WHERE ItemType = 'Manufactured' AND RecipeCreated IS NULL;
    
    PRINT 'Updated existing manufactured products with RecipeCreated = No';
END
ELSE
BEGIN
    PRINT 'RecipeCreated column already exists in Products table';
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'RecommendedSellingPrice')
BEGIN
    ALTER TABLE dbo.Products ADD RecommendedSellingPrice DECIMAL(18,2) NULL;
    PRINT 'Added RecommendedSellingPrice column to Products table';
END
ELSE
BEGIN
    PRINT 'RecommendedSellingPrice column already exists in Products table';
END
GO

-- Step 4: Add POID to InterBranchTransfers table
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('InterBranchTransfers') AND name = 'POID')
BEGIN
    ALTER TABLE dbo.InterBranchTransfers ADD POID INT NULL;
    ALTER TABLE dbo.InterBranchTransfers ADD CONSTRAINT FK_IBT_PO FOREIGN KEY (POID) REFERENCES PurchaseOrders(POID);
    PRINT 'Added POID column to InterBranchTransfers table';
END
ELSE
BEGIN
    PRINT 'POID column already exists in InterBranchTransfers table';
END
GO

-- Step 5: Add POID to SupplierInvoices table (if not already linked)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'POID')
BEGIN
    ALTER TABLE dbo.SupplierInvoices ADD POID INT NULL;
    ALTER TABLE dbo.SupplierInvoices ADD CONSTRAINT FK_SI_PO FOREIGN KEY (POID) REFERENCES PurchaseOrders(POID);
    PRINT 'Added POID column to SupplierInvoices table';
END
ELSE
BEGIN
    PRINT 'POID column already exists in SupplierInvoices table';
END
GO

-- Step 6: Check if ManufacturingOrders table exists and add POID
IF OBJECT_ID('dbo.ManufacturingOrders', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('ManufacturingOrders') AND name = 'POID')
    BEGIN
        ALTER TABLE dbo.ManufacturingOrders ADD POID INT NULL;
        ALTER TABLE dbo.ManufacturingOrders ADD CONSTRAINT FK_MO_PO FOREIGN KEY (POID) REFERENCES PurchaseOrders(POID);
        PRINT 'Added POID column to ManufacturingOrders table';
    END
    ELSE
    BEGIN
        PRINT 'POID column already exists in ManufacturingOrders table';
    END
END
ELSE
BEGIN
    PRINT 'ManufacturingOrders table does not exist - skipping';
END
GO

-- =============================================
-- PHASE 2: Create Stored Procedure for PO Generation
-- =============================================

IF OBJECT_ID('dbo.sp_GeneratePONumber', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GeneratePONumber;
GO

CREATE PROCEDURE dbo.sp_GeneratePONumber
    @BranchID INT,
    @POType VARCHAR(50), -- 'i-m', 'e-st', 'i-ibt'
    @RequestDate DATETIME = NULL,
    @ExpectedDate DATETIME = NULL,
    @RequestedBy INT = NULL,
    @Notes NVARCHAR(500) = NULL,
    @PONumber VARCHAR(50) OUTPUT,
    @POID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @RequestDate IS NULL SET @RequestDate = GETDATE();
    
    DECLARE @BranchPrefix VARCHAR(10);
    DECLARE @NextNumber INT;
    DECLARE @POTypeDescription VARCHAR(50);
    
    -- Get branch PREFIX (not BranchCode!)
    SELECT @BranchPrefix = Prefix FROM Branches WHERE BranchID = @BranchID;
    IF @BranchPrefix IS NULL
    BEGIN
        RAISERROR('Invalid BranchID or Branch has no Prefix', 16, 1);
        RETURN;
    END
    
    -- Determine PO type description
    SET @POTypeDescription = CASE @POType
        WHEN 'i-m' THEN 'Manufacturer Internal'
        WHEN 'e-st' THEN 'Stockroom External'
        WHEN 'i-ibt' THEN 'IBT Internal'
        ELSE 'Unknown'
    END;
    
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Get or create sequence
        IF NOT EXISTS (SELECT 1 FROM POSequences WHERE BranchID = @BranchID AND POType = @POType)
        BEGIN
            INSERT INTO POSequences (BranchID, POType, LastNumber) VALUES (@BranchID, @POType, 0);
        END
        
        -- Increment and get next number (with row lock to prevent duplicates)
        UPDATE POSequences WITH (ROWLOCK)
        SET LastNumber = LastNumber + 1,
            @NextNumber = LastNumber + 1
        WHERE BranchID = @BranchID AND POType = @POType;
        
        -- Generate PO number: PO-[Prefix]-[Type]-[00001]
        SET @PONumber = 'PO-' + @BranchPrefix + '-' + @POType + '-' + RIGHT('00000' + CAST(@NextNumber AS VARCHAR), 5);
        
        -- Create PO record
        INSERT INTO PurchaseOrders (PONumber, POType, BranchID, RequestDate, ExpectedDate, Status, RequestedBy, Notes)
        VALUES (@PONumber, @POTypeDescription, @BranchID, @RequestDate, @ExpectedDate, 'Pending', @RequestedBy, @Notes);
        
        SET @POID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        
        PRINT 'Generated PO: ' + @PONumber + ' (POID: ' + CAST(@POID AS VARCHAR) + ')';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Purchase Order System Setup Complete!';
PRINT '========================================';
PRINT '';
PRINT 'Tables Created:';
PRINT '  - PurchaseOrders';
PRINT '  - POSequences';
PRINT '';
PRINT 'Columns Added:';
PRINT '  - Products.RecipeCreated';
PRINT '  - Products.RecommendedSellingPrice';
PRINT '  - InterBranchTransfers.POID';
PRINT '  - SupplierInvoices.POID';
PRINT '';
PRINT 'Stored Procedure Created:';
PRINT '  - sp_GeneratePONumber';
PRINT '';
PRINT 'PO Number Format Examples:';
PRINT '  - Manufacturer to Stockroom: PO-PH-i-m-00001';
PRINT '  - Stockroom to Supplier:     PO-PH-e-st-00001';
PRINT '  - Inter-Branch Transfer:     PO-CH-i-ibt-00001';
PRINT '';
PRINT 'Next Steps:';
PRINT '  1. Test PO generation: EXEC sp_GeneratePONumber @BranchID=1, @POType=''i-ibt''';
PRINT '  2. Update application code to use new PO system';
PRINT '  3. Create PO Viewer form';
PRINT '';
