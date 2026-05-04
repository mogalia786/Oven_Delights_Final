-- Check Flour Brown product details
SELECT 
    ProductID,
    Name,
    SKU,
    Code,
    Category,
    ProductType,
    IsActive,
    IsVatable,
    BranchID
FROM Demo_Retail_Product
WHERE Name LIKE '%Flour%Brown%' OR Name LIKE '%Brown%Flour%'
ORDER BY Name
