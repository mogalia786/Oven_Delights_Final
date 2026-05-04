-- ========================================
-- END OF DAY CASH-UP STORED PROCEDURE TEMPLATE
-- Customize this with your actual table/column names
-- ========================================

/*
INSTRUCTIONS:
1. Run CHECK_TILL_SCHEMA.sql first to see your actual column names
2. Replace the placeholders below with your actual names:
   - [YourTillTable] = Your till/register table name
   - [YourTillIDColumn] = Your till ID column
   - [YourTillNumberColumn] = Your till number column
   - [YourTillNameColumn] = Your till name column
   - [YourSalesTable] = Your sales/transaction table name
   - [YourSaleDateColumn] = Your sale date column
   - [YourTotalAmountColumn] = Your total amount column
   - [YourPaymentMethodColumn] = Your payment method column
   - [YourCashierIDColumn] = Your cashier ID column
   - [YourUsersTable] = Your users table name
   - [YourUserNameColumn] = Your user name column
3. Adjust the VAT calculation if your rate is not 15%
4. Adjust payment method names to match your system
*/

-- Drop if exists
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'sp_GetEndOfDayCashUp') AND type IN (N'P', N'PC'))
    DROP PROCEDURE sp_GetEndOfDayCashUp;
GO

CREATE PROCEDURE sp_GetEndOfDayCashUp
    @BranchID INT,
    @ReportDate DATE,
    @TillID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- EXAMPLE QUERY STRUCTURE - CUSTOMIZE WITH YOUR ACTUAL TABLE/COLUMN NAMES
    
    SELECT 
        -- Till Information
        T.[YourTillIDColumn] AS TillID,
        T.[YourTillNumberColumn] AS TillNumber,
        T.[YourTillNameColumn] AS TillName,
        B.BranchName,
        @ReportDate AS ReportDate,
        
        -- Cashier Name (get first cashier of the day)
        COALESCE(
            (SELECT TOP 1 U.[YourUserNameColumn]
             FROM [YourSalesTable] S
             INNER JOIN [YourUsersTable] U ON S.[YourCashierIDColumn] = U.UserID
             WHERE S.[YourTillIDColumn] = T.[YourTillIDColumn]
               AND CAST(S.[YourSaleDateColumn] AS DATE) = @ReportDate
             ORDER BY S.[YourSaleDateColumn]),
            'N/A'
        ) AS CashierName,
        
        -- Sales Summary (adjust VAT rate if needed - currently 15%)
        COALESCE(SUM(S.[YourTotalAmountColumn] / 1.15), 0) AS TotalSalesExclVAT,
        COALESCE(SUM(S.[YourTotalAmountColumn] - (S.[YourTotalAmountColumn] / 1.15)), 0) AS VATAmount,
        COALESCE(SUM(S.[YourTotalAmountColumn]), 0) AS TotalSalesInclVAT,
        COUNT(DISTINCT S.SaleID) AS TransactionCount,
        
        -- Payment Breakdown (adjust payment method names to match your system)
        COALESCE(SUM(CASE 
            WHEN S.[YourPaymentMethodColumn] IN ('Cash', 'CASH', 'cash') 
            THEN S.[YourTotalAmountColumn] 
            ELSE 0 
        END), 0) AS CashPayments,
        
        COALESCE(SUM(CASE 
            WHEN S.[YourPaymentMethodColumn] IN ('Card', 'CARD', 'Debit Card', 'Credit Card', 'card') 
            THEN S.[YourTotalAmountColumn] 
            ELSE 0 
        END), 0) AS CardPayments,
        
        COALESCE(SUM(CASE 
            WHEN S.[YourPaymentMethodColumn] IN ('EFT', 'eft', 'Bank Transfer') 
            THEN S.[YourTotalAmountColumn] 
            ELSE 0 
        END), 0) AS EFTPayments,
        
        COALESCE(SUM(CASE 
            WHEN S.[YourPaymentMethodColumn] IN ('Account', 'ACCOUNT', 'Credit', 'account') 
            THEN S.[YourTotalAmountColumn] 
            ELSE 0 
        END), 0) AS AccountPayments,
        
        -- Expected Cash (cash payments only)
        COALESCE(SUM(CASE 
            WHEN S.[YourPaymentMethodColumn] IN ('Cash', 'CASH', 'cash') 
            THEN S.[YourTotalAmountColumn] 
            ELSE 0 
        END), 0) AS ExpectedCash,
        
        -- Opening Float (if you track this)
        CAST(0.00 AS DECIMAL(18,2)) AS OpeningFloat,
        
        -- Refunds (if you have a column to identify refunds)
        CAST(0.00 AS DECIMAL(18,2)) AS Refunds,
        
        -- Discounts (if you track this)
        CAST(0.00 AS DECIMAL(18,2)) AS TotalDiscounts
        
    FROM [YourTillTable] T
    INNER JOIN Branches B ON T.BranchID = B.BranchID
    LEFT JOIN [YourSalesTable] S ON T.[YourTillIDColumn] = S.[YourTillIDColumn]
        AND CAST(S.[YourSaleDateColumn] AS DATE) = @ReportDate
    WHERE T.BranchID = @BranchID
      AND T.IsActive = 1
      AND (@TillID IS NULL OR T.[YourTillIDColumn] = @TillID)
    GROUP BY 
        T.[YourTillIDColumn],
        T.[YourTillNumberColumn],
        T.[YourTillNameColumn],
        B.BranchName
    ORDER BY 
        T.[YourTillNumberColumn];
END
GO

PRINT '========================================';
PRINT '⚠️ TEMPLATE STORED PROCEDURE CREATED';
PRINT '========================================';
PRINT '';
PRINT 'This is a TEMPLATE - you must customize it!';
PRINT '';
PRINT 'Steps to customize:';
PRINT '1. Run CHECK_TILL_SCHEMA.sql to see your table/column names';
PRINT '2. Replace all [YourTableName] placeholders';
PRINT '3. Replace all [YourColumnName] placeholders';
PRINT '4. Adjust VAT rate if not 15%';
PRINT '5. Adjust payment method names';
PRINT '6. Test with: EXEC sp_GetEndOfDayCashUp @BranchID=1, @ReportDate=''2025-11-12''';
PRINT '';
GO
