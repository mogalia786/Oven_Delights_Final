-- =============================================
-- COMPLETE INVENTORY FLOW DEPLOYMENT
-- Run this script on Azure SQL to implement full inventory consumption
-- =============================================

PRINT '=========================================='
PRINT 'DEPLOYING COMPLETE INVENTORY FLOW'
PRINT '=========================================='
PRINT ''

-- =============================================
-- STEP 1: Fix ReOrderBooks Status Constraint
-- =============================================
PRINT 'STEP 1: Fixing ReOrderBooks Status Constraint...'
GO

-- Drop existing constraint
IF EXISTS (SELECT * FROM sys.check_constraints WHERE name = 'CK_ReOrderBooks_Status')
BEGIN
    ALTER TABLE ReOrderBooks DROP CONSTRAINT CK_ReOrderBooks_Status
    PRINT '  Dropped existing constraint CK_ReOrderBooks_Status'
END
GO

-- Add corrected constraint
ALTER TABLE ReOrderBooks
ADD CONSTRAINT CK_ReOrderBooks_Status 
CHECK (Status IN ('Posted', 'Pending', 'Completed'))
GO

PRINT '  Added constraint: Status IN (Posted, Pending, Completed)'
PRINT '  Step 1 completed successfully'
PRINT ''
GO

-- =============================================
-- STEP 2: Fix sp_CreateReOrderBook
-- =============================================
PRINT 'STEP 2: Fixing sp_CreateReOrderBook...'
GO

CREATE OR ALTER PROCEDURE sp_CreateReOrderBook
    @ProductID INT,
    @Quantity DECIMAL(18,2),
    @BranchID INT,
    @CreatedBy INT,
    @ManufacturerUserID INT = NULL,
    @ReOrderBookID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO ReOrderBooks (
            ProductID,
            Quantity,
            BranchID,
            Status,
            CreatedBy,
            CreatedDate,
            ManufacturerUserID
        )
        VALUES (
            @ProductID,
            @Quantity,
            @BranchID,
            'Posted',  -- Changed from 'Pending' to 'Posted'
            @CreatedBy,
            GETDATE(),
            @ManufacturerUserID
        );
        
        SET @ReOrderBookID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '  sp_CreateReOrderBook updated - initial status set to Posted'
PRINT '  Step 2 completed successfully'
PRINT ''
GO

-- =============================================
-- STEP 3: Fix sp_StartReOrderBook
-- =============================================
PRINT 'STEP 3: Fixing sp_StartReOrderBook...'
GO

CREATE OR ALTER PROCEDURE sp_StartReOrderBook
    @ReOrderBookID INT,
    @ManufacturerUserID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        UPDATE ReOrderBooks
        SET Status = 'Pending',  -- Changed from 'In Production' to 'Pending'
            ManufacturerUserID = @ManufacturerUserID,
            StartedDate = GETDATE()
        WHERE ReOrderBookID = @ReOrderBookID;
        
        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '  sp_StartReOrderBook updated - status set to Pending'
PRINT '  Step 3 completed successfully'
PRINT ''
GO

-- =============================================
-- STEP 4: Create sp_ConsumeIngredientsFromManufacturing
-- =============================================
PRINT 'STEP 4: Creating sp_ConsumeIngredientsFromManufacturing...'
GO

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
            AND p.Category LIKE '%ingredient%';
        
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
            SELECT @CurrentStock = CurrentStock
            FROM Demo_Retail_Product
            WHERE ProductID = @IngredientID AND BranchID = @BranchID;
            
            IF @CurrentStock IS NULL OR @CurrentStock < @QuantityNeeded
            BEGIN
                CLOSE ingredient_cursor;
                DEALLOCATE ingredient_cursor;
                ROLLBACK TRANSACTION;
                RAISERROR('Insufficient stock for ingredient: %s. Required: %.2f, Available: %.2f', 16, 1, 
                    @IngredientName, @QuantityNeeded, ISNULL(@CurrentStock, 0));
                RETURN;
            END
            
            UPDATE Demo_Retail_Product
            SET CurrentStock = CurrentStock - @QuantityNeeded,
                LastUpdated = GETDATE()
            WHERE ProductID = @IngredientID AND BranchID = @BranchID;
            
            INSERT INTO Demo_Retail_StockMovements (
                ProductID, BranchID, MovementType, Quantity, UnitOfMeasure,
                MovementDate, ReferenceType, ReferenceID, Notes, CreatedBy, CreatedDate
            )
            VALUES (
                @IngredientID, @BranchID, 'Consumption', -@QuantityNeeded, @UnitOfMeasure,
                GETDATE(), 'Production', @ReOrderBookID,
                'Ingredient consumed for production - ReOrderBook: ' + CAST(@ReOrderBookID AS NVARCHAR(50)),
                @UserID, GETDATE()
            );
            
            FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientName, @QuantityNeeded, @UnitOfMeasure;
        END
        
        CLOSE ingredient_cursor;
        DEALLOCATE ingredient_cursor;
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '  sp_ConsumeIngredientsFromManufacturing created successfully'
PRINT '  Step 4 completed successfully'
PRINT ''
GO

