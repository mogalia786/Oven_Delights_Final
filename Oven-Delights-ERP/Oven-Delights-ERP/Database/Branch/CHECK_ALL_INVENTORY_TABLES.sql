-- Check which inventory and journal tables exist

PRINT 'CHECKING INVENTORY AND JOURNAL TABLES:';
PRINT '';

-- Stockroom tables
IF OBJECT_ID('StockroomStock', 'U') IS NOT NULL
    PRINT '✓ StockroomStock exists'
ELSE
    PRINT '✗ StockroomStock does NOT exist';

IF OBJECT_ID('Stockroom_Inventory', 'U') IS NOT NULL
    PRINT '✓ Stockroom_Inventory exists'
ELSE
    PRINT '✗ Stockroom_Inventory does NOT exist';

-- Manufacturing tables
IF OBJECT_ID('ManufacturingStock', 'U') IS NOT NULL
    PRINT '✓ ManufacturingStock exists'
ELSE
    PRINT '✗ ManufacturingStock does NOT exist';

IF OBJECT_ID('Manufacturing_Inventory', 'U') IS NOT NULL
BEGIN
    PRINT '✓ Manufacturing_Inventory exists';
    SELECT c.name AS ColumnName FROM sys.columns c WHERE c.object_id = OBJECT_ID('Manufacturing_Inventory') ORDER BY c.column_id;
END
ELSE
    PRINT '✗ Manufacturing_Inventory does NOT exist';

-- Retail tables
IF OBJECT_ID('RetailStock', 'U') IS NOT NULL
BEGIN
    PRINT '✓ RetailStock exists';
    SELECT c.name AS ColumnName FROM sys.columns c WHERE c.object_id = OBJECT_ID('RetailStock') ORDER BY c.column_id;
END
ELSE
    PRINT '✗ RetailStock does NOT exist';

IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
    PRINT '✓ Demo_Retail_Stock exists'
ELSE
    PRINT '✗ Demo_Retail_Stock does NOT exist';

-- Journal/Ledger tables
IF OBJECT_ID('ChartOfAccounts', 'U') IS NOT NULL
    PRINT '✓ ChartOfAccounts exists'
ELSE
    PRINT '✗ ChartOfAccounts does NOT exist';

IF OBJECT_ID('JournalEntries', 'U') IS NOT NULL
    PRINT '✓ JournalEntries exists'
ELSE
    PRINT '✗ JournalEntries does NOT exist';

IF OBJECT_ID('GeneralLedger', 'U') IS NOT NULL
    PRINT '✓ GeneralLedger exists'
ELSE
    PRINT '✗ GeneralLedger does NOT exist';
