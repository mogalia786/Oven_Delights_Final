-- Check the ItemType of the product with BOM
SELECT 
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.ItemType,
    p.IsActive
FROM Products p
WHERE p.ProductID = 4842

-- Check all ItemType values in Products table
SELECT DISTINCT ItemType, COUNT(*) AS Count
FROM Products
GROUP BY ItemType
ORDER BY Count DESC
