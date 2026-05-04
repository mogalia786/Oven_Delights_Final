-- =============================================
-- Fix SupplierInvoices table structure
-- Keep AmountPaid and AmountOutstanding but ensure they work correctly
-- =============================================

PRINT 'Fixing SupplierInvoices table structure...'

-- First, drop the computed column if it exists
IF EXISTS (SELECT 1 FROM sys.columns WHERE name = 'AmountOutstanding' AND object_id = OBJECT_ID('SupplierInvoices') AND is_computed = 1)
BEGIN
    ALTER TABLE SupplierInvoices DROP COLUMN AmountOutstanding;
    PRINT 'Dropped computed column AmountOutstanding'
END

-- Ensure AmountPaid exists as a regular column with DEFAULT 0
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'AmountPaid' AND object_id = OBJECT_ID('SupplierInvoices'))
BEGIN
    ALTER TABLE SupplierInvoices ADD AmountPaid DECIMAL(18,4) NOT NULL DEFAULT(0);
    PRINT 'Added AmountPaid column'
END
ELSE
BEGIN
    PRINT 'AmountPaid column already exists'
END

-- Add AmountOutstanding as a regular column (not computed)
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE name = 'AmountOutstanding' AND object_id = OBJECT_ID('SupplierInvoices'))
BEGIN
    ALTER TABLE SupplierInvoices ADD AmountOutstanding DECIMAL(18,4) NULL;
    PRINT 'Added AmountOutstanding as regular column'
END
ELSE
BEGIN
    PRINT 'AmountOutstanding column already exists'
END

-- Update existing records to set AmountOutstanding = TotalAmount - AmountPaid
UPDATE SupplierInvoices
SET AmountOutstanding = TotalAmount - ISNULL(AmountPaid, 0)
WHERE AmountOutstanding IS NULL OR AmountOutstanding <> (TotalAmount - ISNULL(AmountPaid, 0));

PRINT 'Updated AmountOutstanding for existing records'

-- Create a trigger to automatically calculate AmountOutstanding on INSERT/UPDATE
IF OBJECT_ID('trg_SupplierInvoices_CalculateOutstanding', 'TR') IS NOT NULL
    DROP TRIGGER trg_SupplierInvoices_CalculateOutstanding
GO

CREATE TRIGGER trg_SupplierInvoices_CalculateOutstanding
ON SupplierInvoices
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE si
    SET AmountOutstanding = si.TotalAmount - ISNULL(si.AmountPaid, 0)
    FROM SupplierInvoices si
    INNER JOIN inserted i ON si.InvoiceID = i.InvoiceID;
END
GO

PRINT 'Created trigger to auto-calculate AmountOutstanding'
PRINT ''
PRINT 'Fix completed successfully!'
PRINT 'AmountPaid and AmountOutstanding are now regular columns with automatic calculation'
