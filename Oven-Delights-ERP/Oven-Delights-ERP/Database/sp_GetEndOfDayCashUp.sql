-- Stored Procedure for End of Day Cash-Up Report
-- Includes order deposits (SaleType='ORDER') for accurate cash reconciliation

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_GetEndOfDayCashUp')
    DROP PROCEDURE sp_GetEndOfDayCashUp
GO

CREATE PROCEDURE sp_GetEndOfDayCashUp
    @BranchID INT,
    @ReportDate DATE,
    @TillID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get cash-up data from DailySales table
    -- Includes SALE, ORDER (deposits), and OrderCollection types
    -- Aggregates by Till and Cashier with all required columns
    
    SELECT 
        ds.TillNumber,
        COALESCE(ds.TillNumber, 'Till ' + CAST(ds.TillNumber AS NVARCHAR(10))) AS TillName,
        ds.CashierName,
        
        -- Sales Summary (excluding returns and orders)
        SUM(CASE WHEN ds.SaleType = 'SALE' THEN ds.TotalAmount / 1.15 ELSE 0 END) AS TotalSalesExclVAT,
        SUM(CASE WHEN ds.SaleType = 'SALE' THEN ds.TotalAmount - (ds.TotalAmount / 1.15) ELSE 0 END) AS VATAmount,
        SUM(CASE WHEN ds.SaleType = 'SALE' THEN ds.TotalAmount ELSE 0 END) AS TotalSalesInclVAT,
        
        -- Transaction counts
        COUNT(CASE WHEN ds.SaleType IN ('SALE', 'ORDER', 'OrderCollection') THEN 1 END) AS TransactionCount,
        
        -- Payment breakdown (all types including orders)
        SUM(CASE WHEN ds.PaymentMethod = 'Cash' THEN ds.TotalAmount ELSE 0 END) AS CashPayments,
        SUM(CASE WHEN ds.PaymentMethod = 'Card' THEN ds.TotalAmount ELSE 0 END) AS CardPayments,
        SUM(CASE WHEN ds.PaymentMethod = 'EFT' THEN ds.TotalAmount ELSE 0 END) AS EFTPayments,
        SUM(CASE WHEN ds.PaymentMethod = 'Account' THEN ds.TotalAmount ELSE 0 END) AS AccountPayments,
        
        -- Returns from POS_Returns table (reduces cash in till)
        COALESCE((
            SELECT COUNT(*)
            FROM POS_Returns r
            INNER JOIN TillPoints tp ON r.TillPointID = tp.TillPointID
            WHERE tp.TillNumber = ds.TillNumber
                AND CAST(r.ReturnDate AS DATE) = @ReportDate
        ), 0) AS ReturnCount,
        
        COALESCE((
            SELECT SUM(r.TotalAmount)
            FROM POS_Returns r
            INNER JOIN TillPoints tp ON r.TillPointID = tp.TillPointID
            WHERE tp.TillNumber = ds.TillNumber
                AND CAST(r.ReturnDate AS DATE) = @ReportDate
        ), 0) AS TotalReturns,
        
        COALESCE((
            SELECT SUM(r.CashAmount)
            FROM POS_Returns r
            INNER JOIN TillPoints tp ON r.TillPointID = tp.TillPointID
            WHERE tp.TillNumber = ds.TillNumber
                AND CAST(r.ReturnDate AS DATE) = @ReportDate
        ), 0) AS CashReturns,
        
        COALESCE((
            SELECT SUM(r.CardAmount)
            FROM POS_Returns r
            INNER JOIN TillPoints tp ON r.TillPointID = tp.TillPointID
            WHERE tp.TillNumber = ds.TillNumber
                AND CAST(r.ReturnDate AS DATE) = @ReportDate
        ), 0) AS CardReturns,
        
        -- Order deposits (separate tracking)
        SUM(CASE WHEN ds.SaleType = 'ORDER' THEN ds.TotalAmount ELSE 0 END) AS OrderDeposits,
        COUNT(CASE WHEN ds.SaleType = 'ORDER' THEN 1 END) AS OrderDepositCount,
        
        -- Order collections
        SUM(CASE WHEN ds.SaleType = 'OrderCollection' THEN ds.TotalAmount ELSE 0 END) AS OrderCollections,
        COUNT(CASE WHEN ds.SaleType = 'OrderCollection' THEN 1 END) AS OrderCollectionCount,
        
        -- Opening Float (from TillFloatConfig table or default 1000)
        ISNULL((
            SELECT TOP 1 tfc.FloatAmount 
            FROM TillFloatConfig tfc
            INNER JOIN TillPoints tp ON tfc.TillPointID = tp.TillPointID
            WHERE tp.TillNumber = ds.TillNumber 
                AND tfc.BranchID = @BranchID
                AND tfc.IsActive = 1
        ), 1000.00) AS OpeningFloat,
        
        -- Expected Cash (Opening Float + Cash payments - Cash returns)
        ISNULL((
            SELECT TOP 1 tfc.FloatAmount 
            FROM TillFloatConfig tfc
            INNER JOIN TillPoints tp ON tfc.TillPointID = tp.TillPointID
            WHERE tp.TillNumber = ds.TillNumber 
                AND tfc.BranchID = @BranchID
                AND tfc.IsActive = 1
        ), 1000.00) + 
        SUM(CASE WHEN ds.PaymentMethod = 'Cash' THEN ds.TotalAmount ELSE 0 END) - 
        ISNULL((
            SELECT SUM(r.CashAmount)
            FROM POS_Returns r
            INNER JOIN TillPoints tp ON r.TillPointID = tp.TillPointID
            WHERE tp.TillNumber = ds.TillNumber
                AND CAST(r.ReturnDate AS DATE) = @ReportDate
        ), 0) AS ExpectedCash,
        
        -- Timestamps
        MIN(ds.CreatedDate) AS FirstTransaction,
        MAX(ds.CreatedDate) AS LastTransaction
        
    FROM DailySales ds
    WHERE ds.BranchID = @BranchID
        AND ds.SaleDate = @ReportDate
        AND (@TillID IS NULL OR EXISTS (
            SELECT 1 FROM TillPoints tp 
            WHERE tp.TillNumber = ds.TillNumber 
            AND tp.TillPointID = @TillID
        ))
    GROUP BY 
        ds.TillNumber,
        ds.CashierName
    ORDER BY 
        ds.TillNumber
END
GO

PRINT 'sp_GetEndOfDayCashUp stored procedure created/updated successfully'
PRINT 'This procedure now includes:'
PRINT '  - SALE transactions (regular sales)'
PRINT '  - ORDER transactions (cake order deposits)'
PRINT '  - OrderCollection transactions (order pickups)'
GO
