-- =============================================
-- RECIPE MANAGEMENT SYSTEM - DATABASE SCHEMA
-- WOW FACTOR FEATURE
-- =============================================
-- Description: Complete database schema for two-tier recipe management
--              with dynamic cost calculation and BOM consolidation
-- Author: Cascade AI Development Team
-- Date: 10 January 2026
-- =============================================

USE [OvenDelightsERP]
GO

-- =============================================
-- TABLE: Demo_SubRecipe_Master
-- Stores sub-recipe header information
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Demo_SubRecipe_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Demo_SubRecipe_Master] (
        [SubRecipeID] INT NOT NULL PRIMARY KEY,
        [Method] NVARCHAR(MAX) NULL,
        [BatchQty] DECIMAL(18,4) NOT NULL DEFAULT 1,
        [TotalCost] DECIMAL(18,4) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedBy] INT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastUpdated] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_SubRecipe_Master_Product] FOREIGN KEY ([SubRecipeID]) 
            REFERENCES [dbo].[Demo_Retail_Product]([ProductID])
    )
    
    PRINT 'Table Demo_SubRecipe_Master created successfully.'
END
ELSE
BEGIN
    PRINT 'Table Demo_SubRecipe_Master already exists.'
END
GO

-- =============================================
-- TABLE: Demo_SubRecipe_BOM
-- Stores ingredient lists for each sub-recipe
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Demo_SubRecipe_BOM]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Demo_SubRecipe_BOM] (
        [BOMLineID] INT IDENTITY(1,1) PRIMARY KEY,
        [SubRecipeID] INT NOT NULL,
        [IngredientID] INT NOT NULL,
        [Quantity] DECIMAL(18,4) NOT NULL,
        [UnitOfMeasure] VARCHAR(20) NOT NULL,
        [PackageSize] DECIMAL(18,4) NOT NULL DEFAULT 1, -- Size of purchased package (e.g., 500g)
        [CostPerUnit] DECIMAL(18,6) NOT NULL, -- Cost per smallest unit (e.g., per gram)
        [TotalCost] AS ([Quantity] * [CostPerUnit]) PERSISTED,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastUpdated] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_SubRecipe_BOM_SubRecipe] FOREIGN KEY ([SubRecipeID]) 
            REFERENCES [dbo].[Demo_Retail_Product]([ProductID]),
        CONSTRAINT [FK_SubRecipe_BOM_Ingredient] FOREIGN KEY ([IngredientID]) 
            REFERENCES [dbo].[Demo_Retail_Product]([ProductID])
    )
    
    CREATE NONCLUSTERED INDEX [IX_SubRecipe_BOM_SubRecipeID] ON [dbo].[Demo_SubRecipe_BOM] ([SubRecipeID])
    CREATE NONCLUSTERED INDEX [IX_SubRecipe_BOM_IngredientID] ON [dbo].[Demo_SubRecipe_BOM] ([IngredientID])
    
    PRINT 'Table Demo_SubRecipe_BOM created successfully.'
END
ELSE
BEGIN
    PRINT 'Table Demo_SubRecipe_BOM already exists.'
END
GO

-- =============================================
-- TABLE: Demo_Product_Recipe_Master
-- Stores product recipe header information
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Demo_Product_Recipe_Master]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Demo_Product_Recipe_Master] (
        [ProductID] INT NOT NULL PRIMARY KEY,
        [Method] NVARCHAR(MAX) NULL,
        [BatchQty] DECIMAL(18,4) NOT NULL DEFAULT 1,
        [TotalCost] DECIMAL(18,4) NULL,
        [IsActive] BIT NOT NULL DEFAULT 1,
        [CreatedBy] INT NULL,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastUpdated] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_Product_Recipe_Master_Product] FOREIGN KEY ([ProductID]) 
            REFERENCES [dbo].[Demo_Retail_Product]([ProductID])
    )
    
    PRINT 'Table Demo_Product_Recipe_Master created successfully.'
END
ELSE
BEGIN
    PRINT 'Table Demo_Product_Recipe_Master already exists.'
END
GO

