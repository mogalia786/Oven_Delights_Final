-- Test BOM expansion for a specific product to see if sub-assemblies are expanded
-- Replace ProductID with your actual product (e.g., "16 Buttercream Eggless Bible Cake")

DECLARE @ProductID INT = 55930; -- Change this to your product ID
DECLARE @OutputQty DECIMAL(18,4) = 100.0;

-- Check if product has a BOM
SELECT 
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty,
    bh.IsActive,
    bh.EffectiveFrom,
    bh.EffectiveTo
FROM BOMHeader bh
INNER JOIN Demo_Retail_Product p ON p.ProductID = bh.ProductID
WHERE bh.ProductID = @ProductID
    AND bh.IsActive = 1
ORDER BY bh.EffectiveFrom DESC;

-- Check BOM items (components)
SELECT 
    bi.LineNumber,
    bi.ComponentType,
    CASE 
        WHEN bi.ComponentType = 'RawMaterial' THEN rm.MaterialName
        WHEN bi.ComponentType = 'Product' THEN p.Name
        ELSE bi.NonStockDesc
    END AS ComponentName,
    bi.QuantityPerBatch,
    bi.UoM,
    bi.RawMaterialID,
    bi.ComponentProductID,
    -- Check if component is itself a product with a BOM (sub-assembly)
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM BOMHeader bh2 
            WHERE bh2.ProductID = bi.ComponentProductID 
            AND bh2.IsActive = 1
        ) THEN 'YES - HAS SUB-BOM'
        ELSE 'NO'
    END AS IsSubAssembly
FROM BOMItems bi
LEFT JOIN RawMaterials rm ON rm.MaterialID = bi.RawMaterialID
LEFT JOIN Demo_Retail_Product p ON p.ProductID = bi.ComponentProductID
WHERE bi.BOMID IN (
    SELECT TOP 1 BOMID 
    FROM BOMHeader 
    WHERE ProductID = @ProductID 
    AND IsActive = 1 
    ORDER BY EffectiveFrom DESC
)
ORDER BY bi.LineNumber;

-- Check RecipeNode hierarchy (alternative structure)
SELECT 
    rn.NodeID,
    rn.ParentNodeID,
    rn.ProductID,
    rn.ItemName,
    rn.Qty,
    rn.MaterialID,
    rn.SubAssemblyProductID,
    rn.SortOrder,
    CASE 
        WHEN rn.SubAssemblyProductID IS NOT NULL THEN 'SUB-ASSEMBLY'
        WHEN rn.MaterialID IS NOT NULL THEN 'RAW MATERIAL'
        ELSE 'OTHER'
    END AS ItemType
FROM RecipeNode rn
WHERE rn.ProductID = @ProductID
ORDER BY rn.SortOrder, rn.NodeID;
