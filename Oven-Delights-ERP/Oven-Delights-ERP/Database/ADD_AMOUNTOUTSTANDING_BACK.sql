-- Add AmountOutstanding back as a regular column (not computed)
SET QUOTED_IDENTIFIER ON;
GO

-- Add the column as a regular DECIMAL column with default value
ALTER TABLE SupplierInvoices 
ADD AmountOutstanding DECIMAL(18,4) NULL;

PRINT 'Added AmountOutstanding as regular column';

-- Update existing records to calculate AmountOutstanding
UPDATE SupplierInvoices
SET AmountOutstanding = TotalAmount - ISNULL(AmountPaid, 0);

PRINT 'Updated AmountOutstanding for existing records';
PRINT 'Fix completed - AmountOutstanding is now a regular column, not computed';
