/*
Purpose: Provide a unified selectable catalog for Stockroom CRUD and Invoice dropdowns by
unioning RawMaterials + SubAssemblies + Decorations + Toppings + Accessories + Packaging.

Outputs two views:
- dbo.InventoryCatalogItems         (all records)
- dbo.InventoryCatalogItemsActive   (IsActive = 1 only)

Each row includes a stable ItemType and a composite ItemKey = ItemType:ID for UI binding.
*/

SET NOCOUNT ON;
GO

/* Drop old views if re-running during development (safe if views exist) */
IF OBJECT_ID('dbo.InventoryCatalogItemsActive', 'V') IS NOT NULL DROP VIEW dbo.InventoryCatalogItemsActive;
IF OBJECT_ID('dbo.InventoryCatalogItems', 'V') IS NOT NULL DROP VIEW dbo.InventoryCatalogItems;
GO

CREATE VIEW dbo.InventoryCatalogItems
AS
SELECT
    CAST('RawMaterial' AS VARCHAR(20))    AS ItemType,
    rm.MaterialID                         AS ItemID,
    rm.MaterialCode                       AS ItemCode,
    rm.MaterialName                       AS ItemName,
    CAST(NULL AS INT)                     AS DefaultUoMID,
    rm.IsActive,
    CAST('RawMaterials' AS VARCHAR(30))   AS SourceTable,
    CONCAT('RawMaterial:', rm.MaterialID) AS ItemKey,
    rm.UoMID                              AS UoMID,
    u.UnitName                            AS UnitName
FROM dbo.RawMaterials rm
LEFT JOIN dbo.Units u ON u.UoMID = rm.UoMID

UNION ALL
SELECT
    'SubAssembly'                          AS ItemType,
    sa.SubAssemblyID                       AS ItemID,
    sa.SubAssemblyCode                     AS ItemCode,
    sa.SubAssemblyName                     AS ItemName,
    CAST(NULL AS INT)                      AS DefaultUoMID,
    sa.IsActive,
    'SubAssemblies'                        AS SourceTable,
    CONCAT('SubAssembly:', sa.SubAssemblyID) AS ItemKey,
    sa.UoMID                               AS UoMID,
    u.UnitName                             AS UnitName
FROM dbo.SubAssemblies sa
LEFT JOIN dbo.Units u ON u.UoMID = sa.UoMID

UNION ALL
SELECT
    'Decoration'                           AS ItemType,
    d.DecorationID                         AS ItemID,
    d.DecorationCode                       AS ItemCode,
    d.DecorationName                       AS ItemName,
    CAST(NULL AS INT)                      AS DefaultUoMID,
    d.IsActive,
    'Decorations'                          AS SourceTable,
    CONCAT('Decoration:', d.DecorationID)  AS ItemKey,
    d.UoMID                                AS UoMID,
    u.UnitName                             AS UnitName
FROM dbo.Decorations d
LEFT JOIN dbo.Units u ON u.UoMID = d.UoMID

UNION ALL
SELECT
    'Topping'                              AS ItemType,
    t.ToppingID                            AS ItemID,
    t.ToppingCode                          AS ItemCode,
    t.ToppingName                          AS ItemName,
    CAST(NULL AS INT)                      AS DefaultUoMID,
    t.IsActive,
    'Toppings'                             AS SourceTable,
    CONCAT('Topping:', t.ToppingID)        AS ItemKey,
    t.UoMID                                AS UoMID,
    u.UnitName                             AS UnitName
FROM dbo.Toppings t
LEFT JOIN dbo.Units u ON u.UoMID = t.UoMID

UNION ALL
SELECT
    'Accessory'                            AS ItemType,
    a.AccessoryID                          AS ItemID,
    a.AccessoryCode                        AS ItemCode,
    a.AccessoryName                        AS ItemName,
    CAST(NULL AS INT)                      AS DefaultUoMID,
    a.IsActive,
    'Accessories'                          AS SourceTable,
    CONCAT('Accessory:', a.AccessoryID)    AS ItemKey,
    a.UoMID                                AS UoMID,
    u.UnitName                             AS UnitName
FROM dbo.Accessories a
LEFT JOIN dbo.Units u ON u.UoMID = a.UoMID

UNION ALL
SELECT
    'Packaging'                            AS ItemType,
    p.PackagingID                          AS ItemID,
    p.PackagingCode                        AS ItemCode,
    p.PackagingName                        AS ItemName,
    CAST(NULL AS INT)                      AS DefaultUoMID,
    p.IsActive,
    'Packaging'                            AS SourceTable,
    CONCAT('Packaging:', p.PackagingID)    AS ItemKey,
    p.UoMID                                AS UoMID,
    u.UnitName                             AS UnitName
FROM dbo.Packaging p
LEFT JOIN dbo.Units u ON u.UoMID = p.UoMID;
GO

CREATE VIEW dbo.InventoryCatalogItemsActive
AS
SELECT *
FROM dbo.InventoryCatalogItems
WHERE IsActive = 1;
GO
