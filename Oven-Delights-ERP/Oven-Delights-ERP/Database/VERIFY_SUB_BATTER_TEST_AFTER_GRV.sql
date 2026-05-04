-- =============================================
-- Verify sub-recipe costs after GRV price change
-- This script checks if sp_RecalculateAllCosts updated the sub-recipe automatically
-- =============================================

-- SET THE SUBRECIPE ID HERE:
-- Sub-Batter Test (ProductID from Demo_Retail_Product)
DECLARE @SubRecipeID INT = 59988; -- Sub-Batter Test

PRINT '========================================';
PRINT 'SUB-RECIPE COST VERIFICATION';
PRINT '========================================';
PRINT '';

-- Get Sub-Recipe Master details
SELECT 
    'SUB-RECIPE MASTER' AS [Section],
    sm.SubRecipeID,
    sm.Method AS [SubRecipeName],
    sm.BatchQty,
    sm.TotalCost AS [Total Cost (from Master)],
    sm.TotalCost / NULLIF(sm.BatchQty, 0) AS [Cost Per Unit],
    sm.LastUpdated
FROM Demo_SubRecipe_Master sm
WHERE sm.SubRecipeID = @SubRecipeID;

PRINT '';
PRINT '----------------------------------------';
PRINT 'INGREDIENT LINE ITEMS';
PRINT '----------------------------------------';
PRINT '';

-- Get ingredient line items with current prices
SELECT 
    'INGREDIENT DETAILS' AS [Section],
    si.IngredientID,
    p.Name AS [Ingredient Name],
    si.Quantity,
    si.UnitOfMeasure,
    si.PackageSize,
    si.CostPerUnit AS [Cost Per Unit (in Sub-Recipe)],
    (si.Quantity * si.CostPerUnit) AS [Line Total],
    price.CostPrice AS [Current Price (Demo_Retail_Price)],
    p.AverageCost AS [Average Cost (Demo_Retail_Product)],
    p.LastPaidPrice AS [Last Paid Price (Demo_Retail_Product)]
FROM Demo_SubRecipe_Ingredients si
INNER JOIN Demo_Retail_Product p ON si.IngredientID = p.ProductID
LEFT JOIN Demo_Retail_Price price ON si.IngredientID = price.ProductID AND price.BranchID = 6
WHERE si.SubRecipeID = @SubRecipeID
AND p.BranchID = 6
ORDER BY si.IngredientID;

PRINT '';
PRINT '----------------------------------------';
PRINT 'COST SUMMARY';
PRINT '----------------------------------------';
PRINT '';

-- Calculate and compare totals
SELECT 
    'COST COMPARISON' AS [Section],
    sm.TotalCost AS [TotalCost from Master],
    (SELECT SUM(si.Quantity * si.CostPerUnit) 
     FROM Demo_SubRecipe_Ingredients si 
     WHERE si.SubRecipeID = @SubRecipeID) AS [Calculated from Line Items],
    CASE 
        WHEN sm.TotalCost = (SELECT SUM(si.Quantity * si.CostPerUnit) 
                             FROM Demo_SubRecipe_Ingredients si 
                             WHERE si.SubRecipeID = @SubRecipeID)
        THEN 'MATCH ✓'
        ELSE 'MISMATCH ✗'
    END AS [Status]
FROM Demo_SubRecipe_Master sm
WHERE sm.SubRecipeID = @SubRecipeID;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION COMPLETE';
PRINT '========================================';
