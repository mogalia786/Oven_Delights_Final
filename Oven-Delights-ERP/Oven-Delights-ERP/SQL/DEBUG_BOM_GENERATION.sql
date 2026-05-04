-- =============================================
-- DEBUG BOM GENERATION ISSUE
-- Run this to diagnose why BOM Generate button isn't populating items
-- =============================================

PRINT '🔍 Checking BOM Generation Data...';
PRINT '';

-- Step 1: Check if we have Internal products
PRINT '=== 1. INTERNAL PRODUCTS CHECK ===';
SELECT 
    ProductID,
    SKU,
    Name,
    ProductType,
    BranchID,
    IsActive
FROM dbo.Demo_Retail_Product
WHERE ProductType = 'Internal'
  AND ISNULL(IsActive, 1) = 1
ORDER BY Name;

PRINT '';
PRINT '=== 2. BOM HEADER CHECK ===';
-- Check if BOMHeader exists for these products
SELECT 
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty,
    bh.IsActive,
    bh.EffectiveFrom,
    bh.EffectiveTo
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
WHERE bh.IsActive = 1
  AND bh.EffectiveFrom <= CAST(GETDATE() AS DATE)
  AND (bh.EffectiveTo IS NULL OR bh.EffectiveTo >= CAST(GETDATE() AS DATE))
ORDER BY p.Name;

PRINT '';
PRINT '=== 3. BOM ITEMS CHECK ===';
-- Check if BOMItems exist for active BOMs
SELECT 
    bi.BOMID,
    p.Name AS ProductName,
    bi.LineNumber,
    bi.ComponentType,
    CASE 
        WHEN bi.NonStockDesc IS NOT NULL THEN bi.NonStockDesc
        WHEN bi.RawMaterialID IS NOT NULL THEN CONCAT(rm.MaterialCode, ' - ', rm.MaterialName)
        WHEN bi.ComponentProductID IS NOT NULL THEN cp.Name
        ELSE 'Component'
    END AS ComponentName,
    bi.QuantityPerBatch,
    bi.UoM
FROM dbo.BOMItems bi
INNER JOIN dbo.BOMHeader bh ON bh.BOMID = bi.BOMID
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = bi.RawMaterialID
LEFT JOIN dbo.Demo_Retail_Product cp ON cp.ProductID = bi.ComponentProductID
WHERE bh.IsActive = 1
ORDER BY p.Name, bi.LineNumber;

PRINT '';
PRINT '=== 4. RECIPE NODE CHECK (Build My Product) ===';
-- Check if RecipeNode has components for products without BOM
SELECT 
    rn.ProductID,
    p.Name AS ProductName,
    rn.NodeID,
    rn.NodeKind,
    rn.ItemName,
    rn.Qty,
    u.UoMCode,
    rn.MaterialID,
    rn.SubAssemblyProductID
FROM dbo.RecipeNode rn
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = rn.ProductID
LEFT JOIN dbo.UoM u ON u.UoMID = rn.UoMID
WHERE p.ProductType = 'Internal'
  AND rn.ParentNodeID IS NOT NULL
  AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL)
ORDER BY p.Name, ISNULL(rn.SortOrder, 0), rn.NodeID;

