-- Check the structure of Demo_SubRecipe_Ingredients table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_Ingredients'
ORDER BY ORDINAL_POSITION;

-- Check if TotalCost is a computed column
SELECT 
    c.name AS ColumnName,
    c.is_computed,
    cc.definition AS ComputedDefinition
FROM sys.columns c
LEFT JOIN sys.computed_columns cc ON c.object_id = cc.object_id AND c.column_id = cc.column_id
WHERE c.object_id = OBJECT_ID('Demo_SubRecipe_Ingredients')
ORDER BY c.column_id;
