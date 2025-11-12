-- Check the actual column names in Demo_Retail_Product table
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
ORDER BY ORDINAL_POSITION;

-- Check if there's a column for product type/classification
SELECT TOP 5 
    ProductID, 
    Name, 
    SKU,
    CategoryID,
    IsActive
FROM Demo_Retail_Product;
