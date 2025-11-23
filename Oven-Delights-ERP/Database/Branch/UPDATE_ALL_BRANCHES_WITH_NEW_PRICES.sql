-- =============================================
-- UPDATE ALL BRANCHES WITH NEW PRICES FROM PRODUCTS MASTER
-- =============================================

PRINT '========================================';
PRINT 'UPDATING ALL BRANCHES WITH NEW PRICES';
PRINT '========================================';
PRINT '';

-- Check current state
PRINT 'CURRENT STATE:';
SELECT 
    BranchID,
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices
FROM Demo_Retail_Price
GROUP BY BranchID
ORDER BY BranchID;

PRINT '';
PRINT '========================================';
PRINT 'UPDATING PRICES FROM PRODUCTS MASTER';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

-- Update all branch prices with prices from Products master table
UPDATE price
SET 
    price.SellingPrice = COALESCE(p.RecommendedSellingPrice, p.LastPaidPrice, 0),
    price.CostPrice = COALESCE(p.AverageCost, p.LastPaidPrice, 0)
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
INNER JOIN Products p ON p.ProductCode = drp.SKU
WHERE p.IsActive = 1
    AND (p.RecommendedSellingPrice > 0 OR p.LastPaidPrice > 0);

DECLARE @UpdatedCount INT = @@ROWCOUNT;

PRINT 'Updated ' + CAST(@UpdatedCount AS NVARCHAR(10)) + ' price records across all branches';

COMMIT TRANSACTION;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION:';
PRINT '========================================';

-- Check updated state
SELECT 
    BranchID,
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice,
    AVG(SellingPrice) AS AvgPrice
FROM Demo_Retail_Price
GROUP BY BranchID
ORDER BY BranchID;

-- Sample Branch 8 products
PRINT '';
PRINT 'Sample Branch 8 products (First 10):';
SELECT TOP 10
    drp.SKU,
    drp.Name,
    price.SellingPrice,
    price.CostPrice
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
WHERE price.BranchID = 8
    AND price.SellingPrice > 0
ORDER BY drp.SKU;

PRINT '';
PRINT '========================================';
PRINT '✅ ALL BRANCHES UPDATED WITH NEW PRICES!';
PRINT '========================================';
