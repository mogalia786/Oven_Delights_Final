-- =============================================
-- TEST: Check if Recipe query works
-- =============================================

PRINT '🔍 Testing Recipe Query...';
PRINT '';

-- Test the exact query that BOMEditorForm should use
DECLARE @pid INT = (SELECT TOP 1 ProductID FROM dbo.Recipe WHERE IsActive = 1);

PRINT 'Testing with ProductID: ' + CAST(@pid AS VARCHAR);
PRINT '';

-- This is the NEW query (from Recipe table)
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Recipe')
BEGIN
    PRINT '=== NEW RECIPE SYSTEM QUERY ===';
    SELECT 
        ri.LineNumber,
        CASE 
            WHEN ri.IngredientType = 'RawMaterial' THEN CONCAT(rm.MaterialCode, ' - ', rm.MaterialName)
            WHEN ri.IngredientType = 'SubAssembly' THEN sp.Name
            ELSE ri.IngredientName
        END AS ComponentName,
        ri.Quantity AS QuantityPerBatch,
        ri.UoM,
        ri.MaterialID AS RawMaterialID
    FROM dbo.Recipe r
    INNER JOIN dbo.RecipeIngredient ri ON ri.RecipeID = r.RecipeID
    LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = ri.MaterialID
    LEFT JOIN dbo.Demo_Retail_Product sp ON sp.ProductID = ri.SubAssemblyProductID
    WHERE r.ProductID = @pid AND r.IsActive = 1
    ORDER BY ri.LineNumber;
    
    DECLARE @NewCount INT = @@ROWCOUNT;
    PRINT '';
    PRINT '✅ Found ' + CAST(@NewCount AS VARCHAR) + ' ingredients from NEW system';
END

PRINT '';
PRINT '=== OLD RECIPENODE QUERY ===';
-- This is the OLD query (from RecipeNode)
SELECT ROW_NUMBER() OVER (ORDER BY ISNULL(rn.SortOrder,0), rn.NodeID) AS LineNumber,
       ISNULL(rn.ItemName, 'Component') AS ComponentName,
       ISNULL(rn.Qty, 0) AS QuantityPerBatch,
       ISNULL(u.UoMCode, '') AS UoM,
       rn.MaterialID AS RawMaterialID
FROM dbo.RecipeNode rn
LEFT JOIN dbo.UoM u ON u.UoMID = rn.UoMID
WHERE rn.ProductID = @pid
  AND rn.ParentNodeID IS NOT NULL
  AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL)
ORDER BY ISNULL(rn.SortOrder,0), rn.NodeID;

DECLARE @OldCount INT = @@ROWCOUNT;
PRINT '';
PRINT '✅ Found ' + CAST(@OldCount AS VARCHAR) + ' ingredients from OLD system';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT 'DIAGNOSIS:';
IF @NewCount > 0
BEGIN
    PRINT '✅ NEW system has data - BOM should work after rebuild';
END
ELSE IF @OldCount > 0
BEGIN
    PRINT '⚠️  Only OLD system has data - Need to migrate or rebuild app';
END
ELSE
BEGIN
    PRINT '❌ NO DATA in either system - Need to create recipe';
END
PRINT '═══════════════════════════════════════════════';
