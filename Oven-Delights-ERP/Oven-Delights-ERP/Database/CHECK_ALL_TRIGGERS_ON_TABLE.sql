-- Check ALL triggers on SupplierInvoices
SELECT 
    t.name AS TriggerName,
    t.is_disabled AS IsDisabled,
    t.is_instead_of_trigger AS IsInsteadOfTrigger,
    te.type_desc AS EventType,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.triggers t
INNER JOIN sys.trigger_events te ON t.object_id = te.object_id
WHERE t.parent_id = OBJECT_ID('SupplierInvoices')
ORDER BY t.name;
