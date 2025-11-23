-- Get exact column names for inventory tables

PRINT 'STOCKROOMSTOCK COLUMNS:';
SELECT c.name AS ColumnName, t.name AS DataType
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('StockroomStock')
ORDER BY c.column_id;

PRINT '';
PRINT 'MANUFACTURINGSTOCK COLUMNS:';
SELECT c.name AS ColumnName, t.name AS DataType
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('ManufacturingStock')
ORDER BY c.column_id;

PRINT '';
PRINT 'MANUFACTURING_INVENTORY COLUMNS:';
SELECT c.name AS ColumnName, t.name AS DataType
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Manufacturing_Inventory')
ORDER BY c.column_id;

PRINT '';
PRINT 'RETAILSTOCK COLUMNS:';
SELECT c.name AS ColumnName, t.name AS DataType
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('RetailStock')
ORDER BY c.column_id;

PRINT '';
PRINT 'CHARTOFACCOUNTS COLUMNS:';
SELECT c.name AS ColumnName, t.name AS DataType
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('ChartOfAccounts')
ORDER BY c.column_id;
