-- Verify Branch 6 sub-recipe exists in Demo_SubRecipe_Master

-- Check if Branch 6's Sub Dough - Dhall Roti (ProductID 60718) has a master record
SELECT 
    sr.SubRecipeID,
    p.Name AS SubRecipeName,
    p.BranchID,
    sr.Method,
    sr.BatchQty,
    sr.TotalCost,
    sr.IsActive
FROM Demo_SubRecipe_Master sr
INNER JOIN Demo_Retail_Product p ON sr.SubRecipeID = p.ProductID
WHERE p.ProductID = 60718;  -- Branch 6's ProductID

-- Check if it has ingredients
SELECT 
    SubRecipeID,
    IngredientID,
    Quantity,
    UnitOfMeasure,
    CostPerUnit
FROM Demo_SubRecipe_Ingredients
WHERE SubRecipeID = 60718;

-- Test the exact query used by LoadComponents for Branch 6
DECLARE @BranchID INT = 6;

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
