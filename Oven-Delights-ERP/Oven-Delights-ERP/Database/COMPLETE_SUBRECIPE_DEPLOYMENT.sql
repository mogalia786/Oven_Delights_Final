-- =============================================
-- COMPLETE SUB-RECIPE INVENTORY DEPLOYMENT
-- Runs all prerequisites and deployment in correct order
-- =============================================

PRINT '========================================='
PRINT 'COMPLETE SUB-RECIPE INVENTORY DEPLOYMENT'
PRINT '========================================='
PRINT ''

-- =============================================
-- PART 1: Create Recipe Tables (Prerequisites)
-- =============================================
PRINT 'PART 1: Creating Recipe Management tables...'
PRINT ''

-- TABLE: Demo_ProductRecipe_Master
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Demo_ProductRecipe_Master') AND type in (N'U'))
BEGIN
    CREATE TABLE Demo_ProductRecipe_Master (
        ProductID INT NOT NULL PRIMARY KEY,
        Method NVARCHAR(MAX) NULL,
        BatchQty DECIMAL(18,4) NOT NULL DEFAULT 1,
        TotalCost DECIMAL(18,4) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_ProductRecipe_Master_Product FOREIGN KEY (ProductID) 
            REFERENCES Demo_Retail_Product(ProductID)
    );
    PRINT '  ✓ Created Demo_ProductRecipe_Master'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_ProductRecipe_Master already exists'
END
GO

-- TABLE: Demo_SubRecipe_Master
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Demo_SubRecipe_Master') AND type in (N'U'))
BEGIN
    CREATE TABLE Demo_SubRecipe_Master (
        SubRecipeID INT NOT NULL PRIMARY KEY,
        Method NVARCHAR(MAX) NULL,
        BatchQty DECIMAL(18,4) NOT NULL DEFAULT 1,
        TotalCost DECIMAL(18,4) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy INT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        LastUpdated DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_SubRecipe_Master_Product FOREIGN KEY (SubRecipeID) 
            REFERENCES Demo_Retail_Product(ProductID)
    );
    PRINT '  ✓ Created Demo_SubRecipe_Master'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_SubRecipe_Master already exists'
END
GO

-- TABLE: Demo_SubRecipe_Ingredients
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Demo_SubRecipe_Ingredients') AND type in (N'U'))
BEGIN
    CREATE TABLE Demo_SubRecipe_Ingredients (
        IngredientLineID INT IDENTITY(1,1) PRIMARY KEY,
        SubRecipeID INT NOT NULL,
        IngredientID INT NOT NULL,
        Quantity DECIMAL(18,4) NOT NULL,
        UnitOfMeasure VARCHAR(20) NOT NULL,
        CostPerUnit DECIMAL(18,6) NOT NULL,
        TotalCost AS (Quantity * CostPerUnit) PERSISTED,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_SubRecipe_Ingredients_SubRecipe FOREIGN KEY (SubRecipeID) 
            REFERENCES Demo_Retail_Product(ProductID),
        CONSTRAINT FK_SubRecipe_Ingredients_Ingredient FOREIGN KEY (IngredientID) 
            REFERENCES Demo_Retail_Product(ProductID)
    );
    CREATE INDEX IX_SubRecipe_Ingredients_SubRecipeID ON Demo_SubRecipe_Ingredients(SubRecipeID);
    PRINT '  ✓ Created Demo_SubRecipe_Ingredients'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_SubRecipe_Ingredients already exists'
END
GO

-- TABLE: Demo_ProductRecipe_BOM
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Demo_ProductRecipe_BOM') AND type in (N'U'))
BEGIN
    CREATE TABLE Demo_ProductRecipe_BOM (
        BOMLineID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        ComponentID INT NOT NULL,
        ComponentType VARCHAR(20) NOT NULL,
        Quantity DECIMAL(18,4) NOT NULL,
        UnitOfMeasure NVARCHAR(50) NOT NULL DEFAULT 'Each',
        CostPerUnit DECIMAL(18,6) NOT NULL,
        TotalCost AS (Quantity * CostPerUnit) PERSISTED,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_ProductRecipe_BOM_Product FOREIGN KEY (ProductID) 
            REFERENCES Demo_Retail_Product(ProductID),
        CONSTRAINT FK_ProductRecipe_BOM_Component FOREIGN KEY (ComponentID) 
            REFERENCES Demo_Retail_Product(ProductID)
    );
    CREATE INDEX IX_ProductRecipe_BOM_ProductID ON Demo_ProductRecipe_BOM(ProductID);
    PRINT '  ✓ Created Demo_ProductRecipe_BOM'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_ProductRecipe_BOM already exists'
