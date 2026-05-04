-- Debug Order Book dropdown query
-- Test exact query from ReOrderBookManagerForm.vb

-- Step 1: Check Products table for Goolab Jumbu
SELECT 'Products Table' AS Source, ProductID, ProductName, ProductCode, SKU
FROM Products
WHERE ProductName LIKE '%Goolab%';

-- Step 2: Check Demo_Retail_Product for Goolab Jumbu
SELECT 'Demo_Retail_Product Table' AS Source, ProductID, Name, BranchID, ProductType, Category, IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%Goolab%';

-- Step 3: Check Demo_ProductRecipe_Master
SELECT 'Demo_ProductRecipe_Master Table' AS Source, ProductID, BatchQty, TotalCost, IsActive
FROM Demo_ProductRecipe_Master
WHERE ProductID IN (SELECT ProductID FROM Products WHERE ProductName LIKE '%Goolab%');

-- Step 4: Test the JOIN between Demo_Retail_Product and Products
SELECT 
    'JOIN Test' AS Source,
    p.ProductID AS Demo_Retail_ProductID,
    p.Name AS Demo_Retail_Name,
    p.BranchID,
    prod.ProductID AS Products_ProductID,
    prod.ProductName AS Products_Name
FROM Demo_Retail_Product p
INNER JOIN Products prod ON prod.ProductName = p.Name
WHERE p.Name LIKE '%Goolab%';

-- Step 5: Test the full query (HEAD OFFICE version - all branches)
SELECT MIN(p.ProductID) AS ProductID, p.Name AS ProductName, MIN(ISNULL(p.Code, p.SKU)) AS SKU
FROM Demo_Retail_Product p
INNER JOIN Products prod ON prod.ProductName = p.Name
WHERE p.IsActive = 1
  AND p.ProductType = 'Internal'
  AND p.Category NOT LIKE '%sub%recipe%'
  AND p.Category NOT LIKE '%subrecipe%'
  AND EXISTS (SELECT 1 FROM Demo_ProductRecipe_Master pr WHERE pr.ProductID = prod.ProductID AND pr.IsActive = 1)
GROUP BY p.Name
ORDER BY p.Name;

-- Step 6: Test specific branch version (Branch 1)
SELECT p.ProductID, p.Name AS ProductName, ISNULL(p.Code, p.SKU) AS SKU
FROM Demo_Retail_Product p
INNER JOIN Products prod ON prod.ProductName = p.Name
WHERE p.IsActive = 1
  AND p.BranchID = 1
  AND p.ProductType = 'Internal'
  AND p.Category NOT LIKE '%sub%recipe%'
  AND p.Category NOT LIKE '%subrecipe%'
  AND EXISTS (SELECT 1 FROM Demo_ProductRecipe_Master pr WHERE pr.ProductID = prod.ProductID AND pr.IsActive = 1)
ORDER BY p.Name;

-- Step 7: Show ALL internal products (without recipe filter) to see what's available
SELECT DISTINCT p.Name AS ProductName, p.ProductType, p.Category, p.IsActive
FROM Demo_Retail_Product p
WHERE p.ProductType = 'Internal'
  AND p.Category NOT LIKE '%sub%recipe%'
  AND p.Category NOT LIKE '%subrecipe%'
  AND p.IsActive = 1
ORDER BY p.Name;
