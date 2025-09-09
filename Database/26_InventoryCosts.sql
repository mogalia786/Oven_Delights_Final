/*
Adds cost/supplier fields to new catalogs and introduces a unified cost history table,
then exposes a view that includes current/last paid cost + last supplier.

This mirrors typical RawMaterials setup (current cost + last paid/supplier + history).
All FKs to Suppliers are optional (created only if dbo.Suppliers exists).
*/

SET NOCOUNT ON;
GO

/* 1) Extend catalogs with cost/head columns */
IF COL_LENGTH('dbo.SubAssemblies', 'CurrentCost') IS NULL ALTER TABLE dbo.SubAssemblies ADD CurrentCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.SubAssemblies', 'LastPaidCost') IS NULL ALTER TABLE dbo.SubAssemblies ADD LastPaidCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.SubAssemblies', 'LastPurchaseDate') IS NULL ALTER TABLE dbo.SubAssemblies ADD LastPurchaseDate DATETIME NULL;
IF COL_LENGTH('dbo.SubAssemblies', 'LastSupplierID') IS NULL ALTER TABLE dbo.SubAssemblies ADD LastSupplierID INT NULL;

IF COL_LENGTH('dbo.Decorations', 'CurrentCost') IS NULL ALTER TABLE dbo.Decorations ADD CurrentCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Decorations', 'LastPaidCost') IS NULL ALTER TABLE dbo.Decorations ADD LastPaidCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Decorations', 'LastPurchaseDate') IS NULL ALTER TABLE dbo.Decorations ADD LastPurchaseDate DATETIME NULL;
IF COL_LENGTH('dbo.Decorations', 'LastSupplierID') IS NULL ALTER TABLE dbo.Decorations ADD LastSupplierID INT NULL;

IF COL_LENGTH('dbo.Toppings', 'CurrentCost') IS NULL ALTER TABLE dbo.Toppings ADD CurrentCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Toppings', 'LastPaidCost') IS NULL ALTER TABLE dbo.Toppings ADD LastPaidCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Toppings', 'LastPurchaseDate') IS NULL ALTER TABLE dbo.Toppings ADD LastPurchaseDate DATETIME NULL;
IF COL_LENGTH('dbo.Toppings', 'LastSupplierID') IS NULL ALTER TABLE dbo.Toppings ADD LastSupplierID INT NULL;

IF COL_LENGTH('dbo.Accessories', 'CurrentCost') IS NULL ALTER TABLE dbo.Accessories ADD CurrentCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Accessories', 'LastPaidCost') IS NULL ALTER TABLE dbo.Accessories ADD LastPaidCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Accessories', 'LastPurchaseDate') IS NULL ALTER TABLE dbo.Accessories ADD LastPurchaseDate DATETIME NULL;
IF COL_LENGTH('dbo.Accessories', 'LastSupplierID') IS NULL ALTER TABLE dbo.Accessories ADD LastSupplierID INT NULL;

IF COL_LENGTH('dbo.Packaging', 'CurrentCost') IS NULL ALTER TABLE dbo.Packaging ADD CurrentCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Packaging', 'LastPaidCost') IS NULL ALTER TABLE dbo.Packaging ADD LastPaidCost DECIMAL(18,4) NULL;
IF COL_LENGTH('dbo.Packaging', 'LastPurchaseDate') IS NULL ALTER TABLE dbo.Packaging ADD LastPurchaseDate DATETIME NULL;
IF COL_LENGTH('dbo.Packaging', 'LastSupplierID') IS NULL ALTER TABLE dbo.Packaging ADD LastSupplierID INT NULL;
GO

