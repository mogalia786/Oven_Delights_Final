-- Update all existing BOM records with current cost prices from Demo_Retail_Price

PRINT '=== Step 1: Check current BOM costs before update ==='
SELECT 
    bom.BOMLineID,
    bom.ProductID,
    bom.ComponentID,
    p.Name AS ComponentName,
    bom.Quantity,
    bom.CostPerUnit AS OldCostPerUnit,
    ISNULL(rp.CostPrice, 0) AS CurrentCostPrice,
    (bom.Quantity * ISNULL(rp.CostPrice, 0)) AS NewTotalCost
FROM Demo_ProductRecipe_BOM bom
INNER JOIN Demo_Retail_Product p ON p.ProductID = bom.ComponentID
LEFT JOIN Demo_Retail_Price rp ON rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
WHERE bom.ComponentType != 'SubRecipe'
ORDER BY bom.ProductID, bom.ComponentID;

PRINT ''
PRINT '=== Step 2: Update BOM CostPerUnit for all non-SubRecipe components ==='
PRINT '(TotalCost will auto-update as it is a computed column)'
UPDATE bom
SET 
    bom.CostPerUnit = ISNULL(rp.CostPrice, 0)
FROM Demo_ProductRecipe_BOM bom
INNER JOIN Demo_Retail_Product p ON p.ProductID = bom.ComponentID
LEFT JOIN Demo_Retail_Price rp ON rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
WHERE bom.ComponentType != 'SubRecipe';

PRINT ''
PRINT '=== Step 3: Verify updated costs ==='
SELECT 
    bom.BOMLineID,
    bom.ProductID,
    bom.ComponentID,
    p.Name AS ComponentName,
    bom.Quantity,
    bom.CostPerUnit AS UpdatedCostPerUnit,
    bom.TotalCost AS UpdatedTotalCost
FROM Demo_ProductRecipe_BOM bom
INNER JOIN Demo_Retail_Product p ON p.ProductID = bom.ComponentID
WHERE bom.ComponentType != 'SubRecipe'
ORDER BY bom.ProductID, bom.ComponentID;

PRINT ''
PRINT '=== Step 4: Update Demo_ProductRecipe_Master TotalCost ==='
UPDATE rm
SET rm.TotalCost = (
    SELECT SUM(bom.TotalCost)
    FROM Demo_ProductRecipe_BOM bom
    WHERE bom.ProductID = rm.ProductID
)
FROM Demo_ProductRecipe_Master rm;

PRINT ''
PRINT '=== Step 5: Verify final recipe costs ==='
SELECT 
    rm.ProductID,
    p.Name AS ProductName,
    rm.TotalCost,
    rm.BatchQty,
    (rm.TotalCost / NULLIF(rm.BatchQty, 0)) AS CostPerUnit
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
ORDER BY p.Name;
