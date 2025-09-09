/*
Purpose: Repoint Products.CategoryID/SubcategoryID FKs from legacy tables
         dbo.ProductCategories/dbo.ProductSubcategories to new
         dbo.Categories/dbo.Subcategories.

This script:
1) Attempts to map existing Products.CategoryID/SubcategoryID values
   from legacy IDs to new IDs by matching on names.
2) Drops old FK constraints if they point to legacy tables.
3) Re-creates FKs to the new master tables.

Run against database: Oven_Delights_Main
*/

SET NOCOUNT ON;
GO

BEGIN TRY
    BEGIN TRAN;

    -- 0) Preconditions: ensure target tables exist
    IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Products' AND schema_id = SCHEMA_ID('dbo'))
    BEGIN
        RAISERROR('Table dbo.Products not found', 16, 1);
        ROLLBACK TRAN; RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Categories' AND schema_id = SCHEMA_ID('dbo'))
    BEGIN
        RAISERROR('Table dbo.Categories not found', 16, 1);
        ROLLBACK TRAN; RETURN;
    END
    IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Subcategories' AND schema_id = SCHEMA_ID('dbo'))
    BEGIN
        RAISERROR('Table dbo.Subcategories not found', 16, 1);
        ROLLBACK TRAN; RETURN;
    END

    -- 1) Detect current FK targets
    ;WITH fk AS (
        SELECT fk.name AS FKName,
               COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColName,
               rt.name AS RefTable
        FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
        JOIN sys.tables pt ON pt.object_id = fk.parent_object_id
        JOIN sys.tables rt ON rt.object_id = fk.referenced_object_id
        WHERE pt.name = 'Products' AND SCHEMA_NAME(pt.schema_id) = 'dbo'
          AND fk.is_disabled = 0
    )
    SELECT * INTO #_fk_products FROM fk;

    DECLARE @catRef sysname = (SELECT TOP 1 RefTable FROM #_fk_products WHERE ColName = 'CategoryID');
    DECLARE @subRef sysname = (SELECT TOP 1 RefTable FROM #_fk_products WHERE ColName = 'SubcategoryID');

    -- 2) Map existing legacy IDs -> new IDs (by names) only if current refs are legacy tables
    IF @catRef = 'ProductCategories'
    BEGIN
        PRINT 'Mapping Products.CategoryID from legacy ProductCategories to new Categories by name...';
        ;WITH mapCat AS (
            SELECT pc.CategoryID AS LegacyID, c.CategoryID AS NewID
            FROM dbo.ProductCategories pc
            JOIN dbo.Categories c ON c.CategoryName = pc.CategoryName
        )
        UPDATE p
            SET CategoryID = mc.NewID
        FROM dbo.Products p
        JOIN mapCat mc ON p.CategoryID = mc.LegacyID;
    END

    IF @subRef = 'ProductSubcategories'
    BEGIN
        PRINT 'Mapping Products.SubcategoryID from legacy ProductSubcategories to new Subcategories by name...';
        ;WITH mapCat AS (
            SELECT pc.CategoryID AS LegacyCatID, c.CategoryID AS NewCatID
            FROM dbo.ProductCategories pc
            JOIN dbo.Categories c ON c.CategoryName = pc.CategoryName
        ), mapSub AS (
            SELECT ps.SubcategoryID AS LegacySubID, s.SubcategoryID AS NewSubID
            FROM dbo.ProductSubcategories ps
            JOIN dbo.Subcategories s ON s.SubcategoryName = ps.SubcategoryName
            JOIN mapCat mc ON mc.LegacyCatID = ps.CategoryID AND mc.NewCatID = s.CategoryID
        )
        UPDATE p
            SET SubcategoryID = ms.NewSubID
        FROM dbo.Products p
        JOIN mapSub ms ON p.SubcategoryID = ms.LegacySubID;

        -- Any SubcategoryID still pointing to legacy IDs will violate the new FK later; set to NULL
        UPDATE p
            SET SubcategoryID = NULL
        FROM dbo.Products p
        WHERE NOT EXISTS (
            SELECT 1 FROM dbo.Subcategories s WHERE s.SubcategoryID = p.SubcategoryID
        );
    END

    -- 3) Drop legacy FKs if they exist
    DECLARE @dropCat nvarchar(400) = NULL, @dropSub nvarchar(400) = NULL;

    IF EXISTS (
        SELECT 1 FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
        JOIN sys.tables rt ON rt.object_id = fk.referenced_object_id
        WHERE fk.parent_object_id = OBJECT_ID('dbo.Products')
          AND COL_NAME(fkc.parent_object_id, fkc.parent_column_id) = 'CategoryID'
          AND rt.name = 'ProductCategories'
    )
        SET @dropCat = N'ALTER TABLE dbo.Products DROP CONSTRAINT FK_Products_Category;';

    IF EXISTS (
        SELECT 1 FROM sys.foreign_keys fk
        JOIN sys.foreign_key_columns fkc ON fkc.constraint_object_id = fk.object_id
        JOIN sys.tables rt ON rt.object_id = fk.referenced_object_id
        WHERE fk.parent_object_id = OBJECT_ID('dbo.Products')
          AND COL_NAME(fkc.parent_object_id, fkc.parent_column_id) = 'SubcategoryID'
          AND rt.name = 'ProductSubcategories'
    )
        SET @dropSub = N'ALTER TABLE dbo.Products DROP CONSTRAINT FK_Products_Subcategory;';

    IF @dropSub IS NOT NULL EXEC (@dropSub);
    IF @dropCat IS NOT NULL EXEC (@dropCat);

    -- 4) Create new FKs to dbo.Categories / dbo.Subcategories
    IF NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Products_Category'
    )
    BEGIN
        PRINT 'Creating FK_Products_Category -> dbo.Categories(CategoryID)';
        ALTER TABLE dbo.Products WITH CHECK
            ADD CONSTRAINT FK_Products_Category FOREIGN KEY (CategoryID)
            REFERENCES dbo.Categories (CategoryID);
    END

    IF NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Products_Subcategory'
    )
    BEGIN
        PRINT 'Creating FK_Products_Subcategory -> dbo.Subcategories(SubcategoryID)';
        ALTER TABLE dbo.Products WITH CHECK
            ADD CONSTRAINT FK_Products_Subcategory FOREIGN KEY (SubcategoryID)
            REFERENCES dbo.Subcategories (SubcategoryID);
    END

    COMMIT TRAN;
    PRINT 'Products FKs successfully repointed to new Categories/Subcategories.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    DECLARE @msg nvarchar(4000) = ERROR_MESSAGE();
    RAISERROR('36_Migrate_Products_FKs_To_New_Categories failed: %s', 16, 1, @msg);
END CATCH
GO
