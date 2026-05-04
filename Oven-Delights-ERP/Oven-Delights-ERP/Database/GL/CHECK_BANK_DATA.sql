-- Check what CreditDebitIndicator values exist in the bank statement data
SELECT TOP 20
    TransactionID,
    TransactionDate,
    Description,
    Amount,
    CreditDebitIndicator,
    CASE 
        WHEN Description LIKE '%Deposit%' THEN 'Should be Credit (Money IN)'
        WHEN Description LIKE '%Purchase%' THEN 'Should be Debit (Money OUT)'
        WHEN Description LIKE '%Card sale%' THEN 'Should be Credit (Money IN)'
        ELSE 'Unknown'
    END AS ExpectedType
FROM AP_StatementTransactions
ORDER BY TransactionDate DESC
