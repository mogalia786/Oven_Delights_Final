-- Sync Demo_Retail_Stock.QtyOnHand to Demo_Retail_Product.CurrentStock
-- This will fix Bar One Slice and all other products

UPDATE p
SET p.CurrentStock = ISNULL(s.QtyOnHand, 0)
FROM dbo.Demo_Retail_Product p
INNER JOIN dbo.Retail_Variant v ON v.ProductID = p.ProductID
INNER JOIN dbo.Demo_Retail_Stock s ON s.VariantID = v.VariantID AND s.BranchID = p.BranchID
WHERE ISNULL(p.CurrentStock, 0) <> ISNULL(s.QtyOnHand, 0);

-- Show what was updated
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.BranchID,
    p.CurrentStock AS Updated_CurrentStock,
    s.QtyOnHand AS Demo_Retail_Stock_QtyOnHand
FROM dbo.Demo_Retail_Product p
INNER JOIN dbo.Retail_Variant v ON v.ProductID = p.ProductID
INNER JOIN dbo.Demo_Retail_Stock s ON s.VariantID = v.VariantID AND s.BranchID = p.BranchID
WHERE p.Name LIKE '%Bar One%'
ORDER BY p.Name;

PRINT 'Synced Demo_Retail_Stock.QtyOnHand to Demo_Retail_Product.CurrentStock';
