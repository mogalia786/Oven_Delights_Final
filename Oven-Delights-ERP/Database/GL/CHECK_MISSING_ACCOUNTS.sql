-- Check which GL accounts exist and which are missing

PRINT 'Checking GL Accounts for POS Integration'
PRINT '=========================================='
PRINT ''

-- Required accounts
DECLARE @RequiredAccounts TABLE (
    AccountCode NVARCHAR(10),
    AccountName NVARCHAR(100),
    AccountType NVARCHAR(50)
)

INSERT INTO @RequiredAccounts VALUES
('1010', 'Bank - Current Account', 'Asset'),
('1030', 'Cash on Hand', 'Asset'),
('1050', 'Debtors - Uncleared EFT', 'Asset'),
('1220', 'Inventory - Retail Stock', 'Asset'),
('2010', 'Customer Deposits', 'Liability'),
('2020', 'VAT Output (Payable)', 'Liability'),
('2021', 'VAT Input (Receivable)', 'Asset'),
('4010', 'Sales Revenue - Retail', 'Revenue'),
('4020', 'Sales Returns', 'Revenue'),
('5010', 'Cost of Goods Sold', 'Expense')

-- Check each account
SELECT 
    r.AccountCode,
    r.AccountName,
    r.AccountType,
    CASE 
        WHEN c.AccountID IS NOT NULL THEN '✓ EXISTS'
        ELSE '✗ MISSING'
    END AS Status,
    CASE 
        WHEN c.AccountID IS NOT NULL AND c.IsActive = 0 THEN 'INACTIVE'
        ELSE ''
    END AS Warning
FROM @RequiredAccounts r
LEFT JOIN ChartOfAccounts c ON r.AccountCode = c.AccountCode
ORDER BY r.AccountCode

PRINT ''
PRINT 'Missing Accounts to Create:'
PRINT '----------------------------'

-- Show SQL to create missing accounts
SELECT 
    'INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive) VALUES (''' +
    r.AccountCode + ''', ''' + r.AccountName + ''', ''' + r.AccountType + ''', 1);' AS CreateSQL
FROM @RequiredAccounts r
LEFT JOIN ChartOfAccounts c ON r.AccountCode = c.AccountCode
WHERE c.AccountID IS NULL
