-- =============================================
-- FIX: Update sp_ConsumeSubRecipeFromInventory to work with NEW Recipe Management System
-- Uses Demo_ProductRecipe_BOM instead of old BOM_Lines/BOM_Header tables
-- =============================================

CREATE OR ALTER PROCEDURE sp_ConsumeSubRecipeFromInventory
    @SubRecipeID INT = NULL,
    @QuantityNeeded DECIMAL(18,2),
    @ProductID INT,
    @BranchID INT,
    @ReOrderBookID INT = NULL,
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get batch quantity for the product
    DECLARE @BatchQty DECIMAL(18,2) = 1;
    SELECT @BatchQty = BatchQty 
    FROM Demo_ProductRecipe_Master 
    WHERE ProductID = @ProductID AND IsActive = 1;
    
    -- Calculate scaling factor
    DECLARE @ScalingFactor DECIMAL(18,6) = @QuantityNeeded / @BatchQty;
    
    DECLARE @SubRecipesNeeded TABLE (
        SubRecipeID INT,
        SubRecipeName NVARCHAR(255),
        QuantityPerBatch DECIMAL(18,2),
        TotalQuantityNeeded DECIMAL(18,2)
    );
    
    -- Get sub-recipes from NEW Recipe Management system
    IF @SubRecipeID IS NOT NULL
    BEGIN
        -- Specific sub-recipe
        INSERT INTO @SubRecipesNeeded (SubRecipeID, SubRecipeName, QuantityPerBatch, TotalQuantityNeeded)
        SELECT 
            pbl.ComponentID,
            p.Name,
            pbl.Quantity,
            pbl.Quantity * @ScalingFactor
        FROM Demo_ProductRecipe_BOM pbl
        INNER JOIN Demo_Retail_Product p ON pbl.ComponentID = p.ProductID
        WHERE pbl.ProductID = @ProductID
          AND pbl.ComponentID = @SubRecipeID
          AND pbl.ComponentType = 'SubRecipe'
          AND pbl.IsActive = 1;
    END
    ELSE
    BEGIN
        -- All sub-recipes for the product
        INSERT INTO @SubRecipesNeeded (SubRecipeID, SubRecipeName, QuantityPerBatch, TotalQuantityNeeded)
        SELECT 
            pbl.ComponentID,
            p.Name,
            pbl.Quantity,
            pbl.Quantity * @ScalingFactor
        FROM Demo_ProductRecipe_BOM pbl
        INNER JOIN Demo_Retail_Product p ON pbl.ComponentID = p.ProductID
        WHERE pbl.ProductID = @ProductID
          AND pbl.ComponentType = 'SubRecipe'
          AND pbl.IsActive = 1;
    END
    
    IF NOT EXISTS (SELECT 1 FROM @SubRecipesNeeded)
    BEGIN
        RETURN;
    END
    
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
        
        DECLARE @InventoryID INT, @AvailableQty DECIMAL(18,2), @BatchNumber NVARCHAR(50);
        
        -- FIFO: Get oldest available inventory first
        DECLARE inventory_cursor CURSOR FOR
        SELECT InventoryID, Quantity, BatchNumber
        FROM Demo_SubRecipe_Inventory
        WHERE SubRecipeID = @CurrentSubRecipeID 
          AND BranchID = @BranchID 
          AND Status = 'Available'
        ORDER BY ManufacturedDate ASC;
        
        OPEN inventory_cursor;
        FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber;
        
        WHILE @@FETCH_STATUS = 0 AND @QuantityConsumed < @CurrentQuantityNeeded
        BEGIN
            DECLARE @QtyToConsume DECIMAL(18,2);
            DECLARE @RemainingNeeded DECIMAL(18,2) = @CurrentQuantityNeeded - @QuantityConsumed;
            
            IF @AvailableQty >= @RemainingNeeded
            BEGIN
                -- This batch has enough
                SET @QtyToConsume = @RemainingNeeded;
                
                -- Update inventory
                UPDATE Demo_SubRecipe_Inventory
                SET Quantity = Quantity - @QtyToConsume,
                    Status = CASE WHEN (Quantity - @QtyToConsume) <= 0 THEN 'Consumed' ELSE 'Available' END,
                    LastUpdated = GETDATE()
                WHERE InventoryID = @InventoryID;
                
                SET @QuantityConsumed = @QuantityConsumed + @QtyToConsume;
            END
            ELSE
            BEGIN
                -- Consume entire batch
                SET @QtyToConsume = @AvailableQty;
                
                -- Update inventory
                UPDATE Demo_SubRecipe_Inventory
                SET Quantity = 0,
                    Status = 'Consumed',
                    LastUpdated = GETDATE()
                WHERE InventoryID = @InventoryID;
                
                SET @QuantityConsumed = @QuantityConsumed + @QtyToConsume;
            END
            
            -- Log the consumption
            INSERT INTO Demo_SubRecipe_Movements (
                SubRecipeID, 
                BranchID, 
                MovementType, 
                Quantity, 
                BatchNumber, 
                ReOrderBookID, 
                UserID, 
                Notes
            )
            VALUES (
                @CurrentSubRecipeID,
                @BranchID,
                'Consumed',
                @QtyToConsume,
                @BatchNumber,
                @ReOrderBookID,
                @UserID,
                'Consumed for production - ' + @CurrentSubRecipeName
            );
            
            FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber;
        END
        
        CLOSE inventory_cursor;
        DEALLOCATE inventory_cursor;
        
        -- Check if we consumed enough
        IF @QuantityConsumed < @CurrentQuantityNeeded
        BEGIN
            DECLARE @ShortageQty DECIMAL(18,2) = @CurrentQuantityNeeded - @QuantityConsumed;
            RAISERROR('Insufficient sub-recipe inventory. Needed: %f, Available: %f, Shortage: %f', 16, 1, 
                      @CurrentQuantityNeeded, @QuantityConsumed, @ShortageQty);
            RETURN;
        END
        
        FETCH NEXT FROM subrecipe_cursor INTO @CurrentSubRecipeID, @CurrentSubRecipeName, @CurrentQuantityNeeded;
    END
    
    CLOSE subrecipe_cursor;
    DEALLOCATE subrecipe_cursor;
END
GO

PRINT '✅ sp_ConsumeSubRecipeFromInventory updated for NEW Recipe Management System';
GO
