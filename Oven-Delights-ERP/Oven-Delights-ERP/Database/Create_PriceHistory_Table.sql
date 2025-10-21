-- Create Price History table to track all price changes

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'PriceHistory')
BEGIN
    CREATE TABLE dbo.PriceHistory (
        PriceHistoryID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        BranchID INT NOT NULL,
        Price DECIMAL(18,2) NOT NULL,
        Currency VARCHAR(10) NOT NULL DEFAULT 'ZAR',
        EffectiveFrom DATETIME NOT NULL DEFAULT GETDATE(),
        EffectiveTo DATETIME NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_PriceHistory_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_PriceHistory_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    PRINT 'PriceHistory table created successfully!';
    
    -- Create index for fast lookups
    CREATE INDEX IX_PriceHistory_Product_Branch_Active 
    ON dbo.PriceHistory(ProductID, BranchID, IsActive, EffectiveFrom DESC);
    
    PRINT 'Index created on PriceHistory table.';
END
ELSE
BEGIN
    PRINT 'PriceHistory table already exists.';
END

GO

-- Create view for current active prices (what POS will use)
IF OBJECT_ID('dbo.vw_CurrentPrices', 'V') IS NOT NULL
    DROP VIEW dbo.vw_CurrentPrices;
GO

CREATE VIEW dbo.vw_CurrentPrices
AS
SELECT 
    ph.ProductID,
    p.ProductCode,
    p.ProductName,
    ph.BranchID,
    b.BranchName,
    ph.Price,
    ph.Currency,
    ph.EffectiveFrom,
    ph.CreatedDate
FROM dbo.PriceHistory ph
INNER JOIN dbo.Products p ON p.ProductID = ph.ProductID
INNER JOIN dbo.Branches b ON b.BranchID = ph.BranchID
WHERE ph.IsActive = 1
  AND ph.EffectiveTo IS NULL;

GO

PRINT 'vw_CurrentPrices view created successfully!';
PRINT '';
PRINT 'USAGE:';
PRINT '1. When setting a new price, set EffectiveTo = GETDATE() on old price';
PRINT '2. Insert new price with IsActive = 1, EffectiveTo = NULL';
PRINT '3. POS queries vw_CurrentPrices to get latest active price';
PRINT '4. Price history is preserved for reporting and auditing';
