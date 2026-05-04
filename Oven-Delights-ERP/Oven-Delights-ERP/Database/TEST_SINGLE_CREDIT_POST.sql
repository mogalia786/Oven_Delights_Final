-- Test posting a single credit transaction manually to see exact error
DECLARE @TestTransactionID INT;

-- Get first unposted credit transaction
SELECT TOP 1 @TestTransactionID = TransactionID
FROM AP_StatementTransactions
WHERE CreditDebitIndicator = 'Credit' 
  AND (IsReconciled = 0 OR IsReconciled IS NULL)
ORDER BY TransactionDate ASC;

-- Show what we're about to post
SELECT 
    TransactionID,
    TransactionDate,
    Amount,
    CreditDebitIndicator,
    Description,
    Reference,
    RelatedPartyName
FROM AP_StatementTransactions
WHERE TransactionID = @TestTransactionID;

-- Try to post it
EXEC sp_PostCreditTransactionsToLedgers 
    @TransactionID = @TestTransactionID,
    @PostedBy = 'TEST_USER';

-- Check if it posted successfully
SELECT 
    TransactionID,
    IsReconciled,
    ReconciledDate,
    ReconciledBy,
    MappedLedgerAccount
FROM AP_StatementTransactions
WHERE TransactionID = @TestTransactionID;

-- Check GeneralLedger entries created
SELECT TOP 10
    EntryID,
    AccountID,
    TransactionDate,
    Description,
    DebitAmount,
    CreditAmount,
    ReferenceID,
    CreatedBy,
    CreatedDate
FROM GeneralLedger
ORDER BY EntryID DESC;
