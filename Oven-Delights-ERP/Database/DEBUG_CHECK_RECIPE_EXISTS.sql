-- =============================================
-- DEBUG: Check if recipe exists for Sub Batter - Madeira Slab
-- =============================================

PRINT '🔍 Checking for recipe data...';
PRINT '';

-- Find the product
SELECT 
    ProductID,
    Name,
    Category,
    ProductType,
    BranchID
FROM Demo_Retail_Product
WHERE Name LIKE '%Madeira%Slab%'
   OR Name LIKE '%Sub Batter%Madeira%';

PRINT '';
PRINT '--- Checking Demo_SubRecipe_Master ---';

-- Check if sub-recipe exists
SELECT 
    sr.SubRecipeID,
    p.Name AS SubRecipeName,
    sr.BatchQty,
    sr.TotalCost,
    sr.IsActive,
    sr.CreatedDate
FROM Demo_SubRecipe_Master sr
INNER JOIN Demo_Retail_Product p ON sr.SubRecipeID = p.ProductID
WHERE p.Name LIKE '%Madeira%Slab%'
   OR p.Name LIKE '%Sub Batter%Madeira%';

PRINT '';
PRINT '--- Checking Demo_SubRecipe_Ingredients ---';

-- Check if ingredients exist for this sub-recipe
SELECT 
    sri.IngredientLineID,
    p.Name AS SubRecipeName,
    ing.Name AS IngredientName,
    sri.Quantity,
    sri.UnitOfMeasure,
    sri.CostPerUnit,
    sri.TotalCost
FROM Demo_SubRecipe_Ingredients sri
INNER JOIN Demo_Retail_Product p ON sri.SubRecipeID = p.ProductID
INNER JOIN Demo_Retail_Product ing ON sri.IngredientID = ing.ProductID
WHERE p.Name LIKE '%Madeira%Slab%'
   OR p.Name LIKE '%Sub Batter%Madeira%';

PRINT '';
PRINT '--- Checking Demo_ProductRecipe_Master ---';

-- Check if it's a product recipe instead
SELECT 
    pr.ProductID,
    p.Name AS ProductName,
    pr.BatchQty,
    pr.TotalCost,
    pr.IsActive,
    pr.CreatedDate
FROM Demo_ProductRecipe_Master pr
INNER JOIN Demo_Retail_Product p ON pr.ProductID = p.ProductID
WHERE p.Name LIKE '%Madeira%Slab%'
   OR p.Name LIKE '%Sub Batter%Madeira%';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT 'If no results appear above, the recipe has not been created yet.';
PRINT 'Use the Create Sub-Recipe form to create the recipe first.';
PRINT '═══════════════════════════════════════════════';
