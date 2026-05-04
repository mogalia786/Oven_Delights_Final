-- =============================================
-- Add Sub-Recipe to Inventory WITH GL POSTING
-- Called when baker completes sub-recipe production
-- 1. Deducts ingredients from manufacturing stock
-- 2. Adds sub-recipe to inventory
-- 3. Posts GL entries (DR Manufacturing Inventory, CR Raw Materials)
-- 4. Updates sub-recipe cost in Demo_Retail_Product
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
        
        SET @BatchNumber = 'BATCH-' + @BranchPrefix + '-' + 
                          FORMAT(GETDATE(), 'yyyyMMdd-HHmmss')
        
        -- Track total ingredient cost for GL posting
        DECLARE @TotalIngredientCost DECIMAL(18,2) = 0
        DECLARE @SubRecipeTotalCost DECIMAL(18,2) = 0
        
        -- Deduct ingredients from manufacturing stock and calculate cost
        DECLARE @IngredientID INT, @IngredientQty DECIMAL(18,2), @IngredientName NVARCHAR(200)
        DECLARE @CurrentStock DECIMAL(18,2), @IngredientUnitCost DECIMAL(18,2), @IngredientLineCost DECIMAL(18,2)
        
        DECLARE ingredient_cursor CURSOR FOR
        SELECT 
            sri.IngredientID,
            sri.Quantity * @Quantity AS TotalQtyNeeded,
            p.Name,
            ISNULL(p.AverageCost, ISNULL(p.LastPaidPrice, 0)) AS UnitCost
        FROM 
            Demo_SubRecipe_Ingredients sri
            INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID
        WHERE 
            sri.SubRecipeID = @SubRecipeID
        
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
        
        -- Calculate sub-recipe unit cost
        DECLARE @SubRecipeUnitCost DECIMAL(18,2) = 0
        IF @Quantity > 0
            SET @SubRecipeUnitCost = @TotalIngredientCost / @Quantity
        
        SET @SubRecipeTotalCost = @TotalIngredientCost
        
        -- Add to sub-recipe inventory
        DECLARE @CurrentDateTime DATETIME = GETDATE()
        
        INSERT INTO Demo_SubRecipe_Inventory (
            SubRecipeID,
            SubRecipeName,
            BatchNumber,
            Quantity,
            UnitOfMeasure,
            UnitCost,
            TotalCost,
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
            @SubRecipeUnitCost,
            @SubRecipeTotalCost,
            @CurrentDateTime,
            CONVERT(TIME, @CurrentDateTime),
            @BranchID,
            @ManufacturedBy,
            'Available',
            @Notes
        )
        
        -- Update sub-recipe cost in Demo_Retail_Product
        UPDATE Demo_Retail_Product
        SET 
            AverageCost = @SubRecipeUnitCost,
            LastPaidPrice = @SubRecipeUnitCost,
            LastUpdated = GETDATE()
        WHERE ProductID = @SubRecipeID AND BranchID = @BranchID
        
        -- POST GL ENTRIES
        -- Only post if we have GL infrastructure (check if Journals table exists)
        IF OBJECT_ID('dbo.Journals', 'U') IS NOT NULL AND 
           OBJECT_ID('dbo.sp_CreateJournalEntry', 'P') IS NOT NULL
        BEGIN
            DECLARE @JournalID INT
            DECLARE @FiscalPeriodID INT = 1 -- Default, should be calculated from date
            DECLARE @JournalReference NVARCHAR(50) = 'SUB-' + @BatchNumber
            DECLARE @JournalDescription NVARCHAR(255) = 'Sub-Recipe Manufacturing: ' + @SubRecipeName + ' (Qty: ' + CAST(@Quantity AS NVARCHAR(20)) + ')'
            
            -- Create journal entry
            EXEC sp_CreateJournalEntry 
                @JournalDate = @CurrentDateTime,
                @Reference = @JournalReference,
                @Description = @JournalDescription,
                @FiscalPeriodID = @FiscalPeriodID,
                @BranchID = @BranchID,
                @CreatedBy = @ManufacturedBy,
                @JournalID = @JournalID OUTPUT
            
            -- Get account IDs for Manufacturing Inventory (1410) and Raw Materials Inventory (1400)
            DECLARE @ManufacturingInventoryAccountID INT
            DECLARE @RawMaterialsInventoryAccountID INT
            
            SELECT @ManufacturingInventoryAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1410' -- Manufacturing Inventory (WIP)
            
            SELECT @RawMaterialsInventoryAccountID = AccountID 
            FROM ChartOfAccounts 
            WHERE AccountCode = '1400' -- Raw Materials Inventory
            
            -- If accounts exist, post the entries
            IF @ManufacturingInventoryAccountID IS NOT NULL AND @RawMaterialsInventoryAccountID IS NOT NULL
            BEGIN
                -- DR: Manufacturing Inventory (1410) - Sub-recipe value
                DECLARE @DescriptionDR NVARCHAR(255) = 'Sub-Recipe Manufactured: ' + @SubRecipeName
                EXEC sp_AddJournalDetail
                    @JournalID = @JournalID,
                    @AccountID = @ManufacturingInventoryAccountID,
                    @Debit = @SubRecipeTotalCost,
                    @Credit = 0,
                    @Description = @DescriptionDR
                
                -- CR: Raw Materials Inventory (1400) - Ingredient costs
                DECLARE @DescriptionCR NVARCHAR(255) = 'Ingredients consumed for: ' + @SubRecipeName
                EXEC sp_AddJournalDetail
                    @JournalID = @JournalID,
                    @AccountID = @RawMaterialsInventoryAccountID,
                    @Debit = 0,
                    @Credit = @TotalIngredientCost,
                    @Description = @DescriptionCR
                
                -- Auto-post the journal
                EXEC sp_PostJournal
                    @JournalID = @JournalID,
                    @PostedBy = @ManufacturedBy
            END
        END
        
        SET @Success = 1
        SET @Message = 'Sub-recipe added to inventory successfully. Batch: ' + @BatchNumber + 
                      ' | Unit Cost: R' + CAST(@SubRecipeUnitCost AS NVARCHAR(20)) + 
                      ' | Total Cost: R' + CAST(@SubRecipeTotalCost AS NVARCHAR(20))
        
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

PRINT 'sp_AddSubRecipeToInventory WITH GL POSTING created successfully'
GO
