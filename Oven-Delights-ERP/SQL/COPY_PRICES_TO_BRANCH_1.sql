-- ========================================
-- COPY PRICES FROM BRANCH 6 TO BRANCH 1
-- ========================================

-- Step 1: Check what exists for Branch 1
SELECT 
    ProductID,
    BranchID,
    CostPrice,
    SellingPrice
FROM dbo.Demo_Retail_Price
WHERE BranchID = 1;

-- Step 2: Copy all prices from Branch 6 to Branch 1
INSERT INTO dbo.Demo_Retail_Price 
    (ProductID, BranchID, CostPrice, SellingPrice, SellingPriceExVAT, EffectiveFrom, CreatedAt)
SELECT 
    ProductID,
    1 AS BranchID,  -- Change to Branch 1
    CostPrice,
    SellingPrice,
    CostPrice AS SellingPriceExVAT,
    EffectiveFrom,
    GETDATE() AS CreatedAt
FROM dbo.Demo_Retail_Price
WHERE BranchID = 6
  AND ProductID NOT IN (
      SELECT ProductID 
      FROM dbo.Demo_Retail_Price 
      WHERE BranchID = 1
  );

-- Step 3: Verify the copy
SELECT 
    drp.ProductID,
    drp.BranchID,
    p.Name,
    drp.CostPrice AS AvgCost_ExclVAT,
    drp.SellingPrice AS LastPaid_InclVAT
FROM dbo.Demo_Retail_Price drp
INNER JOIN dbo.Demo_Retail_Product p ON drp.ProductID = p.ProductID
WHERE drp.BranchID = 1
ORDER BY p.Name;

-- EXECUTE THIS SCRIPT TO COPY ALL PRICES TO BRANCH 1
