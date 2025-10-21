/*
Oven Delights ERP
Stockroom Module - Database Schema (SQL Server)

This script creates the core Stockroom tables if they do not already exist.
It aligns with existing core tables:
 - Users(UserID)
 - Branches(ID)

Tables created:
 - Suppliers
 - ProductCategories
 - RawMaterials
 - PurchaseOrders, PurchaseOrderLines
 - GoodsReceivedNotes, GRNLines
 - StockMovements
 - StockAdjustments, StockAdjustmentLines
 - StockTransfers, StockTransferLines

Run order: after base schema creation.
*/

SET NOCOUNT ON;
GO

/* Utility: default schema */
IF SCHEMA_ID('dbo') IS NULL EXEC('CREATE SCHEMA dbo');
GO

/* SystemSettings - key/value app settings (e.g., VATRate) */
IF OBJECT_ID('dbo.SystemSettings','U') IS NULL
BEGIN
    CREATE TABLE dbo.SystemSettings (
        [Key]        NVARCHAR(100) NOT NULL PRIMARY KEY,
        [Value]      NVARCHAR(255) NULL,
        Description  NVARCHAR(255) NULL,
        ModifiedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        ModifiedBy   INT NULL,
        CONSTRAINT FK_SystemSettings_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );
END;
GO

/* Suppliers */
IF OBJECT_ID('dbo.Suppliers','U') IS NULL
BEGIN
    CREATE TABLE dbo.Suppliers (
        SupplierID       INT IDENTITY(1,1) PRIMARY KEY,
        SupplierCode     NVARCHAR(20) NOT NULL UNIQUE,
        CompanyName      NVARCHAR(100) NOT NULL,
        ContactPerson    NVARCHAR(100) NULL,
        Email            NVARCHAR(128) NULL,
        Phone            NVARCHAR(20) NULL,
        Mobile           NVARCHAR(20) NULL,
        PhysicalAddress  NVARCHAR(255) NULL,
        City             NVARCHAR(50) NULL,
        Province         NVARCHAR(50) NULL,
        PostalCode       NVARCHAR(10) NULL,
        Country          NVARCHAR(50) NOT NULL DEFAULT N'South Africa',
        VATNumber        NVARCHAR(20) NULL,
        PaymentTermsDays INT NOT NULL DEFAULT 30,
        CreditLimit      DECIMAL(18,2) NOT NULL DEFAULT 0,
        CurrentBalance   DECIMAL(18,2) NOT NULL DEFAULT 0,
        IsActive         BIT NOT NULL DEFAULT 1,
        CreatedDate      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy        INT NOT NULL,
        ModifiedDate     DATETIME2 NULL,
        ModifiedBy       INT NULL,
        CONSTRAINT FK_Suppliers_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_Suppliers_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );
END;
GO

/* ProductCategories */
IF OBJECT_ID('dbo.ProductCategories','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductCategories (
        CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode NVARCHAR(20) NOT NULL UNIQUE,
        CategoryName NVARCHAR(100) NOT NULL,
        Description  NVARCHAR(255) NULL,
        IsActive     BIT NOT NULL DEFAULT 1,
        CreatedDate  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy    INT NOT NULL,
        CONSTRAINT FK_ProductCategories_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID)
    );
END;
GO

/* RawMaterials */
IF OBJECT_ID('dbo.RawMaterials','U') IS NULL
BEGIN
    CREATE TABLE dbo.RawMaterials (
        MaterialID       INT IDENTITY(1,1) PRIMARY KEY,
        MaterialCode     NVARCHAR(20) NOT NULL UNIQUE,
        MaterialName     NVARCHAR(100) NOT NULL,
        Description      NVARCHAR(255) NULL,
        CategoryID       INT NOT NULL,
        BaseUnit         NVARCHAR(20) NOT NULL,
        CurrentStock     DECIMAL(18,4) NOT NULL DEFAULT 0,
        ReorderLevel     DECIMAL(18,4) NOT NULL DEFAULT 0,
        MaxStockLevel    DECIMAL(18,4) NOT NULL DEFAULT 0,
        StandardCost     DECIMAL(18,4) NOT NULL DEFAULT 0,
        LastCost         DECIMAL(18,4) NOT NULL DEFAULT 0,
        AverageCost      DECIMAL(18,4) NOT NULL DEFAULT 0,
        PreferredSupplierID INT NULL,
        IsActive         BIT NOT NULL DEFAULT 1,
        CreatedDate      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy        INT NOT NULL,
        ModifiedDate     DATETIME2 NULL,
        ModifiedBy       INT NULL,
        CONSTRAINT FK_RawMaterials_Category FOREIGN KEY (CategoryID) REFERENCES dbo.ProductCategories(CategoryID),
        CONSTRAINT FK_RawMaterials_PrefSupplier FOREIGN KEY (PreferredSupplierID) REFERENCES dbo.Suppliers(SupplierID),
        CONSTRAINT FK_RawMaterials_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_RawMaterials_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );
    CREATE INDEX IX_RawMaterials_CategoryID ON dbo.RawMaterials(CategoryID);
    CREATE INDEX IX_RawMaterials_Code ON dbo.RawMaterials(MaterialCode);
