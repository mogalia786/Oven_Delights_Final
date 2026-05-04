-- Add Reference and Notes columns to SupplierInvoices table
-- These columns are needed for the Supplier History form

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'SupplierInvoices' AND COLUMN_NAME = 'Reference')
BEGIN
    ALTER TABLE SupplierInvoices
    ADD Reference NVARCHAR(200) NULL
    
    PRINT 'Added Reference column to SupplierInvoices'
END
ELSE
BEGIN
    PRINT 'Reference column already exists in SupplierInvoices'
END
GO

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'SupplierInvoices' AND COLUMN_NAME = 'Notes')
BEGIN
    ALTER TABLE SupplierInvoices
    ADD Notes NVARCHAR(500) NULL
    
    PRINT 'Added Notes column to SupplierInvoices'
END
ELSE
BEGIN
    PRINT 'Notes column already exists in SupplierInvoices'
END
GO

PRINT 'SupplierInvoices table updated successfully'
