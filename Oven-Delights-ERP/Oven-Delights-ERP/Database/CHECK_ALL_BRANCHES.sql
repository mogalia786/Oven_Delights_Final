-- Check eggs data across ALL branches

-- Check Demo_SubRecipe_BOM for Sub Batter Test across all branches
SELECT 
    'Demo_SubRecipe_BOM - All Data' AS Source,
    sb.BOMLineID,
    sb.SubRecipeID,
    sb.IngredientID,
    sb.CostPerUnit,
    sb.Quantity,
    sb.TotalCost
FROM Demo_SubRecipe_BOM sb
WHERE sb.SubRecipeID IN (
    SELECT SubRecipeID 
    FROM Demo_SubRecipe_Master 
    WHERE Method LIKE '%batter%'
);

-- Check eggs price in ALL branches
SELECT 
    'Demo_Retail_Product - Eggs All Branches' AS Source,
    ProductID,
    Name,
    BranchID,
    AverageCost,
    LastPaidPrice
FROM Demo_Retail_Product
WHERE ProductID = 56850
ORDER BY BranchID;

-- Check if Demo_SubRecipe_BOM has BranchID column
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_BOM'
ORDER BY ORDINAL_POSITION;