END
GO

PRINT ''

-- =============================================
-- PART 2: Create Re-Order Book Tables
-- =============================================
PRINT 'PART 2: Creating Re-Order Book tables...'
PRINT ''

-- TABLE: ReOrderBooks
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReOrderBooks')
BEGIN
    CREATE TABLE ReOrderBooks (
        ReOrderBookID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderNumber NVARCHAR(50) NOT NULL,
        ManufacturerUserID INT NOT NULL,
        BranchID INT NOT NULL,
        OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
        RequiredDate DATETIME NULL,
        IsUrgent BIT NOT NULL DEFAULT 0,
        Status NVARCHAR(20) NOT NULL DEFAULT 'Draft',
        Notes NVARCHAR(500) NULL,
        CreatedBy INT NOT NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        PostedDate DATETIME NULL,
        PostedBy INT NULL
    )
    CREATE INDEX IX_ReOrderBooks_Status ON ReOrderBooks(Status, BranchID)
    CREATE INDEX IX_ReOrderBooks_Manufacturer ON ReOrderBooks(ManufacturerUserID, Status)
    PRINT '  ✓ Created ReOrderBooks'
END
ELSE
BEGIN
    PRINT '  ⚠ ReOrderBooks already exists'
END
GO

-- TABLE: ReOrderBookLines
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ReOrderBookLines')
BEGIN
    CREATE TABLE ReOrderBookLines (
        ReOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
        ReOrderBookID INT NOT NULL,
        ProductID INT NOT NULL,
        ProductName NVARCHAR(200) NOT NULL,
        Barcode NVARCHAR(50) NULL,
        LineNumber INT NOT NULL,
        QuantityOrdered DECIMAL(18,2) NOT NULL,
        UnitOfMeasure NVARCHAR(50) NOT NULL DEFAULT 'Each',
        ItemType NVARCHAR(20) NOT NULL DEFAULT 'Product',
        Notes NVARCHAR(500) NULL,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_ReOrderBookLines_ReOrderBook FOREIGN KEY (ReOrderBookID) 
            REFERENCES ReOrderBooks(ReOrderBookID)
    )
    CREATE INDEX IX_ReOrderBookLines_ReOrderBook ON ReOrderBookLines(ReOrderBookID)
    CREATE INDEX IX_ReOrderBookLines_Product ON ReOrderBookLines(ProductID)
    PRINT '  ✓ Created ReOrderBookLines'
END
ELSE
BEGIN
    PRINT '  ⚠ ReOrderBookLines already exists'
    
    -- Add ItemType column if missing
    IF NOT EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('ReOrderBookLines') AND name = 'ItemType')
    BEGIN
        ALTER TABLE ReOrderBookLines ADD ItemType NVARCHAR(20) NULL DEFAULT 'Product'
        UPDATE ReOrderBookLines SET ItemType = 'Product' WHERE ItemType IS NULL
        ALTER TABLE ReOrderBookLines ALTER COLUMN ItemType NVARCHAR(20) NOT NULL
        PRINT '  ✓ Added ItemType column'
    END
END
GO

PRINT ''

-- =============================================
-- PART 3: Create Sub-Recipe Inventory Tables
-- =============================================
PRINT 'PART 3: Creating Sub-Recipe Inventory tables...'
PRINT ''

-- TABLE: Demo_SubRecipe_Inventory
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
    PRINT '  ✓ Created Demo_SubRecipe_Inventory'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_SubRecipe_Inventory already exists'
END
GO

-- TABLE: Demo_SubRecipe_Consumption_Log
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
    PRINT '  ✓ Created Demo_SubRecipe_Consumption_Log'
END
ELSE
BEGIN
    PRINT '  ⚠ Demo_SubRecipe_Consumption_Log already exists'
END
GO

PRINT ''
PRINT 'PART 4: Creating stored procedures...'
PRINT ''

