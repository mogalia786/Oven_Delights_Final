SET NOCOUNT ON;
SET XACT_ABORT ON;

/* Retail Install (Sage/Pastel aligned, Branch-aware)
   Clean install of Retail schema and views with BranchID.
   Run AFTER Retail_Reset_Cleanup.sql
*/

/* 1) Tables */
IF OBJECT_ID('dbo.Retail_Product','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Product(
        ProductID INT IDENTITY(1,1) PRIMARY KEY,
        SKU VARCHAR(64) NOT NULL UNIQUE,
        Name VARCHAR(200) NOT NULL,
        Category VARCHAR(100) NULL,
        Description VARCHAR(1000) NULL,
        IsActive BIT NOT NULL DEFAULT(1),
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
END;

IF OBJECT_ID('dbo.Retail_Variant','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Variant(
        VariantID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        Barcode VARCHAR(64) NULL UNIQUE,
        AttributesJson NVARCHAR(MAX) NULL,
        IsActive BIT NOT NULL DEFAULT(1),
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Variant_Product FOREIGN KEY(ProductID) REFERENCES dbo.Retail_Product(ProductID)
    );
END;

IF OBJECT_ID('dbo.Retail_Price','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Price(
        PriceID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        BranchID INT NULL,
        SellingPrice DECIMAL(18,2) NOT NULL,
        Currency VARCHAR(8) NOT NULL DEFAULT 'ZAR',
        EffectiveFrom DATE NOT NULL,
        EffectiveTo DATE NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Price_Product FOREIGN KEY(ProductID) REFERENCES dbo.Retail_Product(ProductID)
    );
    CREATE INDEX IX_Retail_Price_Product ON dbo.Retail_Price(ProductID, BranchID, EffectiveFrom);
END;

IF OBJECT_ID('dbo.Retail_Stock','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Stock(
        StockID INT IDENTITY(1,1) PRIMARY KEY,
        VariantID INT NOT NULL,
        BranchID INT NULL,
        QtyOnHand DECIMAL(18,3) NOT NULL DEFAULT(0),
        ReorderPoint DECIMAL(18,3) NOT NULL DEFAULT(0),
        Location VARCHAR(64) NULL,
        LocationKey AS ISNULL(Location,'') PERSISTED,
        BranchKey AS ISNULL(BranchID,-1) PERSISTED,
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Stock_Variant FOREIGN KEY(VariantID) REFERENCES dbo.Retail_Variant(VariantID),
        CONSTRAINT UQ_Retail_Stock UNIQUE(VariantID, BranchKey, LocationKey)
    );
END;

IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_StockMovements(
        MovementID INT IDENTITY(1,1) PRIMARY KEY,
        VariantID INT NOT NULL,
        BranchID INT NULL,
        QtyDelta DECIMAL(18,3) NOT NULL,
        Reason VARCHAR(50) NOT NULL, -- Production, Correction, Sale, Return
        Ref1 VARCHAR(100) NULL,
        Ref2 VARCHAR(100) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy INT NULL,
        CONSTRAINT FK_Retail_Move_Variant FOREIGN KEY(VariantID) REFERENCES dbo.Retail_Variant(VariantID)
    );
    CREATE INDEX IX_Retail_StockMovements_Variant ON dbo.Retail_StockMovements(VariantID, BranchID, CreatedAt);
END;

IF OBJECT_ID('dbo.Retail_ProductImage','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_ProductImage(
        ImageID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        ImageUrl NVARCHAR(512) NOT NULL,
        ThumbnailUrl NVARCHAR(512) NULL,
        IsPrimary BIT NOT NULL DEFAULT(0),
        ImageData VARBINARY(MAX) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Image_Product FOREIGN KEY(ProductID) REFERENCES dbo.Retail_Product(ProductID)
    );
    CREATE INDEX IX_Retail_ProductImage_Product ON dbo.Retail_ProductImage(ProductID, IsPrimary);
END;

/* Optional branch FK hooks */
IF OBJECT_ID('dbo.Branches','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Retail_Stock_Branch')
        ALTER TABLE dbo.Retail_Stock ADD CONSTRAINT FK_Retail_Stock_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Retail_Price_Branch')
        ALTER TABLE dbo.Retail_Price ADD CONSTRAINT FK_Retail_Price_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Retail_Move_Branch')
        ALTER TABLE dbo.Retail_StockMovements ADD CONSTRAINT FK_Retail_Move_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
END;

/* 2) Helper SP */
IF OBJECT_ID('dbo.sp_Retail_EnsureVariant','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_Retail_EnsureVariant AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_Retail_EnsureVariant
    @ProductID INT,
    @Barcode   VARCHAR(64) = NULL,
    @VariantID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 @VariantID = VariantID FROM dbo.Retail_Variant WHERE ProductID = @ProductID AND IsActive = 1 ORDER BY VariantID;
    IF @VariantID IS NULL
    BEGIN
        INSERT INTO dbo.Retail_Variant(ProductID, Barcode, AttributesJson, IsActive)
        VALUES(@ProductID, @Barcode, NULL, 1);
        SET @VariantID = CAST(SCOPE_IDENTITY() AS INT);
    END
END;
GO

/* 3) Views */
IF OBJECT_ID('dbo.v_Retail_ProductCurrentPrice','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCurrentPrice;
GO
CREATE VIEW dbo.v_Retail_ProductCurrentPrice
AS
WITH CurrentPrice AS (
    SELECT
        pr.ProductID,
        pr.BranchID,
        pr.SellingPrice,
        pr.Currency,
        pr.EffectiveFrom,
        ROW_NUMBER() OVER (PARTITION BY pr.ProductID, pr.BranchID ORDER BY pr.EffectiveFrom DESC) AS rn
    FROM dbo.Retail_Price pr
    WHERE pr.EffectiveTo IS NULL OR pr.EffectiveTo > CAST(SYSUTCDATETIME() AS date)
)
SELECT
    p.ProductID,
    p.SKU,
    p.Name,
    p.Category,
    cp.BranchID,
    cp.SellingPrice,
    cp.Currency,
    cp.EffectiveFrom
FROM dbo.Retail_Product p
JOIN CurrentPrice cp ON cp.ProductID = p.ProductID AND cp.rn = 1;
GO

IF OBJECT_ID('dbo.v_Retail_StockOnHand','V') IS NOT NULL DROP VIEW dbo.v_Retail_StockOnHand;
GO
CREATE VIEW dbo.v_Retail_StockOnHand
AS
SELECT
    v.VariantID,
    p.ProductID,
    p.SKU,
    p.Name,
    v.Barcode,
    s.BranchID,
    s.Location,
    s.QtyOnHand,
    s.ReorderPoint,
    CASE WHEN s.QtyOnHand <= s.ReorderPoint THEN 1 ELSE 0 END AS LowStock
FROM dbo.Retail_Variant v
JOIN dbo.Retail_Product p ON p.ProductID = v.ProductID
LEFT JOIN dbo.Retail_Stock s ON s.VariantID = v.VariantID;
GO

IF OBJECT_ID('dbo.v_Retail_ProductCatalog','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCatalog;
GO
CREATE VIEW dbo.v_Retail_ProductCatalog
AS
SELECT
    p.ProductID,
    p.SKU,
    p.Name,
    p.Category,
    cpp.BranchID,
    cpp.SellingPrice,
    cpp.Currency,
    img.ImageUrl AS PrimaryImageUrl
FROM dbo.Retail_Product p
LEFT JOIN dbo.v_Retail_ProductCurrentPrice cpp ON cpp.ProductID = p.ProductID
OUTER APPLY (
  SELECT TOP 1 ImageUrl
  FROM dbo.Retail_ProductImage i
  WHERE i.ProductID = p.ProductID
  ORDER BY i.IsPrimary DESC, i.ImageID ASC
) img;
GO

IF OBJECT_ID('dbo.v_Retail_PriceHistory','V') IS NOT NULL DROP VIEW dbo.v_Retail_PriceHistory;
GO
CREATE VIEW dbo.v_Retail_PriceHistory
AS
SELECT
    p.ProductID,
    p.SKU,
    p.Name,
    pr.BranchID,
    pr.SellingPrice,
    pr.Currency,
    pr.EffectiveFrom,
    pr.EffectiveTo
FROM dbo.Retail_Product p
JOIN dbo.Retail_Price pr ON pr.ProductID = p.ProductID;
GO

/* 4) Verification */
PRINT 'Retail Branch-aware tables:';
SELECT name FROM sys.tables WHERE name LIKE 'Retail_%' ORDER BY name;
PRINT 'Retail Branch-aware views:';
SELECT name FROM sys.views WHERE name LIKE 'v_Retail_%' ORDER BY name;
