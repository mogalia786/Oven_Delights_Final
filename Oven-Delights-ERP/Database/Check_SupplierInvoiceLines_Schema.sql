-- Check actual column names in SupplierInvoiceLines table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierInvoiceLines'
ORDER BY ORDINAL_POSITION
GO

-- If UnitPrice exists instead of UnitCost, rename it back
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoiceLines') AND name = 'UnitPrice')
AND NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.SupplierInvoiceLines') AND name = 'UnitCost')
BEGIN
    EXEC sp_rename 'dbo.SupplierInvoiceLines.UnitPrice', 'UnitCost', 'COLUMN'
    PRINT 'Renamed UnitPrice back to UnitCost'
END
ELSE
BEGIN
    PRINT 'UnitCost column exists - no rename needed'
END
GO
