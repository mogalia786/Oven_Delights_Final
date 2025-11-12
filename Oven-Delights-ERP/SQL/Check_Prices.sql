-- Check prices in Demo_Retail_Price
SELECT 
    BranchID,
    COUNT(*) AS PriceRecords,
    AVG(SellingPrice) AS AvgPrice,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice
FROM Demo_Retail_Price
GROUP BY BranchID;

-- Check sample prices for specific products
SELECT TOP 10
    p.Code,
    p.Name,
    p.BranchID AS ProductBranchID,
    pr.BranchID AS PriceBranchID,
    pr.SellingPrice,
    pr.CostPrice
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE p.BranchID = 6
ORDER BY p.Code;

-- Check what the view is returning
SELECT TOP 10
    ItemCode,
    ProductName,
    BranchID,
    SellingPrice,
    CostPrice
FROM vw_POS_Products
WHERE BranchID = 6
ORDER BY ItemCode;

-- Check for price mismatches (product BranchID != price BranchID)
SELECT 
    'Prices with wrong BranchID' AS Issue,
    COUNT(*) AS Count
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE p.BranchID != pr.BranchID;

-- Show specific examples of wrong prices
SELECT TOP 10
    p.Code,
    p.Name,
    p.BranchID AS ProductBranch,
    pr.BranchID AS PriceBranch,
    pr.SellingPrice
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE p.BranchID != pr.BranchID;
