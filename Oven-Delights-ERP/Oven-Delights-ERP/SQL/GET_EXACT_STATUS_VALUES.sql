-- Get the EXACT Status constraint definition
SELECT 
    cc.name AS ConstraintName,
    cc.definition AS ConstraintDefinition
FROM sys.check_constraints cc
INNER JOIN sys.tables t ON cc.parent_object_id = t.object_id
WHERE t.name = 'InternalOrderHeader';

-- Get all existing Status values that are currently in use
SELECT DISTINCT Status 
FROM InternalOrderHeader
ORDER BY Status;
