-- Check if BOM scaling is working correctly
-- Example: Recipe for 60 units needs 6L milk, baker requests 30 units, should need 3L milk

DECLARE @ProductID INT = 56082; -- Bar One Slice (or any product)
DECLARE @RequestedQty DECIMAL(18,2) = 30;

-- Check BOMHeader
SELECT 
    'BOMHeader' AS Info,
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty,
    bh.IsActive
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
WHERE bh.ProductID = @ProductID AND bh.IsActive = 1;

-- Check BOMItems and calculate scaled quantities
SELECT 
    'BOMItems (Raw Calculation)' AS Info,
    bi.LineNumber,
    CASE 
        WHEN bi.RawMaterialID IS NOT NULL THEN CONCAT(rm.MaterialCode, ' - ', rm.MaterialName)
        WHEN bi.ComponentProductID IS NOT NULL THEN p.Name
        ELSE bi.NonStockDesc
    END AS ComponentName,
    bi.QuantityPerBatch AS RecipeQuantity,
    bh.BatchYieldQty AS RecipeBatchSize,
    @RequestedQty AS RequestedQty,
    bi.QuantityPerBatch * @RequestedQty / bh.BatchYieldQty AS ScaledQuantity,
    bi.UoM
FROM dbo.BOMItems bi
INNER JOIN dbo.BOMHeader bh ON bh.BOMID = bi.BOMID
LEFT JOIN dbo.RawMaterials rm ON rm.MaterialID = bi.RawMaterialID
LEFT JOIN dbo.Demo_Retail_Product p ON p.ProductID = bi.ComponentProductID
WHERE bh.ProductID = @ProductID AND bh.IsActive = 1
ORDER BY bi.LineNumber;

PRINT 'Formula: ScaledQuantity = (RecipeQuantity * RequestedQty) / RecipeBatchSize';
PRINT 'Example: If recipe needs 6L for 60 units, and you request 30 units:';
PRINT '         ScaledQuantity = (6 * 30) / 60 = 3L ✓';
