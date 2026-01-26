-- =============================================
-- POPULATE DASHBOARD TEST DATA
-- Creates sample invoices and orders for testing
-- =============================================

USE Oven_Delights_Main
GO

-- Create CustomerInvoices table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'CustomerInvoices')
BEGIN
    CREATE TABLE CustomerInvoices (
        InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
        InvoiceNumber NVARCHAR(50) NOT NULL,
        CustomerID INT NULL,
        BranchID INT NOT NULL,
        InvoiceDate DATETIME NOT NULL DEFAULT GETDATE(),
        DueDate DATETIME NULL,
        TotalAmount DECIMAL(18,2) NOT NULL DEFAULT 0,
        PaymentStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending',
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_CustomerInvoices_Branch FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
    )
    PRINT 'CustomerInvoices table created'
END
GO

-- Populate sample customer invoices across branches
DECLARE @BranchCount INT = (SELECT COUNT(*) FROM Branches WHERE IsActive = 1)
DECLARE @BranchID INT
DECLARE @Counter INT = 1

DECLARE branch_cursor CURSOR FOR 
SELECT BranchID FROM Branches WHERE IsActive = 1

OPEN branch_cursor
FETCH NEXT FROM branch_cursor INTO @BranchID

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Paid invoices (60%)
    INSERT INTO CustomerInvoices (InvoiceNumber, BranchID, InvoiceDate, TotalAmount, PaymentStatus)
    VALUES 
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-001', @BranchID, DATEADD(DAY, -80, GETDATE()), 15000 + (@Counter * 1000), 'Paid'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-002', @BranchID, DATEADD(DAY, -70, GETDATE()), 22000 + (@Counter * 1500), 'Paid'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-003', @BranchID, DATEADD(DAY, -60, GETDATE()), 18000 + (@Counter * 1200), 'Paid'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-004', @BranchID, DATEADD(DAY, -50, GETDATE()), 25000 + (@Counter * 2000), 'Paid'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-005', @BranchID, DATEADD(DAY, -40, GETDATE()), 19000 + (@Counter * 1300), 'Paid'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-006', @BranchID, DATEADD(DAY, -30, GETDATE()), 21000 + (@Counter * 1400), 'Paid')

    -- Outstanding invoices (40%)
    INSERT INTO CustomerInvoices (InvoiceNumber, BranchID, InvoiceDate, DueDate, TotalAmount, PaymentStatus)
    VALUES 
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-007', @BranchID, DATEADD(DAY, -25, GETDATE()), DATEADD(DAY, 5, GETDATE()), 12000 + (@Counter * 800), 'Pending'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-008', @BranchID, DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, 10, GETDATE()), 16000 + (@Counter * 1100), 'Pending'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-009', @BranchID, DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, 15, GETDATE()), 14000 + (@Counter * 900), 'Partial'),
        ('INV-' + CAST(@BranchID AS VARCHAR) + '-010', @BranchID, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, 20, GETDATE()), 18000 + (@Counter * 1200), 'Pending')

    SET @Counter = @Counter + 1
    FETCH NEXT FROM branch_cursor INTO @BranchID
END

CLOSE branch_cursor
DEALLOCATE branch_cursor

PRINT 'Customer invoices populated'
GO

-- Add cake category products if they don't exist
IF NOT EXISTS (SELECT * FROM Demo_Retail_Product WHERE Category LIKE '%cake%')
BEGIN
    -- Get a branch ID for initial stock
    DECLARE @FirstBranch INT = (SELECT TOP 1 BranchID FROM Branches WHERE IsActive = 1)
    
    -- Insert cake products
    INSERT INTO Demo_Retail_Product (Name, Category, SKU, IsActive, ProductType)
    VALUES 
        ('Chocolate Cake', 'Cakes', 'CAKE-001', 1, 'Internal'),
        ('Vanilla Cake', 'Cakes', 'CAKE-002', 1, 'Internal'),
        ('Red Velvet Cake', 'Cakes', 'CAKE-003', 1, 'Internal'),
        ('Carrot Cake', 'Cakes', 'CAKE-004', 1, 'Internal'),
        ('Black Forest Cake', 'Cakes', 'CAKE-005', 1, 'Internal')
    
    PRINT 'Cake products added'
END
GO

-- Add pastry category products if they don't exist
IF NOT EXISTS (SELECT * FROM Demo_Retail_Product WHERE Category LIKE '%pastry%')
BEGIN
    INSERT INTO Demo_Retail_Product (Name, Category, SKU, IsActive, ProductType)
    VALUES 
        ('Croissant', 'Pastries', 'PAST-001', 1, 'Internal'),
        ('Danish Pastry', 'Pastries', 'PAST-002', 1, 'Internal'),
        ('Eclair', 'Pastries', 'PAST-003', 1, 'Internal'),
        ('Apple Turnover', 'Pastries', 'PAST-004', 1, 'Internal')
    
    PRINT 'Pastry products added'
END
GO

