-- =============================================
-- Product Pricing Table (Branch-Specific)
-- Each branch can set their own selling prices
-- =============================================

IF OBJECT_ID('dbo.ProductPricing','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductPricing (
        PricingID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        BranchID INT NOT NULL,
        SellingPrice DECIMAL(18,4) NOT NULL,
        PromotionPrice DECIMAL(18,4) NULL,
        PromotionStartDate DATETIME NULL,
        PromotionEndDate DATETIME NULL,
        IsActive BIT NOT NULL DEFAULT(1),
        EffectiveDate DATETIME NOT NULL DEFAULT(GETDATE()),
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        ModifiedBy INT NULL,
        ModifiedDate DATETIME NULL,
        CONSTRAINT FK_ProductPricing_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_ProductPricing_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID),
        CONSTRAINT UQ_ProductPricing_Product_Branch UNIQUE (ProductID, BranchID)
    );
    
    CREATE INDEX IX_ProductPricing_Product ON dbo.ProductPricing(ProductID);
    CREATE INDEX IX_ProductPricing_Branch ON dbo.ProductPricing(BranchID);
    CREATE INDEX IX_ProductPricing_Active ON dbo.ProductPricing(IsActive);
    
    PRINT 'Created table: ProductPricing';
END
ELSE
BEGIN
    PRINT 'Table ProductPricing already exists';
END
GO

-- =============================================
-- Product Pricing History (Audit Trail)
-- =============================================

IF OBJECT_ID('dbo.ProductPricingHistory','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductPricingHistory (
        HistoryID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        BranchID INT NOT NULL,
        OldPrice DECIMAL(18,4) NULL,
        NewPrice DECIMAL(18,4) NOT NULL,
        ChangeReason NVARCHAR(200) NULL,
        ChangedBy INT NULL,
        ChangedDate DATETIME NOT NULL DEFAULT(GETDATE()),
        CONSTRAINT FK_ProductPricingHistory_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
        CONSTRAINT FK_ProductPricingHistory_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    );
    
    CREATE INDEX IX_ProductPricingHistory_Product ON dbo.ProductPricingHistory(ProductID);
    CREATE INDEX IX_ProductPricingHistory_Branch ON dbo.ProductPricingHistory(BranchID);
    CREATE INDEX IX_ProductPricingHistory_Date ON dbo.ProductPricingHistory(ChangedDate);
    
    PRINT 'Created table: ProductPricingHistory';
END
ELSE
BEGIN
    PRINT 'Table ProductPricingHistory already exists';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'Product Pricing tables created';
PRINT '========================================';
PRINT '';
PRINT 'FEATURES:';
PRINT '- Branch-specific selling prices';
PRINT '- Promotion pricing with date ranges';
PRINT '- Price change history/audit trail';
PRINT '- Effective dating for future prices';
PRINT '';
PRINT 'USAGE:';
PRINT '- Each branch sets own selling price per product';
PRINT '- POS queries ProductPricing for current branch';
PRINT '- Promotions automatically activate/deactivate by date';
PRINT '- All price changes logged in history table';
GO
