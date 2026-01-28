-- Diagnostic queries to check journal data

-- 1. Check if there are any journals
SELECT COUNT(*) AS TotalJournals FROM JournalHeaders
SELECT COUNT(*) AS TotalJournalLines FROM JournalDetails

-- 2. Check posted journals
SELECT COUNT(*) AS PostedJournals FROM JournalHeaders WHERE IsPosted = 1

-- 3. Check account 1200 (Accounts Receivable) specifically
SELECT TOP 10
    jh.JournalID,
    jh.JournalNumber,
    jh.JournalDate,
    jh.IsPosted,
    jd.AccountID,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '1200'
ORDER BY jh.JournalDate DESC

-- 4. Test the stored procedure directly (only if account 1200 exists)
DECLARE @AccountID INT
SELECT @AccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1200'

IF @AccountID IS NOT NULL
BEGIN
    EXEC sp_GetAccountLedger 
        @AccountID = @AccountID,
        @FromDate = '2025-12-01',
        @ToDate = '2026-01-27',
        @BranchID = NULL
END
ELSE
BEGIN
    PRINT 'Account 1200 not found. Skipping stored procedure test.'
END

-- 5. Check all accounts with transactions
SELECT 
    coa.AccountCode,
    coa.AccountName,
    COUNT(*) AS TransactionCount,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits
FROM JournalDetails jd
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
WHERE jh.IsPosted = 1
GROUP BY coa.AccountCode, coa.AccountName
ORDER BY coa.AccountCode
