-- Retail Module Tables (Azure SQL, idempotent)
-- Timestamp: 11-Sep-2025 21:21 SAST

/* Product master */
IF OBJECT_ID('dbo.Retail_Product','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Product(
        ProductID       INT IDENTITY(1,1) PRIMARY KEY,
        SKU             VARCHAR(64) NOT NULL UNIQUE,
        Name            VARCHAR(200) NOT NULL,
        Category        VARCHAR(100) NULL,
        Description     VARCHAR(1000) NULL,
        IsActive        BIT NOT NULL DEFAULT(1),
        CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
END
GO

/* Variant (optional) */
IF OBJECT_ID('dbo.Retail_Variant','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Variant(
        VariantID       INT IDENTITY(1,1) PRIMARY KEY,
        ProductID       INT NOT NULL,
        Barcode         VARCHAR(64) NULL UNIQUE,
        AttributesJson  NVARCHAR(MAX) NULL,
        IsActive        BIT NOT NULL DEFAULT(1),
        CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Variant_Product FOREIGN KEY(ProductID) REFERENCES dbo.Retail_Product(ProductID)
    );
END
GO

/* Price with history (1 active row per product) */
IF OBJECT_ID('dbo.Retail_Price','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Price(
        PriceID         INT IDENTITY(1,1) PRIMARY KEY,
        ProductID       INT NOT NULL,
        BranchID        INT NULL,
        SellingPrice    DECIMAL(18,2) NOT NULL,
        Currency        VARCHAR(8) NOT NULL DEFAULT 'ZAR',
        EffectiveFrom   DATE NOT NULL,
        EffectiveTo     DATE NULL,
        CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Price_Product FOREIGN KEY(ProductID) REFERENCES dbo.Retail_Product(ProductID)
    );
    CREATE INDEX IX_Retail_Price_Product ON dbo.Retail_Price(ProductID, BranchID, EffectiveFrom);
END
GO

/* Stock on hand */
IF OBJECT_ID('dbo.Retail_Stock','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_Stock(
        StockID         INT IDENTITY(1,1) PRIMARY KEY,
        VariantID       INT NOT NULL,
        BranchID        INT NULL,
        QtyOnHand       DECIMAL(18,3) NOT NULL DEFAULT(0),
        ReorderPoint    DECIMAL(18,3) NOT NULL DEFAULT(0),
        Location        VARCHAR(64) NULL,
        LocationKey     AS ISNULL(Location,'') PERSISTED,
        BranchKey       AS ISNULL(BranchID,-1) PERSISTED,
        UpdatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Stock_Variant FOREIGN KEY(VariantID) REFERENCES dbo.Retail_Variant(VariantID),
        CONSTRAINT UQ_Retail_Stock UNIQUE(VariantID, BranchKey, LocationKey)
    );
END
GO

/* Stock movements for audit */
IF OBJECT_ID('dbo.Retail_StockMovements','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_StockMovements(
        MovementID      INT IDENTITY(1,1) PRIMARY KEY,
        VariantID       INT NOT NULL,
        BranchID        INT NULL,
        QtyDelta        DECIMAL(18,3) NOT NULL,
        Reason          VARCHAR(50) NOT NULL, -- Production, Correction, Sale, Return
        Ref1            VARCHAR(100) NULL,
        Ref2            VARCHAR(100) NULL,
        CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CreatedBy       INT NULL,
        CONSTRAINT FK_Retail_Move_Variant FOREIGN KEY(VariantID) REFERENCES dbo.Retail_Variant(VariantID)
    );
    CREATE INDEX IX_Retail_StockMovements_Variant ON dbo.Retail_StockMovements(VariantID, BranchID, CreatedAt);
END
GO

/* Optional: add FK to Branches table if it exists */
IF OBJECT_ID('dbo.Branches','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Retail_Stock_Branch')
        ALTER TABLE dbo.Retail_Stock ADD CONSTRAINT FK_Retail_Stock_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Retail_Price_Branch')
        ALTER TABLE dbo.Retail_Price ADD CONSTRAINT FK_Retail_Price_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Retail_Move_Branch')
        ALTER TABLE dbo.Retail_StockMovements ADD CONSTRAINT FK_Retail_Move_Branch FOREIGN KEY(BranchID) REFERENCES dbo.Branches(BranchID);
END
GO

/* Product images (store URLs to blob/filesystem; thumbs optional) */
IF OBJECT_ID('dbo.Retail_ProductImage','U') IS NULL
BEGIN
    CREATE TABLE dbo.Retail_ProductImage(
        ImageID         INT IDENTITY(1,1) PRIMARY KEY,
        ProductID       INT NOT NULL,
        ImageUrl        NVARCHAR(512) NOT NULL,
        ThumbnailUrl    NVARCHAR(512) NULL,
        IsPrimary       BIT NOT NULL DEFAULT(0),
        CreatedAt       DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_Retail_Image_Product FOREIGN KEY(ProductID) REFERENCES dbo.Retail_Product(ProductID)
    );
    CREATE INDEX IX_Retail_ProductImage_Product ON dbo.Retail_ProductImage(ProductID, IsPrimary);
END
GO

/* Helper: ensure a Variant exists for each Product (if no variants used) */
IF OBJECT_ID('dbo.sp_Retail_EnsureVariant','P') IS NULL
    EXEC('CREATE PROCEDURE dbo.sp_Retail_EnsureVariant AS RETURN 0');
GO
ALTER PROCEDURE dbo.sp_Retail_EnsureVariant
    @ProductID INT,
    @Barcode   VARCHAR(64) = NULL,
    @VariantID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 @VariantID = VariantID FROM dbo.Retail_Variant WHERE ProductID = @ProductID AND IsActive = 1 ORDER BY VariantID;
    IF @VariantID IS NULL
    BEGIN
        INSERT INTO dbo.Retail_Variant(ProductID, Barcode, AttributesJson, IsActive)
        VALUES(@ProductID, @Barcode, NULL, 1);
        SET @VariantID = CAST(SCOPE_IDENTITY() AS INT);
    END
END
GO
