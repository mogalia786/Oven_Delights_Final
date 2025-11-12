-- Simulate the exact POS query for BranchID 6
DECLARE @BranchID INT = 6;

SELECT 
    p.ProductID,
    p.SKU,
    p.Name AS ProductName,
    p.Category,
    v.VariantID,
    v.Barcode,
    pr.SellingPrice,
    pr.CostPrice,
    s.QtyOnHand,
    s.ReorderPoint,
    CASE WHEN s.QtyOnHand > 0 THEN 1 ELSE 0 END AS InStock
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Variant v ON p.ProductID = v.ProductID
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID 
    AND (pr.BranchID IS NULL OR pr.BranchID = @BranchID)
    AND pr.EffectiveFrom <= GETDATE()
    AND (pr.EffectiveTo IS NULL OR pr.EffectiveTo >= GETDATE())
LEFT JOIN Demo_Retail_Stock s ON v.VariantID = s.VariantID 
    AND s.BranchID = @BranchID
WHERE p.IsActive = 1 AND v.IsActive = 1 AND p.BranchID = @BranchID
ORDER BY p.Category, p.Name;

-- Check how many products have prices
SELECT 
    'Products with prices' AS Issue,
    COUNT(DISTINCT p.ProductID) AS Count
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE p.BranchID = 6;

-- Check how many products have NO prices
SELECT 
    'Products WITHOUT prices' AS Issue,
    COUNT(*) AS Count
FROM Demo_Retail_Product p
WHERE p.BranchID = 6
    AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = p.ProductID);

-- Check price records by branch
SELECT 
    BranchID,
    COUNT(*) AS PriceRecords
FROM Demo_Retail_Price
GROUP BY BranchID;

-- Sample products with all details
SELECT TOP 10
    p.ProductID,
    p.Code,
    p.Name,
    p.BranchID,
    p.IsActive,
    v.VariantID,
    v.IsActive AS VariantActive,
    pr.PriceID,
    pr.SellingPrice,
    s.StockID,
    s.QtyOnHand
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Variant v ON p.ProductID = v.ProductID
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID AND pr.BranchID = 6
LEFT JOIN Demo_Retail_Stock s ON v.VariantID = s.VariantID AND s.BranchID = 6
WHERE p.BranchID = 6
ORDER BY p.Code;
