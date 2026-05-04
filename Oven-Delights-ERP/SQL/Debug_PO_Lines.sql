-- Debug: Check exact PO lines for PO-6-20260501125339
DECLARE @PONumber VARCHAR(50) = 'PO-6-20260501125339';
DECLARE @POID INT;

SELECT @POID = PurchaseOrderID 
FROM PurchaseOrders 
WHERE PONumber = @PONumber;

-- Show raw PO lines data
SELECT * FROM PurchaseOrderLines WHERE PurchaseOrderID = @POID ORDER BY POLineID;

-- Count how many lines exist
SELECT COUNT(*) AS TotalPOLines FROM PurchaseOrderLines WHERE PurchaseOrderID = @POID;
