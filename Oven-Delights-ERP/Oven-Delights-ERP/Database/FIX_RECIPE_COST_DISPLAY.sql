-- =============================================
-- FIX RECIPE ISSUES
-- 1. Manufactured product costs now show in Price Management
-- 2. Recipe component deletion works correctly (code fix already applied)
-- =============================================

-- Drop and recreate sp_UpdateProductRecipeTotalCost
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
    DECLARE @CostWithVATAndAdhoc DECIMAL(18,4) = 0;
    
    -- Calculate total cost from BOM components (Quantity * CostPerUnit)
    SELECT @TotalCost = ISNULL(SUM(Quantity * CostPerUnit), 0)
    FROM Demo_ProductRecipe_BOM
    WHERE ProductID = @ProductID
      AND IsActive = 1;
    
    -- Get BatchQty to calculate cost per unit
    SELECT @BatchQty = ISNULL(BatchQty, 1)
    FROM Demo_ProductRecipe_Master
    WHERE ProductID = @ProductID;
    
    -- Calculate cost per unit (base cost)
    SET @CostPerUnit = @TotalCost / @BatchQty;
    
    -- Add VAT (15%) and Adhoc charges (15%) to match selling price display
    -- Cost with VAT = CostPerUnit * 1.15
    -- Cost with VAT + Adhoc = (CostPerUnit * 1.15) * 1.15 = CostPerUnit * 1.3225
    SET @CostWithVATAndAdhoc = @CostPerUnit * 1.3225;
    
    -- Update the master record with calculated total cost
    UPDATE Demo_ProductRecipe_Master
    SET TotalCost = @TotalCost,
        LastUpdated = GETDATE()
    WHERE ProductID = @ProductID;
    
    -- Update Demo_Retail_Price.CostPrice for ALL branches with this product (by Name)
    -- Use cost with VAT + Adhoc to match how selling price is displayed (incl VAT)
    UPDATE rp
    SET rp.CostPrice = @CostWithVATAndAdhoc
    FROM Demo_Retail_Price rp
    INNER JOIN Demo_Retail_Product p ON rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
    WHERE p.Name = (SELECT Name FROM Demo_Retail_Product WHERE ProductID = @ProductID)
      AND p.IsActive = 1;
    
    -- If no price record exists, create one for each branch
    INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, SellingPrice, EffectiveFrom, CreatedAt)
    SELECT p.ProductID, p.BranchID, @CostWithVATAndAdhoc, 0, GETDATE(), GETDATE()
    FROM Demo_Retail_Product p
    WHERE p.Name = (SELECT Name FROM Demo_Retail_Product WHERE ProductID = @ProductID)
      AND p.IsActive = 1
      AND NOT EXISTS (
          SELECT 1 FROM Demo_Retail_Price rp 
          WHERE rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
      );
    
END
GO

PRINT '✓ Updated sp_UpdateProductRecipeTotalCost - now updates Demo_Retail_Price.CostPrice'
GO

-- Update costs for all existing manufactured products with recipes
PRINT 'Updating costs for existing manufactured products...'
GO

DECLARE @ProductID INT
DECLARE product_cursor CURSOR FOR
    SELECT DISTINCT ProductID 
    FROM Demo_ProductRecipe_Master 
    WHERE IsActive = 1

OPEN product_cursor
FETCH NEXT FROM product_cursor INTO @ProductID

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC sp_UpdateProductRecipeTotalCost @ProductID = @ProductID
    FETCH NEXT FROM product_cursor INTO @ProductID
END

CLOSE product_cursor
DEALLOCATE product_cursor

PRINT '✓ Updated costs for all existing manufactured products'
GO

-- Verify the fix
SELECT 
    p.Name AS ProductName,
    prm.BatchQty,
    prm.TotalCost AS RecipeTotalCost,
    (prm.TotalCost / prm.BatchQty) AS CostPerUnit,
    rp.CostPrice AS PriceManagementCost,
    CASE 
        WHEN rp.CostPrice IS NULL THEN '❌ NOT SHOWING'
        WHEN ABS(rp.CostPrice - (prm.TotalCost / prm.BatchQty)) < 0.01 THEN '✓ CORRECT'
        ELSE '⚠ MISMATCH'
    END AS Status
FROM Demo_ProductRecipe_Master prm
INNER JOIN Demo_Retail_Product p ON prm.ProductID = p.ProductID
LEFT JOIN Demo_Retail_Price rp ON rp.ProductID = p.ProductID AND rp.BranchID = p.BranchID
WHERE prm.IsActive = 1
ORDER BY p.Name

PRINT ''
PRINT '========================================='
PRINT 'FIXES APPLIED:'
PRINT '1. ✓ sp_UpdateProductRecipeTotalCost now updates Demo_Retail_Price.CostPrice'
PRINT '2. ✓ Manufactured product costs will show in Price Management'
PRINT '3. ✓ Recipe component deletion fixed in code (rebuild required)'
PRINT '========================================='
