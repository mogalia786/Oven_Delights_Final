-- =============================================
-- FIX BRANCH 8 PRICES
-- Map existing prices to new ProductIDs via SKU
-- =============================================

PRINT '========================================';
PRINT 'FIXING BRANCH 8 PRICE MAPPING';
PRINT '========================================';
PRINT '';

-- Check current state
PRINT 'CURRENT STATE:';
SELECT 
    'Demo_Retail_Price (Branch 8)' AS Info,
    COUNT(*) AS RecordCount,
    MIN(ProductID) AS MinProductID,
    MAX(ProductID) AS MaxProductID
FROM Demo_Retail_Price
WHERE BranchID = 8;

SELECT 
    'Demo_Retail_Product' AS Info,
    COUNT(*) AS RecordCount,
    MIN(ProductID) AS MinProductID,
    MAX(ProductID) AS MaxProductID
FROM Demo_Retail_Product;

PRINT '';
PRINT 'Checking for mismatched ProductIDs...';

-- Find prices that reference non-existent products
SELECT 
    'Orphaned Prices' AS Issue,
    COUNT(*) AS RecordCount
FROM Demo_Retail_Price price
WHERE BranchID = 8
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Product drp
        WHERE drp.ProductID = price.ProductID
    );

-- Check Products master table for pricing data
PRINT '';
PRINT 'Products Master Table Pricing:';
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithRecommendedPrice,
    SUM(CASE WHEN LastPaidPrice > 0 THEN 1 ELSE 0 END) AS WithLastPaidPrice,
    SUM(CASE WHEN COALESCE(RecommendedSellingPrice, LastPaidPrice, 0) > 0 THEN 1 ELSE 0 END) AS WithAnyPrice,
    SUM(CASE WHEN COALESCE(RecommendedSellingPrice, LastPaidPrice, 0) = 0 THEN 1 ELSE 0 END) AS WithoutPrice
FROM Products
WHERE IsActive = 1
    AND ItemType IN ('internal', 'external', 'Manufactured');

PRINT '';
PRINT '========================================';
PRINT 'SOLUTION: Delete old prices and recreate';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

-- Delete old prices for Branch 8 (they reference wrong ProductIDs)
DELETE FROM Demo_Retail_Price
WHERE BranchID = 8;

PRINT 'Deleted old prices for Branch 8';

-- Recreate prices with correct ProductIDs (inherit from Products master table)
INSERT INTO Demo_Retail_Price (
    ProductID,
    BranchID,
    SellingPrice,
    CostPrice,
    EffectiveFrom,
    EffectiveTo,
    CreatedAt
)
SELECT 
    drp.ProductID,
    8 AS BranchID,
    COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) AS SellingPrice,
    COALESCE(p.AverageCost, p.LastPaidPrice, 0) AS CostPrice,
    CAST(GETDATE() AS DATE) AS EffectiveFrom,
    NULL AS EffectiveTo,
    GETDATE() AS CreatedAt
FROM Products p
INNER JOIN Demo_Retail_Product drp ON drp.SKU = p.ProductCode
WHERE p.IsActive = 1
    AND p.ItemType IN ('internal', 'external', 'Manufactured');
    -- Removed filter: AND COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0) > 0
    -- This ensures ALL products get price records (even if 0) so they appear in POS

DECLARE @PriceCount INT = @@ROWCOUNT;
DECLARE @PricesWithValue INT = (
    SELECT COUNT(*) FROM Demo_Retail_Price 
    WHERE BranchID = 8 AND SellingPrice > 0
);
DECLARE @PricesZero INT = (
    SELECT COUNT(*) FROM Demo_Retail_Price 
    WHERE BranchID = 8 AND SellingPrice = 0
);

PRINT 'Created ' + CAST(@PriceCount AS NVARCHAR(10)) + ' total prices for Branch 8';
PRINT '  - ' + CAST(@PricesWithValue AS NVARCHAR(10)) + ' with valid prices (inherited from Products table)';
PRINT '  - ' + CAST(@PricesZero AS NVARCHAR(10)) + ' with zero price (need manual pricing)';

IF @PricesZero > 0
BEGIN
    PRINT '';
    PRINT '⚠️ WARNING: ' + CAST(@PricesZero AS NVARCHAR(10)) + ' products have no price in Products master table!';
    PRINT 'These products will show R0.00 in POS until prices are set in Products table.';
END

COMMIT TRANSACTION;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION:';
PRINT '========================================';

-- Verify prices now reference valid products
SELECT 
    'Demo_Retail_Price (Branch 8)' AS Info,
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice
FROM Demo_Retail_Price
WHERE BranchID = 8;

-- Check for any orphaned prices
SELECT 
    'Orphaned Prices (should be 0)' AS CheckResult,
    COUNT(*) AS RecordCount
FROM Demo_Retail_Price price
WHERE BranchID = 8
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Product drp
        WHERE drp.ProductID = price.ProductID
    );

-- Sample data
PRINT '';
PRINT 'Sample Products with Prices (First 10):';
SELECT TOP 10
    drp.ProductID,
    drp.SKU,
    drp.Name,
    drp.Category,
    price.SellingPrice,
    price.CostPrice
FROM Demo_Retail_Product drp
INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID AND price.BranchID = 8
WHERE drp.IsActive = 1
ORDER BY drp.SKU;

PRINT '';
PRINT '========================================';
PRINT '✅ BRANCH 8 PRICES FIXED!';
PRINT '========================================';
