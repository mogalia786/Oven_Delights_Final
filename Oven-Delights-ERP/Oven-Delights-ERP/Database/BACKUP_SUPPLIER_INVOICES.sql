-- =============================================
-- Backup SupplierInvoices data to temporary table
-- =============================================

PRINT 'Backing up SupplierInvoices data...'

-- Create backup table
IF OBJECT_ID('SupplierInvoices_Backup', 'U') IS NOT NULL
    DROP TABLE SupplierInvoices_Backup;

SELECT *
INTO SupplierInvoices_Backup
FROM SupplierInvoices;

DECLARE @rowCount INT = @@ROWCOUNT;
PRINT 'Backed up ' + CAST(@rowCount AS NVARCHAR(10)) + ' invoice records to SupplierInvoices_Backup'

-- Also backup invoice lines
IF OBJECT_ID('SupplierInvoiceLines_Backup', 'U') IS NOT NULL
    DROP TABLE SupplierInvoiceLines_Backup;

SELECT *
INTO SupplierInvoiceLines_Backup
FROM SupplierInvoiceLines;

SET @rowCount = @@ROWCOUNT;
PRINT 'Backed up ' + CAST(@rowCount AS NVARCHAR(10)) + ' invoice line records to SupplierInvoiceLines_Backup'

PRINT ''
PRINT 'Backup completed successfully!'
PRINT 'You can now run DROP_AND_RECREATE_SUPPLIER_INVOICES.sql'
