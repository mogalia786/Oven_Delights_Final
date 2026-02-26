-- =============================================
-- Check actual schema of key tables
-- =============================================

PRINT '========================================='
PRINT 'CHECKING ACTUAL DATABASE SCHEMA'
PRINT '========================================='
PRINT ''

-- Check SupplierInvoices columns
PRINT 'SupplierInvoices columns:'
PRINT '-------------------------------------------'
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'SupplierInvoices' AND type = 'U')
BEGIN
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'SupplierInvoices'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT 'Table does not exist'

PRINT ''

-- Check GLBatches columns
PRINT 'GLBatches columns:'
PRINT '-------------------------------------------'
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'GLBatches' AND type = 'U')
BEGIN
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'GLBatches'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT 'Table does not exist'

PRINT ''

-- Check Suppliers columns
PRINT 'Suppliers columns:'
PRINT '-------------------------------------------'
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Suppliers' AND type = 'U')
BEGIN
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Suppliers'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT 'Table does not exist'

PRINT ''

-- Check Beneficiaries columns
PRINT 'Beneficiaries columns:'
PRINT '-------------------------------------------'
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'Beneficiaries' AND type = 'U')
BEGIN
    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'Beneficiaries'
    ORDER BY ORDINAL_POSITION
END
ELSE
    PRINT 'Table does not exist'

PRINT ''
PRINT '========================================='
PRINT 'SCHEMA CHECK COMPLETE'
PRINT '========================================='
