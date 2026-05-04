-- Find all stored procedures that INSERT into SupplierLedger
SELECT 
    OBJECT_NAME(object_id) AS ProcedureName,
    OBJECT_DEFINITION(object_id) AS Definition
FROM sys.objects
WHERE type = 'P'
    AND OBJECT_DEFINITION(object_id) LIKE '%INSERT INTO SupplierLedger%'
ORDER BY name;

-- Check if there are any triggers on related tables that insert into SupplierLedger
SELECT 
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName,
    OBJECT_DEFINITION(object_id) AS TriggerDefinition
FROM sys.triggers
WHERE OBJECT_DEFINITION(object_id) LIKE '%INSERT INTO SupplierLedger%';

-- Check the exact column definition for IsReversed
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierLedger'
    AND COLUMN_NAME = 'IsReversed';
