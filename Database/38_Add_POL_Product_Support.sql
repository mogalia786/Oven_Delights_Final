/* 38_Add_POL_Product_Support.sql
Purpose:
- Enable Products on Purchase Order lines alongside Raw Materials.
- Add nullable ProductID and ItemSource, enforce exclusivity, and add FK to Products.
- Idempotent and safe to run multiple times.
*/

SET NOCOUNT ON;
GO

/* ---- Columns: ProductID, ItemSource ---- */
IF COL_LENGTH('dbo.PurchaseOrderLines','ProductID') IS NULL
BEGIN
    ALTER TABLE dbo.PurchaseOrderLines ADD ProductID INT NULL;
END
GO

IF COL_LENGTH('dbo.PurchaseOrderLines','ItemSource') IS NULL
BEGIN
    ALTER TABLE dbo.PurchaseOrderLines ADD ItemSource NVARCHAR(2) NULL; -- 'RM' or 'PR'
END
GO

/* ---- Make MaterialID nullable to allow Product-only lines ---- */
IF EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.PurchaseOrderLines') 
      AND name = 'MaterialID' 
      AND is_nullable = 0
)
BEGIN
    ALTER TABLE dbo.PurchaseOrderLines ALTER COLUMN MaterialID INT NULL;
END
GO

/* ---- Backfill ItemSource for existing RM rows ---- */
UPDATE dbo.PurchaseOrderLines
   SET ItemSource = 'RM'
 WHERE ItemSource IS NULL AND MaterialID IS NOT NULL;
GO

/* ---- Allowed values constraint for ItemSource ---- */
IF NOT EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_POL_ItemSource_Allowed'
      AND parent_object_id = OBJECT_ID('dbo.PurchaseOrderLines')
)
BEGIN
    ALTER TABLE dbo.PurchaseOrderLines
        ADD CONSTRAINT CK_POL_ItemSource_Allowed
        CHECK (ItemSource IN ('RM','PR'));
END
GO

/* ---- Exclusivity constraint: exactly one of MaterialID or ProductID, and ItemSource must match ---- */
IF EXISTS (
    SELECT 1 FROM sys.check_constraints
    WHERE name = 'CK_POL_ItemChoice'
      AND parent_object_id = OBJECT_ID('dbo.PurchaseOrderLines')
)
BEGIN
    ALTER TABLE dbo.PurchaseOrderLines DROP CONSTRAINT CK_POL_ItemChoice;
END
GO

ALTER TABLE dbo.PurchaseOrderLines
    ADD CONSTRAINT CK_POL_ItemChoice
    CHECK (
        (MaterialID IS NOT NULL AND ProductID IS     NULL AND ItemSource = 'RM') OR
        (MaterialID IS     NULL AND ProductID IS NOT NULL AND ItemSource = 'PR')
    );
GO

/* ---- Foreign Key to Products ---- */
IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = 'FK_POL_Product'
      AND parent_object_id = OBJECT_ID('dbo.PurchaseOrderLines')
)
BEGIN
    ALTER TABLE dbo.PurchaseOrderLines
        ADD CONSTRAINT FK_POL_Product FOREIGN KEY (ProductID)
        REFERENCES dbo.Products(ProductID);
END
GO

/* ---- Optional index to aid queries by ItemSource ---- */
IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = 'IX_PurchaseOrderLines_ItemSource'
      AND object_id = OBJECT_ID('dbo.PurchaseOrderLines')
)
BEGIN
    CREATE INDEX IX_PurchaseOrderLines_ItemSource
        ON dbo.PurchaseOrderLines(ItemSource, PurchaseOrderID);
END
GO
