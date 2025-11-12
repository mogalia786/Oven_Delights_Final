-- Check if sp_MO_CreateBundleFromBOM exists and when it was last modified
SELECT 
    'Stored Procedure Info' AS Info,
    OBJECT_NAME(object_id) AS ProcedureName,
    create_date,
    modify_date
FROM sys.objects
WHERE name = 'sp_MO_CreateBundleFromBOM';

-- Check Americano Short BOM
SELECT 
    'Americano Short BOM' AS Info,
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty,
    bh.YieldUoM,
    r.BatchYield AS Recipe_BatchYield
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
LEFT JOIN dbo.Recipe r ON r.ProductID = bh.ProductID
WHERE p.Name LIKE '%Americano%Short%' AND bh.IsActive = 1;

-- Check BOMItems for Americano Short
SELECT 
    'Americano Short BOM Items' AS Info,
    bi.BOMItemID,
    bi.LineNumber,
    bi.ComponentType,
    CASE 
        WHEN bi.RawMaterialID IS NOT NULL THEN rm.MaterialName
        ELSE bi.NonStockDesc
    END AS ComponentName,
    bi.QuantityPerBatch,
    bi.UoM
FROM dbo.BOMItems bi
INNER JOIN dbo.BOMHeader bh ON bh.BOMID = bi.BOMID
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = bi.RawMaterialID
WHERE p.Name LIKE '%Americano%Short%' AND bh.IsActive = 1;
