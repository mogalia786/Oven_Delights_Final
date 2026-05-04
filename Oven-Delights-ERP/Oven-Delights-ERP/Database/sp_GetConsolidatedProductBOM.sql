-- =============================================
-- Stored Procedure: sp_GetConsolidatedProductBOM
-- Purpose: Get consolidated BOM for a product including:
--   1. Product Recipe Components (sub-recipes, packaging, etc.)
--   2. Expanded ingredients from sub-recipes
-- This gives the complete material list needed for manufacturing
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetConsolidatedProductBOM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_GetConsolidatedProductBOM]
GO

CREATE PROCEDURE [dbo].[sp_GetConsolidatedProductBOM]
    @ProductID INT,
    @ProductionQty DECIMAL(18,4) = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get batch quantity from product recipe
    DECLARE @BatchQty DECIMAL(18,4) = 1
    SELECT @BatchQty = ISNULL(BatchQty, 1)
    FROM Demo_ProductRecipe_Master
    WHERE ProductID = @ProductID
    
    -- Calculate batches needed
    DECLARE @BatchesNeeded DECIMAL(18,4) = CEILING(@ProductionQty / @BatchQty)
    
    -- Create temp table for consolidated BOM
    CREATE TABLE #ConsolidatedBOM (
        ComponentID INT,
        ComponentName NVARCHAR(500),
        ComponentType VARCHAR(50),
        Category NVARCHAR(200),
        Quantity DECIMAL(18,4),
        UnitOfMeasure NVARCHAR(50),
        CostPerUnit DECIMAL(18,6),
        TotalCost DECIMAL(18,2)
    )
    
    -- STEP 1: Get direct components from Product Recipe BOM
    -- ONLY include packaging, consumables, and other non-SubRecipe components
    -- Sub-recipes will be expanded into their ingredients in Step 2
    INSERT INTO #ConsolidatedBOM (ComponentID, ComponentName, ComponentType, Category, Quantity, UnitOfMeasure, CostPerUnit, TotalCost)
    SELECT 
        pb.ComponentID,
        p.Name AS ComponentName,
        pb.ComponentType,
        p.Category,
        pb.Quantity * @BatchesNeeded AS Quantity,
        'unit' AS UnitOfMeasure,
        pb.CostPerUnit,
        (pb.Quantity * @BatchesNeeded * pb.CostPerUnit) AS TotalCost
    FROM Demo_ProductRecipe_BOM pb
    INNER JOIN Demo_Retail_Product p ON pb.ComponentID = p.ProductID
    WHERE pb.ProductID = @ProductID
      AND pb.IsActive = 1
      AND pb.ComponentType <> 'SubRecipe' -- Exclude sub-recipes, they will be expanded
    
    -- STEP 2: For each sub-recipe component, expand its ingredients
    -- Get all sub-recipe IDs from the product BOM
    DECLARE @SubRecipeID INT
    DECLARE @SubRecipeQty DECIMAL(18,4)
    
    DECLARE subrecipe_cursor CURSOR FOR
    SELECT ComponentID, Quantity * @BatchesNeeded
    FROM Demo_ProductRecipe_BOM
    WHERE ProductID = @ProductID
      AND ComponentType = 'SubRecipe'
      AND IsActive = 1
    
    OPEN subrecipe_cursor
    FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID, @SubRecipeQty
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get batch quantity for this sub-recipe
        DECLARE @SubRecipeBatchQty DECIMAL(18,4) = 1
        SELECT @SubRecipeBatchQty = ISNULL(BatchQty, 1)
        FROM Demo_SubRecipe_Master
        WHERE SubRecipeID = @SubRecipeID
        
        -- Calculate batches needed for this sub-recipe
        DECLARE @SubRecipeBatches DECIMAL(18,4) = CEILING(@SubRecipeQty / @SubRecipeBatchQty)
        
        -- Insert ingredients from this sub-recipe
        INSERT INTO #ConsolidatedBOM (ComponentID, ComponentName, ComponentType, Category, Quantity, UnitOfMeasure, CostPerUnit, TotalCost)
        SELECT 
            si.IngredientID,
            p.Name AS ComponentName,
            'Ingredient' AS ComponentType,
            p.Category,
            si.Quantity * @SubRecipeBatches AS Quantity,
            si.UnitOfMeasure,
            si.CostPerUnit,
            (si.Quantity * @SubRecipeBatches * si.CostPerUnit) AS TotalCost
        FROM Demo_SubRecipe_Ingredients si
        INNER JOIN Demo_Retail_Product p ON si.IngredientID = p.ProductID
        WHERE si.SubRecipeID = @SubRecipeID
          AND si.IsActive = 1
        
        FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID, @SubRecipeQty
    END
    
    CLOSE subrecipe_cursor
    DEALLOCATE subrecipe_cursor
    
    -- STEP 3: Consolidate duplicate ingredients (sum quantities)
    SELECT 
        ComponentID,
        ComponentName,
        ComponentType,
        Category,
        SUM(Quantity) AS Quantity,
        MAX(UnitOfMeasure) AS UnitOfMeasure, -- Use first unit found
        AVG(CostPerUnit) AS CostPerUnit, -- Average cost if multiple entries
        SUM(TotalCost) AS TotalCost
    FROM #ConsolidatedBOM
    GROUP BY ComponentID, ComponentName, ComponentType, Category
    ORDER BY 
        CASE ComponentType
            WHEN 'SubRecipe' THEN 1
            WHEN 'Ingredient' THEN 2
            WHEN 'Packaging' THEN 3
            WHEN 'Consumable' THEN 4
            ELSE 5
        END,
        ComponentName
    
    DROP TABLE #ConsolidatedBOM
END
GO

PRINT 'sp_GetConsolidatedProductBOM created successfully';
GO
