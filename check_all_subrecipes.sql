-- Check all sub-recipes to see which ones work and which don't

-- 1. List all sub-recipes that have master records
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    p.Category,
    p.ProductType,
    sr.SubRecipeID,
    sr.BatchQty,
    sr.TotalCost
FROM Demo_Retail_Product p
INNER JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID
WHERE (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%')
ORDER BY p.Name, p.BranchID;

-- 2. Test LoadComponents query for Branch 6 - see which sub-recipes appear
DECLARE @BranchID INT = 6;

SELECT p.ProductID, p.Name, p.Category, p.ProductType, sr.SubRecipeID
FROM Demo_Retail_Product p
LEFT JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%')
WHERE p.IsActive = 1
  AND p.BranchID = @BranchID
  AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%')
  AND sr.SubRecipeID IS NOT NULL
ORDER BY p.Name;

-- 3. Check specifically for Sub Dough - Dhall Roti across all branches
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    p.Category,
    p.ProductType,
    p.IsActive,
    sr.SubRecipeID AS HasMasterRecord
FROM Demo_Retail_Product p
LEFT JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID
WHERE p.Name LIKE '%Sub Dough%Dhall Roti%'
ORDER BY p.BranchID;
