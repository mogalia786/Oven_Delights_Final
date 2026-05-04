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
    
    -- Use South Africa timezone (UTC+2)
    DECLARE @Today DATE = CAST(DATEADD(HOUR, 2, GETUTCDATE()) AS DATE);
    
    SELECT 
        -- Orders due today (ReadyDate = Today)
        COUNT(CASE WHEN o.ReadyDate = @Today THEN 1 END) AS OrdersRequested,
        
        -- Orders completed (any status = Ready, Completed or PickedUp)
        COUNT(CASE WHEN o.OrderStatus IN ('Ready', 'Completed', 'PickedUp') THEN 1 END) AS OrdersCompleted,
        
        -- Orders picked up
        COUNT(CASE WHEN o.OrderStatus = 'PickedUp' THEN 1 END) AS OrdersPickedUp,
        
        -- Orders completed but not picked up (Ready or Completed status)
        COUNT(CASE WHEN o.OrderStatus IN ('Ready', 'Completed') THEN 1 END) AS OrdersCompletedNotPickedUp,
        
        -- Orders due today but not completed
        COUNT(CASE WHEN o.ReadyDate = @Today AND o.OrderStatus NOT IN ('Ready', 'Completed', 'PickedUp') THEN 1 END) AS OrdersDueTodayNotCompleted,
        
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
