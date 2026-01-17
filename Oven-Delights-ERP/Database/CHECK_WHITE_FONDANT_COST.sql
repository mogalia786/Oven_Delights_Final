-- Check if White Fondant has cost data stored

-- Check in Demo_SubRecipe_Master
SELECT 
    'Demo_SubRecipe_Master' AS TableName,
    srm.SubRecipeID,
    drp.Name AS SubRecipeName,
    srm.BatchQty,
    srm.TotalCost,
    srm.LastUpdated
FROM Demo_SubRecipe_Master srm
INNER JOIN Demo_Retail_Product drp ON srm.SubRecipeID = drp.ProductID
WHERE drp.Name LIKE '%White%Fondant%'
ORDER BY srm.LastUpdated DESC;

-- Check ingredients for White Fondant
SELECT 
    'Demo_SubRecipe_Ingredients' AS TableName,
    sri.SubRecipeID,
    drp_sub.Name AS SubRecipeName,
    sri.IngredientID,
    drp_ing.Name AS IngredientName,
    sri.Quantity,
    sri.UnitOfMeasure,
    sri.PackageSize,
    sri.CostPerUnit,
    (sri.Quantity * sri.CostPerUnit) AS LineCost
FROM Demo_SubRecipe_Ingredients sri
INNER JOIN Demo_Retail_Product drp_sub ON sri.SubRecipeID = drp_sub.ProductID
INNER JOIN Demo_Retail_Product drp_ing ON sri.IngredientID = drp_ing.ProductID
WHERE drp_sub.Name LIKE '%White%Fondant%';

-- Check Demo_Retail_Product cost
SELECT 
    'Demo_Retail_Product' AS TableName,
    ProductID,
    Name,
    Category,
    ProductType,
    ISNULL(AverageCost, 0) AS AverageCost,
    ISNULL(LastPaidPrice, 0) AS LastPaidPrice,
    LastUpdated
FROM Demo_Retail_Product
WHERE Name LIKE '%White%Fondant%';

-- Calculate what the cost SHOULD be
SELECT 
    'CALCULATED COST' AS Info,
    drp_sub.Name AS SubRecipeName,
    SUM(sri.Quantity * ISNULL(sri.CostPerUnit, 0)) AS CalculatedTotalCost,
    srm.BatchQty,
    CASE 
        WHEN ISNULL(srm.BatchQty, 0) > 0 
        THEN SUM(sri.Quantity * ISNULL(sri.CostPerUnit, 0)) / srm.BatchQty 
        ELSE 0 
    END AS CalculatedUnitCost
FROM Demo_SubRecipe_Ingredients sri
INNER JOIN Demo_Retail_Product drp_sub ON sri.SubRecipeID = drp_sub.ProductID
LEFT JOIN Demo_SubRecipe_Master srm ON sri.SubRecipeID = srm.SubRecipeID
WHERE drp_sub.Name LIKE '%White%Fondant%'
GROUP BY drp_sub.Name, srm.BatchQty;
