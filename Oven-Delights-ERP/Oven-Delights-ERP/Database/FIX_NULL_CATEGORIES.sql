-- Update existing products with NULL categories to get category names from Categories table
UPDATE p
SET p.Category = c.CategoryName
FROM Demo_Retail_Product p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.Category IS NULL
    AND p.CategoryID IS NOT NULL;

-- Verify the update
SELECT TOP 10
    ProductID,
    Name,
    Category,
    CategoryID,
    ProductType,
    BranchID,
    IsActive
FROM Demo_Retail_Product
WHERE CategoryID IS NOT NULL
ORDER BY CreatedAt DESC;
