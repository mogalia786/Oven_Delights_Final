-- Check actual table schemas

PRINT '1. BRANCHES TABLE:';
SELECT c.name AS ColumnName, t.name AS DataType
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Branches')
ORDER BY c.column_id;

PRINT '';
PRINT '2. STOCKROOM_INVENTORY TABLE:';
IF OBJECT_ID('Stockroom_Inventory', 'U') IS NOT NULL
BEGIN
    SELECT c.name AS ColumnName, t.name AS DataType
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('Stockroom_Inventory')
    ORDER BY c.column_id;
END
ELSE
    PRINT 'Table does not exist';

PRINT '';
PRINT '3. MANUFACTURING_INVENTORY TABLE:';
IF OBJECT_ID('Manufacturing_Inventory', 'U') IS NOT NULL
BEGIN
    SELECT c.name AS ColumnName, t.name AS DataType
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('Manufacturing_Inventory')
    ORDER BY c.column_id;
END
ELSE
    PRINT 'Table does not exist';
