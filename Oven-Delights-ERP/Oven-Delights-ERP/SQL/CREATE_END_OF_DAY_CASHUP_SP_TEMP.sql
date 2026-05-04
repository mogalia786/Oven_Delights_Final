-- ========================================
-- TEMPORARY END OF DAY CASH-UP (SAMPLE DATA)
-- Use this to test the form while we fix the schema
-- ========================================

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
    
    -- Return sample data for testing the form
    -- This uses your actual TillPoints table but with sample sales data
    
    SELECT 
        T.TillPointID AS TillID,
        T.TillNumber,
        COALESCE(T.TillNumber, 'Till ' + CAST(T.TillPointID AS NVARCHAR(10))) AS TillName,
        B.BranchName,
        @ReportDate AS ReportDate,
        'Sample Cashier' AS CashierName,
        
        -- Sample Sales Summary
        CAST(4551.74 AS DECIMAL(18,2)) AS TotalSalesExclVAT,
        CAST(682.76 AS DECIMAL(18,2)) AS VATAmount,
        CAST(5234.50 AS DECIMAL(18,2)) AS TotalSalesInclVAT,
        47 AS TransactionCount,
        
        -- Sample Payment Breakdown
        CAST(3450.00 AS DECIMAL(18,2)) AS CashPayments,
        CAST(1234.50 AS DECIMAL(18,2)) AS CardPayments,
        CAST(350.00 AS DECIMAL(18,2)) AS EFTPayments,
        CAST(200.00 AS DECIMAL(18,2)) AS AccountPayments,
        
        -- Sample Expected Cash
        CAST(3450.00 AS DECIMAL(18,2)) AS ExpectedCash,
        CAST(500.00 AS DECIMAL(18,2)) AS OpeningFloat,
        CAST(0.00 AS DECIMAL(18,2)) AS Refunds,
        CAST(0.00 AS DECIMAL(18,2)) AS TotalDiscounts
        
    FROM TillPoints T
    INNER JOIN Branches B ON T.BranchID = B.BranchID
    WHERE T.BranchID = @BranchID
      AND T.IsActive = 1
      AND (@TillID IS NULL OR T.TillPointID = @TillID)
    ORDER BY T.TillNumber;
END
GO

PRINT '✓ TEMPORARY sp_GetEndOfDayCashUp created!';
PRINT '';
PRINT '⚠️ This returns SAMPLE DATA for testing only';
PRINT '';
PRINT 'Use this to:';
PRINT '  - Test the form design';
PRINT '  - See the report layout';
PRINT '  - Print sample reports';
PRINT '  - Demo to stakeholders';
PRINT '';
PRINT 'Then run CHECK_SALES_SCHEMA.sql to get real data';
GO
