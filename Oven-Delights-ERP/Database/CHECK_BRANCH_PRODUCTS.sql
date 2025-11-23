-- Check which branch has which products

-- 1. Show all Bar One Spread records
PRINT '=== All Bar One Spread records ==='
SELECT ProductID, Name, Category, ProductType, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE Name = 'Bar One Spread'
ORDER BY BranchID

-- 2. Show all ingredients for each branch
PRINT ''
PRINT '=== Ingredient count by branch ==='
SELECT BranchID, COUNT(*) AS IngredientCount
FROM Demo_Retail_Product
WHERE Category LIKE '%ingredient%' AND IsActive = 1
GROUP BY BranchID
ORDER BY BranchID

-- 3. Show sample ingredients for Branch 1
PRINT ''
PRINT '=== Sample ingredients for Branch 1 ==='
SELECT TOP 10 ProductID, Name, Category, CurrentStock
FROM Demo_Retail_Product
WHERE BranchID = 1 
  AND Category LIKE '%ingredient%' 
  AND IsActive = 1
ORDER BY Name

-- 4. Show sample ingredients for Branch 6
PRINT ''
PRINT '=== Sample ingredients for Branch 6 ==='
SELECT TOP 10 ProductID, Name, Category, CurrentStock
FROM Demo_Retail_Product
WHERE BranchID = 6 
  AND Category LIKE '%ingredient%' 
  AND IsActive = 1
ORDER BY Name
