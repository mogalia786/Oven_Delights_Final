-- Check the Americano recipe (the one you created with 60L milk)
SELECT 
    r.RecipeID,
    r.ProductID,
    r.RecipeName,
    r.BatchYield,
    r.BatchYieldUoM,
    r.IsActive
FROM dbo.Recipe r
WHERE r.RecipeName LIKE '%Americano%' OR r.RecipeName LIKE '%250ML%'
ORDER BY r.RecipeID DESC;

-- Check ingredients for this recipe
SELECT 
    ri.RecipeIngredientID,
    ri.RecipeID,
    ri.IngredientType,
    ri.IngredientName,
    rm.MaterialName,
    ri.Quantity,
    ri.UoM
FROM dbo.RecipeIngredients ri
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID
WHERE ri.RecipeID IN (SELECT RecipeID FROM dbo.Recipe WHERE RecipeName LIKE '%Americano%' OR RecipeName LIKE '%250ML%')
ORDER BY ri.RecipeID, ri.RecipeIngredientID;
