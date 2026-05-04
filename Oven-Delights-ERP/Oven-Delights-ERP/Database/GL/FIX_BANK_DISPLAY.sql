-- Diagnostic: Check what CreditDebitIndicator values exist
SELECT DISTINCT CreditDebitIndicator, COUNT(*) as Count
FROM AP_StatementTransactions
GROUP BY CreditDebitIndicator

-- Sample data to understand the pattern
SELECT TOP 10
    TransactionDate,
    Description,
    Amount,
    CreditDebitIndicator,
    CASE 
        WHEN Description LIKE '%Deposit%' OR Description LIKE '%Card sale%' THEN 'Money IN'
        WHEN Description LIKE '%Purchase%' THEN 'Money OUT'
        ELSE 'Unknown'
    END AS TransactionType
FROM AP_StatementTransactions
ORDER BY TransactionDate DESC
