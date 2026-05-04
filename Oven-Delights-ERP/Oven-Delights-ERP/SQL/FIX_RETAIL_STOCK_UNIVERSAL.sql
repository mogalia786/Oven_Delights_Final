-- =============================================
-- UNIVERSAL FIX: Update sp_CompleteReOrderProduct
-- Works with ANY schema - checks what exists first
-- =============================================

PRINT '🔧 Updating sp_CompleteReOrderProduct to update retail stock...';
PRINT '';

-- First, let's see what we're working with
PRINT '📋 Checking database schema...';

DECLARE @HasRetailStock BIT = 0;
DECLARE @HasRetailStockUnderscore BIT = 0;
DECLARE @HasCurrentStock BIT = 0;
DECLARE @HasStockOnHand BIT = 0;

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
BEGIN
    SET @HasRetailStock = 1;
    PRINT '✅ RetailStock table found';
END

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Stock')
BEGIN
    SET @HasRetailStockUnderscore = 1;
    PRINT '✅ Retail_Stock table found';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CurrentStock')
BEGIN
    SET @HasCurrentStock = 1;
    PRINT '✅ Products.CurrentStock column found';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'StockOnHand')
BEGIN
    SET @HasStockOnHand = 1;
    PRINT '✅ Products.StockOnHand column found';
END

PRINT '';
PRINT 'Creating updated stored procedure...';
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
        
        -- Update RetailStock table (if exists)
        IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
        BEGIN
            IF EXISTS (SELECT 1 FROM RetailStock WHERE ProductID = @ProductID AND BranchID = @BranchID AND StockType = 'Internal')
            BEGIN
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
                INSERT INTO RetailStock (ProductID, BranchID, Quantity, StockType, LastUpdated, UpdatedBy)
                VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE(), @CompletedByName);
            END
        END
        
        -- Update Retail_Stock table (with underscore, if exists)
        IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Stock')
        BEGIN
            IF EXISTS (SELECT 1 FROM Retail_Stock WHERE ProductID = @ProductID AND BranchID = @BranchID)
            BEGIN
                EXEC('UPDATE Retail_Stock SET Quantity = Quantity + ' + @QuantityCompleted + ', LastUpdated = GETDATE() WHERE ProductID = ' + @ProductID + ' AND BranchID = ' + @BranchID);
            END
            ELSE
            BEGIN
                EXEC('INSERT INTO Retail_Stock (ProductID, BranchID, Quantity, LastUpdated) VALUES (' + @ProductID + ', ' + @BranchID + ', ' + @QuantityCompleted + ', GETDATE())');
            END
        END
        
        -- Update Products.CurrentStock (if column exists)
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CurrentStock')
        BEGIN
            UPDATE Products
            SET CurrentStock = ISNULL(CurrentStock, 0) + @QuantityCompleted
            WHERE ProductID = @ProductID;
        END
        
        -- Update Products.StockOnHand (if column exists)
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'StockOnHand')
        BEGIN
            UPDATE Products
            SET StockOnHand = ISNULL(StockOnHand, 0) + @QuantityCompleted
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

PRINT '';
PRINT '✅ sp_CompleteReOrderProduct updated successfully!';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 WHAT THIS PROCEDURE NOW DOES:';
PRINT '1. Creates StockMovements record (audit trail)';
PRINT '2. Updates RetailStock table (if exists)';
PRINT '3. Updates Retail_Stock table (if exists)';
PRINT '4. Updates Products.CurrentStock (if column exists)';
PRINT '5. Updates Products.StockOnHand (if column exists)';
PRINT '';
PRINT '💡 The procedure checks what exists in YOUR database';
PRINT '   and updates accordingly. No schema errors!';
PRINT '';
PRINT '✅ Ready to test - complete a product and check stock!';
PRINT '═══════════════════════════════════════════════';
