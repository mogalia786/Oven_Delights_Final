-- Check why Dhall Roti 6's is not appearing in Create Product Recipe dropdown
SELECT 
    ProductID,
    Name,
    ProductCode,
    SKU,
    Category,
    ProductType,
    IsActive,
    BranchID
FROM Demo_Retail_Product
WHERE Name LIKE '%Dhall Roti%'
ORDER BY BranchID;
