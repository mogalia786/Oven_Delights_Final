-- Check if sp_GetTodayOrderStats exists
SELECT 
    name,
    type_desc,
    create_date,
    modify_date
FROM sys.objects 
WHERE name = 'sp_GetTodayOrderStats'
GO

-- Check POS_CustomOrders data for today
DECLARE @Today DATE = CAST(GETDATE() AS DATE);

SELECT 
    'Total Orders' as Metric,
    COUNT(*) as Count
FROM POS_CustomOrders
WHERE OrderStatus NOT IN ('Cancelled')

UNION ALL

SELECT 
    'Orders with ReadyDate = Today' as Metric,
    COUNT(*) as Count
FROM POS_CustomOrders
WHERE CAST(ReadyDate AS DATE) = @Today
  AND OrderStatus NOT IN ('Cancelled')

UNION ALL

SELECT 
    'Orders Completed' as Metric,
    COUNT(*) as Count
FROM POS_CustomOrders
WHERE OrderStatus IN ('Completed', 'PickedUp')

UNION ALL

SELECT 
    'Orders Picked Up' as Metric,
    COUNT(*) as Count
FROM POS_CustomOrders
WHERE OrderStatus = 'PickedUp'

UNION ALL

SELECT 
    'Orders Completed Not Picked Up' as Metric,
    COUNT(*) as Count
FROM POS_CustomOrders
WHERE OrderStatus = 'Completed'
GO

-- Show sample of recent orders
SELECT TOP 10
    OrderID,
    OrderNumber,
    OrderStatus,
    OrderDate,
    ReadyDate,
    CAST(ReadyDate AS DATE) as ReadyDateOnly,
    CAST(GETDATE() AS DATE) as TodayDate,
    CASE 
        WHEN CAST(ReadyDate AS DATE) = CAST(GETDATE() AS DATE) THEN 'YES'
        ELSE 'NO'
    END as IsToday,
    BranchID
FROM POS_CustomOrders
ORDER BY OrderID DESC
GO

-- Test the stored procedure if it exists
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'sp_GetTodayOrderStats')
BEGIN
    PRINT 'Testing sp_GetTodayOrderStats...'
    EXEC sp_GetTodayOrderStats @BranchID = NULL
END
ELSE
BEGIN
    PRINT 'sp_GetTodayOrderStats does NOT exist - needs to be created'
END
GO