END;
GO

/* PurchaseOrders */
IF OBJECT_ID('dbo.PurchaseOrders','U') IS NULL
BEGIN
    CREATE TABLE dbo.PurchaseOrders (
        PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
        PONumber        NVARCHAR(30) NOT NULL UNIQUE,
        SupplierID      INT NOT NULL,
        BranchID        INT NOT NULL,
        OrderDate       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        RequiredDate    DATETIME2 NULL,
        DeliveryDate    DATETIME2 NULL,
        Status          NVARCHAR(20) NOT NULL DEFAULT N'Draft',
        SubTotal        DECIMAL(18,2) NOT NULL DEFAULT 0,
        VATAmount       DECIMAL(18,2) NOT NULL DEFAULT 0,
        TotalAmount     AS (SubTotal + VATAmount) PERSISTED,
        Reference       NVARCHAR(50) NULL,
        Notes           NVARCHAR(500) NULL,
        ApprovedBy      INT NULL,
        ApprovedDate    DATETIME2 NULL,
        CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy       INT NOT NULL,
        ModifiedDate    DATETIME2 NULL,
        ModifiedBy      INT NULL,
        CONSTRAINT FK_PO_Supplier FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID),
        CONSTRAINT FK_PO_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
        CONSTRAINT FK_PO_ApprovedBy FOREIGN KEY (ApprovedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_PO_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_PO_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );
    CREATE INDEX IX_PurchaseOrders_SupplierID_OrderDate ON dbo.PurchaseOrders(SupplierID, OrderDate DESC);
END;
GO

/* PurchaseOrderLines */
IF OBJECT_ID('dbo.PurchaseOrderLines','U') IS NULL
BEGIN
    CREATE TABLE dbo.PurchaseOrderLines (
        POLineID        INT IDENTITY(1,1) PRIMARY KEY,
        PurchaseOrderID INT NOT NULL,
        MaterialID      INT NOT NULL,
        OrderedQuantity DECIMAL(18,4) NOT NULL,
        ReceivedQuantity DECIMAL(18,4) NOT NULL DEFAULT 0,
        UnitCost        DECIMAL(18,4) NOT NULL,
        LineTotal       AS (ROUND(UnitCost * OrderedQuantity, 2)) PERSISTED,
        LineStatus      NVARCHAR(20) NOT NULL DEFAULT N'Pending',
        CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_POL_PO FOREIGN KEY (PurchaseOrderID) REFERENCES dbo.PurchaseOrders(PurchaseOrderID),
        CONSTRAINT FK_POL_Material FOREIGN KEY (MaterialID) REFERENCES dbo.RawMaterials(MaterialID)
    );
    CREATE INDEX IX_PurchaseOrderLines_PO ON dbo.PurchaseOrderLines(PurchaseOrderID);
END;
GO

