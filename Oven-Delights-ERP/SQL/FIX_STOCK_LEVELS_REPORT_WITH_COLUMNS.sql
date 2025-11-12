-- =============================================
-- FIX: sp_Report_StockLevels (WITH ReorderLevel/MaxStock)
-- Only run this AFTER adding columns with ADD_STOCK_COLUMNS_TO_PRODUCTS.sql
-- =============================================

PRINT '🔧 Fixing Stock Levels Report (WITH ReorderLevel/MaxStock)...';
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
            WHEN ISNULL(p.MaxStock, 0) > 0 AND ISNULL(rs.Quantity, 0) >= ISNULL(p.MaxStock, 999999) THEN 'OVERSTOCK'
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
PRINT '📋 WHAT THIS VERSION DOES:';
PRINT '1. ✅ Reads from RetailStock table (real quantities)';
PRINT '2. ✅ Uses ReorderLevel from Products table';
PRINT '3. ✅ Uses MaxStock from Products table';
PRINT '4. ✅ Shows accurate stock status based on reorder levels';
PRINT '5. ✅ Filters low stock items correctly';
PRINT '6. ✅ Calculates total inventory value';
PRINT '';
PRINT '✅ Stock Levels Report fully functional with reorder alerts!';
PRINT '═══════════════════════════════════════════════';
