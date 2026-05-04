-- Check what's in the database after GRV capture

SELECT 'Demo_Retail_Product' AS Source, ProductID, Name, AverageCost, LastPaidPrice
FROM Demo_Retail_Product
WHERE ProductID = 56850 AND BranchID = 6;

SELECT 'Demo_SubRecipe_Ingredients' AS Source, IngredientLineID, IngredientID, CostPerUnit, Quantity, TotalCost
FROM Demo_SubRecipe_Ingredients
WHERE IngredientID = 56850 AND SubRecipeID = 57008;

SELECT 'Demo_SubRecipe_Master' AS Source, SubRecipeID, Method, TotalCost, BatchQty
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 57008;
