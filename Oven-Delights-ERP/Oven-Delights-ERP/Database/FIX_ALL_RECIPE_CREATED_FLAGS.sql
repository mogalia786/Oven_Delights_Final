-- Fix Recipe_Created flag for ALL products that have recipes in Demo_ProductRecipe_Master
-- This updates the flag across ALL branches for each product

PRINT 'Updating Recipe_Created flag for all products with recipes...'

-- Update Recipe_Created = 1 for all products that have a recipe in Demo_ProductRecipe_Master
UPDATE p
SET p.Recipe_Created = 1
FROM Demo_Retail_Product p
WHERE EXISTS (
    SELECT 1 
    FROM Demo_ProductRecipe_Master rm 
    WHERE rm.ProductID = p.ProductID 
      AND rm.IsActive = 1
)
AND (p.Recipe_Created IS NULL OR p.Recipe_Created = 0);

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR) + ' product records'

-- Verify the update
PRINT ''
PRINT '=== Products with Recipe_Created = 1 (after update) ==='
SELECT DISTINCT p.Name, COUNT(*) AS BranchCount
FROM Demo_Retail_Product p
WHERE p.Recipe_Created = 1
GROUP BY p.Name
ORDER BY p.Name;

PRINT ''
PRINT '=== Products with recipes but still missing Recipe_Created flag ==='
SELECT DISTINCT p.ProductID, p.Name, p.BranchID, p.Recipe_Created
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE rm.IsActive = 1
  AND (p.Recipe_Created IS NULL OR p.Recipe_Created = 0)
ORDER BY p.Name, p.BranchID;
