-- Find sub-recipes that have ingredients
SELECT 
    sm.SubRecipeID,
    sm.Method AS [SubRecipeName],
    sm.BatchQty,
    sm.TotalCost,
    COUNT(si.IngredientLineID) AS [Ingredient Count],
    sm.LastUpdated
FROM Demo_SubRecipe_Master sm
LEFT JOIN Demo_SubRecipe_Ingredients si ON sm.SubRecipeID = si.SubRecipeID
WHERE sm.IsActive = 1
GROUP BY sm.SubRecipeID, sm.Method, sm.BatchQty, sm.TotalCost, sm.LastUpdated
HAVING COUNT(si.IngredientLineID) > 0
ORDER BY sm.LastUpdated DESC;
