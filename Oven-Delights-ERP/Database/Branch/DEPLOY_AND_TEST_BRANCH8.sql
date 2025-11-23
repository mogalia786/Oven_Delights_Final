-- =============================================
-- DEPLOY AND TEST BRANCH 8
-- =============================================

PRINT '========================================';
PRINT 'STEP 1: CLEAN UP BRANCH 8';
PRINT '========================================';

-- Clean up Branch 8 data
DELETE FROM Demo_Retail_Stock WHERE BranchID = 8;
DELETE FROM Demo_Retail_Price WHERE BranchID = 8;
DELETE FROM Branches WHERE BranchID = 8;

PRINT 'Branch 8 cleaned up';
PRINT '';

PRINT '========================================';
PRINT 'STEP 2: CREATE BRANCH 8 - ONE CLICK';
PRINT '========================================';

-- Create Branch 8 properly
EXEC sp_CreateNewBranch 
    @BranchName = 'Branch 8', 
    @BranchPrefix = 'B8', 
    @CreatedBy = 1;

PRINT '';
PRINT '========================================';
PRINT 'STEP 3: VERIFICATION';
PRINT '========================================';

-- Verify results
SELECT 
    'Branch 8 Products' AS Info,
    COUNT(DISTINCT drp.SKU) AS ProductCount
FROM Demo_Retail_Product drp
INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID
WHERE price.BranchID = 8;

SELECT 
    'Branch 8 Prices' AS Info,
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices
FROM Demo_Retail_Price
WHERE BranchID = 8;

SELECT 
    'Branch 8 Stock' AS Info,
    COUNT(*) AS StockRecords
FROM Demo_Retail_Stock
WHERE BranchID = 8;

PRINT '';
PRINT '========================================';
PRINT 'BRANCH 8 SETUP COMPLETE!';
PRINT '========================================';
