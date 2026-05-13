-- Copy Sub Dough - Dhall Roti sub-recipe from Branch 1 (60714) to Branch 6 (60718)

-- 1. Copy the master record
INSERT INTO Demo_SubRecipe_Master (SubRecipeID, Method, BatchQty, TotalCost, IsActive, CreatedBy, CreatedDate)
SELECT 
    60718 AS SubRecipeID,  -- Branch 6's ProductID
    Method,
    BatchQty,
    TotalCost,
    IsActive,
    CreatedBy,
    GETDATE() AS CreatedDate
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 60714;  -- Branch 1's ProductID

-- 2. Copy the ingredients
INSERT INTO Demo_SubRecipe_Ingredients (SubRecipeID, IngredientID, Quantity, UnitOfMeasure, PackageSize, CostPerUnit, IsActive, CreatedDate)
SELECT 
    60718 AS SubRecipeID,  -- Branch 6's ProductID
    IngredientID,
    Quantity,
    UnitOfMeasure,
    PackageSize,
    CostPerUnit,
    IsActive,
    GETDATE() AS CreatedDate
FROM Demo_SubRecipe_Ingredients
WHERE SubRecipeID = 60714;  -- Branch 1's ProductID

-- 3. Verify the copy
SELECT 
    sr.SubRecipeID,
    p.Name,
    p.BranchID,
    sr.BatchQty,
    sr.TotalCost
FROM Demo_SubRecipe_Master sr
INNER JOIN Demo_Retail_Product p ON sr.SubRecipeID = p.ProductID
WHERE sr.SubRecipeID IN (60714, 60718)
ORDER BY p.BranchID;
