-- =============================================
-- Stored Procedure: sp_GetOrderStatusReport
-- Purpose: Get orders due for a selected date with status tracking and timestamps
-- Shows: Date Ordered, Date/Time Completed, Date/Time Picked Up
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetOrderStatusReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetOrderStatusReport]
GO

CREATE PROCEDURE [dbo].[sp_GetOrderStatusReport]
    @ReadyDate DATE,
    @BranchID INT = NULL, -- NULL = All branches
    @OrderStatus VARCHAR(50) = NULL -- NULL = All statuses, or 'New', 'InProgress', 'Completed', 'PickedUp'
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        o.OrderID,
        o.OrderNumber,
        b.BranchName AS CollectionPoint,
        o.CustomerName,
        o.CustomerPhone,
        o.ReadyDate,
        o.ReadyTime,
        o.OrderDate,
        o.OrderStatus,
        
        -- Status display
        CASE o.OrderStatus
            WHEN 'New' THEN 'Processing'
            WHEN 'InProgress' THEN 'Processing'
            WHEN 'Completed' THEN 'Completed'
            WHEN 'PickedUp' THEN 'Completed & Picked Up'
            ELSE o.OrderStatus
        END AS StatusDisplay,
        
        -- Timestamps (converted to South African Time)
        o.OrderDate AT TIME ZONE 'UTC' AT TIME ZONE 'South Africa Standard Time' AS DateOrdered,
        o.CreatedDate AT TIME ZONE 'UTC' AT TIME ZONE 'South Africa Standard Time' AS DateTimeCreated,
        o.ModifiedDate AT TIME ZONE 'UTC' AT TIME ZONE 'South Africa Standard Time' AS DateTimeModified,
        
        -- Order details
        o.TotalAmount,
        o.DepositPaid,
        o.BalanceDue,
        o.SpecialInstructions,
        
        -- Item count
        (SELECT COUNT(*) FROM POS_CustomOrderItems WHERE OrderID = o.OrderID) AS ItemCount,
        
        -- Item summary
        (SELECT STRING_AGG(CONCAT(Quantity, 'x ', ProductName), ', ')
         FROM POS_CustomOrderItems 
         WHERE OrderID = o.OrderID) AS ItemSummary
        
    FROM POS_CustomOrders o
    INNER JOIN Branches b ON o.BranchID = b.BranchID
    
    WHERE o.ReadyDate = @ReadyDate
        AND (@BranchID IS NULL OR o.BranchID = @BranchID)
        AND (@OrderStatus IS NULL OR o.OrderStatus = @OrderStatus)
    
    ORDER BY 
        o.ReadyTime ASC,
        b.BranchName,
        o.OrderNumber;
END
GO

PRINT 'sp_GetOrderStatusReport created successfully';
GO
