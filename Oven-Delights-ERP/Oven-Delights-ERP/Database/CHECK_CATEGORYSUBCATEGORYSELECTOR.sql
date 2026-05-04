-- Check if CategorySubcategorySelector has SelectedSubcategoryId property
-- This will help us understand the control structure

SELECT 
    s.name AS SubcategoryName,
    s.SubcategoryID,
    c.CategoryName,
    c.CategoryID
FROM Subcategories s
INNER JOIN Categories c ON s.CategoryID = c.CategoryID
WHERE c.CategoryName LIKE '%buttercream%'
ORDER BY s.SubcategoryName;
