-- =============================================
-- VERIFY BRANCH 10 PRICES
-- =============================================

PRINT '========================================';
PRINT 'BRANCH 10 PRICE VERIFICATION';
PRINT '========================================';
PRINT '';

-- 1. Price summary
SELECT 
    'Branch 10 Prices' AS Info,
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice,
    AVG(SellingPrice) AS AvgPrice
FROM Demo_Retail_Price
WHERE BranchID = 10;

-- 2. Sample products with prices
PRINT '';
PRINT 'Sample products with prices (First 20):';
SELECT TOP 20
    drp.SKU,
    drp.Name,
    drp.Category,
    price.SellingPrice,
    price.CostPrice,
    stock.QtyOnHand
FROM Demo_Retail_Product drp
INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID
LEFT JOIN Demo_Retail_Stock stock ON stock.VariantID = drp.ProductID AND stock.BranchID = 10
WHERE price.BranchID = 10
    AND price.SellingPrice > 0
ORDER BY drp.SKU;

-- 3. Products ready for POS
PRINT '';
PRINT 'POS Readiness:';
SELECT 
    'Products ready for POS' AS Status,
    COUNT(DISTINCT drp.SKU) AS ProductCount
FROM Demo_Retail_Product drp
INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID
WHERE price.BranchID = 10
    AND price.SellingPrice > 0;

-- 4. Compare with Products master table
PRINT '';
PRINT 'Comparison with Products master:';
SELECT 
    'Products master (retail)' AS Source,
    COUNT(*) AS ProductCount,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice
FROM Products
WHERE IsActive = 1
    AND ItemType IN ('internal', 'external', 'Manufactured');

PRINT '';
PRINT '========================================';
PRINT 'SUMMARY';
PRINT '========================================';

DECLARE @ValidPrices INT = (
    SELECT COUNT(*) FROM Demo_Retail_Price 
    WHERE BranchID = 10 AND SellingPrice > 0
);

DECLARE @ZeroPrices INT = (
    SELECT COUNT(*) FROM Demo_Retail_Price 
    WHERE BranchID = 10 AND SellingPrice = 0
);

PRINT 'Branch 10 has ' + CAST(@ValidPrices AS NVARCHAR(10)) + ' products with valid prices';
PRINT 'Branch 10 has ' + CAST(@ZeroPrices AS NVARCHAR(10)) + ' products with zero prices';

IF @ValidPrices > 300
    PRINT '✅ BRANCH 10 IS READY FOR POS!';
ELSE
    PRINT '⚠️ WARNING: Most products have zero prices - need to populate Products master table first';
