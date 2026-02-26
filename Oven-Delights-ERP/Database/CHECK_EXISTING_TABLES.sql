-- =============================================
-- Check if Bank Reconciliation tables exist and their structure
-- =============================================

PRINT '========================================='
PRINT 'CHECKING EXISTING TABLES'
PRINT '========================================='
PRINT ''

-- Check BankStatementTransactions
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BankStatementTransactions' AND type = 'U')
BEGIN
    PRINT '✓ BankStatementTransactions table EXISTS'
    PRINT 'Columns in BankStatementTransactions:'
    SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'BankStatementTransactions'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT '✗ BankStatementTransactions table DOES NOT EXIST'

PRINT ''

-- Check BeneficiaryPayments
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'BeneficiaryPayments' AND type = 'U')
BEGIN
    PRINT '✓ BeneficiaryPayments table EXISTS'
    PRINT 'Columns in BeneficiaryPayments:'
    SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'BeneficiaryPayments'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT '✗ BeneficiaryPayments table DOES NOT EXIST'

PRINT ''

-- Check SupplierInvoices
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'SupplierInvoices' AND type = 'U')
BEGIN
    PRINT '✓ SupplierInvoices table EXISTS'
    PRINT 'Checking for bank reconciliation columns:'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'PaymentReference')
        PRINT '  ✓ PaymentReference column exists'
    ELSE
        PRINT '  ✗ PaymentReference column MISSING'
    
    IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'Status')
        PRINT '  ✓ Status column exists'
    ELSE
        PRINT '  ✗ Status column MISSING'
END
ELSE
    PRINT '✗ SupplierInvoices table DOES NOT EXIST'

PRINT ''
PRINT '========================================='
PRINT 'CHECK COMPLETE'
PRINT '========================================='
