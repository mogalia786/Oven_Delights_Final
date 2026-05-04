-- Check the cost breakdown for Sub Batter Test (SubRecipeID = 57008)

-- 1. Check ingredients and their costs
SELECT 
    'Ingredients' AS Source,
    sri.IngredientLineID,
    sri.IngredientID,
    p.Name AS IngredientName,
    sri.Quantity,
    sri.UnitOfMeasure,
    sri.PackageSize,
    sri.CostPerUnit,
    (sri.Quantity * sri.CostPerUnit) AS TotalCost
FROM Demo_SubRecipe_Ingredients sri
INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID
WHERE sri.SubRecipeID = 57008
  AND sri.IsActive = 1
ORDER BY p.Name;

-- 2. Check total cost in Demo_SubRecipe_Master
SELECT 
    'Sub-Recipe Master' AS Source,
    SubRecipeID,
    Method,
    BatchQty,
    TotalCost,
    (TotalCost / NULLIF(BatchQty, 0)) AS CostPerUnit
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 57008;

-- 3. Check sum of ingredient costs (should match TotalCost in master)
SELECT 
    'Calculated Total' AS Source,
    SUM(sri.Quantity * sri.CostPerUnit) AS CalculatedTotalCost
FROM Demo_SubRecipe_Ingredients sri
WHERE sri.SubRecipeID = 57008
  AND sri.IsActive = 1;

-- 4. Check prices in Demo_Retail_Price for each ingredient
SELECT 
    'Demo_Retail_Price' AS Source,
    rp.ProductID,
    p.Name AS ProductName,
    rp.BranchID,
    rp.CostPrice,
    rp.SellingPrice,
    rp.EffectiveFrom
FROM Demo_Retail_Price rp
INNER JOIN Demo_Retail_Product p ON rp.ProductID = p.ProductID
WHERE rp.ProductID IN (
    SELECT DISTINCT IngredientID 
    FROM Demo_SubRecipe_Ingredients 
    WHERE SubRecipeID = 57008
)
ORDER BY p.Name, rp.BranchID, rp.EffectiveFrom DESC;
