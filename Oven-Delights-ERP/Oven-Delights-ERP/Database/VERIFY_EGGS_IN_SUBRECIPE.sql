-- Verify which eggs product is in SubRecipeID 57008

SELECT 
    si.IngredientLineID,
    si.SubRecipeID,
    si.IngredientID,
    rp.Name AS IngredientName,
    rp.SKU,
    si.CostPerUnit,
    si.Quantity,
    si.TotalCost
FROM Demo_SubRecipe_Ingredients si
INNER JOIN Demo_Retail_Product rp ON si.IngredientID = rp.ProductID AND rp.BranchID = 6
WHERE si.SubRecipeID = 57008
AND rp.Name LIKE '%egg%'
ORDER BY si.IngredientLineID;
