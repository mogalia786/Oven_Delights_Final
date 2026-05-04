-- Sync existing RetailStock quantities to Demo_Retail_Product.CurrentStock
-- This fixes products that were already completed but POS shows 0

UPDATE p
SET p.CurrentStock = ISNULL(rs.Quantity, 0)
FROM dbo.Demo_Retail_Product p
INNER JOIN dbo.RetailStock rs ON rs.ProductID = p.ProductID
WHERE p.BranchID = rs.BranchID
  AND ISNULL(p.CurrentStock, 0) <> ISNULL(rs.Quantity, 0);

-- Show what was updated
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.BranchID,
    p.CurrentStock AS NewCurrentStock,
    rs.Quantity AS RetailStockQuantity
FROM dbo.Demo_Retail_Product p
INNER JOIN dbo.RetailStock rs ON rs.ProductID = p.ProductID
WHERE p.BranchID = rs.BranchID
ORDER BY p.Name;

PRINT 'Synced existing stock quantities to Demo_Retail_Product.CurrentStock';
