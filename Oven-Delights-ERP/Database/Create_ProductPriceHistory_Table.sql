-- =============================================
-- Product Price History Table
-- Tracks cost price changes from invoice capture
-- Used for latest price lookup in Purchase Orders
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ProductPriceHistory')
BEGIN
    CREATE TABLE ProductPriceHistory (
        PriceHistoryID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        SKU NVARCHAR(50),
        ProductName NVARCHAR(255) NOT NULL,
        SupplierID INT,
        SupplierName NVARCHAR(255),
        InvoiceNumber NVARCHAR(50),
        InvoiceDate DATE NOT NULL,
        CostPrice DECIMAL(18,2) NOT NULL,
        Quantity DECIMAL(18,2),
        UnitOfMeasure NVARCHAR(50),
        BranchID INT NOT NULL,
        CapturedBy NVARCHAR(100),
        CapturedDate DATETIME DEFAULT GETDATE(),
        Notes NVARCHAR(500),
        CONSTRAINT FK_ProductPriceHistory_Product FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID),
        CONSTRAINT FK_ProductPriceHistory_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    )
    
    -- Index for fast lookup of latest price
    CREATE INDEX IX_ProductPriceHistory_ProductID_Date ON ProductPriceHistory(ProductID, InvoiceDate DESC)
    CREATE INDEX IX_ProductPriceHistory_SKU_Date ON ProductPriceHistory(SKU, InvoiceDate DESC)
    CREATE INDEX IX_ProductPriceHistory_Branch ON ProductPriceHistory(BranchID)
    
    PRINT 'ProductPriceHistory table created successfully'
END
ELSE
BEGIN
    PRINT 'ProductPriceHistory table already exists'
END
GO

-- =============================================
-- View: Latest Product Prices
-- Shows most recent cost price per product
-- =============================================

IF EXISTS (SELECT * FROM sys.views WHERE name = 'vw_LatestProductPrices')
    DROP VIEW vw_LatestProductPrices
GO

CREATE VIEW vw_LatestProductPrices
AS
SELECT 
    p.ProductID,
    p.SKU,
    p.Name AS ProductName,
    p.BranchID,
    b.BranchName,
    ph.CostPrice AS LatestCostPrice,
    ph.InvoiceDate AS LastPurchaseDate,
    ph.SupplierName AS LastSupplier,
    ph.InvoiceNumber AS LastInvoiceNumber,
    ph.CapturedDate
FROM (
    -- Get latest price history record per product per branch
    SELECT 
        ProductID,
        BranchID,
        MAX(PriceHistoryID) AS LatestPriceHistoryID
    FROM ProductPriceHistory
    GROUP BY ProductID, BranchID
) latest
INNER JOIN ProductPriceHistory ph ON ph.PriceHistoryID = latest.LatestPriceHistoryID
INNER JOIN Demo_Retail_Product p ON p.ProductID = ph.ProductID AND p.BranchID = ph.BranchID
INNER JOIN Branches b ON b.BranchID = p.BranchID
GO

PRINT 'vw_LatestProductPrices view created successfully'
GO

-- =============================================
-- Stored Procedure: Get Latest Product Price
-- Returns most recent cost price for a product
-- =============================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_GetLatestProductPrice')
    DROP PROCEDURE sp_GetLatestProductPrice
GO

CREATE PROCEDURE sp_GetLatestProductPrice
    @ProductID INT,
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON
    
    SELECT TOP 1
        CostPrice,
        InvoiceDate,
        SupplierName,
        InvoiceNumber
    FROM ProductPriceHistory
    WHERE ProductID = @ProductID
      AND BranchID = @BranchID
    ORDER BY InvoiceDate DESC, PriceHistoryID DESC
END
GO

PRINT 'sp_GetLatestProductPrice procedure created successfully'
GO

-- =============================================
-- Stored Procedure: Record Price from Invoice
-- Called when capturing supplier invoices
-- =============================================

IF EXISTS (SELECT * FROM sys.procedures WHERE name = 'sp_RecordProductPriceFromInvoice')
    DROP PROCEDURE sp_RecordProductPriceFromInvoice
GO

CREATE PROCEDURE sp_RecordProductPriceFromInvoice
    @ProductID INT,
    @SKU NVARCHAR(50),
    @ProductName NVARCHAR(255),
    @SupplierID INT,
    @SupplierName NVARCHAR(255),
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @CostPrice DECIMAL(18,2),
    @Quantity DECIMAL(18,2),
    @UnitOfMeasure NVARCHAR(50),
    @BranchID INT,
    @CapturedBy NVARCHAR(100),
    @Notes NVARCHAR(500) = NULL
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Insert price history record
        INSERT INTO ProductPriceHistory (
            ProductID, SKU, ProductName, SupplierID, SupplierName,
            InvoiceNumber, InvoiceDate, CostPrice, Quantity, UnitOfMeasure,
            BranchID, CapturedBy, Notes
        )
        VALUES (
            @ProductID, @SKU, @ProductName, @SupplierID, @SupplierName,
            @InvoiceNumber, @InvoiceDate, @CostPrice, @Quantity, @UnitOfMeasure,
            @BranchID, @CapturedBy, @Notes
        )
        
        -- Update Demo_Retail_Product stock
        UPDATE Demo_Retail_Product
        SET CurrentStock = ISNULL(CurrentStock, 0) + @Quantity
        WHERE ProductID = @ProductID
          AND BranchID = @BranchID
        
        -- Update Demo_Retail_Price with latest cost price
        UPDATE Demo_Retail_Price
        SET CostPrice = @CostPrice
        WHERE ProductID = @ProductID
          AND BranchID = @BranchID
        
        COMMIT TRANSACTION
        
        SELECT 'SUCCESS' AS Result, 'Price history recorded and stock updated' AS Message
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SELECT 'ERROR' AS Result, ERROR_MESSAGE() AS Message
    END CATCH
END
GO

PRINT 'sp_RecordProductPriceFromInvoice procedure created successfully'
GO
