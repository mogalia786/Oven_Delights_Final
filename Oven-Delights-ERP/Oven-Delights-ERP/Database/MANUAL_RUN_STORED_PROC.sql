-- Manually update eggs price and run stored procedure to test if it works
-- Using ProductID 56850 (XFA-EGG-KGR) which is in SubRecipeID 57008

-- Step 1: Update eggs price in Demo_Retail_Product
UPDATE Demo_Retail_Product
SET AverageCost = 65.00,
    LastPaidPrice = 65.00
WHERE ProductID = 56850
AND BranchID = 6;

-- Step 2: Run the stored procedure
EXEC sp_RecalculateAllCosts;

-- Step 3: Check results
SELECT 'After Manual Update - Demo_Retail_Product' AS Source, ProductID, Name, SKU, AverageCost, LastPaidPrice
FROM Demo_Retail_Product
WHERE ProductID = 56850 AND BranchID = 6;

SELECT 'After Manual Update - Demo_SubRecipe_Ingredients' AS Source, si.IngredientLineID, si.IngredientID, rp.Name, si.CostPerUnit, si.Quantity, si.TotalCost
FROM Demo_SubRecipe_Ingredients si
INNER JOIN Demo_Retail_Product rp ON si.IngredientID = rp.ProductID AND rp.BranchID = 6
WHERE si.IngredientID = 56850 AND si.SubRecipeID = 57008;

SELECT 'After Manual Update - Demo_SubRecipe_Master' AS Source, SubRecipeID, Method, TotalCost, BatchQty
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 57008;
