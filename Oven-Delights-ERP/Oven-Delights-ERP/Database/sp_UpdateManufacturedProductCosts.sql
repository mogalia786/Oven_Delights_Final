-- Stored procedure to calculate and update manufactured product costs based on BOM
-- This should be called after capturing invoices for raw materials

IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_UpdateManufacturedProductCosts')
    DROP PROCEDURE sp_UpdateManufacturedProductCosts
GO

CREATE PROCEDURE sp_UpdateManufacturedProductCosts
    @BranchID INT = NULL,  -- If NULL, update for all branches
    @ProductID INT = NULL  -- If NULL, update all manufactured products
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Update cost for all manufactured products (ProductType = 'Internal')
    -- Cost = SUM(ingredient cost * quantity) / batch size
    
    DECLARE @ProdID INT, @BatchSize DECIMAL(18,3), @TotalCost DECIMAL(18,2), @UnitCost DECIMAL(18,2)
    DECLARE @BID INT
    
    -- Cursor for each manufactured product
    DECLARE prod_cursor CURSOR FOR
        SELECT DISTINCT p.ProductID, p.BranchID
        FROM Demo_Retail_Product p
        WHERE p.ProductType = 'Internal' 
          AND p.IsActive = 1
          AND (@ProductID IS NULL OR p.ProductID = @ProductID)
          AND (@BranchID IS NULL OR p.BranchID = @BranchID)
    
    OPEN prod_cursor
    FETCH NEXT FROM prod_cursor INTO @ProdID, @BID
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Get batch size from BillOfMaterials
        SELECT @BatchSize = ISNULL(BatchSize, 1)
        FROM BillOfMaterials
        WHERE ProductID = @ProdID
        
        IF @BatchSize IS NULL OR @BatchSize = 0
            SET @BatchSize = 1
        
        -- Calculate total cost from BOM ingredients
        SELECT @TotalCost = SUM(
            ISNULL(bom.Quantity, 0) * 
            ISNULL((SELECT TOP 1 CostPrice 
                    FROM Demo_Retail_Price 
                    WHERE ProductID = rm.LinkedProductID 
                      AND BranchID = @BID 
                    ORDER BY EffectiveFrom DESC), 0)
        )
        FROM BillOfMaterialsLine bom
        INNER JOIN BillOfMaterials b ON bom.BOMID = b.BOMID
        INNER JOIN RawMaterials rm ON bom.MaterialID = rm.MaterialID
        WHERE b.ProductID = @ProdID
        
        IF @TotalCost IS NULL
            SET @TotalCost = 0
        
        -- Calculate unit cost (total cost / batch size)
        SET @UnitCost = @TotalCost / @BatchSize
        
        -- Update Demo_Retail_Price for this product
        IF EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = @ProdID AND BranchID = @BID)
        BEGIN
            UPDATE Demo_Retail_Price
            SET CostPrice = @UnitCost,
                EffectiveFrom = GETDATE()
            WHERE ProductID = @ProdID AND BranchID = @BID
        END
        ELSE
        BEGIN
            INSERT INTO Demo_Retail_Price (ProductID, BranchID, CostPrice, SellingPrice, SellingPriceExVAT, EffectiveFrom, CreatedAt)
            VALUES (@ProdID, @BID, @UnitCost, @UnitCost * 1.5, @UnitCost * 1.3, GETDATE(), GETDATE())
        END
        
        FETCH NEXT FROM prod_cursor INTO @ProdID, @BID
    END
    
    CLOSE prod_cursor
    DEALLOCATE prod_cursor
    
    PRINT 'Manufactured product costs updated successfully'
END
GO

PRINT 'sp_UpdateManufacturedProductCosts created successfully'
