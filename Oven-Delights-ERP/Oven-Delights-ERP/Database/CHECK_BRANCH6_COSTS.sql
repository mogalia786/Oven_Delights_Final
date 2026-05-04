-- Check if ingredients in Branch 6 have LastPaidPrice updated

PRINT '=== Check ingredients in Branch 6 ==='
SELECT 
    ProductID,
    Name,
    BranchID,
    AverageCost,
    LastPaidPrice,
    Category
FROM Demo_Retail_Product
WHERE BranchID = 6
  AND Name IN ('5*7*3', 'Choc milk block', 'Label White Keep In Fridge', 'Sugar White Huletts')
ORDER BY Name;

PRINT ''
PRINT '=== Check same ingredients in ALL branches ==='
SELECT 
    ProductID,
    Name,
    BranchID,
    AverageCost,
    LastPaidPrice,
    Category
FROM Demo_Retail_Product
WHERE Name IN ('5*7*3', 'Choc milk block', 'Label White Keep In Fridge', 'Sugar White Huletts')
ORDER BY Name, BranchID;
