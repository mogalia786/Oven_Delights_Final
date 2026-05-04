-- Check if Cheesy Cake and mango cake have recipes in Demo_ProductRecipe_Master

DECLARE @BranchID INT = 6; -- Your logged-in branch

PRINT '=== Step 1: Check if recipes exist in Demo_ProductRecipe_Master ==='
SELECT rm.ProductID, p.Name, p.BranchID, rm.BatchQty, rm.IsActive AS RecipeActive, p.IsActive AS ProductActive
FROM Demo_ProductRecipe_Master rm
LEFT JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE p.Name IN ('Cheesy Cake', 'mango cake')
ORDER BY p.Name, p.BranchID;

PRINT ''
PRINT '=== Step 2: Check what the Order Book query returns for Branch 6 ==='
SELECT p.ProductID, p.Name AS ProductName, ISNULL(p.Code, p.SKU) AS SKU, p.BranchID
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE rm.IsActive = 1
  AND p.IsActive = 1
  AND p.BranchID = @BranchID
  AND p.ProductType = 'Internal'
  AND p.Category NOT LIKE '%sub%recipe%'
  AND p.Category NOT LIKE '%subrecipe%'
ORDER BY p.Name;

PRINT ''
PRINT '=== Step 3: Check ALL products in Demo_ProductRecipe_Master ==='
SELECT COUNT(*) AS TotalRecipes
FROM Demo_ProductRecipe_Master
WHERE IsActive = 1;

PRINT ''
PRINT '=== Step 4: Check which ProductIDs have recipes ==='
SELECT DISTINCT rm.ProductID, p.Name, p.BranchID
FROM Demo_ProductRecipe_Master rm
LEFT JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE rm.IsActive = 1
ORDER BY p.Name, p.BranchID;
