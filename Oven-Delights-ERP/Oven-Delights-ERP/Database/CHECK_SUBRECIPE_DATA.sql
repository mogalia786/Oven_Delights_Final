-- Check if Sub Batter Test exists and what ingredients it has

-- 1. Check if SubRecipeID 56886 exists
SELECT 'Demo_SubRecipe_Master' AS Source, *
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 56886;

-- 2. Check ALL ingredients in SubRecipeID 56886
SELECT 'Demo_SubRecipe_BOM - All Ingredients' AS Source, 
    sb.*,
    rp.Name AS IngredientName
FROM Demo_SubRecipe_BOM sb
LEFT JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE sb.SubRecipeID = 56886;

-- 3. Find Sub Batter Test by name
SELECT 'Find Sub Batter Test' AS Source, *
FROM Demo_SubRecipe_Master
WHERE Method LIKE '%batter%';

-- 4. Check if eggs (56850) is in ANY sub-recipe
SELECT 'Eggs in ANY SubRecipe' AS Source,
    sb.SubRecipeID,
    sm.Method,
    sb.IngredientID,
    sb.CostPerUnit,
    sb.Quantity
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_SubRecipe_Master sm ON sb.SubRecipeID = sm.SubRecipeID
WHERE sb.IngredientID = 56850;
