-- =============================================
-- CREATE POS VIEW FOR CATEGORY NAVIGATION
-- =============================================
-- Purpose: Create view for POS to load products with category/subcategory
-- Filters: Only POS-visible products (internal/external, not Internal)
-- =============================================

USE [Oven_Delights_Main];
GO

PRINT '========================================';
PRINT 'Creating POS View';
PRINT '========================================';
GO

-- =============================================
-- View: v_POS_Products
-- =============================================
IF OBJECT_ID('dbo.v_POS_Products', 'V') IS NOT NULL
    DROP VIEW dbo.v_POS_Products;
GO

CREATE VIEW dbo.v_POS_Products
AS
SELECT 
    p.ProductID,
    p.Code,
    p.ProductCode,
    p.Name AS ProductName,
    p.Description,
    p.SKU,
    p.BranchID,
    c.CategoryID,
    c.CategoryName,
    c.DisplayOrder AS CategoryDisplayOrder,
    sc.SubCategoryID,
    sc.SubCategoryName,
    sc.DisplayOrder AS SubCategoryDisplayOrder,
    pr.SellingPrice,
    pr.CostPrice,
    s.QtyOnHand,
    v.VariantID,
    v.Barcode,
    p.IsActive,
    p.ProductType,
    -- Determine if product should show on POS
    CASE 
        WHEN p.Category IN ('ingredients', 'sub recipe', 'packaging') THEN 0
        WHEN p.Category LIKE '%Internal%' AND p.ProductType = 'Internal' THEN 0  -- Capital I = raw materials
        ELSE 1
    END AS ShowOnPOS
FROM Demo_Retail_Product p
LEFT JOIN Categories c ON c.CategoryID = p.CategoryID
LEFT JOIN SubCategories sc ON sc.SubCategoryID = p.SubCategoryID
LEFT JOIN Demo_Retail_Variant v ON v.ProductID = p.ProductID AND v.IsDefault = 1
LEFT JOIN Demo_Retail_Price pr ON pr.ProductID = p.ProductID
LEFT JOIN Demo_Retail_Stock s ON s.VariantID = v.VariantID AND s.BranchID = p.BranchID
WHERE p.IsActive = 1;
GO

PRINT 'Created v_POS_Products view';
GO

-- =============================================
-- View: v_POS_Categories
-- =============================================
IF OBJECT_ID('dbo.v_POS_Categories', 'V') IS NOT NULL
    DROP VIEW dbo.v_POS_Categories;
GO

CREATE VIEW dbo.v_POS_Categories
AS
SELECT DISTINCT
    c.CategoryID,
    c.CategoryName,
    c.DisplayOrder,
    COUNT(DISTINCT p.ProductID) AS ProductCount
FROM Categories c
INNER JOIN Demo_Retail_Product p ON p.CategoryID = c.CategoryID
WHERE p.IsActive = 1
  AND c.IsActive = 1
  AND p.Category NOT IN ('ingredients', 'sub recipe', 'packaging')
GROUP BY c.CategoryID, c.CategoryName, c.DisplayOrder;
GO

PRINT 'Created v_POS_Categories view';
GO

-- =============================================
-- View: v_POS_SubCategories
-- =============================================
IF OBJECT_ID('dbo.v_POS_SubCategories', 'V') IS NOT NULL
    DROP VIEW dbo.v_POS_SubCategories;
GO

CREATE VIEW dbo.v_POS_SubCategories
AS
SELECT DISTINCT
    sc.SubCategoryID,
    sc.CategoryID,
    sc.SubCategoryName,
    sc.DisplayOrder,
    c.CategoryName,
    COUNT(DISTINCT p.ProductID) AS ProductCount
FROM SubCategories sc
INNER JOIN Categories c ON c.CategoryID = sc.CategoryID
INNER JOIN Demo_Retail_Product p ON p.SubCategoryID = sc.SubCategoryID
WHERE p.IsActive = 1
  AND sc.IsActive = 1
  AND c.IsActive = 1
  AND p.Category NOT IN ('ingredients', 'sub recipe', 'packaging')
GROUP BY sc.SubCategoryID, sc.CategoryID, sc.SubCategoryName, sc.DisplayOrder, c.CategoryName;
GO

PRINT 'Created v_POS_SubCategories view';
GO

PRINT '';
PRINT '========================================';
PRINT 'SUCCESS! POS Views Created';
PRINT '========================================';
PRINT 'Views available:';
PRINT '  - v_POS_Products';
PRINT '  - v_POS_Categories';
PRINT '  - v_POS_SubCategories';
PRINT '========================================';
GO
