-- Check what ProductID is stored in Demo_ProductRecipe_Master for Goolab Jumbu
SELECT 
    'Demo_ProductRecipe_Master' AS TableName,
    pr.*
FROM Demo_ProductRecipe_Master pr
WHERE pr.ProductID IN (SELECT ProductID FROM Products WHERE ProductName LIKE '%Goolab%');

-- Check Products table for Goolab Jumbu
SELECT 
    'Products' AS TableName,
    ProductID, ProductName, ProductCode, SKU
FROM Products
WHERE ProductName LIKE '%Goolab%';

-- Check Demo_Retail_Product table for Goolab Jumbu
SELECT 
    'Demo_Retail_Product' AS TableName,
    ProductID, Name, BranchID, SKU, ProductType, Category
FROM Demo_Retail_Product
WHERE Name LIKE '%Goolab%'
ORDER BY BranchID;

-- Check if there's a mismatch between Products.ProductID and Demo_Retail_Product.ProductID
SELECT 
    'ID Comparison' AS Info,
    p.ProductID AS Products_ProductID,
    drp.ProductID AS Demo_Retail_Product_ProductID,
    p.ProductName,
    drp.BranchID
FROM Products p
LEFT JOIN Demo_Retail_Product drp ON p.ProductName = drp.Name
WHERE p.ProductName LIKE '%Goolab%'
ORDER BY drp.BranchID;
