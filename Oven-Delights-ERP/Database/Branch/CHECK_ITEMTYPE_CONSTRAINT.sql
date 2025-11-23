-- Check the ItemType constraint and current values

PRINT 'CHECKING ITEMTYPE CONSTRAINT:';
PRINT '';

-- Get constraint definition
SELECT 
    con.name AS ConstraintName,
    con.definition AS ConstraintDefinition
FROM sys.check_constraints con
INNER JOIN sys.tables t ON con.parent_object_id = t.object_id
WHERE t.name = 'Products'
    AND con.parent_column_id = (
        SELECT column_id 
        FROM sys.columns 
        WHERE object_id = OBJECT_ID('Products') 
        AND name = 'ItemType'
    );

PRINT '';
PRINT 'CURRENT ITEMTYPE VALUES IN PRODUCTS TABLE:';
SELECT DISTINCT 
    ItemType,
    COUNT(*) AS Count
FROM Products
GROUP BY ItemType
ORDER BY ItemType;

PRINT '';
PRINT 'PRODUCTS TABLE COLUMNS:';
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length,
    c.is_nullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Products')
ORDER BY c.column_id;
