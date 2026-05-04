-- Check if Macaroni Cake product exists and is set up correctly

-- 1. Check if product exists in Demo_Retail_Product
SELECT 
    ProductID,
    SKU,
    Name,
    Category,
    ProductType,
    BranchID,
    IsActive,
    CurrentStock
FROM Demo_Retail_Product
WHERE Name LIKE '%macaroni%'
ORDER BY BranchID

-- 2. Check if product has price records
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    rp.CostPrice,
    rp.SellingPrice,
    rp.EffectiveFrom
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
WHERE p.Name LIKE '%macaroni%'
ORDER BY p.BranchID

-- 3. Check what the PO query would return (for Branch 1)
SELECT ProductID AS MaterialID, 
       ISNULL(Code, SKU) AS MaterialCode, 
       Name AS MaterialName, 
       0 AS AverageCost, 
       CASE WHEN ProductType = 'External' THEN 'EXT' ELSE 'RM' END AS ItemSource, 
       ISNULL(Category, 'Uncategorized') AS CategoryName 
FROM Demo_Retail_Product 
WHERE IsActive = 1 
  AND BranchID = 1
  AND Name LIKE '%macaroni%'
ORDER BY Name

-- 4. Check what the PO query would return (for HEAD OFFICE - BranchID 0)
SELECT MIN(ProductID) AS MaterialID, 
       MIN(ISNULL(Code, SKU)) AS MaterialCode, 
       Name AS MaterialName, 
       0 AS AverageCost, 
       CASE WHEN ProductType = 'External' THEN 'EXT' ELSE 'RM' END AS ItemSource, 
       ISNULL(MIN(Category), 'Uncategorized') AS CategoryName 
FROM Demo_Retail_Product 
WHERE IsActive = 1 
  AND Name LIKE '%macaroni%'
GROUP BY Name, ProductType 
ORDER BY Name

-- 5. Check if there are any NULL BranchIDs
SELECT COUNT(*) AS NullBranchCount
FROM Demo_Retail_Product
WHERE Name LIKE '%macaroni%' AND BranchID IS NULL

-- 6. Check all active products count per branch
SELECT BranchID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY BranchID
ORDER BY BranchID
