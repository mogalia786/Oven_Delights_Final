-- Update Recipe_Created flag for Goolab Jumbu (ProductID 60544)
-- This should have been set when the recipe was created

UPDATE Demo_Retail_Product
SET Recipe_Created = 1
WHERE ProductID = 60544;

-- Verify the update
SELECT ProductID, Name, BranchID, Recipe_Created, ProductType, Category
FROM Demo_Retail_Product
WHERE ProductID = 60544;

PRINT 'Updated Recipe_Created flag for Goolab Jumbu (ProductID 60544)';
