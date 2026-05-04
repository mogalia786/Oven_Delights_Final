-- =============================================
-- Updated: Consume Sub-Recipes from Inventory for Product Manufacturing
-- Consumes ALL sub-recipes required by a product's BOM
-- Uses FIFO (First In, First Out) - oldest sub-recipes consumed first
-- =============================================
CREATE OR ALTER PROCEDURE sp_ConsumeSubRecipeFromInventory
    @SubRecipeID INT = NULL,           -- If NULL, consume all sub-recipes in BOM
    @QuantityNeeded DECIMAL(18,2),     -- Quantity of the PRODUCT being manufactured
    @ProductID INT,                     -- The product being manufactured
    @BranchID INT,
    @ReOrderBookID INT = NULL,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Get all sub-recipes needed from BOM
        DECLARE @SubRecipesNeeded TABLE (
            SubRecipeID INT,
            SubRecipeName NVARCHAR(255),
            QuantityPerProduct DECIMAL(18,2),
            TotalQuantityNeeded DECIMAL(18,2)
        );
        
        -- If specific SubRecipeID provided, use it; otherwise get all from BOM
        IF @SubRecipeID IS NOT NULL
        BEGIN
            INSERT INTO @SubRecipesNeeded (SubRecipeID, SubRecipeName, QuantityPerProduct, TotalQuantityNeeded)
            SELECT 
                bd.IngredientID,
                p.Name,
                bd.Quantity,
                bd.Quantity * @QuantityNeeded
            FROM 
                BOMDetails bd
                INNER JOIN Demo_Retail_Product p ON bd.IngredientID = p.ProductID
            WHERE 
                bd.ProductID = @ProductID
                AND bd.IngredientID = @SubRecipeID
                AND bd.IsActive = 1
                AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%');
        END
        ELSE
        BEGIN
            -- Get all sub-recipes from BOM
            INSERT INTO @SubRecipesNeeded (SubRecipeID, SubRecipeName, QuantityPerProduct, TotalQuantityNeeded)
            SELECT 
                bd.IngredientID,
                p.Name,
                bd.Quantity,
                bd.Quantity * @QuantityNeeded
            FROM 
                BOMDetails bd
                INNER JOIN Demo_Retail_Product p ON bd.IngredientID = p.ProductID
            WHERE 
                bd.ProductID = @ProductID
                AND bd.IsActive = 1
                AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%');
        END
        
        -- Check if any sub-recipes found
        IF NOT EXISTS (SELECT 1 FROM @SubRecipesNeeded)
        BEGIN
            -- No sub-recipes in BOM - this is OK, product may only use ingredients
            COMMIT TRANSACTION;
            RETURN;
        END
        
        -- Consume each sub-recipe from inventory
        DECLARE @CurrentSubRecipeID INT;
        DECLARE @CurrentSubRecipeName NVARCHAR(255);
        DECLARE @CurrentQuantityNeeded DECIMAL(18,2);
        DECLARE @QuantityConsumed DECIMAL(18,2);
        
        DECLARE subrecipe_cursor CURSOR FOR
        SELECT SubRecipeID, SubRecipeName, TotalQuantityNeeded
        FROM @SubRecipesNeeded;
        
        OPEN subrecipe_cursor;
        FETCH NEXT FROM subrecipe_cursor INTO @CurrentSubRecipeID, @CurrentSubRecipeName, @CurrentQuantityNeeded;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @QuantityConsumed = 0;
            
            -- Get available inventory for this sub-recipe (FIFO - oldest first)
            DECLARE @InventoryID INT, @AvailableQty DECIMAL(18,2), @BatchNumber NVARCHAR(50);
            
            DECLARE inventory_cursor CURSOR FOR
            SELECT InventoryID, Quantity, BatchNumber
            FROM Demo_SubRecipe_Inventory
            WHERE SubRecipeID = @CurrentSubRecipeID 
              AND BranchID = @BranchID 
              AND Status = 'Available'
            ORDER BY ManufacturedDate ASC; -- FIFO: Oldest first
            
            OPEN inventory_cursor;
            FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber;
            
            WHILE @@FETCH_STATUS = 0 AND @QuantityConsumed < @CurrentQuantityNeeded
            BEGIN
                DECLARE @QtyToConsume DECIMAL(18,2);
                
                -- Calculate how much to consume from this batch
                IF (@CurrentQuantityNeeded - @QuantityConsumed) <= @AvailableQty
                BEGIN
                    SET @QtyToConsume = @CurrentQuantityNeeded - @QuantityConsumed;
                END
                ELSE
                BEGIN
                    SET @QtyToConsume = @AvailableQty;
                END
                
                -- Update inventory
                IF @QtyToConsume >= @AvailableQty
                BEGIN
                    -- Fully consumed
                    UPDATE Demo_SubRecipe_Inventory
                    SET Status = 'Consumed',
                        ConsumedDate = GETDATE(),
                        ConsumedBy = @UserID,
                        Quantity = 0
                    WHERE InventoryID = @InventoryID;
                END
                ELSE
                BEGIN
                    -- Partially consumed
                    UPDATE Demo_SubRecipe_Inventory
                    SET Quantity = Quantity - @QtyToConsume
                    WHERE InventoryID = @InventoryID;
                END
                
                -- Log consumption
                INSERT INTO Demo_SubRecipe_Consumption_Log (
                    InventoryID,
                    ProductID,
                    ProductName,
                    ReOrderBookID,
                    QuantityConsumed,
                    ConsumedDate,
                    ConsumedBy,
                    BranchID
                )
                VALUES (
                    @InventoryID,
                    @ProductID,
                    (SELECT Name FROM Demo_Retail_Product WHERE ProductID = @ProductID),
                    @ReOrderBookID,
                    @QtyToConsume,
                    GETDATE(),
                    @UserID,
                    @BranchID
                );
                
                SET @QuantityConsumed = @QuantityConsumed + @QtyToConsume;
                
                FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber;
            END
            
            CLOSE inventory_cursor;
            DEALLOCATE inventory_cursor;
            
            -- Check if we got enough
            IF @QuantityConsumed < @CurrentQuantityNeeded
            BEGIN
                ROLLBACK TRANSACTION;
                RAISERROR('Insufficient sub-recipe inventory for %s. Required: %.2f, Available: %.2f', 
                    16, 1, @CurrentSubRecipeName, @CurrentQuantityNeeded, @QuantityConsumed);
                RETURN;
            END
            
            FETCH NEXT FROM subrecipe_cursor INTO @CurrentSubRecipeID, @CurrentSubRecipeName, @CurrentQuantityNeeded;
        END
        
        CLOSE subrecipe_cursor;
        DEALLOCATE subrecipe_cursor;
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Sub-recipes consumed successfully' AS Message;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

PRINT 'sp_ConsumeSubRecipeFromInventory updated to handle all sub-recipes in BOM'
GO
