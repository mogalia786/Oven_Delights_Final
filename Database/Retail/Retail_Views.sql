-- Retail Module Views (Azure SQL, idempotent)
-- Timestamp: 11-Sep-2025 21:22 SAST

/* Current Price per Product */
IF OBJECT_ID('dbo.v_Retail_ProductCurrentPrice','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCurrentPrice;
GO
CREATE VIEW dbo.v_Retail_ProductCurrentPrice AS
SELECT p.ProductID, p.SKU, p.Name, p.Category,
       pr.SellingPrice, pr.Currency, pr.EffectiveFrom
FROM dbo.Retail_Product p
OUTER APPLY (
  SELECT TOP 1 SellingPrice, Currency, EffectiveFrom
  FROM dbo.Retail_Price pr
  WHERE pr.ProductID = p.ProductID AND (pr.EffectiveTo IS NULL OR pr.EffectiveTo > CAST(SYSUTCDATETIME() AS date))
  ORDER BY pr.EffectiveFrom DESC
) pr;
GO

/* Stock On Hand per Variant */
IF OBJECT_ID('dbo.v_Retail_StockOnHand','V') IS NOT NULL DROP VIEW dbo.v_Retail_StockOnHand;
GO
CREATE VIEW dbo.v_Retail_StockOnHand AS
SELECT v.VariantID, p.ProductID, p.SKU, p.Name, v.Barcode, s.Location, s.QtyOnHand, s.ReorderPoint,
       CASE WHEN s.QtyOnHand <= s.ReorderPoint THEN 1 ELSE 0 END AS LowStock
FROM dbo.Retail_Variant v
JOIN dbo.Retail_Product p ON p.ProductID = v.ProductID
LEFT JOIN dbo.Retail_Stock s ON s.VariantID = v.VariantID;
GO

/* Product Catalog with Current Price */
IF OBJECT_ID('dbo.v_Retail_ProductCatalog','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCatalog;
GO
CREATE VIEW dbo.v_Retail_ProductCatalog AS
SELECT p.ProductID, p.SKU, p.Name, p.Category,
       cpp.SellingPrice, cpp.Currency,
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

/* Price History */
IF OBJECT_ID('dbo.v_Retail_PriceHistory','V') IS NOT NULL DROP VIEW dbo.v_Retail_PriceHistory;
GO
CREATE VIEW dbo.v_Retail_PriceHistory AS
SELECT p.ProductID, p.SKU, p.Name, pr.SellingPrice, pr.Currency, pr.EffectiveFrom, pr.EffectiveTo
FROM dbo.Retail_Product p
JOIN dbo.Retail_Price pr ON pr.ProductID = p.ProductID;
GO
