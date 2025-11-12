-- =============================================
-- CHECK: Do you have any completed products?
-- =============================================

PRINT '🔍 Checking for completed products...';
PRINT '';

-- Check ReOrderBookLines
PRINT '1️⃣ Completed Re-Order Book Lines:';
SELECT 
    rol.ReOrderLineID,
    rob.ReOrderNumber,
    rol.ProductName,
    rol.QuantityOrdered,
    rol.QuantityCompleted,
    rol.LineStatus,
    rol.CompletedBy,
    rol.CompletedDate,
    rol.RetailStockUpdated,
    rob.BranchID
FROM ReOrderBookLines rol
INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
WHERE rol.LineStatus = 'Completed'
ORDER BY rol.CompletedDate DESC;

IF @@ROWCOUNT = 0
BEGIN
    PRINT '';
    PRINT '❌ NO completed products found!';
    PRINT '';
    PRINT '📋 This means:';
    PRINT '1. You have not completed any products yet, OR';
    PRINT '2. The completion process is not working';
    PRINT '';
    PRINT '🔧 SOLUTION:';
    PRINT '1. Run FIX_RETAIL_STOCK_SAFE.sql to update the stored procedure';
    PRINT '2. Open Baker Production View';
    PRINT '3. Complete a product';
    PRINT '4. Check RetailStock again';
END
ELSE
BEGIN
    PRINT '';
    PRINT '✅ Completed products found!';
    PRINT '';
    PRINT '📋 Next check: Were they added to RetailStock?';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';

-- Check RetailStock
PRINT '2️⃣ RetailStock Table:';
SELECT 
    rs.RetailStockID,
    p.ProductName,
    rs.Quantity,
    rs.StockType,
    rs.BranchID,
    rs.LastUpdated,
    rs.UpdatedBy
FROM RetailStock rs
INNER JOIN Products p ON rs.ProductID = p.ProductID
WHERE rs.StockType = 'Internal'
ORDER BY rs.LastUpdated DESC;

IF @@ROWCOUNT = 0
BEGIN
    PRINT '';
    PRINT '❌ RetailStock is EMPTY!';
    PRINT '';
    PRINT '📋 This means:';
    PRINT '1. The stored procedure was not updated yet, OR';
    PRINT '2. Products were completed BEFORE the fix was applied';
    PRINT '';
    PRINT '🔧 SOLUTION:';
    PRINT 'Option A - Update procedure and complete NEW product:';
    PRINT '  1. Run FIX_RETAIL_STOCK_SAFE.sql';
    PRINT '  2. Complete a NEW product';
    PRINT '';
    PRINT 'Option B - Populate from existing completed products:';
    PRINT '  1. Run POPULATE_RETAIL_STOCK_FROM_HISTORY.sql';
    PRINT '  2. Review the products it will add';
    PRINT '  3. Uncomment the INSERT section and run again';
END
ELSE
BEGIN
    PRINT '';
    PRINT '✅ RetailStock has products!';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';

-- Check StockMovements
PRINT '3️⃣ Stock Movements (Production Complete):';
SELECT TOP 5
    sm.MovementID,
    sm.MovementDate,
    p.ProductName,
    sm.QuantityIn,
    sm.BalanceAfter,
    sm.ReferenceNumber,
    sm.CreatedBy
FROM StockMovements sm
INNER JOIN Products p ON sm.MaterialID = p.ProductID
WHERE sm.MovementType = 'Production Complete'
ORDER BY sm.MovementID DESC;

IF @@ROWCOUNT = 0
BEGIN
    PRINT '';
    PRINT '❌ NO Production Complete movements found!';
    PRINT '   This confirms no products have been completed yet.';
END
ELSE
BEGIN
    PRINT '';
    PRINT '✅ Stock movements exist (audit trail working)';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 SUMMARY:';
PRINT '';
PRINT 'Check the results above to determine next steps.';
PRINT '';
PRINT 'If NO completed products: Complete a product first';
PRINT 'If completed products but NO RetailStock: Run FIX_RETAIL_STOCK_SAFE.sql';
PRINT 'If you want to populate from history: Run POPULATE_RETAIL_STOCK_FROM_HISTORY.sql';
PRINT '═══════════════════════════════════════════════';
