-- Check Demo_Retail_Product table schema

SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.precision AS Precision,
    c.scale AS Scale,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('Demo_Retail_Product')
ORDER BY c.column_id

-- Check if CurrentStock column exists
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'CurrentStock')
BEGIN
    PRINT 'ERROR: CurrentStock column does NOT exist in Demo_Retail_Product!'
    PRINT 'Adding CurrentStock column...'
    
    ALTER TABLE Demo_Retail_Product ADD CurrentStock DECIMAL(18,3) NULL DEFAULT 0
    
    PRINT 'CurrentStock column added successfully'
END
ELSE
BEGIN
    PRINT 'CurrentStock column exists'
END

-- Show sample data
SELECT TOP 10 ProductID, Name, Category, ProductType, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Category LIKE '%ingredient%'
ORDER BY Name
