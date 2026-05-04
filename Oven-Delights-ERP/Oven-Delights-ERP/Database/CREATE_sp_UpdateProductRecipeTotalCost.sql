-- Create stored procedure to calculate and update recipe total cost
-- TotalCost = Sum of (BOM component costs) + AdHocCost

IF OBJECT_ID('sp_UpdateProductRecipeTotalCost', 'P') IS NOT NULL
    DROP PROCEDURE sp_UpdateProductRecipeTotalCost;
GO

CREATE PROCEDURE sp_UpdateProductRecipeTotalCost
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @TotalCost DECIMAL(18,4) = 0;
    DECLARE @BatchQty DECIMAL(18,4) = 1;
    DECLARE @CostPerUnit DECIMAL(18,4) = 0;
    
    -- Calculate total cost from BOM components (Quantity * CostPerUnit)
    SELECT @TotalCost = ISNULL(SUM(Quantity * CostPerUnit), 0)
    FROM Demo_ProductRecipe_BOM
    WHERE ProductID = @ProductID
      AND IsActive = 1;
    
    -- Get BatchQty to calculate cost per unit
    SELECT @BatchQty = ISNULL(BatchQty, 1)
    FROM Demo_ProductRecipe_Master
    WHERE ProductID = @ProductID;
    
    -- Calculate cost per unit
    SET @CostPerUnit = @TotalCost / @BatchQty;
    
    -- Update the master record with calculated total cost
    UPDATE Demo_ProductRecipe_Master
    SET TotalCost = @TotalCost,
        LastUpdated = GETDATE()
    WHERE ProductID = @ProductID;
    
    -- Update Demo_Retail_Price.CostPrice for ALL branches with this product (by Name)
    -- This makes manufactured product cost show in Price Management like LastPaidPrice for external products
    UPDATE rp
    SET rp.CostPrice = @CostPerUnit,
        rp.LastUpdated = GETDATE()
    FROM Demo_Retail_Price rp
    INNER JOIN Demo_Retail_Product p ON rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
    WHERE p.Name = (SELECT Name FROM Demo_Retail_Product WHERE ProductID = @ProductID)
      AND p.IsActive = 1;
    
    -- If no price record exists, create one for each branch
    INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, SellingPrice, EffectiveFrom, CreatedAt, LastUpdated)
    SELECT p.ProductID, p.BranchID, @CostPerUnit, 0, GETDATE(), GETDATE(), GETDATE()
    FROM Demo_Retail_Product p
    WHERE p.Name = (SELECT Name FROM Demo_Retail_Product WHERE ProductID = @ProductID)
      AND p.IsActive = 1
      AND NOT EXISTS (
          SELECT 1 FROM Demo_Retail_Price rp 
          WHERE rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
      );
    
END
GO

PRINT 'Created sp_UpdateProductRecipeTotalCost successfully';
GO

-- Test: Update TotalCost for Goolab Jumbu
DECLARE @GoolabProductID INT;
SELECT @GoolabProductID = ProductID FROM Products WHERE ProductName LIKE '%Goolab%';

IF @GoolabProductID IS NOT NULL
BEGIN
    EXEC sp_UpdateProductRecipeTotalCost @ProductID = @GoolabProductID;
    
    -- Verify the update
    SELECT 
        'Demo_ProductRecipe_Master' AS TableName,
        ProductID,
        BatchQty,
        TotalCost,
        Method
    FROM Demo_ProductRecipe_Master
    WHERE ProductID = @GoolabProductID;
    
    -- Show BOM components
    SELECT 
        'Demo_ProductRecipe_BOM' AS TableName,
        ComponentType,
        ComponentID,
        Quantity,
        CostPerUnit,
        (Quantity * CostPerUnit) AS LineCost
    FROM Demo_ProductRecipe_BOM
    WHERE ProductID = @GoolabProductID
      AND IsActive = 1;
    
    PRINT 'Updated TotalCost for Goolab Jumbu successfully';
END
ELSE
BEGIN
    PRINT 'Goolab Jumbu product not found';
END
