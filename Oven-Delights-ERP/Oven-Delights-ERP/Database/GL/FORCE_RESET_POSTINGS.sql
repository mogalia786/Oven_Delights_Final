-- =============================================
-- FORCE RESET BANK STATEMENT POSTINGS
-- Direct UPDATE with verification
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT 'FORCE RESETTING BANK STATEMENT POSTINGS'
PRINT '========================================='
PRINT ''

-- Show current status
PRINT 'Current Status:'
SELECT 
    COUNT(*) AS Total,
    SUM(CASE WHEN PostedToGL = 1 THEN 1 ELSE 0 END) AS Posted,
    SUM(CASE WHEN PostedToGL = 0 THEN 1 ELSE 0 END) AS NotPosted
FROM BankStatementTransactions

PRINT ''
PRINT 'Resetting ALL transactions...'

-- Force reset ALL transactions
UPDATE BankStatementTransactions
SET PostedToGL = 0,
    PostedDate = NULL,
    PostedBy = NULL,
    GLBatchID = NULL

PRINT '✓ Updated all transactions'
PRINT ''

-- Show new status
PRINT 'New Status:'
SELECT 
    COUNT(*) AS Total,
    SUM(CASE WHEN PostedToGL = 1 THEN 1 ELSE 0 END) AS Posted,
    SUM(CASE WHEN PostedToGL = 0 THEN 1 ELSE 0 END) AS NotPosted
FROM BankStatementTransactions

PRINT ''
PRINT '========================================='
PRINT 'FORCE RESET COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'All bank statement transactions reset to PostedToGL = 0'
PRINT 'Refresh the Bank Statement Viewer form to see changes'
PRINT ''
