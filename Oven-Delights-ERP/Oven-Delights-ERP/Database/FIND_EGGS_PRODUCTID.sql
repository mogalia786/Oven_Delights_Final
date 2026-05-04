-- Find the actual ProductID for Eggs in the sub-recipe

-- Get all ingredients from the sub-recipe that shows in the screenshot
SELECT 
    sb.BOMLineID,
    sb.SubRecipeID,
    sb.IngredientID,
    rp.Name AS IngredientName,
    sb.CostPerUnit,
    sb.Quantity,
    sb.TotalCost
FROM Demo_SubRecipe_BOM sb
LEFT JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID AND rp.BranchID = 6
WHERE sb.SubRecipeID IN (
    SELECT SubRecipeID 
    FROM Demo_SubRecipe_Master 
    WHERE Method LIKE '%batter%'
)
ORDER BY sb.SubRecipeID, rp.Name;

-- Find ALL products named Eggs
SELECT 
    ProductID,
    Name,
    BranchID,
    AverageCost,
    LastPaidPrice
FROM Demo_Retail_Product
WHERE Name LIKE '%egg%'
AND BranchID = 6
ORDER BY Name;
