-- =============================================
-- BOM FULFILLMENT FROM EXISTING STOCK
-- =============================================
-- Allow stockroom to fulfill BOM requests directly from existing inventory

-- Procedure to fulfill BOM request from existing stock
IF OBJECT_ID('sp_FulfillBOMFromStock', 'P') IS NOT NULL
    DROP PROCEDURE sp_FulfillBOMFromStock;
GO

CREATE PROCEDURE sp_FulfillBOMFromStock
    @InternalOrderID INT,
    @FulfilledBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Check if order exists and is open
        IF NOT EXISTS (SELECT 1 FROM InternalOrderHeader WHERE InternalOrderID = @InternalOrderID AND Status = 'Open')
        BEGIN
            RAISERROR('Internal Order not found or already fulfilled', 16, 1);
            RETURN;
        END
        
        -- Get order details
        DECLARE @FromLocationID INT, @ToLocationID INT, @BranchID INT;
        SELECT @FromLocationID = FromLocationID, @ToLocationID = ToLocationID
        FROM InternalOrderHeader
        WHERE InternalOrderID = @InternalOrderID;
        
        -- Check stock availability for all items
        DECLARE @InsufficientStock TABLE (MaterialID INT, Required DECIMAL(18,3), Available DECIMAL(18,3));
        
        INSERT INTO @InsufficientStock
        SELECT 
            iol.RawMaterialID,
            iol.Quantity,
            ISNULL((SELECT TOP 1 BalanceAfter 
                    FROM StockMovements 
                    WHERE MaterialID = iol.RawMaterialID 
                      AND InventoryArea = 'Stockroom'
                    ORDER BY MovementID DESC), 0) AS Available
        FROM InternalOrderLines iol
        WHERE iol.InternalOrderID = @InternalOrderID
          AND iol.RawMaterialID IS NOT NULL
          AND iol.Quantity > ISNULL((SELECT TOP 1 BalanceAfter 
                                              FROM StockMovements 
                                              WHERE MaterialID = iol.RawMaterialID 
                                                AND InventoryArea = 'Stockroom'
                                              ORDER BY MovementID DESC), 0);
        
        -- If any items have insufficient stock, return error with details
        IF EXISTS (SELECT 1 FROM @InsufficientStock)
        BEGIN
            DECLARE @ErrorMsg NVARCHAR(MAX) = 'Insufficient stock for: ';
            SELECT @ErrorMsg = @ErrorMsg + rm.MaterialName + ' (Need: ' + CAST(Required AS NVARCHAR) + ', Have: ' + CAST(Available AS NVARCHAR) + '); '
            FROM @InsufficientStock ist
            INNER JOIN RawMaterials rm ON rm.MaterialID = ist.MaterialID;
            
            RAISERROR(@ErrorMsg, 16, 1);
            RETURN;
        END
        
        -- Fulfill each line item
        DECLARE @LineID INT, @MaterialID INT, @Qty DECIMAL(18,3), @ItemDesc NVARCHAR(200);
        DECLARE @CurrentBalance DECIMAL(18,3), @UnitCost DECIMAL(18,2);
        
        DECLARE line_cursor CURSOR FOR
        SELECT InternalOrderLineID, RawMaterialID, Quantity, ISNULL(Notes, '')
        FROM InternalOrderLines
        WHERE InternalOrderID = @InternalOrderID AND RawMaterialID IS NOT NULL;
        
        OPEN line_cursor;
        FETCH NEXT FROM line_cursor INTO @LineID, @MaterialID, @Qty, @ItemDesc;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Get current stockroom balance
            SELECT TOP 1 @CurrentBalance = ISNULL(BalanceAfter, 0),
                         @UnitCost = ISNULL(UnitCost, 0)
            FROM StockMovements
            WHERE MaterialID = @MaterialID AND InventoryArea = 'Stockroom'
            ORDER BY MovementID DESC;
            
            -- Reduce from Stockroom
            INSERT INTO StockMovements (
                MaterialID, MovementType, MovementDate,
                QuantityOut, BalanceAfter, UnitCost, TotalValue,
                InventoryArea, FromLocation, ToLocation,
                ReferenceType, ReferenceNumber,
                BranchID, CreatedBy, CreatedDate, Notes
            )
            SELECT 
                @MaterialID,
                'Transfer to Manufacturing',
                GETDATE(),
                @Qty,
                @CurrentBalance - @Qty,
                @UnitCost,
                @UnitCost * @Qty,
                'Stockroom',
                'Stockroom',
                'Manufacturing',
                'InternalOrder',
                ioh.InternalOrderNo,
                @BranchID,
                @FulfilledBy,
                GETDATE(),
                'BOM Fulfilled: ' + @ItemDesc
            FROM InternalOrderHeader ioh
            WHERE ioh.InternalOrderID = @InternalOrderID;
            
            -- Add to Manufacturing
            DECLARE @MfgBalance DECIMAL(18,3) = 0;
            SELECT TOP 1 @MfgBalance = ISNULL(BalanceAfter, 0)
            FROM StockMovements
            WHERE MaterialID = @MaterialID AND InventoryArea = 'Manufacturing'
            ORDER BY MovementID DESC;
            
            INSERT INTO StockMovements (
                MaterialID, MovementType, MovementDate,
                QuantityIn, BalanceAfter, UnitCost, TotalValue,
                InventoryArea, FromLocation, ToLocation,
                ReferenceType, ReferenceNumber,
                BranchID, CreatedBy, CreatedDate, Notes
            )
            SELECT 
                @MaterialID,
                'Received from Stockroom',
                GETDATE(),
                @Qty,
                @MfgBalance + @Qty,
                @UnitCost,
                @UnitCost * @Qty,
                'Manufacturing',
                'Stockroom',
                'Manufacturing',
                'InternalOrder',
                ioh.InternalOrderNo,
                @BranchID,
                @FulfilledBy,
                GETDATE(),
                'BOM Received: ' + @ItemDesc
            FROM InternalOrderHeader ioh
            WHERE ioh.InternalOrderID = @InternalOrderID;
            
            FETCH NEXT FROM line_cursor INTO @LineID, @MaterialID, @Qty, @ItemDesc;
        END
        
        CLOSE line_cursor;
        DEALLOCATE line_cursor;
        
        -- Mark order as fulfilled
        UPDATE InternalOrderHeader
        SET 
            Status = 'Fulfilled',
            FulfilledDate = GETDATE(),
            FulfilledBy = @FulfilledBy
        WHERE InternalOrderID = @InternalOrderID;
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, 'BOM fulfilled from existing stock' AS Message;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('global', 'line_cursor') >= 0
        BEGIN
            CLOSE line_cursor;
            DEALLOCATE line_cursor;
        END
        
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT '✅ sp_FulfillBOMFromStock created';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ BOM FULFILLMENT PROCEDURES CREATED!';
PRINT '';
PRINT '🎯 Stockroom can now fulfill BOM requests directly from existing stock';
PRINT '   - Checks stock availability before fulfilling';
PRINT '   - Transfers ingredients from Stockroom to Manufacturing';
PRINT '   - Updates StockMovements for full audit trail';
PRINT '═══════════════════════════════════════════════';
