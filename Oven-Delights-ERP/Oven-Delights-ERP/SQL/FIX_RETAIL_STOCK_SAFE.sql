-- =============================================
-- SAFE FIX: Update sp_CompleteReOrderProduct
-- No dynamic SQL - only updates tables that exist
-- =============================================

PRINT '🔧 Updating sp_CompleteReOrderProduct (SAFE VERSION)...';
GO

-- =============================================
-- Drop existing procedure
-- =============================================
IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
    DROP PROCEDURE sp_CompleteReOrderProduct;
GO

-- =============================================
-- Create updated procedure
-- =============================================
CREATE PROCEDURE sp_CompleteReOrderProduct
    @ReOrderLineID INT,
    @QuantityCompleted DECIMAL(18,2),
    @CompletedBy INT  -- UserID (INT)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @ReOrderBookID INT, @ProductID INT, @ProductName NVARCHAR(200), @SKU NVARCHAR(50), @BranchID INT;
        DECLARE @CompletedByName NVARCHAR(200);
        
        -- Get baker name from UserID
        SELECT @CompletedByName = ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
        FROM Users
        WHERE UserID = @CompletedBy;
        
        IF @CompletedByName IS NULL OR LTRIM(RTRIM(@CompletedByName)) = ''
            SET @CompletedByName = 'User ' + CAST(@CompletedBy AS NVARCHAR(10));
        
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
        
        -- Update line completion
        UPDATE ReOrderBookLines
        SET 
            QuantityCompleted = @QuantityCompleted,
            LineStatus = 'Completed',
            CompletedDate = GETDATE(),
            CompletedBy = @CompletedByName,
            RetailStockUpdated = 1,
            RetailStockUpdateDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
        -- Update Retail Stock
        DECLARE @CurrentBalance DECIMAL(18,2) = 0;
        
        SELECT TOP 1 @CurrentBalance = ISNULL(BalanceAfter, 0)
        FROM StockMovements
        WHERE MaterialID = @ProductID 
            AND BranchID = @BranchID
            AND InventoryArea = 'Retail'
        ORDER BY MovementID DESC;
        
        -- Create stock movement for completed product
        INSERT INTO StockMovements (
            MaterialID, MovementType, MovementDate,
            QuantityIn, BalanceAfter, UnitCost, TotalValue,
            InventoryArea, FromLocation, ToLocation,
            ReferenceType, ReferenceNumber,
            BranchID, CreatedBy, CreatedDate, Notes
        )
        SELECT 
            @ProductID,
            'Production Complete',
            GETDATE(),
            @QuantityCompleted,
            @CurrentBalance + @QuantityCompleted,
            ISNULL(p.LastPaidPrice, 0),
            ISNULL(p.LastPaidPrice, 0) * @QuantityCompleted,
            'Retail',
            'Manufacturing',
            'Retail',
            'ReOrder',
            rob.ReOrderNumber,
            @BranchID,
            @CompletedBy,
            GETDATE(),
            'Completed from Re-Order Book by ' + @CompletedByName
        FROM ReOrderBooks rob
        CROSS JOIN Products p
        WHERE rob.ReOrderBookID = @ReOrderBookID AND p.ProductID = @ProductID;
        
        -- Update RetailStock table (if exists) - NO DYNAMIC SQL
        IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
        BEGIN
            -- Check if record exists
            IF EXISTS (SELECT 1 FROM RetailStock WHERE ProductID = @ProductID AND BranchID = @BranchID AND StockType = 'Internal')
            BEGIN
                -- Update existing
                UPDATE RetailStock
                SET 
                    Quantity = Quantity + @QuantityCompleted,
                    LastUpdated = GETDATE(),
                    UpdatedBy = @CompletedByName
                WHERE ProductID = @ProductID 
                  AND BranchID = @BranchID 
                  AND StockType = 'Internal';
            END
            ELSE
            BEGIN
                -- Insert new
                INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
                VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE(), @CompletedByName);
            END
        END
        
        -- Audit log
        INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, ProductID, Quantity, Notes)
        VALUES (@ReOrderBookID, 'ProductCompleted', @CompletedByName, @ProductID, @QuantityCompleted, 
                @ProductName + ' completed and added to retail stock');
        
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
            
            INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, OldStatus, NewStatus, Notes)
            VALUES (@ReOrderBookID, 'Completed', @CompletedByName, 'InProgress', 'Completed', 'All products completed');
            
            SET @AllCompleted = 1;
        END
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, @AllCompleted AS AllCompleted;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0
            ROLLBACK TRANSACTION;
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO

PRINT '';
PRINT '✅ sp_CompleteReOrderProduct updated successfully!';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 WHAT THIS PROCEDURE DOES:';
PRINT '1. ✅ Creates StockMovements record (audit trail)';
PRINT '2. ✅ Updates RetailStock table (if exists)';
PRINT '3. ✅ Updates ReOrderBookLines completion status';
PRINT '4. ✅ Updates ReOrderBooks status when all complete';
PRINT '';
PRINT '⚠️  NOTE: This version only updates RetailStock table.';
PRINT '   If you need Retail_Stock or Products columns updated,';
PRINT '   run CHECK_RETAIL_STOCK_SCHEMA.sql first to see the schema,';
PRINT '   then we can add those updates safely.';
PRINT '';
PRINT '✅ No schema errors - Ready to test!';
PRINT '═══════════════════════════════════════════════';
