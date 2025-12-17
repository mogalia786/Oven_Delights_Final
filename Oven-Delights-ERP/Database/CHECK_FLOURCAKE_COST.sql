-- Check FlourCake cost price in Demo_Retail_Price
SELECT 
    p.ProductID,
    p.Name,
    p.SKU,
    p.BranchID,
    b.BranchName,
    rp.CostPrice,
    rp.SellingPrice,
    rp.EffectiveFrom
FROM Demo_Retail_Product p
LEFT JOIN Demo_Retail_Price rp ON p.ProductID = rp.ProductID AND p.BranchID = rp.BranchID
LEFT JOIN Branches b ON p.BranchID = b.BranchID
WHERE p.Name LIKE '%FlourCake%'
ORDER BY p.BranchID, rp.EffectiveFrom DESC

-- Also check RecipeNode table
SELECT * FROM RecipeNode WHERE ItemName LIKE '%FlourCake%'
