-- Check what date ranges you've been fetching statements for
PRINT '=============================================='
PRINT 'STATEMENT FETCH ANALYSIS'
PRINT '=============================================='
PRINT ''

PRINT 'Date range of statement transactions imported:'
SELECT 
    MIN(TransactionDate) AS EarliestTransaction,
    MAX(TransactionDate) AS LatestTransaction,
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN DebitAmount > 0 THEN 1 ELSE 0 END) AS DebitCount,
    SUM(CASE WHEN CreditAmount > 0 THEN 1 ELSE 0 END) AS CreditCount,
    SUM(DebitAmount) AS TotalDebits,
    SUM(CreditAmount) AS TotalCredits
FROM BankStatementTransactions
GO

PRINT ''
PRINT 'Payments that should appear on statements:'
SELECT 
    RequestedExecutionDate AS PaymentDate,
    DATEADD(DAY, 1, RequestedExecutionDate) AS ShouldAppearOnDate,
    TotalControlSum AS Amount,
    BatchStatus,
    MessageID
FROM FNB_PaymentBatches
WHERE BatchStatus IN ('ACCP', 'ACSC')
ORDER BY RequestedExecutionDate
GO

PRINT ''
PRINT '=============================================='
PRINT 'ACTION REQUIRED:'
PRINT '1. Fetch statements for dates: 2026-01-25 to 2026-02-01'
PRINT '2. Look for debits matching payment amounts (2820.00, 1999.85, etc.)'
PRINT '3. If still not showing, contact FNB about Sandbox statement simulation'
PRINT '=============================================='
GO
