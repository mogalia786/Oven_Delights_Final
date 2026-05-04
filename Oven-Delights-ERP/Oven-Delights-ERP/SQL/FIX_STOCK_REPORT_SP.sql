-- Fix sp_Report_StockLevels to use Demo_Retail_Product instead of Products
DROP PROCEDURE IF EXISTS sp_Report_StockLevels;
GO

CREATE PROCEDURE sp_Report_StockLevels
    @BranchID INT = 0,
    @LowStockOnly BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get stock levels from RetailStock table joined with Demo_Retail_Product
    SELECT 
        p.SKU AS ProductCode,
        p.Name AS ProductName,
        p.CategoryID,
        p.ProductType AS ItemType,
        ISNULL(rs.UnitOfMeasure, 'ea') AS BaseUoM,
        ISNULL(rs.Quantity, 0) AS CurrentStock,
        0 AS ReorderLevel,  -- Not in RetailStock table
        0 AS MaxStock,      -- Not in RetailStock table
        0.00 AS UnitCost,   -- Not in Demo_Retail_Product table
        ISNULL(rs.Quantity, 0) * 0.00 AS TotalValue,
        CASE 
            WHEN ISNULL(rs.Quantity, 0) = 0 THEN 'OUT OF STOCK'
            WHEN ISNULL(rs.Quantity, 0) <= 5 THEN 'LOW STOCK'
            ELSE 'NORMAL'
        END AS StockStatus
    FROM dbo.Demo_Retail_Product p
    LEFT JOIN dbo.RetailStock rs ON p.ProductID = rs.ProductID 
        AND (@BranchID = 0 OR rs.BranchID = @BranchID)
    WHERE p.IsActive = 1
        AND (@LowStockOnly = 0 OR ISNULL(rs.Quantity, 0) <= 5)
    ORDER BY p.Name;
END
GO

PRINT 'sp_Report_StockLevels updated to use Demo_Retail_Product!';
