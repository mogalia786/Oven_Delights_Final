-- =============================================
-- Consume Sub-Recipe from Inventory
-- Called when manufacturing a product that uses prepared sub-recipes
-- Uses FIFO (First In, First Out) - oldest sub-recipes consumed first
-- =============================================
CREATE OR ALTER PROCEDURE sp_ConsumeSubRecipeFromInventory
    @SubRecipeID INT,
    @QuantityNeeded DECIMAL(18,2),
    @ProductID INT,
    @ProductName NVARCHAR(200),
    @ReOrderBookID INT = NULL,
    @BranchID INT,
    @ConsumedBy INT,
    @QuantityConsumed DECIMAL(18,2) OUTPUT,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        SET @QuantityConsumed = 0
        
        -- Get available inventory (FIFO - oldest first)
        DECLARE @InventoryID INT, @AvailableQty DECIMAL(18,2), @BatchNumber NVARCHAR(50)
        
        DECLARE inventory_cursor CURSOR FOR
        SELECT InventoryID, Quantity, BatchNumber
        FROM Demo_SubRecipe_Inventory
        WHERE SubRecipeID = @SubRecipeID 
          AND BranchID = @BranchID 
          AND Status = 'Available'
        ORDER BY ManufacturedDate ASC -- FIFO: Oldest first
        
        OPEN inventory_cursor
        FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber
        
        WHILE @@FETCH_STATUS = 0 AND @QuantityConsumed < @QuantityNeeded
        BEGIN
            DECLARE @QtyToConsume DECIMAL(18,2)
            
            -- Calculate how much to consume from this batch
            IF (@QuantityNeeded - @QuantityConsumed) <= @AvailableQty
            BEGIN
                -- This batch has enough to fulfill remaining requirement
                SET @QtyToConsume = @QuantityNeeded - @QuantityConsumed
            END
            ELSE
            BEGIN
                -- Consume entire batch and continue to next
                SET @QtyToConsume = @AvailableQty
            END
            
            -- Update inventory
            IF @QtyToConsume >= @AvailableQty
            BEGIN
                -- Fully consumed
                UPDATE Demo_SubRecipe_Inventory
                SET Status = 'Consumed',
                    ConsumedDate = GETDATE(),
                    ConsumedBy = @ConsumedBy,
                    Quantity = 0
                WHERE InventoryID = @InventoryID
            END
            ELSE
            BEGIN
                -- Partially consumed
                UPDATE Demo_SubRecipe_Inventory
                SET Quantity = Quantity - @QtyToConsume
                WHERE InventoryID = @InventoryID
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
                @ProductName,
                @ReOrderBookID,
                @QtyToConsume,
                GETDATE(),
                @ConsumedBy,
                @BranchID
            )
            
            SET @QuantityConsumed = @QuantityConsumed + @QtyToConsume
            
            FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber
        END
        
        CLOSE inventory_cursor
        DEALLOCATE inventory_cursor
        
        IF @QuantityConsumed >= @QuantityNeeded
        BEGIN
            SET @Success = 1
            SET @Message = 'Successfully consumed ' + CAST(@QuantityConsumed AS NVARCHAR(50)) + ' from inventory'
        END
        ELSE
        BEGIN
            SET @Success = 0
            SET @Message = 'Insufficient inventory. Required: ' + CAST(@QuantityNeeded AS NVARCHAR(50)) + 
                          ', Available: ' + CAST(@QuantityConsumed AS NVARCHAR(50))
            ROLLBACK TRANSACTION
            RETURN
        END
        
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

PRINT 'sp_ConsumeSubRecipeFromInventory created successfully'
GO
