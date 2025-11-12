-- Find all POS-related tables, views, and stored procedures

-- 1. Find all tables with POS in the name
SELECT 'TABLES' AS ObjectType, TABLE_NAME AS Name
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
  AND (TABLE_NAME LIKE '%POS%' OR TABLE_NAME LIKE '%Cache%' OR TABLE_NAME LIKE '%Product%')
ORDER BY TABLE_NAME;

-- 2. Find all views with POS or Product in the name
SELECT 'VIEWS' AS ObjectType, TABLE_NAME AS Name
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_NAME LIKE '%POS%' OR TABLE_NAME LIKE '%Product%' OR TABLE_NAME LIKE '%Cache%'
ORDER BY TABLE_NAME;

-- 3. Find stored procedures that might initialize POS data
SELECT 'STORED PROCEDURES' AS ObjectType, ROUTINE_NAME AS Name
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_TYPE = 'PROCEDURE'
  AND (ROUTINE_NAME LIKE '%POS%' OR ROUTINE_NAME LIKE '%Initialize%' OR ROUTINE_NAME LIKE '%Cache%')
ORDER BY ROUTINE_NAME;

-- 4. Check if there's a specific POS product cache table
IF OBJECT_ID('dbo.POS_ProductCache', 'U') IS NOT NULL
BEGIN
    SELECT 'POS_ProductCache table EXISTS!' AS Info;
    SELECT TOP 10 * FROM dbo.POS_ProductCache WHERE Name LIKE '%Bar One%';
END

IF OBJECT_ID('dbo.POSProducts', 'U') IS NOT NULL
BEGIN
    SELECT 'POSProducts table EXISTS!' AS Info;
    SELECT TOP 10 * FROM dbo.POSProducts WHERE Name LIKE '%Bar One%';
END

-- 5. Look for any view that might be used by POS
SELECT 
    v.TABLE_NAME,
    SUBSTRING(v.VIEW_DEFINITION, 1, 500) AS ViewDefinition_Preview
FROM INFORMATION_SCHEMA.VIEWS v
WHERE v.TABLE_NAME LIKE '%Product%'
   OR v.VIEW_DEFINITION LIKE '%CurrentStock%'
   OR v.VIEW_DEFINITION LIKE '%Demo_Retail_Product%'
ORDER BY v.TABLE_NAME;
