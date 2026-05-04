-- Check if Demo_Retail_Stock table exists
SELECT 'Demo_Retail_Stock' AS TableName, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Stock'
ORDER BY ORDINAL_POSITION;

-- Check recent entries
IF OBJECT_ID('dbo.Demo_Retail_Stock', 'U') IS NOT NULL
    SELECT TOP 10 * FROM dbo.Demo_Retail_Stock ORDER BY 1 DESC;
ELSE
    PRINT 'Demo_Retail_Stock table does not exist';

-- List all stock-related tables
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME LIKE '%Stock%'
ORDER BY TABLE_NAME;
