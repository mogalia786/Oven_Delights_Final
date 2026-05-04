-- =============================================
-- ERP REPORTING STORED PROCEDURES
-- Professional reports with date filtering
-- =============================================

USE OvenDelightsERP;
GO

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
        SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS GrossProfit,
        CASE 
            WHEN SUM(td.Quantity * td.UnitPrice) > 0 
            THEN (SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0))) / SUM(td.Quantity * td.UnitPrice)
            ELSE 0 
        END AS ProfitMargin
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    LEFT JOIN Products p ON td.ProductID = p.ProductID
    LEFT JOIN Branches b ON t.BranchID = b.BranchID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    GROUP BY CONVERT(DATE, t.TransactionDate), b.BranchName
    ORDER BY SaleDate DESC, b.BranchName;
END;
GO

-- =============================================
-- 2. STOCK LEVELS REPORT
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
    
    SELECT 
        p.ProductCode,
        p.ProductName,
        c.CategoryName,
        b.BranchName,
        ISNULL(i.CurrentStock, 0) AS CurrentStock,
        ISNULL(i.ReorderLevel, 0) AS ReorderLevel,
        ISNULL(i.MaxStock, 0) AS MaxStock,
        ISNULL(p.CostPrice, 0) AS UnitCost,
        ISNULL(i.CurrentStock, 0) * ISNULL(p.CostPrice, 0) AS TotalValue,
        CASE 
            WHEN ISNULL(i.CurrentStock, 0) <= ISNULL(i.ReorderLevel, 0) THEN 'LOW STOCK'
            WHEN ISNULL(i.CurrentStock, 0) = 0 THEN 'OUT OF STOCK'
            ELSE 'OK'
        END AS StockStatus
    FROM Products p
    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
    LEFT JOIN Inventory i ON p.ProductID = i.ProductID
    LEFT JOIN Branches b ON i.BranchID = b.BranchID
    WHERE (@BranchID = 0 OR i.BranchID = @BranchID)
        AND (@LowStockOnly = 0 OR ISNULL(i.CurrentStock, 0) <= ISNULL(i.ReorderLevel, 0))
    ORDER BY StockStatus DESC, p.ProductName;
END;
GO

-- =============================================
-- 3. PRODUCTION SUMMARY REPORT
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
    
    SELECT 
        CONVERT(DATE, mo.CreatedDate) AS ProductionDate,
        p.ProductName,
        b.BranchName,
        COUNT(mo.ManufacturingOrderID) AS OrderCount,
        SUM(mo.QuantityOrdered) AS QuantityProduced,
        SUM(mo.TotalCost) AS MaterialCost,
        0.00 AS LaborCost, -- Placeholder for labor cost tracking
        SUM(mo.TotalCost) AS TotalCost,
        CASE 
            WHEN SUM(mo.QuantityOrdered) > 0 
            THEN SUM(mo.TotalCost) / SUM(mo.QuantityOrdered)
            ELSE 0 
        END AS CostPerUnit
    FROM ManufacturingOrders mo
    INNER JOIN Products p ON mo.ProductID = p.ProductID
    LEFT JOIN Branches b ON mo.BranchID = b.BranchID
    WHERE CONVERT(DATE, mo.CreatedDate) BETWEEN @StartDate AND @EndDate
        AND mo.Status = 'Completed'
        AND (@BranchID = 0 OR mo.BranchID = @BranchID)
    GROUP BY CONVERT(DATE, mo.CreatedDate), p.ProductName, b.BranchName
    ORDER BY ProductionDate DESC, p.ProductName;
END;
GO

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
        c.CategoryName,
        SUM(td.Quantity) AS QuantitySold,
        SUM(td.Quantity * td.UnitPrice) AS TotalRevenue,
        SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS GrossProfit,
        AVG(td.UnitPrice) AS AveragePrice,
        CASE 
            WHEN SUM(td.Quantity * td.UnitPrice) > 0 
            THEN (SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0))) / SUM(td.Quantity * td.UnitPrice)
            ELSE 0 
        END AS ProfitMargin
    FROM TransactionDetails td
    INNER JOIN Transactions t ON td.TransactionID = t.TransactionID
    INNER JOIN Products p ON td.ProductID = p.ProductID
    LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
        AND (@CategoryID = 0 OR p.CategoryID = @CategoryID)
    GROUP BY p.ProductCode, p.ProductName, c.CategoryName
    ORDER BY TotalRevenue DESC;
