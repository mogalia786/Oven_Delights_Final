-- Check GeneralLedger table for computed columns
SELECT 
    c.name AS ColumnName,
    c.is_computed AS IsComputed,
    cc.definition AS ComputedDefinition,
    cc.is_persisted AS IsPersisted,
    t.name AS DataType
FROM sys.columns c
LEFT JOIN sys.computed_columns cc ON c.object_id = cc.object_id AND c.column_id = cc.column_id
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('GeneralLedger')
ORDER BY c.column_id;

-- Check indexes on GeneralLedger
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('GeneralLedger')
    AND i.name IS NOT NULL;
