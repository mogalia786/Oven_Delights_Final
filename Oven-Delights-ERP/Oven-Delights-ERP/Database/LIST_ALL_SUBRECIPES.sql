-- List all sub-recipes to find the correct one
SELECT 
    SubRecipeID,
    Method AS [SubRecipeName],
    BatchQty,
    TotalCost,
    IsActive,
    CreatedDate,
    LastUpdated
FROM Demo_SubRecipe_Master
WHERE IsActive = 1
ORDER BY LastUpdated DESC;
