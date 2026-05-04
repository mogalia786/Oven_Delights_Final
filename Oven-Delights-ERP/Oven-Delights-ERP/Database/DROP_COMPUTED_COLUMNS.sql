-- Drop computed columns from SupplierInvoices
-- Only drop AmountOutstanding since AmountDue doesn't exist

PRINT 'Dropping computed column AmountOutstanding...'

-- Drop the computed column
ALTER TABLE SupplierInvoices DROP COLUMN AmountOutstanding;
PRINT 'Dropped AmountOutstanding'

-- Add it back as a regular column
ALTER TABLE SupplierInvoices ADD AmountOutstanding DECIMAL(18,4) NULL;
PRINT 'Added AmountOutstanding as regular column'

-- Update existing records
UPDATE SupplierInvoices
SET AmountOutstanding = TotalAmount - ISNULL(AmountPaid, 0);
PRINT 'Updated AmountOutstanding for existing records'

PRINT ''
PRINT 'Fix completed successfully!'
