-- Check if Americano BOM was created with correct BatchYieldQty
SELECT 
    'BOMHeader for Americano' AS Info,
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty,
    bh.YieldUoM,
    bh.IsActive
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
WHERE p.Name LIKE '%Americano%'
ORDER BY bh.BOMID DESC;

-- Check BOMItems for Americano
SELECT 
    'BOMItems for Americano' AS Info,
    bi.BOMItemID,
    bi.BOMID,
    bi.LineNumber,
    bi.ComponentType,
    CASE 
        WHEN bi.RawMaterialID IS NOT NULL THEN rm.MaterialName
        WHEN bi.ComponentProductID IS NOT NULL THEN p.Name
        ELSE bi.NonStockDesc
    END AS ComponentName,
    bi.QuantityPerBatch,
    bi.UoM
FROM dbo.BOMItems bi
INNER JOIN dbo.BOMHeader bh ON bh.BOMID = bi.BOMID
INNER JOIN dbo.Demo_Retail_Product prod ON prod.ProductID = bh.ProductID
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = bi.RawMaterialID
LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = bi.ComponentProductID
WHERE prod.Name LIKE '%Americano%'
ORDER BY bi.BOMID, bi.LineNumber;
