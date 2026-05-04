-- =============================================
-- RE-ORDER BOOK STORED PROCEDURES
-- Complete workflow from creation to completion
-- =============================================

-- =============================================
-- 1. CREATE NEW RE-ORDER BOOK (Draft)
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
        
        -- Ensure uniqueness
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
        DECLARE @ProductName NVARCHAR(200), @SKU NVARCHAR(50), @BOMHeaderID INT;
        
        SELECT @ProductName = ProductName, @SKU = SKU
        FROM Products WHERE ProductID = @ProductID;
        
        -- Find BOM for this product
        SELECT TOP 1 @BOMHeaderID = BOMHeaderID
        FROM BOMHeader
        WHERE ProductID = @ProductID AND IsActive = 1
        ORDER BY CreatedDate DESC;
        
        -- Get next line number
        DECLARE @LineNumber INT;
        SELECT @LineNumber = ISNULL(MAX(LineNumber), 0) + 1
        FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID;
        
        -- Add product line
        INSERT INTO ReOrderBookLines (
            ReOrderBookID, ProductID, ProductName, SKU,
            QuantityOrdered, UnitOfMeasure, BOMHeaderID,
            LineNumber, Notes
        )
        VALUES (
            @ReOrderBookID, @ProductID, @ProductName, @SKU,
            @QuantityOrdered, @UnitOfMeasure, @BOMHeaderID,
            @LineNumber, @Notes
        );
        
        SET @ReOrderLineID = SCOPE_IDENTITY();
        
        -- Calculate ingredients from RecipeNode (BOM structure)
        IF @BOMHeaderID IS NOT NULL
        BEGIN
            INSERT INTO ReOrderBookIngredients (
                ReOrderBookID, ReOrderLineID, MaterialID, MaterialName, MaterialSKU,
                QuantityRequired, UnitOfMeasure, UnitCost, TotalCost
            )
            SELECT 
                @ReOrderBookID,
                @ReOrderLineID,
                rn.MaterialID,
                rn.ItemName,
                p.SKU,
                rn.Qty * @QuantityOrdered, -- Scale by product quantity
                ISNULL(uom.UoMName, 'Each'),
                ISNULL(p.LastPaidPrice, 0),
                ISNULL(p.LastPaidPrice, 0) * (rn.Qty * @QuantityOrdered)
            FROM RecipeNode rn
            INNER JOIN Products p ON rn.MaterialID = p.ProductID
            LEFT JOIN UnitOfMeasure uom ON rn.UoMID = uom.UoMID
            WHERE rn.ProductID = @ProductID 
                AND rn.MaterialID IS NOT NULL
                AND rn.ItemType IN ('Component', 'Raw Material');
            
            -- Check stock availability
            UPDATE ing
            SET 
                QuantityAvailable = ISNULL(sm.BalanceAfter, 0),
                QuantityShortfall = CASE 
                    WHEN ISNULL(sm.BalanceAfter, 0) < ing.QuantityRequired 
                    THEN ing.QuantityRequired - ISNULL(sm.BalanceAfter, 0)
                    ELSE 0 
                END,
                IsAvailable = CASE 
                    WHEN ISNULL(sm.BalanceAfter, 0) >= ing.QuantityRequired THEN 1 
                    ELSE 0 
                END
            FROM ReOrderBookIngredients ing
            LEFT JOIN (
                SELECT MaterialID, BalanceAfter
                FROM StockMovements sm1
                WHERE sm1.MovementID = (
                    SELECT MAX(MovementID) 
                    FROM StockMovements sm2 
                    WHERE sm2.MaterialID = sm1.MaterialID 
                    AND sm2.InventoryArea = 'Stockroom'
                )
            ) sm ON ing.MaterialID = sm.MaterialID
            WHERE ing.ReOrderLineID = @ReOrderLineID;
        END
        
        -- Update header totals
        UPDATE ReOrderBooks
        SET 
            TotalProducts = (SELECT COUNT(*) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID),
            TotalQuantity = (SELECT SUM(QuantityOrdered) FROM ReOrderBookLines WHERE ReOrderBookID = @ReOrderBookID),
            EstimatedCost = (SELECT SUM(TotalCost) FROM ReOrderBookIngredients WHERE ReOrderBookID = @ReOrderBookID)
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
-- 3. POST RE-ORDER BOOK (Issue to Manufacturing)
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
        
        -- Check ingredient availability
        DECLARE @ShortfallCount INT;
        SELECT @ShortfallCount = COUNT(*)
        FROM ReOrderBookIngredients
        WHERE ReOrderBookID = @ReOrderBookID AND IsAvailable = 0;
        
        IF @ShortfallCount > 0
        BEGIN
            RAISERROR('Cannot post: Some ingredients are not available in sufficient quantity', 16, 1);
            RETURN;
        END
        
        -- Issue ingredients from stockroom to manufacturing
        DECLARE @ReOrderNumber NVARCHAR(50), @BranchID INT;
        SELECT @ReOrderNumber = ReOrderNumber, @BranchID = BranchID
        FROM ReOrderBooks WHERE ReOrderBookID = @ReOrderBookID;
        
        -- Create stock movements for each ingredient
        INSERT INTO StockMovements (
            MaterialID, MovementType, MovementDate,
            QuantityOut, UnitCost, TotalValue,
            InventoryArea, FromLocation, ToLocation,
            ReferenceType, ReferenceNumber,
            RequestedBy, RequestedDate,
            BranchID, CreatedBy, CreatedDate, Notes
        )
        SELECT 
            ing.MaterialID,
            'Transfer to Manufacturing',
            GETDATE(),
            ing.QuantityRequired,
            ing.UnitCost,
            ing.TotalCost,
            'Stockroom',
            'Stockroom',
            'Manufacturing',
            'ReOrder',
            @ReOrderNumber,
            @PostedBy,
            GETDATE(),
            @BranchID,
            @PostedBy,
            GETDATE(),
            'Issued for Re-Order: ' + @ReOrderNumber
        FROM ReOrderBookIngredients ing
        WHERE ing.ReOrderBookID = @ReOrderBookID;
        
        -- Mark ingredients as issued
        UPDATE ReOrderBookIngredients
        SET 
            QuantityIssued = QuantityRequired,
            IssuedDate = GETDATE(),
            IssuedBy = @PostedBy
        WHERE ReOrderBookID = @ReOrderBookID;
        
        -- Update re-order book status
        UPDATE ReOrderBooks
        SET 
            Status = 'Posted',
            PostedBy = @PostedBy,
            PostedDate = GETDATE()
        WHERE ReOrderBookID = @ReOrderBookID;
        
        -- Audit log
        INSERT INTO ReOrderBookAudit (ReOrderBookID, ActionType, ActionBy, OldStatus, NewStatus, Notes)
        VALUES (@ReOrderBookID, 'Posted', @PostedBy, 'Draft', 'Posted', 'Re-order book posted to manufacturing');
        
        COMMIT TRANSACTION;
        
        SELECT 'SUCCESS' AS Result, 'Re-order book posted successfully' AS Message;
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
-- 4. GET BAKER'S RE-ORDER BOOKS
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
        rob.EstimatedCost,
        rob.CreatedBy,
        rob.CreatedDate,
        rob.PostedBy,
        rob.PostedDate,
        rob.Notes,
        rob.IsPrinted,
        rob.LastPrintedDate,
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
-- 5. GET RE-ORDER BOOK DETAILS (For Printing)
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
        rob.EstimatedCost,
        rob.CreatedBy,
        rob.CreatedDate,
        rob.PostedBy,
        rob.PostedDate,
        rob.Notes,
        b.BranchName,
        b.BranchCode,
        b.Address,
        b.PhoneNumber
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
        rol.Notes
    FROM ReOrderBookLines rol
    WHERE rol.ReOrderBookID = @ReOrderBookID
    ORDER BY rol.LineNumber;
    
    -- Ingredients (Grouped by Material)
    SELECT 
        ing.MaterialName,
        ing.MaterialSKU,
        SUM(ing.QuantityRequired) AS TotalQuantityRequired,
        ing.UnitOfMeasure,
        MAX(ing.QuantityAvailable) AS QuantityAvailable,
        SUM(ing.QuantityShortfall) AS TotalShortfall,
        MIN(CAST(ing.IsAvailable AS INT)) AS IsAvailable,
        AVG(ing.UnitCost) AS AvgUnitCost,
        SUM(ing.TotalCost) AS TotalCost
    FROM ReOrderBookIngredients ing
    WHERE ing.ReOrderBookID = @ReOrderBookID
    GROUP BY ing.MaterialName, ing.MaterialSKU, ing.UnitOfMeasure
    ORDER BY ing.MaterialName;
    
    -- Update printed status
    UPDATE ReOrderBooks
    SET IsPrinted = 1, LastPrintedDate = GETDATE()
    WHERE ReOrderBookID = @ReOrderBookID;
END;
GO

PRINT '✅ sp_GetReOrderBookDetails created';

-- =============================================
-- 6. GET ALL DRAFT RE-ORDER BOOKS (Admin View)
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
        rob.EstimatedCost,
        rob.CreatedBy,
        rob.CreatedDate,
        b.BranchName,
        -- Check if all ingredients available
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM ReOrderBookIngredients 
                WHERE ReOrderBookID = rob.ReOrderBookID AND IsAvailable = 0
            ) THEN 0 
            ELSE 1 
        END AS CanPost
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
PRINT '✅ RE-ORDER BOOK PROCEDURES CREATED!';
PRINT '   - sp_CreateReOrderBook (Create draft)';
PRINT '   - sp_AddProductToReOrderBook (Add products with BOM calc)';
PRINT '   - sp_PostReOrderBook (Issue to manufacturing)';
PRINT '   - sp_GetBakerReOrderBooks (Baker dashboard)';
PRINT '   - sp_GetReOrderBookDetails (Print production sheet)';
PRINT '   - sp_GetDraftReOrderBooks (Admin management)';
PRINT '═══════════════════════════════════════════════';
