-- ========================================
-- FINAL FIX FOR LAST PAID PRICE
-- ========================================

-- Step 1: Find the product "Bag 1000 83*54*300mm"
SELECT 
    ProductID, 
    Name, 
    BranchID,
    SKU,
    Code
FROM dbo.Demo_Retail_Product 
WHERE Name LIKE '%Bag%1000%'
   OR Name LIKE '%83*54*300%';

-- Step 2: Check Demo_Retail_Price for this product
SELECT 
    drp.ProductID,
    drp.BranchID,
    p.Name,
    drp.CostPrice,
    drp.SellingPrice,
    drp.SellingPriceExVAT,
    drp.EffectiveFrom
FROM dbo.Demo_Retail_Price drp
INNER JOIN dbo.Demo_Retail_Product p ON drp.ProductID = p.ProductID
WHERE p.Name LIKE '%Bag%1000%'
   OR p.Name LIKE '%83*54*300%';

-- Step 3: If NO records exist, INSERT sample data
-- Replace ProductID and BranchID with actual values from Step 1

-- Example: If ProductID = 12345 and BranchID = 6
/*
INSERT INTO dbo.Demo_Retail_Price 
    (ProductID, BranchID, CostPrice, SellingPrice, SellingPriceExVAT, EffectiveFrom, CreatedAt)
VALUES 
    (12345, 6, 100.00, 115.00, 100.00, GETDATE(), GETDATE());
*/

-- Step 4: Verify the insert
SELECT 
    drp.ProductID,
    drp.BranchID,
    p.Name,
    drp.CostPrice AS AvgCost_ExclVAT,
    drp.SellingPrice AS LastPaid_InclVAT
FROM dbo.Demo_Retail_Price drp
INNER JOIN dbo.Demo_Retail_Product p ON drp.ProductID = p.ProductID
WHERE p.Name LIKE '%Bag%1000%'
   OR p.Name LIKE '%83*54*300%';
