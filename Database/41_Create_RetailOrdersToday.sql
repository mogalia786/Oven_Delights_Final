/* Create table to persist today's retail orders for dashboard */
IF OBJECT_ID('dbo.RetailOrdersToday', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.RetailOrdersToday (
        ID                INT IDENTITY(1,1) PRIMARY KEY,
        OrderDate         DATE        NOT NULL CONSTRAINT DF_RetailOrdersToday_OrderDate DEFAULT (CONVERT(date, GETDATE())),
        CreatedDate       DATETIME    NOT NULL CONSTRAINT DF_RetailOrdersToday_CreatedDate DEFAULT (GETDATE()),
        BranchID          INT         NULL,
        LocationID        INT         NULL,
        OrderNumber       VARCHAR(50) NULL,
        ProductID         INT         NOT NULL,
        SKU               NVARCHAR(100) NULL,
        ProductName       NVARCHAR(200) NULL,
        Qty               DECIMAL(18,2) NOT NULL,
        RequestedBy       INT         NULL,
        RequestedByName   NVARCHAR(150) NULL,
        ManufacturerUserID INT        NULL,
        ManufacturerName  NVARCHAR(150) NULL
    );

    CREATE INDEX IX_RetailOrdersToday_Date ON dbo.RetailOrdersToday(OrderDate);
    CREATE INDEX IX_RetailOrdersToday_DateBranch ON dbo.RetailOrdersToday(OrderDate, BranchID);
END
GO

/* Helper: Upsert procedure to avoid duplicates for same order+product on same day */
IF OBJECT_ID('dbo.sp_RetailOrdersToday_Upsert', 'P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_RetailOrdersToday_Upsert AS BEGIN SET NOCOUNT ON; END');
GO

ALTER PROCEDURE dbo.sp_RetailOrdersToday_Upsert
    @OrderDate          DATE,
    @BranchID           INT,
    @LocationID         INT,
    @OrderNumber        VARCHAR(50),
    @ProductID          INT,
    @SKU                NVARCHAR(100),
    @ProductName        NVARCHAR(200),
    @Qty                DECIMAL(18,2),
    @RequestedBy        INT,
    @RequestedByName    NVARCHAR(150),
    @ManufacturerUserID INT = NULL,
    @ManufacturerName   NVARCHAR(150) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM dbo.RetailOrdersToday t
        WHERE t.OrderDate = @OrderDate
          AND t.BranchID = @BranchID
          AND t.ProductID = @ProductID
    )
    BEGIN
        UPDATE dbo.RetailOrdersToday
           SET OrderNumber = COALESCE(@OrderNumber, OrderNumber),
               SKU = COALESCE(@SKU, SKU),
               ProductName = COALESCE(@ProductName, ProductName),
               Qty = @Qty,
               RequestedBy = @RequestedBy,
               RequestedByName = @RequestedByName,
               ManufacturerUserID = @ManufacturerUserID,
               ManufacturerName = @ManufacturerName,
               LocationID = @LocationID
         WHERE OrderDate = @OrderDate AND BranchID = @BranchID AND ProductID = @ProductID;
    END
    ELSE
    BEGIN
        INSERT INTO dbo.RetailOrdersToday
        (OrderDate, CreatedDate, BranchID, LocationID, OrderNumber, ProductID, SKU, ProductName, Qty, RequestedBy, RequestedByName, ManufacturerUserID, ManufacturerName)
        VALUES
        (@OrderDate, GETDATE(), @BranchID, @LocationID, @OrderNumber, @ProductID, @SKU, @ProductName, @Qty, @RequestedBy, @RequestedByName, @ManufacturerUserID, @ManufacturerName);
    END
END
GO