-- =============================================
-- STEP 5: Update sp_ConsumeSubRecipeFromInventory
-- =============================================
PRINT 'STEP 5: Updating sp_ConsumeSubRecipeFromInventory...'
GO

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
    BEGIN TRY
        BEGIN TRANSACTION;
        
        DECLARE @SubRecipesNeeded TABLE (
            SubRecipeID INT,
            SubRecipeName NVARCHAR(255),
            QuantityPerProduct DECIMAL(18,2),
            TotalQuantityNeeded DECIMAL(18,2)
        );
        
        IF @SubRecipeID IS NOT NULL
        BEGIN
            INSERT INTO @SubRecipesNeeded (SubRecipeID, SubRecipeName, QuantityPerProduct, TotalQuantityNeeded)
            SELECT 
                bd.IngredientID, p.Name, bd.Quantity, bd.Quantity * @QuantityNeeded
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
            INSERT INTO @SubRecipesNeeded (SubRecipeID, SubRecipeName, QuantityPerProduct, TotalQuantityNeeded)
            SELECT 
                bd.IngredientID, p.Name, bd.Quantity, bd.Quantity * @QuantityNeeded
            FROM 
                BOMDetails bd
                INNER JOIN Demo_Retail_Product p ON bd.IngredientID = p.ProductID
            WHERE 
                bd.ProductID = @ProductID
                AND bd.IsActive = 1
                AND (p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%');
        END
        
        IF NOT EXISTS (SELECT 1 FROM @SubRecipesNeeded)
        BEGIN
            COMMIT TRANSACTION;
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
                
                IF (@CurrentQuantityNeeded - @QuantityConsumed) <= @AvailableQty
                    SET @QtyToConsume = @CurrentQuantityNeeded - @QuantityConsumed;
                ELSE
                    SET @QtyToConsume = @AvailableQty;
                
                IF @QtyToConsume >= @AvailableQty
                BEGIN
                    UPDATE Demo_SubRecipe_Inventory
                    SET Status = 'Consumed', ConsumedDate = GETDATE(),
                        ConsumedBy = @UserID, Quantity = 0
                    WHERE InventoryID = @InventoryID;
                END
                ELSE
                BEGIN
                    UPDATE Demo_SubRecipe_Inventory
                    SET Quantity = Quantity - @QtyToConsume
                    WHERE InventoryID = @InventoryID;
                END
                
                INSERT INTO Demo_SubRecipe_Consumption_Log (
                    InventoryID, ProductID, ProductName, ReOrderBookID,
                    QuantityConsumed, ConsumedDate, ConsumedBy, BranchID
                )
                VALUES (
                    @InventoryID, @ProductID,
                    (SELECT Name FROM Demo_Retail_Product WHERE ProductID = @ProductID),
                    @ReOrderBookID, @QtyToConsume, GETDATE(), @UserID, @BranchID
                );
                
                SET @QuantityConsumed = @QuantityConsumed + @QtyToConsume;
                
                FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber;
            END
            
            CLOSE inventory_cursor;
            DEALLOCATE inventory_cursor;
            
            IF @QuantityConsumed < @CurrentQuantityNeeded
            BEGIN
                CLOSE subrecipe_cursor;
                DEALLOCATE subrecipe_cursor;
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
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '  sp_ConsumeSubRecipeFromInventory updated successfully'
PRINT '  Step 5 completed successfully'
PRINT ''
GO

-- =============================================
-- STEP 6: Update sp_GetSubRecipeInventoryReport
-- =============================================
PRINT 'STEP 6: Updating sp_GetSubRecipeInventoryReport...'
GO

CREATE OR ALTER PROCEDURE sp_GetSubRecipeInventoryReport
    @BranchID INT = NULL,
    @SubRecipeID INT = NULL,
    @FreshnessFilter NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.InventoryID, i.SubRecipeID, i.SubRecipeName, i.BatchNumber,
        i.Quantity, i.UnitOfMeasure, i.ManufacturedDate,
        FORMAT(i.ManufacturedDate, 'yyyy-MM-dd') AS ManufacturedDateFormatted,
        i.ManufacturedTime,
        FORMAT(CAST(i.ManufacturedTime AS DATETIME), 'HH:mm:ss') AS ManufacturedTimeFormatted,
        i.ExpiryDate, i.BranchID, b.BranchName, b.Prefix AS BranchPrefix,
        i.ManufacturedBy,
        ISNULL(baker.FirstName + ' ' + baker.LastName, u.Username) AS BakerName,
        u.Username AS ManufacturedByName,
        i.Status, i.Notes,
        DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) AS AgeInHours,
        DATEDIFF(DAY, i.ManufacturedDate, GETDATE()) AS AgeInDays,
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'Very Fresh'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Fresh'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'Good'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Aging'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Old'
            ELSE 'Very Old'
        END AS FreshnessLevel,
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'DarkGreen'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Green'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'LightGreen'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Yellow'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Orange'
            ELSE 'Red'
        END AS ColorCode,
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN '0,100,0'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN '0,128,0'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN '144,238,144'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN '255,255,0'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN '255,165,0'
            ELSE '255,0,0'
        END AS RGBColor,
        ROW_NUMBER() OVER (PARTITION BY i.SubRecipeID, i.BranchID ORDER BY i.ManufacturedDate ASC) AS FIFOPriority,
        (SELECT COUNT(*) FROM Demo_SubRecipe_Consumption_Log WHERE InventoryID = i.InventoryID) AS TimesUsed,
        (SELECT SUM(QuantityConsumed) FROM Demo_SubRecipe_Consumption_Log WHERE InventoryID = i.InventoryID) AS TotalQuantityUsed
    FROM 
        Demo_SubRecipe_Inventory i
        INNER JOIN Branches b ON i.BranchID = b.BranchID
        LEFT JOIN Users u ON i.ManufacturedBy = u.UserID
        LEFT JOIN ReOrderBooks rb ON TRY_CAST(
            SUBSTRING(i.BatchNumber, 
                CHARINDEX('-', i.BatchNumber) + 1, 
                CHARINDEX('-', i.BatchNumber, CHARINDEX('-', i.BatchNumber) + 1) - CHARINDEX('-', i.BatchNumber) - 1
            ) AS INT
        ) = rb.ReOrderBookID
        LEFT JOIN Users baker ON rb.ManufacturerUserID = baker.UserID
    WHERE 
        i.Status = 'Available'
        AND (@BranchID IS NULL OR i.BranchID = @BranchID)
        AND (@SubRecipeID IS NULL OR i.SubRecipeID = @SubRecipeID)
        AND (@FreshnessFilter IS NULL OR 
            CASE 
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'Very Fresh'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Fresh'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'Good'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Aging'
                WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Old'
                ELSE 'Very Old'
            END = @FreshnessFilter
        )
    ORDER BY 
        i.SubRecipeName, i.ManufacturedDate ASC
