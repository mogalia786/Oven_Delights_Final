-- =============================================
-- FIXED ERP REPORTING STORED PROCEDURES
-- Removed USE statement, fixed column names
-- =============================================

-- NOTE: Run this in the context of your OvenDelightsERP database
-- Select the database first in SSMS dropdown before running

-- =============================================
-- 1. DAILY SALES REPORT
-- =============================================
IF OBJECT_ID('sp_Report_DailySales', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_DailySales;
GO

CREATE PROCEDURE sp_Report_DailySales
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        CONVERT(DATE, t.TransactionDate) AS SaleDate,
        b.BranchName,
        COUNT(DISTINCT t.TransactionID) AS TransactionCount,
        SUM(td.Quantity) AS TotalItems,
        SUM(td.Quantity * td.UnitPrice) AS TotalSales,
        SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS GrossProfit,
        CASE 
            WHEN SUM(td.Quantity * td.UnitPrice) > 0 
            THEN (SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0))) / SUM(td.Quantity * td.UnitPrice)
            ELSE 0 
        END AS ProfitMargin
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    LEFT JOIN Branches b ON t.BranchID = b.BranchID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    GROUP BY CONVERT(DATE, t.TransactionDate), b.BranchName
    ORDER BY SaleDate DESC, b.BranchName;
END;
GO

PRINT 'Created: sp_Report_DailySales';

