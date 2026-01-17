-- =============================================
-- CREATE MISSING RECIPE STORED PROCEDURES
-- These are needed for saving recipe data
-- =============================================

PRINT '📊 Creating missing recipe stored procedures...';
PRINT '';

-- =============================================
-- sp_SaveSubRecipeIngredient
-- =============================================
IF OBJECT_ID('sp_SaveSubRecipeIngredient', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveSubRecipeIngredient;
GO

CREATE PROCEDURE sp_SaveSubRecipeIngredient
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
        -- Delete existing ingredient if it exists (to avoid duplicates)
        DELETE FROM Demo_SubRecipe_Ingredients
        WHERE SubRecipeID = @SubRecipeID 
          AND IngredientID = @IngredientID;
        
        -- Insert the ingredient
        INSERT INTO Demo_SubRecipe_Ingredients (
            SubRecipeID,
            IngredientID,
            Quantity,
            UnitOfMeasure,
            PackageSize,
            CostPerUnit,
            IsActive,
            CreatedDate
        )
        VALUES (
            @SubRecipeID,
            @IngredientID,
            @Quantity,
            @UnitOfMeasure,
            @PackageSize,
            @CostPerUnit,
            1,
            GETDATE()
        );
        
        SET @Success = 1;
        SET @Message = 'Ingredient saved successfully';
    END TRY
    BEGIN CATCH
        SET @Success = 0;
        SET @Message = ERROR_MESSAGE();
    END CATCH
END
GO

PRINT '✅ Created sp_SaveSubRecipeIngredient';
GO

-- =============================================
-- sp_SaveSubRecipe
-- =============================================
IF OBJECT_ID('sp_SaveSubRecipe', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveSubRecipe;
GO

CREATE PROCEDURE sp_SaveSubRecipe
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
        -- Check if recipe already exists
        IF EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @SubRecipeID)
        BEGIN
            -- Update existing
            UPDATE Demo_SubRecipe_Master
            SET Method = @Method,
                BatchQty = @BatchQty,
                LastUpdated = GETDATE(),
                IsActive = 1
            WHERE SubRecipeID = @SubRecipeID;
            
            SET @Success = 1;
            SET @Message = 'Sub-recipe updated successfully';
        END
        ELSE
        BEGIN
            -- Insert new
            INSERT INTO Demo_SubRecipe_Master (
                SubRecipeID,
                Method,
                BatchQty,
                IsActive,
                CreatedBy,
                CreatedDate,
                LastUpdated
            )
            VALUES (
                @SubRecipeID,
                @Method,
                @BatchQty,
                1,
                @CreatedBy,
                GETDATE(),
                GETDATE()
            );
            
            SET @Success = 1;
            SET @Message = 'Sub-recipe created successfully';
        END
    END TRY
    BEGIN CATCH
        SET @Success = 0;
        SET @Message = ERROR_MESSAGE();
    END CATCH
END
GO

PRINT '✅ Created sp_SaveSubRecipe';
GO

-- =============================================
-- sp_SaveProductRecipe
-- =============================================
IF OBJECT_ID('sp_SaveProductRecipe', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveProductRecipe;
GO

CREATE PROCEDURE sp_SaveProductRecipe
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
        -- Check if recipe already exists
        IF EXISTS (SELECT 1 FROM Demo_ProductRecipe_Master WHERE ProductID = @ProductID)
        BEGIN
            -- Update existing
            UPDATE Demo_ProductRecipe_Master
            SET Method = @Method,
                BatchQty = @BatchQty,
                LastUpdated = GETDATE(),
                IsActive = 1
            WHERE ProductID = @ProductID;
            
            SET @Success = 1;
            SET @Message = 'Product recipe updated successfully';
        END
        ELSE
        BEGIN
            -- Insert new
            INSERT INTO Demo_ProductRecipe_Master (
                ProductID,
                Method,
                BatchQty,
                IsActive,
                CreatedBy,
                CreatedDate,
                LastUpdated
            )
            VALUES (
                @ProductID,
                @Method,
                @BatchQty,
                1,
                @CreatedBy,
                GETDATE(),
                GETDATE()
            );
            
            SET @Success = 1;
            SET @Message = 'Product recipe created successfully';
        END
    END TRY
    BEGIN CATCH
        SET @Success = 0;
        SET @Message = ERROR_MESSAGE();
    END CATCH
END
GO

PRINT '✅ Created sp_SaveProductRecipe';
GO

-- =============================================
-- sp_SaveProductRecipeBOM
-- =============================================
IF OBJECT_ID('sp_SaveProductRecipeBOM', 'P') IS NOT NULL
    DROP PROCEDURE sp_SaveProductRecipeBOM;
GO

CREATE PROCEDURE sp_SaveProductRecipeBOM
    @ProductID INT,
    @ComponentID INT,
    @ComponentType VARCHAR(20),
    @Quantity DECIMAL(18,4),
    @CostPerUnit DECIMAL(18,6)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Delete existing component if it exists (to avoid duplicates)
        DELETE FROM Demo_ProductRecipe_BOM
        WHERE ProductID = @ProductID 
          AND ComponentID = @ComponentID
          AND ComponentType = @ComponentType;
        
        -- Insert the component
        INSERT INTO Demo_ProductRecipe_BOM (
            ProductID,
            ComponentID,
            ComponentType,
            Quantity,
            CostPerUnit,
            IsActive,
            CreatedDate
        )
        VALUES (
            @ProductID,
            @ComponentID,
            @ComponentType,
            @Quantity,
            @CostPerUnit,
            1,
            GETDATE()
        );
        
        SELECT 'SUCCESS' AS Result;
    END TRY
    BEGIN CATCH
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END
GO

PRINT '✅ Created sp_SaveProductRecipeBOM';
GO

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ All recipe stored procedures created!';
PRINT '';
PRINT 'Now you can:';
PRINT '1. Save sub-recipes with ingredients';
PRINT '2. Save product recipes with sub-recipes and packaging';
PRINT '3. Generate BOM requisitions from saved recipes';
PRINT '';
PRINT 'Try saving the Sub Batter - Madeira Slab recipe again.';
PRINT '═══════════════════════════════════════════════';
GO
