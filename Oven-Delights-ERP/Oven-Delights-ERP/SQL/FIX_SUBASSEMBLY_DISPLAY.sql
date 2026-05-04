-- =============================================
-- FIX SubAssembly Display Issue
-- =============================================

PRINT '🔍 Checking SubAssembly References...';
PRINT '';

-- Check for orphaned SubAssemblyProductID references
SELECT 
    ri.RecipeIngredientID,
    ri.RecipeID,
    r.RecipeName,
    ri.LineNumber,
    ri.IngredientType,
    ri.SubAssemblyProductID,
    ri.IngredientName,
    CASE 
        WHEN ri.SubAssemblyProductID IS NOT NULL AND p.ProductID IS NULL THEN '❌ ORPHANED - Product does not exist'
        WHEN ri.SubAssemblyProductID IS NOT NULL AND p.ProductID IS NOT NULL THEN '✅ Valid - ' + p.Name
        ELSE 'N/A'
    END AS Status
FROM dbo.RecipeIngredient ri
INNER JOIN dbo.Recipe r ON r.RecipeID = ri.RecipeID
LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = ri.SubAssemblyProductID
WHERE ri.IngredientType = 'SubAssembly'
ORDER BY r.RecipeName, ri.LineNumber;

PRINT '';
PRINT '=== Fixing Orphaned References ===';

-- Fix: Set IngredientName for SubAssemblies where the product doesn't exist
UPDATE ri
SET ri.IngredientType = 'Other',
    ri.IngredientName = COALESCE(ri.IngredientName, 'Unknown SubAssembly (ID: ' + CAST(ri.SubAssemblyProductID AS VARCHAR) + ')'),
    ri.SubAssemblyProductID = NULL
FROM dbo.RecipeIngredient ri
LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = ri.SubAssemblyProductID
WHERE ri.IngredientType = 'SubAssembly'
  AND ri.SubAssemblyProductID IS NOT NULL
  AND p.ProductID IS NULL;

DECLARE @FixedCount INT = @@ROWCOUNT;
PRINT '✅ Fixed ' + CAST(@FixedCount AS VARCHAR) + ' orphaned SubAssembly reference(s)';

-- Also fix: Populate IngredientName for valid SubAssemblies
UPDATE ri
SET ri.IngredientName = p.Name
FROM dbo.RecipeIngredient ri
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = ri.SubAssemblyProductID
WHERE ri.IngredientType = 'SubAssembly'
  AND ri.SubAssemblyProductID IS NOT NULL
  AND (ri.IngredientName IS NULL OR ri.IngredientName = '');

DECLARE @UpdatedCount INT = @@ROWCOUNT;
PRINT '✅ Updated ' + CAST(@UpdatedCount AS VARCHAR) + ' SubAssembly name(s)';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ FIX COMPLETE!';
PRINT '';
PRINT 'Try BOM Generate again - SubAssemblies should now display correctly';
PRINT '═══════════════════════════════════════════════';