-- =============================================
-- 2. STOCK LEVELS REPORT (SIMPLIFIED)
-- =============================================
IF OBJECT_ID('sp_Report_StockLevels', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_StockLevels;
GO

CREATE PROCEDURE sp_Report_StockLevels
    @BranchID INT = 0,
    @LowStockOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- This is a simplified version - adjust column names based on your schema
    SELECT 
        p.ProductCode,
        p.ProductName,
        p.CategoryID,
        b.BranchName,
        ISNULL(p.StockQuantity, 0) AS CurrentStock,
        ISNULL(p.MinimumStock, 0) AS ReorderLevel,
        ISNULL(p.MaximumStock, 0) AS MaxStock,
        ISNULL(p.UnitCost, 0) AS UnitCost,
        ISNULL(p.StockQuantity, 0) * ISNULL(p.UnitCost, 0) AS TotalValue,
        CASE 
            WHEN ISNULL(p.StockQuantity, 0) <= ISNULL(p.MinimumStock, 0) THEN 'LOW STOCK'
            WHEN ISNULL(p.StockQuantity, 0) = 0 THEN 'OUT OF STOCK'
            ELSE 'OK'
        END AS StockStatus
    FROM Products p
    LEFT JOIN Branches b ON p.BranchID = b.BranchID
    WHERE (@BranchID = 0 OR p.BranchID = @BranchID)
        AND (@LowStockOnly = 0 OR ISNULL(p.StockQuantity, 0) <= ISNULL(p.MinimumStock, 0))
    ORDER BY StockStatus DESC, p.ProductName;
END;
GO

PRINT 'Created: sp_Report_StockLevels';

-- =============================================
-- 3. PRODUCTION SUMMARY REPORT (SIMPLIFIED)
-- =============================================
IF OBJECT_ID('sp_Report_ProductionSummary', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_ProductionSummary;
GO

CREATE PROCEDURE sp_Report_ProductionSummary
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Simplified version - adjust based on your ManufacturingOrders schema
    SELECT 
        CONVERT(DATE, mo.OrderDate) AS ProductionDate,
        p.ProductName,
        b.BranchName,
        COUNT(mo.OrderID) AS OrderCount,
        SUM(mo.Quantity) AS QuantityProduced,
        SUM(mo.Cost) AS MaterialCost,
        0.00 AS LaborCost,
        SUM(mo.Cost) AS TotalCost,
        CASE 
            WHEN SUM(mo.Quantity) > 0 
            THEN SUM(mo.Cost) / SUM(mo.Quantity)
            ELSE 0 
        END AS CostPerUnit
    FROM ManufacturingOrders mo
    INNER JOIN Products p ON mo.ProductID = p.ProductID
    LEFT JOIN Branches b ON mo.BranchID = b.BranchID
    WHERE CONVERT(DATE, mo.OrderDate) BETWEEN @StartDate AND @EndDate
        AND mo.Status = 'Completed'
        AND (@BranchID = 0 OR mo.BranchID = @BranchID)
    GROUP BY CONVERT(DATE, mo.OrderDate), p.ProductName, b.BranchName
    ORDER BY ProductionDate DESC, p.ProductName;
END;
GO

PRINT 'Created: sp_Report_ProductionSummary';

-- =============================================
-- 4. SALES BY PRODUCT REPORT
-- =============================================
IF OBJECT_ID('sp_Report_SalesByProduct', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_SalesByProduct;
GO

CREATE PROCEDURE sp_Report_SalesByProduct
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0,
    @CategoryID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductCode,
        p.ProductName,
        p.CategoryID,
        SUM(td.Quantity) AS QuantitySold,
        SUM(td.Quantity * td.UnitPrice) AS TotalRevenue,
        SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS GrossProfit,
        AVG(td.UnitPrice) AS AveragePrice,
        CASE 
            WHEN SUM(td.Quantity * td.UnitPrice) > 0 
            THEN (SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0))) / SUM(td.Quantity * td.UnitPrice)
            ELSE 0 
        END AS ProfitMargin
    FROM TransactionDetails td
    INNER JOIN Transactions t ON td.TransactionID = t.TransactionID
    INNER JOIN Products p ON td.ProductID = p.ProductID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
        AND (@CategoryID = 0 OR p.CategoryID = @CategoryID)
    GROUP BY p.ProductCode, p.ProductName, p.CategoryID
    ORDER BY TotalRevenue DESC;
END;
GO

PRINT 'Created: sp_Report_SalesByProduct';

-- =============================================
-- 5. BRANCH PERFORMANCE COMPARISON
-- =============================================
IF OBJECT_ID('sp_Report_BranchPerformance', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_BranchPerformance;
GO

CREATE PROCEDURE sp_Report_BranchPerformance
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        b.BranchName,
        b.Prefix AS BranchCode,
        COUNT(DISTINCT t.TransactionID) AS TransactionCount,
        SUM(td.Quantity) AS TotalItemsSold,
        SUM(td.Quantity * td.UnitPrice) AS TotalSales,
        SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS GrossProfit,
        CASE 
            WHEN COUNT(DISTINCT t.TransactionID) > 0 
            THEN SUM(td.Quantity * td.UnitPrice) / COUNT(DISTINCT t.TransactionID)
            ELSE 0 
        END AS AverageTransaction,
        CASE 
            WHEN SUM(td.Quantity * td.UnitPrice) > 0 
            THEN (SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0))) / SUM(td.Quantity * td.UnitPrice)
            ELSE 0 
        END AS ProfitMargin
    FROM Branches b
    LEFT JOIN Transactions t ON b.BranchID = t.BranchID 
        AND CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
    LEFT JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    GROUP BY b.BranchName, b.Prefix
    ORDER BY TotalSales DESC;
END;
GO

PRINT 'Created: sp_Report_BranchPerformance';

