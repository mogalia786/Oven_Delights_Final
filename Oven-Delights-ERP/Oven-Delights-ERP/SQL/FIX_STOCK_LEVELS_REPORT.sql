-- =============================================
-- FIX: sp_Report_StockLevels to read from RetailStock
-- =============================================

PRINT '🔧 Fixing Stock Levels Report to read from RetailStock...';
GO

IF OBJECT_ID('sp_Report_StockLevels', 'P') IS NOT NULL
    DROP PROCEDURE sp_Report_StockLevels;
GO

CREATE PROCEDURE sp_Report_StockLevels
    @BranchID INT = 0,
    @LowStockOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get stock levels from RetailStock table
    SELECT 
        p.ProductCode,
        p.ProductName,
        p.CategoryID,
        p.ItemType,
        p.BaseUoM,
        ISNULL(rs.Quantity, 0) AS CurrentStock,
        ISNULL(p.ReorderLevel, 0) AS ReorderLevel,
        ISNULL(p.MaxStock, 0) AS MaxStock,
        ISNULL(p.LastPaidPrice, 0.00) AS UnitCost,
        ISNULL(rs.Quantity, 0) * ISNULL(p.LastPaidPrice, 0.00) AS TotalValue,
        CASE 
            WHEN ISNULL(rs.Quantity, 0) = 0 THEN 'OUT OF STOCK'
            WHEN ISNULL(rs.Quantity, 0) <= ISNULL(p.ReorderLevel, 0) THEN 'LOW STOCK'
            WHEN ISNULL(rs.Quantity, 0) >= ISNULL(p.MaxStock, 999999) THEN 'OVERSTOCK'
            ELSE 'NORMAL'
        END AS StockStatus
    FROM Products p
    LEFT JOIN RetailStock rs ON p.ProductID = rs.ProductID 
        AND rs.StockType = 'Internal'
        AND (@BranchID = 0 OR rs.BranchID = @BranchID)
    WHERE p.IsActive = 1
      AND (@LowStockOnly = 0 OR ISNULL(rs.Quantity, 0) <= ISNULL(p.ReorderLevel, 0))
    ORDER BY p.ProductName;
END;
GO

PRINT '';
PRINT '✅ sp_Report_StockLevels updated successfully!';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 WHAT CHANGED:';
PRINT '1. Now reads from RetailStock table (actual inventory)';
PRINT '2. Shows real quantities instead of hardcoded 0';
PRINT '3. Calculates stock status (Out of Stock, Low Stock, Normal)';
PRINT '4. Calculates total value based on LastPaidPrice';
PRINT '5. Filters by branch if specified';
PRINT '6. Shows low stock items only if checkbox checked';
PRINT '';
PRINT '✅ Stock Levels Report will now show correct quantities!';
PRINT '═══════════════════════════════════════════════';
