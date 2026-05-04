-- =============================================
-- CORRECTED: sp_CompleteReOrderProduct
-- 
-- CRITICAL FIX: Updates Demo_Retail_Stock (not RetailStock)
-- so that completed products appear in POS immediately
-- =============================================

CREATE OR ALTER PROCEDURE sp_CompleteReOrderProduct
    @ReOrderLineID INT,
    @QuantityCompleted DECIMAL(18,2),
    @CompletedBy INT  -- UserID (INT)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ReOrderBookID INT, @ProductID INT, @ProductName NVARCHAR(200), @SKU NVARCHAR(50), @BranchID INT;
    DECLARE @CompletedByName NVARCHAR(200);
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Get baker name from UserID
        SELECT @CompletedByName = FirstName + ' ' + LastName
        FROM Users
        WHERE UserID = @CompletedBy;
        
        IF @CompletedByName IS NULL
            SET @CompletedByName = 'Unknown Baker';
        
        -- Get line details
        SELECT 
            @ReOrderBookID = rol.ReOrderBookID,
            @ProductID = rol.ProductID,
            @ProductName = rol.ProductName,
            @SKU = rol.SKU,
            @BranchID = rob.BranchID
        FROM ReOrderBookLines rol
        INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
        WHERE rol.ReOrderLineID = @ReOrderLineID;
        
        -- Validate we got the data
        IF @ReOrderBookID IS NULL OR @ProductID IS NULL
        BEGIN
            RAISERROR('Invalid ReOrderLineID - line not found', 16, 1);
            RETURN;
        END
        
        PRINT '========================================';
        PRINT 'Completing Production:';
        PRINT 'Product: ' + @ProductName + ' (' + @SKU + ')';
        PRINT 'Quantity: ' + CAST(@QuantityCompleted AS NVARCHAR(20));
        PRINT 'Branch: ' + CAST(@BranchID AS NVARCHAR(10));
        PRINT 'Baker: ' + @CompletedByName;
        PRINT '========================================';
        
        -- Update line completion
        UPDATE ReOrderBookLines
        SET 
            QuantityCompleted = @QuantityCompleted,
            LineStatus = 'Completed',
            CompletedBy = @CompletedByName,
            CompletedDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
        PRINT 'Step 1: Updated ReOrderBookLines status';
        
        -- Insert into StockMovements for audit
        INSERT INTO StockMovements (
            MaterialID,
            BranchID,
            MovementType,
            MovementDate,
            QuantityIn,
            QuantityOut,
            BalanceAfter,
            UnitCost,
            TotalValue,
            ReferenceType,
            ReferenceID,
            ReferenceNumber,
            Notes,
            CreatedDate,
            CreatedBy
        )
        VALUES (
            @ProductID,
            @BranchID,
            'Production Complete',
            GETDATE(),
            @QuantityCompleted,
            0,
            0,  -- Will be calculated by trigger if exists
            0,
            0,
            'ReOrderBook',
            @ReOrderBookID,
            'ROB-' + CAST(@ReOrderBookID AS NVARCHAR(20)),
            'Completed from Re-Order Book by ' + @CompletedByName,
            GETDATE(),
            @CompletedBy
        );
        
        PRINT 'Step 2: Logged to StockMovements';
        
        -- =============================================
        -- CRITICAL FIX: Update Demo_Retail_Stock (not RetailStock!)
        -- =============================================
        IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
        BEGIN
            -- Check if record exists
            IF EXISTS (SELECT 1 FROM Demo_Retail_Stock WHERE ProductID = @ProductID AND BranchID = @BranchID)
            BEGIN
                UPDATE Demo_Retail_Stock
                SET 
                    Quantity = Quantity + @QuantityCompleted,
                    LastUpdated = GETDATE()
                WHERE ProductID = @ProductID AND BranchID = @BranchID;
                
                PRINT 'Step 3: Updated Demo_Retail_Stock (existing record)';
            END
            ELSE
            BEGIN
                INSERT INTO Demo_Retail_Stock (ProductID, BranchID, Quantity, LastUpdated)
                VALUES (@ProductID, @BranchID, @QuantityCompleted, GETDATE());
                
                PRINT 'Step 3: Inserted into Demo_Retail_Stock (new record)';
            END
            
            -- Show updated stock
            DECLARE @NewQuantity DECIMAL(18,2);
            SELECT @NewQuantity = Quantity 
            FROM Demo_Retail_Stock 
            WHERE ProductID = @ProductID AND BranchID = @BranchID;
            
            PRINT 'New Stock Quantity: ' + CAST(@NewQuantity AS NVARCHAR(20));
        END
        ELSE
        BEGIN
            PRINT 'WARNING: Demo_Retail_Stock table does not exist!';
        END
        
        -- Also update legacy RetailStock if it exists (for backward compatibility)
        IF OBJECT_ID('RetailStock', 'U') IS NOT NULL
        BEGIN
            IF EXISTS (SELECT 1 FROM RetailStock WHERE ProductID = @ProductID AND BranchID = @BranchID)
            BEGIN
                UPDATE RetailStock
                SET 
                    Quantity = Quantity + @QuantityCompleted,
                    LastUpdated = GETDATE()
                WHERE ProductID = @ProductID AND BranchID = @BranchID;
            END
            ELSE
            BEGIN
                INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
                VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE(), 'System');
            END
            
            PRINT 'Step 4: Also updated legacy RetailStock table';
        END
        
        -- Check if all products completed
        DECLARE @AllCompleted BIT = 0;
        IF NOT EXISTS (SELECT 1 FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID AND LineStatus <> 'Completed')
        BEGIN
            UPDATE ReOrderBooks
            SET 
                Status = 'Completed',
                CompletedBy = @CompletedByName,
                CompletedDate = GETDATE()
            WHERE ReOrderBookID = @ReOrderBookID;
            
            SET @AllCompleted = 1;
            PRINT 'Step 5: All products completed - ReOrderBook marked as Completed';
        END
        ELSE
        BEGIN
            PRINT 'Step 5: More products pending completion';
        END
        
        COMMIT TRANSACTION;
        
        PRINT '========================================';
        PRINT '✅ Production completion successful!';
        PRINT '========================================';
        
        -- Return result
        SELECT 
            @AllCompleted AS AllCompleted,
            @ProductID AS ProductID,
            @ProductName AS ProductName,
            @QuantityCompleted AS QuantityCompleted,
            @BranchID AS BranchID,
            'Success' AS Status;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        PRINT '========================================';
        PRINT '❌ ERROR: Production completion failed!';
        PRINT 'Error: ' + @ErrorMessage;
        PRINT '========================================';
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

PRINT '';
PRINT '✅ sp_CompleteReOrderProduct corrected successfully!';
PRINT '';
PRINT 'CRITICAL FIX APPLIED:';
PRINT '- ✅ Now updates Demo_Retail_Stock (not RetailStock)';
PRINT '- ✅ Completed products will appear in POS immediately';
PRINT '- ✅ Also updates legacy RetailStock for backward compatibility';
PRINT '- ✅ Detailed logging for debugging';
PRINT '';
PRINT 'USAGE: EXEC sp_CompleteReOrderProduct @ReOrderLineID = 123, @QuantityCompleted = 50, @CompletedBy = 1';
PRINT '';
