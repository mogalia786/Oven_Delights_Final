-- Check which branches actually have sales data
-- This will help identify why wrong branches are showing sales

-- 1. Sales by Branch
SELECT 
    b.BranchName,
    COUNT(s.SaleID) AS OrderCount,
    ISNULL(SUM(s.TotalAmount), 0) AS TotalSales,
    MIN(s.SaleDate) AS FirstSale,
    MAX(s.SaleDate) AS LastSale
FROM Branches b
LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID
WHERE b.IsActive = 1
GROUP BY b.BranchName
ORDER BY TotalSales DESC;

-- 2. Check if "Ayesha Centre" exists in Branches table
SELECT BranchID, BranchName 
FROM Branches 
WHERE BranchName LIKE '%Ayesha%' OR BranchName LIKE '%Centre%';

-- 3. Check Demo_Sales BranchID distribution
SELECT 
    s.BranchID,
    b.BranchName,
    COUNT(*) AS SalesCount
FROM Demo_Sales s
LEFT JOIN Branches b ON s.BranchID = b.BranchID
GROUP BY s.BranchID, b.BranchName
ORDER BY SalesCount DESC;

-- 4. Check for cake orders
SELECT 
    b.BranchName,
    COUNT(DISTINCT s.SaleID) AS CakeOrders
FROM Demo_Sales s
INNER JOIN Demo_SalesLines sl ON s.SaleID = sl.SaleID
INNER JOIN Demo_Retail_Product p ON sl.ProductID = p.ProductID AND p.BranchID = s.BranchID
WHERE p.Category LIKE '%cake%'
GROUP BY b.BranchName;

-- 5. Check product categories available
SELECT DISTINCT Category, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY Category
ORDER BY Category;
