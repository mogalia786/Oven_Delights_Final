-- =============================================
-- SIMPLIFIED RE-ORDER BOOK PROCEDURES
-- Production instruction workflow
-- =============================================

-- =============================================
-- 1. CREATE NEW RE-ORDER BOOK
-- =============================================
IF OBJECT_ID('sp_CreateReOrderBook', 'P') IS NOT NULL
    DROP PROCEDURE sp_CreateReOrderBook;
GO

CREATE PROCEDURE sp_CreateReOrderBook
    @BranchID INT,
    @ManufacturerUserID INT,
    @OrderDate DATE,
    @RequiredDate DATE,
    @CreatedBy NVARCHAR(100),
    @IsUrgent BIT = 0,
    @Notes NVARCHAR(MAX) = NULL,
    @ReOrderBookID INT OUTPUT,
    @ReOrderNumber NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Get branch code and manufacturer name
        DECLARE @BranchCode NVARCHAR(10), @ManufacturerName NVARCHAR(100);
        
        SELECT @BranchCode = BranchCode FROM Branches WHERE BranchID = @BranchID;
        SELECT @ManufacturerName = FirstName + ' ' + LastName FROM Users WHERE UserID = @ManufacturerUserID;
        
        -- Generate unique ReOrder number: BranchCode-RO-i-BakerName
        DECLARE @BaseName NVARCHAR(50) = @BranchCode + '-RO-i-' + REPLACE(@ManufacturerName, ' ', '');
        DECLARE @Counter INT = 1;
        SET @ReOrderNumber = @BaseName;
        
        WHILE EXISTS (SELECT 1 FROM ReOrderBooks WHERE ReOrderNumber = @ReOrderNumber)
        BEGIN
            SET @Counter = @Counter + 1;
            SET @ReOrderNumber = @BaseName + '-' + CAST(@Counter AS NVARCHAR(10));
        END
        
        -- Create re-order book
        INSERT INTO ReOrderBooks (
            ReOrderNumber, BranchID, ManufacturerUserID, ManufacturerName,
            OrderDate, RequiredDate, Status, Priority, CreatedBy, IsUrgent, Notes
        )
        VALUES (
            @ReOrderNumber, @BranchID, @ManufacturerUserID, @ManufacturerName,
            @OrderDate, @RequiredDate, 'Draft', 
            CASE WHEN @IsUrgent = 1 THEN 'Urgent' ELSE 'Normal' END,
            @CreatedBy, @IsUrgent, @Notes
        );
        
        SET @ReOrderBookID = SCOPE_IDENTITY();
        
        -- Audit log
        INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, NewStatus, Notes)
        VALUES (@ReOrderBookID, 'Created', @CreatedBy, 'Draft', 'Re-order book created');
        
        COMMIT TRANSACTION;
        
        SELECT @ReOrderBookID AS ReOrderBookID, @ReOrderNumber AS ReOrderNumber, 'SUCCESS' AS Result;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT '✅ sp_CreateReOrderBook created';

-- =============================================
-- 2. ADD PRODUCT TO RE-ORDER BOOK
-- =============================================
IF OBJECT_ID('sp_AddProductToReOrderBook', 'P') IS NOT NULL
    DROP PROCEDURE sp_AddProductToReOrderBook;
GO

CREATE PROCEDURE sp_AddProductToReOrderBook
    @ReOrderBookID INT,
    @ProductID INT,
    @QuantityOrdered DECIMAL(18,2),
    @UnitOfMeasure NVARCHAR(20) = 'Each',
    @Notes NVARCHAR(500) = NULL,
    @ReOrderLineID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Get product details
        DECLARE @ProductName NVARCHAR(200), @SKU NVARCHAR(50);
        
        SELECT 
            @ProductName = ProductName, 
            @SKU = SKU
        FROM Products 
        WHERE ProductID = @ProductID;
        
        -- Get next line number
        DECLARE @LineNumber INT;
        SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1
        FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID;
        
        -- Add product line
        INSERT INTO ReOrderBookLines (
            ReOrderBookID, ProductID, ProductName, SKU,
            QuantityOrdered, UnitOfMeasure, LineNumber, Notes
        )
        VALUES (
            @ReOrderBookID, @ProductID, @ProductName, @SKU,
            @QuantityOrdered, @UnitOfMeasure, @LineNumber, @Notes
        );
        
        SET @ReOrderLineID = SCOPE_IDENTITY();
        
        -- Update header totals
        UPDATE ReOrderBooks
        SET 
            TotalProducts = (SELECT COUNT(*) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID),
            TotalQuantity = (SELECT SUM(QuantityOrdered) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID)
        WHERE ReOrderBookID = @ReOrderBookID;
        
        COMMIT TRANSACTION;
        
        SELECT @ReOrderLineID AS ReOrderLineID, 'SUCCESS' AS Result;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT '✅ sp_AddProductToReOrderBook created';

