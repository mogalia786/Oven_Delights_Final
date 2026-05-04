-- Check PO-6-20260504130534 (the current PO)
DECLARE @PONumber VARCHAR(50) = 'PO-6-20260504130534';
DECLARE @POID INT;

SELECT @POID = PurchaseOrderID 
FROM PurchaseOrders 
WHERE PONumber = @PONumber;

PRINT 'Purchase Order ID: ' + CAST(ISNULL(@POID, 0) AS VARCHAR(10));

-- Count total lines in this PO
SELECT COUNT(*) AS TotalPOLines 
FROM PurchaseOrderLines 
WHERE PurchaseOrderID = @POID;

-- Show all lines
SELECT * 
FROM PurchaseOrderLines 
WHERE PurchaseOrderID = @POID 
ORDER BY POLineID;

-- Test the query with Demo_Retail_Product join
SELECT COALESCE(pol.MaterialID, pol.ProductID) AS ProductID,
       CASE 
         WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialCode 
         WHEN p.ProductID IS NOT NULL THEN p.ProductCode 
         WHEN drp.ProductID IS NOT NULL THEN drp.Code 
         ELSE COALESCE(CAST(pol.MaterialID AS NVARCHAR(20)), CAST(pol.ProductID AS NVARCHAR(20))) 
       END AS ProductCode,
       CASE 
         WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialName 
         WHEN p.ProductID IS NOT NULL THEN p.ProductName 
         WHEN drp.ProductID IS NOT NULL THEN drp.Name 
         ELSE 'Unknown Item' 
       END AS ProductName
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID 
LEFT JOIN Products p ON pol.ProductID = p.ProductID 
LEFT JOIN Demo_Retail_Product drp ON pol.ProductID = drp.ProductID 
WHERE pol.PurchaseOrderID = @POID;

-- Count results
SELECT COUNT(*) AS RowsReturned
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID 
LEFT JOIN Products p ON pol.ProductID = p.ProductID 
LEFT JOIN Demo_Retail_Product drp ON pol.ProductID = drp.ProductID 
WHERE pol.PurchaseOrderID = @POID;
