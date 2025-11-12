-- Check what was actually imported
SELECT 'Demo_Retail_Product' AS TableName, COUNT(*) AS RecordCount FROM Demo_Retail_Product
UNION ALL
SELECT 'Demo_Retail_Variant', COUNT(*) FROM Demo_Retail_Variant
UNION ALL
SELECT 'Demo_Retail_Price', COUNT(*) FROM Demo_Retail_Price
UNION ALL
SELECT 'Demo_Retail_Stock', COUNT(*) FROM Demo_Retail_Stock
UNION ALL
SELECT 'RawMaterials', COUNT(*) FROM RawMaterials WHERE MaterialCode LIKE 'AC%' OR MaterialCode LIKE 'UM%'
UNION ALL
SELECT 'Subassemblies', COUNT(*) FROM Subassemblies WHERE SubAssemblyCode LIKE 'AC%' OR SubAssemblyCode LIKE 'UM%';

-- Check products by branch
SELECT BranchID, COUNT(*) AS ProductCount 
FROM Demo_Retail_Product 
GROUP BY BranchID;

-- Sample products
SELECT TOP 20 
    ProductID,
    Code, 
    Name, 
    Category, 
    BranchID,
    SKU,
    ProductType
FROM Demo_Retail_Product 
ORDER BY BranchID, Code;

-- Check if variants exist
SELECT TOP 10 
    v.VariantID,
    v.ProductID,
    v.Barcode,
    p.Code,
    p.Name,
    p.BranchID
FROM Demo_Retail_Variant v
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
ORDER BY p.BranchID, p.Code;

-- Check if prices exist
SELECT TOP 10 
    pr.PriceID,
    pr.ProductID,
    pr.BranchID,
    pr.SellingPrice,
    pr.CostPrice,
    p.Code,
    p.Name
FROM Demo_Retail_Price pr
INNER JOIN Demo_Retail_Product p ON pr.ProductID = p.ProductID
ORDER BY pr.BranchID, p.Code;
