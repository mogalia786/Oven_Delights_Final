-- =============================================
-- DIAGNOSE GENERAL LEDGER STRUCTURE
-- =============================================

PRINT '========================================='
PRINT 'CHECKING GENERALLEDGER TABLE STRUCTURE'
PRINT '========================================='
PRINT ''

-- Check if GeneralLedger table exists
IF OBJECT_ID('GeneralLedger', 'U') IS NOT NULL
BEGIN
    PRINT 'GeneralLedger table EXISTS'
    PRINT ''
    
    -- Show column structure
    PRINT 'Column Structure:'
    SELECT 
        c.name AS ColumnName,
        t.name AS DataType,
        c.max_length AS MaxLength,
        c.is_nullable AS IsNullable
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('GeneralLedger')
    ORDER BY c.column_id
    
    PRINT ''
    PRINT 'Checking AccountID column data type...'
    
    DECLARE @AccountIDType NVARCHAR(50)
    SELECT @AccountIDType = t.name 
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('GeneralLedger') AND c.name = 'AccountID'
    
    IF @AccountIDType = 'int'
        PRINT '✓ AccountID is INT (correct - should reference ChartOfAccounts.AccountID)'
    ELSE IF @AccountIDType = 'nvarchar' OR @AccountIDType = 'varchar'
        PRINT '✗ AccountID is ' + @AccountIDType + ' (WRONG - should be INT)'
    ELSE
        PRINT '? AccountID is ' + @AccountIDType
    
    PRINT ''
    PRINT 'Sample GL entries (last 10):'
    SELECT TOP 10
        EntryID,
        JournalEntryNumber,
        AccountID,
        DebitAmount,
        CreditAmount,
        Description,
        TransactionDate
    FROM GeneralLedger
    ORDER BY EntryID DESC
    
    PRINT ''
    PRINT 'Checking for invalid AccountID values...'
    
    -- If AccountID is INT, check for orphaned records
    IF @AccountIDType = 'int'
    BEGIN
        SELECT COUNT(*) AS InvalidEntries
        FROM GeneralLedger gl
        WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountID = gl.AccountID)
        
        IF @@ROWCOUNT > 0
        BEGIN
            PRINT 'Found entries with invalid AccountID (not in ChartOfAccounts)'
            SELECT TOP 10 * FROM GeneralLedger gl
            WHERE NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountID = gl.AccountID)
        END
    END
    
END
ELSE
BEGIN
    PRINT '✗ GeneralLedger table DOES NOT EXIST'
END

PRINT ''
PRINT '========================================='
PRINT 'CHECKING CHARTOFACCOUNTS TABLE'
PRINT '========================================='
PRINT ''

IF OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL
BEGIN
    PRINT 'ChartOfAccounts table EXISTS'
    PRINT ''
    
    -- Show key accounts
    PRINT 'Key accounts:'
    SELECT 
        AccountID,
        AccountCode,
        AccountName,
        AccountType,
        IsActive
    FROM ChartOfAccounts
    WHERE AccountCode IN ('1110', '1120', '1200', '2100', '4300', '6080')
    ORDER BY AccountCode
    
    PRINT ''
    PRINT 'Bank account (1120):'
    SELECT * FROM ChartOfAccounts WHERE AccountCode = '1120'
    
END
ELSE
BEGIN
    PRINT '✗ ChartOfAccounts table DOES NOT EXIST'
END

PRINT ''
PRINT '========================================='
PRINT 'CHECKING AP_STATEMENTTRANSACTIONS'
PRINT '========================================='
PRINT ''

IF OBJECT_ID('AP_StatementTransactions', 'U') IS NOT NULL
BEGIN
    PRINT 'AP_StatementTransactions table EXISTS'
    PRINT ''
    
    -- Check for IsMapped column
    IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'IsMapped')
        PRINT '✓ IsMapped column EXISTS'
    ELSE
        PRINT '✗ IsMapped column MISSING - run ALTER_AP_STATEMENT_TRANSACTIONS_ADD_MAPPING.sql'
    
    -- Check for IsReconciled column
    IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('AP_StatementTransactions') AND name = 'IsReconciled')
        PRINT '✓ IsReconciled column EXISTS'
    ELSE
        PRINT '✗ IsReconciled column MISSING'
    
    PRINT ''
    PRINT 'Transaction summary:'
    SELECT 
        COUNT(*) AS TotalTransactions,
        SUM(CASE WHEN CreditDebitIndicator = 'Credit' THEN 1 ELSE 0 END) AS Credits,
        SUM(CASE WHEN CreditDebitIndicator = 'Debit' THEN 1 ELSE 0 END) AS Debits,
        SUM(CASE WHEN IsReconciled = 1 THEN 1 ELSE 0 END) AS Posted
    FROM AP_StatementTransactions
    
END
ELSE
BEGIN
    PRINT '✗ AP_StatementTransactions table DOES NOT EXIST'
END

PRINT ''
PRINT '========================================='
PRINT 'DIAGNOSIS COMPLETE'
PRINT '========================================='
