-- Debug query to check CashBookTransactions data
-- Run this to see what's actually in your cash book

SELECT TOP 20
    t.TransactionID,
    t.TransactionDate,
    t.ReferenceNumber,
    t.TransactionType,
    t.Payee,
    t.Description,
    t.Amount,
    t.PaymentMethod,
    t.CategoryID,
    t.GLAccountID,
    cb.CashBookName,
    cb.CashBookType,
    u.Username AS CreatedBy
FROM CashBookTransactions t
INNER JOIN CashBooks cb ON t.CashBookID = cb.CashBookID
LEFT JOIN Users u ON t.CreatedBy = u.UserID
WHERE t.IsVoid = 0
ORDER BY t.TransactionDate DESC, t.TransactionID DESC;

-- Check if Payee column has data
SELECT 
    COUNT(*) AS TotalTransactions,
    SUM(CASE WHEN Payee IS NULL OR Payee = '' THEN 1 ELSE 0 END) AS BlankPayee,
    SUM(CASE WHEN Payee IS NOT NULL AND Payee <> '' THEN 1 ELSE 0 END) AS HasPayee
FROM CashBookTransactions
WHERE IsVoid = 0;

-- Show sample Payee values
SELECT DISTINCT TOP 10
    Payee,
    COUNT(*) AS Count
FROM CashBookTransactions
WHERE IsVoid = 0
  AND Payee IS NOT NULL
  AND Payee <> ''
GROUP BY Payee
ORDER BY COUNT(*) DESC;
