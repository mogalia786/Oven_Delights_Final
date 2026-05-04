-- Check ALL FlourCake entries across all branches
SELECT 
    ProductID,
    Name,
    BranchID,
    IsVatable,
    ProductType,
    Category,
    IsActive
FROM Demo_Retail_Product
WHERE Name LIKE '%FlourCake%' OR Name LIKE '%Flour%Cake%'
ORDER BY Name, BranchID

-- Check if there are any with IsVatable = 1
SELECT 
    ProductID,
    Name,
    BranchID,
    IsVatable
FROM Demo_Retail_Product
WHERE (Name LIKE '%FlourCake%' OR Name LIKE '%Flour%Cake%')
  AND IsVatable = 1
