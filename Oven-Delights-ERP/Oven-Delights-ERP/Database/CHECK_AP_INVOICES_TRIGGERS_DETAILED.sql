-- Check for triggers on AP_Invoices table
SELECT 
    t.name AS TriggerName,
    OBJECT_NAME(t.parent_id) AS TableName,
    t.is_disabled AS IsDisabled,
    t.is_instead_of_trigger AS IsInsteadOf,
    CASE 
        WHEN OBJECTPROPERTY(t.object_id, 'ExecIsInsertTrigger') = 1 THEN 'INSERT'
        WHEN OBJECTPROPERTY(t.object_id, 'ExecIsUpdateTrigger') = 1 THEN 'UPDATE'
        WHEN OBJECTPROPERTY(t.object_id, 'ExecIsDeleteTrigger') = 1 THEN 'DELETE'
        ELSE 'UNKNOWN'
    END AS TriggerType,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
FROM sys.triggers t
WHERE OBJECT_NAME(t.parent_id) = 'AP_Invoices';

-- If triggers exist, this will show their full definition
-- Look for any INSERT statements in the trigger that reference Debit, Credit, Balance, InvoiceID
