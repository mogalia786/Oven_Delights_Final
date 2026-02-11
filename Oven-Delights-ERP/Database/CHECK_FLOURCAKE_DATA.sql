-- =============================================
-- Check FlourCake and Eggs data in database
-- Verify prices and IsVatable settings
-- =============================================

PRINT '=== Checking FlourCake Data ==='
PRINT ''

-- Check Demo_Retail_Product
SELECT 
    ProductID,
    Name,
    BranchID,
    IsVatable,
    ProductType,
    Category,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%FlourCake%' OR Name LIKE '%Flour%Cake%'
ORDER BY BranchID

PRINT ''
PRINT '=== Checking FlourCake Prices ==='
PRINT ''

-- Check Demo_Retail_Price
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    rp.CostPrice,
    rp.SellingPrice,
    p.IsVatable
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
WHERE p.Name LIKE '%FlourCake%' OR p.Name LIKE '%Flour%Cake%'
ORDER BY p.BranchID

PRINT ''
PRINT '=== Checking Eggs Data ==='
PRINT ''

-- Check Eggs
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    rp.CostPrice,
    rp.SellingPrice,
    p.IsVatable
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
WHERE p.Name LIKE '%Eggs%'
ORDER BY p.BranchID

PRINT ''
PRINT '=== Checking RawMaterials for FlourCake ==='
PRINT ''

-- Check if FlourCake exists in RawMaterials
SELECT 
    MaterialID,
    MaterialCode,
    MaterialName,
    LastPaidPrice
FROM RawMaterials
WHERE MaterialName LIKE '%FlourCake%' OR MaterialName LIKE '%Flour%Cake%'

PRINT ''
PRINT 'Check complete!'
