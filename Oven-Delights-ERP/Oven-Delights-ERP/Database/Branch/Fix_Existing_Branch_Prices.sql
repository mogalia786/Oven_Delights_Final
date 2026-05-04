-- =============================================
-- Script to fix prices for existing branches
-- Copies prices from master branch (Branch 6) to branches with 0 prices
-- =============================================

-- Check which branches have 0 prices
SELECT 
    b.BranchID,
    b.BranchName,
    COUNT(drp.PriceID) AS PriceCount,
    SUM(CASE WHEN drp.SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPriceCount
FROM Branches b
LEFT JOIN Demo_Retail_Price drp ON drp.BranchID = b.BranchID
WHERE b.IsActive = 1
GROUP BY b.BranchID, b.BranchName
ORDER BY b.BranchID;

-- Fix prices for a specific branch (replace @TargetBranchID with the branch you just created)
DECLARE @TargetBranchID INT = 8; -- Change this to your new branch ID
DECLARE @MasterBranchID INT = 6;

BEGIN TRANSACTION;

-- Delete existing zero prices
DELETE FROM Demo_Retail_Price
WHERE BranchID = @TargetBranchID
  AND SellingPrice = 0;

-- Copy prices from master branch
INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom, EffectiveTo)
SELECT 
    master.ProductID,
    @TargetBranchID AS BranchID,
    master.SellingPrice,
    master.CostPrice,
    GETDATE() AS EffectiveFrom,
    NULL AS EffectiveTo
FROM Demo_Retail_Price master
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = master.ProductID
WHERE master.BranchID = @MasterBranchID
  AND drp.IsActive = 1
  AND (drp.ProductType = 'External' OR drp.ProductType = 'Internal')
  AND master.SellingPrice > 0
  AND NOT EXISTS (
      SELECT 1 FROM Demo_Retail_Price 
      WHERE ProductID = master.ProductID AND BranchID = @TargetBranchID
  );

PRINT 'Prices copied: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- Verify the fix
SELECT 
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice,
    AVG(SellingPrice) AS AvgPrice
FROM Demo_Retail_Price
WHERE BranchID = @TargetBranchID;

COMMIT TRANSACTION;

-- If everything looks good, the prices should now be copied!
