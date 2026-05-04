-- =============================================
-- FIX: sp_Report_StockLevels (SAFE VERSION)
-- Works without ReorderLevel/MaxStock columns
-- =============================================

PRINT '🔧 Fixing Stock Levels Report (SAFE VERSION)...';
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
    -- Uses 0 for ReorderLevel/MaxStock if columns don't exist
    SELECT 
        p.ProductCode,
        p.ProductName,
        p.CategoryID,
        p.ItemType,
        p.BaseUoM,
        ISNULL(rs.Quantity, 0) AS CurrentStock,
        0 AS ReorderLevel,  -- Default to 0 if column doesn't exist
        0 AS MaxStock,      -- Default to 0 if column doesn't exist
        ISNULL(p.LastPaidPrice, 0.00) AS UnitCost,
        ISNULL(rs.Quantity, 0) * ISNULL(p.LastPaidPrice, 0.00) AS TotalValue,
        CASE 
            WHEN ISNULL(rs.Quantity, 0) = 0 THEN 'OUT OF STOCK'
            WHEN ISNULL(rs.Quantity, 0) <= 5 THEN 'LOW STOCK'
            ELSE 'NORMAL'
        END AS StockStatus
    FROM Products p
    LEFT JOIN RetailStock rs ON p.ProductID = rs.ProductID 
        AND rs.StockType = 'Internal'
        AND (@BranchID = 0 OR rs.BranchID = @BranchID)
    WHERE p.IsActive = 1
      AND (@LowStockOnly = 0 OR ISNULL(rs.Quantity, 0) <= 5)
    ORDER BY p.ProductName;
END;
GO

PRINT '';
PRINT '✅ sp_Report_StockLevels updated successfully!';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 WHAT THIS VERSION DOES:';
PRINT '1. ✅ Reads from RetailStock table (real quantities)';
PRINT '2. ✅ Shows actual stock levels instead of 0';
PRINT '3. ✅ Calculates total inventory value';
PRINT '4. ✅ Shows stock status (Out of Stock, Low Stock, Normal)';
PRINT '5. ✅ Low Stock = 5 or less items';
PRINT '6. ✅ Filters by branch if specified';
PRINT '';
PRINT '⚠️  NOTE: ReorderLevel and MaxStock set to 0';
PRINT '   (Products table does not have these columns)';
PRINT '';
PRINT '💡 To add ReorderLevel/MaxStock columns to Products:';
PRINT '   ALTER TABLE Products ADD ReorderLevel DECIMAL(18,2) DEFAULT 0;';
PRINT '   ALTER TABLE Products ADD MaxStock DECIMAL(18,2) DEFAULT 0;';
PRINT '';
PRINT '✅ Stock Levels Report will now show REAL quantities!';
PRINT '═══════════════════════════════════════════════';