/* GoodsReceivedNotes */
IF OBJECT_ID('dbo.GoodsReceivedNotes','U') IS NULL
BEGIN
    CREATE TABLE dbo.GoodsReceivedNotes (
        GRNID        INT IDENTITY(1,1) PRIMARY KEY,
        GRNNumber    NVARCHAR(30) NOT NULL UNIQUE,
        PurchaseOrderID INT NOT NULL,
        SupplierID   INT NOT NULL,
        ReceivedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        TotalAmount  DECIMAL(18,2) NOT NULL DEFAULT 0,
        Status       NVARCHAR(20) NOT NULL DEFAULT N'Received',
        DeliveryNote NVARCHAR(50) NULL,
        ReceivedBy   INT NOT NULL,
        Notes        NVARCHAR(500) NULL,
        CreatedDate  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy    INT NOT NULL,
        CONSTRAINT FK_GRN_PO FOREIGN KEY (PurchaseOrderID) REFERENCES dbo.PurchaseOrders(PurchaseOrderID),
        CONSTRAINT FK_GRN_Supplier FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID),
        CONSTRAINT FK_GRN_ReceivedBy FOREIGN KEY (ReceivedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_GRN_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID)
    );
END;
GO

/* GRNLines */
IF OBJECT_ID('dbo.GRNLines','U') IS NULL
BEGIN
    CREATE TABLE dbo.GRNLines (
        GRNLineID   INT IDENTITY(1,1) PRIMARY KEY,
        GRNID       INT NOT NULL,
        POLineID    INT NOT NULL,
        MaterialID  INT NOT NULL,
        ReceivedQuantity DECIMAL(18,4) NOT NULL,
        UnitCost    DECIMAL(18,4) NOT NULL,
        LineTotal   AS (ROUND(UnitCost * ReceivedQuantity, 2)) PERSISTED,
        CreatedDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_GRNL_GRN FOREIGN KEY (GRNID) REFERENCES dbo.GoodsReceivedNotes(GRNID),
        CONSTRAINT FK_GRNL_POL FOREIGN KEY (POLineID) REFERENCES dbo.PurchaseOrderLines(POLineID),
        CONSTRAINT FK_GRNL_Material FOREIGN KEY (MaterialID) REFERENCES dbo.RawMaterials(MaterialID)
    );
END;
GO

/* StockMovements */
IF OBJECT_ID('dbo.StockMovements','U') IS NULL
BEGIN
    CREATE TABLE dbo.StockMovements (
        MovementID     INT IDENTITY(1,1) PRIMARY KEY,
        MaterialID     INT NOT NULL,
        MovementType   NVARCHAR(20) NOT NULL, -- Purchase, Sale, Transfer, Adjustment, Production
        MovementDate   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        QuantityIn     DECIMAL(18,4) NOT NULL DEFAULT 0,
        QuantityOut    DECIMAL(18,4) NOT NULL DEFAULT 0,
        BalanceAfter   DECIMAL(18,4) NOT NULL,
        UnitCost       DECIMAL(18,4) NOT NULL DEFAULT 0,
        TotalValue     DECIMAL(18,2) NOT NULL DEFAULT 0,
        InventoryArea  NVARCHAR(20) NOT NULL DEFAULT N'Stockroom', -- Stockroom, Manufacturing, Retail
        ReferenceType  NVARCHAR(20) NULL,
        ReferenceID    INT NULL,
        ReferenceNumber NVARCHAR(30) NULL,
        Notes          NVARCHAR(255) NULL,
        CreatedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy      INT NOT NULL,
        CONSTRAINT FK_StockMovements_Material FOREIGN KEY (MaterialID) REFERENCES dbo.RawMaterials(MaterialID),
        CONSTRAINT FK_StockMovements_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID)
    );
    CREATE INDEX IX_StockMovements_MaterialID_Date ON dbo.StockMovements(MaterialID, MovementDate DESC);
END;
GO