-- =============================================
-- 3. POST RE-ORDER BOOK (Send to Baker)
-- =============================================
IF OBJECT_ID('sp_PostReOrderBook', 'P') IS NOT NULL
    DROP PROCEDURE sp_PostReOrderBook;
GO

CREATE PROCEDURE sp_PostReOrderBook
    @ReOrderBookID INT,
    @PostedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validate status
        DECLARE @CurrentStatus NVARCHAR(20);
        SELECT @CurrentStatus = Status FROM ReOrderBooks WHERE ReOrderBookID = @ReOrderBookID;
        
        IF @CurrentStatus <> 'Draft'
        BEGIN
            RAISERROR('Can only post Draft re-order books', 16, 1);
            RETURN;
        END
        
        -- Update status
        UPDATE ReOrderBooks
        SET 
            Status = 'Posted',
            PostedBy = @PostedBy,
            PostedDate = GETDATE()
        WHERE ReOrderBookID = @ReOrderBookID;
        
        -- Audit log
        INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, OldStatus, NewStatus, Notes)
        VALUES (@ReOrderBookID, 'Posted', @PostedBy, 'Draft', 'Posted', 'Re-order book posted to baker');
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, 'Re-order book posted to baker' AS Message;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT '✅ sp_PostReOrderBook created';

-- =============================================
-- 4. BAKER STARTS RE-ORDER BOOK
-- =============================================
IF OBJECT_ID('sp_StartReOrderBook', 'P') IS NOT NULL
    DROP PROCEDURE sp_StartReOrderBook;
GO

CREATE PROCEDURE sp_StartReOrderBook
    @ReOrderBookID INT,
    @StartedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        UPDATE ReOrderBooks
        SET 
            Status = 'InProgress',
            StartedBy = @StartedBy,
            StartedDate = GETDATE()
        WHERE ReOrderBookID = @ReOrderBookID;
        
        INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, OldStatus, NewStatus, Notes)
        VALUES (@ReOrderBookID, 'Started', @StartedBy, 'Posted', 'InProgress', 'Baker started production');
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END;
GO

PRINT '✅ sp_StartReOrderBook created';

-- =============================================
-- 5. COMPLETE PRODUCT (Baker finishes baking)
-- =============================================
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
            CompletedBy = @CompletedBy,
            RetailStockUpdated = 1,
            RetailStockUpdateDate = GETDATE()
        WHERE ReOrderLineID = @ReOrderLineID;
        
        -- Update Retail Stock (add finished product)
        -- Check if product exists in StockMovements for this branch
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
            'Completed from Re-Order Book'
        FROM ReOrderBooks rob
        CROSS JOIN Products p
        WHERE rob.ReOrderBookID = @ReOrderBookID AND p.ProductID = @ProductID;
        
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

PRINT '✅ sp_CompleteReOrderProduct created';

