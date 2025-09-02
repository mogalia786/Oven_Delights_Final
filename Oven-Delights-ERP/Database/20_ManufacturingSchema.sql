-- Manufacturing Schema: Categories, Subcategories, Recipe Templates, Parameters, Components
-- Idempotent guards
IF OBJECT_ID('dbo.Categories','U') IS NULL
BEGIN
    CREATE TABLE dbo.Categories (
        CategoryID INT IDENTITY PRIMARY KEY,
        CategoryName NVARCHAR(100) NOT NULL UNIQUE,
        IsActive BIT NOT NULL DEFAULT 1
    );
END
GO

IF OBJECT_ID('dbo.Subcategories','U') IS NULL
BEGIN
    CREATE TABLE dbo.Subcategories (
        SubcategoryID INT IDENTITY PRIMARY KEY,
        CategoryID INT NOT NULL FOREIGN KEY REFERENCES dbo.Categories(CategoryID),
        SubcategoryName NVARCHAR(100) NOT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CONSTRAINT UQ_Subcategory UNIQUE (CategoryID, SubcategoryName)
    );
END
GO

IF OBJECT_ID('dbo.UoM','U') IS NULL
BEGIN
    CREATE TABLE dbo.UoM (
        UoMID INT IDENTITY PRIMARY KEY,
        UoMCode VARCHAR(10) NOT NULL UNIQUE,
        UoMName NVARCHAR(50) NOT NULL
    );
    INSERT INTO dbo.UoM (UoMCode, UoMName) VALUES ('ea','Each'),('g','Gram'),('kg','Kilogram'),('ml','Millilitre'),('l','Litre'),('cm','Centimetre');
END
GO

IF OBJECT_ID('dbo.Products','U') IS NULL
BEGIN
    CREATE TABLE dbo.Products (
        ProductID INT IDENTITY PRIMARY KEY,
        SKU NVARCHAR(50) NOT NULL UNIQUE,
        ProductName NVARCHAR(100) NOT NULL,
        DefaultUoMID INT NOT NULL FOREIGN KEY REFERENCES dbo.UoM(UoMID),
        LastRolledCost DECIMAL(18,2) NULL,
        LastRolledDate DATETIME NULL,
        IsActive BIT NOT NULL DEFAULT 1
    );
END
GO

IF OBJECT_ID('dbo.Materials','U') IS NULL
BEGIN
    CREATE TABLE dbo.Materials (
        MaterialID INT IDENTITY PRIMARY KEY,
        MaterialCode NVARCHAR(50) NOT NULL UNIQUE,
        MaterialName NVARCHAR(100) NOT NULL,
        DefaultUoMID INT NOT NULL FOREIGN KEY REFERENCES dbo.UoM(UoMID),
        Type VARCHAR(20) NOT NULL DEFAULT 'Raw', -- Raw, Packaging, Service
        IsActive BIT NOT NULL DEFAULT 1
    );
END
GO

IF OBJECT_ID('dbo.RecipeTemplate','U') IS NULL
BEGIN
    CREATE TABLE dbo.RecipeTemplate (
        RecipeTemplateID INT IDENTITY PRIMARY KEY,
        SubcategoryID INT NOT NULL FOREIGN KEY REFERENCES dbo.Subcategories(SubcategoryID),
        TemplateName NVARCHAR(100) NOT NULL,
        DefaultYieldQty DECIMAL(18,4) NOT NULL DEFAULT 1,
        DefaultYieldUoMID INT NOT NULL FOREIGN KEY REFERENCES dbo.UoM(UoMID),
        BranchID INT NULL FOREIGN KEY REFERENCES dbo.Branches(BranchID),
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedBy INT NOT NULL FOREIGN KEY REFERENCES dbo.Users(UserID),
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE()
    );
END
GO

-- Unique when BranchID is NOT NULL
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'UX_RecipeTemplate_SubTemplate_Branch' 
      AND object_id = OBJECT_ID('dbo.RecipeTemplate')
)
BEGIN
    CREATE UNIQUE INDEX UX_RecipeTemplate_SubTemplate_Branch
    ON dbo.RecipeTemplate (SubcategoryID, TemplateName, BranchID)
    WHERE BranchID IS NOT NULL;
END
GO

-- Unique when BranchID is NULL (global templates)
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes 
    WHERE name = 'UX_RecipeTemplate_SubTemplate_Global' 
      AND object_id = OBJECT_ID('dbo.RecipeTemplate')
)
BEGIN
    CREATE UNIQUE INDEX UX_RecipeTemplate_SubTemplate_Global
    ON dbo.RecipeTemplate (SubcategoryID, TemplateName)
    WHERE BranchID IS NULL;
END
GO

IF OBJECT_ID('dbo.RecipeParameters','U') IS NULL
BEGIN
    CREATE TABLE dbo.RecipeParameters (
        RecipeTemplateID INT PRIMARY KEY FOREIGN KEY REFERENCES dbo.RecipeTemplate(RecipeTemplateID),
        UseLength BIT NOT NULL DEFAULT 1,
        UseWidth BIT NOT NULL DEFAULT 1,
        UseHeight BIT NOT NULL DEFAULT 0,
        UseDiameter BIT NOT NULL DEFAULT 0,
        UseLayers BIT NOT NULL DEFAULT 0,
        DefaultLengthCm DECIMAL(18,2) NULL,
        DefaultWidthCm DECIMAL(18,2) NULL,
        DefaultHeightCm DECIMAL(18,2) NULL,
        DefaultDiameterCm DECIMAL(18,2) NULL,
        DefaultLayers INT NULL
    );
END
GO

IF OBJECT_ID('dbo.RecipeComponent','U') IS NULL
BEGIN
    CREATE TABLE dbo.RecipeComponent (
        RecipeComponentID INT IDENTITY PRIMARY KEY,
        RecipeTemplateID INT NOT NULL FOREIGN KEY REFERENCES dbo.RecipeTemplate(RecipeTemplateID),
        [LineNo] INT NOT NULL,
        ComponentType VARCHAR(20) NOT NULL, -- Material, SubAssembly, Decoration
        MaterialID INT NULL FOREIGN KEY REFERENCES dbo.Materials(MaterialID),
        SubAssemblyProductID INT NULL FOREIGN KEY REFERENCES dbo.Products(ProductID),
        BaseQty DECIMAL(18,6) NOT NULL,
        UoMID INT NOT NULL FOREIGN KEY REFERENCES dbo.UoM(UoMID),
        ScrapPercent DECIMAL(5,2) NOT NULL DEFAULT 0,
        IsOptional BIT NOT NULL DEFAULT 0,
        IncludeInStandardCost BIT NOT NULL DEFAULT 1,
        ScalingRule VARCHAR(20) NOT NULL, -- FixedPerBatch, PerUnit, PerArea, PerVolume, PerLayer, PerPerimeter
        BaseAreaCm2 DECIMAL(18,2) NULL,
        BaseVolumeCm3 DECIMAL(18,2) NULL,
        BasePerimeterCm DECIMAL(18,2) NULL,
        Notes NVARCHAR(255) NULL,
        CONSTRAINT UQ_RecipeComp UNIQUE (RecipeTemplateID, [LineNo])
    );
END
GO
