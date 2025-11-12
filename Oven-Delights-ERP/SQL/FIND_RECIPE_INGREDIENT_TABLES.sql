-- Find all recipe-related tables
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Recipe%'
ORDER BY TABLE_NAME;

-- Check if there's a RecipeNode table
IF OBJECT_ID('dbo.RecipeNode', 'U') IS NOT NULL
BEGIN
    SELECT 'RecipeNode for Americano' AS Info, *
    FROM dbo.RecipeNode
    WHERE ProductID IN (SELECT ProductID FROM dbo.Demo_Retail_Product WHERE Name LIKE '%Americano%')
    ORDER BY NodeID;
END

-- Check BOMItems for Americano
SELECT 'BOMItems for Americano' AS Info,
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
