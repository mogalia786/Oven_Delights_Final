-- Find Sub Batter Test in all possible tables
-- Check Demo_SubRecipe_Master
SELECT 'Demo_SubRecipe_Master' AS TableName, SubRecipeID, Method AS Name, BatchQty, TotalCost
FROM Demo_SubRecipe_Master
WHERE Method LIKE '%Batter%Test%' OR Method LIKE '%Sub%Batter%';

-- Check Demo_Retail_Product for sub-recipe products
SELECT 'Demo_Retail_Product' AS TableName, ProductID, Name, Category
FROM Demo_Retail_Product
WHERE Name LIKE '%Batter%Test%' OR Name LIKE '%Sub%Batter%'
  AND (Category LIKE '%sub%recipe%' OR Category LIKE '%subrecipe%');

-- Check all sub-recipes with ingredients to find the right one
SELECT 
    sm.SubRecipeID,
    sm.Method AS SubRecipeName,
    COUNT(si.IngredientLineID) AS IngredientCount,
    sm.TotalCost,
    sm.LastUpdated
FROM Demo_SubRecipe_Master sm
LEFT JOIN Demo_SubRecipe_Ingredients si ON sm.SubRecipeID = si.SubRecipeID
WHERE sm.IsActive = 1
GROUP BY sm.SubRecipeID, sm.Method, sm.TotalCost, sm.LastUpdated
ORDER BY sm.LastUpdated DESC;
