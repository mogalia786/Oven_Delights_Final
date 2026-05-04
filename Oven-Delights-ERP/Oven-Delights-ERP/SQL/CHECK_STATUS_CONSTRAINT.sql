-- Check the Status constraint on InternalOrderHeader
SELECT 
    cc.name AS ConstraintName,
    cc.definition AS ConstraintDefinition
FROM sys.check_constraints cc
INNER JOIN sys.tables t ON cc.parent_object_id = t.object_id
WHERE t.name = 'InternalOrderHeader'
AND cc.definition LIKE '%Status%';

-- Check default value for Status
SELECT 
    c.name AS ColumnName,
    dc.definition AS DefaultValue
FROM sys.columns c
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
WHERE c.object_id = OBJECT_ID('InternalOrderHeader')
AND c.name = 'Status';

-- Check existing Status values
SELECT DISTINCT Status 
FROM InternalOrderHeader
WHERE Status IS NOT NULL;
