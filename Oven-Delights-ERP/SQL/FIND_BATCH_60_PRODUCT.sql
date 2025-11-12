-- Find the product with BatchYield = 60 and 60L milk
SELECT 
    r.RecipeID,
    r.ProductID,
    p.Name AS ProductName,
    r.RecipeName,
    r.BatchYield,
    r.BatchYieldUoM
FROM dbo.Recipe r
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = r.ProductID
WHERE r.BatchYield = 60 AND r.IsActive = 1;

-- Check its ingredients
SELECT 
    ri.RecipeIngredientID,
    ri.IngredientName,
    rm.MaterialName,
    ri.Quantity,
    ri.UoM
FROM dbo.RecipeIngredient ri
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID
WHERE ri.RecipeID IN (SELECT RecipeID FROM dbo.Recipe WHERE BatchYield = 60 AND IsActive = 1);

-- Check its BOM
SELECT 
    'BOM for BatchYield=60 product' AS Info,
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty,
    bh.YieldUoM
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
INNER JOIN dbo.Recipe r ON r.ProductID = bh.ProductID
WHERE r.BatchYield = 60 AND bh.IsActive = 1;
