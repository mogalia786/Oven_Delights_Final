-- Check demo_Retail_stock structure
SELECT TOP 5 * FROM demo_Retail_stock;

-- Check demo_Retail_product structure  
SELECT TOP 5 * FROM demo_Retail_product;

-- Check demo_Retail_price structure
SELECT TOP 5 * FROM demo_Retail_price;

-- Get column names for demo_Retail_stock
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'demo_Retail_stock';
