-- Debug: Check what items are in PO and why they might not show

-- 1. Find PO4 ID
SELECT PurchaseOrderID, PONumber, SupplierID, BranchID, Status
FROM PurchaseOrders
WHERE PONumber LIKE '%PO4%' OR PONumber LIKE '%4%'
ORDER BY CreatedDate DESC

-- 2. Check PO Lines for PO4 (replace @POID with actual ID from above)
DECLARE @POID INT = (SELECT TOP 1 PurchaseOrderID FROM PurchaseOrders WHERE PONumber LIKE '%4%' ORDER BY CreatedDate DESC)

SELECT 
    pol.POLineID,
    pol.MaterialID,
    pol.ProductID,
    pol.ItemSource,
    pol.OrderedQuantity,
    pol.ReceivedQuantity,
    pol.UnitCost,
    pol.LineTotal,
    -- Check if MaterialID exists
    CASE WHEN rm.MaterialID IS NOT NULL THEN 'Found in RawMaterials' ELSE 'NOT FOUND in RawMaterials' END AS MaterialStatus,
    rm.MaterialName,
    -- Check if ProductID exists
    CASE WHEN p.ProductID IS NOT NULL THEN 'Found in Demo_Retail_Product' ELSE 'NOT FOUND in Demo_Retail_Product' END AS ProductStatus,
    p.Name AS ProductName,
    p.BranchID AS ProductBranchID
FROM PurchaseOrderLines pol
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID AND p.BranchID = (SELECT BranchID FROM PurchaseOrders WHERE PurchaseOrderID = @POID)
WHERE pol.PurchaseOrderID = @POID
ORDER BY pol.POLineID

-- 3. Check if there are orphaned items (MaterialID or ProductID that don't exist)
SELECT 
    pol.POLineID,
    pol.MaterialID,
    pol.ProductID,
    pol.ItemSource,
    'ORPHANED - No matching record' AS Issue
FROM PurchaseOrderLines pol
LEFT JOIN RawMaterials rm ON pol.MaterialID = rm.MaterialID
LEFT JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID AND p.BranchID = (SELECT BranchID FROM PurchaseOrders WHERE PurchaseOrderID = @POID)
WHERE pol.PurchaseOrderID = @POID
  AND rm.MaterialID IS NULL 
  AND p.ProductID IS NULL
