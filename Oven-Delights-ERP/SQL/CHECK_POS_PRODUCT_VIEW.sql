-- Check what the POS sees for "Bar One Slice"
-- This shows exactly what data the POS is reading

DECLARE @BranchID INT = 6; -- AYESHA CAKE HOUSE branch from your screenshot

-- What POS should be querying
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.BranchID,
    p.CurrentStock AS [POS_Sees_This_Stock],
    p.ProductType,
    p.IsActive
FROM dbo.Demo_Retail_Product p
WHERE p.Name LIKE '%Bar One%'
ORDER BY p.ProductID;

-- What's actually in RetailStock
SELECT 
    rs.ProductID,
    p.Name,
    rs.BranchID,
    rs.Quantity AS [Actual_Stock_In_RetailStock],
    rs.StockType
FROM dbo.RetailStock rs
INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = rs.ProductID
WHERE p.Name LIKE '%Bar One%'
ORDER BY rs.ProductID;

-- Check if there's a mismatch
SELECT 
    p.ProductID,
    p.SKU,
    p.Name,
    p.BranchID AS Product_BranchID,
    p.CurrentStock AS Product_CurrentStock,
    rs.BranchID AS Stock_BranchID,
    rs.Quantity AS Stock_Quantity,
    CASE 
        WHEN p.CurrentStock <> rs.Quantity THEN 'MISMATCH!'
        ELSE 'OK'
    END AS Status
FROM dbo.Demo_Retail_Product p
LEFT JOIN dbo.RetailStock rs ON rs.ProductID = p.ProductID AND rs.BranchID = p.BranchID
WHERE p.Name LIKE '%Bar One%';
