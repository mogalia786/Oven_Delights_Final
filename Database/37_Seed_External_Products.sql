/*
37_Seed_External_Products.sql

Purpose: Add sample external (purchasable) products for testing Purchase Orders.
- Ensures Categories/Subcategories exist (Packaging/Boxes, Decorations/Edible, Sprinkles/Colored)
- Inserts external Products with those categories and marks them Active
- Avoids manufactured products by not creating ProductRecipe rows
- Safe to run multiple times (guards by ProductCode existence)
*/

SET NOCOUNT ON;
GO

BEGIN TRY
    BEGIN TRAN;

    /* Ensure Categories exist */
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = N'Packaging')
        INSERT INTO dbo.Categories(CategoryName) VALUES (N'Packaging');
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = N'Decorations')
        INSERT INTO dbo.Categories(CategoryName) VALUES (N'Decorations');
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = N'Sprinkles')
        INSERT INTO dbo.Categories(CategoryName) VALUES (N'Sprinkles');
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = N'Beverages')
        INSERT INTO dbo.Categories(CategoryName) VALUES (N'Beverages');
    IF NOT EXISTS (SELECT 1 FROM dbo.Categories WHERE CategoryName = N'Bread & Resell')
        INSERT INTO dbo.Categories(CategoryName) VALUES (N'Bread & Resell');

    /* Resolve CategoryIDs */
    DECLARE @catPackaging INT = (SELECT CategoryID FROM dbo.Categories WHERE CategoryName = N'Packaging');
    DECLARE @catDecor INT     = (SELECT CategoryID FROM dbo.Categories WHERE CategoryName = N'Decorations');
    DECLARE @catSprinkles INT = (SELECT CategoryID FROM dbo.Categories WHERE CategoryName = N'Sprinkles');
    DECLARE @catBeverages INT = (SELECT CategoryID FROM dbo.Categories WHERE CategoryName = N'Beverages');
    DECLARE @catBread INT     = (SELECT CategoryID FROM dbo.Categories WHERE CategoryName = N'Bread & Resell');

    /* Ensure Subcategories exist */
    IF NOT EXISTS (SELECT 1 FROM dbo.Subcategories WHERE SubcategoryName = N'Boxes' AND CategoryID = @catPackaging)
        INSERT INTO dbo.Subcategories(CategoryID, SubcategoryName) VALUES (@catPackaging, N'Boxes');
    IF NOT EXISTS (SELECT 1 FROM dbo.Subcategories WHERE SubcategoryName = N'Edible' AND CategoryID = @catDecor)
        INSERT INTO dbo.Subcategories(CategoryID, SubcategoryName) VALUES (@catDecor, N'Edible');
    IF NOT EXISTS (SELECT 1 FROM dbo.Subcategories WHERE SubcategoryName = N'Colored' AND CategoryID = @catSprinkles)
        INSERT INTO dbo.Subcategories(CategoryID, SubcategoryName) VALUES (@catSprinkles, N'Colored');
    IF NOT EXISTS (SELECT 1 FROM dbo.Subcategories WHERE SubcategoryName = N'Soft Drinks' AND CategoryID = @catBeverages)
        INSERT INTO dbo.Subcategories(CategoryID, SubcategoryName) VALUES (@catBeverages, N'Soft Drinks');
    IF NOT EXISTS (SELECT 1 FROM dbo.Subcategories WHERE SubcategoryName = N'Loaves' AND CategoryID = @catBread)
        INSERT INTO dbo.Subcategories(CategoryID, SubcategoryName) VALUES (@catBread, N'Loaves');

    /* Resolve SubcategoryIDs */
    DECLARE @subBoxes INT    = (SELECT SubcategoryID FROM dbo.Subcategories WHERE CategoryID = @catPackaging AND SubcategoryName = N'Boxes');
    DECLARE @subEdible INT   = (SELECT SubcategoryID FROM dbo.Subcategories WHERE CategoryID = @catDecor AND SubcategoryName = N'Edible');
    DECLARE @subColored INT  = (SELECT SubcategoryID FROM dbo.Subcategories WHERE CategoryID = @catSprinkles AND SubcategoryName = N'Colored');
    DECLARE @subSoftDrinks INT = (SELECT SubcategoryID FROM dbo.Subcategories WHERE CategoryID = @catBeverages AND SubcategoryName = N'Soft Drinks');
    DECLARE @subLoaves INT     = (SELECT SubcategoryID FROM dbo.Subcategories WHERE CategoryID = @catBread AND SubcategoryName = N'Loaves');

    /* Insert external Products (no ProductRecipe entries) */
    DECLARE @hasItemType BIT = CASE WHEN COL_LENGTH('dbo.Products','ItemType') IS NULL THEN 0 ELSE 1 END;

    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'PKG-BOX-S')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'PKG-BOX-S', N'Box - Small', @catPackaging, @subBoxes, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'PKG-BOX-S', N'Box - Small', @catPackaging, @subBoxes, 1);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'PKG-BOX-M')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'PKG-BOX-M', N'Box - Medium', @catPackaging, @subBoxes, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'PKG-BOX-M', N'Box - Medium', @catPackaging, @subBoxes, 1);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'PKG-BOX-12')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'PKG-BOX-12', N'Cake Box 12"', @catPackaging, @subBoxes, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'PKG-BOX-12', N'Cake Box 12"', @catPackaging, @subBoxes, 1);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'DEC-GL-ED')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'DEC-GL-ED', N'Gold Leaf (Edible)', @catDecor, @subEdible, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'DEC-GL-ED', N'Gold Leaf (Edible)', @catDecor, @subEdible, 1);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'DEC-SF-ED')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'DEC-SF-ED', N'Sugar Flowers (Edible)', @catDecor, @subEdible, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'DEC-SF-ED', N'Sugar Flowers (Edible)', @catDecor, @subEdible, 1);
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'SPR-RNB-500')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'SPR-RNB-500', N'Rainbow Sprinkles 500g', @catSprinkles, @subColored, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'SPR-RNB-500', N'Rainbow Sprinkles 500g', @catSprinkles, @subColored, 1);
    END

    /* Beverages - e.g., Coke */
    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'BEV-COKE-330')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'BEV-COKE-330', N'Coca-Cola 330ml Can', @catBeverages, @subSoftDrinks, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'BEV-COKE-330', N'Coca-Cola 330ml Can', @catBeverages, @subSoftDrinks, 1);
    END
    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'BEV-COKE-500')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'BEV-COKE-500', N'Coca-Cola 500ml PET', @catBeverages, @subSoftDrinks, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'BEV-COKE-500', N'Coca-Cola 500ml PET', @catBeverages, @subSoftDrinks, 1);
    END

    /* Bread loaves (resell) */
    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'BRD-WHT-LOAF')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'BRD-WHT-LOAF', N'White Bread Loaf 700g', @catBread, @subLoaves, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'BRD-WHT-LOAF', N'White Bread Loaf 700g', @catBread, @subLoaves, 1);
    END
    IF NOT EXISTS (SELECT 1 FROM dbo.Products WHERE ProductCode = N'BRD-WHT-LOAF-SM')
    BEGIN
        IF @hasItemType = 1
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, ItemType, IsActive)
            VALUES (N'BRD-WHT-LOAF-SM', N'White Bread Loaf 400g', @catBread, @subLoaves, N'Finished', 1);
        ELSE
            INSERT INTO dbo.Products (ProductCode, ProductName, CategoryID, SubcategoryID, IsActive)
            VALUES (N'BRD-WHT-LOAF-SM', N'White Bread Loaf 400g', @catBread, @subLoaves, 1);
    END

    COMMIT TRAN;
    PRINT 'External test products seeded successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR('37_Seed_External_Products failed: %s', 16, 1, @msg);
END CATCH
GO