END
GO

PRINT '  sp_GetSubRecipeInventoryReport updated - now shows Baker name'
PRINT '  Step 6 completed successfully'
PRINT ''
GO

-- =============================================
-- DEPLOYMENT COMPLETE
-- =============================================
PRINT '=========================================='
PRINT 'DEPLOYMENT COMPLETED SUCCESSFULLY'
PRINT '=========================================='
PRINT ''
PRINT 'Summary of changes:'
PRINT '  1. Fixed ReOrderBooks status constraint (Posted, Pending, Completed)'
PRINT '  2. Fixed sp_CreateReOrderBook - initial status = Posted'
PRINT '  3. Fixed sp_StartReOrderBook - status = Pending'
PRINT '  4. Created sp_ConsumeIngredientsFromManufacturing'
PRINT '  5. Updated sp_ConsumeSubRecipeFromInventory - handles all BOM sub-recipes'
PRINT '  6. Updated sp_GetSubRecipeInventoryReport - shows Baker name'
PRINT ''
PRINT 'Inventory flow now complete:'
PRINT '  ✓ Sub-recipe manufacturing consumes ingredients'
PRINT '  ✓ Product manufacturing consumes sub-recipes and ingredients'
PRINT '  ✓ All inventory movements are logged'
PRINT '  ✓ FIFO consumption for sub-recipes'
PRINT ''
GO
