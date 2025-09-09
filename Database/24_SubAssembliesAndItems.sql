/*
    Creates tables for sub-assemblies and category-specific items (decorations, toppings, accessories, packaging)
    and seeds each table with sample data.

    Notes:
    - These are standalone catalogs to support selection dialogs. They can be linked later to RecipeNode or Products if needed.
    - Uses UoM if present; otherwise leaves DefaultUoMID NULL.
*/

SET NOCOUNT ON;
GO

-- Helper: check if a table exists
IF OBJECT_ID('dbo.SubAssemblies', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SubAssemblies (
        SubAssemblyID      INT IDENTITY(1,1) PRIMARY KEY,
        SubAssemblyCode    VARCHAR(50) NOT NULL UNIQUE,
        SubAssemblyName    NVARCHAR(100) NOT NULL,
        DefaultUoMID       INT NULL, -- FK to dbo.UoM(UoMID) if exists
        Description        NVARCHAR(255) NULL,
        IsActive           BIT NOT NULL CONSTRAINT DF_SubAssemblies_IsActive DEFAULT(1),
        CreatedDate        DATETIME NOT NULL CONSTRAINT DF_SubAssemblies_CreatedDate DEFAULT(GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.Decorations', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Decorations (
        DecorationID   INT IDENTITY(1,1) PRIMARY KEY,
        DecorationCode VARCHAR(50) NOT NULL UNIQUE,
        DecorationName NVARCHAR(100) NOT NULL,
        DefaultUoMID   INT NULL,
        Notes          NVARCHAR(255) NULL,
        IsActive       BIT NOT NULL CONSTRAINT DF_Decorations_IsActive DEFAULT(1),
        CreatedDate    DATETIME NOT NULL CONSTRAINT DF_Decorations_CreatedDate DEFAULT(GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.Toppings', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Toppings (
        ToppingID     INT IDENTITY(1,1) PRIMARY KEY,
        ToppingCode   VARCHAR(50) NOT NULL UNIQUE,
        ToppingName   NVARCHAR(100) NOT NULL,
        DefaultUoMID  INT NULL,
        Notes         NVARCHAR(255) NULL,
        IsActive      BIT NOT NULL CONSTRAINT DF_Toppings_IsActive DEFAULT(1),
        CreatedDate   DATETIME NOT NULL CONSTRAINT DF_Toppings_CreatedDate DEFAULT(GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.Accessories', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Accessories (
        AccessoryID    INT IDENTITY(1,1) PRIMARY KEY,
        AccessoryCode  VARCHAR(50) NOT NULL UNIQUE,
        AccessoryName  NVARCHAR(100) NOT NULL,
        DefaultUoMID   INT NULL,
        Notes          NVARCHAR(255) NULL,
        IsActive       BIT NOT NULL CONSTRAINT DF_Accessories_IsActive DEFAULT(1),
        CreatedDate    DATETIME NOT NULL CONSTRAINT DF_Accessories_CreatedDate DEFAULT(GETDATE())
    );
END
GO

IF OBJECT_ID('dbo.Packaging', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Packaging (
        PackagingID    INT IDENTITY(1,1) PRIMARY KEY,
        PackagingCode  VARCHAR(50) NOT NULL UNIQUE,
        PackagingName  NVARCHAR(100) NOT NULL,
        DefaultUoMID   INT NULL,
        Notes          NVARCHAR(255) NULL,
        IsActive       BIT NOT NULL CONSTRAINT DF_Packaging_IsActive DEFAULT(1),
        CreatedDate    DATETIME NOT NULL CONSTRAINT DF_Packaging_CreatedDate DEFAULT(GETDATE())
    );
END
GO

-- Optional FKs to UoM if it exists
IF OBJECT_ID('dbo.UoM', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_SubAssemblies_UoM')
        ALTER TABLE dbo.SubAssemblies  WITH NOCHECK ADD CONSTRAINT FK_SubAssemblies_UoM FOREIGN KEY (DefaultUoMID) REFERENCES dbo.UoM(UoMID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Decorations_UoM')
        ALTER TABLE dbo.Decorations   WITH NOCHECK ADD CONSTRAINT FK_Decorations_UoM FOREIGN KEY (DefaultUoMID) REFERENCES dbo.UoM(UoMID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Toppings_UoM')
        ALTER TABLE dbo.Toppings      WITH NOCHECK ADD CONSTRAINT FK_Toppings_UoM FOREIGN KEY (DefaultUoMID) REFERENCES dbo.UoM(UoMID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Accessories_UoM')
        ALTER TABLE dbo.Accessories   WITH NOCHECK ADD CONSTRAINT FK_Accessories_UoM FOREIGN KEY (DefaultUoMID) REFERENCES dbo.UoM(UoMID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Packaging_UoM')
        ALTER TABLE dbo.Packaging     WITH NOCHECK ADD CONSTRAINT FK_Packaging_UoM FOREIGN KEY (DefaultUoMID) REFERENCES dbo.UoM(UoMID);
END
GO

/* Seed Data (idempotent) */
-- SubAssemblies
IF NOT EXISTS (SELECT 1 FROM dbo.SubAssemblies WHERE SubAssemblyCode = 'SUB-MILKBASE')
    INSERT INTO dbo.SubAssemblies (SubAssemblyCode, SubAssemblyName, DefaultUoMID, Description)
    VALUES ('SUB-MILKBASE', 'Milk Base', NULL, 'Base prepared from milk and sugar');
IF NOT EXISTS (SELECT 1 FROM dbo.SubAssemblies WHERE SubAssemblyCode = 'SUB-GANACHE')
    INSERT INTO dbo.SubAssemblies (SubAssemblyCode, SubAssemblyName, DefaultUoMID, Description)
    VALUES ('SUB-GANACHE', 'Chocolate Ganache', NULL, 'Chocolate + cream mixture');

-- Decorations
IF NOT EXISTS (SELECT 1 FROM dbo.Decorations WHERE DecorationCode = 'DEC-SPRINK')
    INSERT INTO dbo.Decorations (DecorationCode, DecorationName, DefaultUoMID, Notes)
    VALUES ('DEC-SPRINK', 'Sprinkles (Rainbow)', NULL, 'Rainbow sugar sprinkles');
IF NOT EXISTS (SELECT 1 FROM dbo.Decorations WHERE DecorationCode = 'DEC-ICING')
    INSERT INTO dbo.Decorations (DecorationCode, DecorationName, DefaultUoMID, Notes)
    VALUES ('DEC-ICING', 'Icing Flowers', NULL, 'Pre-made icing flowers');

-- Toppings
IF NOT EXISTS (SELECT 1 FROM dbo.Toppings WHERE ToppingCode = 'TOP-ALMOND')
    INSERT INTO dbo.Toppings (ToppingCode, ToppingName, DefaultUoMID, Notes)
    VALUES ('TOP-ALMOND', 'Toasted Almonds', NULL, 'Crunchy almond topping');
IF NOT EXISTS (SELECT 1 FROM dbo.Toppings WHERE ToppingCode = 'TOP-CHIPS')
    INSERT INTO dbo.Toppings (ToppingCode, ToppingName, DefaultUoMID, Notes)
    VALUES ('TOP-CHIPS', 'Chocolate Chips', NULL, 'Semi-sweet chips');

-- Accessories
IF NOT EXISTS (SELECT 1 FROM dbo.Accessories WHERE AccessoryCode = 'ACC-CANDLE')
    INSERT INTO dbo.Accessories (AccessoryCode, AccessoryName, DefaultUoMID, Notes)
    VALUES ('ACC-CANDLE', 'Birthday Candles (Pack)', NULL, 'Assorted colors');
IF NOT EXISTS (SELECT 1 FROM dbo.Accessories WHERE AccessoryCode = 'ACC-TOPPER')
    INSERT INTO dbo.Accessories (AccessoryCode, AccessoryName, DefaultUoMID, Notes)
    VALUES ('ACC-TOPPER', 'Cake Topper - Congrats', NULL, 'Reusable topper');

-- Packaging
IF NOT EXISTS (SELECT 1 FROM dbo.Packaging WHERE PackagingCode = 'PKG-BOX8')
    INSERT INTO dbo.Packaging (PackagingCode, PackagingName, DefaultUoMID, Notes)
    VALUES ('PKG-BOX8', 'Cake Box - 8 inch', NULL, 'White cardboard box 8"')
IF NOT EXISTS (SELECT 1 FROM dbo.Packaging WHERE PackagingCode = 'PKG-RIBBON')
    INSERT INTO dbo.Packaging (PackagingCode, PackagingName, DefaultUoMID, Notes)
    VALUES ('PKG-RIBBON', 'Ribbon (Roll)', NULL, 'Decorative ribbon roll');
GO
