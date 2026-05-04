-- Find all database objects that reference AmountOutstanding
SELECT 
    OBJECT_NAME(object_id) AS ObjectName,
    type_desc AS ObjectType,
    OBJECT_DEFINITION(object_id) AS Definition
FROM sys.objects
WHERE OBJECT_DEFINITION(object_id) LIKE '%AmountOutstanding%'
ORDER BY type_desc, ObjectName;

-- Check for views
SELECT 
    v.name AS ViewName,
    OBJECT_DEFINITION(v.object_id) AS ViewDefinition
FROM sys.views v
WHERE OBJECT_DEFINITION(v.object_id) LIKE '%AmountOutstanding%';

-- Check for constraints
SELECT 
    OBJECT_NAME(c.parent_object_id) AS TableName,
    c.name AS ConstraintName,
    c.type_desc AS ConstraintType,
    c.definition AS ConstraintDefinition
FROM sys.check_constraints c
WHERE c.definition LIKE '%AmountOutstanding%';
