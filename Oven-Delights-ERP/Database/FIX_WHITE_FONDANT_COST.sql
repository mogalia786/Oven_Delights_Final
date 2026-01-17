-- =============================================
-- Manually fix White Fondant cost by calculating from ingredients
-- Run this if sp_UpdateSubRecipeTotalCost wasn't available when recipe was saved
-- =============================================

DECLARE @SubRecipeID INT;
DECLARE @TotalCost DECIMAL(18,4);

-- Get White Fondant ProductID
SELECT @SubRecipeID = ProductID 
FROM Demo_Retail_Product 
WHERE Name LIKE '%White%Fondant%Icing%'
  AND Category LIKE '%sub%recipe%';

IF @SubRecipeID IS NOT NULL
BEGIN
    PRINT 'Found White Fondant with ProductID: ' + CAST(@SubRecipeID AS VARCHAR(10));
    
    -- Calculate total cost from ingredients
    SELECT @TotalCost = SUM(ISNULL(sri.Quantity, 0) * ISNULL(sri.CostPerUnit, 0))
    FROM Demo_SubRecipe_Ingredients sri
    WHERE sri.SubRecipeID = @SubRecipeID;
    
    PRINT 'Calculated Total Cost: R' + CAST(ISNULL(@TotalCost, 0) AS VARCHAR(20));
    
    -- Update Demo_SubRecipe_Master
    IF EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @SubRecipeID)
    BEGIN
        UPDATE Demo_SubRecipe_Master
        SET 
            TotalCost = ISNULL(@TotalCost, 0),
            LastUpdated = GETDATE()
        WHERE SubRecipeID = @SubRecipeID;
        
        PRINT '✓ Updated Demo_SubRecipe_Master.TotalCost';
    END
    ELSE
    BEGIN
        PRINT '⚠ No record found in Demo_SubRecipe_Master for this sub-recipe';
    END
    
    -- Update Demo_Retail_Product
    UPDATE Demo_Retail_Product
    SET 
        AverageCost = ISNULL(@TotalCost, 0),
        LastUpdated = GETDATE()
    WHERE ProductID = @SubRecipeID;
    
    PRINT '✓ Updated Demo_Retail_Product.AverageCost';
    
    -- Show the ingredients breakdown
    SELECT 
        drp.Name AS IngredientName,
        sri.Quantity,
        sri.UnitOfMeasure,
        sri.CostPerUnit,
        (sri.Quantity * sri.CostPerUnit) AS LineCost
    FROM Demo_SubRecipe_Ingredients sri
    INNER JOIN Demo_Retail_Product drp ON sri.IngredientID = drp.ProductID
    WHERE sri.SubRecipeID = @SubRecipeID;
    
    PRINT '';
    PRINT '✓ White Fondant cost has been updated!';
    PRINT 'Next: Manufacture a new batch to see the cost reflected in inventory.';
END
ELSE
BEGIN
    PRINT '❌ White Fondant sub-recipe not found!';
    PRINT 'Check the product name in Demo_Retail_Product.';
END
GO
