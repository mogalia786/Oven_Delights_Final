/*
10_Upgrade_Add_Manufacturing_Core.sql
Purpose: Additive manufacturing core schema (accounting-aligned) without altering existing Stock Control tables.
- Product categories/subcategories
- Products (Finished/SemiFinished)
- BOM (header/items) allowing Raw, SemiFinished, NonStock components
- Manufacturing Orders (MO) + consumption/output
- Internal Orders (iPO) between Inventory Locations (Stockroom, Manufacturing, Retail)
- InventoryLocations (per branch)
- DocumentNumbering seeds for MO, MI, MR, iPO

Notes:
- Reuses existing dbo.RawMaterials for stock items already in Stock Control.
- No changes to existing PurchaseOrders/GRN/Invoices/CreditNotes tables.
- All objects created only if not exists.
*/

SET NOCOUNT ON;
GO

/* =============================
   Inventory Locations (per branch)
   ============================= */
IF OBJECT_ID('dbo.InventoryLocations','U') IS NULL
BEGIN
    CREATE TABLE dbo.InventoryLocations (
        LocationID    INT IDENTITY(1,1) PRIMARY KEY,
        BranchID      INT NULL,
        LocationCode  NVARCHAR(20) NOT NULL,
        LocationName  NVARCHAR(100) NOT NULL,
        IsActive      BIT NOT NULL DEFAULT 1,
        CreatedDate   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT UQ_InventoryLocations_Code UNIQUE (BranchID, LocationCode)
    );
END
GO

/* Seed default locations per branch: STOCKROOM, MFG, RETAIL */
IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'Branches' AND type = 'U')
BEGIN
    ;WITH B AS (
        SELECT ID AS BranchID FROM dbo.Branches
    )
    INSERT INTO dbo.InventoryLocations (BranchID, LocationCode, LocationName)
    SELECT B.BranchID, C.LocationCode, C.LocationName
    FROM B
    CROSS APPLY (VALUES
        ('STOCKROOM','Stockroom'),
        ('MFG','Manufacturing'),
        ('RETAIL','Retail')
    ) AS C(LocationCode, LocationName)
    WHERE NOT EXISTS (
        SELECT 1 FROM dbo.InventoryLocations L
        WHERE L.BranchID = B.BranchID AND L.LocationCode = C.LocationCode
    );
END
GO

/* =============================
   Product Categories & Subcategories
   ============================= */
IF OBJECT_ID('dbo.ProductCategories','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductCategories (
        CategoryID     INT IDENTITY(1,1) PRIMARY KEY,
        CategoryCode   NVARCHAR(20) NOT NULL UNIQUE,
        CategoryName   NVARCHAR(100) NOT NULL,
        IsActive       BIT NOT NULL DEFAULT 1,
        CreatedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

IF OBJECT_ID('dbo.ProductSubcategories','U') IS NULL
BEGIN
    CREATE TABLE dbo.ProductSubcategories (
        SubcategoryID   INT IDENTITY(1,1) PRIMARY KEY,
        CategoryID      INT NOT NULL,
        SubcategoryCode NVARCHAR(30) NOT NULL,
        SubcategoryName NVARCHAR(100) NOT NULL,
        IsActive        BIT NOT NULL DEFAULT 1,
        CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_ProductSubcategories_Category FOREIGN KEY (CategoryID)
            REFERENCES dbo.ProductCategories(CategoryID),
        CONSTRAINT UQ_ProductSubcategories UNIQUE (CategoryID, SubcategoryCode)
    );
END
GO

/* Optional seed for common bakery categories (non-invasive) */
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories)
BEGIN
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName)
    VALUES ('CAKES','Cakes'),('CONFECT','Confectionery'),('BREAD','Bread'),('ROLLS','Rolls'),('PASTRY','Pastry');
END
GO

/* =============================
   Products (Finished/SemiFinished)
   ============================= */
IF OBJECT_ID('dbo.Products','U') IS NULL
BEGIN
    CREATE TABLE dbo.Products (
        ProductID      INT IDENTITY(1,1) PRIMARY KEY,
        ProductCode    NVARCHAR(30) NOT NULL UNIQUE,
        ProductName    NVARCHAR(150) NOT NULL,
        CategoryID     INT NOT NULL,
        SubcategoryID  INT NULL,
        ItemType       NVARCHAR(20) NOT NULL, -- 'Finished' | 'SemiFinished'
        BaseUoM        NVARCHAR(20) NOT NULL DEFAULT 'ea',
        Dimensions     NVARCHAR(200) NULL, -- e.g., '40x40 cm'
        IsActive       BIT NOT NULL DEFAULT 1,
        CreatedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT CK_Products_ItemType CHECK (ItemType IN ('Finished','SemiFinished')),
        CONSTRAINT FK_Products_Category FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID),
        CONSTRAINT FK_Products_Subcategory FOREIGN KEY (SubcategoryID) REFERENCES dbo.Subcategories(SubcategoryID)
    );
