-- Debug script to check why order deposits don't show in ERP End of Day report

-- 1. Check if ORDER type records exist in DailySales
SELECT 
    'DailySales ORDER records' AS CheckType,
    COUNT(*) AS RecordCount,
    SUM(TotalAmount) AS TotalAmount
FROM DailySales
WHERE SaleDate = CAST(GETDATE() AS DATE)
    AND SaleType = 'ORDER';

-- 2. Test stored procedure output
DECLARE @BranchID INT = 1;  -- Change to your branch ID
DECLARE @ReportDate DATE = CAST(GETDATE() AS DATE);

SELECT 
    'Stored Procedure Output' AS CheckType,
    OrderDepositCount,
    OrderDeposits
FROM (
    EXEC sp_GetEndOfDayCashUp @BranchID, @ReportDate, NULL
) AS Result;

-- 3. Check the actual stored procedure query directly
SELECT 
    ds.TillNumber,
    COALESCE(ds.TillNumber, 'Till ' + CAST(ds.TillNumber AS NVARCHAR(10))) AS TillName,
    ds.CashierName,
    
    -- Order deposits
    SUM(CASE WHEN ds.SaleType = 'ORDER' THEN ds.TotalAmount ELSE 0 END) AS OrderDeposits,
    COUNT(CASE WHEN ds.SaleType = 'ORDER' THEN 1 END) AS OrderDepositCount
    
FROM DailySales ds
WHERE ds.BranchID = 1  -- Change to your branch ID
    AND ds.SaleDate = CAST(GETDATE() AS DATE)
GROUP BY 
    ds.TillNumber,
    ds.CashierName
ORDER BY 
    ds.TillNumber;

-- 4. Check if form display condition is the issue
-- The form checks: tillRow.Table.Columns.Contains("OrderDepositCount") AndAlso Convert.ToInt32(tillRow("OrderDepositCount")) > 0
-- This query shows what the form will see:
SELECT 
    'Form Display Check' AS CheckType,
    CASE 
        WHEN COUNT(CASE WHEN ds.SaleType = 'ORDER' THEN 1 END) > 0 THEN 'Should Display'
        ELSE 'Will NOT Display'
    END AS DisplayStatus,
    COUNT(CASE WHEN ds.SaleType = 'ORDER' THEN 1 END) AS OrderDepositCount
FROM DailySales ds
WHERE ds.BranchID = 1  -- Change to your branch ID
    AND ds.SaleDate = CAST(GETDATE() AS DATE);
