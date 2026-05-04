-- =============================================
-- Stored Procedure: sp_GetIngredientCostPerUnit
-- Description: Gets the cost per unit for an ingredient from Demo_Retail_Product
-- =============================================

IF OBJECT_ID('sp_GetIngredientCostPerUnit', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetIngredientCostPerUnit;
GO

CREATE PROCEDURE sp_GetIngredientCostPerUnit
    @IngredientID INT,
    @BranchID INT,
    @PackageSize DECIMAL(18,6),
    @CostPerUnit DECIMAL(18,6) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- First try Demo_Retail_Price (where PO form gets prices from)
    SELECT @CostPerUnit = CostPrice
    FROM Demo_Retail_Price
    WHERE ProductID = @IngredientID
      AND BranchID = @BranchID;
    
    -- If not found, try Demo_Retail_Product
    IF @CostPerUnit IS NULL OR @CostPerUnit = 0
    BEGIN
        SELECT @CostPerUnit = ISNULL(AverageCost, ISNULL(LastPaidPrice, 0))
        FROM Demo_Retail_Product
        WHERE ProductID = @IngredientID
          AND BranchID = @BranchID;
    END
    
    -- If still no cost found, set to 0
    IF @CostPerUnit IS NULL
        SET @CostPerUnit = 0;
END;
GO

PRINT 'Stored procedure sp_GetIngredientCostPerUnit created successfully!';
GO