/* Optional FKs to Suppliers */
IF OBJECT_ID('dbo.Suppliers','U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_SubAssemblies_Suppliers')
        ALTER TABLE dbo.SubAssemblies  WITH NOCHECK ADD CONSTRAINT FK_SubAssemblies_Suppliers FOREIGN KEY (LastSupplierID) REFERENCES dbo.Suppliers(SupplierID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Decorations_Suppliers')
        ALTER TABLE dbo.Decorations   WITH NOCHECK ADD CONSTRAINT FK_Decorations_Suppliers FOREIGN KEY (LastSupplierID) REFERENCES dbo.Suppliers(SupplierID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Toppings_Suppliers')
        ALTER TABLE dbo.Toppings      WITH NOCHECK ADD CONSTRAINT FK_Toppings_Suppliers FOREIGN KEY (LastSupplierID) REFERENCES dbo.Suppliers(SupplierID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Accessories_Suppliers')
        ALTER TABLE dbo.Accessories   WITH NOCHECK ADD CONSTRAINT FK_Accessories_Suppliers FOREIGN KEY (LastSupplierID) REFERENCES dbo.Suppliers(SupplierID);
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_Packaging_Suppliers')
        ALTER TABLE dbo.Packaging     WITH NOCHECK ADD CONSTRAINT FK_Packaging_Suppliers FOREIGN KEY (LastSupplierID) REFERENCES dbo.Suppliers(SupplierID);
END
GO

/* 2) Unified cost history table for all item types */
IF OBJECT_ID('dbo.InventoryItemCostHistory','U') IS NULL
BEGIN
    CREATE TABLE dbo.InventoryItemCostHistory (
        HistoryID       INT IDENTITY(1,1) PRIMARY KEY,
        ItemType        VARCHAR(20) NOT NULL,   -- RawMaterial, SubAssembly, Decoration, Topping, Accessory, Packaging
        ItemID          INT NOT NULL,
        SupplierID      INT NULL,              -- optional FK if Suppliers exists
        UoMID           INT NULL,              -- optional FK to UoM
        UnitCost        DECIMAL(18,4) NOT NULL,
        Quantity        DECIMAL(18,4) NULL,
        Currency        VARCHAR(10) NULL,
        PaidDate        DATETIME NULL,
        InvoiceNumber   NVARCHAR(50) NULL,
        Notes           NVARCHAR(255) NULL,
        CreatedDate     DATETIME NOT NULL CONSTRAINT DF_InventoryItemCostHistory_Created DEFAULT(GETDATE())
    );
END
GO

/* Optional FKs */
IF OBJECT_ID('dbo.Suppliers','U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_InvCostHistory_Suppliers')
    ALTER TABLE dbo.InventoryItemCostHistory WITH NOCHECK ADD CONSTRAINT FK_InvCostHistory_Suppliers FOREIGN KEY (SupplierID) REFERENCES dbo.Suppliers(SupplierID);
IF OBJECT_ID('dbo.UoM','U') IS NOT NULL AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name='FK_InvCostHistory_UoM')
    ALTER TABLE dbo.InventoryItemCostHistory WITH NOCHECK ADD CONSTRAINT FK_InvCostHistory_UoM FOREIGN KEY (UoMID) REFERENCES dbo.UoM(UoMID);
GO

/* 3) Recreate unified catalog view with cost info */
IF OBJECT_ID('dbo.InventoryCatalogItemsActive', 'V') IS NOT NULL DROP VIEW dbo.InventoryCatalogItemsActive;
IF OBJECT_ID('dbo.InventoryCatalogItems', 'V') IS NOT NULL DROP VIEW dbo.InventoryCatalogItems;
GO

CREATE VIEW dbo.InventoryCatalogItems
AS
SELECT
    CAST('RawMaterial' AS VARCHAR(20)) AS ItemType,
    rm.MaterialID        AS ItemID,
    rm.MaterialCode      AS ItemCode,
    rm.MaterialName      AS ItemName,
    CAST(NULL AS INT)    AS DefaultUoMID,
    rm.IsActive,
    CAST('RawMaterials' AS VARCHAR(30)) AS SourceTable,
    CONCAT('RawMaterial:', rm.MaterialID) AS ItemKey,
    CAST(NULL AS DECIMAL(18,4)) AS CurrentCost,      -- assuming existing RM has its own cost columns elsewhere
    CAST(NULL AS DECIMAL(18,4)) AS LastPaidCost,
    CAST(NULL AS INT)            AS LastSupplierID,
    CAST(NULL AS DATETIME)       AS LastPurchaseDate
FROM dbo.RawMaterials rm

UNION ALL
SELECT
    'SubAssembly', sa.SubAssemblyID, sa.SubAssemblyCode, sa.SubAssemblyName, CAST(NULL AS INT), sa.IsActive,
    'SubAssemblies', CONCAT('SubAssembly:', sa.SubAssemblyID), sa.CurrentCost, sa.LastPaidCost, sa.LastSupplierID, sa.LastPurchaseDate
FROM dbo.SubAssemblies sa

UNION ALL
SELECT
    'Decoration', d.DecorationID, d.DecorationCode, d.DecorationName, CAST(NULL AS INT), d.IsActive,
    'Decorations', CONCAT('Decoration:', d.DecorationID), d.CurrentCost, d.LastPaidCost, d.LastSupplierID, d.LastPurchaseDate
FROM dbo.Decorations d

UNION ALL
SELECT
    'Topping', t.ToppingID, t.ToppingCode, t.ToppingName, CAST(NULL AS INT), t.IsActive,
    'Toppings', CONCAT('Topping:', t.ToppingID), t.CurrentCost, t.LastPaidCost, t.LastSupplierID, t.LastPurchaseDate
FROM dbo.Toppings t

UNION ALL
SELECT
    'Accessory', a.AccessoryID, a.AccessoryCode, a.AccessoryName, CAST(NULL AS INT), a.IsActive,
    'Accessories', CONCAT('Accessory:', a.AccessoryID), a.CurrentCost, a.LastPaidCost, a.LastSupplierID, a.LastPurchaseDate
FROM dbo.Accessories a

UNION ALL
SELECT
    'Packaging', p.PackagingID, p.PackagingCode, p.PackagingName, CAST(NULL AS INT), p.IsActive,
    'Packaging', CONCAT('Packaging:', p.PackagingID), p.CurrentCost, p.LastPaidCost, p.LastSupplierID, p.LastPurchaseDate
FROM dbo.Packaging p;
GO

CREATE VIEW dbo.InventoryCatalogItemsActive
AS
SELECT * FROM dbo.InventoryCatalogItems WHERE IsActive = 1;
GO
