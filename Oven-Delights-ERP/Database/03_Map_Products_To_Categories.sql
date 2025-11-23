-- =============================================
-- MAP PRODUCTS TO CATEGORIES/SUBCATEGORIES
-- =============================================
-- Purpose: Update ProductCode, CategoryID, SubCategoryID in:
--          1. Demo_Retail_Product (POS)
--          2. Products (Master/ERP)
-- Mapping: Excel ITEM CCODE -> ProductCode
-- =============================================

USE [OvenDelightsERP];
GO

PRINT '========================================';
PRINT 'Mapping Products to Categories';
PRINT '========================================';
GO

-- =============================================
-- STEP 1: Create Staging Table for Excel Data
-- =============================================
IF OBJECT_ID('tempdb..#ExcelProducts') IS NOT NULL
    DROP TABLE #ExcelProducts;
GO

CREATE TABLE #ExcelProducts (
    ItemCode        NVARCHAR(50),
    Barcode         NVARCHAR(50),
    ItemDescription NVARCHAR(200),
    SubCategory     NVARCHAR(100),
    MainCategory    NVARCHAR(100),
    ItemCategory    NVARCHAR(20),  -- 'internal', 'external', 'Internal'
    UnitOfMeasure   NVARCHAR(20)
);
GO

PRINT 'Staging table created.';
PRINT 'Next: Import Excel data using BULK INSERT or Python script';
GO

-- =============================================
-- STEP 2: Update Demo_Retail_Product
-- =============================================
-- This will be run AFTER Excel data is loaded into #ExcelProducts

/*
-- Extract ProductCode from Code (remove branch prefix)
UPDATE Demo_Retail_Product
SET ProductCode = CASE 
    WHEN Code LIKE 'AC%' THEN SUBSTRING(Code, 3, LEN(Code))
    WHEN Code LIKE 'UM%' THEN SUBSTRING(Code, 3, LEN(Code))
    ELSE Code
END
WHERE ProductCode IS NULL AND Code IS NOT NULL;

PRINT 'ProductCode extracted from Code field';
GO

-- Map CategoryID and SubCategoryID
UPDATE drp
SET 
    drp.CategoryID = cat.CategoryID,
    drp.SubCategoryID = subcat.SubCategoryID
FROM Demo_Retail_Product drp
INNER JOIN #ExcelProducts excel ON drp.ProductCode = excel.ItemCode
INNER JOIN Categories cat ON LTRIM(RTRIM(cat.CategoryName)) = LTRIM(RTRIM(excel.MainCategory))
LEFT JOIN SubCategories subcat ON subcat.CategoryID = cat.CategoryID 
    AND LTRIM(RTRIM(subcat.SubCategoryName)) = LTRIM(RTRIM(excel.SubCategory))
WHERE drp.ProductCode IS NOT NULL;

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Demo_Retail_Product records updated with CategoryID/SubCategoryID';
GO
*/

-- =============================================
-- STEP 3: Update Products (Master Table)
-- =============================================
/*
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
BEGIN
    UPDATE p
    SET 
        p.CategoryID = cat.CategoryID,
        p.SubCategoryID = subcat.SubCategoryID
    FROM Products p
    INNER JOIN #ExcelProducts excel ON p.ProductCode = excel.ItemCode
    INNER JOIN Categories cat ON LTRIM(RTRIM(cat.CategoryName)) = LTRIM(RTRIM(excel.MainCategory))
    LEFT JOIN SubCategories subcat ON subcat.CategoryID = cat.CategoryID 
        AND LTRIM(RTRIM(subcat.SubCategoryName)) = LTRIM(RTRIM(excel.SubCategory))
    WHERE p.ProductCode IS NOT NULL;
    
    PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Products (Master) records updated with CategoryID/SubCategoryID';
END
ELSE
BEGIN
    PRINT 'Products table not found - skipping master table update';
END
GO
*/

-- =============================================
-- STEP 4: Verification Queries
-- =============================================
/*
PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';

-- Demo_Retail_Product summary
SELECT 
    c.CategoryName,
    sc.SubCategoryName,
    COUNT(*) AS ProductCount
FROM Demo_Retail_Product drp
LEFT JOIN Categories c ON c.CategoryID = drp.CategoryID
LEFT JOIN SubCategories sc ON sc.SubCategoryID = drp.SubCategoryID
GROUP BY c.CategoryName, sc.SubCategoryName
ORDER BY c.CategoryName, sc.SubCategoryName;

-- Products (Master) summary
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
BEGIN
    SELECT 
        c.CategoryName,
        sc.SubCategoryName,
        COUNT(*) AS ProductCount
    FROM Products p
    LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
    LEFT JOIN SubCategories sc ON sc.SubCategoryID = p.SubCategoryID
    GROUP BY c.CategoryName, sc.SubCategoryName
    ORDER BY c.CategoryName, sc.SubCategoryName;
END

PRINT '';
PRINT '========================================';
PRINT 'Mapping Complete!';
PRINT '========================================';
GO
*/