-- =============================================
-- SP: Get Available Sub-Recipe Inventory
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
        i.InventoryID, i.SubRecipeID, i.SubRecipeName, i.BatchNumber,
        i.Quantity, i.UnitOfMeasure, i.ManufacturedDate, i.ManufacturedTime,
        i.ExpiryDate, i.BranchID, b.BranchName, i.ManufacturedBy,
        u.Username AS ManufacturedByName, i.Status, i.Notes,
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
    FROM Demo_SubRecipe_Inventory i
        INNER JOIN Branches b ON i.BranchID = b.BranchID
        LEFT JOIN Users u ON i.ManufacturedBy = u.UserID
    WHERE i.Status = 'Available'
        AND (@SubRecipeID IS NULL OR i.SubRecipeID = @SubRecipeID)
        AND (@BranchID IS NULL OR i.BranchID = @BranchID)
    ORDER BY i.SubRecipeName, i.ManufacturedDate ASC
END
GO

PRINT '  ✓ sp_GetAvailableSubRecipeInventory created'
GO

-- =============================================
-- SP: Add Sub-Recipe to Inventory
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
        
        DECLARE @SubRecipeName NVARCHAR(200)
        SELECT @SubRecipeName = Name FROM Demo_Retail_Product WHERE ProductID = @SubRecipeID
        
        DECLARE @BranchPrefix NVARCHAR(10)
        SELECT @BranchPrefix = ISNULL(Prefix, 'BR') FROM Branches WHERE BranchID = @BranchID
        
        SET @BatchNumber = 'SR-' + @BranchPrefix + '-' + FORMAT(GETDATE(), 'yyyyMMdd-HHmmss')
        
        -- Deduct ingredients from stock
        DECLARE @IngredientID INT, @IngredientQty DECIMAL(18,2), @IngredientName NVARCHAR(200), @CurrentStock DECIMAL(18,2)
        
        DECLARE ingredient_cursor CURSOR FOR
        SELECT sri.IngredientID, sri.Quantity * @Quantity, p.Name
        FROM Demo_SubRecipe_Ingredients sri
        INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID
        WHERE sri.SubRecipeID = @SubRecipeID
        
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
                SET @Message = 'Insufficient stock: ' + @IngredientName
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
            @SubRecipeID, @SubRecipeName, @BatchNumber, @Quantity, 'Batch',
            GETDATE(), CONVERT(TIME, GETDATE()), @BranchID, @ManufacturedBy, 'Available', @Notes
        )
        
        SET @Success = 1
        SET @Message = 'Sub-recipe added to inventory. Batch: ' + @BatchNumber
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        SET @Success = 0
        SET @Message = 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO

PRINT '  ✓ sp_AddSubRecipeToInventory created'
GO

-- =============================================
-- SP: Consume Sub-Recipe from Inventory (FIFO)
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
        
        DECLARE @InventoryID INT, @AvailableQty DECIMAL(18,2), @QtyToConsume DECIMAL(18,2)
        
        DECLARE inventory_cursor CURSOR FOR
        SELECT InventoryID, Quantity
        FROM Demo_SubRecipe_Inventory
        WHERE SubRecipeID = @SubRecipeID AND BranchID = @BranchID AND Status = 'Available'
        ORDER BY ManufacturedDate ASC
        
        OPEN inventory_cursor
        FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty
        
        WHILE @@FETCH_STATUS = 0 AND @QuantityConsumed < @QuantityNeeded
        BEGIN
            SET @QtyToConsume = CASE 
                WHEN (@QuantityNeeded - @QuantityConsumed) <= @AvailableQty 
                THEN (@QuantityNeeded - @QuantityConsumed)
                ELSE @AvailableQty
            END
            
            IF @QtyToConsume >= @AvailableQty
            BEGIN
                UPDATE Demo_SubRecipe_Inventory
                SET Status = 'Consumed', ConsumedDate = GETDATE(), ConsumedBy = @ConsumedBy, Quantity = 0
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
            VALUES (@InventoryID, @ProductID, @ProductName, @ReOrderBookID, @QtyToConsume, GETDATE(), @ConsumedBy, @BranchID)
            
            SET @QuantityConsumed = @QuantityConsumed + @QtyToConsume
            FETCH NEXT FROM inventory_cursor INTO @InventoryID, @AvailableQty
        END
        
        CLOSE inventory_cursor
        DEALLOCATE inventory_cursor
        
        IF @QuantityConsumed >= @QuantityNeeded
        BEGIN
            SET @Success = 1
            SET @Message = 'Consumed ' + CAST(@QuantityConsumed AS NVARCHAR(50)) + ' from inventory'
        END
        ELSE
        BEGIN
            SET @Success = 0
            SET @Message = 'Insufficient inventory'
            ROLLBACK TRANSACTION
            RETURN
        END
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        SET @Success = 0
        SET @Message = 'Error: ' + ERROR_MESSAGE()
    END CATCH
