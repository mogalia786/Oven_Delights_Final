-- =============================================
-- VERIFY TABLE NAMES BEFORE RUNNING ACCOUNTING SCRIPTS
-- This script checks which invoice tables exist in your database
-- =============================================

PRINT '=========================================='
PRINT 'VERIFYING TABLE STRUCTURE'
PRINT '=========================================='
PRINT ''

-- Check which invoice tables exist
PRINT 'Checking for invoice tables...'
PRINT ''

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'AP_Invoices')
BEGIN
    PRINT '✓ Found: AP_Invoices (with underscore)'
    
    PRINT ''
    PRINT 'Columns in AP_Invoices:'
    SELECT 
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'AP_Invoices'
    ORDER BY ORDINAL_POSITION;
    
    PRINT ''
    PRINT 'Row count:'
    DECLARE @AP_Count INT;
    SELECT @AP_Count = COUNT(*) FROM AP_Invoices;
    PRINT 'AP_Invoices has ' + CAST(@AP_Count AS NVARCHAR(10)) + ' rows';
END
ELSE
BEGIN
    PRINT '✗ AP_Invoices (with underscore) does NOT exist'
END

PRINT ''
PRINT '-------------------------------------------'
PRINT ''

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'APInvoices')
BEGIN
    PRINT '✓ Found: APInvoices (no underscore)'
    
    PRINT ''
    PRINT 'Columns in APInvoices:'
    SELECT 
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'APInvoices'
    ORDER BY ORDINAL_POSITION;
    
    PRINT ''
    PRINT 'Row count:'
    DECLARE @API_Count INT;
    SELECT @API_Count = COUNT(*) FROM APInvoices;
    PRINT 'APInvoices has ' + CAST(@API_Count AS NVARCHAR(10)) + ' rows';
END
ELSE
BEGIN
    PRINT '✗ APInvoices (no underscore) does NOT exist'
END

PRINT ''
PRINT '-------------------------------------------'
PRINT ''

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'SupplierInvoices')
BEGIN
    PRINT '✓ Found: SupplierInvoices'
    
    PRINT ''
    PRINT 'Columns in SupplierInvoices:'
    SELECT 
        COLUMN_NAME, 
        DATA_TYPE, 
        IS_NULLABLE,
        CHARACTER_MAXIMUM_LENGTH
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'SupplierInvoices'
    ORDER BY ORDINAL_POSITION;
    
    PRINT ''
    PRINT 'Row count:'
    DECLARE @SI_Count INT;
    SELECT @SI_Count = COUNT(*) FROM SupplierInvoices;
    PRINT 'SupplierInvoices has ' + CAST(@SI_Count AS NVARCHAR(10)) + ' rows';
END
ELSE
BEGIN
    PRINT '✗ SupplierInvoices does NOT exist'
END

PRINT ''
PRINT '=========================================='
PRINT 'OTHER IMPORTANT TABLES'
PRINT '=========================================='
PRINT ''

-- Check for Suppliers table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Suppliers')
BEGIN
    PRINT '✓ Suppliers table exists'
    DECLARE @SupCount INT;
    SELECT @SupCount = COUNT(*) FROM Suppliers;
    PRINT '  ' + CAST(@SupCount AS NVARCHAR(10)) + ' suppliers found';
END
ELSE
    PRINT '✗ Suppliers table does NOT exist'

PRINT ''

-- Check for ChartOfAccounts table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'ChartOfAccounts')
BEGIN
    PRINT '✓ ChartOfAccounts table exists'
    DECLARE @COACount INT;
    SELECT @COACount = COUNT(*) FROM ChartOfAccounts;
    PRINT '  ' + CAST(@COACount AS NVARCHAR(10)) + ' accounts found';
    
    -- Check if it has the new columns
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'SupplierID')
        PRINT '  ✓ SupplierID column exists'
    ELSE
        PRINT '  ✗ SupplierID column does NOT exist (will be added by scripts)'
    
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ChartOfAccounts' AND COLUMN_NAME = 'IsSubsidiaryLedger')
        PRINT '  ✓ IsSubsidiaryLedger column exists'
    ELSE
        PRINT '  ✗ IsSubsidiaryLedger column does NOT exist (will be added by scripts)'
END
ELSE
    PRINT '✗ ChartOfAccounts table does NOT exist'

PRINT ''

-- Check for JournalHeaders table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'JournalHeaders')
BEGIN
    PRINT '✓ JournalHeaders table exists'
    DECLARE @JHCount INT;
    SELECT @JHCount = COUNT(*) FROM JournalHeaders;
    PRINT '  ' + CAST(@JHCount AS NVARCHAR(10)) + ' journal headers found';
END
ELSE
    PRINT '✗ JournalHeaders table does NOT exist'

PRINT ''

-- Check for JournalLines table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'JournalLines')
BEGIN
    PRINT '✓ JournalLines table exists'
    DECLARE @JLCount INT;
    SELECT @JLCount = COUNT(*) FROM JournalLines;
    PRINT '  ' + CAST(@JLCount AS NVARCHAR(10)) + ' journal lines found';
END
ELSE
    PRINT '✗ JournalLines table does NOT exist'

PRINT ''

-- Check for Customers table
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Customers')
BEGIN
    PRINT '✓ Customers table exists'
    DECLARE @CustCount INT;
    SELECT @CustCount = COUNT(*) FROM Customers;
    PRINT '  ' + CAST(@CustCount AS NVARCHAR(10)) + ' customers found';
END
ELSE
    PRINT '✗ Customers table does NOT exist'

PRINT ''
PRINT '=========================================='
PRINT 'VERIFICATION COMPLETE'
PRINT '=========================================='
PRINT ''
PRINT 'NEXT STEPS:'
PRINT '1. Review the output above'
PRINT '2. Share the results with me'
PRINT '3. I will adjust the scripts to match your table names'
PRINT '4. Then you can safely run the accounting scripts'
PRINT ''