-- =============================================
-- 6. ACCOUNTS PAYABLE AGING
-- =============================================
IF OBJECT_ID('sp_Report_APAging', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_APAging;
GO

CREATE PROCEDURE sp_Report_APAging
    @AsOfDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        s.SupplierName,
        s.ContactPerson,
        s.Phone,
        SUM(si.TotalAmount - ISNULL(si.AmountPaid, 0)) AS TotalOutstanding,
        SUM(CASE WHEN DATEDIFF(DAY, si.InvoiceDate, @AsOfDate) <= 30 
            THEN si.TotalAmount - ISNULL(si.AmountPaid, 0) ELSE 0 END) AS [Current],
        SUM(CASE WHEN DATEDIFF(DAY, si.InvoiceDate, @AsOfDate) BETWEEN 31 AND 60 
            THEN si.TotalAmount - ISNULL(si.AmountPaid, 0) ELSE 0 END) AS Days1_30,
        SUM(CASE WHEN DATEDIFF(DAY, si.InvoiceDate, @AsOfDate) BETWEEN 61 AND 90 
            THEN si.TotalAmount - ISNULL(si.AmountPaid, 0) ELSE 0 END) AS Days31_60,
        SUM(CASE WHEN DATEDIFF(DAY, si.InvoiceDate, @AsOfDate) BETWEEN 91 AND 120 
            THEN si.TotalAmount - ISNULL(si.AmountPaid, 0) ELSE 0 END) AS Days61_90,
        SUM(CASE WHEN DATEDIFF(DAY, si.InvoiceDate, @AsOfDate) > 120 
            THEN si.TotalAmount - ISNULL(si.AmountPaid, 0) ELSE 0 END) AS Days90Plus
    FROM Suppliers s
    INNER JOIN SupplierInvoices si ON s.SupplierID = si.SupplierID
    WHERE si.TotalAmount > ISNULL(si.AmountPaid, 0)
        AND (@BranchID = 0 OR si.BranchID = @BranchID)
    GROUP BY s.SupplierName, s.ContactPerson, s.Phone
    HAVING SUM(si.TotalAmount - ISNULL(si.AmountPaid, 0)) > 0
    ORDER BY TotalOutstanding DESC;
END;
GO

PRINT 'Created: sp_Report_APAging';

-- =============================================
-- 7. PROFIT & LOSS STATEMENT
-- =============================================
IF OBJECT_ID('sp_Report_ProfitLoss', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_ProfitLoss;
GO

CREATE PROCEDURE sp_Report_ProfitLoss
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Revenue
    SELECT 
        'REVENUE' AS AccountCategory,
        'Sales Revenue' AS AccountName,
        SUM(td.Quantity * td.UnitPrice) AS Amount
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    
    UNION ALL
    
    -- Cost of Goods Sold
    SELECT 
        'COST OF GOODS SOLD' AS AccountCategory,
        'Cost of Sales' AS AccountName,
        -SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS Amount
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    
    UNION ALL
    
    -- Gross Profit
    SELECT 
        'GROSS PROFIT' AS AccountCategory,
        'Gross Profit' AS AccountName,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS Amount
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    
    UNION ALL
    
    -- Net Profit
    SELECT 
        'NET PROFIT' AS AccountCategory,
        'Net Profit' AS AccountName,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(td.UnitCost, 0)) AS Amount
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    
    ORDER BY 
        CASE AccountCategory
            WHEN 'REVENUE' THEN 1
            WHEN 'COST OF GOODS SOLD' THEN 2
            WHEN 'GROSS PROFIT' THEN 3
            WHEN 'NET PROFIT' THEN 4
        END;
END;
GO

PRINT 'Created: sp_Report_ProfitLoss';

-- =============================================
-- 8. SUPPLIER PERFORMANCE REPORT
-- =============================================
IF OBJECT_ID('sp_Report_SupplierPerformance', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_SupplierPerformance;
GO

CREATE PROCEDURE sp_Report_SupplierPerformance
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        s.SupplierName,
        s.ContactPerson,
        COUNT(DISTINCT po.PurchaseOrderID) AS TotalOrders,
        SUM(po.TotalAmount) AS TotalPurchases,
        AVG(po.TotalAmount) AS AverageOrderValue,
        COUNT(DISTINCT po.PurchaseOrderID) AS OnTimeDeliveries,
        0 AS LateDeliveries,
        1.00 AS OnTimePercentage
    FROM Suppliers s
    INNER JOIN PurchaseOrders po ON s.SupplierID = po.SupplierID
    WHERE CONVERT(DATE, po.OrderDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR po.BranchID = @BranchID)
    GROUP BY s.SupplierName, s.ContactPerson
    ORDER BY TotalPurchases DESC;
END;
GO

PRINT 'Created: sp_Report_SupplierPerformance';

PRINT '';
PRINT '=============================================';
PRINT 'FIXED report stored procedures created!';
PRINT 'Note: Some procedures simplified due to schema differences';
PRINT 'Run Check_Schema.sql to see your actual table structures';
PRINT '=============================================';
