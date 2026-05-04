-- =============================================
-- Match Batch Payments to Statement Transactions
-- =============================================

PRINT '=============================================='
PRINT 'BATCH PAYMENT vs STATEMENT MATCHING'
PRINT '=============================================='
PRINT ''

-- Show batch payments with expected statement date
PRINT 'Batch Payments Sent (with expected statement date):'
SELECT 
    BatchID,
    MessageID,
    RequestedExecutionDate AS PaymentDate,
    DATEADD(DAY, 1, RequestedExecutionDate) AS ExpectedOnStatementDate,
    TotalControlSum AS Amount,
    BatchStatus,
    DebtorAccountNumber,
    CreatedDate
FROM FNB_PaymentBatches
WHERE BatchStatus IN ('ACCP', 'ACSC', 'Pending')
ORDER BY RequestedExecutionDate DESC
GO

PRINT ''
PRINT '=============================================='
PRINT 'Statement Transactions (Debits - Money Out):'
SELECT 
    TransactionDate,
    Description,
    Reference,
    DebitAmount,
    Balance,
    ImportedDate
FROM BankStatementTransactions
WHERE DebitAmount IS NOT NULL
  AND DebitAmount > 0
ORDER BY TransactionDate DESC
GO

PRINT ''
PRINT '=============================================='
PRINT 'MATCHING LOGIC:'
PRINT '1. Batch payment on 2026-01-26 should appear on statement dated 2026-01-27'
PRINT '2. Look for DebitAmount matching TotalControlSum'
PRINT '3. Description may contain MessageID or batch reference'
PRINT ''
PRINT 'If no matches found:'
PRINT '- Fetch statements for dates AFTER payment execution dates'
PRINT '- Check if BatchStatus is ACCP (Accepted) or ACSC (Accepted Settlement Completed)'
PRINT '- RJCT (Rejected) payments will NOT appear on statements'
PRINT '=============================================='
GO