-- =============================================
-- TABLE: Demo_Product_BOM
-- Stores sub-recipe and packaging lists for each product
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Demo_Product_BOM]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Demo_Product_BOM] (
        [BOMLineID] INT IDENTITY(1,1) PRIMARY KEY,
        [ProductID] INT NOT NULL,
        [ComponentType] VARCHAR(20) NOT NULL, -- 'SubRecipe' or 'Packaging'
        [ComponentID] INT NOT NULL,
        [Quantity] DECIMAL(18,4) NOT NULL,
        [CostPerUnit] DECIMAL(18,4) NOT NULL,
        [TotalCost] AS ([Quantity] * [CostPerUnit]) PERSISTED,
        [CreatedDate] DATETIME NOT NULL DEFAULT GETDATE(),
        [LastUpdated] DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT [FK_Product_BOM_Product] FOREIGN KEY ([ProductID]) 
            REFERENCES [dbo].[Demo_Retail_Product]([ProductID]),
        CONSTRAINT [FK_Product_BOM_Component] FOREIGN KEY ([ComponentID]) 
            REFERENCES [dbo].[Demo_Retail_Product]([ProductID]),
        CONSTRAINT [CK_Product_BOM_ComponentType] CHECK ([ComponentType] IN ('SubRecipe', 'Packaging'))
    )
    
    CREATE NONCLUSTERED INDEX [IX_Product_BOM_ProductID] ON [dbo].[Demo_Product_BOM] ([ProductID])
    CREATE NONCLUSTERED INDEX [IX_Product_BOM_ComponentID] ON [dbo].[Demo_Product_BOM] ([ComponentID])
    
    PRINT 'Table Demo_Product_BOM created successfully.'
END
ELSE
BEGIN
    PRINT 'Table Demo_Product_BOM already exists.'
END
GO

-- =============================================
-- VIEW: vw_SubRecipe_Details
-- Complete sub-recipe information with ingredients
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_SubRecipe_Details]'))
    DROP VIEW [dbo].[vw_SubRecipe_Details]
GO

CREATE VIEW [dbo].[vw_SubRecipe_Details]
AS
SELECT 
    sr.SubRecipeID,
    p.Name AS SubRecipeName,
    p.Category AS SubRecipeCategory,
    sr.Method,
    sr.BatchQty,
    sr.TotalCost,
    sr.IsActive,
    sr.CreatedDate,
    sr.LastUpdated,
    COUNT(DISTINCT sb.IngredientID) AS IngredientCount
FROM Demo_SubRecipe_Master sr
INNER JOIN Demo_Retail_Product p ON sr.SubRecipeID = p.ProductID
LEFT JOIN Demo_SubRecipe_BOM sb ON sr.SubRecipeID = sb.SubRecipeID
GROUP BY 
    sr.SubRecipeID, p.Name, p.Category, sr.Method, sr.BatchQty, 
    sr.TotalCost, sr.IsActive, sr.CreatedDate, sr.LastUpdated
GO

PRINT 'View vw_SubRecipe_Details created successfully.'
GO

-- =============================================
-- VIEW: vw_Product_Recipe_Details
-- Complete product recipe information with components
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Product_Recipe_Details]'))
    DROP VIEW [dbo].[vw_Product_Recipe_Details]
GO

CREATE VIEW [dbo].[vw_Product_Recipe_Details]
AS
SELECT 
    pr.ProductID,
    p.Name AS ProductName,
    p.Category AS ProductCategory,
    pr.Method,
    pr.BatchQty,
    pr.TotalCost,
    pr.IsActive,
    pr.CreatedDate,
    pr.LastUpdated,
    COUNT(DISTINCT CASE WHEN pb.ComponentType = 'SubRecipe' THEN pb.ComponentID END) AS SubRecipeCount,
    COUNT(DISTINCT CASE WHEN pb.ComponentType = 'Packaging' THEN pb.ComponentID END) AS PackagingCount
FROM Demo_Product_Recipe_Master pr
INNER JOIN Demo_Retail_Product p ON pr.ProductID = p.ProductID
LEFT JOIN Demo_Product_BOM pb ON pr.ProductID = pb.ProductID
GROUP BY 
    pr.ProductID, p.Name, p.Category, pr.Method, pr.BatchQty, 
    pr.TotalCost, pr.IsActive, pr.CreatedDate, pr.LastUpdated
GO

PRINT 'View vw_Product_Recipe_Details created successfully.'
GO

-- =============================================
-- VIEW: vw_Product_BOM_Consolidated
-- Consolidates all ingredients across sub-recipes for a product
-- =============================================
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_Product_BOM_Consolidated]'))
    DROP VIEW [dbo].[vw_Product_BOM_Consolidated]
