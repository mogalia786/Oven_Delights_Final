-- ========================================
-- DIAGNOSE SALES DATA
-- Check what's actually in Demo_Sales table
-- ========================================

PRINT '========================================';
PRINT 'CHECKING DEMO_SALES DATA';
PRINT '========================================';
PRINT '';

-- Check if there are any sales at all
PRINT '1. Total sales count:';
SELECT COUNT(*) AS TotalSales FROM Demo_Sales;

PRINT '';
PRINT '2. Sales for BranchID = 6:';
SELECT COUNT(*) AS SalesForBranch6 FROM Demo_Sales WHERE BranchID = 6;

PRINT '';
PRINT '3. Sales for TillPointID = 1:';
SELECT COUNT(*) AS SalesForTill1 FROM Demo_Sales WHERE TillPointID = 1;

PRINT '';
PRINT '4. Sales for BranchID = 6 AND TillPointID = 1:';
SELECT COUNT(*) AS SalesForBranch6Till1 FROM Demo_Sales WHERE BranchID = 6 AND TillPointID = 1;

PRINT '';
PRINT '5. Sample sales records (top 10):';
SELECT TOP 10
    SalesID,
    InvoiceNumber,
    BranchID,
    TillPointID,
    CashierID,
    SaleDate,
    TotalAmount,
    PaymentMethod
FROM Demo_Sales
ORDER BY SaleDate DESC;

PRINT '';
PRINT '6. Sales date range:';
SELECT 
    MIN(SaleDate) AS EarliestSale,
    MAX(SaleDate) AS LatestSale
FROM Demo_Sales;

PRINT '';
PRINT '7. Sales by date (last 7 days):';
SELECT 
    CAST(SaleDate AS DATE) AS SaleDate,
    COUNT(*) AS TransactionCount,
    SUM(TotalAmount) AS TotalSales
FROM Demo_Sales
WHERE SaleDate >= DATEADD(day, -7, GETDATE())
GROUP BY CAST(SaleDate AS DATE)
ORDER BY CAST(SaleDate AS DATE) DESC;

PRINT '';
PRINT '8. Sales by TillPointID:';
SELECT 
    TillPointID,
    COUNT(*) AS TransactionCount,
    SUM(TotalAmount) AS TotalSales
FROM Demo_Sales
GROUP BY TillPointID
ORDER BY TillPointID;

PRINT '';
PRINT '9. Sales by BranchID:';
SELECT 
    BranchID,
    COUNT(*) AS TransactionCount,
    SUM(TotalAmount) AS TotalSales
FROM Demo_Sales
GROUP BY BranchID
ORDER BY BranchID;

PRINT '';
PRINT '10. Check TillPoints table:';
SELECT 
    TillPointID,
    TillNumber,
    BranchID,
    IsActive
FROM TillPoints
WHERE BranchID = 6
ORDER BY TillPointID;

PRINT '';
PRINT '========================================';
PRINT 'DIAGNOSIS COMPLETE';
PRINT '========================================';
PRINT '';
PRINT 'Review the results above to identify:';
PRINT '  - Are there sales in Demo_Sales?';
PRINT '  - What TillPointID values are used?';
PRINT '  - What BranchID values are used?';
PRINT '  - What date range do sales cover?';
PRINT '  - Do TillPointID values match between tables?';
GO
