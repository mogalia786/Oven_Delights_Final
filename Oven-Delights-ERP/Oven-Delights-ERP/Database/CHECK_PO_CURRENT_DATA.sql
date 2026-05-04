-- Check the current data for PO-2-20260211025058
-- This will show what's actually in the database after the Edit PO update

SELECT 
    po.PurchaseOrderID,
    po.PONumber,
    po.OrderDate,
    po.SupplierID,
    s.CompanyName AS SupplierName,
    po.SubTotal,
    po.VATAmount,
    po.TotalAmount
FROM PurchaseOrders po
INNER JOIN Suppliers s ON po.SupplierID = s.SupplierID
WHERE po.PONumber = 'PO-2-20260211025058'

-- Check the PO lines
SELECT 
    pol.POLineID,
    pol.MaterialID,
    pol.ProductID,
    CASE 
        WHEN rm.MaterialID IS NOT NULL THEN rm.MaterialName
        WHEN p.ProductID IS NOT NULL THEN p.Name
        ELSE 'Unknown'
    END AS ProductName,
    pol.OrderedQuantity,
    pol.UnitCost,
    pol.IsVatable,
    pol.ItemSource,
    (pol.OrderedQuantity * pol.UnitCost) AS LineTotal
FROM PurchaseOrderLines pol
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID
WHERE pol.PurchaseOrderID = (
    SELECT PurchaseOrderID FROM PurchaseOrders WHERE PONumber = 'PO-2-20260211025058'
)
ORDER BY pol.POLineID
