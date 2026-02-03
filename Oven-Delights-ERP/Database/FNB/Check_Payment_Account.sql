-- Check which account is used for payments vs statements
PRINT '=============================================='
PRINT 'PAYMENT ACCOUNT vs STATEMENT ACCOUNT CHECK'
PRINT '=============================================='
PRINT ''

-- Show payment account from credentials
PRINT 'Payment Account (from FNB_APICredentials):'
SELECT 
    Environment,
    DebtorAccountNumber AS PaymentAccount,
    DebtorBranchID,
    IsActive
FROM FNB_APICredentials
WHERE IsActive = 1
GO

PRINT ''
PRINT '=============================================='
PRINT 'Recent Batch Payments Sent:'
SELECT TOP 5
    BatchID,
    MessageID,
    TotalControlSum AS TotalAmount,
    RequestedExecutionDate AS ExecutionDate,
    BatchStatus AS Status,
    DebtorAccountNumber AS PaymentFromAccount,
    CreatedDate
FROM FNB_PaymentBatches
ORDER BY CreatedDate DESC
GO

PRINT ''
PRINT '=============================================='
PRINT 'Recent Statement Transactions Imported:'
SELECT TOP 5
    TransactionDate,
    Description,
    Reference,
    DebitAmount,
    CreditAmount,
    Balance,
    ImportedDate
FROM BankStatementTransactions
ORDER BY ImportedDate DESC
GO

PRINT ''
PRINT '=============================================='
PRINT 'IMPORTANT:'
PRINT 'The DebtorAccountNumber in FNB_APICredentials must match'
PRINT 'the AccountNumber you use when fetching statements.'
PRINT ''
PRINT 'Batch payments appear on NEXT DAY statement (not same day)'
PRINT '=============================================='
GO