END
GO

/* =============================
   BOM (recipe) - Header and Items
   ============================= */
IF OBJECT_ID('dbo.BOMHeader','U') IS NULL
BEGIN
    CREATE TABLE dbo.BOMHeader (
        BOMID          INT IDENTITY(1,1) PRIMARY KEY,
        ProductID      INT NOT NULL, -- Output item (Finished or SemiFinished)
        VersionNo      INT NOT NULL DEFAULT 1,
        BatchYieldQty  DECIMAL(18,4) NOT NULL,
        YieldUoM       NVARCHAR(20) NOT NULL,
        EffectiveFrom  DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
        EffectiveTo    DATE NULL,
        IsActive       BIT NOT NULL DEFAULT 1,
        CreatedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_BOMHeader_Product FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
    );
END
GO

IF OBJECT_ID('dbo.BOMItems','U') IS NULL
BEGIN
    CREATE TABLE dbo.BOMItems (
        BOMItemID          INT IDENTITY(1,1) PRIMARY KEY,
        BOMID              INT NOT NULL,
        LineNumber         INT NOT NULL,
        ComponentType      NVARCHAR(20) NOT NULL, -- 'RawMaterial' | 'SemiFinished' | 'NonStock'
        RawMaterialID      INT NULL,              -- FK to RawMaterials when ComponentType='RawMaterial'
        ComponentProductID INT NULL,              -- FK to Products when ComponentType='SemiFinished'
        NonStockDesc       NVARCHAR(150) NULL,    -- when ComponentType='NonStock'
        QuantityPerBatch   DECIMAL(18,4) NOT NULL,
        UoM                NVARCHAR(20) NOT NULL,
        Backflush          BIT NOT NULL DEFAULT 0,
        ScrapPercent       DECIMAL(9,4) NULL,
        CONSTRAINT FK_BOMItems_Header FOREIGN KEY (BOMID) REFERENCES dbo.BOMHeader(BOMID),
        CONSTRAINT FK_BOMItems_Raw FOREIGN KEY (RawMaterialID) REFERENCES dbo.RawMaterials(MaterialID),
        CONSTRAINT FK_BOMItems_Prod FOREIGN KEY (ComponentProductID) REFERENCES dbo.Products(ProductID),
        CONSTRAINT CK_BOMItems_ComponentType CHECK (ComponentType IN ('RawMaterial','SemiFinished','NonStock')),
        CONSTRAINT CK_BOMItems_ComponentRefs CHECK (
            (ComponentType = 'RawMaterial'  AND RawMaterialID IS NOT NULL AND ComponentProductID IS NULL AND NonStockDesc IS NULL) OR
            (ComponentType = 'SemiFinished' AND ComponentProductID IS NOT NULL AND RawMaterialID IS NULL AND NonStockDesc IS NULL) OR
            (ComponentType = 'NonStock'     AND NonStockDesc IS NOT NULL AND RawMaterialID IS NULL AND ComponentProductID IS NULL)
        ),
        CONSTRAINT UQ_BOMItems_Line UNIQUE (BOMID, LineNumber)
    );
END
GO

/* =============================
   Manufacturing Orders (MO) and related
   ============================= */
IF OBJECT_ID('dbo.ManufacturingOrders','U') IS NULL
BEGIN
    CREATE TABLE dbo.ManufacturingOrders (
        MOID           INT IDENTITY(1,1) PRIMARY KEY,
        MONumber       NVARCHAR(30) NOT NULL UNIQUE,
        ProductID      INT NOT NULL,
        Quantity       DECIMAL(18,4) NOT NULL,
        UoM            NVARCHAR(20) NOT NULL,
        BranchID       INT NULL,
        RequestedBy    INT NULL,
        Status         NVARCHAR(20) NOT NULL DEFAULT 'Open', -- Open|InProgress|Completed|Closed|Cancelled
        CreatedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        RequiredDate   DATE NULL,
        StartedDate    DATETIME2 NULL,
        CompletedDate  DATETIME2 NULL,
        CONSTRAINT CK_ManufacturingOrders_Status CHECK (Status IN ('Open','InProgress','Completed','Closed','Cancelled')),
        CONSTRAINT FK_MO_Product FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
    );
END
GO

