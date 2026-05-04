-- Check what values are actually stored in CreditDebitIndicator field
SELECT TOP 20
    TransactionID,
    TransactionDate,
    Amount,
    CreditDebitIndicator,
    Description,
    Reference,
    IsReconciled
FROM AP_StatementTransactions
WHERE AccountNumber = '62003723469'
ORDER BY TransactionDate DESC;

-- Check distinct values in CreditDebitIndicator
SELECT DISTINCT CreditDebitIndicator, COUNT(*) AS Count
FROM AP_StatementTransactions
GROUP BY CreditDebitIndicator;
