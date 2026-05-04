-- Verify SupplierInvoices table structure
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.is_computed AS IsComputed,
    cc.definition AS ComputedDefinition
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
LEFT JOIN sys.computed_columns cc ON c.object_id = cc.object_id AND c.column_id = cc.column_id
WHERE c.object_id = OBJECT_ID('SupplierInvoices')
ORDER BY c.column_id;
