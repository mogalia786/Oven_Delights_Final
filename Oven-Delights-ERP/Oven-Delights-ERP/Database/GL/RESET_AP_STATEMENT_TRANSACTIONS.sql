-- =============================================
-- RESET AP_STATEMENT_TRANSACTIONS (CORRECT TABLE)
-- This is the table the Bank Statement Viewer actually uses
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT 'RESETTING AP_STATEMENT_TRANSACTIONS'
PRINT '========================================='
PRINT ''

-- Show current status
PRINT 'Current Status:'
SELECT 
    COUNT(*) AS Total,
    SUM(CASE WHEN IsReconciled = 1 THEN 1 ELSE 0 END) AS Reconciled,
    SUM(CASE WHEN IsReconciled = 0 THEN 1 ELSE 0 END) AS NotReconciled,
    SUM(CASE WHEN IsMapped = 1 THEN 1 ELSE 0 END) AS Mapped,
    SUM(CASE WHEN IsMapped = 0 THEN 1 ELSE 0 END) AS NotMapped
FROM AP_StatementTransactions

PRINT ''
PRINT 'Resetting IsReconciled and IsMapped flags...'

-- Reset the flags
UPDATE AP_StatementTransactions
SET IsReconciled = 0,
    IsMapped = 0,
    ReconciledDate = NULL,
    ReconciledBy = NULL

PRINT '✓ Reset all flags'
PRINT ''

-- Show new status
PRINT 'New Status:'
SELECT 
    COUNT(*) AS Total,
    SUM(CASE WHEN IsReconciled = 1 THEN 1 ELSE 0 END) AS Reconciled,
    SUM(CASE WHEN IsReconciled = 0 THEN 1 ELSE 0 END) AS NotReconciled,
    SUM(CASE WHEN IsMapped = 1 THEN 1 ELSE 0 END) AS Mapped,
    SUM(CASE WHEN IsMapped = 0 THEN 1 ELSE 0 END) AS NotMapped
FROM AP_StatementTransactions

PRINT ''
PRINT '========================================='
PRINT 'RESET COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'All AP statement transactions reset'
PRINT 'Close and reopen Bank Statement Viewer to see changes'
PRINT ''
