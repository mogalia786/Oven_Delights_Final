-- =============================================
-- Add Sub-Recipe to Inventory
-- Called when baker completes sub-recipe production
-- Deducts ingredients from manufacturing stock
-- =============================================
CREATE OR ALTER PROCEDURE sp_AddSubRecipeToInventory
    @SubRecipeID INT,
    @Quantity DECIMAL(18,2),
    @BranchID INT,
    @ManufacturedBy INT,
    @Notes NVARCHAR(500) = NULL,
    @BatchNumber NVARCHAR(50) OUTPUT,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validate sub-recipe exists
        IF NOT EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @SubRecipeID AND IsActive = 1)
        BEGIN
            SET @Success = 0
            SET @Message = 'Sub-recipe not found or inactive'
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- Get sub-recipe details
        DECLARE @SubRecipeName NVARCHAR(200), @UnitOfMeasure NVARCHAR(50)
        SELECT @SubRecipeName = Name, @UnitOfMeasure = 'Batch'
        FROM Demo_Retail_Product 
        WHERE ProductID = @SubRecipeID
        
        -- Generate batch number: SR-BranchPrefix-YYYYMMDD-HHMMSS
        DECLARE @BranchPrefix NVARCHAR(10)
        SELECT @BranchPrefix = ISNULL(Prefix, 'BR')
        FROM Branches 
        WHERE BranchID = @BranchID
        
        SET @BatchNumber = 'SR-' + @BranchPrefix + '-' + 
                          FORMAT(GETDATE(), 'yyyyMMdd-HHmmss')
        
        -- Deduct ingredients from manufacturing stock
        DECLARE @IngredientID INT, @IngredientQty DECIMAL(18,2), @IngredientName NVARCHAR(200)
        DECLARE @CurrentStock DECIMAL(18,2)
        
        DECLARE ingredient_cursor CURSOR FOR
        SELECT 
            sri.IngredientID,
            sri.Quantity * @Quantity AS TotalQtyNeeded,
            p.Name
        FROM 
            Demo_SubRecipe_Ingredients sri
            INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID
        WHERE 
            sri.SubRecipeID = @SubRecipeID
        
        OPEN ingredient_cursor
        FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientQty, @IngredientName
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Check current stock in manufacturing inventory
            SELECT @CurrentStock = ISNULL(CurrentStock, 0)
            FROM Demo_Retail_Product
            WHERE ProductID = @IngredientID AND BranchID = @BranchID
            
            IF @CurrentStock < @IngredientQty
            BEGIN
                SET @Success = 0
                SET @Message = 'Insufficient stock for ingredient: ' + @IngredientName + 
                              '. Required: ' + CAST(@IngredientQty AS NVARCHAR(50)) + 
                              ', Available: ' + CAST(@CurrentStock AS NVARCHAR(50))
                CLOSE ingredient_cursor
                DEALLOCATE ingredient_cursor
                ROLLBACK TRANSACTION
                RETURN
            END
            
            -- Deduct from manufacturing stock
            UPDATE Demo_Retail_Product
            SET CurrentStock = CurrentStock - @IngredientQty
            WHERE ProductID = @IngredientID AND BranchID = @BranchID
            
            -- Log stock movement (using Demo_Retail_StockMovements structure)
            -- Note: Demo_Retail_StockMovements uses VariantID, not ProductID
            -- We'll skip stock movement logging for now as it requires variant mapping
            -- This can be added later when variant system is fully integrated
            
            FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientQty, @IngredientName
        END
        
        CLOSE ingredient_cursor
        DEALLOCATE ingredient_cursor
        
        -- Add to sub-recipe inventory
        INSERT INTO Demo_SubRecipe_Inventory (
            SubRecipeID,
            SubRecipeName,
            BatchNumber,
            Quantity,
            UnitOfMeasure,
            ManufacturedDate,
            ManufacturedTime,
            BranchID,
            ManufacturedBy,
            Status,
            Notes
        )
        VALUES (
            @SubRecipeID,
            @SubRecipeName,
            @BatchNumber,
            @Quantity,
            @UnitOfMeasure,
            GETDATE(),
            CONVERT(TIME, GETDATE()),
            @BranchID,
            @ManufacturedBy,
            'Available',
            @Notes
        )
        
        SET @Success = 1
        SET @Message = 'Sub-recipe added to inventory successfully. Batch: ' + @BatchNumber
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        SET @Success = 0
        SET @Message = 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'sp_AddSubRecipeToInventory created successfully'
GO
