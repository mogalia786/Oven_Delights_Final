-- Check what's stored in Purchase Order for Salt Bale
-- This will show if the PO was created with the correct price

-- 1. Find Purchase Orders with Salt Bale
SELECT 
    po.PurchaseOrderID,
    po.PONumber,
    po.OrderDate,
    po.Status,
    s.CompanyName AS Supplier
FROM PurchaseOrders po
INNER JOIN Suppliers s ON po.SupplierID = s.SupplierID
WHERE po.PurchaseOrderID IN (
    SELECT DISTINCT PurchaseOrderID 
    FROM PurchaseOrderLines pol
    INNER JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID
    WHERE p.Name LIKE '%Salt Bale%'
)
ORDER BY po.OrderDate DESC;

-- 2. Check PurchaseOrderLines for Salt Bale
SELECT 
    pol.PurchaseOrderLineID,
    po.PONumber,
    p.Name AS ProductName,
    p.IsVatable,
    pol.Quantity,
    pol.UnitPrice,
    pol.LineTotal,
    po.OrderDate
FROM PurchaseOrderLines pol
INNER JOIN PurchaseOrders po ON pol.PurchaseOrderID = po.PurchaseOrderID
INNER JOIN Demo_Retail_Product p ON pol.ProductID = p.ProductID
WHERE p.Name LIKE '%Salt Bale%'
ORDER BY po.OrderDate DESC;

-- EXPECTED RESULTS:
-- If Salt Bale is non-vatable and should be R20:
-- - pol.UnitPrice should be 20.00 (NOT 17.39)
-- - If you see 17.39, the PO was created BEFORE the fix was applied
-- - You need to create a NEW Purchase Order AFTER rebuilding to test the fix

-- DIAGNOSIS:
-- If UnitPrice = 17.39:
--   - This PO was created with the OLD code (before fix)
--   - The fix only affects NEW Purchase Orders created after rebuild
--   - Create a new PO with Salt Bale to test the fix
--   - The new PO should save UnitPrice = 20.00 for non-vatable items
