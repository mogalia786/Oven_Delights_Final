-- Debug why stock is not updating

-- 1. Check Bar One Spread in Demo_Retail_Product
SELECT ProductID, Name, Category, ProductType, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name LIKE '%Bar One Spread%'
ORDER BY BranchID

-- 2. Check recent Purchase Orders for Bar One Spread
SELECT TOP 5 po.POID, po.PONumber, po.OrderDate, pol.ProductID, pol.ProductName, pol.Quantity, pol.UnitCost
FROM PurchaseOrders po
INNER JOIN PurchaseOrderLines pol ON po.POID = pol.POID
WHERE pol.ProductName LIKE '%Bar One Spread%'
ORDER BY po.OrderDate DESC

-- 3. Check recent GRVs/Invoices
SELECT TOP 5 i.InvoiceID, i.InvoiceNumber, i.InvoiceDate, i.ReceivedDate
FROM Invoices i
ORDER BY i.InvoiceDate DESC

-- 4. Check StockMovements for Bar One Spread
SELECT TOP 10 sm.MovementDate, sm.MovementType, sm.QuantityIn, sm.MaterialID, sm.ReferenceNumber
FROM StockMovements sm
WHERE sm.ReferenceType = 'GRV'
ORDER BY sm.MovementDate DESC

-- 5. Manual test update - try to update stock directly
DECLARE @TestProductID INT
SELECT TOP 1 @TestProductID = ProductID FROM Demo_Retail_Product WHERE Name LIKE '%Bar One Spread%' AND BranchID = 1

IF @TestProductID IS NOT NULL
BEGIN
    PRINT 'Found ProductID: ' + CAST(@TestProductID AS VARCHAR(10))
    
    -- Try to update
    UPDATE Demo_Retail_Product 
    SET CurrentStock = ISNULL(CurrentStock, 0) + 10
    WHERE ProductID = @TestProductID AND BranchID = 1
    
    PRINT 'Updated stock for ProductID ' + CAST(@TestProductID AS VARCHAR(10))
    
    -- Show result
    SELECT ProductID, Name, BranchID, CurrentStock
    FROM Demo_Retail_Product
    WHERE ProductID = @TestProductID
END
ELSE
BEGIN
    PRINT 'ERROR: Bar One Spread not found in Demo_Retail_Product for BranchID = 1'
END
