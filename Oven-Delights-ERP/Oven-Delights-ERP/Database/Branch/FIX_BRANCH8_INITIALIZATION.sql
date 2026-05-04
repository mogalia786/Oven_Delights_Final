-- =============================================
-- FIX BRANCH 8: Initialize Products, Prices, and Stock
-- =============================================

PRINT '========================================';
PRINT 'FIXING BRANCH 8 INITIALIZATION';
PRINT '========================================';
PRINT '';

-- First, check if the stored procedure exists
IF OBJECT_ID('sp_InitializeBranchProducts', 'P') IS NULL
BEGIN
    PRINT '❌ ERROR: sp_InitializeBranchProducts does not exist!';
    PRINT 'Please run sp_InitializeBranchProducts_FINAL.sql first';
    RETURN;
END

-- Check current state
PRINT 'CURRENT STATE:';
PRINT '----------------------------------------';

SELECT 
    'Demo_Retail_Product' AS TableName,
    COUNT(*) AS RecordCount
FROM Demo_Retail_Product
WHERE BranchID = 8;

SELECT 
    'Demo_Retail_Price' AS TableName,
    COUNT(*) AS RecordCount
FROM Demo_Retail_Price
WHERE BranchID = 8;

SELECT 
    'Demo_Retail_Stock' AS TableName,
    COUNT(*) AS RecordCount
FROM Demo_Retail_Stock
WHERE BranchID = 8 OR BranchID IS NULL;

PRINT '';
PRINT 'RUNNING sp_InitializeBranchProducts for Branch 8...';
PRINT '';

-- Execute the initialization
EXEC sp_InitializeBranchProducts @BranchID = 8;

PRINT '';
PRINT '========================================';
PRINT 'VERIFICATION:';
PRINT '========================================';

-- Verify products
DECLARE @ProductCount INT = (SELECT COUNT(*) FROM Demo_Retail_Product WHERE BranchID = 8);
DECLARE @PriceCount INT = (SELECT COUNT(*) FROM Demo_Retail_Price WHERE BranchID = 8);
DECLARE @StockCount INT = (SELECT COUNT(*) FROM Demo_Retail_Stock WHERE BranchID = 8 OR BranchID IS NULL);

PRINT 'Products in Demo_Retail_Product (BranchID=8): ' + CAST(@ProductCount AS NVARCHAR(10));
PRINT 'Prices in Demo_Retail_Price (BranchID=8): ' + CAST(@PriceCount AS NVARCHAR(10));
PRINT 'Stock records in Demo_Retail_Stock (BranchID=8): ' + CAST(@StockCount AS NVARCHAR(10));

IF @ProductCount = 0
BEGIN
    PRINT '';
    PRINT '❌ WARNING: No products found in Demo_Retail_Product for Branch 8!';
    PRINT 'Checking Products master table...';
    
    SELECT 
        COUNT(*) AS MasterProductCount,
        SUM(CASE WHEN ItemType IN ('internal', 'external', 'Manufactured') THEN 1 ELSE 0 END) AS RetailProducts,
        SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProducts
    FROM Products;
END
ELSE
BEGIN
    PRINT '';
    PRINT '✅ SUCCESS: Branch 8 has been initialized!';
    
    -- Show sample data
    PRINT '';
    PRINT 'SAMPLE DATA (First 10 products):';
    PRINT '----------------------------------------';
    
    SELECT TOP 10
        drp.ProductID,
        drp.SKU,
        drp.Name,
        drp.Category,
        drp.ProductType,
        drp.BranchID,
        price.SellingPrice,
        stock.QtyOnHand
    FROM Demo_Retail_Product drp
    LEFT JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID AND price.BranchID = 8
    LEFT JOIN Demo_Retail_Stock stock ON stock.VariantID = drp.ProductID AND (stock.BranchID = 8 OR stock.BranchID IS NULL)
    WHERE drp.BranchID = 8
        AND drp.IsActive = 1
    ORDER BY drp.SKU;
END

PRINT '';
PRINT '========================================';
PRINT 'BRANCH 8 FIX COMPLETE!';
PRINT '========================================';
