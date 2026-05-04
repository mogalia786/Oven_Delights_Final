-- Check what invoice and order data exists
USE Oven_Delights_Main
GO

-- Check for invoice tables
PRINT '=== CHECKING INVOICE TABLES ==='
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerInvoices')
    SELECT 'CustomerInvoices' AS TableName, COUNT(*) AS RecordCount FROM CustomerInvoices
ELSE
    PRINT 'CustomerInvoices table does NOT exist'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierInvoices')
    SELECT 'SupplierInvoices' AS TableName, COUNT(*) AS RecordCount, 
           SUM(CASE WHEN PaymentStatus = 'Paid' THEN TotalAmount ELSE 0 END) AS TotalPaid,
           SUM(CASE WHEN PaymentStatus IN ('Pending', 'Partial') THEN TotalAmount ELSE 0 END) AS TotalOutstanding
    FROM SupplierInvoices
ELSE
    PRINT 'SupplierInvoices table does NOT exist'

-- Check for sales/orders
PRINT ''
PRINT '=== CHECKING SALES/ORDER TABLES ==='
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_Sales')
BEGIN
    SELECT 'Demo_Sales' AS TableName, COUNT(*) AS RecordCount, SUM(TotalAmount) AS TotalSales FROM Demo_Sales
    
    PRINT ''
    PRINT 'Sales by Date Range:'
    SELECT 
        CASE 
            WHEN SaleDate >= DATEADD(DAY, -7, GETDATE()) THEN 'Last 7 Days'
            WHEN SaleDate >= DATEADD(DAY, -30, GETDATE()) THEN 'Last 30 Days'
            WHEN SaleDate >= DATEADD(DAY, -90, GETDATE()) THEN 'Last 90 Days'
            ELSE 'Older'
        END AS Period,
        COUNT(*) AS OrderCount,
        SUM(TotalAmount) AS TotalSales
    FROM Demo_Sales
    GROUP BY 
        CASE 
            WHEN SaleDate >= DATEADD(DAY, -7, GETDATE()) THEN 'Last 7 Days'
            WHEN SaleDate >= DATEADD(DAY, -30, GETDATE()) THEN 'Last 30 Days'
            WHEN SaleDate >= DATEADD(DAY, -90, GETDATE()) THEN 'Last 90 Days'
            ELSE 'Older'
        END
    ORDER BY 
        CASE 
            WHEN SaleDate >= DATEADD(DAY, -7, GETDATE()) THEN 1
            WHEN SaleDate >= DATEADD(DAY, -30, GETDATE()) THEN 2
            WHEN SaleDate >= DATEADD(DAY, -90, GETDATE()) THEN 3
            ELSE 4
        END
END
ELSE
    PRINT 'Demo_Sales table does NOT exist'

-- Check for product categories
PRINT ''
PRINT '=== CHECKING PRODUCT CATEGORIES ==='
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_Retail_Product')
BEGIN
    SELECT 
        CASE 
            WHEN Category LIKE '%cake%' THEN 'Cakes'
            WHEN Category LIKE '%pastry%' OR Category LIKE '%pastries%' THEN 'Pastries'
            WHEN Category LIKE '%bread%' THEN 'Bread'
            ELSE 'Other'
        END AS CategoryGroup,
        COUNT(*) AS ProductCount
    FROM Demo_Retail_Product
    WHERE IsActive = 1
    GROUP BY 
        CASE 
            WHEN Category LIKE '%cake%' THEN 'Cakes'
            WHEN Category LIKE '%pastry%' OR Category LIKE '%pastries%' THEN 'Pastries'
            WHEN Category LIKE '%bread%' THEN 'Bread'
            ELSE 'Other'
        END
    ORDER BY ProductCount DESC
    
    PRINT ''
    PRINT 'Orders by Product Category (if sales lines exist):'
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_SalesLines')
    BEGIN
        SELECT 
            CASE 
                WHEN p.Category LIKE '%cake%' THEN 'Cakes'
                WHEN p.Category LIKE '%pastry%' OR p.Category LIKE '%pastries%' THEN 'Pastries'
                WHEN p.Category LIKE '%bread%' THEN 'Bread'
                ELSE 'Other'
            END AS CategoryGroup,
            COUNT(DISTINCT s.SaleID) AS OrderCount,
            SUM(sl.Quantity) AS TotalQuantity
        FROM Demo_Sales s
        INNER JOIN Demo_SalesLines sl ON s.SaleID = sl.SaleID
        INNER JOIN Demo_Retail_Product p ON sl.ProductID = p.ProductID
        WHERE s.SaleDate >= DATEADD(DAY, -90, GETDATE())
        GROUP BY 
            CASE 
                WHEN p.Category LIKE '%cake%' THEN 'Cakes'
                WHEN p.Category LIKE '%pastry%' OR p.Category LIKE '%pastries%' THEN 'Pastries'
                WHEN p.Category LIKE '%bread%' THEN 'Bread'
                ELSE 'Other'
            END
        ORDER BY OrderCount DESC
    END
    ELSE
        PRINT 'Demo_SalesLines table does NOT exist'
END
ELSE
    PRINT 'Demo_Retail_Product table does NOT exist'

-- Check branches
PRINT ''
PRINT '=== CHECKING BRANCHES ==='
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Branches')
    SELECT BranchID, BranchName, IsActive FROM Branches
ELSE
    PRINT 'Branches table does NOT exist'
