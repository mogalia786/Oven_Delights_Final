-- Quick fix: Manually update all sub-recipe BOM costs to match current retail prices
-- Run this after capturing invoices to sync prices immediately

-- Update all sub-recipe BOM ingredient costs to match current retail prices
UPDATE sb
SET sb.CostPerUnit = ISNULL(rp.AverageCost, rp.LastPaidPrice)
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE rp.BranchID = 1; -- Change to your current branch ID

-- Recalculate all sub-recipe master total costs
UPDATE sm
SET sm.TotalCost = (
    SELECT SUM(sb.TotalCost)
    FROM Demo_SubRecipe_BOM sb
    WHERE sb.SubRecipeID = sm.SubRecipeID
)
FROM Demo_SubRecipe_Master sm;

-- Update all product BOM costs for direct ingredients
UPDATE pb
SET pb.CostPerUnit = ISNULL(rp.AverageCost, rp.LastPaidPrice)
FROM Demo_Product_BOM pb
INNER JOIN Demo_Retail_Product rp ON pb.ComponentID = rp.ProductID
WHERE pb.ComponentType = 'Ingredient'
AND rp.BranchID = 1; -- Change to your current branch ID

-- Update all product BOM costs for sub-recipes
UPDATE pb
SET pb.CostPerUnit = sm.TotalCost / sm.BatchQty
FROM Demo_Product_BOM pb
INNER JOIN Demo_SubRecipe_Master sm ON pb.ComponentID = sm.SubRecipeID
WHERE pb.ComponentType = 'SubRecipe';

-- Recalculate all product recipe master total costs
UPDATE pm
SET pm.TotalCost = (
    SELECT SUM(pb.TotalCost)
    FROM Demo_Product_BOM pb
    WHERE pb.ProductID = pm.ProductID
)
FROM Demo_Product_Recipe_Master pm;

PRINT 'All sub-recipe and product costs updated successfully!';

-- Verify the update for eggs in Sub Batter Test
SELECT 
    'VERIFICATION' AS Stage,
    sr.Name AS SubRecipeName,
    rp.Name AS ProductName,
    sb.Quantity,
    sb.CostPerUnit AS BOM_Cost,
    rp.AverageCost AS Retail_Cost,
    sb.TotalCost AS Line_Total
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_SubRecipe_Master sr ON sb.SubRecipeID = sr.SubRecipeID
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE sr.Name LIKE '%Batter%'
AND rp.Name LIKE '%egg%';
