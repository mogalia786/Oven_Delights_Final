/*
31_Manufacturing_ProductInventory.sql
Purpose:
- Create ProductInventory and ProductMovements for finished/semi-finished Products at InventoryLocations
- Stored procedures to:
  * Issue materials from Stockroom to Manufacturing for an MO (records StockMovements transfers + MOConsumption)
  * Receive MO outputs into ProductInventory (records ProductMovements + MOOutputs)
  * Transfer finished goods from MFG to RETAIL (records ProductMovements transfers)
Notes:
- Idempotent guards included.
- Respects existing tables from 10_Upgrade_Add_Manufacturing_Core.sql and Stockroom schema.
*/

SET NOCOUNT ON;
GO

/* =============================
   Finished Goods Inventory Tables
   ============================= */
IF OBJECT_ID('dbo.ProductInventory','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductInventory (
        ProductInventoryID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID          INT NOT NULL,
        BranchID           INT NULL,
        LocationID         INT NOT NULL,
        Batch              NVARCHAR(50) NULL,
        QuantityOnHand     DECIMAL(18,4) NOT NULL DEFAULT 0,
        UnitCost           DECIMAL(18,4) NOT NULL DEFAULT 0,
        TotalCost          AS (ROUND(QuantityOnHand * UnitCost, 2)) PERSISTED,
        LastReceived       DATETIME2 NULL,
        LastIssued         DATETIME2 NULL,
        LastUpdated        DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        IsActive           BIT NOT NULL DEFAULT 1,
        CONSTRAINT FK_PI_Product FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
        CONSTRAINT FK_PI_Location FOREIGN KEY (LocationID) REFERENCES dbo.InventoryLocations(LocationID),
        CONSTRAINT UQ_PI UNIQUE (ProductID, BranchID, LocationID, Batch)
    );
    CREATE INDEX IX_ProductInventory_Product ON dbo.ProductInventory(ProductID);
    CREATE INDEX IX_ProductInventory_Location ON dbo.ProductInventory(LocationID);
END
GO

/* =============================
   Proc: Receive Finished Goods to MFG (no MO)
   - Records ProductMovements (QuantityIn)
   - Upserts ProductInventory at MFG location
   ============================= */
