-- Check ALL triggers on SupplierInvoices table
SELECT 
    t.name AS TriggerName,
    t.is_disabled AS IsDisabled,
    t.is_instead_of_trigger AS IsInsteadOf,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.triggers t
WHERE t.parent_id = OBJECT_ID('SupplierInvoices');
