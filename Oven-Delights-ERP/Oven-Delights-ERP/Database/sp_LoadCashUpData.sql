-- =============================================
-- sp_LoadCashUpData
-- Loads saved cash-up data for a specific date
-- Returns denomination counts and finalization status
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_LoadCashUpData')
    DROP PROCEDURE sp_LoadCashUpData
GO

CREATE PROCEDURE sp_LoadCashUpData
    @BranchID INT,
    @CashUpDate DATE,
    @TillNumber NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        CashUpID,
        BranchID,
        TillNumber,
        CashUpDate,
        CashierName,
        Count_R200,
        Count_R100,
        Count_R50,
        Count_R20,
        Count_R10,
        Count_R5,
        Count_R2,
        Count_R1,
        Count_50c,
        Count_20c,
        Count_10c,
        Count_5c,
        ExpectedCash,
        ActualCash,
        Variance,
        IsFinalized,
        FinalizedDate,
        FinalizedBy,
        CreatedDate,
        CreatedBy,
        LastModifiedDate,
        LastModifiedBy
    FROM CashUpData
    WHERE BranchID = @BranchID
      AND CashUpDate = @CashUpDate
      AND (@TillNumber IS NULL OR TillNumber = @TillNumber)
    ORDER BY TillNumber
END
GO

PRINT 'sp_LoadCashUpData stored procedure created successfully'
PRINT ''
PRINT 'USAGE:'
PRINT '  -- Load all tills for a date'
PRINT '  EXEC sp_LoadCashUpData @BranchID=1, @CashUpDate=''2026-02-01'''
PRINT ''
PRINT '  -- Load specific till'
PRINT '  EXEC sp_LoadCashUpData @BranchID=1, @CashUpDate=''2026-02-01'', @TillNumber=1'
PRINT ''
