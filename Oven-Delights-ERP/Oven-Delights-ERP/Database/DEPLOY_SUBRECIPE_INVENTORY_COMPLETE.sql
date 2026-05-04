-- =============================================
-- COMPLETE DEPLOYMENT SCRIPT
-- Prepared Sub-Recipe Inventory System
-- Run this single script to deploy everything
-- =============================================

PRINT '========================================='
PRINT 'DEPLOYING SUB-RECIPE INVENTORY SYSTEM'
PRINT '========================================='
PRINT ''

-- =============================================
-- STEP 1: Create Inventory Tables
-- =============================================
PRINT 'STEP 1: Creating inventory tables...'

-- Table: Prepared Sub-Recipe Inventory
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_SubRecipe_Inventory')
BEGIN
    CREATE TABLE Demo_SubRecipe_Inventory (
        InventoryID INT IDENTITY(1,1) PRIMARY KEY,
        SubRecipeID INT NOT NULL,
        SubRecipeName NVARCHAR(200) NOT NULL,
        BatchNumber NVARCHAR(50) NOT NULL,
        Quantity DECIMAL(18,2) NOT NULL,
        UnitOfMeasure NVARCHAR(50) NOT NULL,
        ManufacturedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ManufacturedTime TIME NOT NULL DEFAULT CONVERT(TIME, GETDATE()),
        ExpiryDate DATETIME NULL,
        BranchID INT NOT NULL,
        ManufacturedBy INT NOT NULL,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Available',
        ConsumedDate DATETIME NULL,
        ConsumedBy INT NULL,
        Notes NVARCHAR(500) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_SubRecipeInventory_SubRecipe FOREIGN KEY (SubRecipeID) 
            REFERENCES Demo_SubRecipe_Master(SubRecipeID)
    )
    
    CREATE INDEX IX_SubRecipeInventory_SubRecipe ON Demo_SubRecipe_Inventory(SubRecipeID, BranchID, Status)
    CREATE INDEX IX_SubRecipeInventory_Date ON Demo_SubRecipe_Inventory(ManufacturedDate, Status)
    CREATE INDEX IX_SubRecipeInventory_Batch ON Demo_SubRecipe_Inventory(BatchNumber)
    
    PRINT '  ✓ Demo_SubRecipe_Inventory created'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_SubRecipe_Inventory already exists'
END
GO

-- Table: Sub-Recipe Consumption Log
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_SubRecipe_Consumption_Log')
BEGIN
    CREATE TABLE Demo_SubRecipe_Consumption_Log (
        LogID INT IDENTITY(1,1) PRIMARY KEY,
        InventoryID INT NOT NULL,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(200) NOT NULL,
        ReOrderBookID INT NULL,
        QuantityConsumed DECIMAL(18,2) NOT NULL,
        ConsumedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ConsumedBy INT NOT NULL,
        BranchID INT NOT NULL,
        CONSTRAINT FK_SubRecipeConsumption_Inventory FOREIGN KEY (InventoryID) 
            REFERENCES Demo_SubRecipe_Inventory(InventoryID)
    )
    
    CREATE INDEX IX_SubRecipeConsumption_Product ON Demo_SubRecipe_Consumption_Log(ProductID, ConsumedDate)
    CREATE INDEX IX_SubRecipeConsumption_Inventory ON Demo_SubRecipe_Consumption_Log(InventoryID)
    
    PRINT '  ✓ Demo_SubRecipe_Consumption_Log created'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_SubRecipe_Consumption_Log already exists'
END
GO

PRINT ''

-- =============================================
-- STEP 2: Add ItemType to ReOrderBookLines
-- =============================================
PRINT 'STEP 2: Adding ItemType column to ReOrderBookLines...'

IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('ReOrderBookLines') 
    AND name = 'ItemType'
)
BEGIN
    ALTER TABLE ReOrderBookLines
    ADD ItemType NVARCHAR(20) NULL DEFAULT 'Product'
    
    UPDATE ReOrderBookLines
    SET ItemType = 'Product'
    WHERE ItemType IS NULL
    
    ALTER TABLE ReOrderBookLines
    ALTER COLUMN ItemType NVARCHAR(20) NOT NULL
    
    PRINT '  ✓ ItemType column added'
END
ELSE
BEGIN
    PRINT '  ⚠ ItemType column already exists'
END
GO

PRINT ''
PRINT 'STEP 3: Creating stored procedures...'
PRINT ''

-- =============================================
-- SP 1: Get Available Sub-Recipe Inventory
-- =============================================
PRINT '  Creating sp_GetAvailableSubRecipeInventory...'
GO

CREATE OR ALTER PROCEDURE sp_GetAvailableSubRecipeInventory
    @SubRecipeID INT = NULL,
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.InventoryID,
        i.SubRecipeID,
        i.SubRecipeName,
        i.BatchNumber,
        i.Quantity,
        i.UnitOfMeasure,
        i.ManufacturedDate,
        i.ManufacturedTime,
        i.ExpiryDate,
        i.BranchID,
        b.BranchName,
        i.ManufacturedBy,
        u.Username AS ManufacturedByName,
        i.Status,
        i.Notes,
        DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) AS AgeInHours,
        DATEDIFF(DAY, i.ManufacturedDate, GETDATE()) AS AgeInDays,
        CASE 
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 24 THEN 'VeryFresh'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 48 THEN 'Fresh'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 72 THEN 'Good'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 120 THEN 'Aging'
            WHEN DATEDIFF(HOUR, i.ManufacturedDate, GETDATE()) <= 168 THEN 'Old'
            ELSE 'VeryOld'
        END AS FreshnessLevel,
        ROW_NUMBER() OVER (PARTITION BY i.SubRecipeID, i.BranchID ORDER BY i.ManufacturedDate ASC) AS ConsumptionPriority
    FROM 
        Demo_SubRecipe_Inventory i
        INNER JOIN Branches b ON i.BranchID = b.BranchID
        LEFT JOIN Users u ON i.ManufacturedBy = u.UserID
    WHERE 
        i.Status = 'Available'
        AND (@SubRecipeID IS NULL OR i.SubRecipeID = @SubRecipeID)
        AND (@BranchID IS NULL OR i.BranchID = @BranchID)
    ORDER BY 
        i.SubRecipeName,
        i.ManufacturedDate ASC
