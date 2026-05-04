-- =============================================
-- sp_FinalizeEndOfDay
-- Sets EndOfDay flag to True for all tills at a branch
-- This locks all tills and requires supervisor approval to reset
-- =============================================

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
        
        -- Set IsDayEnd = 0 to lock all tills for the next day
        -- This prevents POS login until Reset Day End is performed
        INSERT INTO TillDayEnd (TillPointID, BusinessDate, CashierID, CashierName, IsDayEnd, CreatedAt)
        SELECT 
            tp.TillPointID,
            DATEADD(DAY, 1, @ReportDate),
            0,
            'System',
            0,
            GETDATE()
        FROM TillPoints tp
        WHERE tp.BranchID = @BranchID
          AND tp.IsActive = 1
          AND NOT EXISTS (
              SELECT 1 FROM TillDayEnd tde 
              WHERE tde.TillPointID = tp.TillPointID 
              AND tde.BusinessDate = DATEADD(DAY, 1, @ReportDate)
          )
        
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

PRINT 'sp_FinalizeEndOfDay stored procedure created successfully'
PRINT ''
PRINT 'USAGE:'
PRINT '  EXEC sp_FinalizeEndOfDay @BranchID = 1, @ReportDate = ''2026-02-01'''
PRINT ''
PRINT 'This procedure:'
PRINT '  - Sets IsActive = 0 for all active tills at the branch (locks tills)'
PRINT '  - Logs the finalization event in SystemAuditLog'
PRINT '  - Requires supervisor to set IsActive = 1 to reopen tills for operations'
PRINT ''
