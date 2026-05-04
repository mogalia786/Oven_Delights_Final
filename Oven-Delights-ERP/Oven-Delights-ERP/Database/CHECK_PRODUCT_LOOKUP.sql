-- Check what the LoadProducts query returns for Branch 6
SELECT ProductID, ProductName, LastPaidPrice, IsVatable, ItemSource
FROM (
    -- RawMaterials
    SELECT 
        MaterialID AS ProductID, 
        MaterialName AS ProductName, 
        ISNULL(LastPaidPrice, 0) AS LastPaidPrice, 
        1 AS IsVatable,
        'RM' AS ItemSource
    FROM RawMaterials 
    WHERE IsActive = 1
    
    UNION ALL
    
    -- External Products from Demo_Retail_Product with CostPrice
    SELECT DISTINCT
        p.ProductID, 
        p.Name AS ProductName, 
        ISNULL(rp.CostPrice, 0) AS LastPaidPrice, 
        ISNULL(p.IsVatable, 1) AS IsVatable,
        'PR' AS ItemSource
    FROM Demo_Retail_Product p
    LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
    WHERE p.ProductType = 'External' 
      AND p.IsActive = 1
      AND p.BranchID = 6
) AS AllItems
WHERE ProductName IN ('FlourCake', 'Eggs')
ORDER BY ProductName
