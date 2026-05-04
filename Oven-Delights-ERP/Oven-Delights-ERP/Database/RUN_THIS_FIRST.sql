-- =============================================
-- DIAGNOSTIC: Check BankStatementTransactions Structure
-- RUN THIS FIRST to see what's wrong
-- =============================================

PRINT '========================================='
PRINT 'CHECKING BankStatementTransactions TABLE'
PRINT '========================================='
PRINT ''

-- Does table exist?
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementTransactions' AND type = 'U')
BEGIN
    PRINT '✓ BankStatementTransactions table EXISTS'
    PRINT ''
    PRINT 'Current columns in table:'
    PRINT '-------------------------------------------'
    
    SELECT 
        COLUMN_NAME AS [Column],
        DATA_TYPE AS [Type],
        CASE WHEN IS_NULLABLE = 'YES' THEN 'NULL' ELSE 'NOT NULL' END AS [Nullable]
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'BankStatementTransactions'
    ORDER BY ORDINAL_POSITION
    
    PRINT ''
    PRINT 'Checking for REQUIRED columns:'
    PRINT '-------------------------------------------'
    
    -- Check each required column
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'StatementLineID')
        PRINT '✓ StatementLineID exists'
    ELSE
        PRINT '✗ StatementLineID MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'BankAccountID')
        PRINT '✓ BankAccountID exists'
    ELSE
        PRINT '✗ BankAccountID MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'Status')
        PRINT '✓ Status exists'
    ELSE
        PRINT '✗ Status MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'PostedToGL')
        PRINT '✓ PostedToGL exists'
    ELSE
        PRINT '✗ PostedToGL MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'TransactionDate')
        PRINT '✓ TransactionDate exists'
    ELSE
        PRINT '✗ TransactionDate MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'Description')
        PRINT '✓ Description exists'
    ELSE
        PRINT '✗ Description MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'DebitAmount')
        PRINT '✓ DebitAmount exists'
    ELSE
        PRINT '✗ DebitAmount MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('BankStatementTransactions') AND name = 'CreditAmount')
        PRINT '✓ CreditAmount exists'
    ELSE
        PRINT '✗ CreditAmount MISSING'
    
    PRINT ''
    PRINT '========================================='
    PRINT 'DIAGNOSIS COMPLETE'
    PRINT '========================================='
    PRINT ''
    PRINT 'IF ANY COLUMNS ARE MISSING:'
    PRINT '1. Run DROP_AND_RECREATE_BANK_TABLES.sql'
    PRINT '2. Then run CREATE_BANK_RECONCILIATION_SYSTEM.sql'
    PRINT '3. Then run the stored procedure scripts'
    
END
ELSE
BEGIN
    PRINT '✗ BankStatementTransactions table DOES NOT EXIST'
    PRINT ''
    PRINT 'ACTION REQUIRED:'
    PRINT '1. Run CREATE_BANK_RECONCILIATION_SYSTEM.sql'
    PRINT '2. Then run the stored procedure scripts'
END

PRINT ''
