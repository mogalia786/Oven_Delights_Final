-- Check which BranchID has the master products
SELECT 
    BranchID,
    COUNT(DISTINCT ProductID) AS ProductCount,
    COUNT(DISTINCT CASE WHEN Category LIKE '%ingredient%' THEN ProductID END) AS IngredientCount,
    COUNT(DISTINCT CASE WHEN Category LIKE '%sub%recipe%' THEN ProductID END) AS SubRecipeCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY BranchID
ORDER BY ProductCount DESC;

-- Check Demo_Retail_Price distribution by branch
SELECT 
    BranchID,
    COUNT(*) AS PriceRecordCount,
    COUNT(DISTINCT ProductID) AS UniqueProducts
FROM Demo_Retail_Price
GROUP BY BranchID
ORDER BY BranchID;

-- Check if there are duplicate products in POS (same product in multiple branches)
SELECT 
    p.ProductID,
    p.Name,
    p.BranchID,
    p.Category
FROM Demo_Retail_Product p
WHERE p.Name IN (
    SELECT Name
    FROM Demo_Retail_Product
    WHERE IsActive = 1
    GROUP BY Name
    HAVING COUNT(DISTINCT BranchID) > 1
)
ORDER BY p.Name, p.BranchID;
