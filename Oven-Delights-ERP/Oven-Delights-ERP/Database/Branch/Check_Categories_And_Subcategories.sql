-- =============================================
-- Check Categories and Subcategories structure
-- To map Excel category names to IDs
-- =============================================

-- Step 1: Show all Categories
SELECT 'Categories Table' AS Info;
SELECT 
    CategoryID,
    CategoryName,
    Description,
    IsActive
FROM Categories
ORDER BY CategoryID;

-- Step 2: Show all Subcategories with their parent Category
SELECT 'Subcategories Table' AS Info;
SELECT 
    s.SubcategoryID,
    s.SubcategoryName,
    s.CategoryID,
    c.CategoryName AS ParentCategory,
    s.IsActive
FROM Subcategories s
LEFT JOIN Categories c ON s.CategoryID = c.CategoryID
ORDER BY s.CategoryID, s.SubcategoryID;

-- Step 3: Count products per category in Products table
SELECT 'Products per Category' AS Info;
SELECT 
    p.CategoryID,
    c.CategoryName,
    COUNT(*) AS ProductCount
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY p.CategoryID, c.CategoryName
ORDER BY p.CategoryID;

-- Step 4: Sample products with category info
SELECT 'Sample Products with Categories' AS Info;
SELECT TOP 20
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.CategoryID,
    c.CategoryName,
    p.SubcategoryID,
    s.SubcategoryName,
    p.ItemType
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Subcategories s ON p.SubcategoryID = s.SubcategoryID
ORDER BY p.CategoryID, p.ProductCode;

-- Step 5: Check for common category names from Excel
SELECT 'Matching Excel Category Names' AS Info;
SELECT 
    CategoryID,
    CategoryName
FROM Categories
WHERE CategoryName IN (
    'packaging',
    'sweets',
    'Wedding Cakes',
    'Consumables'
)
ORDER BY CategoryName;

-- Step 6: Check for common subcategory names from Excel
SELECT 'Matching Excel Subcategory Names' AS Info;
SELECT 
    s.SubcategoryID,
    s.SubcategoryName,
    s.CategoryID,
    c.CategoryName AS ParentCategory
FROM Subcategories s
LEFT JOIN Categories c ON s.CategoryID = c.CategoryID
WHERE s.SubcategoryName IN (
    'packaging',
    'sweet',
    'Wedding Cakes'
)
ORDER BY s.SubcategoryName;
