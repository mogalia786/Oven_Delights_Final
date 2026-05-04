-- =============================================
-- FIX: Re-Order Book Manager Error
-- Creates Recipe Management tables
-- =============================================

PRINT '📊 Creating Recipe Management tables...';
PRINT '';

-- =============================================
-- TABLE: Demo_ProductRecipe_Master
-- =============================================
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
    
    PRINT '✅ Created Demo_ProductRecipe_Master';
END
ELSE
BEGIN
    PRINT '⚠️  Demo_ProductRecipe_Master already exists';
END
GO

-- =============================================
-- TABLE: Demo_SubRecipe_Master
-- =============================================
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
    
    PRINT '✅ Created Demo_SubRecipe_Master';
END
ELSE
BEGIN
    PRINT '⚠️  Demo_SubRecipe_Master already exists';
END
GO

-- =============================================
-- TABLE: Demo_SubRecipe_Ingredients
-- =============================================
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
    
    PRINT '✅ Created Demo_SubRecipe_Ingredients';
END
ELSE
BEGIN
    PRINT '⚠️  Demo_SubRecipe_Ingredients already exists';
END
GO

-- =============================================
-- TABLE: Demo_ProductRecipe_BOM
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Demo_ProductRecipe_BOM') AND type in (N'U'))
BEGIN
    CREATE TABLE Demo_ProductRecipe_BOM (
        BOMLineID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        ComponentID INT NOT NULL,
        ComponentType VARCHAR(20) NOT NULL, -- 'SubRecipe' or 'Packaging'
        Quantity DECIMAL(18,4) NOT NULL,
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
    
    PRINT '✅ Created Demo_ProductRecipe_BOM';
END
ELSE
BEGIN
    PRINT '⚠️  Demo_ProductRecipe_BOM already exists';
END
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ Recipe Management tables created!';
PRINT '';
PRINT 'Re-Order Book Manager should now work without errors.';
PRINT '';
PRINT 'Next steps:';
PRINT '1. Close and re-open Re-Order Book Manager';
PRINT '2. Create recipes using Recipe Management forms';
PRINT '3. Products with recipes will appear in Re-Order Book';
PRINT '═══════════════════════════════════════════════';
GO
