-- ========================================
-- CREATE END OF DAY CASH-UP STORED PROCEDURE (FIXED)
-- Retrieves till cash-up data for reconciliation
-- ========================================

-- First, run CHECK_TILL_SCHEMA.sql to identify correct column names
-- Then update this script with the correct column names

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
    
    -- TEMPORARY VERSION - Returns sample data structure
    -- This will be updated once we know the correct table/column names
    
    SELECT 
        1 AS TillID,
        'T001' AS TillNumber,
        'Till 1' AS TillName,
        'Main Branch' AS BranchName,
        @ReportDate AS ReportDate,
        'John Smith' AS CashierName,
        
        -- Sales Summary
        CAST(4551.74 AS DECIMAL(18,2)) AS TotalSalesExclVAT,
        CAST(682.76 AS DECIMAL(18,2)) AS VATAmount,
        CAST(5234.50 AS DECIMAL(18,2)) AS TotalSalesInclVAT,
        47 AS TransactionCount,
        
        -- Payment Breakdown
        CAST(3450.00 AS DECIMAL(18,2)) AS CashPayments,
        CAST(1234.50 AS DECIMAL(18,2)) AS CardPayments,
        CAST(350.00 AS DECIMAL(18,2)) AS EFTPayments,
        CAST(200.00 AS DECIMAL(18,2)) AS AccountPayments,
        
        -- Expected Cash
        CAST(3450.00 AS DECIMAL(18,2)) AS ExpectedCash,
        
        -- Opening Float
        CAST(500.00 AS DECIMAL(18,2)) AS OpeningFloat,
        
        -- Refunds/Returns
        CAST(0.00 AS DECIMAL(18,2)) AS Refunds,
        
        -- Discounts
        CAST(0.00 AS DECIMAL(18,2)) AS TotalDiscounts
    
    WHERE 1=1;  -- Placeholder for testing
    
    -- TODO: Replace above with actual query once schema is confirmed
    -- The query should:
    -- 1. Join to your actual Till table (whatever it's called)
    -- 2. Join to your actual Sales/Transaction table
    -- 3. Join to your actual Users table for cashier names
    -- 4. Filter by @BranchID, @ReportDate, and optionally @TillID
    -- 5. Group by Till
    -- 6. Calculate all the summary fields shown above
    
END
GO

PRINT '✓ sp_GetEndOfDayCashUp created successfully (TEMPORARY VERSION)!';
PRINT '';
PRINT '⚠️ IMPORTANT: This is a TEMPORARY version with sample data';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Run CHECK_TILL_SCHEMA.sql to identify your table/column names';
PRINT '2. Update this stored procedure with correct names';
PRINT '3. Replace sample data with actual queries';
PRINT '';
PRINT 'Required tables:';
PRINT '  - Till/Register table (with TillID, TillNumber, TillName)';
PRINT '  - Sales/Transaction table (with sales data)';
PRINT '  - Users table (with cashier names)';
GO
