-- =============================================
-- DIAGNOSE WHY BRANCH 8 HAS NO DATA
-- =============================================

PRINT '========================================';
PRINT 'DIAGNOSTIC REPORT FOR BRANCH 8';
PRINT '========================================';
PRINT '';

-- 1. Check if stored procedure exists
PRINT '1. STORED PROCEDURE CHECK:';
PRINT '----------------------------------------';
IF OBJECT_ID('sp_InitializeBranchProducts', 'P') IS NOT NULL
    PRINT '✅ sp_InitializeBranchProducts EXISTS'
ELSE
    PRINT '❌ sp_InitializeBranchProducts DOES NOT EXIST';
PRINT '';

-- 2. Check Products master table
PRINT '2. PRODUCTS MASTER TABLE:';
PRINT '----------------------------------------';
IF OBJECT_ID('Products', 'U') IS NOT NULL
BEGIN
    SELECT 
        'Products' AS TableName,
        COUNT(*) AS TotalProducts,
        SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProducts,
        SUM(CASE WHEN ItemType = 'internal' THEN 1 ELSE 0 END) AS InternalProducts,
        SUM(CASE WHEN ItemType = 'external' THEN 1 ELSE 0 END) AS ExternalProducts,
        SUM(CASE WHEN ItemType = 'Manufactured' THEN 1 ELSE 0 END) AS ManufacturedProducts,
        SUM(CASE WHEN ItemType = 'RawMaterial' THEN 1 ELSE 0 END) AS RawMaterials,
        SUM(CASE WHEN CategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithCategory,
        SUM(CASE WHEN SubcategoryID IS NOT NULL THEN 1 ELSE 0 END) AS WithSubcategory
    FROM Products;
    
    PRINT '';
    PRINT 'Sample Products (First 5):';
    SELECT TOP 5
        ProductID,
        ProductCode,
        ProductName,
        ItemType,
        CategoryID,
        SubcategoryID,
        IsActive,
        RecommendedSellingPrice
    FROM Products
    WHERE IsActive = 1
    ORDER BY ProductID;
END
ELSE
    PRINT '❌ Products table DOES NOT EXIST';
PRINT '';

-- 3. Check Demo_Retail_Product
PRINT '3. DEMO_RETAIL_PRODUCT TABLE:';
PRINT '----------------------------------------';
IF OBJECT_ID('Demo_Retail_Product', 'U') IS NOT NULL
BEGIN
    SELECT 
        BranchID,
        COUNT(*) AS ProductCount,
        SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProducts
    FROM Demo_Retail_Product
    GROUP BY BranchID
    ORDER BY BranchID;
    
    PRINT '';
    PRINT 'Branch 8 Products:';
    SELECT COUNT(*) AS Branch8Products
    FROM Demo_Retail_Product
    WHERE BranchID = 8;
END
ELSE
    PRINT '❌ Demo_Retail_Product table DOES NOT EXIST';
PRINT '';

-- 4. Check Demo_Retail_Price
PRINT '4. DEMO_RETAIL_PRICE TABLE:';
PRINT '----------------------------------------';
IF OBJECT_ID('Demo_Retail_Price', 'U') IS NOT NULL
BEGIN
    SELECT 
        BranchID,
        COUNT(*) AS PriceCount,
        SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices
    FROM Demo_Retail_Price
    GROUP BY BranchID
    ORDER BY BranchID;
    
    PRINT '';
    PRINT 'Branch 8 Prices:';
    SELECT COUNT(*) AS Branch8Prices
    FROM Demo_Retail_Price
    WHERE BranchID = 8;
END
ELSE
    PRINT '❌ Demo_Retail_Price table DOES NOT EXIST';
PRINT '';

-- 5. Check Demo_Retail_Stock
PRINT '5. DEMO_RETAIL_STOCK TABLE:';
PRINT '----------------------------------------';
IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
BEGIN
    SELECT 
        BranchID,
        COUNT(*) AS StockRecords,
        SUM(CASE WHEN Quantity > 0 THEN 1 ELSE 0 END) AS ItemsInStock
    FROM Demo_Retail_Stock
    GROUP BY BranchID
    ORDER BY BranchID;
    
    PRINT '';
    PRINT 'Branch 8 Stock:';
    SELECT COUNT(*) AS Branch8StockRecords
    FROM Demo_Retail_Stock
    WHERE BranchID = 8;
END
ELSE
    PRINT '❌ Demo_Retail_Stock table DOES NOT EXIST';
PRINT '';

-- 6. Check Branches table
PRINT '6. BRANCHES TABLE:';
PRINT '----------------------------------------';
IF OBJECT_ID('Branches', 'U') IS NOT NULL
BEGIN
    SELECT 
        BranchID,
        BranchName,
        BranchPrefix,
        IsActive
    FROM Branches
    WHERE BranchID = 8;
    
    IF @@ROWCOUNT = 0
        PRINT '❌ Branch 8 does not exist in Branches table!';
    ELSE
        PRINT '✅ Branch 8 exists in Branches table';
END
ELSE
    PRINT '❌ Branches table DOES NOT EXIST';
PRINT '';

-- 7. Check Categories and Subcategories
PRINT '7. CATEGORIES & SUBCATEGORIES:';
PRINT '----------------------------------------';
IF OBJECT_ID('Categories', 'U') IS NOT NULL
BEGIN
    SELECT 
        'Categories' AS TableName,
        COUNT(*) AS TotalCount,
        SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveCount
    FROM Categories;
END
ELSE
    PRINT '❌ Categories table DOES NOT EXIST';

IF OBJECT_ID('Subcategories', 'U') IS NOT NULL
BEGIN
    SELECT 
        'Subcategories' AS TableName,
        COUNT(*) AS TotalCount,
        SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveCount
    FROM Subcategories;
END
ELSE
    PRINT '❌ Subcategories table DOES NOT EXIST';
PRINT '';

PRINT '========================================';
PRINT 'DIAGNOSTIC COMPLETE';
PRINT '========================================';
PRINT '';
PRINT 'NEXT STEPS:';
PRINT '1. If sp_InitializeBranchProducts does not exist, run: sp_InitializeBranchProducts_FINAL.sql';
PRINT '2. If Products table is empty, import products from CSV';
PRINT '3. If Branch 8 has no data, run: FIX_BRANCH8_INITIALIZATION.sql';
PRINT '';
