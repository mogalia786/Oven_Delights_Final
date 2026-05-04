-- =============================================
-- Smart BOM Calculator with Sub-Recipe Stock Check
-- Checks available sub-recipe inventory and calculates adjusted ingredient requirements
-- =============================================
CREATE OR ALTER PROCEDURE sp_GetSmartBOMWithSubRecipeCheck
    @ProductID INT,
    @QuantityRequired DECIMAL(18,2),
    @BranchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Get BOM items for the product
    SELECT 
        bl.ItemID,
        p.ProductID,
        p.Name AS ItemName,
        p.Category,
        bl.Quantity AS QuantityPerBatch,
        bh.BatchSize,
        (bl.Quantity / bh.BatchSize) * @QuantityRequired AS TotalQuantityNeeded,
        p.UnitOfMeasure,
        -- Check if item is a sub-recipe
        CASE 
            WHEN p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%' THEN 1 
            ELSE 0 
        END AS IsSubRecipe,
        -- Get available sub-recipe stock
        CASE 
            WHEN p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%' 
            THEN ISNULL((
                SELECT SUM(Quantity) 
                FROM Demo_SubRecipe_Inventory 
                WHERE SubRecipeID = bl.ItemID 
                  AND BranchID = @BranchID 
                  AND Status = 'Available'
            ), 0)
            ELSE 0 
        END AS AvailableStock,
        -- Calculate how many can be fulfilled from stock
        CASE 
            WHEN p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%' 
            THEN 
                CASE 
                    WHEN ISNULL((
                        SELECT SUM(Quantity) 
                        FROM Demo_SubRecipe_Inventory 
                        WHERE SubRecipeID = bl.ItemID 
                          AND BranchID = @BranchID 
                          AND Status = 'Available'
                    ), 0) >= (bl.Quantity / bh.BatchSize) * @QuantityRequired
                    THEN (bl.Quantity / bh.BatchSize) * @QuantityRequired -- Enough in stock
                    ELSE ISNULL((
                        SELECT SUM(Quantity) 
                        FROM Demo_SubRecipe_Inventory 
                        WHERE SubRecipeID = bl.ItemID 
                          AND BranchID = @BranchID 
                          AND Status = 'Available'
                    ), 0) -- Partial stock
                END
            ELSE 0 
        END AS CanFulfillFromStock,
        -- Calculate remaining quantity needed if using stock
        CASE 
            WHEN p.Category LIKE '%sub%recipe%' OR p.Category LIKE '%subrecipe%' 
            THEN 
                CASE 
                    WHEN ISNULL((
                        SELECT SUM(Quantity) 
                        FROM Demo_SubRecipe_Inventory 
                        WHERE SubRecipeID = bl.ItemID 
                          AND BranchID = @BranchID 
                          AND Status = 'Available'
                    ), 0) >= (bl.Quantity / bh.BatchSize) * @QuantityRequired
                    THEN 0 -- No additional needed
                    ELSE (bl.Quantity / bh.BatchSize) * @QuantityRequired - ISNULL((
                        SELECT SUM(Quantity) 
                        FROM Demo_SubRecipe_Inventory 
                        WHERE SubRecipeID = bl.ItemID 
                          AND BranchID = @BranchID 
                          AND Status = 'Available'
                    ), 0) -- Need this many more
                END
            ELSE (bl.Quantity / bh.BatchSize) * @QuantityRequired -- Regular ingredient, need full amount
        END AS RemainingQuantityNeeded
    FROM 
        BOM_Lines bl
        INNER JOIN BOM_Header bh ON bl.BOMID = bh.BOMID
        INNER JOIN Demo_Retail_Product p ON bl.ItemID = p.ProductID
    WHERE 
        bh.ProductID = @ProductID
        AND bh.IsActive = 1
    ORDER BY 
        IsSubRecipe DESC, -- Sub-recipes first
        p.Name
END
GO

PRINT 'sp_GetSmartBOMWithSubRecipeCheck created successfully'
GO
