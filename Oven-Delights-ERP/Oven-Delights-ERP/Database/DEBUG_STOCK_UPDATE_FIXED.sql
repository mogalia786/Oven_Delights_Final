-- Debug why stock is not updating - FIXED column names

-- 1. Check Bar One Spread in Demo_Retail_Product
PRINT '=== 1. Bar One Spread in Demo_Retail_Product ==='
SELECT ProductID, Name, Category, ProductType, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name LIKE '%Bar One Spread%'
ORDER BY BranchID

-- 2. Check PurchaseOrders table structure
PRINT '=== 2. Recent Purchase Orders ==='
SELECT TOP 5 * FROM PurchaseOrders ORDER BY CreatedDate DESC

-- 3. Check PurchaseOrderLines table structure  
PRINT '=== 3. Recent Purchase Order Lines ==='
SELECT TOP 5 * FROM PurchaseOrderLines ORDER BY LineID DESC

-- 4. Check Invoices table structure
PRINT '=== 4. Recent Invoices ==='
SELECT TOP 5 * FROM Invoices ORDER BY CreatedDate DESC

-- 5. Check InvoiceLines table structure
PRINT '=== 5. Recent Invoice Lines ==='
SELECT TOP 5 * FROM InvoiceLines ORDER BY LineID DESC

-- 6. Check StockMovements
PRINT '=== 6. Recent Stock Movements ==='
SELECT TOP 10 * FROM StockMovements 
WHERE ReferenceType = 'GRV'
ORDER BY CreatedDate DESC

-- 7. Manual test update - try to update stock directly
PRINT '=== 7. Manual Stock Update Test ==='
DECLARE @TestProductID INT
DECLARE @TestBranchID INT = 1

SELECT TOP 1 @TestProductID = ProductID 
FROM Demo_Retail_Product 
WHERE Name LIKE '%Bar One Spread%' AND BranchID = @TestBranchID

IF @TestProductID IS NOT NULL
BEGIN
    PRINT 'Found ProductID: ' + CAST(@TestProductID AS VARCHAR(10))
    
    -- Show before
    SELECT 'BEFORE UPDATE' AS Status, ProductID, Name, BranchID, CurrentStock
    FROM Demo_Retail_Product
    WHERE ProductID = @TestProductID AND BranchID = @TestBranchID
    
    -- Try to update
    UPDATE Demo_Retail_Product 
    SET CurrentStock = ISNULL(CurrentStock, 0) + 10
    WHERE ProductID = @TestProductID AND BranchID = @TestBranchID
    
    PRINT 'Updated stock for ProductID ' + CAST(@TestProductID AS VARCHAR(10))
    
    -- Show after
    SELECT 'AFTER UPDATE' AS Status, ProductID, Name, BranchID, CurrentStock
    FROM Demo_Retail_Product
    WHERE ProductID = @TestProductID AND BranchID = @TestBranchID
END
ELSE
BEGIN
    PRINT 'ERROR: Bar One Spread not found in Demo_Retail_Product for BranchID = ' + CAST(@TestBranchID AS VARCHAR(10))
END
