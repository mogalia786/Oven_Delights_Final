-- Check what journal entries exist
SELECT 'JournalHeaders Count' AS TableName, COUNT(*) AS RecordCount FROM JournalHeaders
UNION ALL
SELECT 'JournalDetails Count', COUNT(*) FROM JournalDetails
UNION ALL
SELECT 'JournalLines Count', COUNT(*) FROM JournalLines WHERE 1=0 -- Check if table exists
GO

-- Check recent journal entries in JournalDetails
SELECT TOP 20 
    jh.JournalNumber,
    jh.JournalDate,
    jh.Reference,
    jh.Description AS JournalDesc,
    jd.AccountID,
    jd.Debit,
    jd.Credit,
    jd.Description AS LineDesc
FROM JournalHeaders jh
INNER JOIN JournalDetails jd ON jh.JournalID = jd.JournalID
ORDER BY jh.JournalDate DESC, jh.JournalID, jd.LineNumber
GO

-- Check ChartOfAccounts and see if AccountIDs match
SELECT 
    coa.AccountID,
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    COUNT(jd.AccountID) AS JournalEntryCount,
    SUM(jd.Debit) AS TotalDebit,
    SUM(jd.Credit) AS TotalCredit
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
WHERE coa.IsActive = 1 AND coa.IsSubsidiaryLedger = 0
GROUP BY coa.AccountID, coa.AccountCode, coa.AccountName, coa.AccountType
HAVING COUNT(jd.AccountID) > 0
ORDER BY coa.AccountCode
GO

-- Check if JournalLines table exists (might be the issue)
IF OBJECT_ID('JournalLines', 'U') IS NOT NULL
    SELECT 'JournalLines table EXISTS' AS Status
ELSE
    SELECT 'JournalLines table DOES NOT EXIST' AS Status
GO

-- Check bank statement mappings
SELECT TOP 10 * FROM AP_StatementTransactions ORDER BY TransactionDate DESC
GO

-- Check supplier invoices
SELECT TOP 10 * FROM SupplierInvoices ORDER BY InvoiceDate DESC
GO

-- Check AP_Invoices
SELECT TOP 10 * FROM AP_Invoices ORDER BY InvoiceDate DESC
GO
