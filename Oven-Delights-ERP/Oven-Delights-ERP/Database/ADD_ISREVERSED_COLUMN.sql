-- Add IsReversed column to SupplierLedger table
SET QUOTED_IDENTIFIER ON;
GO

-- Check if column exists
IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('SupplierLedger') AND name = 'IsReversed')
BEGIN
    ALTER TABLE SupplierLedger ADD IsReversed BIT NOT NULL DEFAULT 0;
    PRINT 'Added IsReversed column to SupplierLedger';
END
ELSE
BEGIN
    PRINT 'IsReversed column already exists';
END
