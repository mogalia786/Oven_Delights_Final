-- Check FlourCake price in Demo_Retail_Product

SELECT 
    ProductID,
    Name,
    BranchID,
    AverageCost,
    LastPaidPrice,
    CurrentStock
FROM Demo_Retail_Product
WHERE Name LIKE '%FlourCake%'
   OR Name LIKE '%Flour%Cake%'
ORDER BY BranchID;
