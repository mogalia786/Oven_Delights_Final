-- Debug why Cheesy Cake doesn't show in Order Book dropdown

DECLARE @BranchID INT = 6; -- Change to your logged-in BranchID

PRINT '=== Step 1: Check Cheesy Cake in Demo_Retail_Product ==='
SELECT ProductID, Name, BranchID, Recipe_Created, ProductType, Category, IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%Cheesy%'
ORDER BY BranchID;

PRINT ''
PRINT '=== Step 2: Check Cheesy Cake in Demo_ProductRecipe_Master ==='
SELECT rm.ProductID, rm.Method, rm.BatchQty, rm.IsActive, p.Name, p.BranchID
FROM Demo_ProductRecipe_Master rm
LEFT JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE p.Name LIKE '%Cheesy%' OR rm.ProductID IN (SELECT ProductID FROM Demo_Retail_Product WHERE Name LIKE '%Cheesy%')
ORDER BY p.BranchID;

PRINT ''
PRINT '=== Step 3: Test the exact Order Book query for Cheesy Cake ==='
SELECT p.ProductID, p.Name AS ProductName, ISNULL(p.Code, p.SKU) AS SKU, p.BranchID, p.Recipe_Created, rm.ProductID AS RecipeProductID
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE rm.IsActive = 1
  AND p.IsActive = 1
  AND p.Recipe_Created = 1
  AND p.BranchID = @BranchID
  AND p.ProductType = 'Internal'
  AND p.Category NOT LIKE '%sub%recipe%'
  AND p.Category NOT LIKE '%subrecipe%'
  AND p.Name LIKE '%Cheesy%'
ORDER BY p.Name;

PRINT ''
PRINT '=== Step 4: Check if ProductID mismatch exists ==='
-- Check if Demo_ProductRecipe_Master has a different ProductID than Demo_Retail_Product for Cheesy Cake
SELECT 
    'Demo_Retail_Product' AS TableName,
    ProductID, 
    Name, 
    BranchID
FROM Demo_Retail_Product
WHERE Name LIKE '%Cheesy%'
UNION ALL
SELECT 
    'Demo_ProductRecipe_Master' AS TableName,
    rm.ProductID,
    p.Name,
    p.BranchID
FROM Demo_ProductRecipe_Master rm
LEFT JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE p.Name LIKE '%Cheesy%'
ORDER BY TableName, BranchID;