PRINT '';
PRINT '=== 5. PRODUCTS WITHOUT BOM OR RECIPE (DETAILED) ===';
-- Find products that have neither BOM nor RecipeNode with detailed info
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.ProductType,
    p.IsActive AS ProductActive,
    COUNT(DISTINCT bh.BOMID) AS BOMCount,
    COUNT(DISTINCT CASE WHEN bh.IsActive = 1 
                        AND bh.EffectiveFrom <= CAST(GETDATE() AS DATE)
                        AND (bh.EffectiveTo IS NULL OR bh.EffectiveTo >= CAST(GETDATE() AS DATE))
                   THEN bh.BOMID END) AS ActiveBOMCount,
    COUNT(DISTINCT rn.NodeID) AS RecipeNodeCount,
    COUNT(DISTINCT CASE WHEN rn.ParentNodeID IS NOT NULL 
                        AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL)
                   THEN rn.NodeID END) AS ValidRecipeNodeCount,
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN bh.IsActive = 1 
                                 AND bh.EffectiveFrom <= CAST(GETDATE() AS DATE)
                                 AND (bh.EffectiveTo IS NULL OR bh.EffectiveTo >= CAST(GETDATE() AS DATE))
                            THEN bh.BOMID END) > 0 THEN '✅ Has Active BOM'
        WHEN COUNT(DISTINCT bh.BOMID) > 0 THEN '⚠️ Has BOM but NOT ACTIVE or EXPIRED'
        WHEN COUNT(DISTINCT CASE WHEN rn.ParentNodeID IS NOT NULL 
                                 AND (rn.MaterialID IS NOT NULL OR rn.SubAssemblyProductID IS NOT NULL OR rn.ItemName IS NOT NULL)
                            THEN rn.NodeID END) > 0 THEN '✅ Has Recipe (No BOM yet)'
        WHEN COUNT(DISTINCT rn.NodeID) > 0 THEN '⚠️ Has RecipeNodes but NO COMPONENTS'
        ELSE '❌ NO BOM OR RECIPE'
    END AS Status
FROM dbo.Demo_Retail_Product p
LEFT JOIN dbo.BOMHeader bh ON bh.ProductID = p.ProductID
LEFT JOIN dbo.RecipeNode rn ON rn.ProductID = p.ProductID
WHERE p.ProductType = 'Internal'
  AND ISNULL(p.IsActive, 1) = 1
GROUP BY p.ProductID, p.SKU, p.Name, p.ProductType, p.IsActive
ORDER BY p.Name;

PRINT '';
PRINT '=== 6. RAW MATERIALS CHECK ===';
-- Check if we have raw materials available
SELECT TOP 10
    MaterialID,
    MaterialCode,
    MaterialName,
    IsActive
FROM dbo.RawMaterials
WHERE ISNULL(IsActive, 1) = 1
ORDER BY MaterialName;

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 DIAGNOSIS SUMMARY:';
PRINT '';
PRINT 'If Section 1 is empty: No Internal products exist';
PRINT 'If Section 2 is empty: No BOMHeader records exist';
PRINT 'If Section 3 is empty: BOMHeader exists but BOMItems are missing';
PRINT 'If Section 4 is empty: No RecipeNode components exist';
PRINT 'If Section 5 shows:';
PRINT '  - "NO BOM OR RECIPE": Product needs recipe in Build My Product';
PRINT '  - "Has BOM but NOT ACTIVE or EXPIRED": BOM EffectiveTo date has passed!';
PRINT '  - "Has RecipeNodes but NO COMPONENTS": Recipe exists but has no ingredients';
PRINT '';
PRINT '✅ SOLUTIONS:';
PRINT '';
PRINT 'For "Has BOM but NOT ACTIVE or EXPIRED":';
PRINT '  1. Check Section 2 for EffectiveTo dates';
PRINT '  2. Update BOMHeader: UPDATE dbo.BOMHeader SET EffectiveTo = NULL WHERE BOMID = [ID]';
PRINT '  3. Or set EffectiveTo to future date';
PRINT '';
PRINT 'For "NO BOM OR RECIPE":';
PRINT '  1. Go to Manufacturing > Build My Product';
PRINT '  2. Select the Internal product';
PRINT '  3. Add raw materials/ingredients to the recipe';
PRINT '  4. Save the recipe';
PRINT '  5. Then try BOM Generate again';
PRINT '';
PRINT 'For "Has RecipeNodes but NO COMPONENTS":';
PRINT '  1. Check Section 4 - ensure NodeKind is RawMaterial/SubAssembly/Component';
PRINT '  2. Ensure ParentNodeID is NOT NULL';
PRINT '  3. Re-save the recipe in Build My Product';
PRINT '═══════════════════════════════════════════════';
