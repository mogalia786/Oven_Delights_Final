IF OBJECT_ID('dbo.DailyOrderBook','U') IS NULL
BEGIN
    CREATE TABLE dbo.DailyOrderBook
    (
        BookDate                date           NOT NULL,
        BranchID                int            NOT NULL CONSTRAINT DF_DOB_BranchID DEFAULT (0),
        ProductID               int            NOT NULL,
        SKU                     nvarchar(50)   NULL,
        ProductName             nvarchar(200)  NULL,
        OrderNumber             nvarchar(50)   NULL,
        InternalOrderID         int            NULL,
        OrderQty                decimal(18,2)  NULL,
        RequestedAtUtc          datetime2(7)   NULL,
        RequestedBy             int            NULL,
        RequestedByName         nvarchar(128)  NULL,
        ManufacturerUserID      int            NULL,
        ManufacturerName        nvarchar(128)  NULL,
        IsInternal              bit            NOT NULL CONSTRAINT DF_DOB_IsInternal DEFAULT (1),
        PurchaseOrderID         int            NULL,
        SupplierID              int            NULL,
        SupplierName            nvarchar(128)  NULL,
        PurchaseOrderCreatedAtUtc datetime2(7) NULL,
        StockroomFulfilledAtUtc datetime2(7)   NULL,
        ManufacturingCompletedAtUtc datetime2(7) NULL,
        CreatedAtUtc            datetime2(7)   NOT NULL CONSTRAINT DF_DOB_CreatedAtUtc DEFAULT (sysutcdatetime()),
        UpdatedAtUtc            datetime2(7)   NULL,
        CONSTRAINT PK_DailyOrderBook PRIMARY KEY CLUSTERED (BookDate, ProductID, BranchID)
    );
    CREATE INDEX IX_DOB_Product ON dbo.DailyOrderBook(ProductID);
    CREATE INDEX IX_DOB_IOH ON dbo.DailyOrderBook(InternalOrderID);
    CREATE INDEX IX_DOB_PO ON dbo.DailyOrderBook(PurchaseOrderID);
END
GO

-- Safe schema upgrades for existing databases
IF COL_LENGTH('dbo.DailyOrderBook','IsInternal') IS NULL
BEGIN
    ALTER TABLE dbo.DailyOrderBook ADD IsInternal bit NOT NULL CONSTRAINT DF_DOB_IsInternal WITH VALUES DEFAULT(1);
END
IF COL_LENGTH('dbo.DailyOrderBook','PurchaseOrderID') IS NULL
BEGIN
    ALTER TABLE dbo.DailyOrderBook ADD PurchaseOrderID int NULL;
    IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_DOB_PO' AND object_id = OBJECT_ID('dbo.DailyOrderBook'))
        CREATE INDEX IX_DOB_PO ON dbo.DailyOrderBook(PurchaseOrderID);
END
IF COL_LENGTH('dbo.DailyOrderBook','SupplierID') IS NULL
BEGIN
    ALTER TABLE dbo.DailyOrderBook ADD SupplierID int NULL;
END
IF COL_LENGTH('dbo.DailyOrderBook','SupplierName') IS NULL
BEGIN
    ALTER TABLE dbo.DailyOrderBook ADD SupplierName nvarchar(128) NULL;
END
IF COL_LENGTH('dbo.DailyOrderBook','PurchaseOrderCreatedAtUtc') IS NULL
BEGIN
    ALTER TABLE dbo.DailyOrderBook ADD PurchaseOrderCreatedAtUtc datetime2(7) NULL;
END
GO

