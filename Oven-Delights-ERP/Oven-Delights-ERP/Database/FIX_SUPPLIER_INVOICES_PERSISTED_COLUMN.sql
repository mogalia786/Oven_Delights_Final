-- =============================================
-- Fix SupplierInvoices QUOTED_IDENTIFIER Error
-- Remove PERSISTED from computed column AmountOutstanding
-- =============================================

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

PRINT 'Fixing SupplierInvoices PERSISTED computed column issue...'
PRINT ''

-- Drop the unique index first
IF EXISTS (SELECT * FROM sys.indexes WHERE name = 'UQ_SupplierInvoices_Number' AND object_id = OBJECT_ID('SupplierInvoices'))
BEGIN
    DROP INDEX UQ_SupplierInvoices_Number ON SupplierInvoices;
    PRINT 'Dropped unique index UQ_SupplierInvoices_Number'
END

-- Drop the computed column
IF EXISTS (SELECT * FROM sys.columns WHERE name = 'AmountOutstanding' AND object_id = OBJECT_ID('SupplierInvoices'))
BEGIN
    ALTER TABLE SupplierInvoices DROP COLUMN AmountOutstanding;
    PRINT 'Dropped PERSISTED computed column AmountOutstanding'
END

-- Recreate as non-persisted computed column (no QUOTED_IDENTIFIER requirement)
ALTER TABLE SupplierInvoices 
ADD AmountOutstanding AS (TotalAmount - AmountPaid);
PRINT 'Recreated AmountOutstanding as non-persisted computed column'

-- Recreate the unique index
CREATE UNIQUE INDEX UQ_SupplierInvoices_Number ON dbo.SupplierInvoices(InvoiceNumber, SupplierID);
PRINT 'Recreated unique index UQ_SupplierInvoices_Number'

GO

PRINT ''
PRINT 'Fix completed successfully!'
PRINT 'SupplierInvoices table can now accept INSERT statements without QUOTED_IDENTIFIER errors'
PRINT ''
PRINT 'IMPORTANT: AmountOutstanding is now a non-persisted computed column'
PRINT 'This means it is calculated on-the-fly (no performance impact for small tables)'
