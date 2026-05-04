-- Fix BatchYieldQty for ALL products to match recipe batch size
-- This will fix the scaling calculation

-- First, check which products have incorrect BatchYieldQty
SELECT 'Products with incorrect BatchYieldQty' AS Info,
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty AS Current_BatchYieldQty,
    r.BatchYield AS Recipe_BatchYield,
    CASE 
        WHEN bh.BatchYieldQty <> r.BatchYield THEN 'MISMATCH!'
        ELSE 'OK'
    END AS Status
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
INNER JOIN dbo.Recipe r ON r.ProductID = bh.ProductID
WHERE bh.IsActive = 1 AND r.IsActive = 1
ORDER BY Status DESC, p.Name;

-- Update ALL BatchYieldQty from Recipe table
UPDATE bh
SET bh.BatchYieldQty = r.BatchYield
FROM dbo.BOMHeader bh
INNER JOIN dbo.Recipe r ON r.ProductID = bh.ProductID
WHERE bh.IsActive = 1 AND r.IsActive = 1 AND r.BatchYield IS NOT NULL;

PRINT 'Updated BatchYieldQty from Recipe.BatchYield for all products';

-- Show updated values
SELECT 'Updated Products' AS Info,
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchYieldQty AS Updated_BatchYieldQty
FROM dbo.BOMHeader bh
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = bh.ProductID
WHERE bh.IsActive = 1
ORDER BY bh.ProductID;
