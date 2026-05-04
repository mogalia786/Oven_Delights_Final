-- Debug query to check what dates are in CustomOrders
-- Run this in the POS database to see what ReadyDate values are actually stored

USE Oven_Delights_POS
GO

SELECT 
    OrderID,
    OrderNumber,
    ReadyDate,
    CAST(ReadyDate AS DATE) AS ReadyDateOnly,
    OrderStatus,
    BranchID,
    -- Show what today is according to different methods
    CAST(GETDATE() AS DATE) AS ServerToday_GETDATE,
    CAST(GETUTCDATE() AS DATE) AS ServerToday_GETUTCDATE,
    CAST(DATEADD(HOUR, 2, GETUTCDATE()) AS DATE) AS SouthAfricaToday,
    -- Show if this order matches today
    CASE 
        WHEN CAST(ReadyDate AS DATE) = CAST(DATEADD(HOUR, 2, GETUTCDATE()) AS DATE) THEN 'MATCHES TODAY'
        ELSE 'NOT TODAY'
    END AS MatchesFilter
FROM POS_CustomOrders
WHERE OrderStatus NOT IN ('Cancelled')
ORDER BY ReadyDate DESC;