GO

CREATE VIEW [dbo].[vw_Product_BOM_Consolidated]
AS
SELECT 
    pb.ProductID,
    p.Name AS ProductName,
    i.ProductID AS IngredientID,
    i.Name AS IngredientName,
    SUM(sb.Quantity * pb.Quantity) AS TotalQuantity,
    sb.UnitOfMeasure,
    MAX(sb.CostPerUnit) AS CostPerUnit,
    SUM(sb.Quantity * pb.Quantity * sb.CostPerUnit) AS TotalCost
FROM Demo_Product_BOM pb
INNER JOIN Demo_Retail_Product p ON pb.ProductID = p.ProductID
INNER JOIN Demo_SubRecipe_BOM sb ON pb.ComponentID = sb.SubRecipeID
INNER JOIN Demo_Retail_Product i ON sb.IngredientID = i.ProductID
WHERE pb.ComponentType = 'SubRecipe'
GROUP BY pb.ProductID, p.Name, i.ProductID, i.Name, sb.UnitOfMeasure
GO

PRINT 'View vw_Product_BOM_Consolidated created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_CheckSubRecipeExists
-- Checks if a sub-recipe has a recipe created
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CheckSubRecipeExists]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_CheckSubRecipeExists]
GO

CREATE PROCEDURE [dbo].[sp_CheckSubRecipeExists]
    @SubRecipeID INT,
    @Exists BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @SubRecipeID AND IsActive = 1)
        SET @Exists = 1
    ELSE
        SET @Exists = 0
END
GO

PRINT 'Stored Procedure sp_CheckSubRecipeExists created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_CheckProductRecipeExists
-- Checks if a product has a recipe created
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CheckProductRecipeExists]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_CheckProductRecipeExists]
GO

CREATE PROCEDURE [dbo].[sp_CheckProductRecipeExists]
    @ProductID INT,
    @Exists BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    IF EXISTS (SELECT 1 FROM Demo_Product_Recipe_Master WHERE ProductID = @ProductID AND IsActive = 1)
        SET @Exists = 1
    ELSE
        SET @Exists = 0
END
GO

PRINT 'Stored Procedure sp_CheckProductRecipeExists created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_GetIngredientCostPerUnit
-- Calculates cost per smallest unit for an ingredient
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetIngredientCostPerUnit]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_GetIngredientCostPerUnit]
GO

CREATE PROCEDURE [dbo].[sp_GetIngredientCostPerUnit]
    @IngredientID INT,
    @BranchID INT,
    @PackageSize DECIMAL(18,4),
    @CostPerUnit DECIMAL(18,6) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @LastPaidPrice DECIMAL(18,4)
    
    -- Get LastPaidPrice from Demo_Retail_Price (EXCLUDE VAT)
    SELECT TOP 1 @LastPaidPrice = ISNULL(CostPrice, 0)
    FROM Demo_Retail_Price
    WHERE ProductID = @IngredientID 
      AND BranchID = @BranchID
    ORDER BY EffectiveFrom DESC
    
    -- If no price found, default to 0
    IF @LastPaidPrice IS NULL
    BEGIN
        SET @LastPaidPrice = 0
    END
    
    -- Calculate cost per unit (e.g., R10 / 500g = R0.02/g)
    IF @PackageSize > 0
        SET @CostPerUnit = @LastPaidPrice / @PackageSize
    ELSE
        SET @CostPerUnit = @LastPaidPrice
END
GO

PRINT 'Stored Procedure sp_GetIngredientCostPerUnit created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_SaveSubRecipe
-- Saves or updates a sub-recipe with ingredients
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_SaveSubRecipe]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_SaveSubRecipe]
GO

