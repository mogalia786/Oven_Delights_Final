-- Check what category values exist for sub recipes in the imported data
SELECT DISTINCT Category, COUNT(*) AS RecordCount
FROM Demo_Retail_Product
WHERE LOWER(Category) LIKE '%recipe%' OR LOWER(Category) LIKE '%sub%'
GROUP BY Category
ORDER BY Category;

-- Check all unique categories
SELECT DISTINCT Category
FROM Demo_Retail_Product
ORDER BY Category;
