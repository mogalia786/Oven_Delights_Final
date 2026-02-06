-- Check which branch the inventory export is using for Ayesha Centre
-- Run this to verify the branch filter

-- 1. Verify Branch 6 is Ayesha Centre
SELECT BranchID, BranchName, BranchCode, IsActive
FROM Branches
WHERE BranchID = 6 OR BranchName LIKE '%Ayesha%';

-- 2. Show ALL eggs records across all branches
SELECT 
    ProductID,
    Name,
    ProductType,
    Category,
    CurrentStock,
    BranchID,
    b.BranchName,
    IsActive
FROM Demo_Retail_Product drp
LEFT JOIN Branches b ON drp.BranchID = b.BranchID
WHERE Name LIKE '%egg%'
ORDER BY BranchID, ProductID;

-- 3. Show ONLY Ayesha Centre (Branch 6) eggs
SELECT 
    ProductID,
    Name,
    ProductType,
    Category,
    CurrentStock,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%egg%' AND BranchID = 6;

-- DIAGNOSIS:
-- If your inventory export shows 0 stock for eggs at Ayesha Centre, 
-- the export query is likely:
-- 1. Not filtering by BranchID = 6, OR
-- 2. Selecting ProductID 58148 (Branch 4) instead of ProductID 56850 (Branch 6), OR
-- 3. Using DISTINCT on Name which might pick the wrong ProductID
