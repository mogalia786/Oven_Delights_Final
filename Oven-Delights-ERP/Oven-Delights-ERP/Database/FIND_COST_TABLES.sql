-- Find all tables that might contain cost information

-- 1. Check Demo_SubRecipe_Master (has TotalCost for sub-recipes)
SELECT 'Demo_SubRecipe_Master' AS TableName, COUNT(*) AS RecordCount
FROM Demo_SubRecipe_Master;

SELECT TOP 5 * FROM Demo_SubRecipe_Master;

-- 2. Check Demo_Product_Recipe_Master (has TotalCost for finished products)
SELECT 'Demo_Product_Recipe_Master' AS TableName, COUNT(*) AS RecordCount
FROM Demo_Product_Recipe_Master;

SELECT TOP 5 * FROM Demo_Product_Recipe_Master;

-- 3. Check Demo_Retail_Product (has AverageCost, LastPaidPrice)
SELECT 'Demo_Retail_Product' AS TableName, COUNT(*) AS RecordCount
FROM Demo_Retail_Product;

SELECT TOP 5 ProductID, Name, BranchID, AverageCost, LastPaidPrice, CurrentStock 
FROM Demo_Retail_Product;

-- 4. Check Demo_Retail_Price (has CostPrice, SellingPrice)
SELECT 'Demo_Retail_Price' AS TableName, COUNT(*) AS RecordCount
FROM Demo_Retail_Price;

SELECT TOP 5 * FROM Demo_Retail_Price;

-- 5. Check if there's a view or other table
SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_NAME LIKE '%Cost%'
   OR TABLE_NAME LIKE '%Price%'
   OR TABLE_NAME LIKE '%Recipe%'
ORDER BY TABLE_NAME;
