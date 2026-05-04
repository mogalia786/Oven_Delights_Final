-- Check for triggers on Suppliers table
SELECT 
    OBJECT_NAME(parent_id) AS TableName,
    name AS TriggerName,
    OBJECT_DEFINITION(object_id) AS TriggerDefinition,
    is_disabled AS IsDisabled
FROM sys.triggers
WHERE parent_id = OBJECT_ID('Suppliers');

-- Check for any stored procedures that reference Suppliers
SELECT 
    OBJECT_NAME(object_id) AS ProcedureName,
    OBJECT_DEFINITION(object_id) AS Definition
FROM sys.objects
WHERE type = 'P'
    AND OBJECT_DEFINITION(object_id) LIKE '%INSERT INTO Suppliers%'
ORDER BY name;

-- Check Suppliers table indexes
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.has_filter AS HasFilter,
    i.filter_definition AS FilterDefinition
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('Suppliers')
    AND i.name IS NOT NULL
ORDER BY i.name;
