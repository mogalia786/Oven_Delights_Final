-- Check the ACTUAL current stored procedure parameters
SELECT 
    p.name AS ParameterName,
    TYPE_NAME(p.user_type_id) AS DataType,
    p.max_length,
    p.is_nullable,
    p.is_output
FROM sys.parameters p
INNER JOIN sys.objects o ON p.object_id = o.object_id
WHERE o.name = 'sp_SaveProductToAllBranches'
ORDER BY p.parameter_id;
