-- =============================================
-- ADDITIONAL ERP REPORTING STORED PROCEDURES
-- =============================================

USE OvenDelightsERP;
GO

-- =============================================
-- 10. INVENTORY VALUATION REPORT
-- =============================================
IF OBJECT_ID('sp_Report_InventoryValuation', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_InventoryValuation;
GO

CREATE PROCEDURE sp_Report_InventoryValuation
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductCode,
        p.ProductName,
        c.CategoryName,
        b.BranchName,
        ISNULL(i.CurrentStock, 0) AS CurrentStock,
        ISNULL(p.CostPrice, 0) AS UnitCost,
        ISNULL(p.SellingPrice, 0) AS UnitRetailPrice,
        ISNULL(i.CurrentStock, 0) * ISNULL(p.CostPrice, 0) AS TotalValue,
        ISNULL(i.CurrentStock, 0) * ISNULL(p.SellingPrice, 0) AS RetailValue,
        ISNULL(i.CurrentStock, 0) * (ISNULL(p.SellingPrice, 0) - ISNULL(p.CostPrice, 0)) AS PotentialProfit
    FROM Products p
    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
    LEFT JOIN Inventory i ON p.ProductID = i.ProductID
    LEFT JOIN Branches b ON i.BranchID = b.BranchID
    WHERE (@BranchID = 0 OR i.BranchID = @BranchID)
        AND ISNULL(i.CurrentStock, 0) > 0
    ORDER BY TotalValue DESC;
END;
GO

-- =============================================
-- 11. MONTHLY SALES TREND REPORT
-- =============================================
IF OBJECT_ID('sp_Report_MonthlySales', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_MonthlySales;
GO

CREATE PROCEDURE sp_Report_MonthlySales
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        YEAR(t.TransactionDate) AS [Year],
        MONTH(t.TransactionDate) AS [Month],
        DATENAME(MONTH, t.TransactionDate) + ' ' + CAST(YEAR(t.TransactionDate) AS VARCHAR(4)) AS MonthYear,
        COUNT(DISTINCT t.TransactionID) AS TransactionCount,
        SUM(td.Quantity) AS TotalItemsSold,
        SUM(td.Quantity * td.UnitPrice) AS TotalSales,
        SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS GrossProfit,
        CASE 
            WHEN COUNT(DISTINCT t.TransactionID) > 0 
            THEN SUM(td.Quantity * td.UnitPrice) / COUNT(DISTINCT t.TransactionID)
            ELSE 0 
        END AS AverageSale
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    LEFT JOIN Products p ON td.ProductID = p.ProductID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    GROUP BY YEAR(t.TransactionDate), MONTH(t.TransactionDate), DATENAME(MONTH, t.TransactionDate)
    ORDER BY [Year] DESC, [Month] DESC;
END;
GO

-- =============================================
-- 12. TOP SELLING PRODUCTS REPORT
-- =============================================
IF OBJECT_ID('sp_Report_TopSellingProducts', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_TopSellingProducts;
GO

CREATE PROCEDURE sp_Report_TopSellingProducts
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0,
    @TopN INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TOP (@TopN)
        p.ProductCode,
        p.ProductName,
        c.CategoryName,
        SUM(td.Quantity) AS QuantitySold,
        SUM(td.Quantity * td.UnitPrice) AS TotalRevenue,
        SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS GrossProfit,
        COUNT(DISTINCT t.TransactionID) AS TimesOrdered,
        AVG(td.UnitPrice) AS AveragePrice
    FROM TransactionDetails td
    INNER JOIN Transactions t ON td.TransactionID = t.TransactionID
    INNER JOIN Products p ON td.ProductID = p.ProductID
    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    GROUP BY p.ProductCode, p.ProductName, c.CategoryName
    ORDER BY QuantitySold DESC;
END;
GO

-- =============================================
-- 13. SLOW MOVING STOCK REPORT
-- =============================================
IF OBJECT_ID('sp_Report_SlowMovingStock', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_SlowMovingStock;
GO

CREATE PROCEDURE sp_Report_SlowMovingStock
    @DaysSinceLastSale INT = 30,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductCode,
        p.ProductName,
        c.CategoryName,
        b.BranchName,
        ISNULL(i.CurrentStock, 0) AS CurrentStock,
        ISNULL(i.CurrentStock, 0) * ISNULL(p.CostPrice, 0) AS TiedUpCapital,
        MAX(t.TransactionDate) AS LastSaleDate,
        DATEDIFF(DAY, MAX(t.TransactionDate), GETDATE()) AS DaysSinceLastSale
    FROM Products p
    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
    LEFT JOIN Inventory i ON p.ProductID = i.ProductID
    LEFT JOIN Branches b ON i.BranchID = b.BranchID
    LEFT JOIN TransactionDetails td ON p.ProductID = td.ProductID
    LEFT JOIN Transactions t ON td.TransactionID = t.TransactionID
    WHERE (@BranchID = 0 OR i.BranchID = @BranchID)
        AND ISNULL(i.CurrentStock, 0) > 0
    GROUP BY p.ProductCode, p.ProductName, c.CategoryName, b.BranchName, i.CurrentStock, p.CostPrice
    HAVING MAX(t.TransactionDate) IS NULL OR DATEDIFF(DAY, MAX(t.TransactionDate), GETDATE()) >= @DaysSinceLastSale
    ORDER BY DaysSinceLastSale DESC, TiedUpCapital DESC;
END;
GO

-- =============================================
-- 14. REORDER RECOMMENDATION REPORT
-- =============================================
IF OBJECT_ID('sp_Report_ReorderRecommendation', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_ReorderRecommendation;
GO

CREATE PROCEDURE sp_Report_ReorderRecommendation
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductCode,
        p.ProductName,
        s.SupplierName,
        b.BranchName,
        ISNULL(i.CurrentStock, 0) AS CurrentStock,
        ISNULL(i.ReorderLevel, 0) AS ReorderLevel,
        ISNULL(i.MaxStock, 0) AS MaxStock,
        ISNULL(i.MaxStock, 0) - ISNULL(i.CurrentStock, 0) AS RecommendedOrderQty,
        ISNULL(p.CostPrice, 0) AS UnitCost,
        (ISNULL(i.MaxStock, 0) - ISNULL(i.CurrentStock, 0)) * ISNULL(p.CostPrice, 0) AS EstimatedCost,
        CASE 
            WHEN ISNULL(i.CurrentStock, 0) = 0 THEN 'URGENT - OUT OF STOCK'
            WHEN ISNULL(i.CurrentStock, 0) <= ISNULL(i.ReorderLevel, 0) * 0.5 THEN 'HIGH PRIORITY'
            ELSE 'NORMAL'
        END AS Priority
    FROM Products p
    LEFT JOIN Inventory i ON p.ProductID = i.ProductID
    LEFT JOIN Branches b ON i.BranchID = b.BranchID
    LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
    WHERE ISNULL(i.CurrentStock, 0) <= ISNULL(i.ReorderLevel, 0)
        AND (@BranchID = 0 OR i.BranchID = @BranchID)
    ORDER BY 
        CASE Priority
            WHEN 'URGENT - OUT OF STOCK' THEN 1
            WHEN 'HIGH PRIORITY' THEN 2
            ELSE 3
        END,
        EstimatedCost DESC;
END;
GO

-- =============================================
-- 15. CATEGORY PERFORMANCE REPORT
-- =============================================
IF OBJECT_ID('sp_Report_CategoryPerformance', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_CategoryPerformance;
GO

CREATE PROCEDURE sp_Report_CategoryPerformance
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        c.CategoryName,
        COUNT(DISTINCT p.ProductID) AS ProductCount,
        SUM(td.Quantity) AS TotalUnitsSold,
        SUM(td.Quantity * td.UnitPrice) AS TotalRevenue,
        SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS GrossProfit,
        CASE 
            WHEN SUM(td.Quantity * td.UnitPrice) > 0 
            THEN (SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0))) / SUM(td.Quantity * td.UnitPrice)
            ELSE 0 
        END AS ProfitMargin,
        AVG(td.UnitPrice) AS AveragePrice
    FROM Categories c
    INNER JOIN Products p ON c.CategoryID = p.CategoryID
    INNER JOIN TransactionDetails td ON p.ProductID = td.ProductID
    INNER JOIN Transactions t ON td.TransactionID = t.TransactionID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    GROUP BY c.CategoryName
    ORDER BY TotalRevenue DESC;
END;
GO

PRINT 'Additional report stored procedures created successfully!';
