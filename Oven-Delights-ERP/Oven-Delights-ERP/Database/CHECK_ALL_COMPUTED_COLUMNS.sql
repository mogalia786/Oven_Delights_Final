-- Check for computed columns in GeneralLedger and SupplierLedger
SELECT 
    OBJECT_NAME(c.object_id) AS TableName,
    c.name AS ColumnName,
    c.is_computed AS IsComputed,
    cc.definition AS ComputedDefinition,
    cc.is_persisted AS IsPersisted
FROM sys.columns c
LEFT JOIN sys.computed_columns cc ON c.object_id = cc.object_id AND c.column_id = cc.column_id
WHERE c.object_id IN (OBJECT_ID('GeneralLedger'), OBJECT_ID('SupplierLedger'))
    AND c.is_computed = 1
ORDER BY OBJECT_NAME(c.object_id), c.column_id;
