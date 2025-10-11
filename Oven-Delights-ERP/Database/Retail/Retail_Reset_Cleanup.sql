SET NOCOUNT ON;
SET XACT_ABORT ON;

/* Retail Reset Cleanup (Sage/Pastel aligned, Branch-aware)
   Run this to drop all Retail views, procedures, and tables so we can install cleanly.
*/

/* 1) Drop views first */
IF OBJECT_ID('dbo.v_Retail_ProductCatalog','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCatalog;
IF OBJECT_ID('dbo.v_Retail_StockOnHand','V') IS NOT NULL DROP VIEW dbo.v_Retail_StockOnHand;
IF OBJECT_ID('dbo.v_Retail_ProductCurrentPrice','V') IS NOT NULL DROP VIEW dbo.v_Retail_ProductCurrentPrice;
IF OBJECT_ID('dbo.v_Retail_PriceHistory','V') IS NOT NULL DROP VIEW dbo.v_Retail_PriceHistory;

/* 2) Drop helper procedures if any */
IF OBJECT_ID('dbo.sp_Retail_EnsureVariant','P') IS NOT NULL DROP PROCEDURE dbo.sp_Retail_EnsureVariant;

/* 3) Drop tables in dependency order */
IF OBJECT_ID('dbo.Retail_ProductImage','U') IS NOT NULL DROP TABLE dbo.Retail_ProductImage;
IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NOT NULL DROP TABLE dbo.Retail_StockMovements;
IF OBJECT_ID('dbo.Retail_Stock','U') IS NOT NULL DROP TABLE dbo.Retail_Stock;
IF OBJECT_ID('dbo.Retail_Price','U') IS NOT NULL DROP TABLE dbo.Retail_Price;
IF OBJECT_ID('dbo.Retail_Variant','U') IS NOT NULL DROP TABLE dbo.Retail_Variant;
IF OBJECT_ID('dbo.Retail_Product','U') IS NOT NULL DROP TABLE dbo.Retail_Product;

PRINT 'Retail objects dropped. Ready for clean install.';
