-- =============================================
-- sp_SaveCashUpData
-- Saves or updates cash-up denomination counts for a till
-- Supports partial submissions and recalculates totals
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_SaveCashUpData')
    DROP PROCEDURE sp_SaveCashUpData
GO

CREATE PROCEDURE sp_SaveCashUpData
    @BranchID INT,
    @TillNumber NVARCHAR(50),
    @CashUpDate DATE,
    @CashierName NVARCHAR(100),
    @Count_R200 INT = 0,
    @Count_R100 INT = 0,
    @Count_R50 INT = 0,
    @Count_R20 INT = 0,
    @Count_R10 INT = 0,
    @Count_R5 INT = 0,
    @Count_R2 INT = 0,
    @Count_R1 INT = 0,
    @Count_50c INT = 0,
    @Count_20c INT = 0,
    @Count_10c INT = 0,
    @Count_5c INT = 0,
    @ExpectedCash DECIMAL(18,2),
    @UserName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Calculate actual cash from denominations
        DECLARE @ActualCash DECIMAL(18,2)
        SET @ActualCash = 
            (@Count_R200 * 200.00) +
            (@Count_R100 * 100.00) +
            (@Count_R50 * 50.00) +
            (@Count_R20 * 20.00) +
            (@Count_R10 * 10.00) +
            (@Count_R5 * 5.00) +
            (@Count_R2 * 2.00) +
            (@Count_R1 * 1.00) +
            (@Count_50c * 0.50) +
            (@Count_20c * 0.20) +
            (@Count_10c * 0.10) +
            (@Count_5c * 0.05)
        
        -- Calculate variance
        DECLARE @Variance DECIMAL(18,2)
        SET @Variance = @ActualCash - @ExpectedCash
        
        -- Check if record exists
        IF EXISTS (SELECT 1 FROM CashUpData WHERE BranchID = @BranchID AND TillNumber = @TillNumber AND CashUpDate = @CashUpDate)
        BEGIN
            -- Check if already finalized
            IF EXISTS (SELECT 1 FROM CashUpData WHERE BranchID = @BranchID AND TillNumber = @TillNumber AND CashUpDate = @CashUpDate AND IsFinalized = 1)
            BEGIN
                RAISERROR('Cannot update finalized cash-up data', 16, 1)
                RETURN
            END
            
            -- Update existing record
            UPDATE CashUpData
            SET Count_R200 = @Count_R200,
                Count_R100 = @Count_R100,
                Count_R50 = @Count_R50,
                Count_R20 = @Count_R20,
                Count_R10 = @Count_R10,
                Count_R5 = @Count_R5,
                Count_R2 = @Count_R2,
                Count_R1 = @Count_R1,
                Count_50c = @Count_50c,
                Count_20c = @Count_20c,
                Count_10c = @Count_10c,
                Count_5c = @Count_5c,
                ExpectedCash = @ExpectedCash,
                ActualCash = @ActualCash,
                Variance = @Variance,
                LastModifiedDate = GETDATE(),
                LastModifiedBy = @UserName
            WHERE BranchID = @BranchID 
              AND TillNumber = @TillNumber 
              AND CashUpDate = @CashUpDate
              
            SELECT 'Updated' AS Status, @ActualCash AS ActualCash, @Variance AS Variance
        END
        ELSE
        BEGIN
            -- Insert new record
            INSERT INTO CashUpData (
                BranchID, TillNumber, CashUpDate, CashierName,
                Count_R200, Count_R100, Count_R50, Count_R20, Count_R10, Count_R5, Count_R2, Count_R1,
                Count_50c, Count_20c, Count_10c, Count_5c,
                ExpectedCash, ActualCash, Variance,
                CreatedBy, LastModifiedBy
            )
            VALUES (
                @BranchID, @TillNumber, @CashUpDate, @CashierName,
                @Count_R200, @Count_R100, @Count_R50, @Count_R20, @Count_R10, @Count_R5, @Count_R2, @Count_R1,
                @Count_50c, @Count_20c, @Count_10c, @Count_5c,
                @ExpectedCash, @ActualCash, @Variance,
                @UserName, @UserName
            )
            
            SELECT 'Inserted' AS Status, @ActualCash AS ActualCash, @Variance AS Variance
        END
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT 'sp_SaveCashUpData stored procedure created successfully'
PRINT ''
PRINT 'USAGE:'
PRINT '  EXEC sp_SaveCashUpData @BranchID=1, @TillNumber=1, @CashUpDate=''2026-02-01'','
PRINT '       @CashierName=''John Doe'', @Count_R200=5, @Count_R100=10, @ExpectedCash=2500.00, @UserName=''Admin'''
PRINT ''
