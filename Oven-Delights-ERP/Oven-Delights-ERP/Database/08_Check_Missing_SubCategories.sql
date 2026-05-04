-- Check for missing subcategories issue
-- This will help identify why some subcategories aren't showing

USE [Oven_Delights_Main];
GO

PRINT '========================================';
PRINT 'INVESTIGATING MISSING SUBCATEGORIES';
PRINT '========================================';
GO

-- 1. Check total subcategories in SubCategories table
PRINT 'Total SubCategories in table:';
SELECT COUNT(*) AS TotalSubCategories FROM SubCategories;
GO

-- 2. Check subcategories with products
PRINT '';
PRINT 'SubCategories with products assigned:';
SELECT 
    sc.SubCategoryID,
    sc.SubCategoryName,
    c.CategoryName,
    COUNT(DISTINCT p.ProductID) AS ProductCount
FROM SubCategories sc
INNER JOIN Categories c ON c.CategoryID = sc.CategoryID
LEFT JOIN Demo_Retail_Product p ON p.SubCategoryID = sc.SubCategoryID AND p.IsActive = 1
GROUP BY sc.SubCategoryID, sc.SubCategoryName, c.CategoryName
ORDER BY c.CategoryName, sc.SubCategoryName;
GO

-- 3. Check subcategories WITHOUT products (these won't show in v_POS_SubCategories)
PRINT '';
PRINT 'SubCategories WITHOUT any products (will not appear in POS):';
SELECT 
    sc.SubCategoryID,
    sc.SubCategoryName,
    c.CategoryName
FROM SubCategories sc
INNER JOIN Categories c ON c.CategoryID = sc.CategoryID
WHERE NOT EXISTS (
    SELECT 1 FROM Demo_Retail_Product p 
    WHERE p.SubCategoryID = sc.SubCategoryID 
    AND p.IsActive = 1
)
ORDER BY c.CategoryName, sc.SubCategoryName;
GO

-- 4. Check products with NULL subcategory
PRINT '';
PRINT 'Products with CategoryID but NULL SubCategoryID:';
SELECT 
    c.CategoryName,
    COUNT(*) AS ProductsWithoutSubCategory
FROM Demo_Retail_Product p
INNER JOIN Categories c ON c.CategoryID = p.CategoryID
WHERE p.SubCategoryID IS NULL
  AND p.IsActive = 1
GROUP BY c.CategoryName
ORDER BY ProductsWithoutSubCategory DESC;
GO

-- 5. Check v_POS_SubCategories view
PRINT '';
PRINT 'SubCategories visible in POS (from v_POS_SubCategories):';
SELECT 
    CategoryName,
    SubCategoryName,
    ProductCount
FROM v_POS_SubCategories
ORDER BY CategoryName, SubCategoryName;
GO

PRINT '';
PRINT '========================================';
PRINT 'ANALYSIS COMPLETE';
PRINT '========================================';
GO
