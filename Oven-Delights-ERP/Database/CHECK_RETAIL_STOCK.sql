-- Check if Bar One Swissrole slice was added to retail stock
SELECT 
    p.ProductID,
    p.Name,
    p.Category,
    p.CurrentStock,
    p.BranchID,
    b.BranchName
FROM Demo_Retail_Product p
LEFT JOIN Branches b ON p.BranchID = b.BranchID
WHERE p.Name LIKE '%Bar One%' OR p.Name LIKE '%Swissroll%' OR p.Name LIKE '%Swiss roll%'
ORDER BY p.BranchID, p.Name

-- Check production log for recent completions
SELECT TOP 10
    pl.ProductionLogID,
    pl.ProductName,
    pl.Baker,
    pl.ExpectedYield,
    pl.ActualYield,
    pl.ShortBy,
    pl.CostOfSales,
    pl.ProductionDate,
    pl.BranchID
FROM ProductionLog pl
ORDER BY pl.ProductionDate DESC
