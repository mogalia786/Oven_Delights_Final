-- Check Demo_Retail_Stock table

-- 1. Check if table exists
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_Retail_Stock')
BEGIN
    PRINT 'Demo_Retail_Stock table EXISTS'
    
    -- Show structure
    SELECT c.name AS ColumnName, t.name AS DataType
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('Demo_Retail_Stock')
    ORDER BY c.column_id
    
    -- Show sample data
    SELECT TOP 10 * FROM Demo_Retail_Stock
    
    -- Check Bar One Spread
    SELECT ds.*, p.Name
    FROM Demo_Retail_Stock ds
    INNER JOIN Demo_Retail_Product p ON ds.ProductID = p.ProductID
    WHERE p.Name LIKE '%Bar One Spread%'
END
ELSE
BEGIN
    PRINT 'Demo_Retail_Stock table DOES NOT EXIST'
END
