-- Test the EXACT query that should now be running in GetPurchaseOrderLines
DECLARE @POID INT = 322;

SELECT COALESCE(pol.MaterialID, pol.ProductID) AS ProductID,
       CASE 
         WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialCode 
         WHEN p.ProductID IS NOT NULL THEN p.ProductCode 
         WHEN sp.ProductID IS NOT NULL THEN sp.Code 
         WHEN drp.ProductID IS NOT NULL THEN drp.Code 
         ELSE COALESCE(CAST(pol.MaterialID AS NVARCHAR(20)), CAST(pol.ProductID AS NVARCHAR(20))) 
       END AS ProductCode,
       CASE 
         WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialName 
         WHEN p.ProductID IS NOT NULL THEN p.ProductName 
         WHEN drp.ProductID IS NOT NULL THEN 'Demo Product' 
         ELSE 'Unknown Item' 
       END AS ProductName,
       pol.OrderedQuantity AS OrderQuantity, 
       pol.ReceivedQuantity, 
       pol.UnitCost, 
       pol.LineTotal
FROM PurchaseOrderLines pol 
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID 
LEFT JOIN Products p ON pol.ProductID = p.ProductID 
LEFT JOIN Stockroom_Product sp ON pol.ProductID = sp.ProductID 
LEFT JOIN Demo_Retail_Product drp ON pol.ProductID = drp.ProductID 
WHERE pol.PurchaseOrderID = @POID
ORDER BY pol.POLineID;

-- Count results
SELECT COUNT(*) AS TotalRows FROM (
    SELECT pol.POLineID
    FROM PurchaseOrderLines pol 
    LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID 
    LEFT JOIN Products p ON pol.ProductID = p.ProductID 
    LEFT JOIN Stockroom_Product sp ON pol.ProductID = sp.ProductID 
    LEFT JOIN Demo_Retail_Product drp ON pol.ProductID = drp.ProductID 
    WHERE pol.PurchaseOrderID = @POID
) AS Results;
