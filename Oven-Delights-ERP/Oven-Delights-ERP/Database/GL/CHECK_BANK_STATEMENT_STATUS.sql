-- Check current status of bank statement transactions
SELECT 
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN PostedToGL = 1 THEN 1 ELSE 0 END) AS PostedCount,
    SUM(CASE WHEN PostedToGL = 0 THEN 1 ELSE 0 END) AS NotPostedCount
FROM BankStatementTransactions

-- Show sample records
SELECT TOP 10
    TransactionID,
    TransactionDate,
    Description,
    Amount,
    PostedToGL,
    PostedDate,
    PostedBy
FROM BankStatementTransactions
ORDER BY TransactionDate DESC
