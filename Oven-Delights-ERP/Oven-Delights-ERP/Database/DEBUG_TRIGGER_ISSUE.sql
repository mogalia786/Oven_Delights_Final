-- Step 1: Check if trigger exists and is enabled
SELECT 
    t.name AS TriggerName,
    t.is_disabled AS IsDisabled,
    OBJECT_NAME(t.parent_id) AS TableName,
    t.create_date AS CreatedDate,
    t.modify_date AS ModifiedDate
FROM sys.triggers t
WHERE t.name = 'trg_AutoUpdateRecipeCosts_OnProductPriceChange';

-- Step 2: Get the trigger definition to see what it's doing
SELECT OBJECT_DEFINITION(OBJECT_ID('trg_AutoUpdateRecipeCosts_OnProductPriceChange')) AS TriggerDefinition;

-- Step 3: Check actual column names in Demo_Retail_Product
SELECT TOP 1 * FROM Demo_Retail_Product;

-- Get column list for Demo_Retail_Product
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;

-- Step 4: Check actual column names in Demo_SubRecipe_Master
SELECT TOP 1 * FROM Demo_SubRecipe_Master;

-- Get column list for Demo_SubRecipe_Master
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_SubRecipe_Master'
ORDER BY ORDINAL_POSITION;

-- Step 5: Check if TotalCost is a computed column
SELECT 
    c.name AS ColumnName,
    c.is_computed AS IsComputed,
    cc.definition AS ComputedDefinition
FROM sys.columns c
LEFT JOIN sys.computed_columns cc ON c.object_id = cc.object_id AND c.column_id = cc.column_id
WHERE c.object_id = OBJECT_ID('Demo_SubRecipe_BOM')
AND c.name = 'TotalCost';

-- Step 6: Check Demo_SubRecipe_BOM columns
SELECT TOP 1 * FROM Demo_SubRecipe_BOM;
