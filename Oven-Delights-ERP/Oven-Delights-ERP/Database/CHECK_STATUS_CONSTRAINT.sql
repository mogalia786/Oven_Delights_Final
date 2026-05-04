-- Check the CHK_ReOrderBooks_Status constraint definition
SELECT 
    OBJECT_NAME(parent_object_id) AS TableName,
    name AS ConstraintName,
    definition AS ConstraintDefinition
FROM sys.check_constraints
WHERE name = 'CHK_ReOrderBooks_Status'
