-- List ALL triggers in the database
SELECT 
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName,
    is_disabled AS IsDisabled,
    is_instead_of_trigger AS IsInsteadOf,
    OBJECT_DEFINITION(object_id) AS Definition
FROM sys.triggers
WHERE parent_id = OBJECT_ID('SupplierInvoices')
ORDER BY name;
