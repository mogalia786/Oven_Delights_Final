-- Check the account hierarchy structure
SELECT 
    coa.AccountCode,
    coa.AccountName,
    coa.AccountType,
    coa.ParentAccountID,
    parent.AccountCode AS ParentCode,
    parent.AccountName AS ParentName
FROM ChartOfAccounts coa
LEFT JOIN ChartOfAccounts parent ON coa.ParentAccountID = parent.AccountID
WHERE coa.IsActive = 1
ORDER BY coa.AccountCode

-- Check if we have balances in different sources
PRINT ''
PRINT 'Checking balance sources:'
PRINT ''

-- GeneralLedger balances
SELECT 'GeneralLedger' AS Source, COUNT(*) AS RecordCount, SUM(DebitAmount) AS TotalDebits, SUM(CreditAmount) AS TotalCredits
FROM GeneralLedger
WHERE IsReversed = 0

-- SupplierLedger balances (for AP)
SELECT 'SupplierLedger' AS Source, COUNT(*) AS RecordCount, SUM(DebitAmount) AS TotalDebits, SUM(CreditAmount) AS TotalCredits
FROM SupplierLedger

-- CustomerLedger balances (for AR)
SELECT 'CustomerLedger' AS Source, COUNT(*) AS RecordCount, SUM(DebitAmount) AS TotalDebits, SUM(CreditAmount) AS TotalCredits
FROM CustomerLedger
