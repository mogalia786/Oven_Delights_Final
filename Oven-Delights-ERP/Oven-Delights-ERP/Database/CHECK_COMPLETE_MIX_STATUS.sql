-- Check why Complete Mix - Brown Bread Flour is not showing in PO
SELECT 
    ProductID,
    Name,
    SKU,
    Code,
    Category,
    ProductType,
    IsActive,
    BranchID,
    IsVatable
FROM Demo_Retail_Product
WHERE Name LIKE '%Complete%Mix%' OR Name LIKE '%Brown%Bread%Flour%'
ORDER BY Name

-- Also check what BranchID you're currently using in PO
-- Compare with the BranchID of this product
