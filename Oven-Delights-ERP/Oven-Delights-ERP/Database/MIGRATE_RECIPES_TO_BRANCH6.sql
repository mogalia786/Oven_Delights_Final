-- Migrate existing recipes from Branch 1 to Branch 6 (master branch)
-- This updates Demo_ProductRecipe_Master to use Branch 6 ProductIDs instead of Branch 1

PRINT '=== Migrating recipes to Branch 6 (master branch) ==='
PRINT ''

-- Step 1: Show current state
PRINT 'Current recipes with Branch 1 ProductIDs:'
SELECT rm.ProductID AS OldProductID, p1.Name, p1.BranchID AS OldBranchID, p6.ProductID AS NewProductID
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p1 ON p1.ProductID = rm.ProductID
LEFT JOIN Demo_Retail_Product p6 ON p6.Name = p1.Name AND p6.BranchID = 6
WHERE p1.BranchID = 1
  AND rm.IsActive = 1;

PRINT ''
PRINT 'Updating recipes to use Branch 6 ProductIDs...'

-- Step 2: Update Demo_ProductRecipe_Master to use Branch 6 ProductIDs
UPDATE rm
SET rm.ProductID = p6.ProductID
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p1 ON p1.ProductID = rm.ProductID
INNER JOIN Demo_Retail_Product p6 ON p6.Name = p1.Name AND p6.BranchID = 6
WHERE p1.BranchID = 1
  AND rm.IsActive = 1;

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR) + ' recipe records'

-- Step 3: Update Demo_ProductRecipe_BOM to use Branch 6 ProductIDs
PRINT ''
PRINT 'Updating BOM records to use Branch 6 ProductIDs...'

UPDATE bom
SET bom.ProductID = p6.ProductID
FROM Demo_ProductRecipe_BOM bom
INNER JOIN Demo_Retail_Product p1 ON p1.ProductID = bom.ProductID
INNER JOIN Demo_Retail_Product p6 ON p6.Name = p1.Name AND p6.BranchID = 6
WHERE p1.BranchID = 1
  AND bom.IsActive = 1;

PRINT 'Updated ' + CAST(@@ROWCOUNT AS VARCHAR) + ' BOM records'

-- Step 4: Verify the migration
PRINT ''
PRINT '=== Verification: All recipes should now be on Branch 6 ==='
SELECT rm.ProductID, p.Name, p.BranchID, rm.BatchQty, rm.IsActive
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE rm.IsActive = 1
ORDER BY p.Name;

PRINT ''
PRINT '=== Migration complete! All recipes are now on Branch 6 (master branch) ==='
