-- Create stored procedure for Stock Movement Report
-- This queries StockMovements table (where POS writes to)

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_Report_StockMovement')
    DROP PROCEDURE sp_Report_StockMovement
GO

CREATE PROCEDURE sp_Report_StockMovement
    @StartDate DATE,
    @EndDate DATE,
    @BranchID INT = NULL,
    @MovementType NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- UNION both StockMovements (raw materials) and Retail_StockMovements (retail products)
    SELECT 
        sm.MovementDate,
        COALESCE(p.Name, rm.MaterialName, 'Unknown Product') AS ProductName,
        COALESCE(p.SKU, rm.MaterialCode, 'N/A') AS ProductCode,
        sm.MovementType,
        CASE 
            WHEN sm.QuantityOut > 0 THEN -sm.QuantityOut
            ELSE sm.QuantityIn
        END AS Quantity,
        sm.ReferenceNumber AS Reference,
        sm.Notes,
        sm.BranchID,
        b.BranchName
    FROM StockMovements sm
    LEFT JOIN Demo_Retail_Product p ON sm.MaterialID = p.ProductID
    LEFT JOIN RawMaterials rm ON sm.MaterialID = rm.MaterialID
    LEFT JOIN Branches b ON sm.BranchID = b.BranchID
    WHERE sm.MovementDate >= @StartDate
      AND sm.MovementDate <= DATEADD(DAY, 1, @EndDate)
      AND (@BranchID IS NULL OR sm.BranchID = @BranchID)
      AND (@MovementType IS NULL OR sm.MovementType = @MovementType OR @MovementType = 'All Movements')
    
    UNION ALL
    
    SELECT 
        rsm.CreatedAt AS MovementDate,
        COALESCE(p.Name, 'Unknown Product') AS ProductName,
        COALESCE(p.SKU, 'N/A') AS ProductCode,
        rsm.Reason AS MovementType,
        rsm.QtyDelta AS Quantity,
        rsm.Ref1 AS Reference,
        rsm.Ref2 AS Notes,
        rsm.BranchID,
        b.BranchName
    FROM Retail_StockMovements rsm
    LEFT JOIN Demo_Retail_Product p ON rsm.VariantID = p.ProductID AND rsm.BranchID = p.BranchID
    LEFT JOIN Branches b ON rsm.BranchID = b.BranchID
    WHERE rsm.CreatedAt >= @StartDate
      AND rsm.CreatedAt <= DATEADD(DAY, 1, @EndDate)
      AND (@BranchID IS NULL OR rsm.BranchID = @BranchID)
      AND (@MovementType IS NULL OR rsm.Reason = @MovementType OR @MovementType = 'All Movements')
    
    ORDER BY MovementDate DESC
END
GO

PRINT 'sp_Report_StockMovement stored procedure created successfully'
