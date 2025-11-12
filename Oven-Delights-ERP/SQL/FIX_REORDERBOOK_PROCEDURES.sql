-- Fix sp_AddProductToReOrderBook to use Demo_Retail_Product instead of Products

IF OBJECT_ID('dbo.sp_AddProductToReOrderBook', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AddProductToReOrderBook;
GO

CREATE PROCEDURE dbo.sp_AddProductToReOrderBook
    @ReOrderBookID INT,
    @ProductID INT,
    @QuantityOrdered DECIMAL(18,2),
    @UnitOfMeasure NVARCHAR(50) = NULL,
    @Notes NVARCHAR(MAX) = NULL,
    @ReOrderLineID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        -- Get product details from Demo_Retail_Product
        DECLARE @ProductName NVARCHAR(200), @SKU NVARCHAR(50), @BOMHeaderID INT;
        
        SELECT @ProductName = Name, @SKU = SKU
        FROM Demo_Retail_Product WHERE ProductID = @ProductID;
        
        -- Validate product was found
        IF @ProductName IS NULL
        BEGIN
            RAISERROR('Product not found with ProductID: %d', 16, 1, @ProductID);
            RETURN;
        END
        
        -- Find BOM for this product
        SELECT TOP 1 @BOMHeaderID = BOMID
        FROM BOMHeader 
        WHERE ProductID = @ProductID 
        AND IsActive = 1
        ORDER BY EffectiveFrom DESC;
        
        -- Get next line number
        DECLARE @LineNumber INT;
        SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1
        FROM ReOrderBookLines
        WHERE ReOrderBookID = @ReOrderBookID;
        
        -- Add product line
        INSERT INTO ReOrderBookLines (
            ReOrderBookID, ProductID, ProductName, SKU,
            QuantityOrdered, UnitOfMeasure, BOMHeaderID,
            LineNumber, Notes
        )
        VALUES (
            @ReOrderBookID, @ProductID, @ProductName, @SKU,
            @QuantityOrdered, @UnitOfMeasure, @BOMHeaderID,
            @LineNumber, @Notes
        );
        
        -- Get the inserted line ID
        SET @ReOrderLineID = SCOPE_IDENTITY();
        
        -- Update totals in ReOrderBooks
        UPDATE ReOrderBooks
        SET TotalProducts = (SELECT COUNT(*) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID),
            TotalQuantity = (SELECT SUM(QuantityOrdered) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID)
        WHERE ReOrderBookID = @ReOrderBookID;
        
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

PRINT 'sp_AddProductToReOrderBook updated to use Demo_Retail_Product!';
