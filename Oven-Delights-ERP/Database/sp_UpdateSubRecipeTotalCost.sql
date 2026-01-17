-- =============================================
-- Stored Procedure: sp_UpdateSubRecipeTotalCost
-- Description: Calculates and updates the total cost for a sub-recipe
--              based on its ingredients
-- =============================================

IF OBJECT_ID('sp_UpdateSubRecipeTotalCost', 'P') IS NOT NULL
    DROP PROCEDURE sp_UpdateSubRecipeTotalCost;
GO

CREATE PROCEDURE sp_UpdateSubRecipeTotalCost
    @SubRecipeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalCost DECIMAL(18,4) = 0;
    
    -- Calculate total cost from ingredients
    SELECT @TotalCost = SUM(
        ISNULL(sri.Quantity, 0) * ISNULL(sri.CostPerUnit, 0)
    )
    FROM Demo_SubRecipe_Ingredients sri
    WHERE sri.SubRecipeID = @SubRecipeID;
    
    -- Update the master table
    UPDATE Demo_SubRecipe_Master
    SET 
        TotalCost = ISNULL(@TotalCost, 0),
        LastUpdated = GETDATE()
    WHERE SubRecipeID = @SubRecipeID;
    
    -- Also update Demo_Retail_Product with the cost
    UPDATE Demo_Retail_Product
    SET 
        AverageCost = ISNULL(@TotalCost, 0),
        LastUpdated = GETDATE()
    WHERE ProductID = @SubRecipeID;
    
END
GO

PRINT '✓ Created sp_UpdateSubRecipeTotalCost';
GO