IF OBJECT_ID('dbo.sp_FG_ReceiveToMFG','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_FG_ReceiveToMFG AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_FG_ReceiveToMFG
    @ProductID        INT,
    @Quantity         DECIMAL(18,4),
    @BranchID         INT = NULL,
    @UserID           INT = NULL,
    @ToLocationCode   NVARCHAR(20) = N'MFG'
AS
BEGIN
    SET NOCOUNT ON;
    IF @Quantity IS NULL OR @Quantity <= 0 THROW 50030, 'Quantity must be > 0.', 1;

    DECLARE @toLoc INT = dbo.fn_GetLocationId(@BranchID, @ToLocationCode);
    IF @toLoc IS NULL OR @toLoc = 0 THROW 50031, 'Invalid To location.', 1;

    BEGIN TRAN;
    BEGIN TRY
        -- ProductMovements: In to MFG
        INSERT INTO dbo.ProductMovements (ProductID, BranchID, FromLocationID, ToLocationID, MovementType, QuantityIn, QuantityOut, UnitCost, ReferenceType, Notes, CreatedBy)
        VALUES(@ProductID, @BranchID, NULL, @toLoc, N'Adjustment', @Quantity, 0, 0, N'FG-Receive', N'FG receipt to MFG (no MO)', @UserID);

        -- Upsert ProductInventory
        MERGE dbo.ProductInventory AS tgt
        USING (SELECT @ProductID AS ProductID, @BranchID AS BranchID, @toLoc AS LocationID, CAST(NULL AS NVARCHAR(50)) AS Batch) AS src
        ON (tgt.ProductID = src.ProductID AND ISNULL(tgt.BranchID, -1) = ISNULL(src.BranchID, -1) AND tgt.LocationID = src.LocationID AND ISNULL(tgt.Batch,'') = ISNULL(src.Batch,''))
        WHEN MATCHED THEN
            UPDATE SET QuantityOnHand = tgt.QuantityOnHand + @Quantity, LastReceived = SYSUTCDATETIME(), LastUpdated = SYSUTCDATETIME()
        WHEN NOT MATCHED THEN
            INSERT (ProductID, BranchID, LocationID, Batch, QuantityOnHand, UnitCost, LastReceived, LastUpdated)
            VALUES (src.ProductID, src.BranchID, src.LocationID, src.Batch, @Quantity, 0, SYSUTCDATETIME(), SYSUTCDATETIME());

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END
GO

/* =============================
   Type: BOM request items (for multi-BOM bundles)
   ============================= */
IF TYPE_ID('dbo.BOMRequestItem') IS NULL
    CREATE TYPE dbo.BOMRequestItem AS TABLE (
        ProductID   INT        NOT NULL,
        OutputQty   DECIMAL(18,4) NOT NULL
    );
GO

/* =============================
   Proc: Create Internal Order Bundle from one or more BOMs (aggregated)
   - Explodes each BOM and aggregates RawMaterial requirements
   - Creates InternalOrderHeader (From STOCKROOM -> To MFG)
   - Inserts InternalOrderLines (RawMaterial only), consolidated quantities
   - Returns header + lines
   ============================= */
IF OBJECT_ID('dbo.sp_MO_CreateBundleFromBOM','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_MO_CreateBundleFromBOM AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_MO_CreateBundleFromBOM
    @Items            dbo.BOMRequestItem READONLY,
    @BranchID         INT = NULL,
    @UserID           INT = NULL,
    @FromLocationCode NVARCHAR(20) = N'STOCKROOM',
    @ToLocationCode   NVARCHAR(20) = N'MFG'
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM @Items) THROW 50200, 'At least one product is required.', 1;

    DECLARE @fromLoc INT, @toLoc INT;
    SELECT TOP 1 @fromLoc = L.LocationID
    FROM dbo.InventoryLocations L
    WHERE L.LocationCode = @FromLocationCode
      AND ((@BranchID IS NULL AND L.BranchID IS NULL) OR (L.BranchID = @BranchID));
    SELECT TOP 1 @toLoc = L.LocationID
    FROM dbo.InventoryLocations L
    WHERE L.LocationCode = @ToLocationCode
      AND ((@BranchID IS NULL AND L.BranchID IS NULL) OR (L.BranchID = @BranchID));
    IF @fromLoc IS NULL OR @fromLoc = 0 THROW 50201, 'Invalid From location.', 1;
    IF @toLoc   IS NULL OR @toLoc = 0 THROW 50202, 'Invalid To location.', 1;

    IF OBJECT_ID('tempdb..#Req') IS NOT NULL DROP TABLE #Req;
    CREATE TABLE #Req (
        RawMaterialID INT NOT NULL,
        UoM           NVARCHAR(20) NOT NULL,
        RequiredQty   DECIMAL(18,4) NOT NULL
    );

    /* Explode each product's active BOM and accumulate raw material requirements */
    DECLARE @pId INT, @qty DECIMAL(18,4);
    DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
        SELECT ProductID, OutputQty FROM @Items;
    OPEN cur;
    FETCH NEXT FROM cur INTO @pId, @qty;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        DECLARE @BOMID INT, @BatchYield DECIMAL(18,4);
        SELECT TOP 1 @BOMID = H.BOMID, @BatchYield = H.BatchYieldQty
        FROM dbo.BOMHeader H
        WHERE H.ProductID = @pId AND H.IsActive = 1 AND (H.EffectiveTo IS NULL OR H.EffectiveTo >= CAST(GETDATE() AS DATE))
        ORDER BY H.EffectiveFrom DESC, H.BOMID DESC;
        IF @BOMID IS NULL THROW 50203, 'No active BOM found for one or more selected products.', 1;
        IF @BatchYield IS NULL OR @BatchYield <= 0 THROW 50204, 'Invalid BOM batch yield.', 1;

        DECLARE @Scale DECIMAL(18,8) = @qty / @BatchYield;

        INSERT INTO #Req(RawMaterialID, UoM, RequiredQty)
        SELECT BI.RawMaterialID,
               BI.UoM,
               ROUND(BI.QuantityPerBatch * @Scale, 4) AS RequiredQty
        FROM dbo.BOMItems BI
        WHERE BI.BOMID = @BOMID AND BI.ComponentType = 'RawMaterial';

        FETCH NEXT FROM cur INTO @pId, @qty;
    END
    CLOSE cur; DEALLOCATE cur;

    /* Aggregate overlapping materials by RawMaterialID + UoM */
    IF OBJECT_ID('tempdb..#Agg') IS NOT NULL DROP TABLE #Agg;
    SELECT RawMaterialID, UoM, SUM(RequiredQty) AS TotalQty
    INTO #Agg
    FROM #Req
    GROUP BY RawMaterialID, UoM;

    BEGIN TRAN;
    BEGIN TRY
        /* Create InternalOrderHeader */
        DECLARE @ioId INT, @ioNo NVARCHAR(30);

        -- Attempt to get a document number via sp_GetNextDocumentNumber if present
        IF OBJECT_ID('dbo.sp_GetNextDocumentNumber','P') IS NOT NULL
        BEGIN
            DECLARE @NextDoc NVARCHAR(50);
            BEGIN TRY
                EXEC dbo.sp_GetNextDocumentNumber @DocumentType = 'iPO', @BranchID = @BranchID, @UserID = @UserID, @NextDocNumber = @NextDoc OUTPUT;
                SET @ioNo = @NextDoc;
            END TRY
            BEGIN CATCH
                SET @ioNo = CONCAT('iPO-', FORMAT(SYSUTCDATETIME(),'yyyyMMddHHmmss'));
            END CATCH
        END
        ELSE
        BEGIN
            SET @ioNo = CONCAT('iPO-', FORMAT(SYSUTCDATETIME(),'yyyyMMddHHmmss'));
        END

        INSERT INTO dbo.InternalOrderHeader (InternalOrderNo, FromLocationID, ToLocationID, RequestedBy, Status, Notes)
        VALUES(@ioNo, @fromLoc, @toLoc, @UserID, 'Open', N'Bundle created from BOM(s)');
        SET @ioId = SCOPE_IDENTITY();

        -- Persist requested products for completion UI: format "Products: <ProductID>=<Qty>|<ProductID>=<Qty>"
        DECLARE @prodList NVARCHAR(MAX);
        SELECT @prodList = STUFF((
            SELECT '|' + CAST(I.ProductID AS NVARCHAR(20)) + '=' + CAST(I.OutputQty AS NVARCHAR(50))
            FROM @Items I
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');
        IF @prodList IS NOT NULL AND LEN(@prodList) > 0
        BEGIN
            UPDATE dbo.InternalOrderHeader
               SET Notes = CONCAT(ISNULL(Notes,''), CASE WHEN LEN(ISNULL(Notes,''))>0 THEN '; ' ELSE '' END, 'Products: ', @prodList)
             WHERE InternalOrderID = @ioId;
        END

        /* Insert consolidated lines */
        DECLARE @line INT = 0;
        INSERT INTO dbo.InternalOrderLines (InternalOrderID, LineNumber, ItemType, RawMaterialID, ProductID, Quantity, UoM, Notes)
        SELECT @ioId,
               ROW_NUMBER() OVER (ORDER BY A.RawMaterialID),
               'RawMaterial',
               A.RawMaterialID,
               NULL,
               A.TotalQty,
               A.UoM,
               N'Aggregated from BOM bundle'
        FROM #Agg A
        ORDER BY A.RawMaterialID;

        COMMIT;

        -- Return header and lines
        SELECT IOH.InternalOrderID, IOH.InternalOrderNo, IOH.FromLocationID, IOH.ToLocationID, IOH.Status, IOH.RequestedDate
        FROM dbo.InternalOrderHeader IOH
        WHERE IOH.InternalOrderID = @ioId;

        SELECT IOL.InternalOrderLineID, IOL.LineNumber, IOL.ItemType, IOL.RawMaterialID, IOL.Quantity, IOL.UoM
        FROM dbo.InternalOrderLines IOL
        WHERE IOL.InternalOrderID = @ioId
        ORDER BY IOL.LineNumber;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END
GO

/* =============================
   Proc: Fulfill Internal Order Bundle to MFG (stock movements only)
   - Posts StockMovements out of STOCKROOM and in to MFG for each raw material line
   - Updates InternalOrderHeader.Status
   - Returns fulfillment summary
   ============================= */
IF OBJECT_ID('dbo.sp_IO_FulfillToMFG','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_IO_FulfillToMFG AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_IO_FulfillToMFG
    @InternalOrderID   INT,
    @BranchID          INT = NULL,
    @UserID            INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @fromLoc INT, @toLoc INT;
    SELECT @fromLoc = IOH.FromLocationID, @toLoc = IOH.ToLocationID
    FROM dbo.InternalOrderHeader IOH WHERE IOH.InternalOrderID = @InternalOrderID;
    IF @fromLoc IS NULL OR @toLoc IS NULL THROW 50210, 'Internal Order not found.', 1;

    IF OBJECT_ID('tempdb..#Fulfill') IS NOT NULL DROP TABLE #Fulfill;
    CREATE TABLE #Fulfill (
        InternalOrderLineID INT NOT NULL,
        RawMaterialID       INT NOT NULL,
        UoM                 NVARCHAR(20) NOT NULL,
        Quantity            DECIMAL(18,4) NOT NULL
    );

    INSERT INTO #Fulfill(InternalOrderLineID, RawMaterialID, UoM, Quantity)
    SELECT IOL.InternalOrderLineID, IOL.RawMaterialID, IOL.UoM, IOL.Quantity
    FROM dbo.InternalOrderLines IOL
    WHERE IOL.InternalOrderID = @InternalOrderID AND IOL.ItemType = 'RawMaterial';

    BEGIN TRAN;
    BEGIN TRY
        /* For each line, post stock movements out/in */
        DECLARE @LineId INT, @MatId INT, @UoM NVARCHAR(20), @Qty DECIMAL(18,4);
        DECLARE cur2 CURSOR LOCAL FAST_FORWARD FOR
            SELECT InternalOrderLineID, RawMaterialID, UoM, Quantity FROM #Fulfill;
        OPEN cur2;
        FETCH NEXT FROM cur2 INTO @LineId, @MatId, @UoM, @Qty;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Out from FromLocation
            INSERT INTO dbo.StockMovements (MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, InventoryArea, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedBy)
            SELECT @MatId, N'Transfer', SYSUTCDATETIME(), 0, @Qty, 0, rm.AverageCost, ROUND(rm.AverageCost * -@Qty, 2), N'Stockroom', N'iPO', @InternalOrderID, NULL, N'Bundle issue to MFG', @UserID
            FROM dbo.RawMaterials rm WHERE rm.MaterialID = @MatId;

            -- In to ToLocation (MFG store)
            INSERT INTO dbo.StockMovements (MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, InventoryArea, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedBy)
            SELECT @MatId, N'Transfer', SYSUTCDATETIME(), @Qty, 0, 0, rm.AverageCost, ROUND(rm.AverageCost * @Qty, 2), N'Manufacturing', N'iPO', @InternalOrderID, NULL, N'Bundle received at MFG', @UserID
            FROM dbo.RawMaterials rm WHERE rm.MaterialID = @MatId;

            FETCH NEXT FROM cur2 INTO @LineId, @MatId, @UoM, @Qty;
        END
        CLOSE cur2; DEALLOCATE cur2;

        UPDATE dbo.InternalOrderHeader SET Status = 'Issued' WHERE InternalOrderID = @InternalOrderID;

        COMMIT;

        SELECT IOL.InternalOrderLineID, IOL.LineNumber, IOL.RawMaterialID, IOL.Quantity AS IssuedQty, IOL.UoM
        FROM dbo.InternalOrderLines IOL
        WHERE IOL.InternalOrderID = @InternalOrderID
        ORDER BY IOL.LineNumber;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local','cur2') >= -1 BEGIN CLOSE cur2; DEALLOCATE cur2; END
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END
GO

IF OBJECT_ID('dbo.ProductMovements','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductMovements (
        ProductMovementID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID         INT NOT NULL,
        BranchID          INT NULL,
        FromLocationID    INT NULL,
        ToLocationID      INT NULL,
        MovementType      NVARCHAR(20) NOT NULL, -- MO-Output, Transfer, Adjustment
        MovementDate      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        QuantityIn        DECIMAL(18,4) NOT NULL DEFAULT 0,
        QuantityOut       DECIMAL(18,4) NOT NULL DEFAULT 0,
        UnitCost          DECIMAL(18,4) NOT NULL DEFAULT 0,
        TotalValue        AS (ROUND(UnitCost * (QuantityIn - QuantityOut), 2)) PERSISTED,
        ReferenceType     NVARCHAR(30) NULL,
        ReferenceID       INT NULL,
        ReferenceNumber   NVARCHAR(50) NULL,
        Notes             NVARCHAR(255) NULL,
        CreatedBy         INT NULL,
        CreatedDate       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_PM_Product FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
        CONSTRAINT FK_PM_FromLoc FOREIGN KEY (FromLocationID) REFERENCES dbo.InventoryLocations(LocationID),
        CONSTRAINT FK_PM_ToLoc   FOREIGN KEY (ToLocationID)   REFERENCES dbo.InventoryLocations(LocationID)
    );
    CREATE INDEX IX_ProductMovements_Product ON dbo.ProductMovements(ProductID, MovementDate DESC);
END
GO

/* =============================
   Helpers
   ============================= */
IF OBJECT_ID('dbo.fn_GetLocationId','FN') IS NULL
BEGIN
    EXEC('CREATE FUNCTION dbo.fn_GetLocationId(@BranchID INT, @LocationCode NVARCHAR(20)) RETURNS INT AS BEGIN RETURN 0 END');
END
GO

-- Replace body to actual implementation
IF OBJECT_ID('dbo.fn_GetLocationId','FN') IS NOT NULL
BEGIN
    EXEC('ALTER FUNCTION dbo.fn_GetLocationId(@BranchID INT, @LocationCode NVARCHAR(20)) RETURNS INT AS
    BEGIN
        DECLARE @id INT;
        SELECT TOP 1 @id = L.LocationID
        FROM dbo.InventoryLocations L
        WHERE (@BranchID IS NULL OR L.BranchID = @BranchID) AND L.LocationCode = @LocationCode;
        RETURN @id;
    END');
END
GO

/* =============================
   Proc: Issue materials from Stockroom to MFG for MO
   ============================= */
IF OBJECT_ID('dbo.sp_MO_IssueMaterial','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_MO_IssueMaterial AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_MO_IssueMaterial
    @MOID              INT,
    @ComponentType     NVARCHAR(20),   -- RawMaterial | SemiFinished (rare) | NonStock
    @RawMaterialID     INT = NULL,
    @ComponentProductID INT = NULL,
    @Quantity          DECIMAL(18,4),
    @UoM               NVARCHAR(20),
    @FromLocationCode  NVARCHAR(20) = N'' , -- STOCKROOM or MFG
    @ToLocationCode    NVARCHAR(20) = N'MFG',
    @BranchID          INT = NULL,
    @UserID            INT = NULL,
    @OutMovementID     INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @fromLoc INT = dbo.fn_GetLocationId(@BranchID, @FromLocationCode);
    DECLARE @toLoc   INT = dbo.fn_GetLocationId(@BranchID, @ToLocationCode);
    IF @fromLoc IS NULL OR @fromLoc = 0 THROW 50001, 'Invalid From location.', 1;
    IF @toLoc   IS NULL OR @toLoc = 0 THROW 50002, 'Invalid To location.', 1;

    BEGIN TRAN;
    BEGIN TRY
        -- Record consumption line for MO
        DECLARE @line INT = ISNULL((SELECT MAX(LineNumber) FROM dbo.MOConsumption WHERE MOID = @MOID), 0) + 1;
        INSERT INTO dbo.MOConsumption (MOID, LineNumber, ComponentType, RawMaterialID, ComponentProductID, NonStockDesc, QuantityIssued, UoM, FromLocationID)
        VALUES(@MOID, @line, @ComponentType, @RawMaterialID, @ComponentProductID, NULL, @Quantity, @UoM, @fromLoc);

        -- Create StockMovements transfer: Out from FromLocation as InventoryArea
        DECLARE @FromArea NVARCHAR(20) = CASE WHEN @FromLocationCode = N'STOCKROOM' THEN N'Stockroom' ELSE N'Manufacturing' END;
        DECLARE @ToArea   NVARCHAR(20) = CASE WHEN @ToLocationCode = N'RETAIL'    THEN N'Retail'     ELSE N'Manufacturing' END;

        -- Out movement (issue)
        INSERT INTO dbo.StockMovements (MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, InventoryArea, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedBy)
        SELECT @RawMaterialID, N'Transfer', SYSUTCDATETIME(), 0, @Quantity, 0, rm.AverageCost, ROUND(rm.AverageCost * -@Quantity, 2), @FromArea, N'MO', @MOID, NULL, N'Issue to MO', @UserID
        FROM dbo.RawMaterials rm WHERE rm.MaterialID = @RawMaterialID;
        SET @OutMovementID = SCOPE_IDENTITY();

        -- In movement (receive at MFG) for raw materials so MFG store tracks it
        INSERT INTO dbo.StockMovements (MaterialID, MovementType, MovementDate, QuantityIn, QuantityOut, BalanceAfter, UnitCost, TotalValue, InventoryArea, ReferenceType, ReferenceID, ReferenceNumber, Notes, CreatedBy)
        SELECT @RawMaterialID, N'Transfer', SYSUTCDATETIME(), @Quantity, 0, 0, rm.AverageCost, ROUND(rm.AverageCost * @Quantity, 2), @ToArea, N'MO', @MOID, NULL, N'Received at MFG for MO', @UserID
        FROM dbo.RawMaterials rm WHERE rm.MaterialID = @RawMaterialID;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END
GO

/* =============================
   Proc: Receive MO output into ProductInventory
   ============================= */
IF OBJECT_ID('dbo.sp_MO_ReceiveOutput','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_MO_ReceiveOutput AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_MO_ReceiveOutput
    @MOID            INT,
    @QuantityMade    DECIMAL(18,4),
    @UoM             NVARCHAR(20),
    @ToLocationCode  NVARCHAR(20) = N'MFG',
    @BranchID        INT = NULL,
    @UserID          INT = NULL,
    @OutputLineID    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @prodId INT;
    SELECT @prodId = ProductID FROM dbo.ManufacturingOrders WHERE MOID = @MOID;
    IF @prodId IS NULL THROW 50010, 'Manufacturing Order not found.', 1;

    DECLARE @toLoc INT = dbo.fn_GetLocationId(@BranchID, @ToLocationCode);
    IF @toLoc IS NULL OR @toLoc = 0 THROW 50011, 'Invalid To location.', 1;

    BEGIN TRAN;
    BEGIN TRY
        -- Append MOOutputs line
        DECLARE @line INT = ISNULL((SELECT MAX(LineNumber) FROM dbo.MOOutputs WHERE MOID = @MOID), 0) + 1;
        INSERT INTO dbo.MOOutputs (MOID, LineNumber, QuantityMade, UoM, ToLocationID)
        VALUES(@MOID, @line, @QuantityMade, @UoM, @toLoc);
        SET @OutputLineID = SCOPE_IDENTITY();

        -- Record ProductMovements (In to MFG finished inventory)
        INSERT INTO dbo.ProductMovements (ProductID, BranchID, FromLocationID, ToLocationID, MovementType, QuantityIn, QuantityOut, UnitCost, ReferenceType, ReferenceID, Notes, CreatedBy)
        VALUES(@prodId, @BranchID, NULL, @toLoc, N'MO-Output', @QuantityMade, 0, 0, N'MO', @MOID, N'MO output receipt', @UserID);

        -- Upsert ProductInventory
        MERGE dbo.ProductInventory AS tgt
        USING (SELECT @prodId AS ProductID, @BranchID AS BranchID, @toLoc AS LocationID, CAST(NULL AS NVARCHAR(50)) AS Batch) AS src
        ON (tgt.ProductID = src.ProductID AND ISNULL(tgt.BranchID, -1) = ISNULL(src.BranchID, -1) AND tgt.LocationID = src.LocationID AND ISNULL(tgt.Batch,'') = ISNULL(src.Batch,''))
        WHEN MATCHED THEN
            UPDATE SET QuantityOnHand = tgt.QuantityOnHand + @QuantityMade, LastReceived = SYSUTCDATETIME(), LastUpdated = SYSUTCDATETIME()
        WHEN NOT MATCHED THEN
            INSERT (ProductID, BranchID, LocationID, Batch, QuantityOnHand, UnitCost, LastReceived, LastUpdated)
            VALUES (src.ProductID, src.BranchID, src.LocationID, src.Batch, @QuantityMade, 0, SYSUTCDATETIME(), SYSUTCDATETIME());

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END
GO

/* =============================
   Proc: Transfer Finished Goods from MFG to RETAIL
   ============================= */
IF OBJECT_ID('dbo.sp_FG_TransferToRetail','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_FG_TransferToRetail AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_FG_TransferToRetail
    @ProductID        INT,
    @Quantity         DECIMAL(18,4),
    @BranchID         INT = NULL,
    @UserID           INT = NULL,
    @FromLocationCode NVARCHAR(20) = N'MFG',
    @ToLocationCode   NVARCHAR(20) = N'RETAIL'
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @fromLoc INT = dbo.fn_GetLocationId(@BranchID, @FromLocationCode);
    DECLARE @toLoc   INT = dbo.fn_GetLocationId(@BranchID, @ToLocationCode);
    IF @fromLoc IS NULL OR @fromLoc = 0 THROW 50020, 'Invalid From location.', 1;
    IF @toLoc   IS NULL OR @toLoc = 0 THROW 50021, 'Invalid To location.', 1;

    BEGIN TRAN;
    BEGIN TRY
        -- ProductMovements: Out from MFG
        INSERT INTO dbo.ProductMovements (ProductID, BranchID, FromLocationID, ToLocationID, MovementType, QuantityIn, QuantityOut, UnitCost, ReferenceType, Notes, CreatedBy)
        VALUES(@ProductID, @BranchID, @fromLoc, @toLoc, N'Transfer', 0, @Quantity, 0, N'FG-Transfer', N'FG transfer to retail', @UserID);

        -- ProductMovements: In to RETAIL
        INSERT INTO dbo.ProductMovements (ProductID, BranchID, FromLocationID, ToLocationID, MovementType, QuantityIn, QuantityOut, UnitCost, ReferenceType, Notes, CreatedBy)
        VALUES(@ProductID, @BranchID, @fromLoc, @toLoc, N'Transfer', @Quantity, 0, 0, N'FG-Transfer', N'FG transfer to retail', @UserID);

        -- Decrement from MFG ProductInventory
        UPDATE pi
           SET pi.QuantityOnHand = pi.QuantityOnHand - @Quantity,
               pi.LastIssued = SYSUTCDATETIME(),
               pi.LastUpdated = SYSUTCDATETIME()
        FROM dbo.ProductInventory pi
        WHERE pi.ProductID = @ProductID AND ISNULL(pi.BranchID,-1) = ISNULL(@BranchID,-1) AND pi.LocationID = @fromLoc;

        -- Increment into Retail ProductInventory (upsert)
        MERGE dbo.ProductInventory AS tgt
        USING (SELECT @ProductID AS ProductID, @BranchID AS BranchID, @toLoc AS LocationID, CAST(NULL AS NVARCHAR(50)) AS Batch) AS src
        ON (tgt.ProductID = src.ProductID AND ISNULL(tgt.BranchID,-1) = ISNULL(src.BranchID,-1) AND tgt.LocationID = src.LocationID AND ISNULL(tgt.Batch,'') = ISNULL(src.Batch,''))
        WHEN MATCHED THEN
            UPDATE SET QuantityOnHand = tgt.QuantityOnHand + @Quantity, LastReceived = SYSUTCDATETIME(), LastUpdated = SYSUTCDATETIME()
        WHEN NOT MATCHED THEN
            INSERT (ProductID, BranchID, LocationID, Batch, QuantityOnHand, UnitCost, LastReceived, LastUpdated)
            VALUES (src.ProductID, src.BranchID, src.LocationID, src.Batch, @Quantity, 0, SYSUTCDATETIME(), SYSUTCDATETIME());

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END
GO

PRINT '31_Manufacturing_ProductInventory.sql applied (tables + procedures).';

/* =============================
   Proc: Issue all BOM components for an MO (batch)
   ============================= */
IF OBJECT_ID('dbo.sp_MO_IssueFromBOM','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_MO_IssueFromBOM AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_MO_IssueFromBOM
    @MOID              INT,
    @OutputQty         DECIMAL(18,4) = NULL,     -- if NULL, use MO.Quantity
    @BranchID          INT = NULL,
    @UserID            INT = NULL,
    @FromLocationCode  NVARCHAR(20) = N'STOCKROOM',
    @ToLocationCode    NVARCHAR(20) = N'MFG'
AS
BEGIN
    SET NOCOUNT ON;

    /* Resolve MO and Product */
    DECLARE @ProductID INT, @MOQty DECIMAL(18,4), @UoM NVARCHAR(20);
    SELECT @ProductID = ProductID, @MOQty = Quantity, @UoM = UoM
    FROM dbo.ManufacturingOrders WHERE MOID = @MOID;
    IF @ProductID IS NULL THROW 50100, 'Manufacturing Order not found.', 1;
    IF @OutputQty IS NULL SET @OutputQty = ISNULL(@MOQty, 0);
    IF @OutputQty <= 0 THROW 50101, 'Output quantity must be > 0.', 1;

    /* Choose active BOM for product (latest EffectiveFrom) */
    DECLARE @BOMID INT, @BatchYield DECIMAL(18,4), @YieldUoM NVARCHAR(20);
    SELECT TOP 1 @BOMID = H.BOMID, @BatchYield = H.BatchYieldQty, @YieldUoM = H.YieldUoM
    FROM dbo.BOMHeader H
    WHERE H.ProductID = @ProductID AND H.IsActive = 1 AND (H.EffectiveTo IS NULL OR H.EffectiveTo >= CAST(GETDATE() AS DATE))
    ORDER BY H.EffectiveFrom DESC, H.BOMID DESC;
    IF @BOMID IS NULL THROW 50102, 'No active BOM found for product.', 1;
    IF @BatchYield IS NULL OR @BatchYield <= 0 THROW 50103, 'Invalid BOM batch yield.', 1;

    DECLARE @Scale DECIMAL(18,8) = @OutputQty / @BatchYield;

    /* Temp table to collect summary */
    IF OBJECT_ID('tempdb..#IssueSummary') IS NOT NULL DROP TABLE #IssueSummary;
    CREATE TABLE #IssueSummary (
        LineNumber      INT NOT NULL,
        ComponentType   NVARCHAR(20) NOT NULL,
        RawMaterialID   INT NULL,
        ComponentProductID INT NULL,
        NonStockDesc    NVARCHAR(150) NULL,
        RequiredQty     DECIMAL(18,4) NOT NULL,
        UoM             NVARCHAR(20) NOT NULL,
        IssuedQty       DECIMAL(18,4) NOT NULL DEFAULT 0,
        ShortageQty     DECIMAL(18,4) NOT NULL DEFAULT 0
    );

    BEGIN TRAN;
    BEGIN TRY
        /* Iterate BOM items in line order */
        DECLARE @Line INT, @CompType NVARCHAR(20), @RMID INT, @CPID INT, @NS NVARCHAR(150), @QtyPer DECIMAL(18,4), @ItemUoM NVARCHAR(20);
        DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
            SELECT LineNumber, ComponentType, RawMaterialID, ComponentProductID, NonStockDesc, QuantityPerBatch, UoM
            FROM dbo.BOMItems
            WHERE BOMID = @BOMID
            ORDER BY LineNumber;

        OPEN cur;
        FETCH NEXT FROM cur INTO @Line, @CompType, @RMID, @CPID, @NS, @QtyPer, @ItemUoM;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @Req DECIMAL(18,4) = ROUND(@QtyPer * @Scale, 4);

            IF @CompType = 'NonStock'
            BEGIN
                /* Record consumption line only */
                DECLARE @lineNo INT = ISNULL((SELECT MAX(LineNumber) FROM dbo.MOConsumption WHERE MOID = @MOID), 0) + 1;
                INSERT INTO dbo.MOConsumption (MOID, LineNumber, ComponentType, RawMaterialID, ComponentProductID, NonStockDesc, QuantityIssued, UoM, FromLocationID)
                VALUES(@MOID, @lineNo, 'NonStock', NULL, NULL, @NS, @Req, @ItemUoM, NULL);

                INSERT INTO #IssueSummary(LineNumber, ComponentType, RawMaterialID, ComponentProductID, NonStockDesc, RequiredQty, UoM, IssuedQty, ShortageQty)
                VALUES(@Line, 'NonStock', NULL, NULL, @NS, @Req, @ItemUoM, @Req, 0);
            END
            ELSE
            BEGIN
                /* Delegate stock movements to existing proc */
                DECLARE @OutID INT;
                EXEC dbo.sp_MO_IssueMaterial
                    @MOID = @MOID,
                    @ComponentType = @CompType,
                    @RawMaterialID = @RMID,
                    @ComponentProductID = @CPID,
                    @Quantity = @Req,
                    @UoM = @ItemUoM,
                    @FromLocationCode = @FromLocationCode,
                    @ToLocationCode = @ToLocationCode,
                    @BranchID = @BranchID,
                    @UserID = @UserID,
                    @OutMovementID = @OutID OUTPUT;

                INSERT INTO #IssueSummary(LineNumber, ComponentType, RawMaterialID, ComponentProductID, NonStockDesc, RequiredQty, UoM, IssuedQty, ShortageQty)
                VALUES(@Line, @CompType, @RMID, @CPID, NULL, @Req, @ItemUoM, @Req, 0);
            END

            FETCH NEXT FROM cur INTO @Line, @CompType, @RMID, @CPID, @NS, @QtyPer, @ItemUoM;
        END
        CLOSE cur; DEALLOCATE cur;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('local','cur') >= -1 BEGIN CLOSE cur; DEALLOCATE cur; END
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH

    /* Return summary */
    SELECT * FROM #IssueSummary ORDER BY LineNumber;
END
GO
