-- Check if Bar One Swissroll Slice has cost price set
SELECT 
    p.ProductID,
    p.Name,
    p.CurrentStock,
    pr.CostPrice,
    pr.SellingPrice,
    pr.UpdatedAt,
    pr.BranchID
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
WHERE p.Name LIKE '%Bar One%Swissroll%'
ORDER BY pr.BranchID

-- Check if there's a BOM for this product
SELECT 
    bh.BOMID,
    bh.ProductID,
    p.Name AS ProductName,
    bh.BatchSize,
    bh.IsActive
FROM BOM_Header bh
INNER JOIN Demo_Retail_Product p ON bh.ProductID = p.ProductID
WHERE p.Name LIKE '%Bar One%Swissroll%'

-- Check production log for this product
SELECT TOP 5
    pl.ProductionDate,
    pl.ProductName,
    pl.ExpectedYield,
    pl.ActualYield,
    pl.CostOfSales,
    pl.Baker,
    pl.BranchID
FROM ProductionLog pl
WHERE pl.ProductName LIKE '%Bar One%Swissroll%'
ORDER BY pl.ProductionDate DESC