END
GO

PRINT '  ✓ sp_GetAvailableSubRecipeInventory created'
GO

-- =============================================
-- SP 2: Add Sub-Recipe to Inventory
-- =============================================
PRINT '  Creating sp_AddSubRecipeToInventory...'
GO

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
        IF NOT EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @SubRecipeID AND IsActive = 1)
        BEGIN
            SET @Success = 0
            SET @Message = 'Sub-recipe not found or inactive'
            ROLLBACK TRANSACTION
            RETURN
        END
        
        DECLARE @SubRecipeName NVARCHAR(200), @UnitOfMeasure NVARCHAR(50)
        SELECT @SubRecipeName = Name, @UnitOfMeasure = 'Batch'
        FROM Demo_Retail_Product 
        WHERE ProductID = @SubRecipeID
        
        DECLARE @BranchPrefix NVARCHAR(10)
        SELECT @BranchPrefix = ISNULL(Prefix, 'BR')
        FROM Branches 
        WHERE BranchID = @BranchID
        
        SET @BatchNumber = 'SR-' + @BranchPrefix + '-' + FORMAT(GETDATE(), 'yyyyMMdd-HHmmss')
        
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
            
            UPDATE Demo_Retail_Product
            SET CurrentStock = CurrentStock - @IngredientQty
            WHERE ProductID = @IngredientID AND BranchID = @BranchID
            
            FETCH NEXT FROM ingredient_cursor INTO @IngredientID, @IngredientQty, @IngredientName
        END
        
        CLOSE ingredient_cursor
        DEALLOCATE ingredient_cursor
        
        INSERT INTO Demo_SubRecipe_Inventory (
            SubRecipeID, SubRecipeName, BatchNumber, Quantity, UnitOfMeasure,
            ManufacturedDate, ManufacturedTime, BranchID, ManufacturedBy, Status, Notes
        )
        VALUES (
            @SubRecipeID, @SubRecipeName, @BatchNumber, @Quantity, @UnitOfMeasure,
            GETDATE(), CONVERT(TIME, GETDATE()), @BranchID, @ManufacturedBy, 'Available', @Notes
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

PRINT '  ✓ sp_AddSubRecipeToInventory created'
GO

-- =============================================
-- SP 3: Consume Sub-Recipe from Inventory
-- =============================================
PRINT '  Creating sp_ConsumeSubRecipeFromInventory...'
GO

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
        
        DECLARE @InventoryID INT, @AvailableQty DECIMAL(18,2), @BatchNumber NVARCHAR(50)
        
        DECLARE inventory_cursor CURSOR FOR
        SELECT InventoryID, Quantity, BatchNumber
        FROM Demo_SubRecipe_Inventory
        WHERE SubRecipeID = @SubRecipeID 
          AND BranchID = @BranchID 
          AND Status = 'Available'
        ORDER BY ManufacturedDate ASC
        
        OPEN inventory_cursor
        FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty, @BatchNumber
        
        WHILE @@FETCH_STATUS = 0 AND @QuantityConsumed < @QuantityNeeded
        BEGIN
            DECLARE @QtyToConsume DECIMAL(18,2)
            
            IF (@QuantityNeeded - @QuantityConsumed) <= @AvailableQty
            BEGIN
                SET @QtyToConsume = @QuantityNeeded - @QuantityConsumed
            END
            ELSE
            BEGIN
                SET @QtyToConsume = @AvailableQty
            END
            
            IF @QtyToConsume >= @AvailableQty
            BEGIN
                UPDATE Demo_SubRecipe_Inventory
                SET Status = 'Consumed',
                    ConsumedDate = GETDATE(),
                    ConsumedBy = @ConsumedBy,
                    Quantity = 0
                WHERE InventoryID = @InventoryID
            END
            ELSE
            BEGIN
                UPDATE Demo_SubRecipe_Inventory
                SET Quantity = Quantity - @QtyToConsume
                WHERE InventoryID = @InventoryID
            END
            
            INSERT INTO Demo_SubRecipe_Consumption_Log (
                InventoryID, ProductID, ProductName, ReOrderBookID,
                QuantityConsumed, ConsumedDate, ConsumedBy, BranchID
            )
            VALUES (
                @InventoryID, @ProductID, @ProductName, @ReOrderBookID,
                @QtyToConsume, GETDATE(), @ConsumedBy, @BranchID
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

PRINT '  ✓ sp_ConsumeSubRecipeFromInventory created'
GO

PRINT ''
PRINT '========================================='
PRINT '✓ DEPLOYMENT COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'Next steps:'
PRINT '1. Rebuild your application'
PRINT '2. Test Re-Order Book Manager (sub-recipe dropdown)'
PRINT '3. View Sub-Recipe Inventory Report'
PRINT ''
GO