-- Add bread category products if they don't exist
IF NOT EXISTS (SELECT * FROM Demo_Retail_Product WHERE Category LIKE '%bread%')
BEGIN
    INSERT INTO Demo_Retail_Product (Name, Category, SKU, IsActive, ProductType)
    VALUES 
        ('White Bread Loaf', 'Bread', 'BREAD-001', 1, 'Internal'),
        ('Whole Wheat Bread', 'Bread', 'BREAD-002', 1, 'Internal'),
        ('Sourdough Bread', 'Bread', 'BREAD-003', 1, 'Internal')
    
    PRINT 'Bread products added'
END
GO

-- Create more diverse sales with different product categories
DECLARE @SaleCounter INT = 1
DECLARE @BranchID2 INT
DECLARE @ProductID INT
DECLARE @CakeID INT
DECLARE @PastryID INT
DECLARE @BreadID INT

-- Get sample product IDs
SELECT TOP 1 @CakeID = ProductID FROM Demo_Retail_Product WHERE Category LIKE '%cake%'
SELECT TOP 1 @PastryID = ProductID FROM Demo_Retail_Product WHERE Category LIKE '%pastry%'
SELECT TOP 1 @BreadID = ProductID FROM Demo_Retail_Product WHERE Category LIKE '%bread%'

DECLARE branch_cursor2 CURSOR FOR 
SELECT BranchID FROM Branches WHERE IsActive = 1

OPEN branch_cursor2
FETCH NEXT FROM branch_cursor2 INTO @BranchID2

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Create 20 sales per branch over last 90 days with different product types
    DECLARE @DayOffset INT = -90
    WHILE @DayOffset <= -1
    BEGIN
        -- Cake order (30% of orders)
        IF @DayOffset % 3 = 0 AND @CakeID IS NOT NULL
        BEGIN
            INSERT INTO Demo_Sales (BranchID, SaleDate, TotalAmount, PaymentMethod)
            VALUES (@BranchID2, DATEADD(DAY, @DayOffset, GETDATE()), 250 + (ABS(@DayOffset) * 2), 'Cash')
            
            INSERT INTO Demo_SalesLines (SaleID, ProductID, Quantity, UnitPrice)
            VALUES (SCOPE_IDENTITY(), @CakeID, 1, 250 + (ABS(@DayOffset) * 2))
        END
        
        -- Pastry order (25% of orders)
        IF @DayOffset % 4 = 0 AND @PastryID IS NOT NULL
        BEGIN
            INSERT INTO Demo_Sales (BranchID, SaleDate, TotalAmount, PaymentMethod)
            VALUES (@BranchID2, DATEADD(DAY, @DayOffset, GETDATE()), 45 + (ABS(@DayOffset) * 0.5), 'Card')
            
            INSERT INTO Demo_SalesLines (SaleID, ProductID, Quantity, UnitPrice)
            VALUES (SCOPE_IDENTITY(), @PastryID, 3, 15 + (ABS(@DayOffset) * 0.15))
        END
        
        -- Bread order (25% of orders)
        IF @DayOffset % 5 = 0 AND @BreadID IS NOT NULL
        BEGIN
            INSERT INTO Demo_Sales (BranchID, SaleDate, TotalAmount, PaymentMethod)
            VALUES (@BranchID2, DATEADD(DAY, @DayOffset, GETDATE()), 60 + (ABS(@DayOffset) * 0.8), 'Cash')
            
            INSERT INTO Demo_SalesLines (SaleID, ProductID, Quantity, UnitPrice)
            VALUES (SCOPE_IDENTITY(), @BreadID, 2, 30 + (ABS(@DayOffset) * 0.4))
        END
        
        SET @DayOffset = @DayOffset + 4
    END
    
    FETCH NEXT FROM branch_cursor2 INTO @BranchID2
END

CLOSE branch_cursor2
DEALLOCATE branch_cursor2

PRINT 'Additional sales with product categories created'
GO

-- Summary
SELECT 
    'Customer Invoices' AS DataType,
    COUNT(*) AS RecordCount,
    SUM(CASE WHEN PaymentStatus = 'Paid' THEN TotalAmount ELSE 0 END) AS TotalPaid,
    SUM(CASE WHEN PaymentStatus IN ('Pending', 'Partial') THEN TotalAmount ELSE 0 END) AS TotalOutstanding
FROM CustomerInvoices

UNION ALL

SELECT 
    'Demo Sales' AS DataType,
    COUNT(*) AS RecordCount,
    SUM(TotalAmount) AS TotalPaid,
    0 AS TotalOutstanding
FROM Demo_Sales

UNION ALL

SELECT 
    'Cake Products' AS DataType,
    COUNT(*) AS RecordCount,
    0 AS TotalPaid,
    0 AS TotalOutstanding
FROM Demo_Retail_Product WHERE Category LIKE '%cake%'

UNION ALL

SELECT 
    'Pastry Products' AS DataType,
    COUNT(*) AS RecordCount,
    0 AS TotalPaid,
    0 AS TotalOutstanding
FROM Demo_Retail_Product WHERE Category LIKE '%pastry%'

UNION ALL

SELECT 
    'Bread Products' AS DataType,
    COUNT(*) AS RecordCount,
    0 AS TotalPaid,
    0 AS TotalOutstanding
FROM Demo_Retail_Product WHERE Category LIKE '%bread%'

PRINT '✅ Dashboard test data populated successfully!'
PRINT 'Refresh the JARVIS Executive Dashboard to see the data'
