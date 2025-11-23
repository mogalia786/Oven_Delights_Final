-- =============================================
-- SYNC BRANCH 8 PRICES FROM OTHER BRANCHES
-- Copy valid prices from Branch 4 and 6 to Branch 8
-- =============================================

PRINT '========================================';
PRINT 'SYNCING BRANCH 8 PRICES FROM OTHER BRANCHES';
PRINT '========================================';
PRINT '';

-- Show current state
PRINT 'CURRENT STATE:';
SELECT 
    BranchID,
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices
FROM Demo_Retail_Price
WHERE BranchID IN (4, 6, 8)
GROUP BY BranchID
ORDER BY BranchID;

PRINT '';
PRINT '========================================';
PRINT 'UPDATING BRANCH 8 ZERO PRICES';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

-- Update Branch 8 zero prices with valid prices from other branches
UPDATE b8_price
SET 
    b8_price.SellingPrice = source_price.SellingPrice,
    b8_price.CostPrice = source_price.CostPrice
FROM Demo_Retail_Price b8_price
INNER JOIN Demo_Retail_Product b8_prod ON b8_prod.ProductID = b8_price.ProductID
INNER JOIN (
    -- Get valid prices from other branches (prefer Branch 6, then Branch 4)
    SELECT 
        drp.SKU,
        MAX(price.SellingPrice) AS SellingPrice,
        MAX(price.CostPrice) AS CostPrice
    FROM Demo_Retail_Price price
    INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
    WHERE price.BranchID IN (4, 6)
        AND price.SellingPrice > 0
    GROUP BY drp.SKU
) source_price ON source_price.SKU = b8_prod.SKU
WHERE b8_price.BranchID = 8
    AND b8_price.SellingPrice = 0;

DECLARE @UpdatedCount INT = @@ROWCOUNT;
PRINT 'Updated ' + CAST(@UpdatedCount AS NVARCHAR(10)) + ' zero prices in Branch 8 from other branches';

COMMIT TRANSACTION;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION:';
PRINT '========================================';

-- Show updated state
SELECT 
    BranchID,
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice
FROM Demo_Retail_Price
WHERE BranchID IN (4, 6, 8)
GROUP BY BranchID
ORDER BY BranchID;

-- Show products that still have zero prices in Branch 8
PRINT '';
PRINT 'Products still with zero price in Branch 8:';
SELECT 
    COUNT(*) AS StillZeroPrices
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
WHERE price.BranchID = 8
    AND price.SellingPrice = 0
    AND NOT EXISTS (
        -- These are products that don't exist in other branches
        SELECT 1 FROM Demo_Retail_Price other_price
        INNER JOIN Demo_Retail_Product other_prod ON other_prod.ProductID = other_price.ProductID
        WHERE other_prod.SKU = drp.SKU
            AND other_price.BranchID IN (4, 6)
            AND other_price.SellingPrice > 0
    );

-- Sample comparison
PRINT '';
PRINT 'Sample products with updated prices:';
SELECT TOP 10
    drp.SKU,
    drp.Name,
    price.SellingPrice AS Branch8Price,
    price.CostPrice AS Branch8Cost
FROM Demo_Retail_Price price
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = price.ProductID
WHERE price.BranchID = 8
    AND price.SellingPrice > 0
ORDER BY drp.SKU;

PRINT '';
PRINT '========================================';
PRINT '✅ BRANCH 8 PRICES SYNCED!';
PRINT '========================================';
PRINT '';
PRINT 'NEXT STEP: Update Products master table with new Branch 8 prices';
PRINT 'Run: IMPORT_ALL_BRANCH_PRICES_TO_MASTER.sql';
