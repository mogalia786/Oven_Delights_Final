/*
    FINAL FIX: sp_CompleteReOrderProduct
    
    ISSUES FOUND:
    1. Unnecessary CROSS JOIN causing multiple inserts
    2. Transaction count mismatch
    
    SOLUTION:
    - Remove CROSS JOIN
    - Use simple INSERT with variables
    - Proper transaction handling
*/

PRINT '========================================';
PRINT 'FINAL FIX: sp_CompleteReOrderProduct';
PRINT '========================================';
PRINT '';

-- Drop existing procedure
IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE sp_CompleteReOrderProduct;
    PRINT '✅ Old procedure dropped';
END
GO

-- Create the corrected procedure
CREATE PROCEDURE sp_CompleteReOrderProduct
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
        
        -- Update line completion
        UPDATE ReOrderBookLines
        SET 
            QuantityCompleted = @QuantityCompleted,
            LineStatus = 'Completed',
            CompletedBy = @CompletedByName,
            CompletedDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
        -- Insert into StockMovements for audit (FIXED: No CROSS JOIN!)
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
        
        -- Update RetailStock table (if exists)
        IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
        BEGIN
            -- Check if record exists
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
        END
        
        COMMIT TRANSACTION;
        
        -- Return result
        SELECT @AllCompleted AS AllCompleted;
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

PRINT '';
PRINT '✅ sp_CompleteReOrderProduct fixed successfully!';
PRINT '';
PRINT 'FIXES APPLIED:';
PRINT '- ❌ Removed CROSS JOIN with Demo_Retail_Product';
PRINT '- ✅ Changed to simple VALUES insert';
PRINT '- ✅ Fixed transaction handling (BEGIN TRANSACTION inside TRY)';
PRINT '- ✅ Added validation for NULL values';
PRINT '- ✅ Proper error handling with RAISERROR';
PRINT '';
PRINT '🎯 REBUILD ERP AND TEST production completion!';
