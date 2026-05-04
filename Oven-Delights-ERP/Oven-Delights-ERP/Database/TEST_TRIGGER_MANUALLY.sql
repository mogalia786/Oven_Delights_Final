-- Manual test to verify trigger is working
-- This simulates what happens when you capture an invoice

-- Step 1: Check current egg price in BOM
SELECT 
    'BEFORE UPDATE' AS Stage,
    sb.IngredientID,
    rp.Name AS ProductName,
    sb.CostPerUnit AS BOM_CostPerUnit,
    rp.AverageCost AS Retail_AverageCost,
    rp.LastPaidPrice AS Retail_LastPaidPrice
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE rp.Name LIKE '%egg%'
AND sb.SubRecipeID IN (SELECT SubRecipeID FROM Demo_SubRecipe_Master WHERE Name LIKE '%Batter%');

-- Step 2: Manually update egg price (simulating invoice capture)
-- Replace @EggProductID and @BranchID with actual values
DECLARE @EggProductID INT = (SELECT TOP 1 ProductID FROM Demo_Retail_Product WHERE Name LIKE '%egg%');
DECLARE @BranchID INT = 1; -- Change to your current branch ID
DECLARE @NewPrice DECIMAL(18,6) = 55.50;

UPDATE Demo_Retail_Product
SET AverageCost = @NewPrice,
    LastPaidPrice = @NewPrice
WHERE ProductID = @EggProductID
AND BranchID = @BranchID;

-- Step 3: Check if BOM was updated by trigger
SELECT 
    'AFTER UPDATE' AS Stage,
    sb.IngredientID,
    rp.Name AS ProductName,
    sb.CostPerUnit AS BOM_CostPerUnit,
    rp.AverageCost AS Retail_AverageCost,
    rp.LastPaidPrice AS Retail_LastPaidPrice
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE rp.Name LIKE '%egg%'
AND sb.SubRecipeID IN (SELECT SubRecipeID FROM Demo_SubRecipe_Master WHERE Name LIKE '%Batter%');

-- Step 4: Check sub-recipe master total cost
SELECT 
    SubRecipeID,
    Name AS SubRecipeName,
    TotalCost,
    BatchQty
FROM Demo_SubRecipe_Master
WHERE Name LIKE '%Batter%';
