-- Find Sales and Cost of Sales Ledgers in ERP
-- ==============================================

PRINT 'Searching for Sales and Cost of Sales ledgers...';
PRINT '';

-- Check Ledgers table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Ledgers')
BEGIN
    PRINT '1. Ledgers table:';
    SELECT 
        LedgerID,
        LedgerName,
        LedgerType,
        AccountCode,
        IsActive
    FROM Ledgers
    WHERE LedgerName LIKE '%Sales%' 
       OR LedgerName LIKE '%Cost%'
    ORDER BY LedgerName;
END
ELSE
BEGIN
    PRINT '! Ledgers table does not exist';
END

PRINT '';

-- Check ChartOfAccounts table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ChartOfAccounts')
BEGIN
    PRINT '2. Chart of Accounts:';
    SELECT 
        AccountID,
        AccountCode,
        AccountName,
        AccountType,
        IsActive
    FROM ChartOfAccounts
    WHERE AccountName LIKE '%Sales%' 
       OR AccountName LIKE '%Cost%'
    ORDER BY AccountCode;
END
ELSE
BEGIN
    PRINT '! ChartOfAccounts table does not exist';
END

PRINT '';

-- Check GeneralJournal for recent postings
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'GeneralJournal')
BEGIN
    PRINT '3. Recent GL postings (last 10):';
    SELECT TOP 10
        JournalID,
        TransactionDate,
        AccountCode,
        AccountName,
        Debit,
        Credit,
        Description
    FROM GeneralJournal
    ORDER BY CreatedDate DESC;
END
ELSE
BEGIN
    PRINT '! GeneralJournal table does not exist';
END

PRINT '';
PRINT '========================================';
PRINT 'WHERE TO FIND IN ERP:';
PRINT '========================================';
PRINT '1. Accounting Menu > Chart of Accounts';
PRINT '2. Accounting Menu > Ledgers';
PRINT '3. Accounting Menu > General Journal';
PRINT '4. Reports Menu > Trial Balance';
PRINT '5. Reports Menu > Income Statement (P&L)';
PRINT '';
PRINT 'Look for:';
PRINT '- Sales Revenue (Account 4000)';
PRINT '- Cost of Sales (Account 5000)';
GO
