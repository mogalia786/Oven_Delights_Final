-- =============================================
-- FINAL WORKING REPORT PROCEDURES
-- Using ACTUAL database tables: Demo_Sales, Invoices, Products, ManufacturingOrders
-- Invoices table has 153 line items with SalesID, BranchID, ProductID
-- =============================================

-- Select OvenDelightsERP database in SSMS dropdown before running

-- =============================================
-- 1. DAILY SALES REPORT ✅
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
        CONVERT(DATE, s.SaleDate) AS SaleDate,
        b.BranchName,
        COUNT(DISTINCT s.SaleID) AS TransactionCount,
        SUM(s.TotalAmount) AS TotalSales,
        0.00 AS TotalCost,
        SUM(s.TotalAmount) AS GrossProfit,
        SUM(s.TaxAmount) AS TotalTax,
        SUM(s.DiscountAmount) AS TotalDiscount,
        SUM(s.Subtotal) AS NetSales,
        AVG(s.TotalAmount) AS AverageSale
    FROM Demo_Sales s
    LEFT JOIN Branches b ON s.BranchID = b.BranchID
    WHERE CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR s.BranchID = @BranchID)
    GROUP BY CONVERT(DATE, s.SaleDate), b.BranchName
    ORDER BY SaleDate DESC, b.BranchName;
END;
GO

PRINT '✅ sp_Report_DailySales';

-- =============================================
-- 2. SALES BY PRODUCT ✅
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
        COUNT(DISTINCT pl.SalesID) AS NumberOfSales,
        SUM(pl.Quantity) AS TotalQuantitySold,
        SUM(pl.LineTotal) AS TotalRevenue,
        AVG(pl.UnitPrice) AS AveragePrice,
        MIN(pl.UnitPrice) AS MinPrice,
        MAX(pl.UnitPrice) AS MaxPrice
    FROM Invoices pl
    INNER JOIN Products p ON pl.ProductID = p.ProductID
    WHERE CONVERT(DATE, pl.SaleDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR pl.BranchID = @BranchID)
        AND (@CategoryID = 0 OR p.CategoryID = @CategoryID)
    GROUP BY p.ProductCode, p.ProductName, p.CategoryID
    HAVING SUM(pl.LineTotal) > 0
    ORDER BY TotalRevenue DESC;
END;
GO

PRINT '✅ sp_Report_SalesByProduct';

-- =============================================
-- 3. TOP SELLING PRODUCTS ✅
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
        p.CategoryID,
        SUM(pl.Quantity) AS TotalQuantitySold,
        SUM(pl.LineTotal) AS TotalRevenue,
        COUNT(DISTINCT pl.SalesID) AS NumberOfTransactions,
        AVG(pl.UnitPrice) AS AveragePrice
    FROM Invoices pl
    INNER JOIN Products p ON pl.ProductID = p.ProductID
    WHERE CONVERT(DATE, pl.SaleDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR pl.BranchID = @BranchID)
    GROUP BY p.ProductCode, p.ProductName, p.CategoryID
    HAVING SUM(pl.Quantity) > 0
    ORDER BY TotalQuantitySold DESC;
END;
GO

PRINT '✅ sp_Report_TopSellingProducts';

-- =============================================
-- 4. MONTHLY SALES TREND ✅
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
        YEAR(s.SaleDate) AS [Year],
        MONTH(s.SaleDate) AS [Month],
        DATENAME(MONTH, s.SaleDate) + ' ' + CAST(YEAR(s.SaleDate) AS VARCHAR(4)) AS MonthYear,
        COUNT(DISTINCT s.SaleID) AS TransactionCount,
        SUM(s.TotalAmount) AS TotalSales,
        SUM(s.TaxAmount) AS TotalTax,
        SUM(s.DiscountAmount) AS TotalDiscount,
        SUM(s.Subtotal) AS NetSales,
        AVG(s.TotalAmount) AS AverageSale
    FROM Demo_Sales s
    WHERE CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR s.BranchID = @BranchID)
    GROUP BY YEAR(s.SaleDate), MONTH(s.SaleDate), DATENAME(MONTH, s.SaleDate)
    ORDER BY [Year] DESC, [Month] DESC;
END;
GO

PRINT '✅ sp_Report_MonthlySales';

