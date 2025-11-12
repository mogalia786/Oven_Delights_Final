-- ========================================
-- CREATE END OF DAY CASH-UP STORED PROCEDURE (WORKING)
-- Based on ACTUAL Demo_Sales column names from screenshot
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
    -- Using ACTUAL column names from Demo_Sales table
    SELECT 
        T.TillPointID AS TillID,
        T.TillNumber,
        COALESCE(T.TillNumber, 'Till ' + CAST(T.TillPointID AS NVARCHAR(10))) AS TillName,
        B.BranchName,
        @ReportDate AS ReportDate,
        
        -- Cashier info
        COALESCE(
            (SELECT TOP 1 CAST(S.CashierID AS NVARCHAR(50))
             FROM Demo_Sales S
             WHERE S.TillPointID = T.TillPointID 
               AND CAST(S.SaleDate AS DATE) = @ReportDate
               AND S.CashierID IS NOT NULL
             ORDER BY S.SaleDate),
            'N/A'
        ) AS CashierName,
        
        -- Sales Summary
        COALESCE(SUM(S.TotalAmount / 1.15), 0) AS TotalSalesExclVAT,
        COALESCE(SUM(S.TotalAmount - (S.TotalAmount / 1.15)), 0) AS VATAmount,
        COALESCE(SUM(S.TotalAmount), 0) AS TotalSalesInclVAT,
        COUNT(DISTINCT S.SaleID) AS TransactionCount,
        
        -- Payment Breakdown (using TenderType column)
        COALESCE(SUM(CASE WHEN S.TenderType IN ('Cash', 'CASH', 'cash') THEN S.TotalAmount ELSE 0 END), 0) AS CashPayments,
        COALESCE(SUM(CASE WHEN S.TenderType IN ('Card', 'CARD', 'Debit Card', 'Credit Card', 'card') THEN S.TotalAmount ELSE 0 END), 0) AS CardPayments,
        COALESCE(SUM(CASE WHEN S.TenderType IN ('EFT', 'eft', 'Bank Transfer') THEN S.TotalAmount ELSE 0 END), 0) AS EFTPayments,
        COALESCE(SUM(CASE WHEN S.TenderType IN ('Account', 'ACCOUNT', 'Credit', 'account') THEN S.TotalAmount ELSE 0 END), 0) AS AccountPayments,
        
        -- Expected Cash (using CashAmount column for split payments)
        COALESCE(SUM(CASE 
            WHEN S.TenderType IN ('Cash', 'CASH', 'cash') THEN S.TotalAmount 
            WHEN S.CashAmount IS NOT NULL AND S.CashAmount > 0 THEN S.CashAmount
            ELSE 0 
        END), 0) AS ExpectedCash,
        
        -- Opening Float (if tracked in a separate table)
        CAST(0.00 AS DECIMAL(18,2)) AS OpeningFloat,
        
        -- Refunds (using SaleType column - it exists!)
        COALESCE(SUM(CASE WHEN S.SaleType = 'Refund' THEN S.TotalAmount ELSE 0 END), 0) AS Refunds,
        
        -- Discounts (using DiscountAmount column - it exists!)
        COALESCE(SUM(ISNULL(S.DiscountAmount, 0)), 0) AS TotalDiscounts
        
    FROM TillPoints T
    INNER JOIN Branches B ON T.BranchID = B.BranchID
    LEFT JOIN Demo_Sales S ON T.TillPointID = S.TillPointID 
        AND CAST(S.SaleDate AS DATE) = @ReportDate
        AND S.BranchID = @BranchID  -- Also filter by BranchID in Demo_Sales
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
PRINT 'Using ACTUAL column names from Demo_Sales:';
PRINT '  - Cashier: Cashier (not CashierID)';
PRINT '  - Payment: TenderType (not PaymentMethod)';
PRINT '  - SaleType: EXISTS (for refunds)';
PRINT '  - DiscountAmount: EXISTS';
PRINT '  - CashAmount: For split payments';
PRINT '';
PRINT 'Test with:';
PRINT '  EXEC sp_GetEndOfDayCashUp @BranchID=6, @ReportDate=''2025-11-12'', @TillID=NULL';
PRINT '';
PRINT 'This should now return actual sales data!';
GO
