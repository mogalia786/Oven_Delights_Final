-- =============================================
-- Stored Procedure: sp_GetTodayOrderStats
-- Purpose: Get live order statistics for today's orders
-- Returns: Orders Requested, Completed, Picked Up, and Completed but Not Picked Up
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetTodayOrderStats]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetTodayOrderStats]
GO

CREATE PROCEDURE [dbo].[sp_GetTodayOrderStats]
    @BranchID INT = NULL -- NULL = All branches
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Today DATE = CAST(GETDATE() AS DATE);
    
    SELECT 
        -- Orders due today (ReadyDate = Today)
        COUNT(CASE WHEN o.ReadyDate = @Today THEN 1 END) AS OrdersRequested,
        
        -- Orders completed (any status = Completed or PickedUp)
        COUNT(CASE WHEN o.OrderStatus IN ('Completed', 'PickedUp') THEN 1 END) AS OrdersCompleted,
        
        -- Orders picked up
        COUNT(CASE WHEN o.OrderStatus = 'PickedUp' THEN 1 END) AS OrdersPickedUp,
        
        -- Orders completed but not picked up
        COUNT(CASE WHEN o.OrderStatus = 'Completed' THEN 1 END) AS OrdersCompletedNotPickedUp,
        
        -- Orders due today but not completed
        COUNT(CASE WHEN o.ReadyDate = @Today AND o.OrderStatus NOT IN ('Completed', 'PickedUp') THEN 1 END) AS OrdersDueTodayNotCompleted,
        
        -- Total orders
        COUNT(*) AS TotalOrders
        
    FROM POS_CustomOrders o
    WHERE o.ReadyDate = @Today
      AND (@BranchID IS NULL OR o.BranchID = @BranchID)
      AND o.OrderStatus NOT IN ('Cancelled');
END
GO

PRINT 'sp_GetTodayOrderStats created successfully';
GO