-- Upsert requested event
IF OBJECT_ID('dbo.sp_DailyOrderBook_UpsertRequested','P') IS NOT NULL DROP PROCEDURE dbo.sp_DailyOrderBook_UpsertRequested;
GO
CREATE PROCEDURE dbo.sp_DailyOrderBook_UpsertRequested
    @BookDate              date,
    @BranchID              int = NULL,
    @ProductID             int,
    @SKU                   nvarchar(50) = NULL,
    @ProductName           nvarchar(200) = NULL,
    @OrderNumber           nvarchar(50) = NULL,
    @InternalOrderID       int = NULL,
    @OrderQty              decimal(18,2) = NULL,
    @RequestedAtUtc        datetime2(7),
    @RequestedBy           int = NULL,
    @RequestedByName       nvarchar(128) = NULL,
    @ManufacturerUserID    int = NULL,
    @ManufacturerName      nvarchar(128) = NULL,
    @IsInternal            bit = 1,
    @SupplierID            int = NULL,
    @SupplierName          nvarchar(128) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    -- Normalize nullable BranchID to 0 to match table PK
    SET @BranchID = COALESCE(@BranchID, 0);
    MERGE dbo.DailyOrderBook AS tgt
    USING (SELECT @BookDate AS BookDate, @ProductID AS ProductID, @BranchID AS BranchID) AS src
       ON (tgt.BookDate = src.BookDate AND tgt.ProductID = src.ProductID AND tgt.BranchID = src.BranchID)
    WHEN MATCHED THEN
        UPDATE SET SKU=@SKU, ProductName=@ProductName, OrderNumber=@OrderNumber, InternalOrderID=COALESCE(@InternalOrderID, tgt.InternalOrderID),
                   OrderQty=@OrderQty, RequestedAtUtc=@RequestedAtUtc, RequestedBy=@RequestedBy, RequestedByName=@RequestedByName,
                   ManufacturerUserID=@ManufacturerUserID, ManufacturerName=@ManufacturerName, IsInternal = COALESCE(@IsInternal, tgt.IsInternal),
                   SupplierID = COALESCE(@SupplierID, tgt.SupplierID), SupplierName = COALESCE(@SupplierName, tgt.SupplierName),
                   UpdatedAtUtc = sysutcdatetime()
    WHEN NOT MATCHED THEN
        INSERT (BookDate, BranchID, ProductID, SKU, ProductName, OrderNumber, InternalOrderID, OrderQty, RequestedAtUtc, RequestedBy, RequestedByName, ManufacturerUserID, ManufacturerName, IsInternal, SupplierID, SupplierName, UpdatedAtUtc)
        VALUES (@BookDate, @BranchID, @ProductID, @SKU, @ProductName, @OrderNumber, @InternalOrderID, @OrderQty, @RequestedAtUtc, @RequestedBy, @RequestedByName, @ManufacturerUserID, @ManufacturerName, COALESCE(@IsInternal, 1), @SupplierID, @SupplierName, sysutcdatetime());
END
GO

-- Set stockroom fulfilled
IF OBJECT_ID('dbo.sp_DailyOrderBook_SetStockroomFulfilled','P') IS NOT NULL DROP PROCEDURE dbo.sp_DailyOrderBook_SetStockroomFulfilled;
GO
CREATE PROCEDURE dbo.sp_DailyOrderBook_SetStockroomFulfilled
    @BookDate              date,
    @BranchID              int = NULL,
    @ProductID             int = NULL,
    @InternalOrderID       int = NULL,
    @StockroomFulfilledAtUtc datetime2(7)
AS
BEGIN
    SET NOCOUNT ON;
    SET @BranchID = COALESCE(@BranchID, 0);
    UPDATE dbo.DailyOrderBook
       SET StockroomFulfilledAtUtc = @StockroomFulfilledAtUtc,
           UpdatedAtUtc = sysutcdatetime(),
           InternalOrderID = COALESCE(@InternalOrderID, InternalOrderID)
     WHERE BookDate = @BookDate
       AND BranchID = @BranchID
       AND (
            (@ProductID IS NOT NULL AND ProductID = @ProductID)
            OR
            (@ProductID IS NULL AND @InternalOrderID IS NOT NULL AND InternalOrderID = @InternalOrderID)
       );
END
GO

-- Set manufacturing completed
IF OBJECT_ID('dbo.sp_DailyOrderBook_SetManufacturingCompleted','P') IS NOT NULL DROP PROCEDURE dbo.sp_DailyOrderBook_SetManufacturingCompleted;
GO
CREATE PROCEDURE dbo.sp_DailyOrderBook_SetManufacturingCompleted
    @BookDate                 date,
    @BranchID                 int = NULL,
    @ProductID                int = NULL,
    @InternalOrderID          int = NULL,
    @ManufacturingCompletedAtUtc datetime2(7)
AS
BEGIN
    SET NOCOUNT ON;
    SET @BranchID = COALESCE(@BranchID, 0);
    UPDATE dbo.DailyOrderBook
       SET ManufacturingCompletedAtUtc = @ManufacturingCompletedAtUtc,
           UpdatedAtUtc = sysutcdatetime(),
           InternalOrderID = COALESCE(@InternalOrderID, InternalOrderID)
     WHERE BookDate = @BookDate
       AND BranchID = @BranchID
       AND (
            (@ProductID IS NOT NULL AND ProductID = @ProductID)
            OR
            (@ProductID IS NULL AND @InternalOrderID IS NOT NULL AND InternalOrderID = @InternalOrderID)
       );
END
GO
