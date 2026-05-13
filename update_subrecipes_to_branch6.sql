-- Update existing sub-recipes from Branch 1 to Branch 6
-- Changes SubRecipeID to use Branch 6's ProductID instead of Branch 1's

-- Sub Dough - Dhall Roti: Change from 60714 (Branch 1) to 60718 (Branch 6)
UPDATE Demo_SubRecipe_Master
SET SubRecipeID = 60718
WHERE SubRecipeID = 60714;

UPDATE Demo_SubRecipe_BOM
SET SubRecipeID = 60718
WHERE SubRecipeID = 60714;

-- Sub Test100: Find ProductIDs and update
DECLARE @Test100_Branch1 INT, @Test100_Branch6 INT;

SELECT @Test100_Branch1 = ProductID FROM Demo_Retail_Product WHERE Name = 'Sub Test100' AND BranchID = 1;
SELECT @Test100_Branch6 = ProductID FROM Demo_Retail_Product WHERE Name = 'Sub Test100' AND BranchID = 6;

IF @Test100_Branch1 IS NOT NULL AND @Test100_Branch6 IS NOT NULL
BEGIN
    UPDATE Demo_SubRecipe_Master
    SET SubRecipeID = @Test100_Branch6
    WHERE SubRecipeID = @Test100_Branch1;

    UPDATE Demo_SubRecipe_BOM
    SET SubRecipeID = @Test100_Branch6
    WHERE SubRecipeID = @Test100_Branch1;
    
    PRINT 'Sub Test100 updated to Branch 6';
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
    (SELECT COUNT(*) FROM Demo_SubRecipe_BOM WHERE SubRecipeID = p.ProductID) AS IngredientCount
FROM Demo_Retail_Product p
INNER JOIN Demo_SubRecipe_Master sr ON p.ProductID = sr.SubRecipeID
WHERE p.Name IN ('Sub Dough - Dhall Roti', 'Sub Test100')
  AND p.BranchID = 6
ORDER BY p.Name;

PRINT 'Sub-recipes updated to Branch 6 successfully!';