/* StockAdjustments */
IF OBJECT_ID('dbo.StockAdjustments','U') IS NULL
BEGIN
    CREATE TABLE dbo.StockAdjustments (
        AdjustmentID    INT IDENTITY(1,1) PRIMARY KEY,
        AdjustmentNumber NVARCHAR(30) NOT NULL UNIQUE,
        AdjustmentDate  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        ReasonCode      NVARCHAR(20) NOT NULL,
        Reason          NVARCHAR(255) NULL,
        ApprovedBy      INT NULL,
        ApprovedDate    DATETIME2 NULL,
        Status          NVARCHAR(20) NOT NULL DEFAULT N'Draft',
        CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy       INT NOT NULL,
        ModifiedDate    DATETIME2 NULL,
        ModifiedBy      INT NULL,
        CONSTRAINT FK_StockAdjustments_ApprovedBy FOREIGN KEY (ApprovedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_StockAdjustments_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_StockAdjustments_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );
END;
GO

/* StockAdjustmentLines */
IF OBJECT_ID('dbo.StockAdjustmentLines','U') IS NULL
BEGIN
    CREATE TABLE dbo.StockAdjustmentLines (
        AdjustmentLineID  INT IDENTITY(1,1) PRIMARY KEY,
        AdjustmentID      INT NOT NULL,
        MaterialID        INT NOT NULL,
        SystemQuantity    DECIMAL(18,4) NOT NULL,
        ActualQuantity    DECIMAL(18,4) NOT NULL,
        AdjustmentQuantity AS (ActualQuantity - SystemQuantity) PERSISTED,
        UnitCost          DECIMAL(18,4) NOT NULL,
        AdjustmentValue   AS (ROUND((ActualQuantity - SystemQuantity) * UnitCost, 2)) PERSISTED,
        Notes             NVARCHAR(255) NULL,
        CreatedDate       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_StockAdjustmentLines_Header FOREIGN KEY (AdjustmentID) REFERENCES dbo.StockAdjustments(AdjustmentID),
        CONSTRAINT FK_StockAdjustmentLines_Material FOREIGN KEY (MaterialID) REFERENCES dbo.RawMaterials(MaterialID)
    );
END;
GO

/* StockTransfers */
IF OBJECT_ID('dbo.StockTransfers','U') IS NULL
BEGIN
    CREATE TABLE dbo.StockTransfers (
        TransferID     INT IDENTITY(1,1) PRIMARY KEY,
        TransferNumber NVARCHAR(30) NOT NULL UNIQUE,
        FromBranchID   INT NOT NULL,
        ToBranchID     INT NOT NULL,
        TransferDate   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        Status         NVARCHAR(20) NOT NULL DEFAULT N'Draft',
        Reference      NVARCHAR(50) NULL,
        Notes          NVARCHAR(500) NULL,
        ApprovedBy     INT NULL,
        ApprovedDate   DATETIME2 NULL,
        CreatedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy      INT NOT NULL,
        ModifiedDate   DATETIME2 NULL,
        ModifiedBy     INT NULL,
        CONSTRAINT FK_StockTransfers_FromBranch FOREIGN KEY (FromBranchID) REFERENCES dbo.Branches(BranchID),
        CONSTRAINT FK_StockTransfers_ToBranch FOREIGN KEY (ToBranchID) REFERENCES dbo.Branches(BranchID),
        CONSTRAINT FK_StockTransfers_ApprovedBy FOREIGN KEY (ApprovedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_StockTransfers_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES dbo.Users(UserID),
        CONSTRAINT FK_StockTransfers_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );
END;
GO

/* StockTransferLines */
IF OBJECT_ID('dbo.StockTransferLines','U') IS NULL
BEGIN
    CREATE TABLE dbo.StockTransferLines (
        TransferLineID   INT IDENTITY(1,1) PRIMARY KEY,
        TransferID       INT NOT NULL,
        MaterialID       INT NOT NULL,
        TransferQuantity DECIMAL(18,4) NOT NULL,
        ReceivedQuantity DECIMAL(18,4) NOT NULL DEFAULT 0,
        UnitCost         DECIMAL(18,4) NOT NULL,
        LineTotal        AS (ROUND(UnitCost * TransferQuantity, 2)) PERSISTED,
        LineStatus       NVARCHAR(20) NOT NULL DEFAULT N'Pending',
        CreatedDate      DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_StockTransferLines_Header FOREIGN KEY (TransferID) REFERENCES dbo.StockTransfers(TransferID),
        CONSTRAINT FK_StockTransferLines_Material FOREIGN KEY (MaterialID) REFERENCES dbo.RawMaterials(MaterialID)
    );
END;
GO

/* DocumentNumbering - supports per-branch, per-document sequencing with module code */
IF OBJECT_ID('dbo.DocumentNumbering','U') IS NULL
BEGIN
    CREATE TABLE dbo.DocumentNumbering (
        DocumentNumberingID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        DocumentType   NVARCHAR(20) NOT NULL,           -- e.g., PO, GRN, INV
        BranchID       INT NULL,                         -- NULL = global, else per-branch
        ModuleCode     NVARCHAR(5) NOT NULL,             -- ST, M, R
        Prefix         NVARCHAR(10) NULL,                -- optional extra prefix
        NextNumber     INT NOT NULL DEFAULT 1,
        NumberLength   INT NOT NULL DEFAULT 6,
        LastUsedNumber NVARCHAR(50) NULL,
        LastUsedDate   DATETIME2 NULL,
        ModifiedDate   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        ModifiedBy     INT NULL,
        CONSTRAINT FK_DocumentNumbering_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID),
        CONSTRAINT FK_DocumentNumbering_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID)
    );

    -- Indexes are created after this block in a guarded upgrade section
