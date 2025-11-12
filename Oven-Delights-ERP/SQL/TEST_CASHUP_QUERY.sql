-- ========================================
-- TEST CASH-UP QUERY MANUALLY
-- See exactly what the stored procedure is doing
-- ========================================

DECLARE @BranchID INT = 6;
DECLARE @ReportDate DATE = '2025-11-12';  -- Change this to today's date or a date with sales
DECLARE @TillID INT = NULL;  -- NULL = all tills, or set to 1 for specific till

PRINT '========================================';
PRINT 'TESTING CASH-UP QUERY';
PRINT '========================================';
PRINT '';
PRINT 'Parameters:';
PRINT '  @BranchID = ' + CAST(@BranchID AS NVARCHAR(10));
PRINT '  @ReportDate = ' + CAST(@ReportDate AS NVARCHAR(20));
PRINT '  @TillID = ' + ISNULL(CAST(@TillID AS NVARCHAR(10)), 'NULL (all tills)');
PRINT '';

-- First, check what tills exist for this branch
PRINT 'Tills for BranchID ' + CAST(@BranchID AS NVARCHAR(10)) + ':';
SELECT 
    TillPointID,
    TillNumber,
    BranchID,
    IsActive
FROM TillPoints
WHERE BranchID = @BranchID;

PRINT '';
PRINT 'Sales for this branch and date:';
SELECT 
    S.SalesID,
    S.TillPointID,
    S.SaleDate,
    S.TotalAmount,
    S.PaymentMethod
FROM Demo_Sales S
WHERE S.BranchID = @BranchID
  AND CAST(S.SaleDate AS DATE) = @ReportDate;

PRINT '';
PRINT 'Now running the full query:';
PRINT '';

-- This is the exact query from the stored procedure
SELECT 
    T.TillPointID AS TillID,
    T.TillNumber,
    COALESCE(T.TillNumber, 'Till ' + CAST(T.TillPointID AS NVARCHAR(10))) AS TillName,
    B.BranchName,
    @ReportDate AS ReportDate,
    
    -- Cashier info
    COALESCE(
        (SELECT TOP 1 U.Username
         FROM Demo_Sales S
         INNER JOIN Users U ON S.CashierID = U.UserID
         WHERE S.TillPointID = T.TillPointID 
           AND CAST(S.SaleDate AS DATE) = @ReportDate
         ORDER BY S.SaleDate),
        'N/A'
    ) AS CashierName,
    
    -- Sales Summary
    COALESCE(SUM(S.TotalAmount / 1.15), 0) AS TotalSalesExclVAT,
    COALESCE(SUM(S.TotalAmount - (S.TotalAmount / 1.15)), 0) AS VATAmount,
    COALESCE(SUM(S.TotalAmount), 0) AS TotalSalesInclVAT,
    COUNT(DISTINCT S.SalesID) AS TransactionCount,
    
    -- Payment Breakdown
    COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Cash', 'CASH', 'cash') THEN S.TotalAmount ELSE 0 END), 0) AS CashPayments,
    COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Card', 'CARD', 'Debit Card', 'Credit Card', 'card') THEN S.TotalAmount ELSE 0 END), 0) AS CardPayments,
    COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('EFT', 'eft', 'Bank Transfer') THEN S.TotalAmount ELSE 0 END), 0) AS EFTPayments,
    COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Account', 'ACCOUNT', 'Credit', 'account') THEN S.TotalAmount ELSE 0 END), 0) AS AccountPayments,
    
    -- Expected Cash
    COALESCE(SUM(CASE 
        WHEN S.PaymentMethod IN ('Cash', 'CASH', 'cash') THEN S.TotalAmount 
        WHEN S.CashAmount IS NOT NULL AND S.CashAmount > 0 THEN S.CashAmount
        ELSE 0 
    END), 0) AS ExpectedCash,
    
    CAST(0.00 AS DECIMAL(18,2)) AS OpeningFloat,
    CAST(0.00 AS DECIMAL(18,2)) AS Refunds,
    CAST(0.00 AS DECIMAL(18,2)) AS TotalDiscounts,
    
    -- Debug info
    COUNT(*) AS SalesRecordsFound
    
FROM TillPoints T
INNER JOIN Branches B ON T.BranchID = B.BranchID
LEFT JOIN Demo_Sales S ON T.TillPointID = S.TillPointID 
    AND CAST(S.SaleDate AS DATE) = @ReportDate
WHERE T.BranchID = @BranchID
  AND T.IsActive = 1
  AND (@TillID IS NULL OR T.TillPointID = @TillID)
GROUP BY 
    T.TillPointID,
    T.TillNumber,
    B.BranchName
ORDER BY 
    T.TillNumber;

PRINT '';
PRINT '========================================';
PRINT 'If you see zeros, check:';
PRINT '1. Is @ReportDate correct? (change it to a date with sales)';
PRINT '2. Do TillPointID values match between TillPoints and Demo_Sales?';
PRINT '3. Is BranchID stored in Demo_Sales or only in TillPoints?';
PRINT '========================================';
GO