CREATE PROCEDURE [dbo].[sp_SaveSubRecipe]
    @SubRecipeID INT,
    @Method NVARCHAR(MAX),
    @BatchQty DECIMAL(18,4),
    @CreatedBy INT,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Check if sub-recipe already exists
        IF EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @SubRecipeID)
        BEGIN
            -- Update existing
            UPDATE Demo_SubRecipe_Master
            SET Method = @Method,
                BatchQty = @BatchQty,
                LastUpdated = GETDATE()
            WHERE SubRecipeID = @SubRecipeID
            
            SET @Message = 'Sub-recipe updated successfully.'
        END
        ELSE
        BEGIN
            -- Insert new
            INSERT INTO Demo_SubRecipe_Master (SubRecipeID, Method, BatchQty, CreatedBy, IsActive)
            VALUES (@SubRecipeID, @Method, @BatchQty, @CreatedBy, 1)
            
            SET @Message = 'Sub-recipe created successfully.'
        END
        
        SET @Success = 1
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'Stored Procedure sp_SaveSubRecipe created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_SaveSubRecipeIngredient
-- Saves an ingredient to a sub-recipe BOM
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_SaveSubRecipeIngredient]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_SaveSubRecipeIngredient]
GO

CREATE PROCEDURE [dbo].[sp_SaveSubRecipeIngredient]
    @SubRecipeID INT,
    @IngredientID INT,
    @Quantity DECIMAL(18,4),
    @UnitOfMeasure VARCHAR(20),
    @PackageSize DECIMAL(18,4),
    @CostPerUnit DECIMAL(18,6),
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Check if ingredient already exists in BOM
        IF EXISTS (SELECT 1 FROM Demo_SubRecipe_BOM 
                   WHERE SubRecipeID = @SubRecipeID AND IngredientID = @IngredientID)
        BEGIN
            -- Update existing
            UPDATE Demo_SubRecipe_BOM
            SET Quantity = @Quantity,
                UnitOfMeasure = @UnitOfMeasure,
                PackageSize = @PackageSize,
                CostPerUnit = @CostPerUnit,
                LastUpdated = GETDATE()
            WHERE SubRecipeID = @SubRecipeID AND IngredientID = @IngredientID
        END
        ELSE
        BEGIN
            -- Insert new
            INSERT INTO Demo_SubRecipe_BOM (SubRecipeID, IngredientID, Quantity, UnitOfMeasure, PackageSize, CostPerUnit)
            VALUES (@SubRecipeID, @IngredientID, @Quantity, @UnitOfMeasure, @PackageSize, @CostPerUnit)
        END
        
        SET @Success = 1
        SET @Message = 'Ingredient saved successfully.'
    END TRY
    BEGIN CATCH
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'Stored Procedure sp_SaveSubRecipeIngredient created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_UpdateSubRecipeTotalCost
-- Recalculates and updates total cost for a sub-recipe
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateSubRecipeTotalCost]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_UpdateSubRecipeTotalCost]
GO

CREATE PROCEDURE [dbo].[sp_UpdateSubRecipeTotalCost]
    @SubRecipeID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalCost DECIMAL(18,4)
    
    -- Calculate total cost from all ingredients
    SELECT @TotalCost = SUM(TotalCost)
    FROM Demo_SubRecipe_BOM
    WHERE SubRecipeID = @SubRecipeID
    
    -- Update sub-recipe master
    UPDATE Demo_SubRecipe_Master
    SET TotalCost = ISNULL(@TotalCost, 0),
        LastUpdated = GETDATE()
    WHERE SubRecipeID = @SubRecipeID
END
GO

PRINT 'Stored Procedure sp_UpdateSubRecipeTotalCost created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_SaveProductRecipe
-- Saves or updates a product recipe
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_SaveProductRecipe]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_SaveProductRecipe]
GO

CREATE PROCEDURE [dbo].[sp_SaveProductRecipe]
    @ProductID INT,
    @Method NVARCHAR(MAX),
    @BatchQty DECIMAL(18,4),
    @CreatedBy INT,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Check if product recipe already exists
        IF EXISTS (SELECT 1 FROM Demo_Product_Recipe_Master WHERE ProductID = @ProductID)
        BEGIN
            -- Update existing
            UPDATE Demo_Product_Recipe_Master
            SET Method = @Method,
                BatchQty = @BatchQty,
                LastUpdated = GETDATE()
            WHERE ProductID = @ProductID
            
            SET @Message = 'Product recipe updated successfully.'
        END
        ELSE
        BEGIN
            -- Insert new
            INSERT INTO Demo_Product_Recipe_Master (ProductID, Method, BatchQty, CreatedBy, IsActive)
            VALUES (@ProductID, @Method, @BatchQty, @CreatedBy, 1)
            
            SET @Message = 'Product recipe created successfully.'
        END
        
        SET @Success = 1
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'Stored Procedure sp_SaveProductRecipe created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_SaveProductBOMComponent
-- Saves a component (sub-recipe or packaging) to product BOM
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_SaveProductBOMComponent]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_SaveProductBOMComponent]
GO

