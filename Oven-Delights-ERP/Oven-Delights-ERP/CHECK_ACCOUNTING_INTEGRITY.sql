-- =============================================
-- Check Accounting Data Integrity
-- Verify supplier invoices, chart of accounts setup, and data sources
-- =============================================

PRINT '========================================='
PRINT 'CHECKING CHART OF ACCOUNTS SETUP'
PRINT '========================================='

-- Check if IsSubsidiaryLedger flag exists and is set correctly
SELECT 
    AccountID,
    AccountCode,
    AccountName,
    ISNULL(IsSubsidiaryLedger, 0) AS IsSubsidiaryLedger,
    IsActive
FROM ChartOfAccounts
WHERE AccountCode IN ('1200', '2100')  -- Accounts Receivable and Accounts Payable
ORDER BY AccountCode

PRINT ''
PRINT '========================================='
PRINT 'CHECKING SUPPLIER LEDGER DATA'
PRINT '========================================='

-- Check if supplier invoices exist in SupplierLedger
SELECT 
    COUNT(*) AS TotalSupplierTransactions,
    SUM(CreditAmount) AS TotalInvoices,
    SUM(DebitAmount) AS TotalPayments,
    SUM(CreditAmount - DebitAmount) AS NetBalance
FROM SupplierLedger

-- Show recent supplier ledger entries
SELECT TOP 10
    sl.LedgerID,
    sl.TransactionDate,
    sl.SupplierName,
    sl.ReferenceNumber,
    sl.Description,
    sl.DebitAmount,
    sl.CreditAmount,
    sl.RunningBalance
FROM SupplierLedger sl
ORDER BY sl.TransactionDate DESC, sl.LedgerID DESC

PRINT ''
PRINT '========================================='
PRINT 'CHECKING CUSTOMER LEDGER DATA'
PRINT '========================================='

-- Check if customer transactions exist in CustomerLedger
SELECT 
    COUNT(*) AS TotalCustomerTransactions,
    SUM(DebitAmount) AS TotalInvoices,
    SUM(CreditAmount) AS TotalPayments,
    SUM(DebitAmount - CreditAmount) AS NetBalance
FROM CustomerLedger

PRINT ''
PRINT '========================================='
PRINT 'CHECKING JOURNAL DETAILS DATA'
PRINT '========================================='

-- Check journal entries for Equipment account (1510)
SELECT 
    coa.AccountCode,
    coa.AccountName,
    COUNT(jd.JournalDetailID) AS TransactionCount,
    SUM(jd.Debit) AS TotalDebits,
    SUM(jd.Credit) AS TotalCredits,
    SUM(jd.Debit - jd.Credit) AS NetBalance
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
WHERE coa.AccountCode = '1510'
GROUP BY coa.AccountCode, coa.AccountName

-- Show recent Equipment journal entries
SELECT TOP 10
    jh.JournalDate,
    jh.JournalNumber,
    jh.Reference,
    jh.Description,
    jd.Debit,
    jd.Credit
FROM JournalDetails jd
INNER JOIN JournalHeaders jh ON jd.JournalID = jh.JournalID
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '1510'
ORDER BY jh.JournalDate DESC, jh.JournalID DESC

PRINT ''
PRINT '========================================='
PRINT 'CHECKING ACCOUNTS PAYABLE BALANCE'
PRINT '========================================='

-- Compare Accounts Payable balance from different sources
PRINT 'From SupplierLedger:'
SELECT 
    '2100' AS AccountCode,
    'Accounts Payable' AS AccountName,
    SUM(sl.CreditAmount - sl.DebitAmount) AS Balance
FROM SupplierLedger sl

PRINT 'From JournalDetails:'
SELECT 
    coa.AccountCode,
    coa.AccountName,
    SUM(jd.Credit - jd.Debit) AS Balance
FROM JournalDetails jd
INNER JOIN ChartOfAccounts coa ON jd.AccountID = coa.AccountID
WHERE coa.AccountCode = '2100'
GROUP BY coa.AccountCode, coa.AccountName

PRINT ''
PRINT '========================================='
PRINT 'CHECKING ALL ACCOUNT BALANCES'
PRINT '========================================='

-- Show all accounts with their balances from correct source
SELECT 
    coa.AccountCode,
    coa.AccountName,
    ISNULL(coa.IsSubsidiaryLedger, 0) AS IsSubsidiaryLedger,
    CASE 
        WHEN coa.IsSubsidiaryLedger = 1 AND coa.AccountCode LIKE '2%' THEN 'SupplierLedger'
        WHEN coa.IsSubsidiaryLedger = 1 AND coa.AccountCode LIKE '1%' THEN 'CustomerLedger'
        ELSE 'JournalDetails'
    END AS DataSource,
    ISNULL(SUM(jd.Debit), 0) AS JournalDebits,
    ISNULL(SUM(jd.Credit), 0) AS JournalCredits,
    CASE 
        WHEN coa.AccountCode LIKE '1%' OR coa.AccountCode LIKE '5%' 
            THEN ISNULL(SUM(jd.Debit - jd.Credit), 0)
        ELSE ISNULL(SUM(jd.Credit - jd.Debit), 0)
    END AS JournalBalance
FROM ChartOfAccounts coa
LEFT JOIN JournalDetails jd ON coa.AccountID = jd.AccountID
WHERE coa.IsActive = 1
GROUP BY coa.AccountID, coa.AccountCode, coa.AccountName, coa.IsSubsidiaryLedger
ORDER BY coa.AccountCode

PRINT ''
PRINT '========================================='
PRINT 'CHECKING FOR MISSING IsSubsidiaryLedger FLAG'
PRINT '========================================='

-- Check if IsSubsidiaryLedger column exists
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'ChartOfAccounts' 
    AND COLUMN_NAME = 'IsSubsidiaryLedger'
)
BEGIN
    PRINT 'WARNING: IsSubsidiaryLedger column does NOT exist in ChartOfAccounts table!'
    PRINT 'Need to add this column and set it to 1 for Accounts Payable and Accounts Receivable'
END
ELSE
BEGIN
    PRINT 'IsSubsidiaryLedger column exists'
    
    -- Check if it's set correctly for control accounts
    SELECT 
        AccountCode,
        AccountName,
        IsSubsidiaryLedger,
        CASE 
            WHEN AccountCode IN ('1200', '2100') AND IsSubsidiaryLedger = 1 THEN 'OK'
            WHEN AccountCode IN ('1200', '2100') AND (IsSubsidiaryLedger = 0 OR IsSubsidiaryLedger IS NULL) THEN 'NEEDS FIX'
            ELSE 'N/A'
        END AS Status
    FROM ChartOfAccounts
    WHERE AccountCode IN ('1200', '2100')
END
