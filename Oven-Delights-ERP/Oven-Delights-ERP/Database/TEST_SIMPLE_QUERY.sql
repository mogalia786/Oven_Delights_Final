-- Test the simplest possible query for Order Book products
DECLARE @BranchID INT = 6;

-- Simple approach: Just get products that have recipes, join by Name
PRINT '=== Simple Query: Products with recipes for Branch 6 ==='
SELECT DISTINCT p.ProductID, p.Name AS ProductName, ISNULL(p.Code, p.SKU) AS SKU
FROM Demo_ProductRecipe_Master rm
INNER JOIN Products prod ON prod.ProductID = rm.ProductID
INNER JOIN Demo_Retail_Product p ON p.Name = prod.ProductName
WHERE rm.IsActive = 1
  AND p.IsActive = 1
  AND p.BranchID = @BranchID
  AND p.ProductType = 'Internal'
  AND p.Category NOT LIKE '%sub%recipe%'
  AND p.Category NOT LIKE '%subrecipe%'
ORDER BY p.Name;

PRINT ''
PRINT '=== Check if Products table exists and has data ==='
SELECT TOP 5 ProductID, ProductName
FROM Products
ORDER BY ProductID DESC;

PRINT ''
PRINT '=== Check Demo_ProductRecipe_Master ProductIDs ==='
SELECT DISTINCT rm.ProductID, prod.ProductName
FROM Demo_ProductRecipe_Master rm
LEFT JOIN Products prod ON prod.ProductID = rm.ProductID
WHERE rm.IsActive = 1;
