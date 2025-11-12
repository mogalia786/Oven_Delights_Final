-- =============================================
-- POS DEMO TABLES - VERIFICATION QUERIES
-- =============================================
-- Purpose: Verify demo data and compare with production
-- Safe: Read-only queries
-- =============================================

USE [OvenDelightsERP];
GO

PRINT '========================================';
PRINT 'DEMO ENVIRONMENT VERIFICATION';
PRINT '========================================';
GO

-- =============================================
-- 1. Verify Demo Tables Exist
-- =============================================
PRINT '';
PRINT '1. Demo Tables Status:';
PRINT '----------------------------------------';
SELECT 
    TABLE_NAME,
    CASE 
        WHEN TABLE_NAME LIKE 'Demo_%' THEN '✓ Demo Table'
        ELSE 'Production Table'
    END AS TableType
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE 'Demo_%'
   OR TABLE_NAME LIKE 'Retail_%'
ORDER BY TABLE_NAME;
GO

-- =============================================
-- 2. Record Counts - Demo vs Production
-- =============================================
PRINT '';
PRINT '2. Record Counts (Demo vs Production):';
PRINT '----------------------------------------';
SELECT 
    'Products' AS TableName,
    (SELECT COUNT(*) FROM Demo_Retail_Product) AS DemoCount,
    (SELECT COUNT(*) FROM Retail_Product) AS ProductionCount;

SELECT 
    'Variants' AS TableName,
    (SELECT COUNT(*) FROM Demo_Retail_Variant) AS DemoCount,
    (SELECT COUNT(*) FROM Retail_Variant) AS ProductionCount;

SELECT 
    'Prices' AS TableName,
    (SELECT COUNT(*) FROM Demo_Retail_Price) AS DemoCount,
    (SELECT COUNT(*) FROM Retail_Price) AS ProductionCount;

SELECT 
    'Stock' AS TableName,
    (SELECT COUNT(*) FROM Demo_Retail_Stock) AS DemoCount,
    (SELECT COUNT(*) FROM Retail_Stock) AS ProductionCount;

SELECT 
    'Sales' AS TableName,
    (SELECT COUNT(*) FROM Demo_Sales) AS DemoCount,
    0 AS ProductionCount; -- Production sales table may not exist yet
GO

-- =============================================
-- 3. Sample Products with Prices
-- =============================================
PRINT '';
PRINT '3. Sample Products with Prices (First 20):';
PRINT '----------------------------------------';
SELECT TOP 20
    p.SKU,
    p.Name,
    p.Category,
    pr.SellingPrice,
    pr.CostPrice,
    ROUND((pr.SellingPrice - pr.CostPrice) / pr.CostPrice * 100, 2) AS MarkupPercent
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
ORDER BY p.Name;
GO

-- =============================================
-- 4. Stock Availability by Branch
-- =============================================
PRINT '';
PRINT '4. Stock Availability by Branch (Summary):';
PRINT '----------------------------------------';
SELECT 
    b.BranchName,
    COUNT(DISTINCT s.VariantID) AS ProductsInStock,
    SUM(s.QtyOnHand) AS TotalUnits,
    COUNT(CASE WHEN s.QtyOnHand <= s.ReorderPoint THEN 1 END) AS LowStockItems
FROM Demo_Retail_Stock s
INNER JOIN Branches b ON s.BranchID = b.BranchID
GROUP BY b.BranchName
ORDER BY b.BranchName;
GO

-- =============================================
-- 5. Products Without Prices (Should be 0)
-- =============================================
PRINT '';
PRINT '5. Products Without Prices:';
PRINT '----------------------------------------';
SELECT 
    p.SKU,
    p.Name,
    p.Category
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE pr.PriceID IS NULL;
GO

-- =============================================
-- 6. Products Without Stock (Should be 0)
-- =============================================
PRINT '';
PRINT '6. Products Without Stock:';
PRINT '----------------------------------------';
SELECT 
    p.SKU,
    p.Name,
    p.Category
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Variant v ON p.ProductID = v.ProductID
LEFT JOIN Demo_Retail_Stock s ON v.VariantID = s.VariantID
WHERE s.StockID IS NULL;
GO

-- =============================================
-- 7. Price Statistics
-- =============================================
PRINT '';
PRINT '7. Price Statistics:';
PRINT '----------------------------------------';
SELECT 
    COUNT(*) AS TotalProducts,
    MIN(SellingPrice) AS LowestPrice,
    MAX(SellingPrice) AS HighestPrice,
    AVG(SellingPrice) AS AveragePrice,
    AVG(CostPrice) AS AverageCost,
    AVG((SellingPrice - CostPrice) / CostPrice * 100) AS AvgMarkupPercent
