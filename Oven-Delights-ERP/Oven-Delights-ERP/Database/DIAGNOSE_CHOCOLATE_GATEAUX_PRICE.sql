-- Diagnose BC Chocolate Gateaux pricing issue

PRINT '=== BC Chocolate Gateaux Price Diagnosis ==='
PRINT ''

-- Find the product
DECLARE @ProductID INT
SELECT @ProductID = ProductID 
FROM Demo_Retail_Product 
WHERE Name LIKE '%Chocolate Gateaux%' 
  AND SKU LIKE '%BC%'
  AND BranchID = 6

PRINT 'ProductID: ' + CAST(@ProductID AS VARCHAR)
PRINT ''

-- Show ALL price records for this product
PRINT '=== ALL Price Records for this Product ==='
SELECT 
    PriceID,
    ProductID,
    BranchID,
    SellingPrice,
    CostPrice,
    EffectiveFrom,
    CreatedAt
FROM Demo_Retail_Price
WHERE ProductID = @ProductID
ORDER BY 
    CASE WHEN BranchID IS NULL THEN 0 ELSE 1 END,
    BranchID,
    EffectiveFrom DESC

PRINT ''
PRINT '=== What POS View Returns ==='
-- Show what the view returns (simulating the view logic)
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.BranchID,
    ISNULL(
        (SELECT TOP 1 SellingPrice FROM Demo_Retail_Price 
         WHERE ProductID = p.ProductID AND BranchID = p.BranchID 
         ORDER BY EffectiveFrom DESC),
        (SELECT TOP 1 SellingPrice FROM Demo_Retail_Price 
         WHERE ProductID = p.ProductID AND BranchID IS NULL 
         ORDER BY EffectiveFrom DESC)
    ) AS SellingPrice
FROM Demo_Retail_Product p
WHERE p.ProductID = @ProductID
  AND p.BranchID = 6

PRINT ''
PRINT '=== SOLUTION ==='
PRINT 'If there is a global price (BranchID IS NULL) with R 125.00,'
PRINT 'you need to either:'
PRINT '1. DELETE the global price record, OR'
PRINT '2. UPDATE the global price to R 200.00, OR'
PRINT '3. Ensure branch-specific price (BranchID = 6) exists and is newer'
