-- =============================================
-- DIAGNOSE: Why product not appearing in Re-Order Book
-- =============================================

PRINT '🔍 Diagnosing missing product issue...';
PRINT '';

-- Step 1: Check BOMHeader for your new recipe
PRINT '1️⃣ Checking BOMHeader table:';
SELECT 
    bh.BOMID,
    bh.ProductID,
    p.ProductName,
    p.SKU,
    p.IsActive AS ProductActive,
    bh.IsActive AS BOMActive,
    bh.EffectiveFrom,
    bh.EffectiveTo,
    bh.BatchYieldQty,
    CASE 
        WHEN bh.EffectiveTo IS NULL OR bh.EffectiveTo >= CAST(GETDATE() AS DATE) THEN 'Valid'
        ELSE 'Expired'
    END AS BOMStatus
FROM BOMHeader bh
INNER JOIN Products p ON bh.ProductID = p.ProductID
WHERE bh.BOMID IN (9, 11, 12, 13, 14, 15, 16, 17, 18) -- Your visible BOMIDs
ORDER BY bh.BOMID DESC;

PRINT '';
PRINT '2️⃣ Checking BOMItems for BOMID 18 (your newest):';
SELECT 
    bi.BOMItemID,
    bi.BOMID,
    bi.LineNumber,
    bi.ComponentType,
    bi.RawMaterialID,
    rm.MaterialName AS RawMaterialName,
    bi.ComponentProductID,
    p.ProductName AS ComponentProductName,
    bi.QuantityPerBatch,
    bi.UoM
FROM BOMItems bi
LEFT JOIN RawMaterials rm ON bi.RawMaterialID = rm.MaterialID
LEFT JOIN Products p ON bi.ComponentProductID = p.ProductID
WHERE bi.BOMID = 18
ORDER BY bi.LineNumber;

PRINT '';
PRINT '3️⃣ Checking if product appears in Re-Order Book query:';
SELECT DISTINCT 
    p.ProductID, 
    p.ProductName, 
    p.SKU,
    CASE 
        WHEN EXISTS (SELECT 1 FROM BOMHeader bom WHERE bom.ProductID = p.ProductID AND bom.IsActive = 1) THEN 'Has BOM'
        ELSE 'No BOM'
    END AS BOMStatus,
    CASE 
        WHEN EXISTS (SELECT 1 FROM RecipeNode rn WHERE rn.ProductID = p.ProductID AND rn.ParentNodeID IS NOT NULL) THEN 'Has Recipe'
        ELSE 'No Recipe'
    END AS RecipeStatus
FROM Products p 
WHERE p.IsActive = 1 
  AND (EXISTS (SELECT 1 FROM BOMHeader bom WHERE bom.ProductID = p.ProductID AND bom.IsActive = 1) 
       OR EXISTS (SELECT 1 FROM RecipeNode rn WHERE rn.ProductID = p.ProductID AND rn.ParentNodeID IS NOT NULL))
ORDER BY p.ProductID DESC;

PRINT '';
PRINT '4️⃣ Checking RecipeNode for products:';
SELECT 
    rn.ProductID,
    p.ProductName,
    COUNT(*) AS IngredientCount
FROM RecipeNode rn
INNER JOIN Products p ON rn.ProductID = p.ProductID
WHERE rn.ParentNodeID IS NOT NULL
GROUP BY rn.ProductID, p.ProductName
ORDER BY rn.ProductID DESC;

PRINT '';
PRINT '5️⃣ Testing sp_MO_CreateBundleFromBOM for BOMID 18:';
PRINT 'Checking what ProductID is associated with BOMID 18...';
SELECT ProductID FROM BOMHeader WHERE BOMID = 18;

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 CHECKLIST:';
PRINT '✓ Is BOMHeader.IsActive = 1?';
PRINT '✓ Is BOMHeader.EffectiveTo NULL or future date?';
PRINT '✓ Is Products.IsActive = 1?';
PRINT '✓ Does BOMItems have both RawMaterial AND SemiFinished entries?';
PRINT '✓ Do SemiFinished items have their own BOMs?';
PRINT '═══════════════════════════════════════════════';
