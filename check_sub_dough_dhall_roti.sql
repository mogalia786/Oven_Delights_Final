-- Check if Sub Dough - Dhall Roti exists and has recipe master record

-- 1. Check if product exists in Demo_Retail_Product
SELECT 
    ProductID,
    Name,
    Category,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%Sub Dough%Dhall Roti%'
ORDER BY BranchID;

-- 2. Check if it has a record in Demo_SubRecipe_Master
SELECT 
    sr.SubRecipeID,
    p.Name AS SubRecipeName,
    sr.Method,
    sr.BatchQty,
    sr.TotalCost,
    sr.IsActive,
    sr.CreatedDate
FROM Demo_SubRecipe_Master sr
INNER JOIN Demo_Retail_Product p ON sr.SubRecipeID = p.ProductID
WHERE p.Name LIKE '%Sub Dough%Dhall Roti%';

-- 3. Check what components query would return for current user's branch
-- Replace @BranchID with your actual branch ID (likely 1, 6, etc.)
DECLARE @BranchID INT = 1;

SELECT p.ProductID, p.Name, p.Category
FROM Demo_Retail_Product p
LEFT JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%')
WHERE p.IsActive = 1
  AND p.BranchID = @BranchID
  AND p.Name LIKE '%Sub Dough%Dhall Roti%'
  AND (
    (p.Category LIKE '%ingredient%') OR
    (p.Category LIKE '%consumable%') OR
    (p.Category LIKE '%pack%') OR
    (p.Category LIKE '%misce%') OR
    ((p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%') AND sr.SubRecipeID IS NOT NULL)
  )
ORDER BY p.Category, p.Name;
