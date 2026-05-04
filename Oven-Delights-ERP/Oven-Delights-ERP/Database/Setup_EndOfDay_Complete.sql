-- =============================================
-- Complete End of Day Cash-Up Save/Load/Finalize Setup
-- Run this entire script in SQL Server Management Studio
-- =============================================

USE OvenDelightsERP
GO

-- =============================================
-- STEP 1: Create CashUpData Table
-- =============================================
PRINT 'Creating CashUpData table...'
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'U' AND name = 'CashUpData')
BEGIN
    CREATE TABLE CashUpData (
        CashUpID INT IDENTITY(1,1) PRIMARY KEY,
        BranchID INT NOT NULL,
        TillNumber NVARCHAR(50) NOT NULL,
        CashUpDate DATE NOT NULL,
        CashierName NVARCHAR(100) NOT NULL,
        
        -- Denomination counts
        Count_R200 INT DEFAULT 0,
        Count_R100 INT DEFAULT 0,
        Count_R50 INT DEFAULT 0,
        Count_R20 INT DEFAULT 0,
        Count_R10 INT DEFAULT 0,
        Count_R5 INT DEFAULT 0,
        Count_R2 INT DEFAULT 0,
        Count_R1 INT DEFAULT 0,
        Count_50c INT DEFAULT 0,
        Count_20c INT DEFAULT 0,
        Count_10c INT DEFAULT 0,
        Count_5c INT DEFAULT 0,
        
        -- Calculated totals
        ExpectedCash DECIMAL(18,2) NOT NULL,
        ActualCash DECIMAL(18,2) NOT NULL,
        Variance DECIMAL(18,2) NOT NULL,
        
        -- Status
        IsFinalized BIT DEFAULT 0,
        FinalizedDate DATETIME NULL,
        FinalizedBy NVARCHAR(100) NULL,
        
        -- Audit
        CreatedDate DATETIME DEFAULT GETDATE(),
        CreatedBy NVARCHAR(100) NULL,
        LastModifiedDate DATETIME DEFAULT GETDATE(),
        LastModifiedBy NVARCHAR(100) NULL,
        
        -- Constraints
        CONSTRAINT UQ_CashUpData_BranchTillDate UNIQUE (BranchID, TillNumber, CashUpDate)
    )
    
    PRINT 'CashUpData table created successfully'
END
ELSE
BEGIN
    PRINT 'CashUpData table already exists'
END
GO

-- =============================================
-- STEP 2: Create sp_SaveCashUpData
-- =============================================
PRINT 'Creating sp_SaveCashUpData stored procedure...'
GO

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
                Count_R200, Count_R100, Count_R50, Count_R20, Count_R10, Count_R5,
                Count_R2, Count_R1, Count_50c, Count_20c, Count_10c, Count_5c,
                ExpectedCash, ActualCash, Variance,
                CreatedBy, LastModifiedBy
            )
            VALUES (
                @BranchID, @TillNumber, @CashUpDate, @CashierName,
                @Count_R200, @Count_R100, @Count_R50, @Count_R20, @Count_R10, @Count_R5,
                @Count_R2, @Count_R1, @Count_50c, @Count_20c, @Count_10c, @Count_5c,
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

PRINT 'sp_SaveCashUpData created successfully'
GO

-- =============================================
-- STEP 3: Create sp_LoadCashUpData
-- =============================================
PRINT 'Creating sp_LoadCashUpData stored procedure...'
GO

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

PRINT 'sp_LoadCashUpData created successfully'
GO

-- =============================================
-- STEP 4: Update sp_FinalizeEndOfDay
-- =============================================
PRINT 'Creating sp_FinalizeEndOfDay stored procedure...'
GO

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_FinalizeEndOfDay')
    DROP PROCEDURE sp_FinalizeEndOfDay
GO

CREATE PROCEDURE sp_FinalizeEndOfDay
    @BranchID INT,
    @ReportDate DATE
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Finalize all cash-up data for the date
        UPDATE CashUpData
        SET IsFinalized = 1,
            FinalizedDate = GETDATE(),
            FinalizedBy = 'System',
            LastModifiedDate = GETDATE(),
            LastModifiedBy = 'EndOfDayFinalize'
        WHERE BranchID = @BranchID
          AND CashUpDate = @ReportDate
          AND IsFinalized = 0
        
        -- Set IsActive flag to False to lock all tills at the branch
        -- This prevents POS operations until supervisor reactivates
        UPDATE TillPoints
        SET IsActive = 0,
            LastModifiedDate = GETDATE(),
            LastModifiedBy = 'EndOfDayFinalize'
        WHERE BranchID = @BranchID
          AND IsActive = 1
        
        -- Log the finalization
        INSERT INTO SystemAuditLog (
            EventType,
            EventDescription,
            BranchID,
            CreatedDate
        )
        VALUES (
            'EndOfDayFinalized',
            'End of Day finalized for branch ' + CAST(@BranchID AS VARCHAR) + ' on ' + CONVERT(VARCHAR, @ReportDate, 23),
            @BranchID,
            GETDATE()
        )
        
        COMMIT TRANSACTION
        
        SELECT 
            @@ROWCOUNT AS TillsLocked,
            'Success' AS Status,
            'End of Day finalized successfully' AS Message
            
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

PRINT 'sp_FinalizeEndOfDay created successfully'
GO

-- =============================================
-- VERIFICATION
-- =============================================
PRINT ''
PRINT '========================================='
PRINT 'Setup Complete!'
PRINT '========================================='
PRINT ''
PRINT 'Created/Updated:'
PRINT '  - CashUpData table'
PRINT '  - sp_SaveCashUpData stored procedure'
PRINT '  - sp_LoadCashUpData stored procedure'
PRINT '  - sp_FinalizeEndOfDay stored procedure'
PRINT ''
PRINT 'Next steps:'
PRINT '  1. Rebuild your VB.NET application'
PRINT '  2. Test the End of Day Cash-Up Report'
PRINT '  3. Enter denomination counts - they will auto-save'
PRINT '  4. Close and reopen the form - data will load back'
PRINT '  5. Click "Finalize Day" when ready to lock tills'
PRINT ''
