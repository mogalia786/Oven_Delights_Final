-- Find all duplicate products (same Name, different ProductIDs for same branch)

-- 1. Products with multiple ProductIDs for same Name and BranchID
SELECT Name, BranchID, COUNT(*) AS DuplicateCount, 
       STRING_AGG(CAST(ProductID AS VARCHAR), ', ') AS ProductIDs,
       STRING_AGG(CAST(CurrentStock AS VARCHAR), ', ') AS StockLevels
FROM Demo_Retail_Product
WHERE BranchID IS NOT NULL
GROUP BY Name, BranchID
HAVING COUNT(*) > 1
ORDER BY Name, BranchID

-- 2. Products with NULL BranchID
SELECT COUNT(*) AS NullBranchIDCount
FROM Demo_Retail_Product
WHERE BranchID IS NULL

-- 3. Show all NULL BranchID products
SELECT ProductID, Name, Category, BranchID, CurrentStock
FROM Demo_Retail_Product
WHERE BranchID IS NULL
ORDER BY Name
