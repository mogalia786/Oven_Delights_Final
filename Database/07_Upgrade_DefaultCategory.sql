/*
Upgrade: Ensure default Product Category (UNCAT) exists and set default for RawMaterials.CategoryID.
Also ensures inserts into ProductCategories include CreatedBy.
Idempotent and safe to run multiple times.
*/
SET NOCOUNT ON;

IF OBJECT_ID('dbo.ProductCategories','U') IS NULL OR OBJECT_ID('dbo.RawMaterials','U') IS NULL OR OBJECT_ID('dbo.Users','U') IS NULL
BEGIN
    PRINT 'Required tables missing. Ensure core and stockroom schemas are applied first.';
    RETURN;
END

DECLARE @Creator INT = (SELECT TOP 1 UserID FROM dbo.Users ORDER BY UserID);
IF @Creator IS NULL
BEGIN
    -- Minimal bootstrap user (username/email only) to satisfy NOT NULL CreatedBy FKs
    INSERT INTO dbo.Users (Username, Email, IsActive)
    VALUES (N'admin', N'admin@localhost', 1);
    SET @Creator = SCOPE_IDENTITY();
END

-- Upsert UNCAT category
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = N'UNCAT')
BEGIN
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, Description, IsActive, CreatedDate, CreatedBy)
    VALUES (N'UNCAT', N'Uncategorized', N'Default category for materials without a specified category', 1, SYSUTCDATETIME(), @Creator);
END

DECLARE @UncatId INT = (SELECT CategoryID FROM dbo.ProductCategories WHERE CategoryCode = N'UNCAT');

-- Add default constraint on RawMaterials.CategoryID if not present
IF NOT EXISTS (
    SELECT 1
    FROM sys.default_constraints dc
    JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
    WHERE dc.parent_object_id = OBJECT_ID('dbo.RawMaterials')
      AND c.name = 'CategoryID'
)
BEGIN
    DECLARE @sql nvarchar(max) =
        N'ALTER TABLE dbo.RawMaterials ADD CONSTRAINT DF_RawMaterials_CategoryID DEFAULT (' + CAST(@UncatId AS nvarchar(20)) + N') FOR CategoryID;';
    EXEC sp_executesql @sql;
END

PRINT 'Upgrade completed: UNCAT category ensured and default on RawMaterials.CategoryID set.';
