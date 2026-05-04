-- =============================================
-- PREPARED SUB-RECIPE INVENTORY SYSTEM
-- Allows manufacturing sub-recipes ahead of time with timestamp tracking
-- Smart BOM calculation checks inventory before requesting ingredients
-- =============================================

-- Table: Prepared Sub-Recipe Inventory
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Demo_SubRecipe_Inventory')
BEGIN
    CREATE TABLE Demo_SubRecipe_Inventory (
        InventoryID INT IDENTITY(1,1) PRIMARY KEY,
        SubRecipeID INT NOT NULL,
        SubRecipeName NVARCHAR(200) NOT NULL,
        BatchNumber NVARCHAR(50) NOT NULL, -- Format: SR-BranchPrefix-YYYYMMDD-HHMMSS
        Quantity DECIMAL(18,2) NOT NULL,
        UnitOfMeasure NVARCHAR(50) NOT NULL,
        ManufacturedDate DATETIME NOT NULL DEFAULT GETDATE(),
        ManufacturedTime TIME NOT NULL DEFAULT CONVERT(TIME, GETDATE()),
        ExpiryDate DATETIME NULL, -- Optional: calculated based on shelf life
        BranchID INT NOT NULL,
        ManufacturedBy INT NOT NULL, -- UserID
        Status NVARCHAR(20) NOT NULL DEFAULT 'Available', -- Available, Consumed, Expired
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
END
GO

-- Table: Sub-Recipe Consumption Log (tracks which products used which sub-recipes)
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
END
GO

PRINT 'Sub-Recipe Inventory tables created successfully'
GO
