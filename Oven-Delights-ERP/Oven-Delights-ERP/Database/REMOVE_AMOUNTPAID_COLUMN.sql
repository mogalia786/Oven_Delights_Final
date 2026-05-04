-- =============================================
-- Remove AmountPaid and AmountOutstanding columns from SupplierInvoices
-- These columns were added later and are causing issues
-- =============================================

PRINT 'Removing AmountPaid and AmountOutstanding columns from SupplierInvoices...'

-- Drop computed column first
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'AmountOutstanding' AND object_id = OBJECT_ID('SupplierInvoices'))
BEGIN
    ALTER TABLE SupplierInvoices DROP COLUMN AmountOutstanding;
    PRINT 'Dropped AmountOutstanding column'
END

-- Drop AmountPaid column
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'AmountPaid' AND object_id = OBJECT_ID('SupplierInvoices'))
BEGIN
    ALTER TABLE SupplierInvoices DROP COLUMN AmountPaid;
    PRINT 'Dropped AmountPaid column'
END

PRINT ''
PRINT 'Columns removed successfully!'
PRINT 'SupplierInvoices table is back to original structure'
