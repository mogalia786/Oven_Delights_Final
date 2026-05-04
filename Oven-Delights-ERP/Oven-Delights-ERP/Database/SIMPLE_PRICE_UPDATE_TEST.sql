-- Simple test: Update egg price and see if trigger fires

-- Step 1: Check BEFORE state
SELECT 'BEFORE UPDATE - Retail Product' AS Stage, ProductID, Name, BranchID, AverageCost, LastPaidPrice
FROM Demo_Retail_Product
WHERE Name LIKE '%egg%';

SELECT 'BEFORE UPDATE - SubRecipe BOM' AS Stage, sb.IngredientID, sb.CostPerUnit, sb.TotalCost
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE rp.Name LIKE '%egg%';

-- Step 2: Update egg price (this should trigger the cascade)
UPDATE Demo_Retail_Product
SET AverageCost = 55.50,
    LastPaidPrice = 55.50
WHERE Name LIKE '%egg%'
AND BranchID = 1;

-- Step 3: Check AFTER state
SELECT 'AFTER UPDATE - Retail Product' AS Stage, ProductID, Name, BranchID, AverageCost, LastPaidPrice
FROM Demo_Retail_Product
WHERE Name LIKE '%egg%';

SELECT 'AFTER UPDATE - SubRecipe BOM' AS Stage, sb.IngredientID, sb.CostPerUnit, sb.TotalCost
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE rp.Name LIKE '%egg%';

-- Step 4: Check SubRecipe Master total cost
SELECT 'SubRecipe Master TotalCost' AS Stage, SubRecipeID, TotalCost, BatchQty
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 56886;
