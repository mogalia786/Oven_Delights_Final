-- Check for duplicate "Bar One Slice" products with different SKUs
SELECT 
    ProductID,
    SKU,
    Name,
    BranchID,
    CurrentStock,
    ProductType,
    IsActive,
    CreatedAt
FROM dbo.Demo_Retail_Product
WHERE Name LIKE '%Bar One Slice%'
ORDER BY ProductID;

-- Check which SKU the POS is actually using
SELECT 
    ProductID,
    SKU,
    Name,
    BranchID,
    CurrentStock
FROM dbo.Demo_Retail_Product
WHERE SKU = 'ACCEX-BOS-EAC' OR SKU = '200004008'
ORDER BY SKU;

-- Check RetailStock for both SKUs
SELECT 
    rs.ProductID,
    p.SKU,
    p.Name,
    rs.BranchID,
    rs.Quantity
FROM dbo.RetailStock rs
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = rs.ProductID
WHERE p.SKU IN ('ACCEX-BOS-EAC', '200004008')
ORDER BY p.SKU;
