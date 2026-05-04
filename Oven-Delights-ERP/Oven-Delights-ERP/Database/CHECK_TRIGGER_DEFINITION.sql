-- Check what the trigger actually does
SELECT 
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName,
    OBJECT_DEFINITION(object_id) AS TriggerDefinition
FROM sys.triggers
WHERE name = 'trg_AfterUpdateRecipeCosts_OnProductPriceChange';
