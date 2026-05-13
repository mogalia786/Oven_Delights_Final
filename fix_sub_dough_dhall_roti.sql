-- Copy Sub Dough - Dhall Roti sub-recipe from Branch 1 (60714) to Branch 6 (60718)
-- This will make it appear in components dropdown for all branches

-- 1. Copy the master record
INSERT INTO Demo_SubRecipe_Master (SubRecipeID, Method, BatchQty, TotalCost, CreatedBy, CreatedDate)
SELECT 
    60718 AS SubRecipeID,  -- Branch 6's ProductID
    Method,
    BatchQty,
    TotalCost,
    CreatedBy,
    GETDATE() AS CreatedDate
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 60714;  -- Branch 1's ProductID

-- 2. Copy the BOM (ingredients)
INSERT INTO Demo_SubRecipe_BOM (SubRecipeID, IngredientID, Quantity, UnitOfMeasure, CostPerUnit, TotalCost, CreatedDate)
SELECT 
    60718 AS SubRecipeID,  -- Branch 6's ProductID
    IngredientID,
    Quantity,
    UnitOfMeasure,
    CostPerUnit,
    TotalCost,
    GETDATE() AS CreatedDate
FROM Demo_SubRecipe_BOM
WHERE SubRecipeID = 60714;  -- Branch 1's ProductID

-- 3. Verify the copy worked
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    sr.SubRecipeID,
    sr.BatchQty,
    sr.TotalCost,
    (SELECT COUNT(*) FROM Demo_SubRecipe_BOM WHERE SubRecipeID = p.ProductID) AS IngredientCount
FROM Demo_Retail_Product p
INNER JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID
WHERE p.Name = 'Sub Dough - Dhall Roti'
  AND p.BranchID IN (1, 6)
ORDER BY p.BranchID;

PRINT 'Sub Dough - Dhall Roti copied from Branch 1 to Branch 6 successfully!';
