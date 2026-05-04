-- ============================================================================
-- POS INTEGRATION CHECK - What the POS needs to query
-- ============================================================================
-- This script shows the correct tables and columns the POS should use
-- Run this and share results to verify POS is using correct schema
-- ============================================================================

PRINT '=== 1. PRODUCT TABLE CHECK ===';
PRINT 'POS should query Demo_Retail_Product, NOT Products table';
PRINT '';

-- Show Demo_Retail_Product structure
SELECT 'Demo_Retail_Product columns:' AS Info;
SELECT COLUMN_NAME, DATA_TYPE, 
       CASE WHEN IS_NULLABLE = 'YES' THEN 'NULL' ELSE 'NOT NULL' END AS Nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '=== 2. STOCK TABLE CHECK ===';
PRINT 'POS should query RetailStock table for stock levels';
PRINT '';

-- Show RetailStock structure
SELECT 'RetailStock columns:' AS Info;
SELECT COLUMN_NAME, DATA_TYPE,
       CASE WHEN IS_NULLABLE = 'YES' THEN 'NULL' ELSE 'NOT NULL' END AS Nullable
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'RetailStock'
ORDER BY ORDINAL_POSITION;

-- Sample stock data
SELECT 'Sample RetailStock data:' AS Info;
SELECT TOP 5 rs.*, p.Name AS ProductName
FROM dbo.RetailStock rs
JOIN dbo.Demo_Retail_Product p ON p.ProductID = rs.ProductID
ORDER BY rs.RetailStockID DESC;

PRINT '';
PRINT '=== 3. PRICE TABLE CHECK ===';
PRINT 'Check what price table exists';
PRINT '';

-- Check for price tables
SELECT 'Available price-related tables:' AS Info;
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME LIKE '%Price%' OR TABLE_NAME LIKE '%Retail%'
ORDER BY TABLE_NAME;

PRINT '';
PRINT '=== 4. SAMPLE POS QUERY ===';
PRINT 'This is what the POS should query:';
PRINT '';
PRINT 'SELECT p.ProductID, p.SKU AS Code, p.Name AS ProductName,';
PRINT '       ISNULL(rs.Quantity, 0) AS Stock,';
PRINT '       ISNULL(rp.SellingPrice, 0) AS Price,';
PRINT '       p.BranchID';
PRINT 'FROM dbo.Demo_Retail_Product p';
PRINT 'LEFT JOIN dbo.RetailStock rs ON rs.ProductID = p.ProductID AND rs.BranchID = @BranchID';
PRINT 'LEFT JOIN dbo.Retail_Price rp ON rp.ProductID = p.ProductID AND rp.EffectiveTo IS NULL';
PRINT 'WHERE p.IsActive = 1';
PRINT '  AND (p.BranchID = @BranchID OR p.BranchID IS NULL)';
PRINT 'ORDER BY p.Name';
PRINT '';

-- Test the query with a sample branch
DECLARE @TestBranchID INT = 1;
SELECT 'Test query results for BranchID = ' + CAST(@TestBranchID AS VARCHAR) AS Info;

SELECT TOP 10
    p.ProductID,
    p.SKU AS Code,
    p.Name AS ProductName,
    ISNULL(rs.Quantity, 0) AS Stock,
    0.00 AS Price,  -- Update when price table is confirmed
    p.BranchID,
    p.ProductType
FROM dbo.Demo_Retail_Product p
LEFT JOIN dbo.RetailStock rs ON rs.ProductID = p.ProductID AND rs.BranchID = @TestBranchID
WHERE p.IsActive = 1
  AND p.ProductType = 'External'  -- POS should show external (retail) products
ORDER BY p.Name;

PRINT '';
PRINT '=== 5. BRANCH-SPECIFIC STOCK CHECK ===';
PRINT 'Verify stock is branch-specific:';
PRINT '';

SELECT 
    b.BranchName,
    COUNT(DISTINCT rs.ProductID) AS ProductsWithStock,
    SUM(rs.Quantity) AS TotalQuantity
FROM dbo.Branches b
LEFT JOIN dbo.RetailStock rs ON rs.BranchID = b.BranchID
GROUP BY b.BranchID, b.BranchName
ORDER BY b.BranchName;

PRINT '';
PRINT '=== SUMMARY ===';
PRINT 'POS CODE CHANGES NEEDED:';
PRINT '1. Change: FROM dbo.Products → FROM dbo.Demo_Retail_Product';
PRINT '2. Change: p.ProductName → p.Name';
PRINT '3. Change: p.ProductCode → p.SKU';
PRINT '4. Stock: Use RetailStock table with BranchID filter';
PRINT '5. Ensure: All queries filter by BranchID for branch-specific data';
PRINT '6. Product Type: Filter by ProductType = ''External'' for retail products';
