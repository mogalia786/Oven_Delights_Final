-- Check for computed columns in SupplierInvoices
SELECT 
    c.name AS ColumnName,
    c.is_computed AS IsComputed,
    cc.definition AS ComputedDefinition,
    cc.is_persisted AS IsPersisted
FROM sys.columns c
LEFT JOIN sys.computed_columns cc ON c.object_id = cc.object_id AND c.column_id = cc.column_id
WHERE c.object_id = OBJECT_ID('SupplierInvoices')
    AND c.is_computed = 1;