END;
GO

/* sp_GetNextDocumentNumber - returns DU-ST-<DocType>-NNNNNN */
IF OBJECT_ID('dbo.sp_GetNextDocumentNumber','P') IS NOT NULL
    DROP PROCEDURE dbo.sp_GetNextDocumentNumber;
GO
/* Ensure existing DocumentNumbering table has required columns and indexes (upgrade path) */
IF OBJECT_ID('dbo.DocumentNumbering','U') IS NOT NULL
BEGIN
    -- Add missing columns
    IF COL_LENGTH('dbo.DocumentNumbering', 'BranchID') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD BranchID INT NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'ModuleCode') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD ModuleCode NVARCHAR(5) NOT NULL CONSTRAINT DF_DocNum_ModuleCode DEFAULT N'ST';
    IF COL_LENGTH('dbo.DocumentNumbering', 'Prefix') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD Prefix NVARCHAR(10) NULL;
    ELSE IF EXISTS (
        SELECT 1 FROM sys.columns 
        WHERE object_id = OBJECT_ID('dbo.DocumentNumbering') 
          AND name = 'Prefix' AND is_nullable = 0
    )
        ALTER TABLE dbo.DocumentNumbering ALTER COLUMN Prefix NVARCHAR(10) NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'NextNumber') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD NextNumber INT NOT NULL CONSTRAINT DF_DocNum_NextNumber DEFAULT 1;
    IF COL_LENGTH('dbo.DocumentNumbering', 'NumberLength') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD NumberLength INT NOT NULL CONSTRAINT DF_DocNum_NumberLength DEFAULT 6;
    IF COL_LENGTH('dbo.DocumentNumbering', 'LastUsedNumber') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD LastUsedNumber NVARCHAR(50) NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'LastUsedDate') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD LastUsedDate DATETIME2 NULL;
    IF COL_LENGTH('dbo.DocumentNumbering', 'ModifiedDate') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD ModifiedDate DATETIME2 NOT NULL CONSTRAINT DF_DocNum_ModifiedDate DEFAULT SYSUTCDATETIME();
    IF COL_LENGTH('dbo.DocumentNumbering', 'ModifiedBy') IS NULL
        ALTER TABLE dbo.DocumentNumbering ADD ModifiedBy INT NULL;

    -- Foreign keys (guarded via dynamic SQL to avoid parse-time errors)
    DECLARE @sql NVARCHAR(MAX);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DocumentNumbering_Branch')
       AND COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NOT NULL
    BEGIN
        SET @sql = N'ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT FK_DocumentNumbering_Branch FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID);';
        EXEC(@sql);
    END
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_DocumentNumbering_ModifiedBy')
       AND COL_LENGTH('dbo.DocumentNumbering','ModifiedBy') IS NOT NULL
    BEGIN
        SET @sql = N'ALTER TABLE dbo.DocumentNumbering ADD CONSTRAINT FK_DocumentNumbering_ModifiedBy FOREIGN KEY (ModifiedBy) REFERENCES dbo.Users(UserID);';
        EXEC(@sql);
    END

    -- Unique indexes (filtered) if missing, created via dynamic SQL
    IF COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_DocumentNumbering_DocType_Branch' AND object_id = OBJECT_ID('dbo.DocumentNumbering'))
        BEGIN
            SET @sql = N'CREATE UNIQUE INDEX UX_DocumentNumbering_DocType_Branch ON dbo.DocumentNumbering(DocumentType, BranchID) WHERE BranchID IS NOT NULL;';
            EXEC(@sql);
        END
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_DocumentNumbering_DocType_Global' AND object_id = OBJECT_ID('dbo.DocumentNumbering'))
        BEGIN
            SET @sql = N'CREATE UNIQUE INDEX UX_DocumentNumbering_DocType_Global ON dbo.DocumentNumbering(DocumentType) WHERE BranchID IS NULL;';
            EXEC(@sql);
        END
    END
    ELSE
    BEGIN
        -- No BranchID column: create a simple unique index on DocumentType
        IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'UX_DocumentNumbering_DocType_Global' AND object_id = OBJECT_ID('dbo.DocumentNumbering'))
        BEGIN
            SET @sql = N'CREATE UNIQUE INDEX UX_DocumentNumbering_DocType_Global ON dbo.DocumentNumbering(DocumentType);';
            EXEC(@sql);
        END
    END