IF OBJECT_ID('dbo.MOConsumption','U') IS NULL
BEGIN
    CREATE TABLE dbo.MOConsumption (
        ConsumptionID      INT IDENTITY(1,1) PRIMARY KEY,
        MOID               INT NOT NULL,
        LineNumber         INT NOT NULL,
        ComponentType      NVARCHAR(20) NOT NULL, -- 'RawMaterial' | 'SemiFinished' | 'NonStock'
        RawMaterialID      INT NULL,
        ComponentProductID INT NULL,
        NonStockDesc       NVARCHAR(150) NULL,
        QuantityIssued     DECIMAL(18,4) NOT NULL DEFAULT 0,
        UoM                NVARCHAR(20) NOT NULL,
        FromLocationID     INT NULL, -- typically Manufacturing or Stockroom
        IssuedDate         DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_MOCons_MO FOREIGN KEY (MOID) REFERENCES dbo.ManufacturingOrders(MOID),
        CONSTRAINT FK_MOCons_Raw FOREIGN KEY (RawMaterialID) REFERENCES dbo.RawMaterials(MaterialID),
        CONSTRAINT FK_MOCons_Prod FOREIGN KEY (ComponentProductID) REFERENCES dbo.Products(ProductID),
        CONSTRAINT FK_MOCons_FromLoc FOREIGN KEY (FromLocationID) REFERENCES dbo.InventoryLocations(LocationID),
        CONSTRAINT CK_MOCons_ComponentType CHECK (ComponentType IN ('RawMaterial','SemiFinished','NonStock')),
        CONSTRAINT CK_MOCons_ComponentRefs CHECK (
            (ComponentType = 'RawMaterial'  AND RawMaterialID IS NOT NULL AND ComponentProductID IS NULL AND NonStockDesc IS NULL) OR
            (ComponentType = 'SemiFinished' AND ComponentProductID IS NOT NULL AND RawMaterialID IS NULL AND NonStockDesc IS NULL) OR
            (ComponentType = 'NonStock'     AND NonStockDesc IS NOT NULL AND RawMaterialID IS NULL AND ComponentProductID IS NULL)
        ),
        CONSTRAINT UQ_MOCons_Line UNIQUE (MOID, LineNumber)
    );
END
GO

IF OBJECT_ID('dbo.MOOutputs','U') IS NULL
BEGIN
    CREATE TABLE dbo.MOOutputs (
        OutputID      INT IDENTITY(1,1) PRIMARY KEY,
        MOID          INT NOT NULL,
        LineNumber    INT NOT NULL,
        QuantityMade  DECIMAL(18,4) NOT NULL,
        UoM           NVARCHAR(20) NOT NULL,
        ToLocationID  INT NULL, -- typically Manufacturing Finished inventory
        ReceivedDate  DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_MOOut_MO FOREIGN KEY (MOID) REFERENCES dbo.ManufacturingOrders(MOID),
        CONSTRAINT FK_MOOut_ToLoc FOREIGN KEY (ToLocationID) REFERENCES dbo.InventoryLocations(LocationID),
        CONSTRAINT UQ_MOOut_Line UNIQUE (MOID, LineNumber)
    );
END
GO

/* =============================
   Internal Orders (iPO) between locations
   ============================= */
IF OBJECT_ID('dbo.InternalOrderHeader','U') IS NULL
BEGIN
    CREATE TABLE dbo.InternalOrderHeader (
        InternalOrderID  INT IDENTITY(1,1) PRIMARY KEY,
        InternalOrderNo  NVARCHAR(30) NOT NULL UNIQUE, -- iPO numbering
        FromLocationID   INT NOT NULL,
        ToLocationID     INT NOT NULL,
        RequestedBy      INT NULL,
        RequestedDate    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        Status           NVARCHAR(20) NOT NULL DEFAULT 'Open', -- Open|Issued|Completed|Cancelled
        Notes            NVARCHAR(255) NULL,
        CONSTRAINT FK_IO_FromLoc FOREIGN KEY (FromLocationID) REFERENCES dbo.InventoryLocations(LocationID),
        CONSTRAINT FK_IO_ToLoc FOREIGN KEY (ToLocationID) REFERENCES dbo.InventoryLocations(LocationID),
        CONSTRAINT CK_IO_Status CHECK (Status IN ('Open','Issued','Completed','Cancelled'))
    );
END
GO

