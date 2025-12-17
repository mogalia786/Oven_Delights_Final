-- Test query to check if order deposits are in DailySales table
-- Run this to verify data is being recorded correctly

-- Check what's in DailySales for today
SELECT 
    SaleDate,
    TillNumber,
    CashierName,
    SaleType,
    PaymentMethod,
    TotalAmount,
    InvoiceNumber,
    CreatedDate
FROM DailySales
WHERE SaleDate = CAST(GETDATE() AS DATE)
ORDER BY CreatedDate DESC;

-- Check order deposits specifically
SELECT 
    SaleType,
    COUNT(*) AS TransactionCount,
    SUM(TotalAmount) AS TotalAmount
FROM DailySales
WHERE SaleDate = CAST(GETDATE() AS DATE)
GROUP BY SaleType;

-- Test the stored procedure
DECLARE @BranchID INT = 1;  -- Change to your branch ID
DECLARE @ReportDate DATE = CAST(GETDATE() AS DATE);

EXEC sp_GetEndOfDayCashUp @BranchID, @ReportDate, NULL;
