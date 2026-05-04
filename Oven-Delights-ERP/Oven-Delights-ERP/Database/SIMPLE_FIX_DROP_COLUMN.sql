-- Simple fix: Just drop the AmountOutstanding column
-- It can be calculated as (TotalAmount - AmountPaid) when needed
-- Keep AmountPaid for payment tracking

SET QUOTED_IDENTIFIER ON;
GO

-- Drop AmountOutstanding column if it exists
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('SupplierInvoices') AND name = 'AmountOutstanding')
BEGIN
    ALTER TABLE SupplierInvoices DROP COLUMN AmountOutstanding;
    PRINT 'Dropped AmountOutstanding column - can be calculated as (TotalAmount - AmountPaid) when needed';
END
ELSE
BEGIN
    PRINT 'AmountOutstanding column does not exist';
END

PRINT 'Fix completed - AmountOutstanding removed, AmountPaid retained for payment tracking';