IF OBJECT_ID('dbo.InternalOrderLines','U') IS NULL
BEGIN
    CREATE TABLE dbo.InternalOrderLines (
        InternalOrderLineID INT IDENTITY(1,1) PRIMARY KEY,
        InternalOrderID     INT NOT NULL,
        LineNumber          INT NOT NULL,
        ItemType            NVARCHAR(20) NOT NULL, -- 'RawMaterial' | 'Finished'
        RawMaterialID       INT NULL,              -- when RawMaterial
        ProductID           INT NULL,              -- when Finished (or SemiFinished if needed)
        Quantity            DECIMAL(18,4) NOT NULL,
        UoM                 NVARCHAR(20) NOT NULL,
        Notes               NVARCHAR(255) NULL,
        CONSTRAINT FK_IOL_Header FOREIGN KEY (InternalOrderID) REFERENCES dbo.InternalOrderHeader(InternalOrderID),
        CONSTRAINT FK_IOL_Raw FOREIGN KEY (RawMaterialID) REFERENCES dbo.RawMaterials(MaterialID),
        CONSTRAINT FK_IOL_Prod FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID),
        CONSTRAINT CK_IOL_ItemType CHECK (ItemType IN ('RawMaterial','Finished')),
        CONSTRAINT CK_IOL_Refs CHECK (
            (ItemType = 'RawMaterial' AND RawMaterialID IS NOT NULL AND ProductID IS NULL) OR
            (ItemType = 'Finished'    AND ProductID IS NOT NULL AND RawMaterialID IS NULL)
        ),
        CONSTRAINT UQ_IOL_Line UNIQUE (InternalOrderID, LineNumber)
    );
END
GO

/* =============================
   DocumentNumbering seeds (MO, MI, MR, iPO)
   ============================= */
-- Supports both DocumentNumbering variants: with/without BranchID column
IF OBJECT_ID('dbo.DocumentNumbering','U') IS NOT NULL
BEGIN
    DECLARE @HasBranchColumn BIT = CASE WHEN EXISTS (
        SELECT 1 FROM sys.columns
        WHERE object_id = OBJECT_ID('dbo.DocumentNumbering') AND name = 'BranchID'
    ) THEN 1 ELSE 0 END;

    -- Helper insert: MO, MI, MR, iPO
    IF @HasBranchColumn = 1
    BEGIN
        -- Insert global defaults (BranchID = NULL); admins may override per branch later
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'MO' AND BranchID IS NULL)
            INSERT INTO dbo.DocumentNumbering (DocumentType, BranchID, Prefix, NextNumber, NumberLength)
            VALUES ('MO', NULL, 'MO-', 1, 6);
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'MI' AND BranchID IS NULL)
            INSERT INTO dbo.DocumentNumbering (DocumentType, BranchID, Prefix, NextNumber, NumberLength)
            VALUES ('MI', NULL, 'MI-', 1, 6);
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'MR' AND BranchID IS NULL)
            INSERT INTO dbo.DocumentNumbering (DocumentType, BranchID, Prefix, NextNumber, NumberLength)
            VALUES ('MR', NULL, 'MR-', 1, 6);
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'iPO' AND BranchID IS NULL)
            INSERT INTO dbo.DocumentNumbering (DocumentType, BranchID, Prefix, NextNumber, NumberLength)
            VALUES ('iPO', NULL, 'iPO-', 1, 6);
    END
    ELSE
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'MO')
            INSERT INTO dbo.DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength)
            VALUES ('MO', 'MO-', 1, 6);
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'MI')
            INSERT INTO dbo.DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength)
            VALUES ('MI', 'MI-', 1, 6);
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'MR')
            INSERT INTO dbo.DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength)
            VALUES ('MR', 'MR-', 1, 6);
        IF NOT EXISTS (SELECT 1 FROM dbo.DocumentNumbering WHERE DocumentType = 'iPO')
            INSERT INTO dbo.DocumentNumbering (DocumentType, Prefix, NextNumber, NumberLength)
            VALUES ('iPO', 'iPO-', 1, 6);
    END
END
GO

/* Indexes for lookups */
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_Products_Code' AND object_id = OBJECT_ID('dbo.Products'))
    CREATE INDEX IX_Products_Code ON dbo.Products (ProductCode);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_BOMHeader_Product' AND object_id = OBJECT_ID('dbo.BOMHeader'))
    CREATE INDEX IX_BOMHeader_Product ON dbo.BOMHeader (ProductID, IsActive, EffectiveFrom, EffectiveTo);
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_InternalOrder_FromTo' AND object_id = OBJECT_ID('dbo.InternalOrderHeader'))
    CREATE INDEX IX_InternalOrder_FromTo ON dbo.InternalOrderHeader (FromLocationID, ToLocationID, Status);

PRINT('10_Upgrade_Add_Manufacturing_Core.sql applied successfully.');
