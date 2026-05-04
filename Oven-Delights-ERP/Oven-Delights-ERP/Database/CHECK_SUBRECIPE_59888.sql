-- Check if SubRecipeID 59888 has ingredients in any table
DECLARE @SubRecipeID INT = 59888;

-- Check Demo_SubRecipe_Ingredients
SELECT 'Demo_SubRecipe_Ingredients' AS TableName, COUNT(*) AS IngredientCount
FROM Demo_SubRecipe_Ingredients
WHERE SubRecipeID = @SubRecipeID;

-- Check Demo_SubRecipe_BOM (old table)
SELECT 'Demo_SubRecipe_BOM' AS TableName, COUNT(*) AS IngredientCount
FROM Demo_SubRecipe_BOM
WHERE SubRecipeID = @SubRecipeID;

-- Get actual ingredients from Demo_SubRecipe_BOM
SELECT 
    'INGREDIENTS IN Demo_SubRecipe_BOM' AS Section,
    SubRecipeID,
    IngredientID,
    Quantity,
    UnitOfMeasure,
    CostPerUnit,
    TotalCost
FROM Demo_SubRecipe_BOM
WHERE SubRecipeID = @SubRecipeID;
