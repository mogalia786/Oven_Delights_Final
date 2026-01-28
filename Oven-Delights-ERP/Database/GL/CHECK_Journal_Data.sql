-- Quick check for journal data

-- 1. Count total journals
SELECT 'Total Journals' AS CheckType, COUNT(*) AS Count FROM JournalHeaders

-- 2. Count posted journals
SELECT 'Posted Journals' AS CheckType, COUNT(*) AS Count FROM JournalHeaders WHERE IsPosted = 1

-- 3. Count journal details
SELECT 'Total Journal Lines' AS CheckType, COUNT(*) AS Count FROM JournalDetails

-- 4. Sample of journal headers
SELECT TOP 10 
    JournalID,
    JournalNumber,
    JournalDate,
    Description,
    IsPosted,
    BranchID
FROM JournalHeaders
ORDER BY JournalDate DESC

-- 5. Check if any accounts have transactions
SELECT 
    coa.AccountCode,
    coa.AccountName,
    COUNT(jd.JournalDetailID) AS TransactionCount
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
LEFT JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID AND jh.IsPosted = 1
GROUP BY coa.AccountCode, coa.AccountName
HAVING COUNT(jd.JournalDetailID) > 0
ORDER BY coa.AccountCode
