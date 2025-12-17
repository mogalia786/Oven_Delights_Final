-- =============================================
-- Check if newly added products are saved correctly
-- =============================================

PRINT '=== 1. Check most recent products in Demo_Retail_Product ==='
SELECT TOP 10
    ProductID,
    Name,
    SKU,
    Category,
    ProductType,
    BranchID,
    IsActive,
    CurrentStock
FROM Demo_Retail_Product
ORDER BY ProductID DESC

PRINT ''
PRINT '=== 2. Check if products have prices ==='
SELECT TOP 10
    p.ProductID,
    p.Name,
    p.BranchID,
    rp.CostPrice,
    rp.SellingPrice,
    rp.EffectiveFrom
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
ORDER BY p.ProductID DESC

PRINT ''
PRINT '=== 3. Check what GetPOItemsLookup would return for branch 6 ==='
-- This is what PO form queries
SELECT DISTINCT
    p.ProductID AS MaterialID,
    ISNULL(p.Code, p.SKU) AS MaterialCode,
    p.Name AS MaterialName,
    0 AS AverageCost,
    CASE WHEN p.ProductType = 'External' THEN 'EXT' ELSE 'RM' END AS ItemSource,
    ISNULL(p.Category, 'Uncategorized') AS CategoryName
FROM Demo_Retail_Product p
WHERE p.IsActive = 1
  AND p.BranchID = 6  -- AYESHA CENTRE
  AND p.ProductType = 'External'
ORDER BY p.Name

PRINT ''
PRINT '=== 4. Check for specific product (enter name) ==='
-- Replace 'Macaroni Cake' with the product you just added
DECLARE @ProductName NVARCHAR(255) = 'Macaroni Cake'

SELECT 
    ProductID,
    Name,
    BranchID,
    ProductType,
    Category,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%' + @ProductName + '%'

PRINT ''
PRINT '=== DIAGNOSIS ==='
PRINT 'If product exists but ProductType = Internal:'
PRINT '  - Internal products do NOT appear in PO (only External products)'
PRINT '  - Change ItemType to "External" when adding product'
PRINT ''
PRINT 'If product exists but IsActive = 0:'
PRINT '  - Inactive products do not appear in PO'
PRINT '  - Check the IsActive checkbox when adding product'
PRINT ''
PRINT 'If product does not exist at all:'
PRINT '  - sp_SaveProductToAllBranches failed'
PRINT '  - Check for SQL errors in the stored procedure'
