-- Check unposted credit transactions
SELECT 
    TransactionID,
    TransactionDate,
    Amount,
    CreditDebitIndicator,
    Description,
    Reference,
    IsReconciled,
    CASE 
        WHEN Reference LIKE '%FNB OB PMT%' THEN 'EFT Payment → AR (1200)'
        WHEN Reference LIKE '%FNB OB COLL%' THEN 'Collection → AR (1200)'
        WHEN Reference LIKE '%FNB OB TRF%' THEN 'Transfer → Undeposited (1050)'
        WHEN Description LIKE '%DEPOSIT%' THEN 'Cash Deposit → Cash (1000)'
        ELSE 'Other → Undeposited (1050)'
    END AS WillMapTo
FROM AP_StatementTransactions
WHERE CreditDebitIndicator = 'Credit' 
  AND (IsReconciled = 0 OR IsReconciled IS NULL)
ORDER BY TransactionDate ASC;

-- Check if any have already been posted
SELECT 
    COUNT(*) AS TotalCredits,
    SUM(CASE WHEN IsReconciled = 1 THEN 1 ELSE 0 END) AS Posted,
    SUM(CASE WHEN IsReconciled = 0 OR IsReconciled IS NULL THEN 1 ELSE 0 END) AS Unposted
FROM AP_StatementTransactions
WHERE CreditDebitIndicator = 'Credit';
