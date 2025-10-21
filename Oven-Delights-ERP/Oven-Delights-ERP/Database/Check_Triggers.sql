-- Check for triggers that might be causing the BranchID error

SELECT 
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName,
    is_disabled AS IsDisabled
FROM sys.triggers 
WHERE is_disabled = 0 
  AND OBJECT_NAME(parent_id) IN (
    'JournalHeaders', 
    'JournalDetails', 
    'Manufacturing_Inventory', 
    'Manufacturing_InventoryMovements', 
    'RawMaterials',
    'ChartOfAccounts'
  )
ORDER BY TableName, TriggerName;

-- Also check for triggers on any table with 'Inventory' in the name
SELECT 
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName
FROM sys.triggers 
WHERE is_disabled = 0 
  AND OBJECT_NAME(parent_id) LIKE '%Inventory%'
ORDER BY TableName;
