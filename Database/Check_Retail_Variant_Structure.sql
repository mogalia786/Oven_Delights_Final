-- Check Retail_Variant structure to verify column names

SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Retail_Variant')
ORDER BY c.column_id;

PRINT '';
PRINT '--- Check if ProductID column exists in Retail_Variant ---';

IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('dbo.Retail_Variant') AND name = 'ProductID')
    PRINT 'ProductID column EXISTS in Retail_Variant'
ELSE
    PRINT 'ProductID column DOES NOT EXIST in Retail_Variant - THIS IS THE PROBLEM!';

PRINT '';
PRINT '--- Sample data from Retail_Variant ---';
SELECT TOP 10 * FROM dbo.Retail_Variant;
