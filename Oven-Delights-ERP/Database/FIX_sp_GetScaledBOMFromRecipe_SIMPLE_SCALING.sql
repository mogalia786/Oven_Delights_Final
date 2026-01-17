-- =============================================
-- FIX: Simplified sp_GetScaledBOMFromRecipe
-- Logic: BOM defines quantities for 1 unit, multiply by requested quantity
-- No need for batch quantity - just scale directly
-- =============================================

IF OBJECT_ID('sp_GetScaledBOMFromRecipe', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetScaledBOMFromRecipe;
GO

CREATE PROCEDURE sp_GetScaledBOMFromRecipe
    @ProductID INT,
    @RequestedQuantity DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if this is a Product Recipe or Sub-Recipe
    DECLARE @IsProduct BIT = 0;
    DECLARE @IsSubRecipe BIT = 0;
    
    -- Check if Product Recipe exists
    IF EXISTS (SELECT 1 FROM Demo_ProductRecipe_Master WHERE ProductID = @ProductID AND IsActive = 1)
    BEGIN
        SET @IsProduct = 1;
    END
    -- Check if Sub-Recipe exists
    ELSE IF EXISTS (SELECT 1 FROM Demo_SubRecipe_Master WHERE SubRecipeID = @ProductID AND IsActive = 1)
    BEGIN
        SET @IsSubRecipe = 1;
    END
    ELSE
    BEGIN
        -- No recipe found
        RAISERROR('No recipe found for ProductID %d', 16, 1, @ProductID);
        RETURN;
    END
    
    -- Create temp table for consolidated BOM
    CREATE TABLE #ConsolidatedBOM (
        ItemID INT,
        ItemName NVARCHAR(255),
        ItemType NVARCHAR(50),
        Quantity DECIMAL(18,6),
        UnitOfMeasure NVARCHAR(50),
        CostPerUnit DECIMAL(18,6),
        TotalCost DECIMAL(18,6)
    );
    
    -- =============================================
    -- PRODUCT RECIPE: Get SUB-RECIPES + ingredients + packaging
    -- BOM quantities are for 1 unit, multiply by requested quantity
    -- =============================================
    IF @IsProduct = 1
    BEGIN
        -- STEP 1: Get sub-recipes as line items (for stock checking)
        INSERT INTO #ConsolidatedBOM (ItemID, ItemName, ItemType, Quantity, UnitOfMeasure, CostPerUnit, TotalCost)
        SELECT 
            pbl.ComponentID AS ItemID,
            p.Name AS ItemName,
            'Sub-Recipe' AS ItemType,
            pbl.Quantity * @RequestedQuantity AS Quantity,  -- BOM qty * requested qty
            'Each' AS UnitOfMeasure,
            pbl.CostPerUnit,
            pbl.Quantity * @RequestedQuantity * pbl.CostPerUnit AS TotalCost
        FROM Demo_ProductRecipe_BOM pbl
        INNER JOIN Demo_Retail_Product p ON pbl.ComponentID = p.ProductID
        WHERE pbl.ProductID = @ProductID
          AND pbl.ComponentType = 'SubRecipe'
          AND pbl.IsActive = 1;
        
        -- STEP 2: Get ingredients from all sub-recipes (for fresh manufacturing)
        -- Sub-recipe BOM quantities are also for 1 unit of sub-recipe
        INSERT INTO #ConsolidatedBOM (ItemID, ItemName, ItemType, Quantity, UnitOfMeasure, CostPerUnit, TotalCost)
        SELECT 
            sri.IngredientID AS ItemID,
            p.Name AS ItemName,
            'Ingredient' AS ItemType,
            SUM(sri.Quantity * pbl.Quantity * @RequestedQuantity) AS Quantity,  -- ingredient qty * sub-recipe qty * requested qty
            sri.UnitOfMeasure,
            sri.CostPerUnit,
            SUM(sri.Quantity * pbl.Quantity * @RequestedQuantity * sri.CostPerUnit) AS TotalCost
        FROM Demo_ProductRecipe_BOM pbl
        INNER JOIN Demo_SubRecipe_Ingredients sri ON pbl.ComponentID = sri.SubRecipeID
        INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID
        WHERE pbl.ProductID = @ProductID
          AND pbl.ComponentType = 'SubRecipe'
          AND pbl.IsActive = 1
          AND sri.IsActive = 1
        GROUP BY sri.IngredientID, p.Name, sri.UnitOfMeasure, sri.CostPerUnit;
        
        -- STEP 3: Get packaging items
        INSERT INTO #ConsolidatedBOM (ItemID, ItemName, ItemType, Quantity, UnitOfMeasure, CostPerUnit, TotalCost)
        SELECT 
            pbl.ComponentID AS ItemID,
            p.Name AS ItemName,
            'Packaging' AS ItemType,
            pbl.Quantity * @RequestedQuantity AS Quantity,  -- BOM qty * requested qty
            'unit' AS UnitOfMeasure,
            pbl.CostPerUnit,
            pbl.Quantity * @RequestedQuantity * pbl.CostPerUnit AS TotalCost
        FROM Demo_ProductRecipe_BOM pbl
        INNER JOIN Demo_Retail_Product p ON pbl.ComponentID = p.ProductID
        WHERE pbl.ProductID = @ProductID
          AND pbl.ComponentType = 'Packaging'
          AND pbl.IsActive = 1;
    END
    
    -- =============================================
    -- SUB-RECIPE: Get ingredients directly
    -- BOM quantities are for 1 unit, multiply by requested quantity
    -- =============================================
    ELSE IF @IsSubRecipe = 1
    BEGIN
        INSERT INTO #ConsolidatedBOM (ItemID, ItemName, ItemType, Quantity, UnitOfMeasure, CostPerUnit, TotalCost)
        SELECT 
            sri.IngredientID AS ItemID,
            p.Name AS ItemName,
            'Ingredient' AS ItemType,
            sri.Quantity * @RequestedQuantity AS Quantity,  -- BOM qty * requested qty
            sri.UnitOfMeasure,
            sri.CostPerUnit,
            sri.Quantity * @RequestedQuantity * sri.CostPerUnit AS TotalCost
        FROM Demo_SubRecipe_Ingredients sri
        INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID
        WHERE sri.SubRecipeID = @ProductID
          AND sri.IsActive = 1;
    END
    
    -- =============================================
    -- Return consolidated BOM with scaling applied
    -- =============================================
    SELECT 
        ItemID,
        ItemName,
        ItemType,
        CAST(Quantity AS DECIMAL(18,3)) AS Quantity,
        UnitOfMeasure,
        CAST(CostPerUnit AS DECIMAL(18,6)) AS CostPerUnit,
        CAST(TotalCost AS DECIMAL(18,2)) AS TotalCost,
        1 AS RecipeBatchQty,  -- Always 1 since BOM is for 1 unit
        @RequestedQuantity AS RequestedQty,
        @RequestedQuantity AS ScalingFactor  -- Scaling factor is just the requested quantity
    FROM #ConsolidatedBOM
    ORDER BY 
        CASE ItemType 
            WHEN 'Sub-Recipe' THEN 1
            WHEN 'Ingredient' THEN 2
            WHEN 'Packaging' THEN 3
            ELSE 4
        END,
        ItemName;
    
    -- Cleanup
    DROP TABLE #ConsolidatedBOM;
END
GO

PRINT '✅ sp_GetScaledBOMFromRecipe updated with SIMPLE SCALING logic!';
PRINT '   BOM defines quantities for 1 unit, multiply by requested quantity';
PRINT '';
PRINT '📋 LOGIC:';
PRINT '   - BOM Quantity = Amount needed for 1 unit of product';
PRINT '   - Scaled Quantity = BOM Quantity × Requested Quantity';
PRINT '   - No batch quantity needed - BOM is always for 1 unit';
GO
