-- Diagnostic: Why Order Book Schedule Manager only shows 2 products

-- Step 1: Check all products with recipes in Demo_ProductRecipe_Master
PRINT '=== STEP 1: Products with recipes in Demo_ProductRecipe_Master ==='
SELECT ProductID, Method, BatchQty, TotalCost, IsActive, CreatedDate
FROM Demo_ProductRecipe_Master
WHERE IsActive = 1
ORDER BY CreatedDate DESC;

-- Step 2: Check Recipe_Created flag in Demo_Retail_Product
PRINT ''
PRINT '=== STEP 2: Products with Recipe_Created = 1 in Demo_Retail_Product ==='
SELECT ProductID, Name, BranchID, Recipe_Created, ProductType, Category, IsActive
FROM Demo_Retail_Product
WHERE Recipe_Created = 1
ORDER BY Name, BranchID;

-- Step 3: Check products WITHOUT Recipe_Created flag but have recipes
PRINT ''
PRINT '=== STEP 3: Products in Demo_ProductRecipe_Master but Recipe_Created is NULL/0 ==='
SELECT DISTINCT p.ProductID, p.Name, p.BranchID, p.Recipe_Created, p.ProductType, p.Category
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE rm.IsActive = 1
  AND (p.Recipe_Created IS NULL OR p.Recipe_Created = 0)
ORDER BY p.Name, p.BranchID;

-- Step 4: Simulate the Order Book query for your current branch
PRINT ''
PRINT '=== STEP 4: What Order Book query returns (assuming BranchID = 6) ==='
DECLARE @BranchID INT = 6; -- Change this to your logged-in BranchID

SELECT p.ProductID, p.Name AS ProductName, ISNULL(p.Code, p.SKU) AS SKU, p.Recipe_Created, p.BranchID
FROM Demo_ProductRecipe_Master rm
INNER JOIN Demo_Retail_Product p ON p.ProductID = rm.ProductID
WHERE rm.IsActive = 1
  AND p.IsActive = 1
  AND p.Recipe_Created = 1
  AND p.BranchID = @BranchID
  AND p.ProductType = 'Internal'
  AND p.Category NOT LIKE '%sub%recipe%'
  AND p.Category NOT LIKE '%subrecipe%'
ORDER BY p.Name;

-- Step 5: Check if Recipe_Created column exists and has correct data type
PRINT ''
PRINT '=== STEP 5: Recipe_Created column info ==='
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Demo_Retail_Product'
  AND COLUMN_NAME = 'Recipe_Created';