END;
GO
CREATE PROCEDURE dbo.sp_GetNextDocumentNumber
    @DocumentType   NVARCHAR(20),
    @BranchID       INT,
    @UserID         INT,
    @NextDocNumber  NVARCHAR(50) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ModuleCode NVARCHAR(5);
    -- Map module code
    SET @ModuleCode = CASE
        WHEN @DocumentType IN (N'PO', N'GRN', N'ADJ', N'TRF') THEN N'ST'
        WHEN @DocumentType IN (N'INV') THEN N'R'
        ELSE N'ST'
    END;

    DECLARE @BranchPrefix NVARCHAR(10);
    DECLARE @RoleCode NVARCHAR(5);
    -- Handle both Branches schemas: BranchID (preferred) or ID (legacy)
    IF COL_LENGTH('dbo.Branches','BranchID') IS NOT NULL
    BEGIN
        SELECT @BranchPrefix = COALESCE(NULLIF(LTRIM(RTRIM(Prefix)), N''), UPPER(LEFT(BranchName, 2)))
        FROM dbo.Branches WHERE BranchID = @BranchID;
    END
    ELSE
    BEGIN
        SELECT @BranchPrefix = COALESCE(NULLIF(LTRIM(RTRIM(Prefix)), N''), UPPER(LEFT(BranchName, 2)))
        FROM dbo.Branches WHERE ID = @BranchID;
    END

    -- Derive RoleCode from the user's role; fallback to module code when unavailable
    SELECT TOP 1 @RoleCode =
        CASE
            WHEN r.RoleName LIKE 'Super%Admin%' OR r.RoleName = 'SA' THEN N'SA'
            WHEN r.RoleName LIKE 'Admin' OR r.RoleName = 'A' THEN N'A'
            WHEN r.RoleName LIKE 'Stockroom%Manager%' OR r.RoleName = 'SM' THEN N'SM'
            WHEN r.RoleName LIKE 'Manufacturing%Manager%' OR r.RoleName = 'MM' THEN N'MM'
            WHEN r.RoleName LIKE 'Retail%Manager%' OR r.RoleName = 'RM' THEN N'RM'
            ELSE NULL
        END
    FROM dbo.Users u
    INNER JOIN dbo.Roles r ON r.RoleID = u.RoleID
    WHERE u.UserID = @UserID;

    IF @RoleCode IS NULL SET @RoleCode = @ModuleCode; -- safe fallback
    IF @BranchPrefix IS NULL SET @BranchPrefix = N'BR';

    DECLARE @NumberLength INT, @Next INT, @Prefix NVARCHAR(10);

    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @hasBranchId BIT = CASE WHEN COL_LENGTH('dbo.DocumentNumbering','BranchID') IS NULL THEN 0 ELSE 1 END;

        IF @hasBranchId = 1
        BEGIN
            DECLARE @UsedGlobal BIT = 0;

            -- Try branch-specific row first
            SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
            FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
            WHERE DocumentType = @DocumentType AND BranchID = @BranchID;

            IF @Next IS NULL
            BEGIN
                -- Try global row (BranchID IS NULL) next
                SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                WHERE DocumentType = @DocumentType AND BranchID IS NULL;

                IF @Next IS NOT NULL SET @UsedGlobal = 1;
            END

            IF @Next IS NULL
            BEGIN
                -- No existing row; attempt to insert branch-specific. If PK exists on DocumentType only, this may fail; fallback to global row.
                BEGIN TRY
                    INSERT INTO dbo.DocumentNumbering(DocumentType, BranchID, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                    VALUES(@DocumentType, @BranchID, @ModuleCode, N'', 1, 6, @UserID);

                    -- Load inserted values
                    SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                    FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                    WHERE DocumentType = @DocumentType AND BranchID = @BranchID;
                END TRY
                BEGIN CATCH
                    -- Likely PK on DocumentType only; use/create global row instead
                    IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK) WHERE DocumentType = @DocumentType AND BranchID IS NULL)
                    BEGIN
                        INSERT INTO dbo.DocumentNumbering(DocumentType, BranchID, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                        VALUES(@DocumentType, NULL, @ModuleCode, N'', 1, 6, @UserID);
                    END
                    SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
                    FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                    WHERE DocumentType = @DocumentType AND BranchID IS NULL;
                    SET @UsedGlobal = 1;
                    -- Clear the error
                    IF XACT_STATE() <> -1
                        DECLARE @dummy INT; -- no-op to continue
                END CATCH
            END

            IF @NumberLength IS NULL SET @NumberLength = 6;
            IF @Next IS NULL SET @Next = 1;

            DECLARE @NumberPart NVARCHAR(20) = RIGHT(REPLICATE(N'0', @NumberLength) + CAST(@Next AS NVARCHAR(20)), @NumberLength);
            -- Format: BranchPrefix-RoleCode-Number (e.g., JHB-SM-000123)
            DECLARE @Built NVARCHAR(50) = @BranchPrefix + N'-' + @RoleCode + N'-' + @NumberPart;

            IF @UsedGlobal = 1
            BEGIN
                UPDATE dbo.DocumentNumbering
                  SET NextNumber = @Next + 1,
                      LastUsedNumber = @Built,
                      LastUsedDate = SYSUTCDATETIME(),
                      ModifiedDate = SYSUTCDATETIME(),
                      ModifiedBy = @UserID
                WHERE DocumentType = @DocumentType AND BranchID IS NULL;
            END
            ELSE
            BEGIN
                UPDATE dbo.DocumentNumbering
                  SET NextNumber = @Next + 1,
                      LastUsedNumber = @Built,
                      LastUsedDate = SYSUTCDATETIME(),
                      ModifiedDate = SYSUTCDATETIME(),
                      ModifiedBy = @UserID
                WHERE DocumentType = @DocumentType AND BranchID = @BranchID;
            END

            SET @NextDocNumber = @Built;
        END
        ELSE
        BEGIN
            -- Fallback: table without BranchID (global numbering only)
            IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
                           WHERE DocumentType = @DocumentType)
            BEGIN
                INSERT INTO dbo.DocumentNumbering(DocumentType, ModuleCode, Prefix, NextNumber, NumberLength, ModifiedBy)
                VALUES(@DocumentType, @ModuleCode, N'', 1, 6, @UserID);
            END

            SELECT TOP 1 @Next = NextNumber, @NumberLength = NumberLength, @Prefix = Prefix, @ModuleCode = ModuleCode
            FROM dbo.DocumentNumbering WITH (UPDLOCK, HOLDLOCK)
            WHERE DocumentType = @DocumentType;

            IF @NumberLength IS NULL SET @NumberLength = 6;
            IF @Next IS NULL SET @Next = 1;

            DECLARE @NumberPart2 NVARCHAR(20) = RIGHT(REPLICATE(N'0', @NumberLength) + CAST(@Next AS NVARCHAR(20)), @NumberLength);
            -- Format: BranchPrefix-RoleCode-Number (e.g., JHB-SM-000123)
            DECLARE @Built2 NVARCHAR(50) = @BranchPrefix + N'-' + @RoleCode + N'-' + @NumberPart2;

            UPDATE dbo.DocumentNumbering
              SET NextNumber = @Next + 1,
                  LastUsedNumber = @Built2,
                  LastUsedDate = SYSUTCDATETIME(),
                  ModifiedDate = SYSUTCDATETIME(),
                  ModifiedBy = @UserID
            WHERE DocumentType = @DocumentType;

            SET @NextDocNumber = @Built2;
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT 'Stockroom schema creation completed.';
