-- Stored Procedure to consume ingredients from manufacturing stock during production
-- This reduces ingredient inventory at the manufacturer when producing sub-recipes or products
CREATE OR ALTER PROCEDURE sp_ConsumeIngredientsFromManufacturing
    @ReOrderBookID INT,
    @BranchID INT,
    @ProductID INT,
    @QuantityProduced DECIMAL(18,2),
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Get the BOM ingredients for this product
        DECLARE @BOMIngredients TABLE (
            IngredientID INT,
            IngredientName NVARCHAR(255),
            QuantityNeeded DECIMAL(18,2),
            UnitOfMeasure NVARCHAR(50)
        );
        
        INSERT INTO @BOMIngredients (IngredientID, IngredientName, QuantityNeeded, UnitOfMeasure)
        SELECT 
            bd.IngredientID,
            p.Name AS IngredientName,
            bd.Quantity * @QuantityProduced AS QuantityNeeded,
            bd.UnitOfMeasure
        FROM 
            BOMDetails bd
            INNER JOIN Demo_Retail_Product p ON bd.IngredientID = p.ProductID
        WHERE 
            bd.ProductID = @ProductID
            AND bd.IsActive = 1
            AND p.Category LIKE '%ingredient%'; -- Only consume ingredients, not sub-recipes
        
        -- Consume each ingredient from manufacturing stock
        DECLARE @IngredientID INT;
        DECLARE @IngredientName NVARCHAR(255);
        DECLARE @QuantityNeeded DECIMAL(18,2);
        DECLARE @UnitOfMeasure NVARCHAR(50);
        DECLARE @CurrentStock DECIMAL(18,2);
        
        DECLARE ingredient_cursor CURSOR FOR
        SELECT IngredientID, IngredientName, QuantityNeeded, UnitOfMeasure
        FROM @BOMIngredients;
        
        OPEN ingredient_cursor;
        FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientName, @QuantityNeeded, @UnitOfMeasure;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Check current stock
            SELECT @CurrentStock = CurrentStock
            FROM Demo_Retail_Product
            WHERE ProductID = @IngredientID AND BranchID = @BranchID;
            
            IF @CurrentStock IS NULL OR @CurrentStock < @QuantityNeeded
            BEGIN
                ROLLBACK TRANSACTION;
                RAISERROR('Insufficient stock for ingredient: %s. Required: %.2f, Available: %.2f', 16, 1, 
                    @IngredientName, @QuantityNeeded, ISNULL(@CurrentStock, 0));
                RETURN;
            END
            
            -- Reduce ingredient stock
            UPDATE Demo_Retail_Product
            SET CurrentStock = CurrentStock - @QuantityNeeded,
                LastUpdated = GETDATE()
            WHERE ProductID = @IngredientID AND BranchID = @BranchID;
            
            -- Log the consumption
            INSERT INTO Demo_Retail_StockMovements (
                ProductID,
                BranchID,
                MovementType,
                Quantity,
                UnitOfMeasure,
                MovementDate,
                ReferenceType,
                ReferenceID,
                Notes,
                CreatedBy,
                CreatedDate
            )
            VALUES (
                @IngredientID,
                @BranchID,
                'Consumption',
                -@QuantityNeeded,
                @UnitOfMeasure,
                GETDATE(),
                'Production',
                @ReOrderBookID,
                'Ingredient consumed for production - ReOrderBook: ' + CAST(@ReOrderBookID AS NVARCHAR(50)),
                @UserID,
                GETDATE()
            );
            
            FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientName, @QuantityNeeded, @UnitOfMeasure;
        END
        
        CLOSE ingredient_cursor;
        DEALLOCATE ingredient_cursor;
        
        COMMIT TRANSACTION;
        
        SELECT 'Success' AS Result, 'Ingredients consumed successfully' AS Message;
        
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

PRINT 'sp_ConsumeIngredientsFromManufacturing created successfully'
GO
