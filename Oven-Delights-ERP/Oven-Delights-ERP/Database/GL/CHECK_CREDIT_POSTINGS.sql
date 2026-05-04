-- Check if credit transactions (deposits, TD TO) were actually posted to GeneralLedger

PRINT 'Checking for deposit and TD TO transactions in GeneralLedger...'
PRINT ''

-- Check bank statement transactions
SELECT 
    TransactionID,
    TransactionDate,
    Description,
    Amount,
    CreditDebitIndicator,
    IsReconciled,
    IsMapped,
    MappedLedgerAccount
FROM AP_StatementTransactions
WHERE (Description LIKE '%DEPOSIT%' OR Description LIKE '%TD TO%')
ORDER BY TransactionDate DESC

PRINT ''
PRINT 'Checking GeneralLedger entries for these transactions...'
PRINT ''

-- Check if they exist in GeneralLedger
SELECT 
    gl.JournalEntryNumber,
    gl.TransactionDate,
    gl.AccountID,
    gl.Description,
    gl.DebitAmount,
    gl.CreditAmount,
    gl.ReferenceID
FROM GeneralLedger gl
WHERE gl.Description LIKE '%DEPOSIT%' 
   OR gl.Description LIKE '%TD TO%'
   OR gl.ReferenceID LIKE '%DEPOSIT%'
   OR gl.ReferenceID LIKE '%TD%'
ORDER BY gl.TransactionDate DESC

PRINT ''
PRINT 'Count of GL entries for deposits/TD TO:'
SELECT COUNT(*) AS TotalEntries
FROM GeneralLedger
WHERE Description LIKE '%DEPOSIT%' 
   OR Description LIKE '%TD TO%'
   OR ReferenceID LIKE '%DEPOSIT%'
   OR ReferenceID LIKE '%TD%'