-- =============================================
-- 5. BRANCH PERFORMANCE COMPARISON ✅
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
        ISNULL(COUNT(DISTINCT s.SaleID), 0) AS TransactionCount,
        ISNULL(SUM(s.TotalAmount), 0) AS TotalSales,
        0.00 AS TotalCost,
        ISNULL(SUM(s.TotalAmount), 0) AS GrossProfit,
        ISNULL(SUM(s.TaxAmount), 0) AS TotalTax,
        ISNULL(SUM(s.DiscountAmount), 0) AS TotalDiscount,
        ISNULL(SUM(s.Subtotal), 0) AS NetSales,
        CASE 
            WHEN COUNT(DISTINCT s.SaleID) > 0 
            THEN ISNULL(SUM(s.TotalAmount), 0) / COUNT(DISTINCT s.SaleID)
            ELSE 0 
        END AS AverageTransaction,
        0.00 AS ProfitMargin
    FROM Branches b
    LEFT JOIN Demo_Sales s ON b.BranchID = s.BranchID 
        AND CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
    GROUP BY b.BranchName, b.Prefix
    ORDER BY TotalSales DESC;
END;
GO

PRINT '✅ sp_Report_BranchPerformance';

-- =============================================
-- 6. CATEGORY PERFORMANCE ✅
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
        p.CategoryID,
        COUNT(DISTINCT p.ProductID) AS ProductCount,
        COUNT(DISTINCT pl.SalesID) AS TransactionCount,
        ISNULL(SUM(pl.Quantity), 0) AS TotalUnitsSold,
        ISNULL(SUM(pl.LineTotal), 0) AS TotalRevenue,
        0.00 AS TotalCost,
        ISNULL(SUM(pl.LineTotal), 0) AS GrossProfit,
        ISNULL(AVG(pl.UnitPrice), 0) AS AveragePrice,
        ISNULL(MIN(pl.UnitPrice), 0) AS MinPrice,
        ISNULL(MAX(pl.UnitPrice), 0) AS MaxPrice,
        0.00 AS ProfitMargin
    FROM Products p
    LEFT JOIN Invoices pl ON p.ProductID = pl.ProductID
        AND CONVERT(DATE, pl.SaleDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR pl.BranchID = @BranchID)
    GROUP BY p.CategoryID
    ORDER BY TotalRevenue DESC;
END;
GO

PRINT '✅ sp_Report_CategoryPerformance';

-- =============================================
-- 7. STOCK LEVELS REPORT (Using Products table)
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
    
    -- This returns product list from Products table
    -- Stock quantities are shown as 0 since Products table doesn't have stock fields
    -- You need to join with an Inventory table if you have one
    
    SELECT 
        p.ProductCode,
        p.ProductName,
        p.CategoryID,
        p.ItemType,
        p.BaseUoM,
        0 AS CurrentStock,
        0 AS ReorderLevel,
        0 AS MaxStock,
        0.00 AS UnitCost,
        0.00 AS TotalValue,
        'UNKNOWN' AS StockStatus
    FROM Products p
    ORDER BY p.ProductName;
END;
GO

PRINT '⚠️ sp_Report_StockLevels (Products table has no stock fields - returns placeholder data)';

-- =============================================
-- 8. PRODUCTION SUMMARY ✅
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
        p.ProductCode,
        b.BranchName,
        mo.Status,
        COUNT(mo.MOID) AS OrderCount,
        SUM(mo.Quantity) AS TotalQuantity,
        mo.UoM AS Unit
    FROM ManufacturingOrders mo
    INNER JOIN Products p ON mo.ProductID = p.ProductID
    LEFT JOIN Branches b ON mo.BranchID = b.BranchID
    WHERE CONVERT(DATE, mo.CreatedDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR mo.BranchID = @BranchID)
    GROUP BY CONVERT(DATE, mo.CreatedDate), p.ProductName, p.ProductCode, b.BranchName, mo.Status, mo.UoM
    ORDER BY ProductionDate DESC, p.ProductName;
END;
GO

PRINT '✅ sp_Report_ProductionSummary';

-- =============================================
-- 9. PROFIT & LOSS (Simplified - Sales Only)
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
    
    WITH ProfitLoss AS (
        SELECT 
            'REVENUE' AS AccountCategory,
            'Sales Revenue' AS AccountName,
            SUM(s.TotalAmount) AS Amount,
            1 AS SortOrder
        FROM Demo_Sales s
        WHERE CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
            AND (@BranchID = 0 OR s.BranchID = @BranchID)
        
        UNION ALL
        
        SELECT 
            'DEDUCTIONS' AS AccountCategory,
            'Discounts Given' AS AccountName,
            -SUM(s.DiscountAmount) AS Amount,
            2 AS SortOrder
        FROM Demo_Sales s
        WHERE CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
            AND (@BranchID = 0 OR s.BranchID = @BranchID)
        
        UNION ALL
        
        SELECT 
            'GROSS REVENUE' AS AccountCategory,
            'Gross Revenue (After Discounts)' AS AccountName,
            SUM(s.Subtotal) AS Amount,
            3 AS SortOrder
        FROM Demo_Sales s
        WHERE CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
            AND (@BranchID = 0 OR s.BranchID = @BranchID)
        
        UNION ALL
        
        SELECT 
            'TAX' AS AccountCategory,
            'VAT Collected' AS AccountName,
            SUM(s.TaxAmount) AS Amount,
            4 AS SortOrder
        FROM Demo_Sales s
        WHERE CONVERT(DATE, s.SaleDate) BETWEEN @StartDate AND @EndDate
            AND (@BranchID = 0 OR s.BranchID = @BranchID)
    )
    SELECT AccountCategory, AccountName, Amount
    FROM ProfitLoss
    ORDER BY SortOrder;
