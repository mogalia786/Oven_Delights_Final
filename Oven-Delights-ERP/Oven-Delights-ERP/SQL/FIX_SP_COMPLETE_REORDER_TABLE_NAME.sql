/*
    FIX sp_CompleteReOrderProduct - Wrong Table Name
    
    ERROR: Invalid object name 'dbo.ReOrderBook'
    CAUSE: Stored procedure uses singular "ReOrderBook" instead of plural "ReOrderBooks"
    
    This script will check and fix the table name in the stored procedure
*/

PRINT '========================================';
PRINT 'FIXING sp_CompleteReOrderProduct';
PRINT '========================================';
PRINT '';

-- Check if procedure exists
IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NULL
BEGIN
    PRINT '❌ ERROR: sp_CompleteReOrderProduct does not exist!';
    PRINT '   Run FIX_RETAIL_STOCK_SAFE.sql to create it.';
END
ELSE
BEGIN
    PRINT '✅ sp_CompleteReOrderProduct exists';
    PRINT '';
    
    -- Check the procedure definition
    DECLARE @ProcDef NVARCHAR(MAX);
    SELECT @ProcDef = OBJECT_DEFINITION(OBJECT_ID('sp_CompleteReOrderProduct'));
    
    IF @ProcDef LIKE '%dbo.ReOrderBook %' OR @ProcDef LIKE '%ReOrderBook WHERE%'
    BEGIN
        PRINT '❌ FOUND ISSUE: Procedure uses singular "ReOrderBook" instead of "ReOrderBooks"';
        PRINT '   Dropping and recreating procedure...';
        PRINT '';
        
        DROP PROCEDURE sp_CompleteReOrderProduct;
        PRINT '✅ Old procedure dropped';
    END
    ELSE
    BEGIN
        PRINT '✅ Procedure already uses correct table name "ReOrderBooks"';
        PRINT '   No fix needed!';
    END
END
GO

-- Recreate the procedure with correct table names
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
        
        IF @CompletedByName IS NULL
            SET @CompletedByName = 'Unknown Baker';
        
        -- Get line details (CORRECT: ReOrderBooks plural)
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
            CompletedBy = @CompletedByName,
            CompletedDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
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
        SELECT 
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
        FROM ReOrderBooks rob
        CROSS JOIN Demo_Retail_Product p
        WHERE rob.ReOrderBookID = @ReOrderBookID AND p.ProductID = @ProductID;
        
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
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

PRINT '';
PRINT '✅ sp_CompleteReOrderProduct recreated with correct table names!';
PRINT '';
PRINT 'CHANGES:';
PRINT '- ReOrderBook → ReOrderBooks (plural)';
PRINT '- Transaction handling fixed';
PRINT '- All table references corrected';
PRINT '';
PRINT '🎯 REBUILD AND TEST production completion!';
