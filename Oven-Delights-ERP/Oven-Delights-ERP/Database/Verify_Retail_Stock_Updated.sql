-- Verify that Retail_Stock was updated with the BOM completion

SELECT 
    rs.StockID,
    rs.VariantID,
    rs.BranchID,
    rs.QtyOnHand,
    rv.ProductID,
    p.ProductName
FROM dbo.Retail_Stock rs
INNER JOIN dbo.Retail_Variant rv ON rs.VariantID = rv.VariantID
INNER JOIN dbo.Products p ON rv.ProductID = p.ProductID
WHERE rs.VariantID = 15 OR rv.ProductID = 12
ORDER BY rs.StockID DESC;

PRINT '';
PRINT '--- If you see ProductID=12 with QtyOnHand=20, it worked! ---';
