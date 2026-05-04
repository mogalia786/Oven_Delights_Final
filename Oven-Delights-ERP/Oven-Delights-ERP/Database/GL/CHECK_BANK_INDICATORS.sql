-- Check what CreditDebitIndicator values are stored for different transaction types
SELECT TOP 20
    TransactionDate,
    Description,
    Reference,
    Amount,
    CreditDebitIndicator,
    RunningBalance
FROM AP_StatementTransactions
ORDER BY TransactionDate DESC
