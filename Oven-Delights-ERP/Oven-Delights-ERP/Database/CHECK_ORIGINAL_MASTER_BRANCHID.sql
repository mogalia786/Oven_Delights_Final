-- Check what the original master BranchID should be
-- by looking at which BranchID has the most complete product data

-- Check which BranchID has ingredients, sub-recipes, and products
SELECT 
    BranchID,
    COUNT(DISTINCT CASE WHEN Category LIKE '%ingredient%' THEN ProductID END) AS IngredientCount,
    COUNT(DISTINCT CASE WHEN Category LIKE '%sub%recipe%' THEN ProductID END) AS SubRecipeCount,
    COUNT(DISTINCT CASE WHEN ProductType = 'Internal' THEN ProductID END) AS InternalProductCount,
    COUNT(DISTINCT CASE WHEN ProductType = 'External' THEN ProductID END) AS ExternalProductCount,
    COUNT(DISTINCT ProductID) AS TotalProducts
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY BranchID
ORDER BY IngredientCount DESC, SubRecipeCount DESC;

-- Check Demo_Retail_Price to see which BranchID has the most price records
SELECT 
    BranchID,
    COUNT(DISTINCT ProductID) AS ProductsWithPrices,
    COUNT(*) AS TotalPriceRecords
FROM Demo_Retail_Price
GROUP BY BranchID
ORDER BY ProductsWithPrices DESC;

-- Check if BranchID 1 has any products at all
SELECT 
    'BranchID 1 Product Count' AS Metric,
    COUNT(*) AS Count
FROM Demo_Retail_Product
WHERE BranchID = 1 AND IsActive = 1;

-- Check if BranchID 6 has any products
SELECT 
    'BranchID 6 Product Count' AS Metric,
    COUNT(*) AS Count
FROM Demo_Retail_Product
WHERE BranchID = 6 AND IsActive = 1;
