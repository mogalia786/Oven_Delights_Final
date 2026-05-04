-- =============================================
-- Trigger: Auto-Update Product Recipe Costs on Price Change
-- Description: Automatically updates all product recipe BOM costs
--              whenever ingredient prices change in Demo_Retail_Price
-- =============================================

-- Drop existing trigger if it exists
IF OBJECT_ID('trg_AutoUpdateProductRecipeCosts_OnPriceChange', 'TR') IS NOT NULL
    DROP TRIGGER trg_AutoUpdateProductRecipeCosts_OnPriceChange;
GO

CREATE TRIGGER trg_AutoUpdateProductRecipeCosts_OnPriceChange
ON Demo_Retail_Price
AFTER UPDATE, INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Only proceed if CostPrice was updated or inserted
    IF UPDATE(CostPrice) OR EXISTS (SELECT 1 FROM inserted)
    BEGIN
        DECLARE @ProductID INT;
        DECLARE @BranchID INT;
        DECLARE @NewCost DECIMAL(18,6);
        
        -- Cursor to process each updated/inserted price
        DECLARE price_cursor CURSOR FOR
        SELECT i.ProductID, i.BranchID, ISNULL(i.CostPrice, 0)
        FROM inserted i
        LEFT JOIN deleted d ON i.ProductID = d.ProductID AND i.BranchID = d.BranchID
        WHERE d.ProductID IS NULL -- INSERT
           OR ISNULL(i.CostPrice, 0) <> ISNULL(d.CostPrice, 0); -- UPDATE with change
        
        OPEN price_cursor;
        FETCH NEXT FROM price_cursor INTO @ProductID, @BranchID, @NewCost;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Update Product Recipe BOM costs for this ingredient (non-SubRecipe components)
            -- TotalCost is a computed column (Quantity * CostPerUnit) so it updates automatically
            UPDATE bom
            SET bom.CostPerUnit = @NewCost
            FROM Demo_ProductRecipe_BOM bom
            INNER JOIN Demo_Retail_Product p ON p.ProductID = bom.ComponentID
            WHERE p.ProductID = @ProductID
              AND p.BranchID = @BranchID
              AND bom.ComponentType != 'SubRecipe';
            
            -- Recalculate total cost for affected product recipes
            UPDATE rm
            SET rm.TotalCost = (
                SELECT SUM(bom.TotalCost)
                FROM Demo_ProductRecipe_BOM bom
                WHERE bom.ProductID = rm.ProductID
            )
            FROM Demo_ProductRecipe_Master rm
            WHERE EXISTS (
                SELECT 1 
                FROM Demo_ProductRecipe_BOM bom
                INNER JOIN Demo_Retail_Product p ON p.ProductID = bom.ComponentID
                WHERE bom.ProductID = rm.ProductID 
                  AND p.ProductID = @ProductID
                  AND p.BranchID = @BranchID
                  AND bom.ComponentType != 'SubRecipe'
            );
            
            FETCH NEXT FROM price_cursor INTO @ProductID, @BranchID, @NewCost;
        END;
        
        CLOSE price_cursor;
        DEALLOCATE price_cursor;
    END;
END;
GO

PRINT 'Trigger trg_AutoUpdateProductRecipeCosts_OnPriceChange created successfully!';
PRINT 'This trigger will automatically update all product recipe costs when ingredient prices change in Demo_Retail_Price.';
GO
