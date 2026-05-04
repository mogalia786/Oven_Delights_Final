-- Check all constraints on SupplierInvoices table
SELECT 
    c.name AS ConstraintName,
    c.type_desc AS ConstraintType,
    col.name AS ColumnName,
    dc.definition AS DefaultValue
FROM sys.objects c
LEFT JOIN sys.default_constraints dc ON c.object_id = dc.object_id
LEFT JOIN sys.columns col ON dc.parent_column_id = col.column_id AND dc.parent_object_id = col.object_id
WHERE c.parent_object_id = OBJECT_ID('SupplierInvoices')
ORDER BY ConstraintType, ColumnName;

-- Also check for any INSTEAD OF triggers
SELECT 
    t.name AS TriggerName,
    te.type_desc AS TriggerEvent,
    t.is_instead_of_trigger AS IsInsteadOf,
    t.is_disabled AS IsDisabled
FROM sys.triggers t
INNER JOIN sys.trigger_events te ON t.object_id = te.object_id
WHERE t.parent_id = OBJECT_ID('SupplierInvoices');
