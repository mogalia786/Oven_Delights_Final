-- Find the correct SubRecipeID for "Sub Batter Test"
SELECT 
    SubRecipeID,
    Method AS [SubRecipeName],
    BatchQty,
    TotalCost,
    IsActive,
    CreatedDate,
    LastUpdated
FROM Demo_SubRecipe_Master
WHERE Method LIKE '%Sub Batter%'
   OR Method LIKE '%Batter Test%'
ORDER BY SubRecipeID;
