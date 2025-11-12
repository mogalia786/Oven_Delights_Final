-- =============================================
-- POPULATE RetailStock from Completed Re-Order Books
-- =============================================
-- This script will populate RetailStock with products
-- that were already completed before the fix was applied
-- =============================================

PRINT '🔄 Populating RetailStock from completed re-order books...';
PRINT '';

-- Check if there are completed products
DECLARE @CompletedCount INT;
SELECT @CompletedCount = COUNT(*)
FROM ReOrderBookLines
WHERE LineStatus = 'Completed';

PRINT 'Found ' + CAST(@CompletedCount AS NVARCHAR(10)) + ' completed product lines';
PRINT '';

IF @CompletedCount = 0
BEGIN
    PRINT '⚠️  No completed products found!';
    PRINT '   Complete a product in Baker Production View first.';
    RETURN;
END

-- Show what will be added
PRINT '📋 Products that will be added to RetailStock:';
SELECT 
    rol.ProductID,
    rol.ProductName,
    SUM(rol.QuantityCompleted) AS TotalQuantity,
    rob.BranchID,
    COUNT(*) AS CompletionCount
FROM ReOrderBookLines rol
INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
WHERE rol.LineStatus = 'Completed'
  AND rol.QuantityCompleted > 0
GROUP BY rol.ProductID, rol.ProductName, rob.BranchID
ORDER BY rol.ProductName;

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '⚠️  WARNING: This will add the above quantities to RetailStock';
PRINT '   Make sure this is correct before proceeding!';
PRINT '';
PRINT 'To proceed, uncomment the INSERT statement below and run again.';
PRINT '═══════════════════════════════════════════════';

-- UNCOMMENT THE SECTION BELOW TO ACTUALLY INSERT THE DATA
/*
BEGIN TRANSACTION;

BEGIN TRY
    -- Insert aggregated quantities into RetailStock
    INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
    SELECT 
        rol.ProductID,
        rob.BranchID,
        SUM(rol.QuantityCompleted) AS TotalQuantity,
        'Internal',
        GETDATE(),
        'System Migration'
    FROM ReOrderBookLines rol
    INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
    WHERE rol.LineStatus = 'Completed'
      AND rol.QuantityCompleted > 0
      -- Only insert if not already in RetailStock
      AND NOT EXISTS (
          SELECT 1 
          FROM RetailStock rs 
          WHERE rs.ProductID = rol.ProductID 
            AND rs.BranchID = rob.BranchID 
            AND rs.StockType = 'Internal'
      )
    GROUP BY rol.ProductID, rob.BranchID;
    
    DECLARE @RowsInserted INT = @@ROWCOUNT;
    
    -- Update existing records (if any)
    UPDATE rs
    SET 
        rs.Quantity = rs.Quantity + agg.TotalQuantity,
        rs.LastUpdated = GETDATE(),
        rs.UpdatedBy = 'System Migration'
    FROM RetailStock rs
    INNER JOIN (
        SELECT 
            rol.ProductID,
            rob.BranchID,
            SUM(rol.QuantityCompleted) AS TotalQuantity
        FROM ReOrderBookLines rol
        INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
        WHERE rol.LineStatus = 'Completed'
          AND rol.QuantityCompleted > 0
        GROUP BY rol.ProductID, rob.BranchID
    ) agg ON rs.ProductID = agg.ProductID 
         AND rs.BranchID = agg.BranchID 
         AND rs.StockType = 'Internal';
    
    DECLARE @RowsUpdated INT = @@ROWCOUNT;
    
    COMMIT TRANSACTION;
    
    PRINT '';
    PRINT '✅ SUCCESS!';
    PRINT 'Rows inserted: ' + CAST(@RowsInserted AS NVARCHAR(10));
    PRINT 'Rows updated: ' + CAST(@RowsUpdated AS NVARCHAR(10));
    PRINT '';
    PRINT 'Run the verification query to see the results:';
    PRINT 'SELECT * FROM RetailStock WHERE StockType = ''Internal''';
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT '';
    PRINT '❌ ERROR: ' + ERROR_MESSAGE();
END CATCH
*/

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 INSTRUCTIONS:';
PRINT '1. Review the products listed above';
PRINT '2. If correct, uncomment the INSERT section (remove /* and */)';
PRINT '3. Run this script again';
PRINT '4. Verify with: SELECT * FROM RetailStock';
PRINT '═══════════════════════════════════════════════';