FROM Demo_Retail_Price;
GO

-- =============================================
-- 8. Verify Master Products Table Untouched
-- =============================================
PRINT '';
PRINT '8. Master Products Table Verification:';
PRINT '----------------------------------------';
PRINT 'Checking if master Products table was modified...';
GO

-- This should show the same count as before demo setup
SELECT 
    COUNT(*) AS TotalProducts,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveProducts,
    SUM(CASE WHEN ItemType = 'Internal Product' THEN 1 ELSE 0 END) AS InternalProducts,
    SUM(CASE WHEN ItemType = 'External Product' THEN 1 ELSE 0 END) AS ExternalProducts,
    SUM(CASE WHEN ItemType = 'Raw Material' THEN 1 ELSE 0 END) AS RawMaterials
FROM Products;
GO

PRINT '';
PRINT '✓ If counts match your expectations, master table is safe!';
GO

-- =============================================
-- 9. Demo Transaction Tables Status
-- =============================================
PRINT '';
PRINT '9. Demo Transaction Tables (Should be empty):';
PRINT '----------------------------------------';
SELECT 
    'Sales' AS TableName,
    (SELECT COUNT(*) FROM Demo_Sales) AS RecordCount;

SELECT 
    'SalesDetails' AS TableName,
    (SELECT COUNT(*) FROM Demo_SalesDetails) AS RecordCount;

SELECT 
    'Payments' AS TableName,
    (SELECT COUNT(*) FROM Demo_Payments) AS RecordCount;

SELECT 
    'Returns' AS TableName,
    (SELECT COUNT(*) FROM Demo_Returns) AS RecordCount;

SELECT 
    'ReturnDetails' AS TableName,
    (SELECT COUNT(*) FROM Demo_ReturnDetails) AS RecordCount;

SELECT 
    'StockMovements' AS TableName,
    (SELECT COUNT(*) FROM Demo_Retail_StockMovements) AS RecordCount;
GO

PRINT '';
PRINT '✓ Transaction tables should be empty (0 records)';
GO

-- =============================================
-- 10. Ready for POS Check
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'POS READINESS CHECK';
PRINT '========================================';
GO

DECLARE @ProductsReady BIT = CASE WHEN (SELECT COUNT(*) FROM Demo_Retail_Product) > 0 THEN 1 ELSE 0 END;
DECLARE @PricesReady BIT = CASE WHEN (SELECT COUNT(*) FROM Demo_Retail_Price) > 0 THEN 1 ELSE 0 END;
DECLARE @StockReady BIT = CASE WHEN (SELECT COUNT(*) FROM Demo_Retail_Stock) > 0 THEN 1 ELSE 0 END;
DECLARE @TablesReady BIT = CASE WHEN (SELECT COUNT(*) FROM Demo_Sales) = 0 THEN 1 ELSE 0 END;

PRINT 'Products Loaded:     ' + CASE WHEN @ProductsReady = 1 THEN '✓ YES' ELSE '✗ NO' END;
PRINT 'Prices Generated:    ' + CASE WHEN @PricesReady = 1 THEN '✓ YES' ELSE '✗ NO' END;
PRINT 'Stock Populated:     ' + CASE WHEN @StockReady = 1 THEN '✓ YES' ELSE '✗ NO' END;
PRINT 'Transaction Tables:  ' + CASE WHEN @TablesReady = 1 THEN '✓ READY' ELSE '✗ NOT READY' END;

IF @ProductsReady = 1 AND @PricesReady = 1 AND @StockReady = 1 AND @TablesReady = 1
BEGIN
    PRINT '';
    PRINT '========================================';
    PRINT '✓✓✓ DEMO ENVIRONMENT READY FOR POS! ✓✓✓';
    PRINT '========================================';
    PRINT '';
    PRINT 'You can now:';
    PRINT '1. Configure POS to use Demo tables';
    PRINT '2. Start building POS interface';
    PRINT '3. Test sales transactions safely';
    PRINT '';
END
ELSE
BEGIN
    PRINT '';
    PRINT '========================================';
    PRINT '✗ DEMO ENVIRONMENT NOT READY';
    PRINT '========================================';
    PRINT 'Please run the setup scripts in order:';
    PRINT '1. 01_Create_Demo_Tables.sql';
    PRINT '2. 02_Populate_Demo_Data.sql';
    PRINT '';
END
GO
