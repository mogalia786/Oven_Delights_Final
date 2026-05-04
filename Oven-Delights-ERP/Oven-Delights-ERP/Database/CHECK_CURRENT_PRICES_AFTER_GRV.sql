-- Check current state after GRV capture - EGGS ONLY (ProductID 56850)

-- 1. Check eggs price in Demo_Retail_Product
SELECT 
    'Demo_Retail_Product - Eggs' AS Source,
    ProductID,
    Name,
    BranchID,
    AverageCost,
    LastPaidPrice
FROM Demo_Retail_Product
WHERE ProductID = 56850
AND BranchID = 6;

-- 2. Check eggs price in Demo_SubRecipe_BOM for Sub Batter Test
SELECT 
    'Demo_SubRecipe_BOM - Eggs in Sub Batter Test' AS Source,
    sb.BOMLineID,
    sb.SubRecipeID,
    sm.Method AS SubRecipeName,
    sb.IngredientID,
    rp.Name AS IngredientName,
    sb.CostPerUnit AS BOM_CostPerUnit,
    sb.Quantity,
    sb.Quantity * sb.CostPerUnit AS TotalCost
FROM Demo_SubRecipe_BOM sb
INNER JOIN Demo_SubRecipe_Master sm ON sb.SubRecipeID = sm.SubRecipeID
INNER JOIN Demo_Retail_Product rp ON sb.IngredientID = rp.ProductID
WHERE sb.IngredientID = 56850
AND sm.SubRecipeID = 56886;

-- 3. Check Sub Batter Test total cost
SELECT 
    'Demo_SubRecipe_Master - Sub Batter Test' AS Source,
    SubRecipeID,
    Method,
    TotalCost,
    BatchQty,
    TotalCost / NULLIF(BatchQty, 0) AS CostPerUnit
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 56886;

-- 4. Check if stored procedure exists
SELECT 
    'Stored Procedure Check' AS Source,
    name AS ProcedureName,
    create_date,
    modify_date
FROM sys.procedures
WHERE name = 'sp_RecalculateAllCosts';