END
GO

PRINT '  ✓ sp_ConsumeSubRecipeFromInventory created'
GO

-- =============================================
-- SP: Get Draft Re-Order Books
-- =============================================
PRINT '  Creating sp_GetDraftReOrderBooks...'
GO

CREATE OR ALTER PROCEDURE sp_GetDraftReOrderBooks
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        rb.ReOrderBookID,
        rb.ReOrderNumber,
        rb.Status,
        rb.OrderDate,
        rb.RequiredDate,
        rb.IsUrgent,
        u.FirstName + ' ' + u.LastName AS ManufacturerName,
        COUNT(DISTINCT rbl.ProductID) AS TotalProducts,
        ISNULL(SUM(rbl.QuantityOrdered), 0) AS TotalQuantity
    FROM ReOrderBooks rb
    LEFT JOIN Users u ON rb.ManufacturerUserID = u.UserID
    LEFT JOIN ReOrderBookLines rbl ON rb.ReOrderBookID = rbl.ReOrderBookID
    WHERE rb.Status = 'Draft'
      AND rb.BranchID = @BranchID
    GROUP BY rb.ReOrderBookID, rb.ReOrderNumber, rb.Status, rb.OrderDate, 
             rb.RequiredDate, rb.IsUrgent, u.FirstName, u.LastName
    ORDER BY rb.OrderDate DESC
END
GO

PRINT '  ✓ sp_GetDraftReOrderBooks created'
GO

-- =============================================
-- SP: Create Re-Order Book
-- =============================================
PRINT '  Creating sp_CreateReOrderBook...'
GO

CREATE OR ALTER PROCEDURE sp_CreateReOrderBook
    @BranchID INT,
    @ManufacturerUserID INT,
    @OrderDate DATETIME,
    @RequiredDate DATETIME,
    @CreatedBy NVARCHAR(100),
    @IsUrgent BIT,
    @Notes NVARCHAR(500),
    @ReOrderBookID INT OUTPUT,
    @ReOrderNumber NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BranchPrefix NVARCHAR(10)
    SELECT @BranchPrefix = ISNULL(Prefix, 'BR') FROM Branches WHERE BranchID = @BranchID
    
    SET @ReOrderNumber = 'RO-' + @BranchPrefix + '-' + FORMAT(GETDATE(), 'yyyyMMdd-HHmmss')
    
    INSERT INTO ReOrderBooks (
        ReOrderNumber, ManufacturerUserID, BranchID, OrderDate, RequiredDate,
        IsUrgent, Status, Notes, CreatedBy, CreatedDate
    )
    VALUES (
        @ReOrderNumber, @ManufacturerUserID, @BranchID, @OrderDate, @RequiredDate,
        @IsUrgent, 'Draft', @Notes, @ManufacturerUserID, GETDATE()
    )
    
    SET @ReOrderBookID = SCOPE_IDENTITY()
END
GO

PRINT '  ✓ sp_CreateReOrderBook created'
GO

PRINT ''
PRINT '========================================='
PRINT '✓ DEPLOYMENT COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'All tables and procedures created successfully!'
PRINT ''
PRINT 'Tables created:'
PRINT '  - Recipe Management (4 tables)'
PRINT '  - Re-Order Books (2 tables)'
PRINT '  - Sub-Recipe Inventory (2 tables)'
PRINT ''
PRINT 'Stored Procedures created:'
PRINT '  - sp_GetAvailableSubRecipeInventory'
PRINT '  - sp_AddSubRecipeToInventory'
PRINT '  - sp_ConsumeSubRecipeFromInventory'
PRINT '  - sp_GetDraftReOrderBooks'
PRINT '  - sp_CreateReOrderBook'
PRINT ''
GO
