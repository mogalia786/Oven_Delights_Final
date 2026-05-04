-- =============================================
-- COMPREHENSIVE PRICE IMPORT: Get prices from ALL branches
-- Import ALL available prices from Demo_Retail_Price to Products master
-- =============================================

PRINT '========================================';
PRINT 'COMPREHENSIVE PRICE IMPORT FROM ALL BRANCHES';
PRINT '========================================';
PRINT '';

-- Check which branches have price data
PRINT 'Price data by branch:';
SELECT 
    BranchID,
    COUNT(*) AS PriceRecords,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice
FROM Demo_Retail_Price
GROUP BY BranchID
ORDER BY BranchID;

PRINT '';
PRINT '========================================';
PRINT 'UPDATING PRODUCTS WITH ALL AVAILABLE PRICES';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

-- Update Products table with prices from ALL branches
-- Use MAX price if product has different prices across branches
UPDATE p
SET 
    p.RecommendedSellingPrice = price_data.MaxSellingPrice,
    p.AverageCost = price_data.AvgCostPrice,
    p.LastPaidPrice = price_data.MaxSellingPrice
FROM Products p
INNER JOIN (
    SELECT 
        drp.SKU,
        MAX(price.SellingPrice) AS MaxSellingPrice,
        AVG(price.CostPrice) AS AvgCostPrice,
        COUNT(DISTINCT price.BranchID) AS BranchCount
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
    'Products Master Table' AS Info,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0 THEN 1 ELSE 0 END) AS WithoutPrice,
    MIN(RecommendedSellingPrice) AS MinPrice,
    MAX(RecommendedSellingPrice) AS MaxPrice
FROM Products
WHERE IsActive = 1;

-- Show products that still have no price
PRINT '';
PRINT 'Products WITHOUT prices (need manual entry):';
SELECT 
    COUNT(*) AS ProductsWithoutPrice
FROM Products
WHERE IsActive = 1
    AND (RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0);

-- Sample comparison: Products vs Demo_Retail_Price coverage
PRINT '';
PRINT 'Coverage comparison:';
SELECT 
    'Unique SKUs in Demo_Retail_Price' AS Info,
    COUNT(DISTINCT drp.SKU) AS UniqueProducts
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
WHERE price.SellingPrice > 0;

SELECT 
    'Products in master table' AS Info,
    COUNT(*) AS TotalProducts
FROM Products
WHERE IsActive = 1;

PRINT '';
PRINT '========================================';
PRINT '✅ COMPREHENSIVE PRICE IMPORT COMPLETE!';
PRINT '========================================';
PRINT '';
PRINT 'NEXT STEP: Re-run FIX_BRANCH8_PRICES.sql';
