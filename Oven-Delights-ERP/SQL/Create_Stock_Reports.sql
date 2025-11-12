-- =============================================
-- COMPREHENSIVE STOCK REPORTS
-- For Stockroom, Manufacturing, and Retail
-- =============================================

-- =============================================
-- 1. STOCKROOM INVENTORY REPORT
-- =============================================
IF OBJECT_ID('sp_Report_StockroomInventory', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_StockroomInventory;
GO

CREATE PROCEDURE sp_Report_StockroomInventory
    @BranchID INT = 0,
    @CategoryID INT = 0,
    @ShowLowStock BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductID,
        p.ProductName,
        p.SKU,
        p.CategoryID,
        ISNULL(p.StockLevel, 0) AS CurrentStock,
        ISNULL(p.ReorderLevel, 0) AS ReorderLevel,
        ISNULL(p.MaxStockLevel, 0) AS MaxStock,
        p.UnitPrice,
        p.CostPrice,
        ISNULL(p.StockLevel, 0) * p.CostPrice AS StockValue,
        CASE 
            WHEN ISNULL(p.StockLevel, 0) <= ISNULL(p.ReorderLevel, 0) THEN 'Low Stock'
            WHEN ISNULL(p.StockLevel, 0) = 0 THEN 'Out of Stock'
            ELSE 'In Stock'
        END AS StockStatus,
        p.IsActive
    FROM Products p
    WHERE p.IsActive = 1
        AND (@CategoryID = 0 OR p.CategoryID = @CategoryID)
        AND (@ShowLowStock = 0 OR ISNULL(p.StockLevel, 0) <= ISNULL(p.ReorderLevel, 0))
    ORDER BY 
        CASE 
            WHEN ISNULL(p.StockLevel, 0) = 0 THEN 1
            WHEN ISNULL(p.StockLevel, 0) <= ISNULL(p.ReorderLevel, 0) THEN 2
            ELSE 3
        END,
        p.ProductName;
END;
GO

PRINT '✅ sp_Report_StockroomInventory created';

-- =============================================
-- 2. MANUFACTURING MATERIALS REPORT
-- =============================================
IF OBJECT_ID('sp_Report_ManufacturingMaterials', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_ManufacturingMaterials;
GO

CREATE PROCEDURE sp_Report_ManufacturingMaterials
    @ShowLowStock BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get raw materials and ingredients used in manufacturing
    SELECT 
        p.ProductID,
        p.ProductName,
        p.SKU,
        ISNULL(p.StockLevel, 0) AS CurrentStock,
        ISNULL(p.ReorderLevel, 0) AS ReorderLevel,
        p.UnitOfMeasure,
        p.CostPrice,
        ISNULL(p.StockLevel, 0) * p.CostPrice AS StockValue,
        -- Count how many recipes use this material
        (SELECT COUNT(DISTINCT RecipeID) 
         FROM RecipeIngredients ri 
         WHERE ri.IngredientID = p.ProductID) AS UsedInRecipes,
        CASE 
            WHEN ISNULL(p.StockLevel, 0) <= ISNULL(p.ReorderLevel, 0) THEN 'Low Stock'
            WHEN ISNULL(p.StockLevel, 0) = 0 THEN 'Out of Stock'
            ELSE 'Adequate'
        END AS StockStatus
    FROM Products p
    WHERE p.IsActive = 1
        AND p.CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName LIKE '%Material%' OR CategoryName LIKE '%Ingredient%')
        AND (@ShowLowStock = 0 OR ISNULL(p.StockLevel, 0) <= ISNULL(p.ReorderLevel, 0))
    ORDER BY StockStatus, p.ProductName;
END;
GO

PRINT '✅ sp_Report_ManufacturingMaterials created';

-- =============================================
-- 3. RETAIL STOCK REPORT (INTERNAL)
-- =============================================
IF OBJECT_ID('sp_Report_RetailStockInternal', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_RetailStockInternal;
GO

CREATE PROCEDURE sp_Report_RetailStockInternal
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Internal retail stock (finished goods for sale)
    SELECT 
        p.ProductID,
        p.ProductName,
        p.SKU,
        p.Barcode,
        ISNULL(p.StockLevel, 0) AS CurrentStock,
        p.UnitPrice AS RetailPrice,
        p.CostPrice,
        (p.UnitPrice - p.CostPrice) AS ProfitPerUnit,
        CASE 
            WHEN p.UnitPrice > 0 THEN ((p.UnitPrice - p.CostPrice) / p.UnitPrice) * 100
            ELSE 0
        END AS ProfitMargin,
        ISNULL(p.StockLevel, 0) * p.UnitPrice AS RetailValue,
        ISNULL(p.StockLevel, 0) * p.CostPrice AS CostValue,
        -- Sales last 30 days
        (SELECT ISNULL(SUM(i.Quantity), 0)
         FROM Invoices i
         WHERE i.ProductID = p.ProductID
           AND i.SaleDate >= DATEADD(DAY, -30, GETDATE())
           AND (@BranchID = 0 OR i.BranchID = @BranchID)) AS SalesLast30Days,
        CASE 
            WHEN ISNULL(p.StockLevel, 0) <= ISNULL(p.ReorderLevel, 0) THEN 'Low Stock'
            WHEN ISNULL(p.StockLevel, 0) = 0 THEN 'Out of Stock'
            ELSE 'In Stock'
        END AS StockStatus
    FROM Products p
    WHERE p.IsActive = 1
        AND p.CategoryID NOT IN (SELECT CategoryID FROM Categories WHERE CategoryName LIKE '%Material%' OR CategoryName LIKE '%Ingredient%')
    ORDER BY SalesLast30Days DESC, p.ProductName;
END;
GO

PRINT '✅ sp_Report_RetailStockInternal created';

-- =============================================
-- 4. RETAIL SALES ANALYSIS (EXTERNAL)
-- =============================================
IF OBJECT_ID('sp_Report_RetailSalesExternal', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_RetailSalesExternal;
GO

CREATE PROCEDURE sp_Report_RetailSalesExternal
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- External sales analysis (what customers bought)
    SELECT 
        p.ProductID,
        p.ProductName,
        p.CategoryID,
        COUNT(DISTINCT i.SalesID) AS TransactionCount,
        SUM(i.Quantity) AS TotalUnitsSold,
        SUM(i.LineTotal) AS TotalRevenue,
        AVG(i.UnitPrice) AS AvgSellingPrice,
        SUM(i.Quantity * p.CostPrice) AS TotalCost,
        SUM(i.LineTotal) - SUM(i.Quantity * p.CostPrice) AS GrossProfit,
        CASE 
            WHEN SUM(i.LineTotal) > 0 
            THEN ((SUM(i.LineTotal) - SUM(i.Quantity * p.CostPrice)) / SUM(i.LineTotal)) * 100
            ELSE 0
        END AS ProfitMargin,
        -- Current stock level
        ISNULL(p.StockLevel, 0) AS CurrentStock,
        -- Days of stock remaining (based on avg daily sales)
        CASE 
            WHEN SUM(i.Quantity) > 0 
            THEN ISNULL(p.StockLevel, 0) / (SUM(i.Quantity) / DATEDIFF(DAY, @StartDate, @EndDate))
            ELSE 999
        END AS DaysOfStockRemaining
    FROM Invoices i
    INNER JOIN Products p ON i.ProductID = p.ProductID
    WHERE CONVERT(DATE, i.SaleDate) BETWEEN @StartDate AND @EndDate
        AND (@BranchID = 0 OR i.BranchID = @BranchID)
    GROUP BY p.ProductID, p.ProductName, p.CategoryID, p.CostPrice, p.StockLevel
    ORDER BY TotalRevenue DESC;
END;
GO

PRINT '✅ sp_Report_RetailSalesExternal created';

-- =============================================
-- 5. STOCK MOVEMENT SUMMARY
-- =============================================
IF OBJECT_ID('sp_Report_StockMovementSummary', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_StockMovementSummary;
GO

CREATE PROCEDURE sp_Report_StockMovementSummary
    @StartDate DATE,
    @EndDate DATE,
    @ProductID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductID,
        p.ProductName,
        p.SKU,
        -- Opening stock (estimated)
        ISNULL(p.StockLevel, 0) + 
        ISNULL((SELECT SUM(i.Quantity) FROM Invoices i 
                WHERE i.ProductID = p.ProductID 
                AND CONVERT(DATE, i.SaleDate) BETWEEN @StartDate AND @EndDate), 0) AS OpeningStock,
        -- Purchases/Production (would need purchase/production tables)
        0 AS StockIn,
        -- Sales
        ISNULL((SELECT SUM(i.Quantity) FROM Invoices i 
                WHERE i.ProductID = p.ProductID 
                AND CONVERT(DATE, i.SaleDate) BETWEEN @StartDate AND @EndDate), 0) AS StockOut,
        -- Closing stock
        ISNULL(p.StockLevel, 0) AS ClosingStock,
        -- Variance
        0 AS Variance
    FROM Products p
    WHERE p.IsActive = 1
        AND (@ProductID = 0 OR p.ProductID = @ProductID)
    ORDER BY p.ProductName;
END;
GO

PRINT '✅ sp_Report_StockMovementSummary created';

-- =============================================
-- 6. LOW STOCK ALERT REPORT
-- =============================================
IF OBJECT_ID('sp_Report_LowStockAlert', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_LowStockAlert;
GO

CREATE PROCEDURE sp_Report_LowStockAlert
    @DepartmentType NVARCHAR(20) = 'ALL' -- 'Stockroom', 'Manufacturing', 'Retail', 'ALL'
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.ProductID,
        p.ProductName,
        p.SKU,
        p.CategoryID,
        ISNULL(p.StockLevel, 0) AS CurrentStock,
        ISNULL(p.ReorderLevel, 0) AS ReorderLevel,
        ISNULL(p.ReorderLevel, 0) - ISNULL(p.StockLevel, 0) AS QuantityToOrder,
        p.CostPrice,
        (ISNULL(p.ReorderLevel, 0) - ISNULL(p.StockLevel, 0)) * p.CostPrice AS EstimatedOrderCost,
        CASE 
            WHEN ISNULL(p.StockLevel, 0) = 0 THEN 'CRITICAL - Out of Stock'
            WHEN ISNULL(p.StockLevel, 0) <= (ISNULL(p.ReorderLevel, 0) * 0.5) THEN 'URGENT - Very Low'
            ELSE 'Low Stock'
        END AS AlertLevel,
        CASE 
            WHEN p.CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName LIKE '%Material%' OR CategoryName LIKE '%Ingredient%') 
            THEN 'Manufacturing'
            ELSE 'Retail'
        END AS Department
    FROM Products p
    WHERE p.IsActive = 1
        AND ISNULL(p.StockLevel, 0) <= ISNULL(p.ReorderLevel, 0)
        AND (@DepartmentType = 'ALL' 
             OR (@DepartmentType = 'Manufacturing' AND p.CategoryID IN (SELECT CategoryID FROM Categories WHERE CategoryName LIKE '%Material%' OR CategoryName LIKE '%Ingredient%'))
             OR (@DepartmentType = 'Retail' AND p.CategoryID NOT IN (SELECT CategoryID FROM Categories WHERE CategoryName LIKE '%Material%' OR CategoryName LIKE '%Ingredient%'))
             OR @DepartmentType = 'Stockroom')
    ORDER BY 
        CASE 
            WHEN ISNULL(p.StockLevel, 0) = 0 THEN 1
            WHEN ISNULL(p.StockLevel, 0) <= (ISNULL(p.ReorderLevel, 0) * 0.5) THEN 2
            ELSE 3
        END,
        p.ProductName;
END;
GO

PRINT '✅ sp_Report_LowStockAlert created';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ STOCK REPORTS CREATED!';
PRINT '   - sp_Report_StockroomInventory';
PRINT '   - sp_Report_ManufacturingMaterials';
PRINT '   - sp_Report_RetailStockInternal';
PRINT '   - sp_Report_RetailSalesExternal';
PRINT '   - sp_Report_StockMovementSummary';
PRINT '   - sp_Report_LowStockAlert';
PRINT '═══════════════════════════════════════════════';
