/*
    CHECK STOCKROOM STOCK
    
    This query checks if stock was properly updated after GRV
*/

PRINT '========================================';
PRINT 'CHECKING STOCKROOM STOCK';
PRINT '========================================';
PRINT '';

-- Check StockroomStock table
PRINT 'StockroomStock Records:';
SELECT 
    ss.ProductID,
    rm.MaterialCode,
    rm.MaterialName,
    rm.MaterialType,
    b.BranchName,
    ss.Quantity,
    ss.LastUpdated
FROM StockroomStock ss
LEFT JOIN RawMaterials rm ON rm.MaterialID = ss.ProductID
LEFT JOIN Branches b ON b.BranchID = ss.BranchID
ORDER BY ss.LastUpdated DESC;

PRINT '';
PRINT 'RawMaterials.CurrentStock (Legacy):';
SELECT 
    MaterialID,
    MaterialCode,
    MaterialName,
    MaterialType,
    CurrentStock
FROM RawMaterials
WHERE CurrentStock > 0
ORDER BY MaterialCode;

PRINT '';
PRINT 'Recent Stock Movements:';
SELECT TOP 20
    sm.MovementDate,
    sm.MaterialID,
    rm.MaterialCode,
    rm.MaterialName,
    sm.MovementType,
    sm.QuantityIn,
    sm.QuantityOut,
    b.BranchName,
    sm.Notes
FROM StockMovements sm
LEFT JOIN RawMaterials rm ON rm.MaterialID = sm.MaterialID
LEFT JOIN Branches b ON b.BranchID = sm.BranchID
ORDER BY sm.MovementDate DESC;

PRINT '';
PRINT '✅ Check complete!';
