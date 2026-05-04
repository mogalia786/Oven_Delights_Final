-- Get ALL required columns (is_nullable = 0) from Demo_Retail_Product
-- to ensure we're not missing any in the INSERT statement

SELECT 
    c.name AS ColumnName,
    TYPE_NAME(c.user_type_id) AS DataType,
    c.is_nullable,
    c.is_identity
FROM sys.columns c
INNER JOIN sys.tables t ON c.object_id = t.object_id
WHERE t.name = 'Demo_Retail_Product'
    AND c.is_nullable = 0  -- Only required columns
    AND c.is_identity = 0  -- Exclude IDENTITY columns
ORDER BY c.column_id;

-- Compare with what we're inserting:
-- SKU, Name, Category, CategoryID, SubcategoryID, ProductType, BranchID, CurrentStock, IsActive, Description, CreatedAt, UpdatedAt
