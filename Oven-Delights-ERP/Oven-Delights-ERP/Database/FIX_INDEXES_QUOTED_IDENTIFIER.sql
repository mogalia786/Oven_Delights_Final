-- Drop and recreate all indexes on SupplierInvoices with QUOTED_IDENTIFIER ON

SET QUOTED_IDENTIFIER ON;
GO

PRINT 'Dropping indexes on SupplierInvoices...'

-- Drop unique index
DROP INDEX IF EXISTS UQ_SupplierInvoices_Number ON SupplierInvoices;
PRINT 'Dropped UQ_SupplierInvoices_Number'

-- Drop other indexes
DROP INDEX IF EXISTS IX_SupplierInvoices_Supplier ON SupplierInvoices;
DROP INDEX IF EXISTS IX_SupplierInvoices_Branch ON SupplierInvoices;
DROP INDEX IF EXISTS IX_SupplierInvoices_Status ON SupplierInvoices;
DROP INDEX IF EXISTS IX_SupplierInvoices_Date ON SupplierInvoices;
PRINT 'Dropped other indexes'

PRINT ''
PRINT 'Recreating indexes with QUOTED_IDENTIFIER ON...'

-- Recreate unique index
CREATE UNIQUE INDEX UQ_SupplierInvoices_Number ON SupplierInvoices(InvoiceNumber, SupplierID);
PRINT 'Created UQ_SupplierInvoices_Number'

-- Recreate other indexes
CREATE INDEX IX_SupplierInvoices_Supplier ON SupplierInvoices(SupplierID);
CREATE INDEX IX_SupplierInvoices_Branch ON SupplierInvoices(BranchID);
CREATE INDEX IX_SupplierInvoices_Status ON SupplierInvoices(Status);
CREATE INDEX IX_SupplierInvoices_Date ON SupplierInvoices(InvoiceDate);
PRINT 'Created other indexes'

PRINT ''
PRINT 'Fix completed successfully!'
PRINT 'All indexes recreated with QUOTED_IDENTIFIER ON'