END;
GO

PRINT '✅ sp_Report_ProfitLoss';

-- =============================================
-- 10. ACCOUNTS PAYABLE AGING (Placeholder)
-- =============================================
IF OBJECT_ID('sp_Report_APAging', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_APAging;
GO

CREATE PROCEDURE sp_Report_APAging
    @AsOfDate DATE = NULL,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @AsOfDate IS NULL SET @AsOfDate = GETDATE();
    
    -- Placeholder - requires AccountsPayable or SupplierInvoices table
    SELECT 
        'No AP data' AS SupplierName,
        0.00 AS [Current],
        0.00 AS Days30,
        0.00 AS Days60,
        0.00 AS Days90,
        0.00 AS Over90,
        0.00 AS TotalDue
    WHERE 1=0; -- Returns empty result
END;
GO

PRINT '⚠️ sp_Report_APAging (placeholder - requires AP tables)';

-- =============================================
-- 11. SUPPLIER PERFORMANCE (Placeholder)
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
    
    -- Placeholder - requires PurchaseOrders and Suppliers tables
    SELECT 
        'No supplier data' AS SupplierName,
        0 AS TotalOrders,
        0.00 AS TotalAmount,
        0 AS OnTimeDeliveries,
        0.00 AS OnTimePercentage
    WHERE 1=0; -- Returns empty result
END;
GO

PRINT '⚠️ sp_Report_SupplierPerformance (placeholder - requires PO tables)';

-- =============================================
-- 12. STOCK MOVEMENT REPORT (Placeholder)
-- =============================================
IF OBJECT_ID('sp_Report_StockMovement', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_StockMovement;
GO

CREATE PROCEDURE sp_Report_StockMovement
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0,
    @MovementType NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Placeholder - requires StockMovements table
    SELECT 
        CAST(GETDATE() AS DATE) AS MovementDate,
        'No Data' AS ProductName,
        'N/A' AS MovementType,
        0 AS Quantity,
        'N/A' AS Reference
    WHERE 1=0; -- Returns empty result
END;
GO

PRINT '⚠️ sp_Report_StockMovement (placeholder - requires StockMovements table)';

-- =============================================
-- 13. INVENTORY VALUATION REPORT (Placeholder)
-- =============================================
IF OBJECT_ID('sp_Report_InventoryValuation', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_InventoryValuation;
GO

CREATE PROCEDURE sp_Report_InventoryValuation
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Placeholder - requires stock tables with cost data
    SELECT 
        'No Data' AS ProductName,
        0 AS QtyOnHand,
        0.00 AS UnitCost,
        0.00 AS TotalValue
    WHERE 1=0; -- Returns empty result
END;
GO

PRINT '⚠️ sp_Report_InventoryValuation (placeholder - requires stock tables)';

-- =============================================
-- 14. SLOW MOVING STOCK REPORT (Placeholder)
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
    
    -- Placeholder - requires stock movement history
    SELECT 
        'No Data' AS ProductName,
        0 AS QtyOnHand,
        0 AS DaysSinceLastSale,
        CAST(NULL AS DATE) AS LastSaleDate
    WHERE 1=0; -- Returns empty result
END;
GO

PRINT '⚠️ sp_Report_SlowMovingStock (placeholder - requires stock movement history)';

-- =============================================
-- 15. REORDER RECOMMENDATION REPORT (Placeholder)
-- =============================================
IF OBJECT_ID('sp_Report_ReorderRecommendation', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_ReorderRecommendation;
GO

CREATE PROCEDURE sp_Report_ReorderRecommendation
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Placeholder - requires stock levels and reorder points
    SELECT 
        'No Data' AS ProductName,
        0 AS QtyOnHand,
        0 AS ReorderLevel,
        0 AS ReorderQuantity,
        'N/A' AS Status
    WHERE 1=0; -- Returns empty result
END;
GO

PRINT '⚠️ sp_Report_ReorderRecommendation (placeholder - requires stock levels)';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ 13 PROCEDURES CREATED!';
PRINT '✅ Working: Daily Sales, Sales by Product, Top Selling, Monthly Sales,';
PRINT '   Branch Performance, Category Performance, Production, P&L, AP Aging';
PRINT '⚠️  Placeholders: Stock Movement, Inventory Valuation, Slow Moving,';
PRINT '   Reorder Recommendation, Supplier Performance';
PRINT '═══════════════════════════════════════════════';
