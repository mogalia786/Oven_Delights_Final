-- =============================================
-- Trigger: Auto-Update Recipe Costs on Product Price Change
-- Description: Automatically updates all sub-recipe and product BOM costs
--              whenever ingredient prices change in Demo_Retail_Product
-- =============================================

-- Drop existing trigger if it exists
IF OBJECT_ID('trg_AutoUpdateRecipeCosts_OnProductPriceChange', 'TR') IS NOT NULL
    DROP TRIGGER trg_AutoUpdateRecipeCosts_OnProductPriceChange;
GO

CREATE TRIGGER trg_AutoUpdateRecipeCosts_OnProductPriceChange
ON Demo_Retail_Product
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Only proceed if AverageCost or LastPaidPrice was updated
    IF UPDATE(AverageCost) OR UPDATE(LastPaidPrice)
    BEGIN
        DECLARE @ProductID INT;
        DECLARE @NewCost DECIMAL(18,6);
        
        -- Cursor to process each updated product
        DECLARE product_cursor CURSOR FOR
        SELECT i.ProductID, ISNULL(i.AverageCost, i.LastPaidPrice)
        FROM inserted i
        INNER JOIN deleted d ON i.ProductID = d.ProductID AND i.BranchID = d.BranchID
        WHERE ISNULL(i.AverageCost, i.LastPaidPrice) <> ISNULL(d.AverageCost, d.LastPaidPrice);
        
        OPEN product_cursor;
        FETCH NEXT FROM product_cursor INTO @ProductID, @NewCost;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Update Sub-Recipe BOM costs for this ingredient
            -- TotalCost is a computed column (Quantity * CostPerUnit) so it updates automatically
            UPDATE Demo_SubRecipe_BOM
            SET CostPerUnit = @NewCost
            WHERE IngredientID = @ProductID;
            
            -- Recalculate total cost for affected sub-recipes
            UPDATE sm
            SET sm.TotalCost = (
                SELECT SUM(sb.TotalCost)
                FROM Demo_SubRecipe_BOM sb
                WHERE sb.SubRecipeID = sm.SubRecipeID
            )
            FROM Demo_SubRecipe_Master sm
            WHERE EXISTS (
                SELECT 1 
                FROM Demo_SubRecipe_BOM sb 
                WHERE sb.SubRecipeID = sm.SubRecipeID 
                AND sb.IngredientID = @ProductID
            );
            
            -- Update Product BOM costs for this ingredient (direct ingredient use)
            -- TotalCost is a computed column (Quantity * CostPerUnit) so it updates automatically
            UPDATE Demo_Product_BOM
            SET CostPerUnit = @NewCost
            WHERE ComponentID = @ProductID
            AND ComponentType = 'Ingredient';
            
            -- Update Product BOM costs for sub-recipes that use this ingredient
            -- TotalCost is a computed column (Quantity * CostPerUnit) so it updates automatically
            UPDATE pb
            SET pb.CostPerUnit = sm.TotalCost / sm.BatchQty
            FROM Demo_Product_BOM pb
            INNER JOIN Demo_SubRecipe_Master sm ON pb.ComponentID = sm.SubRecipeID
            WHERE pb.ComponentType = 'SubRecipe'
            AND EXISTS (
                SELECT 1 
                FROM Demo_SubRecipe_BOM sb 
                WHERE sb.SubRecipeID = sm.SubRecipeID 
                AND sb.IngredientID = @ProductID
            );
            
            -- Recalculate total cost for affected products
            UPDATE pm
            SET pm.TotalCost = (
                SELECT SUM(pb.TotalCost)
                FROM Demo_Product_BOM pb
                WHERE pb.ProductID = pm.ProductID
            )
            FROM Demo_Product_Recipe_Master pm
            WHERE EXISTS (
                SELECT 1 
                FROM Demo_Product_BOM pb 
                WHERE pb.ProductID = pm.ProductID 
                AND (
                    pb.ComponentID = @ProductID 
                    OR pb.ComponentID IN (
                        SELECT SubRecipeID 
                        FROM Demo_SubRecipe_BOM 
                        WHERE IngredientID = @ProductID
                    )
                )
            );
            
            FETCH NEXT FROM product_cursor INTO @ProductID, @NewCost;
        END;
        
        CLOSE product_cursor;
        DEALLOCATE product_cursor;
    END;
END;
GO

PRINT 'Trigger trg_AutoUpdateRecipeCosts_OnProductPriceChange created successfully!';
PRINT 'This trigger will automatically update all sub-recipe and product costs when ingredient prices change.';
GO
