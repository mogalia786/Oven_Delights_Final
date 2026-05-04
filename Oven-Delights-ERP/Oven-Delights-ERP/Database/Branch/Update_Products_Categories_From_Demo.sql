-- =============================================
-- Update Products table with CategoryID and SubcategoryID from Demo_Retail_Product
-- Products table schema:
--   - CategoryID (INT, FK to Categories)
--   - SubcategoryID (INT, FK to Subcategories)
--   - ItemType (NVARCHAR(20)) - 'Finished' or 'SemiFinished'
-- =============================================

-- Step 1: Check current state
SELECT 'Products Table - Current State' AS Info;
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN CategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithCategory,
    SUM(CASE WHEN SubcategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithSubcategory
FROM Products;

-- Step 2: Show mapping between Demo_Retail_Product and Products
SELECT 'Mapping Check' AS Info;
SELECT TOP 10
    drp.ProductID,
    drp.SKU,
    drp.Name,
    drp.CategoryID AS Demo_CategoryID,
    drp.SubcategoryID AS Demo_SubcategoryID,
    drp.ProductType AS Demo_ProductType,
    p.ProductID AS Products_ProductID,
    p.ProductCode,
    p.ProductName,
    p.CategoryID AS Products_CategoryID,
    p.SubcategoryID AS Products_SubcategoryID,
    p.ItemType AS Products_ItemType
FROM Demo_Retail_Product drp
LEFT JOIN Products p ON p.ProductID = drp.ProductID
WHERE drp.IsActive = 1;

-- Step 3: Check if Categories and Subcategories tables exist and have data
SELECT 'Categories Table' AS Info;
SELECT CategoryID, CategoryName FROM Categories ORDER BY CategoryID;

SELECT 'Subcategories Table' AS Info;
SELECT SubcategoryID, CategoryID, SubcategoryName FROM Subcategories ORDER BY CategoryID, SubcategoryID;

-- Step 4: Check CategoryID and SubcategoryID distribution in Demo_Retail_Product
SELECT 'Demo CategoryID Distribution' AS Info;
SELECT CategoryID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY CategoryID
ORDER BY CategoryID;

SELECT 'Demo SubcategoryID Distribution' AS Info;
SELECT SubcategoryID, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY SubcategoryID
ORDER BY SubcategoryID;

-- Step 5: Update Products table with CategoryID, SubcategoryID, and ItemType from Demo_Retail_Product
BEGIN TRANSACTION;

UPDATE p
SET 
    p.CategoryID = drp.CategoryID,
    p.SubcategoryID = drp.SubcategoryID,
    p.ItemType = CASE 
        WHEN drp.ProductType = 'Internal' THEN 'Finished'
        WHEN drp.ProductType = 'External' THEN 'Finished'
        ELSE 'Finished'
    END
FROM Products p
INNER JOIN Demo_Retail_Product drp ON drp.ProductID = p.ProductID
WHERE drp.IsActive = 1;

PRINT 'Products updated: ' + CAST(@@ROWCOUNT AS VARCHAR);

-- Step 6: Verify the update
SELECT 'Products Table - After Update' AS Info;
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN CategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithCategory,
    SUM(CASE WHEN SubcategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithSubcategory
FROM Products;

-- Show sample of updated products
SELECT TOP 20
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.CategoryID,
    c.CategoryName,
    p.SubcategoryID,
    sc.SubcategoryName,
    p.ItemType
FROM Products p
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
LEFT JOIN Subcategories sc ON sc.SubcategoryID = p.SubcategoryID
ORDER BY p.ProductID;

-- If everything looks good, commit. Otherwise, rollback.
-- COMMIT TRANSACTION;
ROLLBACK TRANSACTION; -- Remove this line and uncomment COMMIT when ready
