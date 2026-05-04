-- Check if trigger exists
SELECT 
    name AS TriggerName,
    is_disabled AS IsDisabled,
    OBJECT_NAME(parent_id) AS TableName
FROM sys.triggers
WHERE name = 'trg_AutoUpdateRecipeCosts_OnProductPriceChange';

-- Check current egg price in Demo_Retail_Product
SELECT 
    ProductID,
    Name AS ProductName,
    BranchID,
    AverageCost,
    LastPaidPrice,
    CurrentStock
FROM Demo_Retail_Product
WHERE Name LIKE '%egg%'
ORDER BY BranchID;

-- Check egg price in Demo_SubRecipe_BOM for Sub Batter Test
SELECT 
    sb.BOMLineID,
    sb.SubRecipeID,
    sr.Name AS SubRecipeName,
    sb.IngredientID,
    rp.Name AS ProductName,
    sb.Quantity,
    sb.CostPerUnit,
    sb.TotalCost,
    rp.AverageCost AS CurrentRetailPrice,
    rp.LastPaidPrice AS CurrentLastPaidPrice
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_SubRecipe_Master sr ON sb.SubRecipeID = sr.SubRecipeID
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE sr.Name LIKE '%Batter%'
AND rp.Name LIKE '%egg%'
ORDER BY sb.SubRecipeID;

-- Check Sub-Recipe Master total cost
SELECT 
    SubRecipeID,
    Name AS SubRecipeName,
    TotalCost,
    BatchQty
FROM Demo_SubRecipe_Master
WHERE Name LIKE '%Batter%';
