/* 39_Add_GRNL_Product_Support.sql
Extends GRNLines to support product-based PO lines without violating FK to RawMaterials.
- Adds nullable ProductID and ItemSource
- Makes MaterialID nullable
- Adds FK to Products(ProductID) when available
- Adds CHECK constraint to enforce exclusivity and match ItemSource
- Adds helpful index
This script is idempotent and guarded.
*/

SET NOCOUNT ON;

IF OBJECT_ID('dbo.GRNLines','U') IS NULL
BEGIN
    RAISERROR('GRNLines table does not exist. Run stockroom base schema first.', 16, 1);
    RETURN;
END;

-- Add ProductID column if missing
IF COL_LENGTH('dbo.GRNLines','ProductID') IS NULL
    ALTER TABLE dbo.GRNLines ADD ProductID INT NULL;

-- Add ItemSource column if missing
IF COL_LENGTH('dbo.GRNLines','ItemSource') IS NULL
    ALTER TABLE dbo.GRNLines ADD ItemSource NVARCHAR(2) NULL; -- RM or PR

-- Make MaterialID nullable if not already
IF EXISTS (
    SELECT 1 FROM sys.columns 
    WHERE object_id = OBJECT_ID('dbo.GRNLines')
      AND name = 'MaterialID' AND is_nullable = 0
)
BEGIN
    ALTER TABLE dbo.GRNLines ALTER COLUMN MaterialID INT NULL;
END

-- Add FK for ProductID when Products table exists and FK not already present
IF OBJECT_ID('dbo.Products','U') IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_GRNL_Product')
BEGIN
    ALTER TABLE dbo.GRNLines ADD CONSTRAINT FK_GRNL_Product FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID);
END

-- Drop legacy or incorrect check constraint if previously created with old name
IF EXISTS (SELECT 1 FROM sys.check_constraints WHERE name = 'CK_GRNL_ItemSource')
BEGIN
    ALTER TABLE dbo.GRNLines DROP CONSTRAINT CK_GRNL_ItemSource;
END

-- Add CHECK constraint to enforce one-and-only-one and ItemSource mapping (use dynamic SQL to avoid parse-time errors)
IF COL_LENGTH('dbo.GRNLines','ItemSource') IS NOT NULL AND COL_LENGTH('dbo.GRNLines','ProductID') IS NOT NULL
BEGIN
    DECLARE @sql nvarchar(max) = N'ALTER TABLE dbo.GRNLines ADD CONSTRAINT CK_GRNL_ItemSource
    CHECK (
        (
            (ItemSource = ''RM'' AND MaterialID IS NOT NULL AND ProductID IS NULL)
            OR (ItemSource = ''PR'' AND ProductID IS NOT NULL AND MaterialID IS NULL)
        )
    );';
    EXEC sp_executesql @sql;
END

-- Backfill ItemSource based on existing data where possible (use dynamic SQL)
IF COL_LENGTH('dbo.GRNLines','ItemSource') IS NOT NULL
BEGIN
    IF COL_LENGTH('dbo.GRNLines','ProductID') IS NOT NULL
    BEGIN
        DECLARE @sql2 nvarchar(max) = N'UPDATE dbo.GRNLines
           SET ItemSource = CASE WHEN ProductID IS NOT NULL THEN ''PR'' ELSE ''RM'' END
         WHERE ItemSource IS NULL;';
        EXEC sp_executesql @sql2;
    END
    ELSE
    BEGIN
        DECLARE @sql2b nvarchar(max) = N'UPDATE dbo.GRNLines SET ItemSource = ''RM'' WHERE ItemSource IS NULL;';
        EXEC sp_executesql @sql2b;
    END
END

-- Helpful index for filtering
IF COL_LENGTH('dbo.GRNLines','ItemSource') IS NOT NULL
   AND NOT EXISTS (
       SELECT 1 FROM sys.indexes WHERE name = 'IX_GRNLines_ItemSource_GRN' AND object_id = OBJECT_ID('dbo.GRNLines')
   )
BEGIN
    DECLARE @sql3 nvarchar(max) = N'CREATE INDEX IX_GRNLines_ItemSource_GRN ON dbo.GRNLines(ItemSource, GRNID);';
    EXEC sp_executesql @sql3;
END

PRINT '39_Add_GRNL_Product_Support applied.';
