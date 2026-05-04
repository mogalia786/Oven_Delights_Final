-- =============================================
-- Stored Procedure: sp_UpdateCakeCompletionQty
-- Purpose: Update completed quantity for cake manufacturing
-- Updates all matching order items based on cake attributes
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateCakeCompletionQty]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_UpdateCakeCompletionQty]
GO

CREATE PROCEDURE [dbo].[sp_UpdateCakeCompletionQty]
    @ReadyDate DATE,
    @BranchID INT = NULL,
    @Size VARCHAR(10),
    @Layer VARCHAR(20),
    @Shape VARCHAR(20),
    @CakeCream VARCHAR(50),
    @SpecialRequest NVARCHAR(MAX),
    @CompletedQty INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update QtyCompleted for all matching order items
    UPDATE i
    SET i.QtyCompleted = i.QtyCompleted + @CompletedQty
    FROM POS_CustomOrderItems i
    INNER JOIN POS_CustomOrders o ON i.OrderID = o.OrderID
    WHERE o.ReadyDate = @ReadyDate
        AND o.OrderStatus IN ('New', 'InProgress')
        AND (@BranchID IS NULL OR o.BranchID = @BranchID)
        -- Match Size
        AND (
            (@Size = '10' AND i.ProductName LIKE '%10%') OR
            (@Size = '12' AND i.ProductName LIKE '%12%') OR
            (@Size = '14' AND i.ProductName LIKE '%14%') OR
            (@Size = '16' AND i.ProductName LIKE '%16%') OR
            (@Size = '18' AND i.ProductName LIKE '%18%') OR
            (@Size = '20' AND i.ProductName LIKE '%20%') OR
            (@Size = '22' AND i.ProductName LIKE '%22%') OR
            (@Size = '24' AND i.ProductName LIKE '%24%')
        )
        -- Match Layer
        AND (
            (@Layer = 'Double' AND (i.ProductName LIKE '%Double%' OR i.ProductName LIKE '%DL%' OR i.ProductName LIKE '%DBL%')) OR
            (@Layer = 'Single' AND i.ProductName NOT LIKE '%Double%' AND i.ProductName NOT LIKE '%DL%' AND i.ProductName NOT LIKE '%DBL%')
        )
        -- Match Shape
        AND (
            (@Shape = 'Figure' AND i.ProductName LIKE '%Figure%') OR
            (@Shape = 'Round' AND i.ProductName LIKE '%Round%') OR
            (@Shape = 'Heart' AND i.ProductName LIKE '%Heart%') OR
            (@Shape = 'Rectangle' AND i.ProductName LIKE '%Rectangle%') OR
            (@Shape = 'Oval' AND i.ProductName LIKE '%Oval%') OR
            (@Shape = 'Square' AND i.ProductName NOT LIKE '%Figure%' AND i.ProductName NOT LIKE '%Round%' AND i.ProductName NOT LIKE '%Heart%' AND i.ProductName NOT LIKE '%Rectangle%' AND i.ProductName NOT LIKE '%Oval%')
        )
        -- Match Cream Type
        AND (
            (@CakeCream = 'Fresh Cream' AND (i.ProductName LIKE '%Fresh Cream%' OR i.ProductName LIKE '%Fresh-Cream%' OR i.ProductName LIKE '%FreshCream%')) OR
            (@CakeCream = 'Butter Cream' AND (i.ProductName LIKE '%Butter Cream%' OR i.ProductName LIKE '%Buttercream%' OR i.ProductName LIKE '%Butter-Cream%'))
        )
        -- Match Special Request (optional)
        AND (
            @SpecialRequest = '' OR
            (o.SpecialInstructions IS NOT NULL AND o.SpecialInstructions LIKE '%' + @SpecialRequest + '%') OR
            i.ProductName LIKE '%' + @SpecialRequest + '%'
        );
    
    -- Return number of rows updated
    SELECT @@ROWCOUNT AS RowsUpdated;
END
GO

PRINT 'sp_UpdateCakeCompletionQty created successfully';
GO
