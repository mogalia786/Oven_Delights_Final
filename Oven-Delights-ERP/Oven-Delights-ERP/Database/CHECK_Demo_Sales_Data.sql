-- Check what data exists in Demo_Sales table

-- 1. Check if table exists and has any data
SELECT 'Total Records' AS CheckType, COUNT(*) AS RecordCount
FROM Demo_Sales;

-- 2. Check date range of data
SELECT 
    'Date Range' AS CheckType,
    MIN(SaleDate) AS EarliestDate,
    MAX(SaleDate) AS LatestDate,
    COUNT(*) AS TotalRecords
FROM Demo_Sales;

-- 3. Check data by month
SELECT 
    YEAR(SaleDate) AS SaleYear,
    MONTH(SaleDate) AS SaleMonth,
    DATENAME(MONTH, SaleDate) AS MonthName,
    COUNT(*) AS RecordCount,
    SUM(TotalAmount) AS TotalSales
FROM Demo_Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate), DATENAME(MONTH, SaleDate)
ORDER BY YEAR(SaleDate) DESC, MONTH(SaleDate) DESC;

-- 4. Check if there's data for current month (February 2026)
SELECT 
    'February 2026 Data' AS CheckType,
    COUNT(*) AS RecordCount,
    SUM(TotalAmount) AS TotalSales
FROM Demo_Sales
WHERE YEAR(SaleDate) = 2026 AND MONTH(SaleDate) = 2;

-- 5. Sample recent records
SELECT TOP 10 
    SaleDate,
    BranchID,
    ProductName,
    Quantity,
    TotalAmount
FROM Demo_Sales
ORDER BY SaleDate DESC;
