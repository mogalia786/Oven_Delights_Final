-- Check SupplierInvoices table structure
-- This will show us exactly what columns exist

SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable,
    c.is_computed AS IsComputed,
    dc.definition AS DefaultValue
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('dbo.SupplierInvoices')
ORDER BY c.column_id;

PRINT '';
PRINT 'Above are ALL columns in SupplierInvoices table';
PRINT 'Check if CreatedDate, GRVID, and AmountOutstanding exist';
