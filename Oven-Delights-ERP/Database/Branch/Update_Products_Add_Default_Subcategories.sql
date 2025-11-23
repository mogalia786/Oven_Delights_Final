-- =============================================
-- Update Products table with default SubcategoryID based on CategoryID
-- This assigns a default subcategory to products that have NULL SubcategoryID
-- =============================================

-- Step 1: Check current state
SELECT 'Before Update' AS Stage;
SELECT 
    CategoryID,
    COUNT(*) AS ProductCount,
    SUM(CASE WHEN SubcategoryID IS NULL THEN 1 ELSE 0 END) AS NullSubcategoryCount
FROM Products
GROUP BY CategoryID
ORDER BY CategoryID;

-- Step 2: Get available subcategories per category
SELECT 'Available Subcategories per Category' AS Info;
SELECT 
    c.CategoryID,
    c.CategoryName,
    s.SubcategoryID,
    s.SubcategoryName
FROM Categories c
LEFT JOIN Subcategories s ON s.CategoryID = c.CategoryID
ORDER BY c.CategoryID, s.SubcategoryID;

-- Step 3: Update Products with default SubcategoryID
-- This uses the FIRST (MIN) SubcategoryID for each CategoryID
BEGIN TRANSACTION;

UPDATE p
SET p.SubcategoryID = (
    SELECT MIN(s.SubcategoryID)
    FROM Subcategories s
    WHERE s.CategoryID = p.CategoryID
)
FROM Products p
WHERE p.SubcategoryID IS NULL
    AND EXISTS (
        SELECT 1 FROM Subcategories s 
        WHERE s.CategoryID = p.CategoryID
    );

-- Show what was updated
SELECT 'After Update' AS Stage;
SELECT 
    CategoryID,
    COUNT(*) AS ProductCount,
    SUM(CASE WHEN SubcategoryID IS NULL THEN 1 ELSE 0 END) AS NullSubcategoryCount,
    SUM(CASE WHEN SubcategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithSubcategoryCount
FROM Products
GROUP BY CategoryID
ORDER BY CategoryID;

-- Verify sample products
SELECT TOP 20
    ProductID,
    ProductCode,
    ProductName,
    CategoryID,
    SubcategoryID,
    ItemType
FROM Products
ORDER BY CategoryID, ProductCode;

-- Commit if everything looks good
-- COMMIT TRANSACTION;
-- Or rollback if there are issues
-- ROLLBACK TRANSACTION;

PRINT 'Review the results above. If correct, uncomment COMMIT TRANSACTION and run again.';