CREATE PROCEDURE [dbo].[sp_SaveProductBOMComponent]
    @ProductID INT,
    @ComponentType VARCHAR(20),
    @ComponentID INT,
    @Quantity DECIMAL(18,4),
    @CostPerUnit DECIMAL(18,4),
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Check if component already exists in BOM
        IF EXISTS (SELECT 1 FROM Demo_Product_BOM 
                   WHERE ProductID = @ProductID 
                     AND ComponentType = @ComponentType 
                     AND ComponentID = @ComponentID)
        BEGIN
            -- Update existing
            UPDATE Demo_Product_BOM
            SET Quantity = @Quantity,
                CostPerUnit = @CostPerUnit,
                LastUpdated = GETDATE()
            WHERE ProductID = @ProductID 
              AND ComponentType = @ComponentType 
              AND ComponentID = @ComponentID
        END
        ELSE
        BEGIN
            -- Insert new
            INSERT INTO Demo_Product_BOM (ProductID, ComponentType, ComponentID, Quantity, CostPerUnit)
            VALUES (@ProductID, @ComponentType, @ComponentID, @Quantity, @CostPerUnit)
        END
        
        SET @Success = 1
        SET @Message = 'Component saved successfully.'
    END TRY
    BEGIN CATCH
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'Stored Procedure sp_SaveProductBOMComponent created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_UpdateProductRecipeTotalCost
-- Recalculates and updates total cost for a product recipe
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateProductRecipeTotalCost]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_UpdateProductRecipeTotalCost]
GO

CREATE PROCEDURE [dbo].[sp_UpdateProductRecipeTotalCost]
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalCost DECIMAL(18,4)
    
    -- Calculate total cost from all components (sub-recipes + packaging)
    SELECT @TotalCost = SUM(TotalCost)
    FROM Demo_Product_BOM
    WHERE ProductID = @ProductID
    
    -- Update product recipe master
    UPDATE Demo_Product_Recipe_Master
    SET TotalCost = ISNULL(@TotalCost, 0),
        LastUpdated = GETDATE()
    WHERE ProductID = @ProductID
END
GO

PRINT 'Stored Procedure sp_UpdateProductRecipeTotalCost created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_DeleteSubRecipeIngredient
-- Deletes an ingredient from sub-recipe BOM
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteSubRecipeIngredient]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_DeleteSubRecipeIngredient]
GO

CREATE PROCEDURE [dbo].[sp_DeleteSubRecipeIngredient]
    @BOMLineID INT,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM Demo_SubRecipe_BOM WHERE BOMLineID = @BOMLineID
        SET @Success = 1
        SET @Message = 'Ingredient deleted successfully.'
    END TRY
    BEGIN CATCH
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'Stored Procedure sp_DeleteSubRecipeIngredient created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_DeleteProductBOMComponent
-- Deletes a component from product BOM
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_DeleteProductBOMComponent]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_DeleteProductBOMComponent]
GO

CREATE PROCEDURE [dbo].[sp_DeleteProductBOMComponent]
    @BOMLineID INT,
    @Success BIT OUTPUT,
    @Message NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DELETE FROM Demo_Product_BOM WHERE BOMLineID = @BOMLineID
        SET @Success = 1
        SET @Message = 'Component deleted successfully.'
    END TRY
    BEGIN CATCH
        SET @Success = 0
        SET @Message = ERROR_MESSAGE()
    END CATCH
END
GO

PRINT 'Stored Procedure sp_DeleteProductBOMComponent created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_GetConsolidatedBOM
-- Gets consolidated ingredient list for a product
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetConsolidatedBOM]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_GetConsolidatedBOM]
GO

CREATE PROCEDURE [dbo].[sp_GetConsolidatedBOM]
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Return consolidated ingredients from all sub-recipes
    SELECT 
        IngredientID,
        IngredientName,
        TotalQuantity,
        UnitOfMeasure,
        CostPerUnit,
        TotalCost
    FROM vw_Product_BOM_Consolidated
    WHERE ProductID = @ProductID
    ORDER BY IngredientName
    
    -- Also return packaging items
    SELECT 
        pb.ComponentID AS PackagingID,
        p.Name AS PackagingName,
        pb.Quantity,
        pb.CostPerUnit,
        pb.TotalCost
    FROM Demo_Product_BOM pb
    INNER JOIN Demo_Retail_Product p ON pb.ComponentID = p.ProductID
    WHERE pb.ProductID = @ProductID
      AND pb.ComponentType = 'Packaging'
    ORDER BY p.Name
