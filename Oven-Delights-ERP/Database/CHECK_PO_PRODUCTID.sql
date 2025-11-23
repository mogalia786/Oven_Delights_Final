-- Check what ProductID is stored in the most recent PO

-- 1. Show recent Purchase Orders
SELECT TOP 5 PurchaseOrderID, PONumber, BranchID, OrderDate, Status
FROM PurchaseOrders
ORDER BY OrderDate DESC

-- 2. Show lines from the most recent PO
DECLARE @LatestPOID INT
SELECT TOP 1 @LatestPOID = PurchaseOrderID FROM PurchaseOrders ORDER BY OrderDate DESC

PRINT 'Latest PO ID: ' + CAST(@LatestPOID AS VARCHAR(10))

SELECT pol.POLineID, pol.ProductID, pol.MaterialID, pol.ItemSource, pol.OrderedQuantity, pol.UnitCost,
       p.Name AS ProductName, p.BranchID AS ProductBranchID
FROM PurchaseOrderLines pol
LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID
WHERE pol.PurchaseOrderID = @LatestPOID

-- 3. Check if Bar One Spread is in the PO
SELECT pol.POLineID, pol.ProductID, pol.MaterialID, p.Name, p.BranchID
FROM PurchaseOrderLines pol
LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID
WHERE pol.PurchaseOrderID = @LatestPOID
  AND p.Name LIKE '%Bar One Spread%'
