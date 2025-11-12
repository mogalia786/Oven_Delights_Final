-- =============================================
-- VERIFY RAW MATERIALS TABLE HAS SUB-RECIPES
-- =============================================

-- Step 1: Check all MaterialType values
PRINT '=== ALL MATERIAL TYPES IN RAWMATERIALS ==='
SELECT 
    MaterialType,
    COUNT(*) AS Count
FROM RawMaterials
GROUP BY MaterialType
ORDER BY MaterialType
GO

-- Step 2: Show sample sub-recipes
PRINT ''
PRINT '=== SAMPLE SUB-RECIPES IN RAWMATERIALS ==='
SELECT TOP 20
    MaterialID,
    MaterialCode,
    MaterialName,
    MaterialType,
    CurrentStock,
    BaseUnit
FROM RawMaterials
WHERE MaterialType LIKE '%recipe%'
   OR MaterialType LIKE '%sub%'
   OR MaterialType LIKE '%assembly%'
ORDER BY MaterialName
GO

-- Step 3: Check if any recipes are missing from RawMaterials
PRINT ''
PRINT '=== RECIPES IN RECIPE TABLE BUT NOT IN RAWMATERIALS ==='
SELECT 
    r.RecipeID,
    r.RecipeName,
    r.ProductID,
    'Missing from RawMaterials' AS Issue
FROM Recipe r
WHERE NOT EXISTS (
    SELECT 1 FROM RawMaterials rm 
    WHERE rm.MaterialName = r.RecipeName
    OR rm.MaterialCode LIKE '%' + CAST(r.RecipeID AS VARCHAR) + '%'
)
ORDER BY r.RecipeName
GO

-- Step 4: Check RecipeIngredient table for sub-recipes
PRINT ''
PRINT '=== SUB-RECIPES USED IN OTHER RECIPES ==='
SELECT DISTINCT
    rm.MaterialID,
    rm.MaterialCode,
    rm.MaterialName,
    rm.MaterialType,
    COUNT(ri.RecipeID) AS UsedInRecipeCount
FROM RecipeIngredient ri
INNER JOIN RawMaterials rm ON rm.MaterialID = ri.MaterialID
WHERE rm.MaterialType LIKE '%recipe%'
   OR rm.MaterialType LIKE '%sub%'
GROUP BY rm.MaterialID, rm.MaterialCode, rm.MaterialName, rm.MaterialType
ORDER BY rm.MaterialName
GO

-- Step 5: Show complete structure
PRINT ''
PRINT '=== COMPLETE RAWMATERIALS STRUCTURE ==='
SELECT 
    MaterialType,
    COUNT(*) AS TotalCount,
    SUM(CASE WHEN CurrentStock > 0 THEN 1 ELSE 0 END) AS WithStock,
    SUM(CurrentStock) AS TotalStock
FROM RawMaterials
GROUP BY MaterialType
ORDER BY MaterialType
GO

-- Step 6: Check if MaterialType needs standardization
PRINT ''
PRINT '=== MATERIAL TYPES THAT NEED STANDARDIZATION ==='
SELECT DISTINCT
    MaterialType,
    COUNT(*) AS Count,
    CASE 
        WHEN MaterialType LIKE '%sub%' AND MaterialType LIKE '%recipe%' THEN 'Should be: Sub Recipe'
        WHEN MaterialType LIKE '%sub%' AND MaterialType LIKE '%assembly%' THEN 'Should be: Sub Recipe'
        ELSE 'OK'
    END AS Recommendation
FROM RawMaterials
WHERE MaterialType IS NOT NULL
GROUP BY MaterialType
ORDER BY MaterialType
GO
