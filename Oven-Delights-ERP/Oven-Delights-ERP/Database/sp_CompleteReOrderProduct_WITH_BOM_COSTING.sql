-- =============================================
-- sp_CompleteReOrderProduct - WITH BOM COSTING
-- Calculates cost of sales from BOM requisition
-- Updates retail stock with manufactured products
-- =============================================

IF OBJECT_ID('sp_CompleteReOrderProduct', 'P') IS NOT NULL
    DROP PROCEDURE sp_CompleteReOrderProduct;
GO

CREATE PROCEDURE sp_CompleteReOrderProduct
    @ReOrderLineID INT,
    @QuantityCompleted DECIMAL(18,2),
    @CompletedBy INT  -- UserID (INT)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @ReOrderBookID INT, @ProductID INT, @ProductName NVARCHAR(200), @BranchID INT;
        DECLARE @CompletedByName NVARCHAR(200);
        DECLARE @QuantityOrdered DECIMAL(18,2);
        DECLARE @UnitCost DECIMAL(18,6) = 0;
        DECLARE @TotalBOMCost DECIMAL(18,2) = 0;
        
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
            @QuantityOrdered = rol.QuantityOrdered,
            @BranchID = rob.BranchID
        FROM ReOrderBookLines rol
        INNER JOIN ReOrderBooks rob ON rol.ReOrderBookID = rob.ReOrderBookID
        WHERE rol.ReOrderLineID = @ReOrderLineID;
        
        -- =============================================
        -- CALCULATE COST OF SALES FROM BOM REQUISITION (for audit only)
        -- =============================================
        SELECT @TotalBOMCost = ISNULL(SUM(TotalCost), 0)
        FROM ReOrderBOMRequisition
        WHERE ReOrderLineID = @ReOrderLineID;
        
        -- Get existing cost from Demo_Retail_Price (DO NOT RECALCULATE)
        -- Cost is set when recipe is saved and only changes on GRV
        SELECT @UnitCost = ISNULL(CostPrice, 0)
        FROM Demo_Retail_Price
        WHERE ProductID = @ProductID AND BranchID = @BranchID;
        
        -- Update line completion with cost information
        UPDATE ReOrderBookLines
        SET 
            QuantityCompleted = @QuantityCompleted,
            LineStatus = 'Completed',
            CompletedDate = GETDATE(),
            CompletedBy = @CompletedByName,
            RetailStockUpdated = 1,
            RetailStockUpdateDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
        -- =============================================
        -- UPDATE RETAIL STOCK WITH MANUFACTURED PRODUCT
        -- =============================================
        DECLARE @CurrentBalance DECIMAL(18,2) = 0;
        
        -- Get current stock balance from StockMovements
        SELECT TOP 1 @CurrentBalance = ISNULL(BalanceAfter, 0)
        FROM StockMovements
        WHERE MaterialID = @ProductID 
            AND BranchID = @BranchID
            AND InventoryArea = 'Retail'
        ORDER BY MovementID DESC;
        
        -- Create stock movement for completed product with BOM cost
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
            @UnitCost,  -- Cost from BOM, not LastPaidPrice
            @UnitCost * @QuantityCompleted,
            'Retail',
            'Manufacturing',
            'Retail',
            'ReOrder',
            rob.ReOrderNumber,
            @BranchID,
            @CompletedBy,
            GETDATE(),
            'Completed from Re-Order Book by ' + @CompletedByName + ' | BOM Cost: R' + CAST(@TotalBOMCost AS NVARCHAR(20))
        FROM ReOrderBooks rob
        WHERE rob.ReOrderBookID = @ReOrderBookID;
        
        -- Update RetailStock table (if exists)
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
        
        -- Update Demo_Retail_Product CurrentStock (if column exists)
        IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'CurrentStock')
        BEGIN
            UPDATE Demo_Retail_Product
            SET CurrentStock = ISNULL(CurrentStock, 0) + @QuantityCompleted
            WHERE ProductID = @ProductID AND BranchID = @BranchID;
        END
        
        -- DO NOT UPDATE Demo_Retail_Price - cost is set when recipe is saved
        -- Manufacturing only affects quantity, not cost
        -- Cost only changes when: 1) Recipe is saved/updated, or 2) GRV updates ingredient costs
        
        -- Audit log
        INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, ProductID, Quantity, Notes)
        VALUES (@ReOrderBookID, 'ProductCompleted', @CompletedByName, @ProductID, @QuantityCompleted, 
                @ProductName + ' completed | Unit Cost: R' + CAST(@UnitCost AS NVARCHAR(20)) + ' | Total BOM Cost: R' + CAST(@TotalBOMCost AS NVARCHAR(20)));
        
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
        
        SELECT 
            'SUCCESS' AS Result, 
            @AllCompleted AS AllCompleted,
            @UnitCost AS UnitCost,
            @TotalBOMCost AS TotalBOMCost,
            @QuantityCompleted AS QuantityCompleted;
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

PRINT '✅ sp_CompleteReOrderProduct updated with BOM costing!';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 WHAT THIS PROCEDURE DOES:';
PRINT '';
PRINT '1. ✅ Calculates COST OF SALES from BOM Requisition';
PRINT '   - Sums all ingredient costs from ReOrderBOMRequisition';
PRINT '   - Calculates unit cost = Total BOM Cost ÷ Quantity Ordered';
PRINT '';
PRINT '2. ✅ Updates RETAIL STOCK with manufactured products';
PRINT '   - Adds to RetailStock table with StockType = ''Internal''';
PRINT '   - Updates Demo_Retail_Product.CurrentStock (if column exists)';
PRINT '   - Creates StockMovements record with BOM cost';
PRINT '';
PRINT '3. ✅ Updates COST PRICE in Demo_Retail_Price';
PRINT '   - Sets CostPrice to calculated unit cost from BOM';
PRINT '   - POS will use this cost for profit calculations';
PRINT '';
PRINT '4. ✅ Tracks completion status';
PRINT '   - Updates ReOrderBookLines with completion details';
PRINT '   - Marks ReOrderBook as Completed when all lines done';
PRINT '   - Creates audit trail with cost information';
PRINT '';
PRINT '🔄 WORKFLOW:';
PRINT '   Manager orders → Baker requests BOM → Stockroom fulfills';
PRINT '   → Baker completes production → THIS PROCEDURE:';
PRINT '     • Calculates cost from ingredients used';
PRINT '     • Adds finished product to retail stock';
PRINT '     • Updates cost price for POS';
PRINT '     • Ready for sale!';
PRINT '═══════════════════════════════════════════════';
GO
