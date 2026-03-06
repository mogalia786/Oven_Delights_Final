-- Check for triggers on AP_Invoices table
SELECT 
    t.name AS TriggerName,
    OBJECT_NAME(t.parent_id) AS TableName,
    t.is_disabled,
    t.is_instead_of_trigger,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.triggers t
WHERE OBJECT_NAME(t.parent_id) = 'AP_Invoices';
