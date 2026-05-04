-- =============================================
-- COMPLETE SETUP WORKFLOW
-- Run these steps in order to fix everything
-- =============================================

PRINT '========================================';
PRINT 'COMPLETE SETUP WORKFLOW';
PRINT '========================================';
PRINT '';
PRINT 'STEP 1: Update Products master table from MASTER_PRODUCT_LIST.csv';
PRINT '   File: UPDATE_PRODUCTS_FROM_MASTER_LIST.sql';
PRINT '   This populates prices in the Products master table';
PRINT '';
PRINT 'STEP 2: Clean up Demo_Retail_Product (remove raw materials)';
PRINT '   File: FIX_DEMO_RETAIL_PRODUCT_REMOVE_RAW_MATERIALS.sql';
PRINT '   This removes ingredients from retail tables';
PRINT '';
PRINT 'STEP 3: Update all existing branches with new prices';
PRINT '   File: UPDATE_ALL_BRANCHES_WITH_NEW_PRICES.sql';
PRINT '   This syncs prices from Products to all branches';
PRINT '';
PRINT 'STEP 4: Deploy the new sp_CreateNewBranch procedure';
PRINT '   File: sp_CreateNewBranch_FINAL.sql';
PRINT '   This creates the one-click branch creation procedure';
PRINT '';
PRINT 'STEP 5: Test by creating a new branch';
PRINT '   EXEC sp_CreateNewBranch @BranchName = ''Test Branch'', @BranchPrefix = ''TST'', @CreatedBy = 1;';
PRINT '';
PRINT '========================================';
PRINT 'CURRENT STATUS CHECK';
PRINT '========================================';
PRINT '';

-- Check if Products table has prices
PRINT '1. Products master table pricing status:';
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice = 0 OR RecommendedSellingPrice IS NULL THEN 1 ELSE 0 END) AS WithoutPrice
FROM Products
WHERE IsActive = 1;

PRINT '';
PRINT '2. Products by ItemType:';
SELECT 
    ItemType,
    COUNT(*) AS Count,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice
FROM Products
WHERE IsActive = 1
GROUP BY ItemType
ORDER BY ItemType;

PRINT '';
PRINT '3. Demo_Retail_Product status:';
SELECT 
    COUNT(*) AS TotalRetailProducts,
    COUNT(DISTINCT SKU) AS UniqueSKUs
FROM Demo_Retail_Product
WHERE IsActive = 1;

PRINT '';
PRINT '4. Branch prices status:';
SELECT 
    b.BranchID,
    b.BranchName,
    COUNT(price.ProductID) AS TotalPrices,
    SUM(CASE WHEN price.SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN price.SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices
FROM Branches b
LEFT JOIN Demo_Retail_Price price ON price.BranchID = b.BranchID
WHERE b.IsActive = 1
GROUP BY b.BranchID, b.BranchName
ORDER BY b.BranchID;

PRINT '';
PRINT '========================================';
PRINT 'DIAGNOSIS:';
PRINT '========================================';
PRINT '';
PRINT 'If Products table has 0 prices: Run STEP 1 first!';
PRINT 'If Demo_Retail_Product has >1000 products: Run STEP 2!';
PRINT 'If branches have 0 prices: Run STEP 3!';
PRINT '';