END
GO

PRINT 'Stored Procedure sp_GetConsolidatedBOM created successfully.'
GO

-- =============================================
-- STORED PROCEDURE: sp_RefreshAllRecipeCosts
-- Updates all recipe costs based on current LastPaidPrice
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RefreshAllRecipeCosts]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_RefreshAllRecipeCosts]
GO

CREATE PROCEDURE [dbo].[sp_RefreshAllRecipeCosts]
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SubRecipeID INT
    DECLARE @ProductID INT
    
    -- Update all sub-recipe ingredient costs
    DECLARE subrecipe_cursor CURSOR FOR
    SELECT DISTINCT SubRecipeID FROM Demo_SubRecipe_Master WHERE IsActive = 1
    
    OPEN subrecipe_cursor
    FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Recalculate total cost
        EXEC sp_UpdateSubRecipeTotalCost @SubRecipeID
        
        FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID
    END
    
    CLOSE subrecipe_cursor
    DEALLOCATE subrecipe_cursor
    
    -- Update all product recipe costs
    DECLARE product_cursor CURSOR FOR
    SELECT DISTINCT ProductID FROM Demo_Product_Recipe_Master WHERE IsActive = 1
    
    OPEN product_cursor
    FETCH NEXT FROM product_cursor INTO @ProductID
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Recalculate total cost
        EXEC sp_UpdateProductRecipeTotalCost @ProductID
        
        FETCH NEXT FROM product_cursor INTO @ProductID
    END
    
    CLOSE product_cursor
    DEALLOCATE product_cursor
END
GO

PRINT 'Stored Procedure sp_RefreshAllRecipeCosts created successfully.'
GO

-- =============================================
-- INDEXES FOR PERFORMANCE
-- =============================================
PRINT 'Creating additional indexes for performance...'

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_SubRecipe_Master_IsActive')
    CREATE NONCLUSTERED INDEX [IX_SubRecipe_Master_IsActive] 
    ON [dbo].[Demo_SubRecipe_Master] ([IsActive]) 
    INCLUDE ([SubRecipeID], [TotalCost])
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Product_Recipe_Master_IsActive')
    CREATE NONCLUSTERED INDEX [IX_Product_Recipe_Master_IsActive] 
    ON [dbo].[Demo_Product_Recipe_Master] ([IsActive]) 
    INCLUDE ([ProductID], [TotalCost])
GO

PRINT '============================================='
PRINT 'RECIPE MANAGEMENT SCHEMA CREATED SUCCESSFULLY'
PRINT '============================================='
PRINT 'Tables Created:'
PRINT '  - Demo_SubRecipe_Master'
PRINT '  - Demo_SubRecipe_BOM'
PRINT '  - Demo_Product_Recipe_Master'
PRINT '  - Demo_Product_BOM'
PRINT ''
PRINT 'Views Created:'
PRINT '  - vw_SubRecipe_Details'
PRINT '  - vw_Product_Recipe_Details'
PRINT '  - vw_Product_BOM_Consolidated'
PRINT ''
PRINT 'Stored Procedures Created:'
PRINT '  - sp_CheckSubRecipeExists'
PRINT '  - sp_CheckProductRecipeExists'
PRINT '  - sp_GetIngredientCostPerUnit'
PRINT '  - sp_SaveSubRecipe'
PRINT '  - sp_SaveSubRecipeIngredient'
PRINT '  - sp_UpdateSubRecipeTotalCost'
PRINT '  - sp_SaveProductRecipe'
PRINT '  - sp_SaveProductBOMComponent'
PRINT '  - sp_UpdateProductRecipeTotalCost'
PRINT '  - sp_DeleteSubRecipeIngredient'
PRINT '  - sp_DeleteProductBOMComponent'
PRINT '  - sp_GetConsolidatedBOM'
PRINT '  - sp_RefreshAllRecipeCosts'
PRINT '============================================='
GO
