-- Test which ProductIDs from your PO actually exist in Products vs Stockroom_Product tables
DECLARE @POID INT = 322;

-- Show all ProductIDs from the PO
SELECT DISTINCT pol.ProductID
FROM PurchaseOrderLines pol
WHERE pol.PurchaseOrderID = @POID
ORDER BY pol.ProductID;

-- Check which ProductIDs exist in Products table
SELECT pol.ProductID, p.ProductID AS FoundInProducts, p.ProductName, p.ProductCode
FROM PurchaseOrderLines pol
LEFT JOIN Products p ON pol.ProductID = p.ProductID
WHERE pol.PurchaseOrderID = @POID
ORDER BY pol.ProductID;

-- Check which ProductIDs exist in Stockroom_Product table
SELECT pol.ProductID, sp.ProductID AS FoundInStockroom, sp.* 
FROM PurchaseOrderLines pol
LEFT JOIN Stockroom_Product sp ON pol.ProductID = sp.ProductID
WHERE pol.PurchaseOrderID = @POID
ORDER BY pol.ProductID;

-- Show which items would have NULL names (the missing ones)
SELECT pol.POLineID, pol.ProductID,
       p.ProductName AS FromProducts,
       CASE WHEN sp.ProductID IS NOT NULL THEN 'Found in Stockroom_Product' ELSE NULL END AS FromStockroom,
       COALESCE(p.ProductName, 'NOT FOUND') AS FinalName
FROM PurchaseOrderLines pol
LEFT JOIN Products p ON pol.ProductID = p.ProductID
LEFT JOIN Stockroom_Product sp ON pol.ProductID = sp.ProductID
WHERE pol.PurchaseOrderID = @POID
ORDER BY pol.POLineID;
