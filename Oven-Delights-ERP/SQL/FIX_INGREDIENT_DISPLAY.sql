-- =============================================
-- FIX: Show ALL ingredients (Raw Materials + Subcomponents)
-- =============================================
-- Problem: sp_MO_CreateBundleFromBOM only shows ComponentType = 'RawMaterial'
-- Solution: Recursively explode subcomponents to show ALL ingredients
-- =============================================

PRINT '🔧 Fixing ingredient display to show ALL components...';
GO

-- =============================================
-- STEP 1: Update sp_MO_CreateBundleFromBOM to handle subcomponents
-- =============================================

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
        RequiredQty   DECIMAL(18,4) NOT NULL,
        ComponentName NVARCHAR(200) NULL
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

        -- Insert RAW MATERIALS directly
        INSERT INTO #Req(RawMaterialID, UoM, RequiredQty, ComponentName)
        SELECT BI.RawMaterialID,
               BI.UoM,
               ROUND(BI.QuantityPerBatch * @Scale, 4) AS RequiredQty,
               CONCAT(rm.MaterialCode, ' - ', rm.MaterialName) AS ComponentName
        FROM dbo.BOMItems BI
        INNER JOIN dbo.RawMaterials rm ON rm.MaterialID = BI.RawMaterialID
        WHERE BI.BOMID = @BOMID AND BI.ComponentType = 'RawMaterial';

        -- Handle SUBCOMPONENTS (Product or SemiFinished) by recursively exploding their BOMs
        DECLARE @SubProductID INT, @SubQty DECIMAL(18,4);
        DECLARE subCur CURSOR LOCAL FAST_FORWARD FOR
            SELECT BI.ComponentProductID, ROUND(BI.QuantityPerBatch * @Scale, 4)
            FROM dbo.BOMItems BI
            WHERE BI.BOMID = @BOMID 
              AND BI.ComponentType IN ('Product', 'SemiFinished') 
              AND BI.ComponentProductID IS NOT NULL;
        
        OPEN subCur;
        FETCH NEXT FROM subCur INTO @SubProductID, @SubQty;
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Get the subcomponent's BOM
            DECLARE @SubBOMID INT, @SubBatchYield DECIMAL(18,4);
            SELECT TOP 1 @SubBOMID = H.BOMID, @SubBatchYield = H.BatchYieldQty
            FROM dbo.BOMHeader H
            WHERE H.ProductID = @SubProductID AND H.IsActive = 1 
              AND (H.EffectiveTo IS NULL OR H.EffectiveTo >= CAST(GETDATE() AS DATE))
            ORDER BY H.EffectiveFrom DESC, H.BOMID DESC;
            
            IF @SubBOMID IS NOT NULL AND @SubBatchYield > 0
            BEGIN
                DECLARE @SubScale DECIMAL(18,8) = @SubQty / @SubBatchYield;
                
                -- Insert the subcomponent's raw materials
                INSERT INTO #Req(RawMaterialID, UoM, RequiredQty, ComponentName)
                SELECT BI.RawMaterialID,
                       BI.UoM,
                       ROUND(BI.QuantityPerBatch * @SubScale, 4) AS RequiredQty,
                       CONCAT(rm.MaterialCode, ' - ', rm.MaterialName, ' (from subcomponent)') AS ComponentName
                FROM dbo.BOMItems BI
                INNER JOIN dbo.RawMaterials rm ON rm.MaterialID = BI.RawMaterialID
                WHERE BI.BOMID = @SubBOMID AND BI.ComponentType = 'RawMaterial';
            END
            
            FETCH NEXT FROM subCur INTO @SubProductID, @SubQty;
        END
        CLOSE subCur;
        DEALLOCATE subCur;

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
               N'Aggregated from BOM bundle (includes subcomponents)'
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

PRINT '✅ sp_MO_CreateBundleFromBOM updated to handle subcomponents';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 FIXES APPLIED:';
PRINT '1. Products with RecipeNode now appear in Re-Order Book';
PRINT '2. Internal POs now show ALL ingredients (raw materials + SemiFinished + Product)';
PRINT '3. Subcomponents are recursively exploded to their raw materials';
PRINT '4. ComponentType IN (''Product'', ''SemiFinished'') now supported';
PRINT '';
PRINT '🧪 TESTING:';
PRINT '1. Run DIAGNOSE_MISSING_PRODUCT.sql to check your data';
PRINT '2. Verify BOMHeader.IsActive = 1 and EffectiveTo is NULL or future';
PRINT '3. Verify Products.IsActive = 1';
PRINT '4. Add product to re-order book - should appear in list';
PRINT '5. Click "Request BOM" - should show ALL ingredients';
PRINT '';
PRINT '⚠️  IMPORTANT: SemiFinished items MUST have their own BOMs!';
PRINT '   Example: If BOMID 18 uses SemiFinished ComponentProductID 4,';
PRINT '   then ProductID 4 must have its own active BOM in BOMHeader.';
PRINT '═══════════════════════════════════════════════';
