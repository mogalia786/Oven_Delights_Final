-- =============================================
-- REVERSE IMPORT: Copy prices FROM Demo_Retail_Price TO Products master table
-- This populates the Products table with existing branch prices
-- =============================================

PRINT '========================================';
PRINT 'IMPORTING PRICES TO PRODUCTS MASTER TABLE';
PRINT '========================================';
PRINT '';

-- Check if Products table has price columns
IF NOT EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('Products') 
    AND name = 'RecommendedSellingPrice'
)
BEGIN
    PRINT '❌ ERROR: Products table does not have RecommendedSellingPrice column!';
    PRINT 'Cannot proceed.';
    RETURN;
END

-- Check current state
PRINT 'CURRENT STATE:';
SELECT 
    'Products Master Table' AS Info,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0 THEN 1 ELSE 0 END) AS WithoutPrice
FROM Products
WHERE IsActive = 1;

-- Check if we have any price data to import
DECLARE @AvailablePrices INT = (
    SELECT COUNT(DISTINCT drp.SKU)
    FROM Demo_Retail_Price price
    INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
    WHERE price.SellingPrice > 0
);

PRINT '';
PRINT 'Available price data in Demo_Retail_Price: ' + CAST(@AvailablePrices AS NVARCHAR(10)) + ' products';

IF @AvailablePrices = 0
BEGIN
    PRINT '';
    PRINT '❌ ERROR: No price data found in Demo_Retail_Price!';
    PRINT 'You need to import prices from a CSV file or enter them manually.';
    RETURN;
END

PRINT '';
PRINT '========================================';
PRINT 'UPDATING PRODUCTS WITH PRICES';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

-- Update Products table with prices from Demo_Retail_Price
-- Use the highest price across all branches as the RecommendedSellingPrice
UPDATE p
SET 
    p.RecommendedSellingPrice = price_data.AvgSellingPrice,
    p.AverageCost = price_data.AvgCostPrice,
    p.LastPaidPrice = price_data.AvgSellingPrice
FROM Products p
INNER JOIN (
    SELECT 
        drp.SKU,
        AVG(price.SellingPrice) AS AvgSellingPrice,
        AVG(price.CostPrice) AS AvgCostPrice
    FROM Demo_Retail_Price price
    INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
    WHERE price.SellingPrice > 0
    GROUP BY drp.SKU
) price_data ON price_data.SKU = p.ProductCode
WHERE p.IsActive = 1;

DECLARE @UpdatedCount INT = @@ROWCOUNT;

PRINT 'Updated ' + CAST(@UpdatedCount AS NVARCHAR(10)) + ' products in Products master table';

COMMIT TRANSACTION;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION:';
PRINT '========================================';

SELECT 
    'Products Master Table (After Update)' AS Info,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0 THEN 1 ELSE 0 END) AS WithoutPrice,
    MIN(RecommendedSellingPrice) AS MinPrice,
    MAX(RecommendedSellingPrice) AS MaxPrice,
    AVG(RecommendedSellingPrice) AS AvgPrice
FROM Products
WHERE IsActive = 1;

-- Sample products with prices
PRINT '';
PRINT 'Sample Products with Prices (First 10):';
SELECT TOP 10
    ProductID,
    ProductCode,
    ProductName,
    RecommendedSellingPrice,
    AverageCost,
    LastPaidPrice
FROM Products
WHERE IsActive = 1
    AND RecommendedSellingPrice > 0
ORDER BY ProductCode;

PRINT '';
PRINT '========================================';
PRINT '✅ PRICES IMPORTED TO PRODUCTS MASTER TABLE!';
PRINT '========================================';
PRINT '';
PRINT 'NEXT STEP: Re-run FIX_BRANCH8_PRICES.sql to populate Demo_Retail_Price for Branch 8';
