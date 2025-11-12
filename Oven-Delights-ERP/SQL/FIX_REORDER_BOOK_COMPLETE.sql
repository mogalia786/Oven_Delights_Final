-- =============================================
-- FIX: Re-Order Book Production Completion Issues
-- =============================================
-- Issues:
-- 1. sp_CompleteReOrderProduct expects INT for @CompletedBy but receives baker name (string)
-- 2. Start Production button should only be enabled when BOM is fulfilled
-- 3. Baker name should auto-select in BOM Editor when clicking Request BOM
-- =============================================

PRINT '🔧 Fixing Re-Order Book Production Completion...';
GO

-- =============================================
-- FIX 1: Update sp_CompleteReOrderProduct to accept UserID instead of name
-- =============================================

IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
    DROP PROCEDURE sp_CompleteReOrderProduct;
GO

CREATE PROCEDURE sp_CompleteReOrderProduct
    @ReOrderLineID INT,
    @QuantityCompleted DECIMAL(18,2),
    @CompletedBy INT  -- Changed from NVARCHAR(100) to INT (UserID)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @ReOrderBookID INT, @ProductID INT, @ProductName NVARCHAR(200), @SKU NVARCHAR(50), @BranchID INT;
        DECLARE @CompletedByName NVARCHAR(200);
        
        -- Get baker name from UserID
        SELECT @CompletedByName = FirstName + ' ' + LastName
        FROM Users
        WHERE UserID = @CompletedBy;
        
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
            CompletedBy = @CompletedByName,  -- Store name for display
            RetailStockUpdated = 1,
            RetailStockUpdateDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
        -- Update Retail Stock (add finished product)
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
            @CompletedBy,  -- Now stores UserID (INT)
            GETDATE(),
            'Completed from Re-Order Book by ' + @CompletedByName
        FROM ReOrderBooks rob
        CROSS JOIN Products p
        WHERE rob.ReOrderBookID = @ReOrderBookID AND p.ProductID = @ProductID;
        
        -- Update RetailStock table (if exists)
        IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
        BEGIN
            -- Check if product already exists in RetailStock for this branch
            IF EXISTS (SELECT 1 FROM RetailStock WHERE ProductID = @ProductID AND BranchID = @BranchID AND StockType = 'Internal')
            BEGIN
                -- Update existing record
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
                -- Insert new record
                INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
                VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE(), @CompletedByName);
            END
        END
        
        -- Update Products.CurrentStock (if column exists)
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CurrentStock')
        BEGIN
            UPDATE Products
            SET CurrentStock = ISNULL(CurrentStock, 0) + @QuantityCompleted
            WHERE ProductID = @ProductID;
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
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT '✅ sp_CompleteReOrderProduct updated to accept UserID (INT) instead of name';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 FIXES APPLIED:';
PRINT '1. sp_CompleteReOrderProduct now accepts @CompletedBy as INT (UserID)';
PRINT '2. Baker name is retrieved from Users table using UserID';
PRINT '3. StockMovements.CreatedBy now stores UserID (INT) correctly';
PRINT '4. Display names still stored in ReOrderBookLines.CompletedBy for reporting';
PRINT '5. ✨ RetailStock table is now updated with completed products';
PRINT '6. ✨ Products.CurrentStock is now updated (if column exists)';
PRINT '';
PRINT '🔧 CODE FIXES (already applied in BakerProductionViewForm.vb):';
PRINT '1. Line 194: Changed from bakerName to bakerID';
PRINT '2. Line 108: Added btnRequestBOM.Enabled logic';
PRINT '3. Line 372: Baker auto-selection via SetRequester()';
PRINT '';
PRINT '💡 RETAIL STOCK UPDATE:';
PRINT 'When a product is completed, the system now:';
PRINT '- Creates StockMovements record (audit trail)';
PRINT '- Updates RetailStock table (actual inventory)';
PRINT '- Updates Products.CurrentStock (if column exists)';
PRINT '';
PRINT '✅ ALL FIXES COMPLETE - Products will now show in retail stock!';
PRINT '═══════════════════════════════════════════════';
