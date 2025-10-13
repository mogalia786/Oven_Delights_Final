-- =============================================
-- POS DEMO TABLES - STEP 1: CREATE STRUCTURE
-- =============================================
-- Purpose: Create demo tables for POS development
-- Safe: These tables are completely separate from production
-- Go-Live: Change config flag from Demo to Production tables
-- =============================================

USE [OvenDelightsERP];
GO

PRINT '========================================';
PRINT 'Creating Demo Tables for POS System';
PRINT 'Bismillah - Starting with Allah''s name';
PRINT '========================================';
GO

-- =============================================
-- 1. Demo_Retail_Product
-- =============================================
IF OBJECT_ID('dbo.Demo_Retail_Product', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Retail_Product;
GO

CREATE TABLE dbo.Demo_Retail_Product(
    ProductID       INT IDENTITY(1,1) PRIMARY KEY,
    SKU             VARCHAR(64) NOT NULL UNIQUE,
    Name            VARCHAR(200) NOT NULL,
    Category        VARCHAR(100) NULL,
    Description     VARCHAR(1000) NULL,
    IsActive        BIT NOT NULL DEFAULT(1),
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

PRINT '✓ Created Demo_Retail_Product';
GO

-- =============================================
-- 2. Demo_Retail_Variant
-- =============================================
IF OBJECT_ID('dbo.Demo_Retail_Variant', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Retail_Variant;
GO

CREATE TABLE dbo.Demo_Retail_Variant(
    VariantID       INT IDENTITY(1,1) PRIMARY KEY,
    ProductID       INT NOT NULL,
    Barcode         VARCHAR(64) NULL UNIQUE,
    AttributesJson  NVARCHAR(MAX) NULL,
    IsActive        BIT NOT NULL DEFAULT(1),
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Demo_Retail_Variant_Product 
        FOREIGN KEY(ProductID) REFERENCES dbo.Demo_Retail_Product(ProductID)
);
GO

CREATE INDEX IX_Demo_Retail_Variant_Product ON dbo.Demo_Retail_Variant(ProductID);
GO

PRINT '✓ Created Demo_Retail_Variant';
GO

-- =============================================
-- 3. Demo_Retail_Price
-- =============================================
IF OBJECT_ID('dbo.Demo_Retail_Price', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Retail_Price;
GO

CREATE TABLE dbo.Demo_Retail_Price(
    PriceID         INT IDENTITY(1,1) PRIMARY KEY,
    ProductID       INT NOT NULL,
    BranchID        INT NULL,
    SellingPrice    DECIMAL(18,2) NOT NULL,
    CostPrice       DECIMAL(18,2) NULL,
    Currency        VARCHAR(8) NOT NULL DEFAULT 'ZAR',
    EffectiveFrom   DATE NOT NULL,
    EffectiveTo     DATE NULL,
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Demo_Retail_Price_Product 
        FOREIGN KEY(ProductID) REFERENCES dbo.Demo_Retail_Product(ProductID)
);
GO

CREATE INDEX IX_Demo_Retail_Price_Product ON dbo.Demo_Retail_Price(ProductID, BranchID, EffectiveFrom);
GO

PRINT '✓ Created Demo_Retail_Price';
GO

-- =============================================
-- 4. Demo_Retail_Stock
-- =============================================
IF OBJECT_ID('dbo.Demo_Retail_Stock', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Retail_Stock;
GO

CREATE TABLE dbo.Demo_Retail_Stock(
    StockID         INT IDENTITY(1,1) PRIMARY KEY,
    VariantID       INT NOT NULL,
    BranchID        INT NULL,
    QtyOnHand       DECIMAL(18,3) NOT NULL DEFAULT(0),
    ReorderPoint    DECIMAL(18,3) NOT NULL DEFAULT(0),
    Location        VARCHAR(64) NULL,
    LocationKey     AS ISNULL(Location,'') PERSISTED,
    BranchKey       AS ISNULL(BranchID,-1) PERSISTED,
    UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Demo_Retail_Stock_Variant 
        FOREIGN KEY(VariantID) REFERENCES dbo.Demo_Retail_Variant(VariantID),
    CONSTRAINT UQ_Demo_Retail_Stock UNIQUE(VariantID, BranchKey, LocationKey)
);
GO

CREATE INDEX IX_Demo_Retail_Stock_Branch ON dbo.Demo_Retail_Stock(BranchID, VariantID);
GO

PRINT '✓ Created Demo_Retail_Stock';
GO

-- =============================================
-- 5. Demo_Retail_StockMovements
-- =============================================
IF OBJECT_ID('dbo.Demo_Retail_StockMovements', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Retail_StockMovements;
GO

CREATE TABLE dbo.Demo_Retail_StockMovements(
    MovementID      INT IDENTITY(1,1) PRIMARY KEY,
    VariantID       INT NOT NULL,
    BranchID        INT NULL,
    QtyDelta        DECIMAL(18,3) NOT NULL,
    Reason          VARCHAR(50) NOT NULL, -- Sale, Return, Adjustment, Production
    Ref1            VARCHAR(100) NULL,
    Ref2            VARCHAR(100) NULL,
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CreatedBy       INT NULL,
    CONSTRAINT FK_Demo_Retail_Move_Variant 
        FOREIGN KEY(VariantID) REFERENCES dbo.Demo_Retail_Variant(VariantID)
);
GO

CREATE INDEX IX_Demo_Retail_StockMovements_Variant ON dbo.Demo_Retail_StockMovements(VariantID, BranchID, CreatedAt);
GO

PRINT '✓ Created Demo_Retail_StockMovements';
GO

-- =============================================
-- 6. Demo_Retail_ProductImage
-- =============================================
IF OBJECT_ID('dbo.Demo_Retail_ProductImage', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Retail_ProductImage;
GO

CREATE TABLE dbo.Demo_Retail_ProductImage(
    ImageID         INT IDENTITY(1,1) PRIMARY KEY,
    ProductID       INT NOT NULL,
    ImageUrl        NVARCHAR(512) NOT NULL,
    ThumbnailUrl    NVARCHAR(512) NULL,
    IsPrimary       BIT NOT NULL DEFAULT(0),
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Demo_Retail_Image_Product 
        FOREIGN KEY(ProductID) REFERENCES dbo.Demo_Retail_Product(ProductID)
);
GO

CREATE INDEX IX_Demo_Retail_ProductImage_Product ON dbo.Demo_Retail_ProductImage(ProductID, IsPrimary);
GO

PRINT '✓ Created Demo_Retail_ProductImage';
GO

-- =============================================
-- 7. Demo_Sales (Transaction Header)
-- =============================================
IF OBJECT_ID('dbo.Demo_Sales', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Sales;
GO

CREATE TABLE dbo.Demo_Sales(
    SaleID          INT IDENTITY(1,1) PRIMARY KEY,
    SaleNumber      VARCHAR(50) NOT NULL UNIQUE,
    BranchID        INT NULL,
    SaleDate        DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CustomerID      INT NULL,
    CustomerName    VARCHAR(200) NULL,
    Subtotal        DECIMAL(18,2) NOT NULL DEFAULT(0),
    TaxAmount       DECIMAL(18,2) NOT NULL DEFAULT(0),
    DiscountAmount  DECIMAL(18,2) NOT NULL DEFAULT(0),
    TotalAmount     DECIMAL(18,2) NOT NULL DEFAULT(0),
    TenderType      VARCHAR(50) NULL, -- Cash, Card, EFT
    Status          VARCHAR(20) NOT NULL DEFAULT('Completed'), -- Completed, Voided
    CashierID       INT NULL,
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

CREATE INDEX IX_Demo_Sales_Branch_Date ON dbo.Demo_Sales(BranchID, SaleDate);
CREATE INDEX IX_Demo_Sales_Number ON dbo.Demo_Sales(SaleNumber);
GO

PRINT '✓ Created Demo_Sales';
GO

-- =============================================
-- 8. Demo_SalesDetails (Transaction Lines)
-- =============================================
IF OBJECT_ID('dbo.Demo_SalesDetails', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_SalesDetails;
GO

CREATE TABLE dbo.Demo_SalesDetails(
    SaleDetailID    INT IDENTITY(1,1) PRIMARY KEY,
    SaleID          INT NOT NULL,
    VariantID       INT NOT NULL,
    ProductName     VARCHAR(200) NOT NULL,
    SKU             VARCHAR(64) NULL,
    Quantity        DECIMAL(18,3) NOT NULL,
    UnitPrice       DECIMAL(18,2) NOT NULL,
    LineTotal       DECIMAL(18,2) NOT NULL,
    TaxAmount       DECIMAL(18,2) NOT NULL DEFAULT(0),
    DiscountAmount  DECIMAL(18,2) NOT NULL DEFAULT(0),
    CONSTRAINT FK_Demo_SalesDetails_Sale 
        FOREIGN KEY(SaleID) REFERENCES dbo.Demo_Sales(SaleID),
    CONSTRAINT FK_Demo_SalesDetails_Variant 
        FOREIGN KEY(VariantID) REFERENCES dbo.Demo_Retail_Variant(VariantID)
);
GO

CREATE INDEX IX_Demo_SalesDetails_Sale ON dbo.Demo_SalesDetails(SaleID);
GO

PRINT '✓ Created Demo_SalesDetails';
GO

-- =============================================
-- 9. Demo_Payments
-- =============================================
IF OBJECT_ID('dbo.Demo_Payments', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Payments;
GO

CREATE TABLE dbo.Demo_Payments(
    PaymentID       INT IDENTITY(1,1) PRIMARY KEY,
    SaleID          INT NOT NULL,
    PaymentType     VARCHAR(50) NOT NULL, -- Cash, Card, EFT, Split
    Amount          DECIMAL(18,2) NOT NULL,
    Reference       VARCHAR(100) NULL,
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Demo_Payments_Sale 
        FOREIGN KEY(SaleID) REFERENCES dbo.Demo_Sales(SaleID)
);
GO

CREATE INDEX IX_Demo_Payments_Sale ON dbo.Demo_Payments(SaleID);
GO

PRINT '✓ Created Demo_Payments';
GO

-- =============================================
-- 10. Demo_Returns (Return Header)
-- =============================================
IF OBJECT_ID('dbo.Demo_Returns', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_Returns;
GO

CREATE TABLE dbo.Demo_Returns(
    ReturnID        INT IDENTITY(1,1) PRIMARY KEY,
    ReturnNumber    VARCHAR(50) NOT NULL UNIQUE,
    OriginalSaleID  INT NULL,
    BranchID        INT NULL,
    ReturnDate      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CustomerID      INT NULL,
    TotalAmount     DECIMAL(18,2) NOT NULL DEFAULT(0),
    Reason          VARCHAR(500) NULL,
    Status          VARCHAR(20) NOT NULL DEFAULT('Completed'),
    ProcessedBy     INT NULL,
    CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT FK_Demo_Returns_Sale 
        FOREIGN KEY(OriginalSaleID) REFERENCES dbo.Demo_Sales(SaleID)
);
GO

CREATE INDEX IX_Demo_Returns_Branch_Date ON dbo.Demo_Returns(BranchID, ReturnDate);
GO

PRINT '✓ Created Demo_Returns';
GO

-- =============================================
-- 11. Demo_ReturnDetails (Return Lines)
-- =============================================
IF OBJECT_ID('dbo.Demo_ReturnDetails', 'U') IS NOT NULL
    DROP TABLE dbo.Demo_ReturnDetails;
GO

CREATE TABLE dbo.Demo_ReturnDetails(
    ReturnDetailID  INT IDENTITY(1,1) PRIMARY KEY,
    ReturnID        INT NOT NULL,
    VariantID       INT NOT NULL,
    ProductName     VARCHAR(200) NOT NULL,
    Quantity        DECIMAL(18,3) NOT NULL,
    UnitPrice       DECIMAL(18,2) NOT NULL,
    LineTotal       DECIMAL(18,2) NOT NULL,
    CONSTRAINT FK_Demo_ReturnDetails_Return 
        FOREIGN KEY(ReturnID) REFERENCES dbo.Demo_Returns(ReturnID),
    CONSTRAINT FK_Demo_ReturnDetails_Variant 
        FOREIGN KEY(VariantID) REFERENCES dbo.Demo_Retail_Variant(VariantID)
);
GO

CREATE INDEX IX_Demo_ReturnDetails_Return ON dbo.Demo_ReturnDetails(ReturnID);
GO

PRINT '✓ Created Demo_ReturnDetails';
GO

-- =============================================
-- Add Foreign Keys to Branches (if exists)
-- =============================================
IF OBJECT_ID('dbo.Branches', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Stock_Branch')
        ALTER TABLE dbo.Demo_Retail_Stock 
        ADD CONSTRAINT FK_Demo_Retail_Stock_Branch 
        FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Price_Branch')
        ALTER TABLE dbo.Demo_Retail_Price 
        ADD CONSTRAINT FK_Demo_Retail_Price_Branch 
        FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Sales_Branch')
        ALTER TABLE dbo.Demo_Sales 
        ADD CONSTRAINT FK_Demo_Sales_Branch 
        FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Returns_Branch')
        ALTER TABLE dbo.Demo_Returns 
        ADD CONSTRAINT FK_Demo_Returns_Branch 
        FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    
    PRINT '✓ Added Foreign Keys to Branches';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'SUCCESS! All Demo Tables Created';
PRINT '========================================';
PRINT 'Next Step: Run 02_Populate_Demo_Data.sql';
PRINT '========================================';
GO