-- =============================================
-- 6. GET BAKER'S RE-ORDER BOOKS
-- =============================================
IF OBJECT_ID('sp_GetBakerReOrderBooks', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBakerReOrderBooks;
GO

CREATE PROCEDURE sp_GetBakerReOrderBooks
    @ManufacturerUserID INT,
    @OrderDate DATE = NULL,
    @Status NVARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        rob.ReOrderBookID,
        rob.ReOrderNumber,
        rob.OrderDate,
        rob.RequiredDate,
        rob.Status,
        rob.Priority,
        rob.IsUrgent,
        rob.TotalProducts,
        rob.TotalQuantity,
        rob.CreatedBy,
        rob.CreatedDate,
        rob.PostedDate,
        rob.StartedDate,
        rob.CompletedDate,
        rob.Notes,
        b.BranchName,
        b.BranchCode
    FROM ReOrderBooks rob
    INNER JOIN Branches b ON rob.BranchID = b.BranchID
    WHERE rob.ManufacturerUserID = @ManufacturerUserID
        AND (@OrderDate IS NULL OR rob.OrderDate = @OrderDate)
        AND (@Status IS NULL OR rob.Status = @Status)
    ORDER BY rob.OrderDate DESC, rob.Priority DESC, rob.CreatedDate DESC;
END;
GO

PRINT '✅ sp_GetBakerReOrderBooks created';

-- =============================================
-- 7. GET RE-ORDER BOOK DETAILS (For Printing)
-- =============================================
IF OBJECT_ID('sp_GetReOrderBookDetails', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetReOrderBookDetails;
GO

CREATE PROCEDURE sp_GetReOrderBookDetails
    @ReOrderBookID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Header
    SELECT 
        rob.ReOrderBookID,
        rob.ReOrderNumber,
        rob.OrderDate,
        rob.RequiredDate,
        rob.Status,
        rob.Priority,
        rob.IsUrgent,
        rob.ManufacturerName,
        rob.TotalProducts,
        rob.TotalQuantity,
        rob.CreatedBy,
        rob.CreatedDate,
        rob.PostedBy,
        rob.PostedDate,
        rob.StartedDate,
        rob.CompletedDate,
        rob.Notes,
        b.BranchName,
        b.BranchCode,
        b.Address,
        b.Phone
    FROM ReOrderBooks rob
    INNER JOIN Branches b ON rob.BranchID = b.BranchID
    WHERE rob.ReOrderBookID = @ReOrderBookID;
    
    -- Product Lines
    SELECT 
        rol.ReOrderLineID,
        rol.LineNumber,
        rol.ProductName,
        rol.SKU,
        rol.QuantityOrdered,
        rol.QuantityCompleted,
        rol.UnitOfMeasure,
        rol.LineStatus,
        rol.CompletedDate,
        rol.CompletedBy,
        rol.Notes
    FROM ReOrderBookLines rol
    WHERE rol.ReOrderBookID = @ReOrderBookID
    ORDER BY rol.LineNumber;
    
    -- Update printed status
    UPDATE ReOrderBooks
    SET IsPrinted = 1, LastPrintedDate = GETDATE()
    WHERE ReOrderBookID = @ReOrderBookID;
END;
GO

PRINT '✅ sp_GetReOrderBookDetails created';

-- =============================================
-- 8. GET ALL DRAFT RE-ORDER BOOKS (Admin View)
-- =============================================
IF OBJECT_ID('sp_GetDraftReOrderBooks', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetDraftReOrderBooks;
GO

CREATE PROCEDURE sp_GetDraftReOrderBooks
    @BranchID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        rob.ReOrderBookID,
        rob.ReOrderNumber,
        rob.ManufacturerName,
        rob.OrderDate,
        rob.RequiredDate,
        rob.Status,
        rob.Priority,
        rob.IsUrgent,
        rob.TotalProducts,
        rob.TotalQuantity,
        rob.CreatedBy,
        rob.CreatedDate,
        b.BranchName
    FROM ReOrderBooks rob
    INNER JOIN Branches b ON rob.BranchID = b.BranchID
    WHERE rob.Status = 'Draft'
        AND (@BranchID IS NULL OR rob.BranchID = @BranchID)
    ORDER BY rob.IsUrgent DESC, rob.RequiredDate, rob.CreatedDate;
END;
GO

PRINT '✅ sp_GetDraftReOrderBooks created';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ SIMPLIFIED RE-ORDER BOOK PROCEDURES CREATED!';
PRINT '   - sp_CreateReOrderBook (Create production instructions)';
PRINT '   - sp_AddProductToReOrderBook (Add products to bake)';
PRINT '   - sp_PostReOrderBook (Send to baker)';
PRINT '   - sp_StartReOrderBook (Baker starts work)';
PRINT '   - sp_CompleteReOrderProduct (Complete + update retail stock)';
PRINT '   - sp_GetBakerReOrderBooks (Baker dashboard)';
PRINT '   - sp_GetReOrderBookDetails (Print production sheet)';
PRINT '   - sp_GetDraftReOrderBooks (Admin management)';
PRINT '';
PRINT '🎯 Workflow: Create → Post → Baker creates BOM → Complete → Retail Stock Updated!';
PRINT '═══════════════════════════════════════════════';
