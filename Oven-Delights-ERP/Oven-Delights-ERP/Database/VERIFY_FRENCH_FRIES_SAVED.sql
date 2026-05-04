-- Check if French Fries Cake was saved correctly
SELECT 
    ProductID,
    Name,
    Category,
    CategoryID,
    SubcategoryID,
    ProductType,
    BranchID,
    IsActive,
    CreatedAt
FROM Demo_Retail_Product
WHERE Name LIKE '%French Fries%'
ORDER BY CreatedAt DESC;

-- Check if it has a price record
SELECT 
    p.ProductID,
    p.Name,
    pr.BranchID,
    pr.SellingPrice,
    pr.CostPrice
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE p.Name LIKE '%French Fries%';
