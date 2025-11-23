-- Test product search to see what's in the database

-- Search for "cake"
SELECT TOP 20 ProductID, ProductCode, ProductName, IsActive
FROM Products
WHERE (ProductName LIKE '%cake%' OR ProductCode LIKE '%cake%')
ORDER BY ProductName;

-- Search for "gat"
SELECT TOP 20 ProductID, ProductCode, ProductName, IsActive
FROM Products
WHERE (ProductName LIKE '%gat%' OR ProductCode LIKE '%gat%')
ORDER BY ProductName;

-- Show all active products (first 50)
SELECT TOP 50 ProductID, ProductCode, ProductName, IsActive
FROM Products
WHERE IsActive = 1
ORDER BY ProductName;

-- Count total products
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProducts,
    SUM(CASE WHEN IsActive = 0 THEN 1 ELSE 0 END) AS InactiveProducts
FROM Products;
