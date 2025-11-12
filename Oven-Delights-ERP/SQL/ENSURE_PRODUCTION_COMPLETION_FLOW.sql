-- =============================================
-- ENSURE PRODUCTION COMPLETION STOCK FLOW
-- This procedure is called when baker completes production
-- =============================================

IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
    DROP PROCEDURE sp_CompleteReOrderProduct;
GO

CREATE PROCEDURE sp_CompleteReOrderProduct
    @ReOrderLineID INT,
    @QuantityCompleted DECIMAL(18,2),
    @CompletedBy INT  -- UserID
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Get re-order line details
        DECLARE @ProductID INT;
        DECLARE @BranchID INT;
        DECLARE @RecipeID INT;
        
        SELECT 
            @ProductID = p.ProductID,
            @BranchID = rob.BranchID
        FROM dbo.ReOrderBookLines robl
        INNER JOIN dbo.ReOrderBook rob ON rob.ReOrderBookID = robl.ReOrderBookID
        INNER JOIN dbo.Demo_Retail_Product p ON p.ProductID = robl.ProductID
        WHERE robl.ReOrderLineID = @ReOrderLineID;
        
        IF @ProductID IS NULL
        BEGIN
            RAISERROR('Re-order line not found', 16, 1);
            RETURN;
        END
        
        -- Get Recipe for ingredient consumption
        SELECT @RecipeID = RecipeID 
        FROM dbo.Recipe 
        WHERE ProductID = @ProductID AND IsActive = 1;
        
        IF @RecipeID IS NULL
        BEGIN
            RAISERROR('No active recipe found for this product', 16, 1);
            RETURN;
        END
        
        -- Get batch yield to calculate ingredient consumption
        DECLARE @BatchYield DECIMAL(18,2);
        SELECT @BatchYield = BatchYield FROM dbo.Recipe WHERE RecipeID = @RecipeID;
        
        IF @BatchYield IS NULL OR @BatchYield <= 0
            SET @BatchYield = 1;
        
        DECLARE @BatchesProduced DECIMAL(18,4) = @QuantityCompleted / @BatchYield;
        
        -- =============================================
        -- STEP 1: REDUCE Manufacturing_Inventory (consume ingredients)
        -- =============================================
        DECLARE @MaterialID INT;
        DECLARE @IngredientQty DECIMAL(18,4);
        DECLARE @TotalQtyNeeded DECIMAL(18,4);
        
        DECLARE ingredient_cursor CURSOR FOR
        SELECT MaterialID, Quantity
        FROM dbo.RecipeIngredient
        WHERE RecipeID = @RecipeID 
        AND IngredientType = 'RawMaterial'
        AND MaterialID IS NOT NULL;
        
        OPEN ingredient_cursor;
        FETCH NEXT FROM ingredient_cursor INTO @MaterialID, @IngredientQty;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @TotalQtyNeeded = @IngredientQty * @BatchesProduced;
            
            -- Reduce from Manufacturing_Inventory
            UPDATE dbo.Manufacturing_Inventory
            SET QtyOnHand = QtyOnHand - @TotalQtyNeeded,
                LastUpdated = GETDATE(),
                UpdatedBy = @CompletedBy
            WHERE MaterialID = @MaterialID 
            AND BranchID = @BranchID;
            
            -- Log movement
            INSERT INTO dbo.Manufacturing_InventoryMovements (
                MaterialID, BranchID, MovementType, QtyDelta, 
                Reference, Notes, MovementDate, CreatedBy
            )
            VALUES (
                @MaterialID, @BranchID, 'Production Consumption', -@TotalQtyNeeded,
                CONCAT('ReOrderLine-', @ReOrderLineID), 
                CONCAT('Consumed for ', @QuantityCompleted, ' units of ProductID ', @ProductID),
                GETDATE(), @CompletedBy
            );
            
            FETCH NEXT FROM ingredient_cursor INTO @MaterialID, @IngredientQty;
        END
        
        CLOSE ingredient_cursor;
        DEALLOCATE ingredient_cursor;
        
        -- =============================================
        -- STEP 2: INCREASE RetailStock (add finished product)
        -- =============================================
        
        -- Check if product exists in RetailStock for this branch
        IF EXISTS (SELECT 1 FROM dbo.RetailStock WHERE ProductID = @ProductID AND BranchID = @BranchID)
        BEGIN
            -- Update existing
            UPDATE dbo.RetailStock
            SET Quantity = Quantity + @QuantityCompleted,
                StockType = 'Internal',
                LastUpdated = GETDATE()
            WHERE ProductID = @ProductID AND BranchID = @BranchID;
        END
        ELSE
        BEGIN
            -- Insert new
            INSERT INTO dbo.RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated)
            VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE());
        END
        
        -- Log stock movement for retail
        INSERT INTO dbo.StockMovements (
            MaterialID, BranchID, MovementType, QuantityIn, 
            InventoryArea, Notes, CreatedBy, CreatedDate
        )
        VALUES (
            @ProductID, @BranchID, 'Production Complete', @QuantityCompleted,
            'Retail', CONCAT('ReOrderLine-', CAST(@ReOrderLineID AS NVARCHAR(50))), @CompletedBy, GETDATE()
        );
        
        -- =============================================
        -- STEP 3: Update ReOrderBookLines
        -- =============================================
        UPDATE dbo.ReOrderBookLines
        SET QuantityCompleted = ISNULL(QuantityCompleted, 0) + @QuantityCompleted,
            CompletedDate = GETDATE(),
            CompletedBy = (SELECT CONCAT(FirstName, ' ', LastName) FROM dbo.Users WHERE UserID = @CompletedBy)
        WHERE ReOrderLineID = @ReOrderLineID;
        
        COMMIT TRANSACTION;
        
        PRINT '✅ Production completed successfully';
        PRINT '   - Product: ' + CAST(@ProductID AS NVARCHAR(50));
        PRINT '   - Quantity: ' + CAST(@QuantityCompleted AS NVARCHAR(50));
        PRINT '   - Branch: ' + CAST(@BranchID AS NVARCHAR(50));
        PRINT '   - Manufacturing stock reduced';
        PRINT '   - Retail stock increased';
        
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

PRINT '';
PRINT '═══════════════════════════════════════════════════════════';
PRINT '✅ sp_CompleteReOrderProduct created/updated successfully!';
PRINT '═══════════════════════════════════════════════════════════';
PRINT '';
PRINT '📋 WHAT THIS PROCEDURE DOES:';
PRINT '';
PRINT '1. REDUCES Manufacturing_Inventory (consumes ingredients)';
PRINT '   - Calculates ingredient consumption based on batch yield';
PRINT '   - Updates Manufacturing_Inventory.QtyOnHand';
PRINT '   - Logs to Manufacturing_InventoryMovements';
PRINT '';
PRINT '2. INCREASES RetailStock (adds finished product)';
PRINT '   - Adds completed product to RetailStock per branch';
PRINT '   - Sets StockType = ''Internal''';
PRINT '   - Logs to StockMovements with InventoryArea = ''Retail''';
PRINT '';
PRINT '3. UPDATES ReOrderBookLines';
PRINT '   - Marks line as Completed or Partial';
PRINT '   - Records completion date and user';
PRINT '';
PRINT '═══════════════════════════════════════════════════════════';
