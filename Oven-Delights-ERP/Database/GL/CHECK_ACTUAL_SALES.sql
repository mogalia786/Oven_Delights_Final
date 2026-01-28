-- Check actual POS sales payment methods

-- 1. Recent sales from Demo_Sales
SELECT TOP 10
    InvoiceNumber,
    SaleDate,
    PaymentMethod,
    CashAmount,
    CardAmount,
    TotalAmount,
    BranchID
FROM Demo_Sales
ORDER BY SaleDate DESC, InvoiceNumber DESC

-- 2. Check if these sales have GL journals
SELECT 
    s.InvoiceNumber,
    s.PaymentMethod,
    s.CashAmount,
    s.CardAmount,
    jh.JournalNumber,
    jh.JournalDate,
    jh.Description
FROM Demo_Sales s
LEFT JOIN JournalHeaders jh ON jh.JournalNumber = 'POS-' + RIGHT(s.InvoiceNumber, CHARINDEX('-', REVERSE(s.InvoiceNumber)) - 1)
WHERE s.SaleDate >= '2026-01-19'
ORDER BY s.SaleDate DESC

-- 3. Check journal details for recent POS journals
SELECT 
    jh.JournalNumber,
    jd.Description,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jh.JournalNumber LIKE 'POS-%'
ORDER BY jh.JournalID DESC, jd.LineNumber
