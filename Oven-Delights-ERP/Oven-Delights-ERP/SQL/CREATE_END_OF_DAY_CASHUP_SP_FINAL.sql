-- ========================================
-- CREATE END OF DAY CASH-UP STORED PROCEDURE (FINAL)
-- Based on actual Demo_Sales table schema
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
    -- Using actual column names from Demo_Sales table
    SELECT 
        T.TillPointID AS TillID,
        T.TillNumber,
        COALESCE(T.TillNumber, 'Till ' + CAST(T.TillPointID AS NVARCHAR(10))) AS TillName,
        B.BranchName,
        @ReportDate AS ReportDate,
        
        -- Cashier info (get first cashier of the day from sales)
        COALESCE(
            (SELECT TOP 1 U.Username
             FROM Demo_Sales S
             INNER JOIN Users U ON S.CashierID = U.UserID
             WHERE S.TillPointID = T.TillPointID 
               AND CAST(S.SaleDate AS DATE) = @ReportDate
             ORDER BY S.SaleDate),
            'N/A'
        ) AS CashierName,
        
        -- Sales Summary (assuming 15% VAT)
        COALESCE(SUM(S.TotalAmount / 1.15), 0) AS TotalSalesExclVAT,
        COALESCE(SUM(S.TotalAmount - (S.TotalAmount / 1.15)), 0) AS VATAmount,
        COALESCE(SUM(S.TotalAmount), 0) AS TotalSalesInclVAT,
        COUNT(DISTINCT S.SaleID) AS TransactionCount,
        
        -- Payment Breakdown (Sales - Returns)
        COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Cash', 'CASH', 'cash') THEN S.TotalAmount ELSE 0 END), 0) - 
        COALESCE((SELECT SUM(R.CashAmount) FROM POS_Returns R WHERE R.TillPointID = T.TillPointID AND CAST(R.ReturnDate AS DATE) = @ReportDate), 0) AS CashPayments,
        COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Card', 'CARD', 'Debit Card', 'Credit Card', 'card') THEN S.TotalAmount ELSE 0 END), 0) - 
        COALESCE((SELECT SUM(R.CardAmount) FROM POS_Returns R WHERE R.TillPointID = T.TillPointID AND CAST(R.ReturnDate AS DATE) = @ReportDate), 0) AS CardPayments,
        COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('EFT', 'eft', 'Bank Transfer') THEN S.TotalAmount ELSE 0 END), 0) AS EFTPayments,
        COALESCE(SUM(CASE WHEN S.PaymentMethod IN ('Account', 'ACCOUNT', 'Credit', 'account') THEN S.TotalAmount ELSE 0 END), 0) AS AccountPayments,
        
        -- Expected Cash (Cash payments + CashAmount from split payments - Cash Returns)
        COALESCE(SUM(CASE 
            WHEN S.PaymentMethod IN ('Cash', 'CASH', 'cash') THEN S.TotalAmount 
            WHEN S.CashAmount IS NOT NULL AND S.CashAmount > 0 THEN S.CashAmount
            ELSE 0 
        END), 0) - COALESCE((SELECT SUM(R.CashAmount) 
                             FROM POS_Returns R 
                             WHERE R.TillPointID = T.TillPointID 
                               AND CAST(R.ReturnDate AS DATE) = @ReportDate), 0) AS ExpectedCash,
        
        -- Opening Float (if tracked in a separate table)
        CAST(0.00 AS DECIMAL(18,2)) AS OpeningFloat,
        
        -- Returns/Refunds from POS_Returns table
        COALESCE((SELECT COUNT(*) 
                  FROM POS_Returns R 
                  WHERE R.TillPointID = T.TillPointID 
                    AND CAST(R.ReturnDate AS DATE) = @ReportDate), 0) AS ReturnCount,
        COALESCE((SELECT SUM(R.TotalAmount) 
                  FROM POS_Returns R 
                  WHERE R.TillPointID = T.TillPointID 
                    AND CAST(R.ReturnDate AS DATE) = @ReportDate), 0) AS TotalReturns,
        COALESCE((SELECT SUM(R.CashAmount) 
                  FROM POS_Returns R 
                  WHERE R.TillPointID = T.TillPointID 
                    AND CAST(R.ReturnDate AS DATE) = @ReportDate), 0) AS CashReturns,
        COALESCE((SELECT SUM(R.CardAmount) 
                  FROM POS_Returns R 
                  WHERE R.TillPointID = T.TillPointID 
                    AND CAST(R.ReturnDate AS DATE) = @ReportDate), 0) AS CardReturns,
        
        -- Discounts (you don't have DiscountAmount column, so set to 0 for now)
        CAST(0.00 AS DECIMAL(18,2)) AS TotalDiscounts
        
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
END
GO

PRINT '✓ sp_GetEndOfDayCashUp created successfully!';
PRINT '';
PRINT 'Using actual schema:';
PRINT '  - Till Table: TillPoints (TillPointID, TillNumber)';
PRINT '  - Sales Table: Demo_Sales';
PRINT '  - Sales ID: SaleID (FIXED)';
PRINT '  - Cashier: CashierID';
PRINT '  - Date: SaleDate';
PRINT '  - Amount: TotalAmount';
PRINT '  - Payment: PaymentMethod';
PRINT '  - Cash Amount: CashAmount (for split payments)';
PRINT '';
PRINT 'Test with:';
PRINT '  EXEC sp_GetEndOfDayCashUp @BranchID=1, @ReportDate=''2025-11-12'', @TillID=NULL';
PRINT '';
PRINT 'Notes:';
PRINT '  - Returns tracked from POS_Returns table';
PRINT '  - Cash and Card totals deduct returns by payment method';
PRINT '  - Discounts set to 0 (no DiscountAmount column found)';
PRINT '  - Adjust payment method names if needed (Cash, Card, EFT, Account)';
GO
