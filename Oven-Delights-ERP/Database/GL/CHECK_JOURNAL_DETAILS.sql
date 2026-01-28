-- Check the journal details for the POS journal

-- 1. Get the JournalID
DECLARE @JournalID INT
SELECT @JournalID = JournalID 
FROM JournalHeaders 
WHERE JournalNumber = 'POS-999999'

PRINT 'JournalID: ' + CAST(@JournalID AS NVARCHAR)
PRINT ''

-- 2. Check journal details (the actual debit/credit entries)
SELECT 
    jd.LineNumber,
    coa.AccountCode,
    coa.AccountName,
    jd.Debit,
    jd.Credit,
    jd.Description
FROM JournalDetails jd
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE jd.JournalID = @JournalID
ORDER BY jd.LineNumber

-- 3. Check if IsPosted flag is set
SELECT 
    JournalNumber,
    IsPosted,
    FiscalPeriodID
FROM JournalHeaders
WHERE JournalNumber = 'POS-999999'

-- 4. Check GL account balances (should show the test transaction)
SELECT 
    coa.AccountCode,
    coa.AccountName,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit) - SUM(jd.Credit) AS Balance
FROM JournalDetails jd
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode IN ('1010', '4010', '2020', '5010', '1220')
GROUP BY coa.AccountCode, coa.AccountName
ORDER BY coa.AccountCode
