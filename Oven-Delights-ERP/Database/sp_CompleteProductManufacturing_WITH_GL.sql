-- =============================================
-- Complete Product Manufacturing WITH GL POSTING
-- Called when manufacturer completes final product
-- 1. Consumes sub-recipes from Demo_SubRecipe_Inventory
-- 2. Consumes direct ingredients from manufacturing stock
-- 3. Adds finished product to retail stock
-- 4. Posts GL entries (DR Finished Goods, CR Manufacturing Inventory + Raw Materials)
-- 5. Updates product cost in Demo_Retail_Product
-- =============================================
CREATE OR ALTER PROCEDURE sp_CompleteProductManufacturing
    @ProductID INT,
    @Quantity DECIMAL(18,2),
    @BranchID INT,
    @ManufacturedBy INT,
    @ReOrderBookID INT = NULL,
    @Notes NVARCHAR(500) = NULL,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validate product exists
        IF NOT EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE ProductID = @ProductID AND IsActive = 1)
        BEGIN
            SET @Success = 0
            SET @Message = 'Product not found or inactive'
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- Get product details
        DECLARE @ProductName NVARCHAR(200)
        SELECT @ProductName = Name
        FROM Demo_Retail_Product 
        WHERE ProductID = @ProductID
        
        -- Track total costs for GL posting
        DECLARE @TotalSubRecipeCost DECIMAL(18,2) = 0
        DECLARE @TotalIngredientCost DECIMAL(18,2) = 0
        DECLARE @TotalProductCost DECIMAL(18,2) = 0
        
        -- Get recipe details
        DECLARE @RecipeID INT
        SELECT TOP 1 @RecipeID = RecipeID 
        FROM Demo_Product_Recipes 
        WHERE ProductID = @ProductID AND IsActive = 1
        ORDER BY CreatedDate DESC
        
        IF @RecipeID IS NULL
        BEGIN
            SET @Success = 0
            SET @Message = 'No active recipe found for product: ' + @ProductName
            ROLLBACK TRANSACTION
            RETURN
        END
        
        -- ========================================
        -- STEP 1: Consume Sub-Recipes
        -- ========================================
        DECLARE @SubRecipeID INT, @SubRecipeQty DECIMAL(18,2), @SubRecipeName NVARCHAR(200)
        DECLARE @SubRecipeUnitCost DECIMAL(18,2), @SubRecipeLineCost DECIMAL(18,2)
        
        DECLARE subrecipe_cursor CURSOR FOR
        SELECT 
            ri.IngredientID,
            ri.Quantity * @Quantity AS TotalQtyNeeded,
            p.Name,
            ISNULL(p.AverageCost, ISNULL(p.LastPaidPrice, 0)) AS UnitCost
        FROM 
            Demo_Recipe_Ingredients ri
            INNER JOIN Demo_Retail_Product p ON ri.IngredientID = p.ProductID
        WHERE 
            ri.RecipeID = @RecipeID
            AND ri.IngredientType = 'SubRecipe'
        
        OPEN subrecipe_cursor
        FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID, @SubRecipeQty, @SubRecipeName, @SubRecipeUnitCost
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Consume sub-recipe from inventory using FIFO
            DECLARE @ConsumeSuccess BIT, @ConsumeMessage NVARCHAR(500)
            
            EXEC sp_ConsumeSubRecipeFromInventory
                @SubRecipeID = @SubRecipeID,
                @QuantityNeeded = @SubRecipeQty,
                @BranchID = @BranchID,
                @UserID = @ManufacturedBy,
                @ReOrderBookID = @ReOrderBookID,
                @Success = @ConsumeSuccess OUTPUT,
                @Message = @ConsumeMessage OUTPUT
            
            IF @ConsumeSuccess = 0
            BEGIN
                SET @Success = 0
                SET @Message = 'Failed to consume sub-recipe: ' + @SubRecipeName + '. ' + @ConsumeMessage
                CLOSE subrecipe_cursor
                DEALLOCATE subrecipe_cursor
                ROLLBACK TRANSACTION
                RETURN
            END
            
            -- Calculate sub-recipe cost
            SET @SubRecipeLineCost = @SubRecipeQty * @SubRecipeUnitCost
            SET @TotalSubRecipeCost = @TotalSubRecipeCost + @SubRecipeLineCost
            
            FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID, @SubRecipeQty, @SubRecipeName, @SubRecipeUnitCost
        END
        
        CLOSE subrecipe_cursor
        DEALLOCATE subrecipe_cursor
        
        -- ========================================
        -- STEP 2: Consume Direct Ingredients
        -- ========================================
        DECLARE @IngredientID INT, @IngredientQty DECIMAL(18,2), @IngredientName NVARCHAR(200)
        DECLARE @CurrentStock DECIMAL(18,2), @IngredientUnitCost DECIMAL(18,2), @IngredientLineCost DECIMAL(18,2)
        
        DECLARE ingredient_cursor CURSOR FOR
        SELECT 
            ri.IngredientID,
            ri.Quantity * @Quantity AS TotalQtyNeeded,
            p.Name,
            ISNULL(p.AverageCost, ISNULL(p.LastPaidPrice, 0)) AS UnitCost
        FROM 
            Demo_Recipe_Ingredients ri
            INNER JOIN Demo_Retail_Product p ON ri.IngredientID = p.ProductID
        WHERE 
            ri.RecipeID = @RecipeID
            AND ri.IngredientType = 'Ingredient'
        
        OPEN ingredient_cursor
        FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientQty, @IngredientName, @IngredientUnitCost
        
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
            
            -- Calculate ingredient line cost
            SET @IngredientLineCost = @IngredientQty * @IngredientUnitCost
            SET @TotalIngredientCost = @TotalIngredientCost + @IngredientLineCost
            
            -- Deduct from manufacturing stock
            UPDATE Demo_Retail_Product
            SET CurrentStock = CurrentStock - @IngredientQty
            WHERE ProductID = @IngredientID AND BranchID = @BranchID
            
            FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientQty, @IngredientName, @IngredientUnitCost
        END
        
        CLOSE ingredient_cursor
        DEALLOCATE ingredient_cursor
        
        -- Calculate total product cost and unit cost
        SET @TotalProductCost = @TotalSubRecipeCost + @TotalIngredientCost
        DECLARE @ProductUnitCost DECIMAL(18,2) = 0
        IF @Quantity > 0
            SET @ProductUnitCost = @TotalProductCost / @Quantity
        
        -- ========================================
        -- STEP 3: Add to Retail Stock (Finished Goods)
        -- ========================================
        UPDATE Demo_Retail_Product
        SET 
            CurrentStock = ISNULL(CurrentStock, 0) + @Quantity,
            AverageCost = @ProductUnitCost,
            LastPaidPrice = @ProductUnitCost,
            LastUpdated = GETDATE()
        WHERE ProductID = @ProductID AND BranchID = @BranchID
        
        -- ========================================
        -- STEP 4: POST GL ENTRIES
        -- ========================================
        IF OBJECT_ID('dbo.Journals', 'U') IS NOT NULL AND 
           OBJECT_ID('dbo.sp_CreateJournalEntry', 'P') IS NOT NULL
        BEGIN
            DECLARE @JournalID INT
            DECLARE @FiscalPeriodID INT = 1
            DECLARE @CurrentDateTime DATETIME = GETDATE()
            DECLARE @JournalReference NVARCHAR(50) = 'PROD-' + CAST(@ProductID AS NVARCHAR(20)) + '-' + FORMAT(@CurrentDateTime, 'yyyyMMddHHmmss')
            DECLARE @JournalDescription NVARCHAR(255) = 'Product Manufacturing: ' + @ProductName + ' (Qty: ' + CAST(@Quantity AS NVARCHAR(20)) + ')'
            
            -- Create journal entry
            EXEC sp_CreateJournalEntry 
                @JournalDate = @CurrentDateTime,
                @Reference = @JournalReference,
                @Description = @JournalDescription,
                @FiscalPeriodID = @FiscalPeriodID,
                @BranchID = @BranchID,
                @CreatedBy = @ManufacturedBy,
                @JournalID = @JournalID OUTPUT
            
            -- Get account IDs
            DECLARE @FinishedGoodsAccountID INT
            DECLARE @ManufacturingInventoryAccountID INT
            DECLARE @RawMaterialsInventoryAccountID INT
            
            SELECT @FinishedGoodsAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1420' -- Finished Goods Inventory
            
            SELECT @ManufacturingInventoryAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1410' -- Manufacturing Inventory (WIP)
            
            SELECT @RawMaterialsInventoryAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1400' -- Raw Materials Inventory
            
            -- Post GL entries
            IF @FinishedGoodsAccountID IS NOT NULL
            BEGIN
                -- DR: Finished Goods Inventory (1420) - Total product value
                DECLARE @DescProductDR NVARCHAR(255) = 'Product Manufactured: ' + @ProductName
                EXEC sp_AddJournalDetail
                    @JournalID = @JournalID,
                    @AccountID = @FinishedGoodsAccountID,
                    @Debit = @TotalProductCost,
                    @Credit = 0,
                    @Description = @DescProductDR
                
                -- CR: Manufacturing Inventory (1410) - Sub-recipe costs
                IF @ManufacturingInventoryAccountID IS NOT NULL AND @TotalSubRecipeCost > 0
                BEGIN
                    DECLARE @DescSubRecipeCR NVARCHAR(255) = 'Sub-recipes consumed for: ' + @ProductName
                    EXEC sp_AddJournalDetail
                        @JournalID = @JournalID,
                        @AccountID = @ManufacturingInventoryAccountID,
                        @Debit = 0,
                        @Credit = @TotalSubRecipeCost,
                        @Description = @DescSubRecipeCR
                END
                
                -- CR: Raw Materials Inventory (1400) - Direct ingredient costs
                IF @RawMaterialsInventoryAccountID IS NOT NULL AND @TotalIngredientCost > 0
                BEGIN
                    DECLARE @DescIngredientCR NVARCHAR(255) = 'Direct ingredients consumed for: ' + @ProductName
                    EXEC sp_AddJournalDetail
                        @JournalID = @JournalID,
                        @AccountID = @RawMaterialsInventoryAccountID,
                        @Debit = 0,
                        @Credit = @TotalIngredientCost,
                        @Description = @DescIngredientCR
                END
                
                -- Auto-post the journal
                EXEC sp_PostJournal
                    @JournalID = @JournalID,
                    @PostedBy = @ManufacturedBy
            END
        END
        
        SET @Success = 1
        SET @Message = 'Product manufactured successfully: ' + @ProductName + 
                      ' | Qty: ' + CAST(@Quantity AS NVARCHAR(20)) +
                      ' | Unit Cost: R' + CAST(@ProductUnitCost AS NVARCHAR(20)) + 
                      ' | Total Cost: R' + CAST(@TotalProductCost AS NVARCHAR(20))
        
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

PRINT 'sp_CompleteProductManufacturing WITH GL POSTING created successfully'
GO
