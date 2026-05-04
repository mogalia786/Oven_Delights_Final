-- Check if Demo_Retail_Product has BranchID column and duplicate products
-- This is causing POS to show duplicate items

-- Check schema
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
AND COLUMN_NAME IN ('ProductID', 'BranchID', 'Name', 'CategoryID', 'SubCategoryID');

-- Check for duplicate product names across branches
SELECT 
    p.Name,
    COUNT(DISTINCT p.ProductID) AS UniqueProductIDs,
    COUNT(DISTINCT p.BranchID) AS UniqueBranchIDs,
    STRING_AGG(CAST(p.BranchID AS VARCHAR), ', ') AS BranchIDs,
    STRING_AGG(CAST(p.ProductID AS VARCHAR), ', ') AS ProductIDs
FROM Demo_Retail_Product p
WHERE p.IsActive = 1
  AND (p.ProductType = 'External' OR p.ProductType = 'Internal')
  AND p.Category NOT IN ('ingredients', 'sub recipe', 'packaging', 'consumables', 'equipment', 'pest control')
GROUP BY p.Name
HAVING COUNT(DISTINCT p.ProductID) > 1
ORDER BY COUNT(DISTINCT p.ProductID) DESC;

-- Count total duplicates
SELECT 
    'Total Products with Duplicates' AS Metric,
    COUNT(*) AS Count
FROM (
    SELECT p.Name
    FROM Demo_Retail_Product p
    WHERE p.IsActive = 1
      AND (p.ProductType = 'External' OR p.ProductType = 'Internal')
      AND p.Category NOT IN ('ingredients', 'sub recipe', 'packaging', 'consumables', 'equipment', 'pest control')
    GROUP BY p.Name
    HAVING COUNT(DISTINCT p.ProductID) > 1
) duplicates;
