-- =============================================
-- EMERGENCY DAY END RESET
-- =============================================
-- Use this script if the Administration menu is not accessible
-- This will reset all incomplete day-ends and allow POS to log in

-- WARNING: Only run this after verifying:
-- 1. No fraudulent activity occurred
-- 2. All cash has been secured
-- 3. You have documented the reason for incomplete day-end

DECLARE @Yesterday DATE = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);
DECLARE @AdminUserID INT = 1; -- Change to your admin user ID
DECLARE @AdminUserName NVARCHAR(100) = 'Administrator'; -- Change to your admin username
DECLARE @Reason NVARCHAR(500) = 'Emergency reset - POS login blocked'; -- Change reason as needed

-- Show incomplete day-ends before reset
PRINT '========================================';
PRINT 'INCOMPLETE DAY-ENDS TO BE RESET:';
PRINT '========================================';
SELECT 
    tp.TillNumber,
    b.BranchName,
    tde.BusinessDate,
    tde.CashierName,
    tde.CreatedAt,
    DATEDIFF(HOUR, tde.CreatedAt, GETDATE()) AS HoursOverdue
FROM TillDayEnd tde
INNER JOIN TillPoints tp ON tde.TillPointID = tp.TillPointID
INNER JOIN Branches b ON tp.BranchID = b.BranchID
WHERE tde.BusinessDate = @Yesterday
AND tde.IsDayEnd = 0
ORDER BY tp.TillNumber;

-- Perform the reset
UPDATE TillDayEnd 
SET IsDayEnd = 1,
    DayEndTime = GETDATE(),
    CompletedBy = @AdminUserID,
    Notes = 'ADMIN RESET: ' + @Reason + ' (Reset by: ' + @AdminUserName + ')'
WHERE BusinessDate = @Yesterday 
AND IsDayEnd = 0;

-- Show results
PRINT '';
PRINT '========================================';
PRINT 'RESET COMPLETE!';
PRINT CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' till(s) reset.';
PRINT '========================================';
PRINT '';
PRINT '✅ All POS tills can now log in.';
PRINT '';

-- Verify reset
SELECT 
    tp.TillNumber,
    b.BranchName,
    tde.BusinessDate,
    tde.IsDayEnd,
    tde.DayEndTime,
    tde.Notes
FROM TillDayEnd tde
INNER JOIN TillPoints tp ON tde.TillPointID = tp.TillPointID
INNER JOIN Branches b ON tp.BranchID = b.BranchID
WHERE tde.BusinessDate = @Yesterday
ORDER BY tp.TillNumber;
