-- =============================================
-- Stored Procedure: sp_GetReOrderBOMRequisition
-- Purpose: Get BOM requisition for a re-order book or specific line
-- =============================================

IF OBJECT_ID('sp_GetReOrderBOMRequisition', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetReOrderBOMRequisition;
GO

CREATE PROCEDURE sp_GetReOrderBOMRequisition
    @ReOrderBookID INT = NULL,
    @ReOrderLineID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get BOM requisition items with fulfillment status
    SELECT 
        bom.BOMRequisitionID,
        bom.ReOrderLineID,
        rbl.ProductName AS ProductName,
        rbl.QuantityOrdered AS ProductQuantity,
        bom.ItemID,
        bom.ItemName,
        bom.ItemType,
        bom.Quantity AS RequiredQuantity,
        bom.UnitOfMeasure,
        bom.CostPerUnit,
        bom.TotalCost,
        bom.IsFulfilled,
        bom.FulfilledQuantity,
        bom.FulfilledDate,
        CASE 
            WHEN bom.FulfilledBy IS NOT NULL THEN u.FirstName + ' ' + u.LastName
            ELSE NULL
        END AS FulfilledByName,
        -- Calculate fulfillment percentage
        CASE 
            WHEN bom.Quantity > 0 THEN CAST((bom.FulfilledQuantity / bom.Quantity * 100) AS DECIMAL(5,2))
            ELSE 0
        END AS FulfillmentPercentage,
        -- Check current stock availability
        ISNULL(rs.CurrentStock, 0) AS CurrentStock,
        CASE 
            WHEN ISNULL(rs.CurrentStock, 0) >= bom.Quantity THEN 1
            ELSE 0
        END AS IsInStock
    FROM ReOrderBOMRequisition bom
    INNER JOIN ReOrderBookLines rbl ON bom.ReOrderLineID = rbl.ReOrderLineID
    INNER JOIN ReOrderBooks rb ON rbl.ReOrderBookID = rb.ReOrderBookID
    LEFT JOIN Users u ON bom.FulfilledBy = u.UserID
    LEFT JOIN Demo_Retail_Product rs ON bom.ItemID = rs.ProductID
    WHERE (@ReOrderBookID IS NULL OR rb.ReOrderBookID = @ReOrderBookID)
      AND (@ReOrderLineID IS NULL OR bom.ReOrderLineID = @ReOrderLineID)
    ORDER BY rbl.LineNumber, bom.ItemType, bom.ItemName;
END
GO

PRINT '✅ sp_GetReOrderBOMRequisition created successfully!';
PRINT '';
PRINT '📋 USAGE:';
PRINT '   -- Get all BOM items for a re-order book';
PRINT '   EXEC sp_GetReOrderBOMRequisition @ReOrderBookID = 123';
PRINT '';
PRINT '   -- Get BOM items for specific product line';
PRINT '   EXEC sp_GetReOrderBOMRequisition @ReOrderLineID = 456';
PRINT '';
PRINT '🔄 RETURNS:';
PRINT '   - Product details (name, quantity ordered)';
PRINT '   - Ingredient/packaging requirements (scaled quantities)';
PRINT '   - Fulfillment status and percentage';
PRINT '   - Current stock availability';
PRINT '   - Cost information';
GO
