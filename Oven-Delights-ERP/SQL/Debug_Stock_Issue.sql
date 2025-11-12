-- Check stock distribution by branch
SELECT 
    BranchID,
    COUNT(*) AS StockRecords
FROM Demo_Retail_Stock
GROUP BY BranchID
ORDER BY BranchID;

-- Check if variants are duplicated
SELECT 
    COUNT(*) AS TotalVariants,
    COUNT(DISTINCT ProductID) AS UniqueProducts
FROM Demo_Retail_Variant;

-- Check products by branch
SELECT 
    BranchID,
    COUNT(*) AS ProductCount
FROM Demo_Retail_Product
GROUP BY BranchID;

-- Check if stock is linked to wrong branches
SELECT TOP 20
    s.StockID,
    s.VariantID,
    s.BranchID AS StockBranchID,
    p.ProductID,
    p.Code,
    p.Name,
    p.BranchID AS ProductBranchID
FROM Demo_Retail_Stock s
INNER JOIN Demo_Retail_Variant v ON s.VariantID = v.VariantID
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
WHERE s.BranchID != p.BranchID
ORDER BY s.StockID;

-- Check total mismatches
SELECT 
    'Stock records with wrong BranchID' AS Issue,
    COUNT(*) AS Count
FROM Demo_Retail_Stock s
INNER JOIN Demo_Retail_Variant v ON s.VariantID = v.VariantID
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
WHERE s.BranchID != p.BranchID;
