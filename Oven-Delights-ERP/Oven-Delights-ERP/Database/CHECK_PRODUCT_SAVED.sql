-- Check the product you just saved to see what Category value was stored
SELECT TOP 5
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
ORDER BY CreatedAt DESC;

-- Also check what category names exist in Categories table
SELECT CategoryID, CategoryName, IsActive
FROM Categories
WHERE IsActive = 1
ORDER BY CategoryName;
