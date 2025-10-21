SET NOCOUNT ON;
SET XACT_ABORT ON;

/* Retail Force BranchID
   - Adds REAL BranchID INT to Price/Stock/StockMovements if missing (does not create computed columns)
   - If legacy BranchId exists, copies data into BranchID (does not drop BranchId)
   - Rebuilds minimal constraints and views
*/

/* Drop views to remove dependencies */
IF OBJECT_ID('dbo.v_Retail_ProductCatalog','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCatalog;
IF OBJECT_ID('dbo.v_Retail_StockOnHand','V') IS NOT NULL DROP VIEW dbo.v_Retail_StockOnHand;
IF OBJECT_ID('dbo.v_Retail_ProductCurrentPrice','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCurrentPrice;
IF OBJECT_ID('dbo.v_Retail_PriceHistory','V') IS NOT NULL DROP VIEW dbo.v_Retail_PriceHistory;

/* Ensure tables exist */
IF OBJECT_ID('dbo.Retail_Price','U') IS NULL
BEGIN
    RAISERROR('Table dbo.Retail_Price missing. Create Retail tables first.',16,1);
    RETURN;
END;
IF OBJECT_ID('dbo.Retail_Stock','U') IS NULL
BEGIN
    RAISERROR('Table dbo.Retail_Stock missing. Create Retail tables first.',16,1);
    RETURN;
END;
IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NULL
BEGIN
    RAISERROR('Table dbo.Retail_StockMovements missing. Create Retail tables first.',16,1);
    RETURN;
END;
IF OBJECT_ID('dbo.Retail_Product','U') IS NULL OR OBJECT_ID('dbo.Retail_Variant','U') IS NULL
BEGIN
    RAISERROR('Retail_Product or Retail_Variant missing. Create Retail tables first.',16,1);
    RETURN;
END;

/* Force-add BranchID as REAL INT if missing */
IF COL_LENGTH('dbo.Retail_Price','BranchID') IS NULL
    ALTER TABLE dbo.Retail_Price ADD BranchID INT NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('dbo.Retail_Price') AND name='BranchId')
    UPDATE dbo.Retail_Price SET BranchID = COALESCE(BranchID, BranchId) WHERE BranchID IS NULL;

IF COL_LENGTH('dbo.Retail_Stock','BranchID') IS NULL
    ALTER TABLE dbo.Retail_Stock ADD BranchID INT NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('dbo.Retail_Stock') AND name='BranchId')
    UPDATE dbo.Retail_Stock SET BranchID = COALESCE(BranchID, BranchId) WHERE BranchID IS NULL;

IF COL_LENGTH('dbo.Retail_StockMovements','BranchID') IS NULL
    ALTER TABLE dbo.Retail_StockMovements ADD BranchID INT NULL;
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id=OBJECT_ID('dbo.Retail_StockMovements') AND name='BranchId')
    UPDATE dbo.Retail_StockMovements SET BranchID = COALESCE(BranchID, BranchId) WHERE BranchID IS NULL;

/* Minimal constraints: BranchKey & LocationKey (recreated safely) */
IF COL_LENGTH('dbo.Retail_Stock','LocationKey') IS NULL
    ALTER TABLE dbo.Retail_Stock ADD LocationKey AS ISNULL(Location,'') PERSISTED;
IF EXISTS (SELECT 1 FROM sys.key_constraints WHERE name='UQ_Retail_Stock' AND parent_object_id=OBJECT_ID('dbo.Retail_Stock'))
    ALTER TABLE dbo.Retail_Stock DROP CONSTRAINT UQ_Retail_Stock;
IF COL_LENGTH('dbo.Retail_Stock','BranchKey') IS NOT NULL
    ALTER TABLE dbo.Retail_Stock DROP COLUMN BranchKey;
ALTER TABLE dbo.Retail_Stock ADD BranchKey AS ISNULL(BranchID,-1) PERSISTED;
ALTER TABLE dbo.Retail_Stock ADD CONSTRAINT UQ_Retail_Stock UNIQUE(VariantID, BranchKey, LocationKey);

/* Index refresh */
IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Retail_Price_Product' AND object_id=OBJECT_ID('dbo.Retail_Price'))
    DROP INDEX IX_Retail_Price_Product ON dbo.Retail_Price;
CREATE INDEX IX_Retail_Price_Product ON dbo.Retail_Price(ProductID, BranchID, EffectiveFrom);

IF EXISTS (SELECT 1 FROM sys.indexes WHERE name='IX_Retail_StockMovements_Variant' AND object_id=OBJECT_ID('dbo.Retail_StockMovements'))
    DROP INDEX IX_Retail_StockMovements_Variant ON dbo.Retail_StockMovements;
CREATE INDEX IX_Retail_StockMovements_Variant ON dbo.Retail_StockMovements(VariantID, BranchID, CreatedAt);

/* Recreate views */
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

/* Verify */
PRINT 'Retail Branch-aware tables:';
SELECT name FROM sys.tables WHERE name LIKE 'Retail_%' ORDER BY name;
PRINT 'Retail Branch-aware views:';
SELECT name FROM sys.views WHERE name LIKE 'v_Retail_%' ORDER BY name;
