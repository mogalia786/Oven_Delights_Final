-- =============================================
-- VERIFY BRANCH 8 SETUP IS COMPLETE
-- Check that all retail products have prices
-- =============================================

PRINT '========================================';
PRINT 'BRANCH 8 SETUP VERIFICATION';
PRINT '========================================';
PRINT '';

-- 1. Products Master Table by ItemType
PRINT '1. PRODUCTS MASTER TABLE BY ITEMTYPE:';
SELECT 
    ItemType,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0 THEN 1 ELSE 0 END) AS WithoutPrice
FROM Products
WHERE IsActive = 1
GROUP BY ItemType
ORDER BY ItemType;

PRINT '';

-- 2. Demo_Retail_Product for Branch 8
PRINT '2. DEMO_RETAIL_PRODUCT (BRANCH 8):';
SELECT 
    COUNT(*) AS TotalProducts,
    COUNT(DISTINCT SKU) AS UniqueSKUs
FROM Demo_Retail_Product
WHERE BranchID = 8 OR BranchID IS NULL;

PRINT '';

-- 3. Demo_Retail_Price for Branch 8
PRINT '3. DEMO_RETAIL_PRICE (BRANCH 8):';
SELECT 
    COUNT(*) AS TotalPrices,
    SUM(CASE WHEN SellingPrice > 0 THEN 1 ELSE 0 END) AS ValidPrices,
    SUM(CASE WHEN SellingPrice = 0 THEN 1 ELSE 0 END) AS ZeroPrices,
    MIN(SellingPrice) AS MinPrice,
    MAX(SellingPrice) AS MaxPrice
FROM Demo_Retail_Price
WHERE BranchID = 8;

PRINT '';

-- 4. Demo_Retail_Stock for Branch 8
PRINT '4. DEMO_RETAIL_STOCK (BRANCH 8):';
SELECT 
    COUNT(*) AS TotalStockRecords,
    SUM(CASE WHEN QtyOnHand > 0 THEN 1 ELSE 0 END) AS ItemsInStock,
    SUM(QtyOnHand) AS TotalQuantity
FROM Demo_Retail_Stock
WHERE BranchID = 8 OR BranchID IS NULL;

PRINT '';

-- 5. Retail products (internal/external) that should have prices
PRINT '5. RETAIL PRODUCTS PRICING STATUS:';
SELECT 
    'Retail Products (should have prices)' AS Category,
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN RecommendedSellingPrice > 0 THEN 1 ELSE 0 END) AS WithPrice,
    SUM(CASE WHEN RecommendedSellingPrice IS NULL OR RecommendedSellingPrice = 0 THEN 1 ELSE 0 END) AS WithoutPrice
FROM Products
WHERE IsActive = 1
    AND ItemType IN ('internal', 'external', 'Manufactured');

PRINT '';

-- 6. Check if POS will work - products with prices AND stock records
PRINT '6. POS READINESS CHECK:';
SELECT 
    'Products ready for POS' AS Status,
    COUNT(DISTINCT drp.SKU) AS ProductCount
FROM Demo_Retail_Product drp
INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID AND price.BranchID = 8
LEFT JOIN Demo_Retail_Stock stock ON stock.VariantID = drp.ProductID AND (stock.BranchID = 8 OR stock.BranchID IS NULL)
WHERE drp.IsActive = 1
    AND price.SellingPrice > 0;

PRINT '';

-- 7. Sample products ready for sale
PRINT '7. SAMPLE PRODUCTS READY FOR SALE (First 10):';
SELECT TOP 10
    drp.SKU,
    drp.Name,
    drp.Category,
    price.SellingPrice,
    ISNULL(stock.QtyOnHand, 0) AS QtyOnHand
FROM Demo_Retail_Product drp
INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID AND price.BranchID = 8
LEFT JOIN Demo_Retail_Stock stock ON stock.VariantID = drp.ProductID AND (stock.BranchID = 8 OR stock.BranchID IS NULL)
WHERE drp.IsActive = 1
    AND price.SellingPrice > 0
ORDER BY drp.SKU;

PRINT '';
PRINT '========================================';
PRINT 'SUMMARY:';
PRINT '========================================';

DECLARE @RetailProducts INT = (
    SELECT COUNT(*) FROM Products 
    WHERE IsActive = 1 AND ItemType IN ('internal', 'external', 'Manufactured')
);

DECLARE @RetailWithPrice INT = (
    SELECT COUNT(*) FROM Products 
    WHERE IsActive = 1 
        AND ItemType IN ('internal', 'external', 'Manufactured')
        AND RecommendedSellingPrice > 0
);

DECLARE @Branch8ValidPrices INT = (
    SELECT COUNT(*) FROM Demo_Retail_Price 
    WHERE BranchID = 8 AND SellingPrice > 0
);

DECLARE @POSReady INT = (
    SELECT COUNT(DISTINCT drp.SKU)
    FROM Demo_Retail_Product drp
    INNER JOIN Demo_Retail_Price price ON price.ProductID = drp.ProductID AND price.BranchID = 8
    WHERE drp.IsActive = 1 AND price.SellingPrice > 0
);

PRINT 'Retail Products (should be in POS): ' + CAST(@RetailProducts AS NVARCHAR(10));
PRINT 'Retail Products with prices: ' + CAST(@RetailWithPrice AS NVARCHAR(10));
PRINT 'Branch 8 valid prices: ' + CAST(@Branch8ValidPrices AS NVARCHAR(10));
PRINT 'Products ready for POS: ' + CAST(@POSReady AS NVARCHAR(10));

PRINT '';

IF @POSReady >= @RetailWithPrice
    PRINT '✅ BRANCH 8 IS READY FOR POS!';
ELSE
BEGIN
    PRINT '⚠️ WARNING: Some retail products missing prices';
    PRINT 'Missing: ' + CAST(@RetailWithPrice - @POSReady AS NVARCHAR(10)) + ' products';
END

PRINT '';
PRINT '========================================';
