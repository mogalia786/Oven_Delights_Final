-- Check the date range of Demo_Sales data
-- This will help us understand why the dashboard shows no data

-- 1. Check if Demo_Sales table has any data
SELECT 'Total Sales Records' AS Info, COUNT(*) AS Count
FROM Demo_Sales;

-- 2. Find the date range of sales data
SELECT 
    'Date Range' AS Info,
    MIN(SaleDate) AS OldestSale,
    MAX(SaleDate) AS NewestSale,
    DATEDIFF(DAY, MIN(SaleDate), MAX(SaleDate)) AS DaySpan
FROM Demo_Sales;

-- 3. Check sales by date (last 90 days from newest sale)
SELECT 
    CAST(SaleDate AS DATE) AS SaleDay,
    COUNT(*) AS OrderCount,
    SUM(TotalAmount) AS TotalSales
FROM Demo_Sales
WHERE SaleDate >= DATEADD(DAY, -90, (SELECT MAX(SaleDate) FROM Demo_Sales))
GROUP BY CAST(SaleDate AS DATE)
ORDER BY SaleDay DESC;

-- 4. Check sales by branch
SELECT 
    b.BranchName,
    COUNT(s.SaleID) AS OrderCount,
    ISNULL(SUM(s.TotalAmount), 0) AS TotalSales
FROM Branches b
LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID
WHERE b.IsActive = 1
GROUP BY b.BranchName
ORDER BY TotalSales DESC;

-- 5. Check if we have cake orders
SELECT 
    'Cake Orders' AS Info,
    COUNT(DISTINCT s.SaleID) AS CakeOrderCount
FROM Demo_Sales s
INNER JOIN Demo_SalesLines sl ON s.SaleID = sl.SaleID
INNER JOIN Demo_Retail_Product p ON sl.ProductID = p.ProductID
WHERE p.Category LIKE '%cake%';

-- 6. Check top 10 products sold
SELECT TOP 10
    p.Name,
    SUM(sl.Quantity) AS TotalQty,
    SUM(sl.Quantity * sl.UnitPrice) AS TotalSales
FROM Demo_SalesLines sl
INNER JOIN Demo_Sales s ON sl.SaleID = s.SaleID
INNER JOIN Demo_Retail_Product p ON sl.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalQty DESC;