END;
GO

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
        SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS TotalCost,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS GrossProfit,
        CASE 
            WHEN COUNT(DISTINCT t.TransactionID) > 0 
            THEN SUM(td.Quantity * td.UnitPrice) / COUNT(DISTINCT t.TransactionID)
            ELSE 0 
        END AS AverageTransaction,
        CASE 
            WHEN SUM(td.Quantity * td.UnitPrice) > 0 
            THEN (SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0))) / SUM(td.Quantity * td.UnitPrice)
            ELSE 0 
        END AS ProfitMargin
    FROM Branches b
    LEFT JOIN Transactions t ON b.BranchID = t.BranchID 
        AND CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
    LEFT JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    LEFT JOIN Products p ON td.ProductID = p.ProductID
    GROUP BY b.BranchName, b.Prefix
    ORDER BY TotalSales DESC;
END;
GO

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

-- =============================================
-- 7. STOCK MOVEMENT REPORT
-- =============================================
IF OBJECT_ID('sp_Report_StockMovement', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_StockMovement;
GO

CREATE PROCEDURE sp_Report_StockMovement
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0,
    @MovementType VARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        sm.MovementDate,
        sm.MovementType,
        p.ProductCode,
        p.ProductName,
        b.BranchName,
        sm.Quantity,
        sm.UnitCost,
        sm.Quantity * sm.UnitCost AS TotalValue,
        sm.Reference,
        sm.Notes
    FROM StockMovements sm
    INNER JOIN Products p ON sm.ProductID = p.ProductID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE CONVERT(DATE, sm.MovementDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR sm.BranchID = @BranchID)
        AND (@MovementType IS NULL OR sm.MovementType = @MovementType)
    ORDER BY sm.MovementDate DESC, p.ProductName;
END;
GO

-- =============================================
-- 8. PROFIT & LOSS STATEMENT
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
        -SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS Amount
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    LEFT JOIN Products p ON td.ProductID = p.ProductID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    
    UNION ALL
    
    -- Gross Profit
    SELECT 
        'GROSS PROFIT' AS AccountCategory,
        'Gross Profit' AS AccountName,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS Amount
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    LEFT JOIN Products p ON td.ProductID = p.ProductID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    
    UNION ALL
    
    -- Operating Expenses (placeholder - customize based on your GL structure)
    SELECT 
        'OPERATING EXPENSES' AS AccountCategory,
        'Operating Expenses' AS AccountName,
        0.00 AS Amount
    
    UNION ALL
    
    -- Net Profit
    SELECT 
        'NET PROFIT' AS AccountCategory,
        'Net Profit' AS AccountName,
        SUM(td.Quantity * td.UnitPrice) - SUM(td.Quantity * ISNULL(p.CostPrice, 0)) AS Amount
    FROM Transactions t
    INNER JOIN TransactionDetails td ON t.TransactionID = td.TransactionID
    LEFT JOIN Products p ON td.ProductID = p.ProductID
    WHERE CONVERT(DATE, t.TransactionDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR t.BranchID = @BranchID)
    
    ORDER BY 
        CASE AccountCategory
            WHEN 'REVENUE' THEN 1
            WHEN 'COST OF GOODS SOLD' THEN 2
            WHEN 'GROSS PROFIT' THEN 3
            WHEN 'OPERATING EXPENSES' THEN 4
            WHEN 'NET PROFIT' THEN 5
        END;
END;
GO

-- =============================================
-- 9. SUPPLIER PERFORMANCE REPORT
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
        SUM(CASE WHEN po.DeliveryDate <= po.RequiredDate THEN 1 ELSE 0 END) AS OnTimeDeliveries,
        SUM(CASE WHEN po.DeliveryDate > po.RequiredDate THEN 1 ELSE 0 END) AS LateDeliveries,
        CASE 
            WHEN COUNT(DISTINCT po.PurchaseOrderID) > 0 
            THEN CAST(SUM(CASE WHEN po.DeliveryDate <= po.RequiredDate THEN 1 ELSE 0 END) AS DECIMAL(10,2)) / COUNT(DISTINCT po.PurchaseOrderID)
            ELSE 0 
        END AS OnTimePercentage
    FROM Suppliers s
    INNER JOIN PurchaseOrders po ON s.SupplierID = po.SupplierID
    WHERE CONVERT(DATE, po.OrderDate) BETWEEN @StartDate AND @EndDate
        AND po.Status = 'Completed'
        AND (@BranchID = 0 OR po.BranchID = @BranchID)
    GROUP BY s.SupplierName, s.ContactPerson
    ORDER BY TotalPurchases DESC;
END;
GO

PRINT 'All report stored procedures created successfully!';
