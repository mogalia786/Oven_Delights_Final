SET NOCOUNT ON;
SET XACT_ABORT ON;

/* Retail Phase 0 (Branch-aware) STRICT repair
   - Drops views first
   - Ensures BranchID exists on Price/Stock/StockMovements
   - Ensures computed keys (LocationKey, BranchKey)
   - Recreates indexes/constraints without expressions
   - Creates views only if BranchID columns exist (clear error if missing)
*/

/* 0) Drop views (safety) */
IF OBJECT_ID('dbo.v_Retail_ProductCatalog','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCatalog;
IF OBJECT_ID('dbo.v_Retail_StockOnHand','V') IS NOT NULL DROP VIEW dbo.v_Retail_StockOnHand;
IF OBJECT_ID('dbo.v_Retail_ProductCurrentPrice','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCurrentPrice;
IF OBJECT_ID('dbo.v_Retail_PriceHistory','V') IS NOT NULL DROP VIEW dbo.v_Retail_PriceHistory;

/* 1) Base tables (create if missing) */
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
        UpdatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Stock_Variant FOREIGN KEY(VariantID) REFERENCES dbo.Retail_Variant(VariantID)
    );
END;

IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_StockMovements(
        MovementID INT IDENTITY(1,1) PRIMARY KEY,
        VariantID INT NOT NULL,
        BranchID INT NULL,
        QtyDelta DECIMAL(18,3) NOT NULL,
        Reason VARCHAR(50) NOT NULL,
        Ref1 VARCHAR(100) NULL,
        Ref2 VARCHAR(100) NULL,
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy INT NULL,
        CONSTRAINT FK_Retail_Move_Variant FOREIGN KEY(VariantID) REFERENCES dbo.Retail_Variant(VariantID)
    );
END;

IF OBJECT_ID('dbo.Retail_ProductImage','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_ProductImage(
        ImageID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        ImageUrl NVARCHAR(512) NOT NULL,
        ThumbnailUrl NVARCHAR(512) NULL,
        IsPrimary BIT NOT NULL DEFAULT(0),
        CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Image_Product FOREIGN KEY(ProductID) REFERENCES dbo.Retail_Product(ProductID)
    );
END;

/* 2) Ensure BranchID columns exist */
IF COL_LENGTH('dbo.Retail_Price','BranchID') IS NULL
    ALTER TABLE dbo.Retail_Price ADD BranchID INT NULL;

IF COL_LENGTH('dbo.Retail_Stock','BranchID') IS NULL
    ALTER TABLE dbo.Retail_Stock ADD BranchID INT NULL;

IF COL_LENGTH('dbo.Retail_StockMovements','BranchID') IS NULL
    ALTER TABLE dbo.Retail_StockMovements ADD BranchID INT NULL;

/* 3) Computed keys (no-expression constraints) */
IF COL_LENGTH('dbo.Retail_Stock','LocationKey') IS NULL
    ALTER TABLE dbo.Retail_Stock ADD LocationKey AS ISNULL(Location,'') PERSISTED;
IF COL_LENGTH('dbo.Retail_Stock','BranchKey') IS NULL
    ALTER TABLE dbo.Retail_Stock ADD BranchKey AS ISNULL(BranchID,-1) PERSISTED;

/* 4) Recreate indexes/constraints */
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Retail_Price_Product' AND object_id=OBJECT_ID('dbo.Retail_Price'))
    DROP INDEX IX_Retail_Price_Product ON dbo.Retail_Price;
CREATE INDEX IX_Retail_Price_Product ON dbo.Retail_Price(ProductID, BranchID, EffectiveFrom);

IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='UQ_Retail_Stock' AND parent_object_id=OBJECT_ID('dbo.Retail_Stock'))
    ALTER TABLE dbo.Retail_Stock DROP CONSTRAINT UQ_Retail_Stock;
ALTER TABLE dbo.Retail_Stock ADD CONSTRAINT UQ_Retail_Stock UNIQUE(VariantID, BranchKey, LocationKey);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Retail_StockMovements_Variant' AND object_id=OBJECT_ID('dbo.Retail_StockMovements'))
    DROP INDEX IX_Retail_StockMovements_Variant ON dbo.Retail_StockMovements;
CREATE INDEX IX_Retail_StockMovements_Variant ON dbo.Retail_StockMovements(VariantID, BranchID, CreatedAt);

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Retail_ProductImage_Product' AND object_id=OBJECT_ID('dbo.Retail_ProductImage'))
    CREATE INDEX IX_Retail_ProductImage_Product ON dbo.Retail_ProductImage(ProductID, IsPrimary);

/* 5) Optional FKs to Branches */
IF OBJECT_ID('dbo.Branches','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Retail_Stock_Branch')
        ALTER TABLE dbo.Retail_Stock ADD CONSTRAINT FK_Retail_Stock_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Retail_Price_Branch')
        ALTER TABLE dbo.Retail_Price ADD CONSTRAINT FK_Retail_Price_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Retail_Move_Branch')
        ALTER TABLE dbo.Retail_StockMovements ADD CONSTRAINT FK_Retail_Move_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
END;

/* 6) Guard: verify BranchID columns exist before creating views */
IF COL_LENGTH('dbo.Retail_Price','BranchID') IS NULL
BEGIN
    RAISERROR('BranchID column missing in dbo.Retail_Price. Aborting view creation.',16,1);
    RETURN;
END;
IF COL_LENGTH('dbo.Retail_Stock','BranchID') IS NULL
BEGIN
    RAISERROR('BranchID column missing in dbo.Retail_Stock. Aborting view creation.',16,1);
    RETURN;
END;
IF COL_LENGTH('dbo.Retail_StockMovements','BranchID') IS NULL
BEGIN
    RAISERROR('BranchID column missing in dbo.Retail_StockMovements. Aborting view creation.',16,1);
    RETURN;
END;

/* 7) Views */
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

/* 8) Verification */
PRINT 'Retail Branch-aware tables:';
SELECT name FROM sys.tables WHERE name LIKE 'Retail_%' ORDER BY name;
PRINT 'Retail Branch-aware views:';
SELECT name FROM sys.views WHERE name LIKE 'v_Retail_%' ORDER BY name;
