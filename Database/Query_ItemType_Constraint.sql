-- Check the ItemType constraint on Products table
SELECT 
    cc.name AS ConstraintName,
    cc.definition AS ConstraintDefinition
FROM sys.check_constraints cc
INNER JOIN sys.tables t ON cc.parent_object_id = t.object_id
WHERE t.name = 'Products' 
AND cc.name LIKE '%ItemType%';

-- Check current ItemType values in Products table
SELECT DISTINCT ItemType, COUNT(*) as Count
FROM Products
GROUP BY ItemType
ORDER BY ItemType;
