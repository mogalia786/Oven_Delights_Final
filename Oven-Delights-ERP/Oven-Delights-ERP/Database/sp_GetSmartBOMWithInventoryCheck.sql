-- =============================================
-- Smart BOM Calculation with Sub-Recipe Inventory Check
-- Checks available sub-recipe inventory first, then calculates net ingredient requirements
-- =============================================
CREATE OR ALTER PROCEDURE sp_GetSmartBOMWithInventoryCheck
    @ProductID INT,
    @QuantityRequired DECIMAL(18,2),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Temp table to hold final BOM requirements
    CREATE TABLE #SmartBOM (
        ItemType NVARCHAR(20), -- 'SubRecipe' or 'Ingredient'
        ItemID INT,
        ItemName NVARCHAR(200),
        QuantityRequired DECIMAL(18,2),
        QuantityInStock DECIMAL(18,2),
        NetQuantityNeeded DECIMAL(18,2),
        UnitOfMeasure NVARCHAR(50),
        Status NVARCHAR(50), -- 'InStock', 'PartialStock', 'OutOfStock'
        Notes NVARCHAR(500)
    )
    
    -- Step 1: Get product recipe BOM (sub-recipes needed)
    INSERT INTO #SmartBOM (ItemType, ItemID, ItemName, QuantityRequired, QuantityInStock, NetQuantityNeeded, UnitOfMeasure, Status, Notes)
    SELECT 
        'SubRecipe' AS ItemType,
        bom.ComponentID AS ItemID,
        p.Name AS ItemName,
        (bom.Quantity * @QuantityRequired) AS QuantityRequired,
        ISNULL(
            (SELECT SUM(Quantity) 
             FROM Demo_SubRecipe_Inventory 
             WHERE SubRecipeID = bom.ComponentID 
               AND BranchID = @BranchID 
               AND Status = 'Available'), 0
        ) AS QuantityInStock,
        CASE 
            WHEN ISNULL(
                (SELECT SUM(Quantity) 
                 FROM Demo_SubRecipe_Inventory 
                 WHERE SubRecipeID = bom.ComponentID 
                   AND BranchID = @BranchID 
                   AND Status = 'Available'), 0
            ) >= (bom.Quantity * @QuantityRequired) 
            THEN 0 -- Fully in stock
            ELSE (bom.Quantity * @QuantityRequired) - ISNULL(
                (SELECT SUM(Quantity) 
                 FROM Demo_SubRecipe_Inventory 
                 WHERE SubRecipeID = bom.ComponentID 
                   AND BranchID = @BranchID 
                   AND Status = 'Available'), 0
            ) -- Net quantity needed
        END AS NetQuantityNeeded,
        bom.UnitOfMeasure AS UnitOfMeasure,
        CASE 
            WHEN ISNULL(
                (SELECT SUM(Quantity) 
                 FROM Demo_SubRecipe_Inventory 
                 WHERE SubRecipeID = bom.ComponentID 
                   AND BranchID = @BranchID 
                   AND Status = 'Available'), 0
            ) >= (bom.Quantity * @QuantityRequired) 
            THEN 'InStock'
            WHEN ISNULL(
                (SELECT SUM(Quantity) 
                 FROM Demo_SubRecipe_Inventory 
                 WHERE SubRecipeID = bom.ComponentID 
                   AND BranchID = @BranchID 
                   AND Status = 'Available'), 0
            ) > 0 
            THEN 'PartialStock'
            ELSE 'OutOfStock'
        END AS Status,
        CASE 
            WHEN ISNULL(
                (SELECT SUM(Quantity) 
                 FROM Demo_SubRecipe_Inventory 
                 WHERE SubRecipeID = bom.ComponentID 
                   AND BranchID = @BranchID 
                   AND Status = 'Available'), 0
            ) >= (bom.Quantity * @QuantityRequired) 
            THEN 'Will use from prepared inventory'
            WHEN ISNULL(
                (SELECT SUM(Quantity) 
                 FROM Demo_SubRecipe_Inventory 
                 WHERE SubRecipeID = bom.ComponentID 
                   AND BranchID = @BranchID 
                   AND Status = 'Available'), 0
            ) > 0 
            THEN 'Partial stock available - will manufacture ' + 
                 CAST((bom.Quantity * @QuantityRequired) - ISNULL(
                     (SELECT SUM(Quantity) 
                      FROM Demo_SubRecipe_Inventory 
                      WHERE SubRecipeID = bom.ComponentID 
                        AND BranchID = @BranchID 
                        AND Status = 'Available'), 0
                 ) AS NVARCHAR(50)) + ' ' + bom.UnitOfMeasure
            ELSE 'Not in stock - will manufacture all'
        END AS Notes
    FROM 
        Demo_ProductRecipe_BOM bom
        INNER JOIN Demo_Retail_Product p ON bom.ComponentID = p.ProductID
    WHERE 
        bom.ProductID = @ProductID
        AND bom.ComponentType = 'SubRecipe'
        AND bom.IsActive = 1
    
    -- Step 2: For sub-recipes NOT fully in stock, get their ingredient requirements
    DECLARE @SubRecipeID INT, @NetQtyNeeded DECIMAL(18,2)
    
    DECLARE subrecipe_cursor CURSOR FOR
    SELECT ItemID, NetQuantityNeeded 
    FROM #SmartBOM 
    WHERE ItemType = 'SubRecipe' AND NetQuantityNeeded > 0
    
    OPEN subrecipe_cursor
    FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID, @NetQtyNeeded
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Add ingredients for this sub-recipe
        INSERT INTO #SmartBOM (ItemType, ItemID, ItemName, QuantityRequired, QuantityInStock, NetQuantityNeeded, UnitOfMeasure, Status, Notes)
        SELECT 
            'Ingredient' AS ItemType,
            sri.IngredientID AS ItemID,
            p.Name AS ItemName,
            (sri.Quantity * @NetQtyNeeded) AS QuantityRequired,
            ISNULL(p.CurrentStock, 0) AS QuantityInStock,
            CASE 
                WHEN ISNULL(p.CurrentStock, 0) >= (sri.Quantity * @NetQtyNeeded) 
                THEN 0
                ELSE (sri.Quantity * @NetQtyNeeded) - ISNULL(p.CurrentStock, 0)
            END AS NetQuantityNeeded,
            sri.UnitOfMeasure AS UnitOfMeasure,
            CASE 
                WHEN ISNULL(p.CurrentStock, 0) >= (sri.Quantity * @NetQtyNeeded) 
                THEN 'InStock'
                WHEN ISNULL(p.CurrentStock, 0) > 0 
                THEN 'PartialStock'
                ELSE 'OutOfStock'
            END AS Status,
            'For sub-recipe: ' + (SELECT Name FROM Demo_Retail_Product WHERE ProductID = @SubRecipeID) AS Notes
        FROM 
            Demo_SubRecipe_Ingredients sri
            INNER JOIN Demo_Retail_Product p ON sri.IngredientID = p.ProductID AND p.BranchID = @BranchID
        WHERE 
            sri.SubRecipeID = @SubRecipeID
        
        FETCH NEXT FROM subrecipe_cursor INTO @SubRecipeID, @NetQtyNeeded
    END
    
    CLOSE subrecipe_cursor
    DEALLOCATE subrecipe_cursor
    
    -- Step 3: Add direct ingredients (packaging, etc.) from product BOM
    INSERT INTO #SmartBOM (ItemType, ItemID, ItemName, QuantityRequired, QuantityInStock, NetQuantityNeeded, UnitOfMeasure, Status, Notes)
    SELECT 
        'Ingredient' AS ItemType,
        bom.ComponentID AS ItemID,
        p.Name AS ItemName,
        (bom.Quantity * @QuantityRequired) AS QuantityRequired,
        ISNULL(p.CurrentStock, 0) AS QuantityInStock,
        CASE 
            WHEN ISNULL(p.CurrentStock, 0) >= (bom.Quantity * @QuantityRequired) 
            THEN 0
            ELSE (bom.Quantity * @QuantityRequired) - ISNULL(p.CurrentStock, 0)
        END AS NetQuantityNeeded,
        bom.UnitOfMeasure AS UnitOfMeasure,
        CASE 
            WHEN ISNULL(p.CurrentStock, 0) >= (bom.Quantity * @QuantityRequired) 
            THEN 'InStock'
            WHEN ISNULL(p.CurrentStock, 0) > 0 
            THEN 'PartialStock'
            ELSE 'OutOfStock'
        END AS Status,
        'Direct ingredient for product' AS Notes
    FROM 
        Demo_ProductRecipe_BOM bom
        INNER JOIN Demo_Retail_Product p ON bom.ComponentID = p.ProductID AND p.BranchID = @BranchID
    WHERE 
        bom.ProductID = @ProductID
        AND bom.ComponentType <> 'SubRecipe'
    
    -- Return consolidated BOM
    SELECT 
        ItemType,
        ItemID,
        ItemName,
        QuantityRequired,
        QuantityInStock,
        NetQuantityNeeded,
        UnitOfMeasure,
        Status,
        Notes,
        -- Color coding for UI
        CASE Status
            WHEN 'InStock' THEN 'Green'
            WHEN 'PartialStock' THEN 'Orange'
            WHEN 'OutOfStock' THEN 'Red'
        END AS ColorCode
    FROM 
        #SmartBOM
    ORDER BY 
        ItemType DESC, -- SubRecipes first
        Status, -- InStock first
        ItemName
    
    DROP TABLE #SmartBOM
END
GO

PRINT 'sp_GetSmartBOMWithInventoryCheck created successfully'
GO
