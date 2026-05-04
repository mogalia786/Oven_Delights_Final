-- =============================================
-- RESET BANK STATEMENT POSTINGS
-- Clears existing GL postings to allow re-posting with new logic
-- =============================================

SET NOCOUNT ON
GO

PRINT ''
PRINT '========================================='
PRINT 'RESETTING BANK STATEMENT POSTINGS'
PRINT '========================================='
PRINT ''

-- =============================================
-- STEP 1: Find and delete journal entries from bank statements
-- =============================================
PRINT 'Step 1: Deleting existing bank statement journal entries...'

-- Delete journal details first (foreign key constraint)
DELETE jd
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jh.Reference LIKE 'BANK-%'
   OR jh.Description LIKE '%bank statement%'

PRINT '✓ Deleted journal detail lines'

-- Delete journal headers
DELETE FROM JournalHeaders
WHERE Reference LIKE 'BANK-%'
   OR Description LIKE '%bank statement%'

PRINT '✓ Deleted journal headers'

PRINT ''

-- =============================================
-- STEP 2: Reset bank statement transaction flags
-- =============================================
PRINT 'Step 2: Resetting bank statement transaction flags...'

UPDATE BankStatementTransactions
SET PostedToGL = 0,
    PostedDate = NULL,
    PostedBy = NULL,
    GLBatchID = NULL
WHERE PostedToGL = 1

PRINT '✓ Reset PostedToGL flags to allow re-posting'

PRINT ''

-- =============================================
-- STEP 3: Show transaction counts
-- =============================================
PRINT 'Step 3: Transaction summary...'

DECLARE @TotalTransactions INT
DECLARE @ReadyToPost INT

SELECT @TotalTransactions = COUNT(*) FROM BankStatementTransactions
SELECT @ReadyToPost = COUNT(*) FROM BankStatementTransactions WHERE PostedToGL = 0

PRINT '✓ Total bank statement transactions: ' + CAST(@TotalTransactions AS VARCHAR(10))
PRINT '✓ Ready to re-post: ' + CAST(@ReadyToPost AS VARCHAR(10))

PRINT ''

-- =============================================
-- SUMMARY
-- =============================================
PRINT '========================================='
PRINT 'BANK STATEMENT POSTING RESET COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'All bank statement GL postings have been cleared.'
PRINT 'All transactions are now ready to be re-posted.'
PRINT ''
PRINT 'Next steps:'
PRINT '1. Open Bank Statement Viewer form'
PRINT '2. Select transactions to post'
PRINT '3. Click "Post to GL" button'
PRINT ''
PRINT 'The new posting logic will:'
PRINT '- Match supplier payments to AP invoices → 2100-XXX ledgers'
PRINT '- Match customer receipts to AR invoices → 1200-XXX ledgers'
PRINT '- Post cash deposits to Cash on Hand (1030)'
PRINT '- Use pattern matching for other transactions'
PRINT ''
