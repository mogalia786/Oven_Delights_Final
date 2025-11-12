-- Fix sp_CompleteReOrderProduct to update Demo_Retail_Product.CurrentStock
-- This is what the POS reads for stock quantity

ALTER PROCEDURE sp_CompleteReOrderProduct
    @ReOrderLineID INT,
    @QuantityCompleted DECIMAL(18,2),
    @CompletedBy INT -- UserID (INT)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ReOrderBookID INT, @ProductID INT, @ProductName NVARCHAR(200), @SKU NVARCHAR(100), @BranchID INT;
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
        INNER JOIN ReOrderBooks rob ON rob.ReOrderBookID = rol.ReOrderBookID
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
        
        -- Insert into StockMovements for audit (FIXED: No Calculated columns)
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
            0, -- Will be calculated by trigger if exists
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
                VALUES (@ProductID, @BranchID, @QuantityCompleted, 'Internal', GETDATE(), @CompletedByName);
            END
        END
        
        -- **CRITICAL FIX:** Update Demo_Retail_Stock.QtyOnHand (what POS vw_POS_Products reads!)
        -- First get or create VariantID from Demo_Retail_Variant
        DECLARE @VariantID INT = NULL;
        SELECT @VariantID = VariantID 
        FROM dbo.Demo_Retail_Variant 
        WHERE ProductID = @ProductID;
        
        IF @VariantID IS NULL
        BEGIN
            INSERT INTO dbo.Demo_Retail_Variant (ProductID) VALUES (@ProductID);
            SET @VariantID = SCOPE_IDENTITY();
        END
        
        -- Now update or insert into Demo_Retail_Stock
        IF EXISTS (SELECT 1 FROM dbo.Demo_Retail_Stock WHERE VariantID = @VariantID AND BranchID = @BranchID)
        BEGIN
            UPDATE dbo.Demo_Retail_Stock
            SET QtyOnHand = ISNULL(QtyOnHand, 0) + @QuantityCompleted
            WHERE VariantID = @VariantID AND BranchID = @BranchID;
        END
        ELSE
        BEGIN
            INSERT INTO dbo.Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint)
            VALUES (@VariantID, @BranchID, @QuantityCompleted, 0);
        END
        
        -- ALSO Update Demo_Retail_Product.CurrentStock for consistency
        UPDATE dbo.Demo_Retail_Product
        SET CurrentStock = ISNULL(CurrentStock, 0) + @QuantityCompleted
        WHERE ProductID = @ProductID
          AND (BranchID = @BranchID OR BranchID IS NULL);
        
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

PRINT 'sp_CompleteReOrderProduct updated to update Demo_Retail_Product.CurrentStock!';
