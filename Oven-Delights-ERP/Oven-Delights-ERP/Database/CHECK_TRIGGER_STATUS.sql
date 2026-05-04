-- Check if trigger is enabled or disabled
SELECT 
    name AS TriggerName,
    OBJECT_NAME(parent_id) AS TableName,
    is_disabled AS IsDisabled,
    CASE WHEN is_disabled = 1 THEN 'DISABLED' ELSE 'ENABLED' END AS Status
FROM sys.triggers
WHERE OBJECT_NAME(parent_id) = 'SupplierInvoices';
