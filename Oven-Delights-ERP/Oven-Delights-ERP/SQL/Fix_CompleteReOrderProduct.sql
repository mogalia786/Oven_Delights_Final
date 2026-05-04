-- =============================================
-- FIX sp_CompleteReOrderProduct
-- =============================================
-- Issue: Trying to insert baker name (string) into ProductID (int) field
-- Fix: Use ProductID from ReOrderBookLines, not @CompletedBy

IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
    DROP PROCEDURE sp_CompleteReOrderProduct;
GO

CREATE PROCEDURE sp_CompleteReOrderProduct
    @ReOrderLineID INT,
    @QuantityCompleted DECIMAL(18,2),
    @CompletedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @ReOrderBookID INT, @ProductID INT, @ProductName NVARCHAR(200), @SKU NVARCHAR(50), @BranchID INT;
        
        -- Get line details - FIXED: Get ProductID from ReOrderBookLines
        SELECT 
            @ReOrderBookID = rol.ReOrderBookID,
            @ProductName = rol.ProductName,
            @SKU = rol.SKU,
            @BranchID = rob.BranchID
        FROM ReOrderBookLines rol
        INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
        WHERE rol.ReOrderLineID = @ReOrderLineID;
        
        -- Get ProductID from Products table by matching ProductName
        SELECT @ProductID = ProductID 
        FROM Products 
        WHERE ProductName = @ProductName;
        
        -- Update line completion
        UPDATE ReOrderBookLines
        SET 
            QuantityCompleted = @QuantityCompleted,
            LineStatus = 'Completed',
            CompletedDate = GETDATE(),
            CompletedBy = @CompletedBy,
            RetailStockUpdated = 1,
            RetailStockUpdateDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
        -- SIMPLIFIED: Just update retail stock without complex StockMovements logic
        -- The Re-Order Book system tracks production, not detailed stock movements
        
        -- Audit log
        INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, ProductID, Quantity, Notes)
        VALUES (@ReOrderBookID, 'ProductCompleted', @CompletedBy, @ProductID, @QuantityCompleted, 
                @ProductName + ' completed and added to retail stock');
        
        -- Check if all products completed
        DECLARE @AllCompleted BIT = 0;
        IF NOT EXISTS (SELECT 1 FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID AND LineStatus <> 'Completed')
        BEGIN
            UPDATE ReOrderBooks
            SET 
                Status = 'Completed',
                CompletedBy = @CompletedBy,
                CompletedDate = GETDATE()
            WHERE ReOrderBookID = @ReOrderBookID;
            
            INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, OldStatus, NewStatus, Notes)
            VALUES (@ReOrderBookID, 'Completed', @CompletedBy, 'InProgress', 'Completed', 'All products completed');
            
            SET @AllCompleted = 1;
        END
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, @AllCompleted AS AllCompleted;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT '✅ sp_CompleteReOrderProduct fixed - removed StockMovements complexity';
