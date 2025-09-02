-- Creates minimal PurchaseOrders and GoodsReceivedNotes tables and a create sproc if they don't exist
SET NOCOUNT ON;
GO

IF OBJECT_ID('dbo.PurchaseOrders','U') IS NULL
BEGIN
    CREATE TABLE dbo.PurchaseOrders(
        PurchaseOrderID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_PurchaseOrders PRIMARY KEY,
        BranchID INT NULL,
        CreatedAtUtc DATETIME2(0) NOT NULL CONSTRAINT DF_PurchaseOrders_CreatedAtUtc DEFAULT (SYSUTCDATETIME()),
        CreatedBy INT NULL,
        SupplierID INT NULL,
        SupplierName NVARCHAR(128) NULL,
        Status NVARCHAR(20) NOT NULL CONSTRAINT DF_PurchaseOrders_Status DEFAULT (N'Draft'),
        Notes NVARCHAR(512) NULL
    );
    CREATE INDEX IX_PurchaseOrders_Status ON dbo.PurchaseOrders(Status) INCLUDE (BranchID);
END
GO

IF OBJECT_ID('dbo.GoodsReceivedNotes','U') IS NULL
BEGIN
    CREATE TABLE dbo.GoodsReceivedNotes(
        GRNID INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_GoodsReceivedNotes PRIMARY KEY,
        BranchID INT NULL,
        PurchaseOrderID INT NULL,
        ReceivedDate DATETIME2(0) NOT NULL CONSTRAINT DF_GRN_ReceivedDate DEFAULT (SYSUTCDATETIME()),
        ReceivedBy INT NULL,
        Notes NVARCHAR(512) NULL
    );
    CREATE INDEX IX_GRN_ReceivedDate ON dbo.GoodsReceivedNotes(ReceivedDate) INCLUDE (BranchID);
END
GO

-- Ensure expected columns exist if PurchaseOrders already exists
IF OBJECT_ID('dbo.PurchaseOrders','U') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.PurchaseOrders','SupplierID') IS NULL
        ALTER TABLE dbo.PurchaseOrders ADD SupplierID INT NULL;
    IF COL_LENGTH('dbo.PurchaseOrders','SupplierName') IS NULL
        ALTER TABLE dbo.PurchaseOrders ADD SupplierName NVARCHAR(128) NULL;
    IF COL_LENGTH('dbo.PurchaseOrders','Notes') IS NULL
        ALTER TABLE dbo.PurchaseOrders ADD Notes NVARCHAR(512) NULL;
    IF COL_LENGTH('dbo.PurchaseOrders','Status') IS NULL
    BEGIN
        ALTER TABLE dbo.PurchaseOrders ADD Status NVARCHAR(20) NULL;
        UPDATE dbo.PurchaseOrders SET Status = N'Draft' WHERE Status IS NULL;
        ALTER TABLE dbo.PurchaseOrders ALTER COLUMN Status NVARCHAR(20) NOT NULL;
        IF OBJECT_ID('DF_PurchaseOrders_Status','D') IS NULL
            ALTER TABLE dbo.PurchaseOrders ADD CONSTRAINT DF_PurchaseOrders_Status DEFAULT (N'Draft') FOR Status;
    END
END
GO

-- Create sproc to insert a PO and return ID
IF OBJECT_ID('dbo.sp_PurchaseOrders_Create','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_PurchaseOrders_Create AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_PurchaseOrders_Create
    @BranchID INT = NULL,
    @CreatedBy INT = NULL,
    @SupplierID INT = NULL,
    @SupplierName NVARCHAR(128) = NULL,
    @Notes NVARCHAR(512) = NULL,
    @PurchaseOrderID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.PurchaseOrders(BranchID, CreatedBy, SupplierID, SupplierName, Notes)
    VALUES(@BranchID, @CreatedBy, @SupplierID, @SupplierName, @Notes);
    SET @PurchaseOrderID = SCOPE_IDENTITY();
END
GO
