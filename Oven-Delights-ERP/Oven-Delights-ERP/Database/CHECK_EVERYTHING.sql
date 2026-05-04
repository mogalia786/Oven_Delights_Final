-- Check everything to diagnose the issue

-- 1. Check if stored procedure exists
SELECT OBJECT_ID('sp_RecalculateAllCosts', 'P') AS StoredProcExists;

-- 2. Check eggs price in Demo_Retail_Product
SELECT 'Demo_Retail_Product' AS Source, ProductID, Name, AverageCost, LastPaidPrice
FROM Demo_Retail_Product
WHERE ProductID = 56850 AND BranchID = 6;

-- 3. Check eggs price in Demo_SubRecipe_Ingredients
SELECT 'Demo_SubRecipe_Ingredients' AS Source, IngredientLineID, IngredientID, CostPerUnit, Quantity, TotalCost
FROM Demo_SubRecipe_Ingredients
WHERE IngredientID = 56850 AND SubRecipeID = 57008;

-- 4. Check Sub Batter Test total cost
SELECT 'Demo_SubRecipe_Master' AS Source, SubRecipeID, Method, TotalCost, BatchQty
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 57008;

-- 5. Manually run the stored procedure NOW
EXEC sp_RecalculateAllCosts;

-- 6. Check results AFTER running stored procedure
SELECT 'AFTER SP - Demo_Retail_Product' AS Source, ProductID, Name, AverageCost, LastPaidPrice
FROM Demo_Retail_Product
WHERE ProductID = 56850 AND BranchID = 6;

SELECT 'AFTER SP - Demo_SubRecipe_Ingredients' AS Source, IngredientLineID, IngredientID, CostPerUnit, Quantity, TotalCost
FROM Demo_SubRecipe_Ingredients
WHERE IngredientID = 56850 AND SubRecipeID = 57008;

SELECT 'AFTER SP - Demo_SubRecipe_Master' AS Source, SubRecipeID, Method, TotalCost, BatchQty
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 57008;
