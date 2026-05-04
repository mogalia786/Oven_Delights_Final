-- =============================================
-- COMPREHENSIVE ACCOUNTS PAYABLE ACCOUNT FIX
-- Identifies actual AP account and fixes all procedures
-- =============================================

PRINT '========================================='
PRINT 'ACCOUNTS PAYABLE ACCOUNT ANALYSIS'
PRINT '========================================='
PRINT ''

-- Check which AP accounts exist
PRINT 'Checking for Accounts Payable accounts...'
PRINT ''

DECLARE @AP_2010 INT, @AP_2030 INT, @AP_2100 INT
DECLARE @ActualAPAccount NVARCHAR(10)
DECLARE @ActualAPAccountID INT

SELECT @AP_2010 = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
SELECT @AP_2030 = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
SELECT @AP_2100 = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1

DECLARE @AccountName NVARCHAR(200)

IF @AP_2010 IS NOT NULL
BEGIN
    SELECT @AccountName = AccountName FROM ChartOfAccounts WHERE AccountCode = '2010'
    PRINT '✓ Found account 2010: ' + @AccountName
    SELECT 
        'Account 2010' AS Account,
        AccountName,
        ISNULL(SUM(Debit), 0) AS TotalDebits,
        ISNULL(SUM(Credit), 0) AS TotalCredits,
        ISNULL(SUM(Credit - Debit), 0) AS Balance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON jd.AccountID = coa.AccountID
    WHERE coa.AccountCode = '2010'
    GROUP BY coa.AccountName
END
ELSE
    PRINT '✗ Account 2010 does not exist'

IF @AP_2030 IS NOT NULL
BEGIN
    SELECT @AccountName = AccountName FROM ChartOfAccounts WHERE AccountCode = '2030'
    PRINT '✓ Found account 2030: ' + @AccountName
    SELECT 
        'Account 2030' AS Account,
        AccountName,
        ISNULL(SUM(Debit), 0) AS TotalDebits,
        ISNULL(SUM(Credit), 0) AS TotalCredits,
        ISNULL(SUM(Credit - Debit), 0) AS Balance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON jd.AccountID = coa.AccountID
    WHERE coa.AccountCode = '2030'
    GROUP BY coa.AccountName
END
ELSE
    PRINT '✗ Account 2030 does not exist'

IF @AP_2100 IS NOT NULL
BEGIN
    SELECT @AccountName = AccountName FROM ChartOfAccounts WHERE AccountCode = '2100'
    PRINT '✓ Found account 2100: ' + @AccountName
    SELECT 
        'Account 2100' AS Account,
        AccountName,
        ISNULL(SUM(Debit), 0) AS TotalDebits,
        ISNULL(SUM(Credit), 0) AS TotalCredits,
        ISNULL(SUM(Credit - Debit), 0) AS Balance
    FROM ChartOfAccounts coa
    LEFT JOIN JournalDetails jd ON jd.AccountID = coa.AccountID
    WHERE coa.AccountCode = '2100'
    GROUP BY coa.AccountName
END
ELSE
    PRINT '✗ Account 2100 does not exist'

PRINT ''

-- Determine the correct AP account (prefer 2100, then 2010, then 2030)
IF @AP_2100 IS NOT NULL
BEGIN
    SET @ActualAPAccount = '2100'
    SET @ActualAPAccountID = @AP_2100
    PRINT '>>> USING ACCOUNT 2100 AS PRIMARY ACCOUNTS PAYABLE <<<'
END
ELSE IF @AP_2010 IS NOT NULL
BEGIN
    SET @ActualAPAccount = '2010'
    SET @ActualAPAccountID = @AP_2010
    PRINT '>>> USING ACCOUNT 2010 AS PRIMARY ACCOUNTS PAYABLE <<<'
END
ELSE IF @AP_2030 IS NOT NULL
BEGIN
    SET @ActualAPAccount = '2030'
    SET @ActualAPAccountID = @AP_2030
    PRINT '>>> USING ACCOUNT 2030 AS PRIMARY ACCOUNTS PAYABLE <<<'
END
ELSE
BEGIN
    PRINT '✗✗✗ ERROR: NO ACCOUNTS PAYABLE ACCOUNT FOUND ✗✗✗'
    PRINT 'Creating account 2100 - Accounts Payable...'
    
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, IsControlAccount, CreatedDate)
    VALUES ('2100', 'Accounts Payable', 'Liability', 1, 1, GETDATE())
    
    SET @ActualAPAccount = '2100'
    SELECT @ActualAPAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100'
    
    PRINT '✓ Created account 2100 - Accounts Payable'
END

PRINT ''
PRINT '========================================='
PRINT 'CHECKING SUPPLIER LEDGER BALANCES'
PRINT '========================================='
PRINT ''

-- Check SupplierLedger balances
IF EXISTS (SELECT 1 FROM sys.tables WHERE name = 'SupplierLedger')
BEGIN
    SELECT 
        'SupplierLedger' AS Source,
        COUNT(*) AS TransactionCount,
        SUM(CreditAmount) AS TotalCredits,
        SUM(DebitAmount) AS TotalDebits,
        SUM(CreditAmount - DebitAmount) AS NetBalance
    FROM SupplierLedger
    WHERE IsReversed = 0
    
    PRINT ''
    PRINT 'Top 10 Suppliers by Balance:'
    SELECT TOP 10
        SupplierCode,
        SupplierName,
        SUM(CreditAmount - DebitAmount) AS Balance
    FROM SupplierLedger
    WHERE IsReversed = 0
    GROUP BY SupplierCode, SupplierName
    ORDER BY SUM(CreditAmount - DebitAmount) DESC
END
ELSE
    PRINT '✗ SupplierLedger table does not exist'

PRINT ''
PRINT '========================================='
PRINT 'ANALYSIS COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'PRIMARY ACCOUNTS PAYABLE ACCOUNT: ' + @ActualAPAccount
PRINT ''
PRINT 'RECOMMENDATION:'
PRINT '  1. All GL procedures should use account ' + @ActualAPAccount
PRINT '  2. SupplierLedger balance should match GL account ' + @ActualAPAccount + ' balance'
PRINT '  3. If balances do not match, investigate posting procedures'
PRINT ''
PRINT 'Next step: Run FIX_ALL_AP_PROCEDURES.sql to update all procedures to use ' + @ActualAPAccount
PRINT ''
