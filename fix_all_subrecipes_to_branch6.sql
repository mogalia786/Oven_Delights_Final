-- Copy all sub-recipes from Branch 1 to Branch 6
-- This fixes Sub Dough - Dhall Roti and Sub Test100

-- First, find the ProductIDs we need to copy
SELECT 
    p1.ProductID AS Branch1_ProductID,
    p6.ProductID AS Branch6_ProductID,
    p1.Name
FROM Demo_Retail_Product p1
INNER JOIN Demo_Retail_Product p6 ON p1.Name = p6.Name AND p6.BranchID = 6
INNER JOIN Demo_SubRecipe_Master sr ON p1.ProductID = sr.SubRecipeID
WHERE p1.BranchID = 1
  AND (p1.Category LIKE '%sub%recipe%' OR p1.Category LIKE '%subrecipe%')
  AND p1.Name IN ('Sub Dough - Dhall Roti', 'Sub Test100')
ORDER BY p1.Name;

-- Copy Sub Dough - Dhall Roti (60714 -> 60718)
INSERT INTO Demo_SubRecipe_Master (SubRecipeID, Method, BatchQty, TotalCost, CreatedBy, CreatedDate)
SELECT 
    60718 AS SubRecipeID,
    Method,
    BatchQty,
    TotalCost,
    CreatedBy,
    GETDATE() AS CreatedDate
FROM Demo_SubRecipe_Master
WHERE SubRecipeID = 60714
  AND NOT EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = 60718);

INSERT INTO Demo_SubRecipe_BOM (SubRecipeID, IngredientID, Quantity, UnitOfMeasure, CostPerUnit, TotalCost, CreatedDate)
SELECT 
    60718 AS SubRecipeID,
    IngredientID,
    Quantity,
    UnitOfMeasure,
    CostPerUnit,
    TotalCost,
    GETDATE() AS CreatedDate
FROM Demo_SubRecipe_BOM
WHERE SubRecipeID = 60714
  AND NOT EXISTS (SELECT 1 FROM Demo_SubRecipe_BOM WHERE SubRecipeID = 60718);

-- Find Sub Test100 ProductIDs
DECLARE @Test100_Branch1 INT, @Test100_Branch6 INT;

SELECT @Test100_Branch1 = ProductID FROM Demo_Retail_Product WHERE Name = 'Sub Test100' AND BranchID = 1;
SELECT @Test100_Branch6 = ProductID FROM Demo_Retail_Product WHERE Name = 'Sub Test100' AND BranchID = 6;

-- Copy Sub Test100 if both ProductIDs exist
IF @Test100_Branch1 IS NOT NULL AND @Test100_Branch6 IS NOT NULL
BEGIN
    -- Copy master record
    INSERT INTO Demo_SubRecipe_Master (SubRecipeID, Method, BatchQty, TotalCost, CreatedBy, CreatedDate)
    SELECT 
        @Test100_Branch6 AS SubRecipeID,
        Method,
        BatchQty,
        TotalCost,
        CreatedBy,
        GETDATE() AS CreatedDate
    FROM Demo_SubRecipe_Master
    WHERE SubRecipeID = @Test100_Branch1
      AND NOT EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @Test100_Branch6);

    -- Copy BOM
    INSERT INTO Demo_SubRecipe_BOM (SubRecipeID, IngredientID, Quantity, UnitOfMeasure, CostPerUnit, TotalCost, CreatedDate)
    SELECT 
        @Test100_Branch6 AS SubRecipeID,
        IngredientID,
        Quantity,
        UnitOfMeasure,
        CostPerUnit,
        TotalCost,
        GETDATE() AS CreatedDate
    FROM Demo_SubRecipe_BOM
    WHERE SubRecipeID = @Test100_Branch1
      AND NOT EXISTS (SELECT 1 FROM Demo_SubRecipe_BOM WHERE SubRecipeID = @Test100_Branch6);
      
    PRINT 'Sub Test100 copied from Branch 1 to Branch 6';
END
ELSE
BEGIN
    PRINT 'Sub Test100 not found on both branches - skipping';
END

-- Verify the results
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
WHERE p.Name IN ('Sub Dough - Dhall Roti', 'Sub Test100')
  AND p.BranchID IN (1, 6)
ORDER BY p.Name, p.BranchID;

PRINT 'All sub-recipes copied to Branch 6 successfully!';
