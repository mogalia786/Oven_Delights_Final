-- Debug why GetComponentCost returns 0 for ingredients

DECLARE @ComponentID INT = 59219; -- Choc milk block ProductID from Branch 6

PRINT '=== Step 1: Check Demo_Retail_Price for this component ==='
SELECT 
    ProductID,
    BranchID,
    CostPrice,
    CurrentPrice,
    SellingPrice
FROM Demo_Retail_Price
WHERE ProductID = @ComponentID;

PRINT ''
PRINT '=== Step 2: Check Demo_Retail_Price for Branch 6 specifically ==='
SELECT 
    ProductID,
    BranchID,
    CostPrice,
    CurrentPrice,
    SellingPrice
FROM Demo_Retail_Price
WHERE ProductID = @ComponentID AND BranchID = 6;

PRINT ''
PRINT '=== Step 3: Check what GetComponentCost query returns ==='
SELECT TOP 1 ISNULL(CostPrice, 0) AS CostFromQuery
FROM Demo_Retail_Price
WHERE ProductID = @ComponentID AND BranchID = 6;

PRINT ''
PRINT '=== Step 4: Check Demo_Retail_Product for this component ==='
SELECT ProductID, Name, BranchID, AverageCost, LastPaidPrice, Category
FROM Demo_Retail_Product
WHERE ProductID = @ComponentID;

PRINT ''
PRINT '=== Step 5: Check ALL Choc milk block entries across all branches ==='
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    pr.CostPrice,
    p.AverageCost,
    p.LastPaidPrice
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price pr ON pr.ProductID = p.ProductID AND pr.BranchID = p.BranchID
WHERE p.Name = 'Choc milk block'
ORDER BY p.BranchID;
