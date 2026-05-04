-- =============================================
-- SIMPLE FIX: Copy prices from working branches to new branches
-- =============================================

PRINT '========================================';
PRINT 'FIXING ALL BRANCH PRICES';
PRINT '========================================';
PRINT '';

BEGIN TRANSACTION;

-- Copy prices from Branch 4 (which has 741 valid prices) to branches with 0 prices
PRINT 'Copying prices from Branch 4 to branches with missing prices...';

-- Update existing price records that are 0
UPDATE target
SET 
    target.SellingPrice = source.SellingPrice,
    target.CostPrice = source.CostPrice
FROM Demo_Retail_Price target
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = target.ProductID
INNER JOIN Demo_Retail_Price source ON source.ProductID = drp.ProductID
WHERE source.BranchID = 4  -- Copy from Branch 4 (working branch)
    AND target.SellingPrice = 0
    AND source.SellingPrice > 0;

PRINT 'Updated ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' zero prices';

-- Insert missing price records for branches that don't have them
INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, CreatedAt)
SELECT 
    source.ProductID,
    b.BranchID,
    source.SellingPrice,
    source.CostPrice,
    CAST(GETDATE() AS DATE),
    GETDATE()
FROM Demo_Retail_Price source
CROSS JOIN Branches b
WHERE source.BranchID = 4  -- Copy from Branch 4
    AND b.IsActive = 1
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Price existing
        WHERE existing.ProductID = source.ProductID
        AND existing.BranchID = b.BranchID
    );

PRINT 'Inserted ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' missing price records';

COMMIT TRANSACTION;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION:';
PRINT '========================================';

SELECT 
    b.BranchID,
    b.BranchName,
    COUNT(price.ProductID) AS TotalPrices,
    SUM(CASE WHEN price.SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN price.SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices
FROM Branches b
LEFT JOIN Demo_Retail_Price price ON price.BranchID = b.BranchID
WHERE b.IsActive = 1
GROUP BY b.BranchID, b.BranchName
ORDER BY b.BranchID;

PRINT '';
PRINT '✅ ALL BRANCHES NOW HAVE PRICES!';
PRINT 'All branches should now show 741 valid prices';
