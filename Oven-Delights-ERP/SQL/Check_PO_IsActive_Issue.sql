-- Check IsActive status for PO-6-20260501125339
-- Find which items have IsActive = 0

DECLARE @PONumber VARCHAR(50) = 'PO-6-20260501125339';
DECLARE @POID INT;

SELECT @POID = PurchaseOrderID 
FROM PurchaseOrders 
WHERE PONumber = @PONumber;

PRINT 'Purchase Order ID: ' + CAST(ISNULL(@POID, 0) AS VARCHAR(10));
PRINT '';

-- Show ALL PO lines with IsActive status
PRINT '=== ALL PURCHASE ORDER LINES ===';
SELECT 
    pol.POLineID,
    pol.MaterialID,
    pol.ProductID,
    pol.OrderedQuantity,
    pol.UnitCost,
    pol.IsActive,
    CASE 
        WHEN pol.IsActive = 1 THEN 'ACTIVE - Will show in GRV'
        WHEN pol.IsActive = 0 THEN 'INACTIVE - MISSING FROM GRV'
        WHEN pol.IsActive IS NULL THEN 'NULL - MISSING FROM GRV'
    END AS Status
FROM PurchaseOrderLines pol
WHERE pol.PurchaseOrderID = @POID
ORDER BY pol.POLineID;

PRINT '';
PRINT '=== SUMMARY ===';
SELECT 
    COUNT(*) AS TotalLines,
    SUM(CASE WHEN IsActive = 1 THEN 1 ELSE 0 END) AS ActiveLines,
    SUM(CASE WHEN ISNULL(IsActive, 0) = 0 THEN 1 ELSE 0 END) AS InactiveOrNullLines
FROM PurchaseOrderLines
WHERE PurchaseOrderID = @POID;

PRINT '';
PRINT '=== ITEMS WITH IsActive = 0 or NULL (MISSING FROM GRV) ===';
SELECT 
    pol.POLineID,
    pol.MaterialID,
    pol.ProductID,
    pol.IsActive
FROM PurchaseOrderLines pol
WHERE pol.PurchaseOrderID = @POID
  AND ISNULL(pol.IsActive, 0) = 0
ORDER BY pol.POLineID;

PRINT '';
PRINT '=== FIX SCRIPT ===';
PRINT 'To fix the missing items, uncomment and run the UPDATE below:';
PRINT '';

/*
-- FIX: Set IsActive = 1 for all lines in this PO
UPDATE PurchaseOrderLines
SET IsActive = 1
WHERE PurchaseOrderID = @POID
  AND ISNULL(IsActive, 0) = 0;

SELECT @@ROWCOUNT AS RowsFixed;
PRINT 'Fixed ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' lines';
*/

GO
