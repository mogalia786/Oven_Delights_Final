-- =============================================
-- DROP BATCH PAYMENT TABLES WITH CONSTRAINTS
-- =============================================

-- First, drop all foreign key constraints
DECLARE @sql NVARCHAR(MAX) = '';

-- Drop FKs referencing SupplierPayments
SELECT @sql = @sql + 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + 
              ' DROP CONSTRAINT ' + name + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('SupplierPayments');

-- Drop FKs referencing SupplierInvoices
SELECT @sql = @sql + 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + 
              ' DROP CONSTRAINT ' + name + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('SupplierInvoices');

-- Drop FKs referencing PaymentBatches
SELECT @sql = @sql + 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + 
              ' DROP CONSTRAINT ' + name + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('PaymentBatches');

-- Drop FKs referencing BankAccounts
SELECT @sql = @sql + 'ALTER TABLE ' + OBJECT_NAME(parent_object_id) + 
              ' DROP CONSTRAINT ' + name + ';' + CHAR(13)
FROM sys.foreign_keys
WHERE referenced_object_id = OBJECT_ID('BankAccounts');

IF LEN(@sql) > 0
BEGIN
    PRINT 'Dropping foreign key constraints...';
    EXEC sp_executesql @sql;
    PRINT '✅ Foreign key constraints dropped';
END

-- Now drop tables in order
-- Drop existing SupplierPaymentAllocations first (if it exists)
IF OBJECT_ID('SupplierPaymentAllocations', 'U') IS NOT NULL
BEGIN
    DROP TABLE SupplierPaymentAllocations;
    PRINT '✅ SupplierPaymentAllocations dropped';
END

IF OBJECT_ID('SupplierInvoicePayments', 'U') IS NOT NULL
BEGIN
    DROP TABLE SupplierInvoicePayments;
    PRINT '✅ SupplierInvoicePayments dropped';
END

IF OBJECT_ID('PaymentBatchItems', 'U') IS NOT NULL
BEGIN
    DROP TABLE PaymentBatchItems;
    PRINT '✅ PaymentBatchItems dropped';
END

IF OBJECT_ID('SupplierPayments', 'U') IS NOT NULL
BEGIN
    DROP TABLE SupplierPayments;
    PRINT '✅ SupplierPayments dropped';
END

IF OBJECT_ID('PaymentBatches', 'U') IS NOT NULL
BEGIN
    DROP TABLE PaymentBatches;
    PRINT '✅ PaymentBatches dropped';
END

IF OBJECT_ID('SupplierInvoices', 'U') IS NOT NULL
BEGIN
    DROP TABLE SupplierInvoices;
    PRINT '✅ SupplierInvoices dropped';
END

IF OBJECT_ID('BankAccounts', 'U') IS NOT NULL
BEGIN
    DROP TABLE BankAccounts;
    PRINT '✅ BankAccounts dropped';
END

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ ALL BATCH PAYMENT TABLES DROPPED!';
PRINT '═══════════════════════════════════════════════';
