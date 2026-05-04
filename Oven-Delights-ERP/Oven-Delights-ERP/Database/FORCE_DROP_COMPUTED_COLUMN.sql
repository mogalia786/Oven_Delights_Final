-- =============================================
-- Force drop the computed column AmountOutstanding
-- =============================================

PRINT 'Force dropping AmountOutstanding computed column...'

-- Drop any indexes on the computed column first
DECLARE @sql NVARCHAR(MAX)
SELECT @sql = STRING_AGG('DROP INDEX ' + i.name + ' ON SupplierInvoices;', ' ')
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('SupplierInvoices')
  AND c.name = 'AmountOutstanding'
  AND i.is_primary_key = 0;

IF @sql IS NOT NULL
BEGIN
    EXEC sp_executesql @sql;
    PRINT 'Dropped indexes on AmountOutstanding'
END

-- Now drop the computed column
ALTER TABLE SupplierInvoices DROP COLUMN AmountOutstanding;
PRINT 'Dropped AmountOutstanding column'

-- Add it back as a regular column
ALTER TABLE SupplierInvoices ADD AmountOutstanding DECIMAL(18,4) NULL;
PRINT 'Added AmountOutstanding as regular column'

-- Update existing records
UPDATE SupplierInvoices
SET AmountOutstanding = TotalAmount - ISNULL(AmountPaid, 0);
PRINT 'Updated AmountOutstanding for existing records'

-- Create trigger
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
PRINT 'Fix completed!'
