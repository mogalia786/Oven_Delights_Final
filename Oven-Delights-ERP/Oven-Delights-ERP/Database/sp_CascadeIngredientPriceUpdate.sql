-- =============================================
-- Stored Procedure: sp_RecalculateAllCosts
-- Description: Recalculates ALL sub-recipe and product costs from current ingredient prices
--              This runs on EVERY GRV to ensure costs are always accurate
-- =============================================

IF OBJECT_ID('sp_RecalculateAllCosts', 'P') IS NOT NULL
    DROP PROCEDURE sp_RecalculateAllCosts;
GO

CREATE PROCEDURE sp_RecalculateAllCosts
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Step 1: Update ALL sub-recipe ingredient costs from current retail prices
        -- Get prices from Demo_Retail_Price (where PO gets prices from)
        UPDATE si
        SET si.CostPerUnit = ISNULL(price.CostPrice, si.CostPerUnit)
        FROM Demo_SubRecipe_Ingredients si
        INNER JOIN Demo_Retail_Price price ON si.IngredientID = price.ProductID
        WHERE price.BranchID = 1; -- Master products are in BranchID 1
        
        -- Step 2: Recalculate total cost for ALL sub-recipes
        UPDATE sm
        SET sm.TotalCost = (
            SELECT SUM(si.Quantity * si.CostPerUnit)
            FROM Demo_SubRecipe_Ingredients si
            WHERE si.SubRecipeID = sm.SubRecipeID
        )
        FROM Demo_SubRecipe_Master sm;
        
        -- Step 3: Update ALL product BOM costs for ingredients
        -- Get prices from Demo_Retail_Price (where PO gets prices from)
        UPDATE pb
        SET pb.CostPerUnit = ISNULL(price.CostPrice, pb.CostPerUnit)
        FROM Demo_Product_BOM pb
        INNER JOIN Demo_Retail_Price price ON pb.ComponentID = price.ProductID
        WHERE pb.ComponentType = 'Ingredient'
        AND price.BranchID = 1;
        
        -- Step 4: Update ALL product BOM costs for sub-recipes
        UPDATE pb
        SET pb.CostPerUnit = sm.TotalCost / NULLIF(sm.BatchQty, 0)
        FROM Demo_Product_BOM pb
        INNER JOIN Demo_SubRecipe_Master sm ON pb.ComponentID = sm.SubRecipeID
        WHERE pb.ComponentType = 'SubRecipe';
        
        -- Step 5: Recalculate total cost for ALL products
        UPDATE pm
        SET pm.TotalCost = (
            SELECT SUM(pb.Quantity * pb.CostPerUnit)
            FROM Demo_Product_BOM pb
            WHERE pb.ProductID = pm.ProductID
        )
        FROM Demo_Product_Recipe_Master pm;
        
        -- Step 6: Update retail stock cost price for ALL finished products
        -- Add 15% adhoc markup to the base cost for internal manufactured products
        UPDATE rs
        SET rs.AverageCost = (pm.TotalCost / NULLIF(pm.BatchQty, 0)) * 1.15
        FROM Demo_Retail_Product rs
        INNER JOIN Demo_Product_Recipe_Master pm ON rs.ProductID = pm.ProductID
        WHERE rs.BranchID = 1;
        
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

PRINT 'Stored procedure sp_RecalculateAllCosts created successfully!';
PRINT 'This procedure will recalculate ALL costs on every GRV, regardless of price changes.';
GO
