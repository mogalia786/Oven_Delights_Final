-- ========================================
-- CREATE END OF DAY CASH-UP STORED PROCEDURE
-- Retrieves till cash-up data for reconciliation
-- ========================================

-- Drop if exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_GetEndOfDayCashUp') AND type IN (N'P', N'PC'))
    DROP PROCEDURE sp_GetEndOfDayCashUp;
GO

CREATE PROCEDURE sp_GetEndOfDayCashUp
    @BranchID INT,
    @ReportDate DATE,
    @TillID INT = NULL  -- NULL = All tills
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get sales data per till for the specified date
    SELECT 
        T.TillID,
        T.TillNumber,
        T.TillName,
        B.BranchName,
        @ReportDate AS ReportDate,
        
        -- Cashier info (get first cashier of the day)
        COALESCE(
            (SELECT TOP 1 U.FullName 
             FROM Demo_Sales S
             INNER JOIN Users U ON S.CashierID = U.UserID
             WHERE S.TillID = T.TillID 
               AND CAST(S.SaleDate AS DATE) = @ReportDate
             ORDER BY S.SaleDate),
            'N/A'
        ) AS CashierName,
        
        -- Sales Summary
        COALESCE(SUM(S.TotalAmount / 1.15), 0) AS TotalSalesExclVAT,
        COALESCE(SUM(S.TotalAmount - (S.TotalAmount / 1.15)), 0) AS VATAmount,
        COALESCE(SUM(S.TotalAmount), 0) AS TotalSalesInclVAT,
        COUNT(DISTINCT S.SaleID) AS TransactionCount,
        
        -- Payment Breakdown
        COALESCE(SUM(CASE WHEN S.PaymentMethod = 'Cash' THEN S.TotalAmount ELSE 0 END), 0) AS CashPayments,
        COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Card', 'Debit Card', 'Credit Card') THEN S.TotalAmount ELSE 0 END), 0) AS CardPayments,
        COALESCE(SUM(CASE WHEN S.PaymentMethod = 'EFT' THEN S.TotalAmount ELSE 0 END), 0) AS EFTPayments,
        COALESCE(SUM(CASE WHEN S.PaymentMethod = 'Account' THEN S.TotalAmount ELSE 0 END), 0) AS AccountPayments,
        
        -- Expected Cash (Cash payments + Cash from split payments)
        COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Cash', 'Split') THEN 
            CASE 
                WHEN S.PaymentMethod = 'Split' THEN S.CashAmount  -- For split payments, use CashAmount column
                ELSE S.TotalAmount  -- For cash payments, use full amount
            END
        ELSE 0 END), 0) AS ExpectedCash,
        
        -- Opening Float (if tracked)
        COALESCE(
            (SELECT TOP 1 FloatAmount 
             FROM TillFloats 
             WHERE TillID = T.TillID 
               AND CAST(FloatDate AS DATE) = @ReportDate
             ORDER BY FloatDate),
            0
        ) AS OpeningFloat,
        
        -- Refunds/Returns
        COALESCE(SUM(CASE WHEN S.SaleType = 'Refund' THEN S.TotalAmount ELSE 0 END), 0) AS Refunds,
        
        -- Discounts
        COALESCE(SUM(S.DiscountAmount), 0) AS TotalDiscounts
        
    FROM TillPoints T
    INNER JOIN Branches B ON T.BranchID = B.BranchID
    LEFT JOIN Demo_Sales S ON T.TillID = S.TillID 
        AND CAST(S.SaleDate AS DATE) = @ReportDate
        AND S.SaleType IN ('Sale', 'OrderCollection')  -- Exclude deposits
    WHERE T.BranchID = @BranchID
      AND T.IsActive = 1
      AND (@TillID IS NULL OR T.TillID = @TillID)
    GROUP BY 
        T.TillID,
        T.TillNumber,
        T.TillName,
        B.BranchName
    ORDER BY 
        T.TillNumber;
END
GO

PRINT '✓ sp_GetEndOfDayCashUp created successfully!';
PRINT '';
PRINT 'This stored procedure returns:';
PRINT '  - Sales summary per till';
PRINT '  - Payment breakdown (Cash, Card, EFT, Account)';
PRINT '  - Expected cash in till';
PRINT '  - Transaction counts';
PRINT '  - Refunds and discounts';
GO
