-- Update Demo_Retail_Product from master list
-- Generated: 2025-12-07 00:33:40

BEGIN TRANSACTION;

-- DRI-AME-250ML - Americano Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-AME-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Americano Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-AME-250ML';
    PRINT 'Updated: DRI-AME-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-AME-250ML', 'Americano Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-AME-250ML';
END
GO

-- DRI-AME-350ML - Americano Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-AME-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Americano Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-AME-350ML';
    PRINT 'Updated: DRI-AME-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-AME-350ML', 'Americano Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-AME-350ML';
END
GO

-- DRI-CAF-EAC - Caramel Freezo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CAF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Caramel Freezo',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-CAF-EAC';
    PRINT 'Updated: DRI-CAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CAF-EAC', 'Caramel Freezo', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-CAF-EAC';
END
GO

-- DRI-CFR=EAC - Coffee Freezo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CFR=EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coffee Freezo',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-CFR=EAC';
    PRINT 'Updated: DRI-CFR=EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CFR=EAC', 'Coffee Freezo', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-CFR=EAC';
END
GO

-- DRI-CHA-350ML - Chai Latte Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CHA-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chai Latte Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-CHA-350ML';
    PRINT 'Updated: DRI-CHA-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CHA-350ML', 'Chai Latte Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-CHA-350ML';
END
GO

-- DRI-CHF-250ML - Chocolate Freezo Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CHF-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Freezo Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-CHF-250ML';
    PRINT 'Updated: DRI-CHF-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CHF-250ML', 'Chocolate Freezo Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-CHF-250ML';
END
GO

-- DRI-CHF-350ML - Chocolate Freezo Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CHF-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Freezo Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-CHF-350ML';
    PRINT 'Updated: DRI-CHF-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CHF-350ML', 'Chocolate Freezo Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-CHF-350ML';
END
GO

-- DRI-CHL-EACH - Chai Latte Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CHL-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chai Latte Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-CHL-EACH';
    PRINT 'Updated: DRI-CHL-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CHL-EACH', 'Chai Latte Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-CHL-EACH';
END
GO

-- DRI-COR-250ML - Cortado Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COR-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cortado Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-COR-250ML';
    PRINT 'Updated: DRI-COR-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COR-250ML', 'Cortado Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-COR-250ML';
END
GO

-- DRI-ESS-250ML - Espresso Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ESS-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Espresso Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ESS-250ML';
    PRINT 'Updated: DRI-ESS-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ESS-250ML', 'Espresso Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ESS-250ML';
END
GO

-- DRI-ESS-350ML - Espresso Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ESS-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Espresso Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ESS-350ML';
    PRINT 'Updated: DRI-ESS-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ESS-350ML', 'Espresso Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ESS-350ML';
END
GO

-- DRI-FLW-250ML - Flat White Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FLW-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Flat White Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-FLW-250ML';
    PRINT 'Updated: DRI-FLW-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FLW-250ML', 'Flat White Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-FLW-250ML';
END
GO

-- DRI-FLW-350ML - Flat White Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FLW-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Flat White Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-FLW-350ML';
    PRINT 'Updated: DRI-FLW-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FLW-350ML', 'Flat White Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-FLW-350ML';
END
GO

-- DRI-FRT-250ML - Five Roses Tea Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FRT-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Five Roses Tea Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-FRT-250ML';
    PRINT 'Updated: DRI-FRT-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FRT-250ML', 'Five Roses Tea Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-FRT-250ML';
END
GO

-- DRI-FRT-350ML - Five Roses Tea Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FRT-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Five Roses Tea Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-FRT-350ML';
    PRINT 'Updated: DRI-FRT-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FRT-350ML', 'Five Roses Tea Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-FRT-350ML';
END
GO

-- DRI-HAF-EAC - Hazelnut Freezo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-HAF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Hazelnut Freezo',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-HAF-EAC';
    PRINT 'Updated: DRI-HAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-HAF-EAC', 'Hazelnut Freezo', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-HAF-EAC';
END
GO

-- DRI-HOC-250ML - Hot Chocolate Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-HOC-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Hot Chocolate Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-HOC-250ML';
    PRINT 'Updated: DRI-HOC-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-HOC-250ML', 'Hot Chocolate Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-HOC-250ML';
END
GO

-- DRI-HOC-350ML - Hot Chocolate Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-HOC-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Hot Chocolate Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-HOC-350ML';
    PRINT 'Updated: DRI-HOC-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-HOC-350ML', 'Hot Chocolate Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-HOC-350ML';
END
GO

-- DRI-HWT-EAC - Tall White Hot Chocolate
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-HWT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tall White Hot Chocolate',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-HWT-EAC';
    PRINT 'Updated: DRI-HWT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-HWT-EAC', 'Tall White Hot Chocolate', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-HWT-EAC';
END
GO

-- DRI-IAM-EAC - Iced Americano
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IAM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Americano',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-IAM-EAC';
    PRINT 'Updated: DRI-IAM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IAM-EAC', 'Iced Americano', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-IAM-EAC';
END
GO

-- DRI-ICC-250ML - Iced Cappuccino Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ICC-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Cappuccino Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ICC-250ML';
    PRINT 'Updated: DRI-ICC-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ICC-250ML', 'Iced Cappuccino Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ICC-250ML';
END
GO

-- DRI-ICC-350ML - Iced Cappuccino Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ICC-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Cappuccino Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ICC-350ML';
    PRINT 'Updated: DRI-ICC-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ICC-350ML', 'Iced Cappuccino Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ICC-350ML';
END
GO

-- DRI-ICF-250ML - Iced Coffee Freezo Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ICF-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Coffee Freezo Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ICF-250ML';
    PRINT 'Updated: DRI-ICF-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ICF-250ML', 'Iced Coffee Freezo Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ICF-250ML';
END
GO

-- DRI-ICF-350ML - Iced Coffee Freezo Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ICF-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Coffee Freezo Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ICF-350ML';
    PRINT 'Updated: DRI-ICF-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ICF-350ML', 'Iced Coffee Freezo Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ICF-350ML';
END
GO

-- DRI-ICF-KGR - Instabean Coffee Freezo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ICF-KGR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Instabean Coffee Freezo',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ICF-KGR';
    PRINT 'Updated: DRI-ICF-KGR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ICF-KGR', 'Instabean Coffee Freezo', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ICF-KGR';
END
GO

-- DRI-ICL-250ML - Iced Chai Latte Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ICL-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Chai Latte Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ICL-250ML';
    PRINT 'Updated: DRI-ICL-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ICL-250ML', 'Iced Chai Latte Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ICL-250ML';
END
GO

-- DRI-ICL-350ML - Iced Chai Latte Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ICL-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Chai Latte Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ICL-350ML';
    PRINT 'Updated: DRI-ICL-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ICL-350ML', 'Iced Chai Latte Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ICL-350ML';
END
GO

-- DRI-ILA-EAC - Iced Latte
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ILA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Latte',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ILA-EAC';
    PRINT 'Updated: DRI-ILA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ILA-EAC', 'Iced Latte', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ILA-EAC';
END
GO

-- DRI-IMO-EAC - Iced Mocha
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IMO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Mocha',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-IMO-EAC';
    PRINT 'Updated: DRI-IMO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IMO-EAC', 'Iced Mocha', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-IMO-EAC';
END
GO

-- DRI-IWM-EAC - Iced White Mocha
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IWM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced White Mocha',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-IWM-EAC';
    PRINT 'Updated: DRI-IWM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IWM-EAC', 'Iced White Mocha', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-IWM-EAC';
END
GO

-- DRI-LAT-350ML - Latte Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-LAT-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Latte Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-LAT-350ML';
    PRINT 'Updated: DRI-LAT-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-LAT-350ML', 'Latte Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-LAT-350ML';
END
GO

-- DRI-LATT-250ML - Latte Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-LATT-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Latte Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-LATT-250ML';
    PRINT 'Updated: DRI-LATT-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-LATT-250ML', 'Latte Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-LATT-250ML';
END
GO

-- DRI-MAC-250ML - Macchiato Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MAC-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Macchiato Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MAC-250ML';
    PRINT 'Updated: DRI-MAC-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MAC-250ML', 'Macchiato Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MAC-250ML';
END
GO

-- DRI-MAC-350ML - Macchiato Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MAC-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Macchiato Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MAC-350ML';
    PRINT 'Updated: DRI-MAC-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MAC-350ML', 'Macchiato Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MAC-350ML';
END
GO

-- DRI-MBO-EAC - OD Bombay Crush
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MBO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Bombay Crush',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MBO-EAC';
    PRINT 'Updated: DRI-MBO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MBO-EAC', 'OD Bombay Crush', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MBO-EAC';
END
GO

-- DRI-MBU-EAC - OD Bubblegum Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MBU-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Bubblegum Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MBU-EAC';
    PRINT 'Updated: DRI-MBU-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MBU-EAC', 'OD Bubblegum Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MBU-EAC';
END
GO

-- DRI-MCH-EAC - OD Chocolate Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MCH-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Chocolate Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MCH-EAC';
    PRINT 'Updated: DRI-MCH-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MCH-EAC', 'OD Chocolate Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MCH-EAC';
END
GO

-- DRI-MCO-EAC - OD Coffee Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MCO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Coffee Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MCO-EAC';
    PRINT 'Updated: DRI-MCO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MCO-EAC', 'OD Coffee Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MCO-EAC';
END
GO

-- DRI-MLI-EAC - OD Lime Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MLI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Lime Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MLI-EAC';
    PRINT 'Updated: DRI-MLI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MLI-EAC', 'OD Lime Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MLI-EAC';
END
GO

-- DRI-MOC-250ML - Mocha Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MOC-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mocha Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MOC-250ML';
    PRINT 'Updated: DRI-MOC-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MOC-250ML', 'Mocha Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MOC-250ML';
END
GO

-- DRI-MOC-350ML - Mocha Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MOC-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mocha Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MOC-350ML';
    PRINT 'Updated: DRI-MOC-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MOC-350ML', 'Mocha Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MOC-350ML';
END
GO

-- DRI-MOF-250ML - Mocha Freezo Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MOF-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mocha Freezo Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MOF-250ML';
    PRINT 'Updated: DRI-MOF-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MOF-250ML', 'Mocha Freezo Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MOF-250ML';
END
GO

-- DRI-MOF-350ML - Mocha Freezo Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MOF-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mocha Freezo Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MOF-350ML';
    PRINT 'Updated: DRI-MOF-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MOF-350ML', 'Mocha Freezo Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MOF-350ML';
END
GO

-- DRI-MSC-EAC - OD Salted Caramel Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MSC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Salted Caramel Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MSC-EAC';
    PRINT 'Updated: DRI-MSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MSC-EAC', 'OD Salted Caramel Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MSC-EAC';
END
GO

-- DRI-MSC-KGR - Malora Spicey Chai Latte
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MSC-KGR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Malora Spicey Chai Latte',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MSC-KGR';
    PRINT 'Updated: DRI-MSC-KGR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MSC-KGR', 'Malora Spicey Chai Latte', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MSC-KGR';
END
GO

-- DRI-MST-EAC - OD Strawberry Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MST-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Strawberry Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MST-EAC';
    PRINT 'Updated: DRI-MST-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MST-EAC', 'OD Strawberry Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MST-EAC';
END
GO

-- DRI-MVA-EAC - OD Vanilla Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MVA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Vanilla Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-MVA-EAC';
    PRINT 'Updated: DRI-MVA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MVA-EAC', 'OD Vanilla Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-MVA-EAC';
END
GO

-- DRI-OBS-EAC - OD Berry Smoothie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-OBS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Berry Smoothie',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-OBS-EAC';
    PRINT 'Updated: DRI-OBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-OBS-EAC', 'OD Berry Smoothie', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-OBS-EAC';
END
GO

-- DRI-OMS-EAC - OD Mango Smoothie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-OMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Mango Smoothie',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-OMS-EAC';
    PRINT 'Updated: DRI-OMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-OMS-EAC', 'OD Mango Smoothie', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-OMS-EAC';
END
GO

-- DRI-OOM-EAC - OD Oreo Milkshake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-OOM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Oreo Milkshake',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-OOM-EAC';
    PRINT 'Updated: DRI-OOM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-OOM-EAC', 'OD Oreo Milkshake', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-OOM-EAC';
END
GO

-- DRI-OSP-EAC - OD Peanut Butter Smoothie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-OSP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Peanut Butter Smoothie',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-OSP-EAC';
    PRINT 'Updated: DRI-OSP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-OSP-EAC', 'OD Peanut Butter Smoothie', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-OSP-EAC';
END
GO

-- DRI-ROB-250ML - Rooibos Tea Short
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-ROB-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rooibos Tea Short',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-ROB-250ML';
    PRINT 'Updated: DRI-ROB-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-ROB-250ML', 'Rooibos Tea Short', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-ROB-250ML';
END
GO

-- DRI-SWM-250ML - Short White Mocha
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SWM-250ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Short White Mocha',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-SWM-250ML';
    PRINT 'Updated: DRI-SWM-250ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SWM-250ML', 'Short White Mocha', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-SWM-250ML';
END
GO

-- DRI-TWM-350ML - Tall White Mocha
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWM-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tall White Mocha',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-TWM-350ML';
    PRINT 'Updated: DRI-TWM-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWM-350ML', 'Tall White Mocha', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-TWM-350ML';
END
GO

-- DRI-VAF-EAC - Vanilla Freezo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-VAF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Vanilla Freezo',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-VAF-EAC';
    PRINT 'Updated: DRI-VAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-VAF-EAC', 'Vanilla Freezo', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-VAF-EAC';
END
GO

-- DRI-WCF-EAC - White Chocolate Freezo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-WCF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'White Chocolate Freezo',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-WCF-EAC';
    PRINT 'Updated: DRI-WCF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-WCF-EAC', 'White Chocolate Freezo', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-WCF-EAC';
END
GO

-- DRI-WHS-EAC - Short White Hot Chocolate
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-WHS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Short White Hot Chocolate',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'DRI-WHS-EAC';
    PRINT 'Updated: DRI-WHS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-WHS-EAC', 'Short White Hot Chocolate', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: DRI-WHS-EAC';
END
GO

-- SHP-FRT-LRG - Five Roses Tea Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-FRT-LRG')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Five Roses Tea Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-FRT-LRG';
    PRINT 'Updated: SHP-FRT-LRG';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-FRT-LRG', 'Five Roses Tea Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-FRT-LRG';
END
GO

-- SHP-FRT-SML - Five Roses Tea Small
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-FRT-SML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Five Roses Tea Small',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-FRT-SML';
    PRINT 'Updated: SHP-FRT-SML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-FRT-SML', 'Five Roses Tea Small', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-FRT-SML';
END
GO

-- SHP-ICL-LRG - Iced Coffee Large
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-ICL-LRG')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iced Coffee Large',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-ICL-LRG';
    PRINT 'Updated: SHP-ICL-LRG';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-ICL-LRG', 'Iced Coffee Large', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-ICL-LRG';
END
GO

-- SHP-RBS-SML - Rooibos Tea Small
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RBS-SML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rooibos Tea Small',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-RBS-SML';
    PRINT 'Updated: SHP-RBS-SML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RBS-SML', 'Rooibos Tea Small', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-RBS-SML';
END
GO

-- SHP-RBT-LRG - Rooibos Tea Tall
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RBT-LRG')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rooibos Tea Tall',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-RBT-LRG';
    PRINT 'Updated: SHP-RBT-LRG';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RBT-LRG', 'Rooibos Tea Tall', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-RBT-LRG';
END
GO

-- XTO- GRT-EAC - Green Tea
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Beverages';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'XTO- GRT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Green Tea',
        Category = 'Beverages',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'XTO- GRT-EAC';
    PRINT 'Updated: XTO- GRT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('XTO- GRT-EAC', 'Green Tea', 'Beverages', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: XTO- GRT-EAC';
END
GO

-- BIS- CHC-EAC - Biscuit Choc Chip
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS- CHC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Choc Chip',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS- CHC-EAC';
    PRINT 'Updated: BIS- CHC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS- CHC-EAC', 'Biscuit Choc Chip', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS- CHC-EAC';
END
GO

-- BIS-ABB-EAC - Biscuit Assorted Pure Butter
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-ABB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Assorted Pure Butter',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-ABB-EAC';
    PRINT 'Updated: BIS-ABB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-ABB-EAC', 'Biscuit Assorted Pure Butter', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-ABB-EAC';
END
GO

-- BIS-BCV-EAC - Biscuit Choc Vanilla 300g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-BCV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Choc Vanilla 300g',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-BCV-EAC';
    PRINT 'Updated: BIS-BCV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-BCV-EAC', 'Biscuit Choc Vanilla 300g', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-BCV-EAC';
END
GO

-- BIS-BUB-EAC - Biscuit Butter Biscuit
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-BUB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Butter Biscuit',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-BUB-EAC';
    PRINT 'Updated: BIS-BUB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-BUB-EAC', 'Biscuit Butter Biscuit', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-BUB-EAC';
END
GO

-- BIS-CCC-EAC - Biscuit Choc Chip Cookie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-CCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Choc Chip Cookie',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-CCC-EAC';
    PRINT 'Updated: BIS-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-CCC-EAC', 'Biscuit Choc Chip Cookie', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-CCC-EAC';
END
GO

-- BIS-CHD-EAC - Biscuit Choc Delights 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-CHD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Choc Delights 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-CHD-EAC';
    PRINT 'Updated: BIS-CHD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-CHD-EAC', 'Biscuit Choc Delights 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-CHD-EAC';
END
GO

-- BIS-CJN-EAC - Biscuit Jam Nest 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-CJN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Jam Nest 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-CJN-EAC';
    PRINT 'Updated: BIS-CJN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-CJN-EAC', 'Biscuit Jam Nest 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-CJN-EAC';
END
GO

-- BIS-COC-EAC - Biscuit Coconut
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-COC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Coconut',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-COC-EAC';
    PRINT 'Updated: BIS-COC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-COC-EAC', 'Biscuit Coconut', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-COC-EAC';
END
GO

-- BIS-CRU-EACH - GLUTEN FREE RUSKS
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-CRU-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'GLUTEN FREE RUSKS',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-CRU-EACH';
    PRINT 'Updated: BIS-CRU-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-CRU-EACH', 'GLUTEN FREE RUSKS', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-CRU-EACH';
END
GO

-- BIS-CUS-EAC - Biscuit Custard
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-CUS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Custard',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-CUS-EAC';
    PRINT 'Updated: BIS-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-CUS-EAC', 'Biscuit Custard', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-CUS-EAC';
END
GO

-- BIS-DAT-EAC - Biscuit Date Roll 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-DAT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Date Roll 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-DAT-EAC';
    PRINT 'Updated: BIS-DAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-DAT-EAC', 'Biscuit Date Roll 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-DAT-EAC';
END
GO

-- BIS-DEB-EAC - Designer Biscuits 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-DEB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Designer Biscuits 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-DEB-EAC';
    PRINT 'Updated: BIS-DEB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-DEB-EAC', 'Designer Biscuits 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-DEB-EAC';
END
GO

-- BIS-FEB-EAC - Biscuit Fego 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-FEB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Fego 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-FEB-EAC';
    PRINT 'Updated: BIS-FEB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-FEB-EAC', 'Biscuit Fego 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-FEB-EAC';
END
GO

-- BIS-FLF-EAC - Biscuit choc Fingers 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-FLF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit choc Fingers 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-FLF-EAC';
    PRINT 'Updated: BIS-FLF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-FLF-EAC', 'Biscuit choc Fingers 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-FLF-EAC';
END
GO

-- BIS-HSB-EAC - Biscuit Horse Shoe 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-HSB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Horse Shoe 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-HSB-EAC';
    PRINT 'Updated: BIS-HSB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-HSB-EAC', 'Biscuit Horse Shoe 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-HSB-EAC';
END
GO

-- BIS-NAK-EAC - Biscuit Naan Katai 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-NAK-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Naan Katai 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-NAK-EAC';
    PRINT 'Updated: BIS-NAK-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-NAK-EAC', 'Biscuit Naan Katai 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-NAK-EAC';
END
GO

-- BIS-PAO-EAC - Biscuit Pcn & almnd 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-PAO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Pcn & almnd 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-PAO-EAC';
    PRINT 'Updated: BIS-PAO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-PAO-EAC', 'Biscuit Pcn & almnd 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-PAO-EAC';
END
GO

-- BIS-PNS-EAC - Biscuit Pecan Nut Squares 300G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-PNS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Pecan Nut Squares 300G',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-PNS-EAC';
    PRINT 'Updated: BIS-PNS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-PNS-EAC', 'Biscuit Pecan Nut Squares 300G', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-PNS-EAC';
END
GO

-- BIS-RMC-EAC - Biscuit Romany Creams
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-RMC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Romany Creams',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-RMC-EAC';
    PRINT 'Updated: BIS-RMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-RMC-EAC', 'Biscuit Romany Creams', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-RMC-EAC';
END
GO

-- BIS-ROC-EAC - Biscuit Romany Creams
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-ROC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Romany Creams',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-ROC-EAC';
    PRINT 'Updated: BIS-ROC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-ROC-EAC', 'Biscuit Romany Creams', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-ROC-EAC';
END
GO

-- BIS-SBB-EAC - Biscuit Short Bread
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'BIS-SBB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Short Bread',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'BIS-SBB-EAC';
    PRINT 'Updated: BIS-SBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('BIS-SBB-EAC', 'Biscuit Short Bread', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: BIS-SBB-EAC';
END
GO

-- XTO-BOO-EAC - Biscuit Original Oreo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'biscuits';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'biscuits' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'XTO-BOO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Biscuit Original Oreo',
        Category = 'biscuits',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'XTO-BOO-EAC';
    PRINT 'Updated: XTO-BOO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('XTO-BOO-EAC', 'Biscuit Original Oreo', 'biscuits', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: XTO-BOO-EAC';
END
GO

-- CBC-BBG-EAC - BC Birthday Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BBG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Birthday Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BBG-EAC';
    PRINT 'Updated: CBC-BBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BBG-EAC', 'BC Birthday Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BBG-EAC';
END
GO

-- CBC-BCC-EAC - Icing Cup Cakes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Icing Cup Cakes',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BCC-EAC';
    PRINT 'Updated: CBC-BCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BCC-EAC', 'Icing Cup Cakes', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BCC-EAC';
END
GO

-- CBC-BCD-EAC - BC Chocolate Delight
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BCD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Chocolate Delight',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BCD-EAC';
    PRINT 'Updated: CBC-BCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BCD-EAC', 'BC Chocolate Delight', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BCD-EAC';
END
GO

-- CBC-BCE-EAC - BC Eggless Vanilla Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BCE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Eggless Vanilla Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BCE-EAC';
    PRINT 'Updated: CBC-BCE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BCE-EAC', 'BC Eggless Vanilla Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BCE-EAC';
END
GO

-- CBC-BCG-EAC - BC Chocolate Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BCG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Chocolate Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BCG-EAC';
    PRINT 'Updated: CBC-BCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BCG-EAC', 'BC Chocolate Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BCG-EAC';
END
GO

-- CBC-BCN-EAC - Icing Cup Cakes With Name
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BCN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Icing Cup Cakes With Name',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BCN-EAC';
    PRINT 'Updated: CBC-BCN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BCN-EAC', 'Icing Cup Cakes With Name', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BCN-EAC';
END
GO

-- CBC-BCS-EAC - BC Chocolate Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BCS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Chocolate Slice',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BCS-EAC';
    PRINT 'Updated: CBC-BCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BCS-EAC', 'BC Chocolate Slice', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BCS-EAC';
END
GO

-- CBC-BDN-EAC - BC Doughnut
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BDN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Doughnut',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BDN-EAC';
    PRINT 'Updated: CBC-BDN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BDN-EAC', 'BC Doughnut', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BDN-EAC';
END
GO

-- CBC-BEG-EAC - BC Eggless Birthday Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Eggless Birthday Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BEG-EAC';
    PRINT 'Updated: CBC-BEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BEG-EAC', 'BC Eggless Birthday Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BEG-EAC';
END
GO

-- CBC-BET-EAC - BC Triple Layer Eggless Drip Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BET-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Triple Layer Eggless Drip Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BET-EAC';
    PRINT 'Updated: CBC-BET-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BET-EAC', 'BC Triple Layer Eggless Drip Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BET-EAC';
END
GO

-- CBC-BRG-EAC - BC Smash Choc Rose Pattern Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BRG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Smash Choc Rose Pattern Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BRG-EAC';
    PRINT 'Updated: CBC-BRG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BRG-EAC', 'BC Smash Choc Rose Pattern Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BRG-EAC';
END
GO

-- CBC-BTD-EAC - BC Triple Layer Drip Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-BTD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Triple Layer Drip Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-BTD-EAC';
    PRINT 'Updated: CBC-BTD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-BTD-EAC', 'BC Triple Layer Drip Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-BTD-EAC';
END
GO

-- CBC-CBG-EAC - Christmas Buttercream Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CBG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Buttercream Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CBG-EAC';
    PRINT 'Updated: CBC-CBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CBG-EAC', 'Christmas Buttercream Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CBG-EAC';
END
GO

-- CBC-CDB-EAC - BC Choc Drip Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CDB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Choc Drip Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CDB-EAC';
    PRINT 'Updated: CBC-CDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CDB-EAC', 'BC Choc Drip Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CDB-EAC';
END
GO

-- CBC-CDN-EAC - Chocolate Doughnut
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CDN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Doughnut',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CDN-EAC';
    PRINT 'Updated: CBC-CDN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CDN-EAC', 'Chocolate Doughnut', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CDN-EAC';
END
GO

-- CBC-CNL-EAC - Coconut Tartlet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CNL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut Tartlet',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CNL-EAC';
    PRINT 'Updated: CBC-CNL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CNL-EAC', 'Coconut Tartlet', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CNL-EAC';
END
GO

-- CBC-CNR-EAC - Coconut Ring
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CNR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut Ring',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CNR-EAC';
    PRINT 'Updated: CBC-CNR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CNR-EAC', 'Coconut Ring', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CNR-EAC';
END
GO

-- CBC-CNS-EAC - Coconut Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CNS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut Slice',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CNS-EAC';
    PRINT 'Updated: CBC-CNS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CNS-EAC', 'Coconut Slice', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CNS-EAC';
END
GO

-- CBC-CNT-EAC - Coconut Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CNT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut Tart',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CNT-EAC';
    PRINT 'Updated: CBC-CNT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CNT-EAC', 'Coconut Tart', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CNT-EAC';
END
GO

-- CBC-CUS-EAC - Currant Square
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CUS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Currant Square',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CUS-EAC';
    PRINT 'Updated: CBC-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CUS-EAC', 'Currant Square', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CUS-EAC';
END
GO

-- CBC-FLA-EAC - Flakey Bits
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-FLA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Flakey Bits',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-FLA-EAC';
    PRINT 'Updated: CBC-FLA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-FLA-EAC', 'Flakey Bits', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-FLA-EAC';
END
GO

-- CBC-JAP-EAC - Jam Puff
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-JAP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Jam Puff',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-JAP-EAC';
    PRINT 'Updated: CBC-JAP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-JAP-EAC', 'Jam Puff', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-JAP-EAC';
END
GO

-- CBC-JAT-EAC - Jam Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-JAT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Jam Tart',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-JAT-EAC';
    PRINT 'Updated: CBC-JAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-JAT-EAC', 'Jam Tart', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-JAT-EAC';
END
GO

-- CBC-JDN-EAC - Jam Doughnut
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-JDN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Jam Doughnut',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-JDN-EAC';
    PRINT 'Updated: CBC-JDN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-JDN-EAC', 'Jam Doughnut', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-JDN-EAC';
END
GO

-- CBC-JTO-EAC - Jam Turnover
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-JTO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Jam Turnover',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-JTO-EAC';
    PRINT 'Updated: CBC-JTO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-JTO-EAC', 'Jam Turnover', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-JTO-EAC';
END
GO

-- CBC-KOE-EAC - Koeksuster 1s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-KOE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Koeksuster 1s',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-KOE-EAC';
    PRINT 'Updated: CBC-KOE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-KOE-EAC', 'Koeksuster 1s', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-KOE-EAC';
END
GO

-- CBC-LPC-EAC - Choc Lamington Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-LPC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Choc Lamington Plain',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-LPC-EAC';
    PRINT 'Updated: CBC-LPC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-LPC-EAC', 'Choc Lamington Plain', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-LPC-EAC';
END
GO

-- CBC-LPR-EAC - Raspberry Lamington Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-LPR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Raspberry Lamington Plain',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-LPR-EAC';
    PRINT 'Updated: CBC-LPR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-LPR-EAC', 'Raspberry Lamington Plain', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-LPR-EAC';
END
GO

-- CBC-MBD-EAC - Mini Buttercream D/N
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MBD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Buttercream D/N',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MBD-EAC';
    PRINT 'Updated: CBC-MBD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MBD-EAC', 'Mini Buttercream D/N', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MBD-EAC';
END
GO

-- CBC-MBG-EAC - Mothers Day Buttercream Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MBG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mothers Day Buttercream Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MBG-EAC';
    PRINT 'Updated: CBC-MBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MBG-EAC', 'Mothers Day Buttercream Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MBG-EAC';
END
GO

-- CBC-MCD-EAC - Mini Chocolate D/N
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MCD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Chocolate D/N',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MCD-EAC';
    PRINT 'Updated: CBC-MCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MCD-EAC', 'Mini Chocolate D/N', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MCD-EAC';
END
GO

-- CBC-MEL-40G - Melting Moments 40g (Round)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MEL-40G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Melting Moments 40g (Round)',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CBC-MEL-40G';
    PRINT 'Updated: CBC-MEL-40G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MEL-40G', 'Melting Moments 40g (Round)', 'Buttercream', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CBC-MEL-40G';
END
GO

-- CBC-MEL-60G - Melting Moments 60g (Long)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MEL-60G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Melting Moments 60g (Long)',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MEL-60G';
    PRINT 'Updated: CBC-MEL-60G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MEL-60G', 'Melting Moments 60g (Long)', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MEL-60G';
END
GO

-- CBC-MFL-EAC - Mini F/BITS
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MFL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini F/BITS',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MFL-EAC';
    PRINT 'Updated: CBC-MFL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MFL-EAC', 'Mini F/BITS', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MFL-EAC';
END
GO

-- CBC-MRL-EAC - Mini Lamington Raspberry Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MRL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Lamington Raspberry Plain',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MRL-EAC';
    PRINT 'Updated: CBC-MRL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MRL-EAC', 'Mini Lamington Raspberry Plain', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MRL-EAC';
END
GO

-- CBC-MSB-EACH - Mini S/B
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MSB-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini S/B',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MSB-EACH';
    PRINT 'Updated: CBC-MSB-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MSB-EACH', 'Mini S/B', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MSB-EACH';
END
GO

-- CBC-MUE-EAC - Muesli Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MUE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Muesli Slice',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MUE-EAC';
    PRINT 'Updated: CBC-MUE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MUE-EAC', 'Muesli Slice', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MUE-EAC';
END
GO

-- CBC-PCC-EAC - BD Picture Cup Cakes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-PCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Picture Cup Cakes',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-PCC-EAC';
    PRINT 'Updated: CBC-PCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-PCC-EAC', 'BD Picture Cup Cakes', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-PCC-EAC';
END
GO

-- CBC-QUC-EAC - Queen Cakes 1s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-QUC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Queen Cakes 1s',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-QUC-EAC';
    PRINT 'Updated: CBC-QUC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-QUC-EAC', 'Queen Cakes 1s', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-QUC-EAC';
END
GO

-- CBC-SNO-EAC - Snowballs 1s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-SNO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Snowballs 1s',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-SNO-EAC';
    PRINT 'Updated: CBC-SNO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-SNO-EAC', 'Snowballs 1s', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-SNO-EAC';
END
GO

-- CBS-SBE-EACH - Eggless Small Buttercream Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-SBE-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Eggless Small Buttercream Gateaux',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-SBE-EACH';
    PRINT 'Updated: CBS-SBE-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-SBE-EACH', 'Eggless Small Buttercream Gateaux', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-SBE-EACH';
END
GO

-- CFC-FDI-EAC - Cake Buttercream In Dome Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FDI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cake Buttercream In Dome Eggless',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FDI-EAC';
    PRINT 'Updated: CFC-FDI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FDI-EAC', 'Cake Buttercream In Dome Eggless', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FDI-EAC';
END
GO

-- CFC-FLM-EAC - Choc Mini Lamington
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FLM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Choc Mini Lamington',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FLM-EAC';
    PRINT 'Updated: CFC-FLM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FLM-EAC', 'Choc Mini Lamington', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FLM-EAC';
END
GO

-- CFC-FRM-EAC - Mini Jam TurnOvers
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Jam TurnOvers',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRM-EAC';
    PRINT 'Updated: CFC-FRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRM-EAC', 'Mini Jam TurnOvers', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRM-EAC';
END
GO

-- CFC-MFL-EAC - Mini CreamPuffs
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MFL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini CreamPuffs',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MFL-EAC';
    PRINT 'Updated: CFC-MFL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MFL-EAC', 'Mini CreamPuffs', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MFL-EAC';
END
GO

-- SHP-BVS-EAC - BC Vanilla Swiss Roll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BVS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC Vanilla Swiss Roll',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BVS-EAC';
    PRINT 'Updated: SHP-BVS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BVS-EAC', 'BC Vanilla Swiss Roll', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BVS-EAC';
END
GO

-- CBC-CRP-EAC - Cream Puff
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-CRP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cream Puff',
        Category = 'Buttercream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-CRP-EAC';
    PRINT 'Updated: CBC-CRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-CRP-EAC', 'Cream Puff', 'Buttercream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-CRP-EAC';
END
GO

-- CBC-EB1-1M - BD 1MX500 BC Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream 1mx500' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-EB1-1M')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 1MX500 BC Eggless',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-EB1-1M';
    PRINT 'Updated: CBC-EB1-1M';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-EB1-1M', 'BD 1MX500 BC Eggless', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-EB1-1M';
END
GO

-- CBF-BCF-018 - BD Buttercream Figure 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Figure 18',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BCF-018';
    PRINT 'Updated: CBF-BCF-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BCF-018', 'BD Buttercream Figure 18', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BCF-018';
END
GO

-- CBF-BCF-018 - BD Buttercream Figure 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Figure 18',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BCF-018';
    PRINT 'Updated: CBF-BCF-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BCF-018', 'BD Buttercream Figure 18', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BCF-018';
END
GO

-- CBF-BCF-020 - BD Buttercream Figure 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Figure 20',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BCF-020';
    PRINT 'Updated: CBF-BCF-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BCF-020', 'BD Buttercream Figure 20', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BCF-020';
END
GO

-- CBF-BCF-020 - BD Buttercream Figure 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BCF-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Figure 20',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BCF-020';
    PRINT 'Updated: CBF-BCF-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BCF-020', 'BD Buttercream Figure 20', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BCF-020';
END
GO

-- CBF-BFE-020 - BD 20 Buttercream Figure on Base Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BFE-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 20 Buttercream Figure on Base Eggless',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BFE-020';
    PRINT 'Updated: CBF-BFE-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BFE-020', 'BD 20 Buttercream Figure on Base Eggless', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BFE-020';
END
GO

-- CBF-BFS-018 - BD Buttercream Fig on SL 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BFS-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Fig on SL 18',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BFS-018';
    PRINT 'Updated: CBF-BFS-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BFS-018', 'BD Buttercream Fig on SL 18', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BFS-018';
END
GO

-- CBF-BFS-018 - BD Buttercream Fig on SL 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BFS-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Fig on SL 18',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BFS-018';
    PRINT 'Updated: CBF-BFS-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BFS-018', 'BD Buttercream Fig on SL 18', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BFS-018';
END
GO

-- CBF-BFS-020 - BD Buttercream Fig on SL 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BFS-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Fig on SL 20',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BFS-020';
    PRINT 'Updated: CBF-BFS-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BFS-020', 'BD Buttercream Fig on SL 20', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BFS-020';
END
GO

-- CBF-FOE-020 - BD 20 Buttercream Figure Only Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FOE-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 20 Buttercream Figure Only Eggless',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FOE-020';
    PRINT 'Updated: CBF-FOE-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FOE-020', 'BD 20 Buttercream Figure Only Eggless', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FOE-020';
END
GO

-- CBR-BCR-012 - BD Buttercream 12 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 12 Round',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-BCR-012';
    PRINT 'Updated: CBR-BCR-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-BCR-012', 'BD Buttercream 12 Round', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-BCR-012';
END
GO

-- CBR-BCR-014 - BD Buttercream 14 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 14 Round',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-BCR-014';
    PRINT 'Updated: CBR-BCR-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-BCR-014', 'BD Buttercream 14 Round', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-BCR-014';
END
GO

-- CBR-BCR-016 - BD Buttercream 16 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 Round',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-BCR-016';
    PRINT 'Updated: CBR-BCR-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-BCR-016', 'BD Buttercream 16 Round', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-BCR-016';
END
GO

-- CBR-BCR-018 - BD Buttercream 18 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream cake round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 18 Round',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-BCR-018';
    PRINT 'Updated: CBR-BCR-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-BCR-018', 'BD Buttercream 18 Round', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-BCR-018';
END
GO

-- CBR-BCR-020 - BD Buttercream 20 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-BCR-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 20 Round',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-BCR-020';
    PRINT 'Updated: CBR-BCR-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-BCR-020', 'BD Buttercream 20 Round', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-BCR-020';
END
GO

-- CBS-BCD-012 - BD Buttercream 12 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 12 DL',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BCD-012';
    PRINT 'Updated: CBS-BCD-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BCD-012', 'BD Buttercream 12 DL', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BCD-012';
END
GO

-- CBS-BCD-014 - BD Buttercream 14 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 14 DL',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BCD-014';
    PRINT 'Updated: CBS-BCD-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BCD-014', 'BD Buttercream 14 DL', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BCD-014';
END
GO

-- CBS-BCD-016 - BD Buttercream 16 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 DL',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BCD-016';
    PRINT 'Updated: CBS-BCD-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BCD-016', 'BD Buttercream 16 DL', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BCD-016';
END
GO

-- CBS-BCD-018 - BD Buttercream 18 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 18 DL',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BCD-018';
    PRINT 'Updated: CBS-BCD-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BCD-018', 'BD Buttercream 18 DL', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BCD-018';
END
GO

-- CBS-BCD-020 - BD Buttercream 20 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 20 DL',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BCD-020';
    PRINT 'Updated: CBS-BCD-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BCD-020', 'BD Buttercream 20 DL', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BCD-020';
END
GO

-- CBS-BCD-022 - BD Buttercream 22 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BCD-022')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 22 DL',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BCD-022';
    PRINT 'Updated: CBS-BCD-022';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BCD-022', 'BD Buttercream 22 DL', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BCD-022';
END
GO

-- CBS-BCE-016 - BD 16 BC DL Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BCE-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16 BC DL Eggless',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BCE-016';
    PRINT 'Updated: CBS-BCE-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BCE-016', 'BD 16 BC DL Eggless', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BCE-016';
END
GO

-- CNO-BC1-1X5 - BD Buttercream 1mx500
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream 1mx500' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BC1-1X5')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 1mx500',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BC1-1X5';
    PRINT 'Updated: CNO-BC1-1X5';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BC1-1X5', 'BD Buttercream 1mx500', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BC1-1X5';
END
GO

-- CNO-BC1-1X5 - BD Buttercream 1mx500
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream 1mx500' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BC1-1X5')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 1mx500',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BC1-1X5';
    PRINT 'Updated: CNO-BC1-1X5';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BC1-1X5', 'BD Buttercream 1mx500', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BC1-1X5';
END
GO

-- CNO-BCE-1X5 - BD Buttercream 1mx500 Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream 1mx500' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCE-1X5')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 1mx500 Eggless',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCE-1X5';
    PRINT 'Updated: CNO-BCE-1X5';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCE-1X5', 'BD Buttercream 1mx500 Eggless', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCE-1X5';
END
GO

-- SRN-BCE-020 - BD20 Buttercream Eggless Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BCE-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD20 Buttercream Eggless Cake',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BCE-020';
    PRINT 'Updated: SRN-BCE-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BCE-020', 'BD20 Buttercream Eggless Cake', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BCE-020';
END
GO

-- SRN-BCR-022 - BC 22 Cut out Figure
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BCR-022')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC 22 Cut out Figure',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BCR-022';
    PRINT 'Updated: SRN-BCR-022';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BCR-022', 'BC 22 Cut out Figure', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BCR-022';
END
GO

-- SRN-FIG-020 - Buttercream Eggless Figure on base 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Buttercream Birthday Cake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'buttercream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-FIG-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Buttercream Eggless Figure on base 20',
        Category = 'Buttercream Birthday Cake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-FIG-020';
    PRINT 'Updated: SRN-FIG-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-FIG-020', 'Buttercream Eggless Figure on base 20', 'Buttercream Birthday Cake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-FIG-020';
END
GO

-- CAN-CMS-EAC - Candles 10s- Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-CMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candles 10s- Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-CMS-EAC';
    PRINT 'Updated: CAN-CMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-CMS-EAC', 'Candles 10s- Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-CMS-EAC';
END
GO

-- CAN-DOU-010 - Candle Numeral Double
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-DOU-010')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral Double',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-DOU-010';
    PRINT 'Updated: CAN-DOU-010';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-DOU-010', 'Candle Numeral Double', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-DOU-010';
END
GO

-- CAN-DOU-080 - Candle Numeral Double
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-DOU-080')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral Double',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-DOU-080';
    PRINT 'Updated: CAN-DOU-080';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-DOU-080', 'Candle Numeral Double', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-DOU-080';
END
GO

-- CAN-GOL-000 - Candle Numeral 0 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-000';
    PRINT 'Updated: CAN-GOL-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-000', 'Candle Numeral 0 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-000';
END
GO

-- CAN-GOL-001 - Candle Numeral 1 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-001';
    PRINT 'Updated: CAN-GOL-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-001', 'Candle Numeral 1 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-001';
END
GO

-- CAN-GOL-002 - Candle Numeral 2 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-002';
    PRINT 'Updated: CAN-GOL-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-002', 'Candle Numeral 2 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-002';
END
GO

-- CAN-GOL-003 - Candle Numeral 3 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-003';
    PRINT 'Updated: CAN-GOL-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-003', 'Candle Numeral 3 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-003';
END
GO

-- CAN-GOL-004 - Candle Numeral 4 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-004';
    PRINT 'Updated: CAN-GOL-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-004', 'Candle Numeral 4 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-004';
END
GO

-- CAN-GOL-005 - Candle Numeral 5 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-005';
    PRINT 'Updated: CAN-GOL-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-005', 'Candle Numeral 5 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-005';
END
GO

-- CAN-GOL-006 - Candle Numeral 6 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-006';
    PRINT 'Updated: CAN-GOL-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-006', 'Candle Numeral 6 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-006';
END
GO

-- CAN-GOL-007 - Candle Numeral 7 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-007';
    PRINT 'Updated: CAN-GOL-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-007', 'Candle Numeral 7 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-007';
END
GO

-- CAN-GOL-008 - Candle Numeral 8 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-008')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 8 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-008';
    PRINT 'Updated: CAN-GOL-008';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-008', 'Candle Numeral 8 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-008';
END
GO

-- CAN-GOL-009 - Candle Numeral 9 Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-009';
    PRINT 'Updated: CAN-GOL-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-009', 'Candle Numeral 9 Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-GOL-009';
END
GO

-- CAN-MAG-24S - Candle Magic Assorted
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-MAG-24S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Magic Assorted',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-MAG-24S';
    PRINT 'Updated: CAN-MAG-24S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-MAG-24S', 'Candle Magic Assorted', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-MAG-24S';
END
GO

-- CAN-MCA-EAC - Magic Candles
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-MCA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Magic Candles',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-MCA-EAC';
    PRINT 'Updated: CAN-MCA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-MCA-EAC', 'Magic Candles', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-MCA-EAC';
END
GO

-- CAN-MIX-24S - Candle Mixed - 24x24
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-MIX-24S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Mixed - 24x24',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-MIX-24S';
    PRINT 'Updated: CAN-MIX-24S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-MIX-24S', 'Candle Mixed - 24x24', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-MIX-24S';
END
GO

-- CAN-RAI-000 - Candle Numeral 0 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-000';
    PRINT 'Updated: CAN-RAI-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-000', 'Candle Numeral 0 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-000';
END
GO

-- CAN-RAI-001 - Candle Numeral 1 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-001';
    PRINT 'Updated: CAN-RAI-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-001', 'Candle Numeral 1 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-001';
END
GO

-- CAN-RAI-002 - Candle Numeral 2 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-002';
    PRINT 'Updated: CAN-RAI-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-002', 'Candle Numeral 2 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-002';
END
GO

-- CAN-RAI-003 - Candle Numeral 3 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-003';
    PRINT 'Updated: CAN-RAI-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-003', 'Candle Numeral 3 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-003';
END
GO

-- CAN-RAI-004 - Candle Numeral 4 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-004';
    PRINT 'Updated: CAN-RAI-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-004', 'Candle Numeral 4 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-004';
END
GO

-- CAN-RAI-005 - Candle Numeral 5 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-005';
    PRINT 'Updated: CAN-RAI-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-005', 'Candle Numeral 5 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-005';
END
GO

-- CAN-RAI-006 - Candle Numeral 6 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-006';
    PRINT 'Updated: CAN-RAI-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-006', 'Candle Numeral 6 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-006';
END
GO

-- CAN-RAI-007 - Candle Numeral 7 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-007';
    PRINT 'Updated: CAN-RAI-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-007', 'Candle Numeral 7 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-007';
END
GO

-- CAN-RAI-009 - Candle Numeral 9 Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-009';
    PRINT 'Updated: CAN-RAI-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-009', 'Candle Numeral 9 Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-RAI-009';
END
GO

-- CAN-SIL-000 - Candle Numeral 0 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-000';
    PRINT 'Updated: CAN-SIL-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-000', 'Candle Numeral 0 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-000';
END
GO

-- CAN-SIL-001 - Candle Numeral 1 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-001';
    PRINT 'Updated: CAN-SIL-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-001', 'Candle Numeral 1 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-001';
END
GO

-- CAN-SIL-002 - Candle Numeral 2 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-002';
    PRINT 'Updated: CAN-SIL-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-002', 'Candle Numeral 2 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-002';
END
GO

-- CAN-SIL-003 - Candle Numeral 3 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-003';
    PRINT 'Updated: CAN-SIL-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-003', 'Candle Numeral 3 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-003';
END
GO

-- CAN-SIL-004 - Candle Numeral 4 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-004';
    PRINT 'Updated: CAN-SIL-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-004', 'Candle Numeral 4 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-004';
END
GO

-- CAN-SIL-005 - Candle Numeral 5 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-005';
    PRINT 'Updated: CAN-SIL-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-005', 'Candle Numeral 5 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-005';
END
GO

-- CAN-SIL-006 - Candle Numeral 6 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-006';
    PRINT 'Updated: CAN-SIL-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-006', 'Candle Numeral 6 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-006';
END
GO

-- CAN-SIL-007 - Candle Numeral 7 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-007';
    PRINT 'Updated: CAN-SIL-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-007', 'Candle Numeral 7 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-007';
END
GO

-- CAN-SIL-008 - Candle Numeral 8 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-008')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 8 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-008';
    PRINT 'Updated: CAN-SIL-008';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-008', 'Candle Numeral 8 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-008';
END
GO

-- CAN-SIL-009 - Candle Numeral 9 Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-009';
    PRINT 'Updated: CAN-SIL-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-009', 'Candle Numeral 9 Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-SIL-009';
END
GO

-- CAN-WHI-000 - Candle Numeral 0 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-000';
    PRINT 'Updated: CAN-WHI-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-000', 'Candle Numeral 0 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-000';
END
GO

-- CAN-WHI-001 - Candle Numeral 1 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-001';
    PRINT 'Updated: CAN-WHI-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-001', 'Candle Numeral 1 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-001';
END
GO

-- CAN-WHI-002 - Candle Numeral 2 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-002';
    PRINT 'Updated: CAN-WHI-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-002', 'Candle Numeral 2 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-002';
END
GO

-- CAN-WHI-003 - Candle Numeral 3 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-003';
    PRINT 'Updated: CAN-WHI-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-003', 'Candle Numeral 3 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-003';
END
GO

-- CAN-WHI-004 - Candle Numeral 4 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-004';
    PRINT 'Updated: CAN-WHI-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-004', 'Candle Numeral 4 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-004';
END
GO

-- CAN-WHI-005 - Candle Numeral 5 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-005';
    PRINT 'Updated: CAN-WHI-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-005', 'Candle Numeral 5 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-005';
END
GO

-- CAN-WHI-006 - Candle Numeral 6 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-006';
    PRINT 'Updated: CAN-WHI-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-006', 'Candle Numeral 6 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-006';
END
GO

-- CAN-WHI-007 - Candle Numeral 7 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-007';
    PRINT 'Updated: CAN-WHI-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-007', 'Candle Numeral 7 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-007';
END
GO

-- CAN-WHI-008 - Candle Numeral 8 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-008')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 8 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-008';
    PRINT 'Updated: CAN-WHI-008';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-008', 'Candle Numeral 8 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-008';
END
GO

-- CAN-WHI-009 - Candle Numeral 9 White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-009';
    PRINT 'Updated: CAN-WHI-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-009', 'Candle Numeral 9 White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CAN-WHI-009';
END
GO

-- MIS-CSA-(6S) - Candle Assorted Sparkle (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CSA-(6S)')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Assorted Sparkle (6s)',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-CSA-(6S)';
    PRINT 'Updated: MIS-CSA-(6S)';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CSA-(6S)', 'Candle Assorted Sparkle (6s)', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-CSA-(6S)';
END
GO

-- MIS-CSG-(6s) - Candle Sparkle Gold (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'candle' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CSG-(6s)')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Sparkle Gold (6s)',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-CSG-(6s)';
    PRINT 'Updated: MIS-CSG-(6s)';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CSG-(6s)', 'Candle Sparkle Gold (6s)', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-CSG-(6s)';
END
GO

-- DRI- CZE-440 - Coke Zero 440ml can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI- CZE-440')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coke Zero 440ml can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI- CZE-440';
    PRINT 'Updated: DRI- CZE-440';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI- CZE-440', 'Coke Zero 440ml can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI- CZE-440';
END
GO

-- DRI-APT-275 - Appletiser 275ml NRB
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-APT-275')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Appletiser 275ml NRB',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-APT-275';
    PRINT 'Updated: DRI-APT-275';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-APT-275', 'Appletiser 275ml NRB', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-APT-275';
END
GO

-- DRI-APT-330 - Appletiser 330ml CAN
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-APT-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Appletiser 330ml CAN',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-APT-330';
    PRINT 'Updated: DRI-APT-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-APT-330', 'Appletiser 330ml CAN', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-APT-330';
END
GO

-- DRI-BAA-500 - Bonaqua 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-BAA-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bonaqua 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-BAA-500';
    PRINT 'Updated: DRI-BAA-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-BAA-500', 'Bonaqua 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-BAA-500';
END
GO

-- DRI-BAN-500 - Bonaqua 500ml Naartjie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-BAN-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bonaqua 500ml Naartjie',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-BAN-500';
    PRINT 'Updated: DRI-BAN-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-BAN-500', 'Bonaqua 500ml Naartjie', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-BAN-500';
END
GO

-- DRI-BON-500ML - Water Bonaqua Still 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-BON-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Water Bonaqua Still 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-BON-500ML';
    PRINT 'Updated: DRI-BON-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-BON-500ML', 'Water Bonaqua Still 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-BON-500ML';
END
GO

-- DRI-CBB-1500 - Cappy Breakfast Blend 1.5litre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CBB-1500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cappy Breakfast Blend 1.5litre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-CBB-1500';
    PRINT 'Updated: DRI-CBB-1500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CBB-1500', 'Cappy Breakfast Blend 1.5litre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-CBB-1500';
END
GO

-- DRI-CBB-EAC - Cappy Breakfast Blend 330ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CBB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cappy Breakfast Blend 330ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-CBB-EAC';
    PRINT 'Updated: DRI-CBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CBB-EAC', 'Cappy Breakfast Blend 330ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-CBB-EAC';
END
GO

-- DRI-COC-125 - Coca-Cola 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COC-125';
    PRINT 'Updated: DRI-COC-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COC-125', 'Coca-Cola 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COC-125';
END
GO

-- DRI-COC-1LT - Coca-Cola 1L
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-1LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola 1L',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COC-1LT';
    PRINT 'Updated: DRI-COC-1LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COC-1LT', 'Coca-Cola 1L', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COC-1LT';
END
GO

-- DRI-COC-2LT - Coca-Cola 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COC-2LT';
    PRINT 'Updated: DRI-COC-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COC-2LT', 'Coca-Cola 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COC-2LT';
END
GO

-- DRI-COC-300 - Coca-Cola 300ml Bottle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola 300ml Bottle',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COC-300';
    PRINT 'Updated: DRI-COC-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COC-300', 'Coca-Cola 300ml Bottle', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COC-300';
END
GO

-- DRI-COC-330 - Coca-Cola 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COC-330';
    PRINT 'Updated: DRI-COC-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COC-330', 'Coca-Cola 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COC-330';
END
GO

-- DRI-COC-440 - Coca- Cola 500ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-440')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca- Cola 500ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COC-440';
    PRINT 'Updated: DRI-COC-440';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COC-440', 'Coca- Cola 500ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COC-440';
END
GO

-- DRI-COC-500 - Coca-Cola 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COC-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COC-500';
    PRINT 'Updated: DRI-COC-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COC-500', 'Coca-Cola 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COC-500';
END
GO

-- DRI-COL-1.5LT - Coca-Cola Zero 1.5ltr
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-1.5LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Zero 1.5ltr',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-1.5LT';
    PRINT 'Updated: DRI-COL-1.5LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-1.5LT', 'Coca-Cola Zero 1.5ltr', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-1.5LT';
END
GO

-- DRI-COL-125 - Coca-Cola Light 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Light 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-125';
    PRINT 'Updated: DRI-COL-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-125', 'Coca-Cola Light 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-125';
END
GO

-- DRI-COL-225 - Coke Light 2250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-225')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coke Light 2250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-225';
    PRINT 'Updated: DRI-COL-225';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-225', 'Coke Light 2250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-225';
END
GO

-- DRI-COL-2LT - Coca-Cola Light 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Light 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-2LT';
    PRINT 'Updated: DRI-COL-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-2LT', 'Coca-Cola Light 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-2LT';
END
GO

-- DRI-COL-2LT - Coca-Cola Light 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Light 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-2LT';
    PRINT 'Updated: DRI-COL-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-2LT', 'Coca-Cola Light 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-2LT';
END
GO

-- DRI-COL-300C - Coke 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-300C')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coke 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-300C';
    PRINT 'Updated: DRI-COL-300C';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-300C', 'Coke 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-300C';
END
GO

-- DRI-COL-330 - Coca-Cola Light 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Light 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-330';
    PRINT 'Updated: DRI-COL-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-330', 'Coca-Cola Light 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-330';
END
GO

-- DRI-COL-500 - Coca-Cola Light 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COL-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Light 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COL-500';
    PRINT 'Updated: DRI-COL-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COL-500', 'Coca-Cola Light 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COL-500';
END
GO

-- DRI-COZ-2250 - Coke Zero 2250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COZ-2250')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coke Zero 2250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COZ-2250';
    PRINT 'Updated: DRI-COZ-2250';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COZ-2250', 'Coke Zero 2250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COZ-2250';
END
GO

-- DRI-COZ-2LT - Coca-Cola Zero 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COZ-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Zero 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COZ-2LT';
    PRINT 'Updated: DRI-COZ-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COZ-2LT', 'Coca-Cola Zero 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COZ-2LT';
END
GO

-- DRI-COZ-2LT - Coca-Cola Zero 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COZ-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Zero 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COZ-2LT';
    PRINT 'Updated: DRI-COZ-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COZ-2LT', 'Coca-Cola Zero 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COZ-2LT';
END
GO

-- DRI-COZ-330 - Coca-Cola Zero 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-COZ-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coca-Cola Zero 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-COZ-330';
    PRINT 'Updated: DRI-COZ-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-COZ-330', 'Coca-Cola Zero 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-COZ-330';
END
GO

-- DRI-CPP-EAC - Cappy Passion Peach
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CPP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cappy Passion Peach',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-CPP-EAC';
    PRINT 'Updated: DRI-CPP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CPP-EAC', 'Cappy Passion Peach', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-CPP-EAC';
END
GO

-- DRI-CRE-400ML - Cream Soda 400ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CRE-400ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cream Soda 400ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-CRE-400ML';
    PRINT 'Updated: DRI-CRE-400ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CRE-400ML', 'Cream Soda 400ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-CRE-400ML';
END
GO

-- DRI-CTP-330 - Cappy Trop Punch 330ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-CTP-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cappy Trop Punch 330ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-CTP-330';
    PRINT 'Updated: DRI-CTP-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-CTP-330', 'Cappy Trop Punch 330ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-CTP-330';
END
GO

-- DRI-FAG-1LT - Fanta Grape
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-1LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Grape',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAG-1LT';
    PRINT 'Updated: DRI-FAG-1LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAG-1LT', 'Fanta Grape', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAG-1LT';
END
GO

-- DRI-FAG-2LT - Fanta Grape 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Grape 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAG-2LT';
    PRINT 'Updated: DRI-FAG-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAG-2LT', 'Fanta Grape 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAG-2LT';
END
GO

-- DRI-FAG-300 - Fanta Grape 300ml Bottle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Grape 300ml Bottle',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAG-300';
    PRINT 'Updated: DRI-FAG-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAG-300', 'Fanta Grape 300ml Bottle', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAG-300';
END
GO

-- DRI-FAG-330 - Fanta Grape 300ml CAN
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Grape 300ml CAN',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAG-330';
    PRINT 'Updated: DRI-FAG-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAG-330', 'Fanta Grape 300ml CAN', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAG-330';
END
GO

-- DRI-FAG-500 - Fanta Grape 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAG-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Grape 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAG-500';
    PRINT 'Updated: DRI-FAG-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAG-500', 'Fanta Grape 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAG-500';
END
GO

-- DRI-FAN-300C - Fanta Orange 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAN-300C')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Orange 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAN-300C';
    PRINT 'Updated: DRI-FAN-300C';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAN-300C', 'Fanta Orange 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAN-300C';
END
GO

-- DRI-FAN-440 - Fanta Orange 400ml can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAN-440')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Orange 400ml can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAN-440';
    PRINT 'Updated: DRI-FAN-440';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAN-440', 'Fanta Orange 400ml can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAN-440';
END
GO

-- DRI-FAO-2LT - Fanta Orange 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Orange 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAO-2LT';
    PRINT 'Updated: DRI-FAO-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAO-2LT', 'Fanta Orange 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAO-2LT';
END
GO

-- DRI-FAO-300 - Fanta Orange 300ml Bottle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Orange 300ml Bottle',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAO-300';
    PRINT 'Updated: DRI-FAO-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAO-300', 'Fanta Orange 300ml Bottle', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAO-300';
END
GO

-- DRI-FAO-330 - Fanta Orange 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Orange 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAO-330';
    PRINT 'Updated: DRI-FAO-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAO-330', 'Fanta Orange 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAO-330';
END
GO

-- DRI-FAO-500 - Fanta Orange 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAO-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Orange 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAO-500';
    PRINT 'Updated: DRI-FAO-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAO-500', 'Fanta Orange 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAO-500';
END
GO

-- DRI-FAP-2LT - Fanta Pineapple 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Pineapple 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAP-2LT';
    PRINT 'Updated: DRI-FAP-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAP-2LT', 'Fanta Pineapple 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAP-2LT';
END
GO

-- DRI-FAP-2LT - Fanta Pineapple 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Pineapple 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAP-2LT';
    PRINT 'Updated: DRI-FAP-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAP-2LT', 'Fanta Pineapple 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAP-2LT';
END
GO

-- DRI-FAP-300 - Fanta Pine 300ml Bottle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Pine 300ml Bottle',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAP-300';
    PRINT 'Updated: DRI-FAP-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAP-300', 'Fanta Pine 300ml Bottle', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAP-300';
END
GO

-- DRI-FAP-330 - Fanta Pineapple 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Pineapple 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAP-330';
    PRINT 'Updated: DRI-FAP-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAP-330', 'Fanta Pineapple 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAP-330';
END
GO

-- DRI-FAP-500 - Fanta Pineapple 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAP-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Pineapple 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAP-500';
    PRINT 'Updated: DRI-FAP-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAP-500', 'Fanta Pineapple 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAP-500';
END
GO

-- DRI-FAS-125 - Fanta 1 litre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FAS-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta 1 litre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FAS-125';
    PRINT 'Updated: DRI-FAS-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FAS-125', 'Fanta 1 litre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FAS-125';
END
GO

-- DRI-FOC-500ML - Fanta Orange Can 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FOC-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta Orange Can 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FOC-500ML';
    PRINT 'Updated: DRI-FOC-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FOC-500ML', 'Fanta Orange Can 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FOC-500ML';
END
GO

-- DRI-FWT-400ML - Fanta What The Flavour 400ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-FWT-400ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta What The Flavour 400ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-FWT-400ML';
    PRINT 'Updated: DRI-FWT-400ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-FWT-400ML', 'Fanta What The Flavour 400ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-FWT-400ML';
END
GO

-- DRI-GRA-275 - Grapetiser 275ml NRB
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-GRA-275')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Grapetiser 275ml NRB',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-GRA-275';
    PRINT 'Updated: DRI-GRA-275';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-GRA-275', 'Grapetiser 275ml NRB', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-GRA-275';
END
GO

-- DRI-GRA-330 - Grapetiser 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-GRA-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Grapetiser 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-GRA-330';
    PRINT 'Updated: DRI-GRA-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-GRA-330', 'Grapetiser 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-GRA-330';
END
GO

-- DRI-GRW-330 - Grapetiser Wht 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-GRW-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Grapetiser Wht 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-GRW-330';
    PRINT 'Updated: DRI-GRW-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-GRW-330', 'Grapetiser Wht 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-GRW-330';
END
GO

-- DRI-IBR-125 - Iron Brew1.25ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IBR-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iron Brew1.25ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-IBR-125';
    PRINT 'Updated: DRI-IBR-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IBR-125', 'Iron Brew1.25ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-IBR-125';
END
GO

-- DRI-IRO-2LT - Iron Brew 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iron Brew 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-IRO-2LT';
    PRINT 'Updated: DRI-IRO-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IRO-2LT', 'Iron Brew 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-IRO-2LT';
END
GO

-- DRI-IRO-2LT - Iron Brew 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iron Brew 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-IRO-2LT';
    PRINT 'Updated: DRI-IRO-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IRO-2LT', 'Iron Brew 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-IRO-2LT';
END
GO

-- DRI-IRO-300 - Iron Brew 300ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iron Brew 300ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-IRO-300';
    PRINT 'Updated: DRI-IRO-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IRO-300', 'Iron Brew 300ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-IRO-300';
END
GO

-- DRI-IRO-330 - Iron Brew 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-IRO-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Iron Brew 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-IRO-330';
    PRINT 'Updated: DRI-IRO-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-IRO-330', 'Iron Brew 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-IRO-330';
END
GO

-- DRI-KAPP-500ML - Clover Krush 100% Apple
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-KAPP-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Clover Krush 100% Apple',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-KAPP-500ML';
    PRINT 'Updated: DRI-KAPP-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-KAPP-500ML', 'Clover Krush 100% Apple', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-KAPP-500ML';
END
GO

-- DRI-KFF-500ML - Clover Krush 6 Fruit � Fibre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-KFF-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Clover Krush 6 Fruit � Fibre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-KFF-500ML';
    PRINT 'Updated: DRI-KFF-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-KFF-500ML', 'Clover Krush 6 Fruit � Fibre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-KFF-500ML';
END
GO

-- DRI-KOR-500ML - Clover Krush 100% Orange
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-KOR-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Clover Krush 100% Orange',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-KOR-500ML';
    PRINT 'Updated: DRI-KOR-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-KOR-500ML', 'Clover Krush 100% Orange', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-KOR-500ML';
END
GO

-- DRI-MEN-500 - Monster Engery 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MEN-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Monster Engery 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-MEN-500';
    PRINT 'Updated: DRI-MEN-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MEN-500', 'Monster Engery 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-MEN-500';
END
GO

-- DRI-MML-500 - Monster Mucho Logo 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MML-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Monster Mucho Logo 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-MML-500';
    PRINT 'Updated: DRI-MML-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MML-500', 'Monster Mucho Logo 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-MML-500';
END
GO

-- DRI-MON-330 - Monster Original
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MON-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Monster Original',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-MON-330';
    PRINT 'Updated: DRI-MON-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MON-330', 'Monster Original', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-MON-330';
END
GO

-- DRI-MON-EAC - Monster
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-MON-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Monster',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-MON-EAC';
    PRINT 'Updated: DRI-MON-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-MON-EAC', 'Monster', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-MON-EAC';
END
GO

-- DRI-PBB-EAC - Powerade Blueberry 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-PBB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Powerade Blueberry 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-PBB-EAC';
    PRINT 'Updated: DRI-PBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-PBB-EAC', 'Powerade Blueberry 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-PBB-EAC';
END
GO

-- DRI-PGE-500 - Predator Gold Energy Drink 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-PGE-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Predator Gold Energy Drink 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-PGE-500';
    PRINT 'Updated: DRI-PGE-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-PGE-500', 'Predator Gold Energy Drink 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-PGE-500';
END
GO

-- DRI-PJI-EAC - Powerade Jagged Ice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-PJI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Powerade Jagged Ice',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-PJI-EAC';
    PRINT 'Updated: DRI-PJI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-PJI-EAC', 'Powerade Jagged Ice', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-PJI-EAC';
END
GO

-- DRI-PNA-500ML - Powerade Naartjie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-PNA-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Powerade Naartjie',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-PNA-500ML';
    PRINT 'Updated: DRI-PNA-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-PNA-500ML', 'Powerade Naartjie', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-PNA-500ML';
END
GO

-- DRI-PPL-EAC - Powerplay
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-PPL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Powerplay',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-PPL-EAC';
    PRINT 'Updated: DRI-PPL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-PPL-EAC', 'Powerplay', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-PPL-EAC';
END
GO

-- DRI-REB-EAC - Red Bull 250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-REB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red Bull 250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-REB-EAC';
    PRINT 'Updated: DRI-REB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-REB-EAC', 'Red Bull 250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-REB-EAC';
END
GO

-- DRI-REC-350ML - Red Cappuccino
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-REC-350ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red Cappuccino',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-REC-350ML';
    PRINT 'Updated: DRI-REC-350ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-REC-350ML', 'Red Cappuccino', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-REC-350ML';
END
GO

-- DRI-RSF-EAC - Red Bull Sugar Free
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-RSF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red Bull Sugar Free',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-RSF-EAC';
    PRINT 'Updated: DRI-RSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-RSF-EAC', 'Red Bull Sugar Free', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-RSF-EAC';
END
GO

-- DRI-SCS-125 - Spar C/Soda 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar C/Soda 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SCS-125';
    PRINT 'Updated: DRI-SCS-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SCS-125', 'Spar C/Soda 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SCS-125';
END
GO

-- DRI-SCS-2LT - Spar C\Soda 2lt
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar C\Soda 2lt',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SCS-2LT';
    PRINT 'Updated: DRI-SCS-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SCS-2LT', 'Spar C\Soda 2lt', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SCS-2LT';
END
GO

-- DRI-SCS-300 - Spar C/Soda 300ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar C/Soda 300ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SCS-300';
    PRINT 'Updated: DRI-SCS-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SCS-300', 'Spar C/Soda 300ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SCS-300';
END
GO

-- DRI-SCS-330 - Spar C/Soda 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar C/Soda 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SCS-330';
    PRINT 'Updated: DRI-SCS-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SCS-330', 'Spar C/Soda 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SCS-330';
END
GO

-- DRI-SCS-500 - Spar Cream Soda 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SCS-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Cream Soda 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SCS-500';
    PRINT 'Updated: DRI-SCS-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SCS-500', 'Spar Cream Soda 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SCS-500';
END
GO

-- DRI-SIB-125 - Spar Iron Brew 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SIB-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Iron Brew 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SIB-125';
    PRINT 'Updated: DRI-SIB-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SIB-125', 'Spar Iron Brew 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SIB-125';
END
GO

-- DRI-SPN-125 - Spar Pine Nut 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPN-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Pine Nut 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPN-125';
    PRINT 'Updated: DRI-SPN-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPN-125', 'Spar Pine Nut 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPN-125';
END
GO

-- DRI-SPN-2LT - Spar Sparbry Pine Nut 2ltr
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPN-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Sparbry Pine Nut 2ltr',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPN-2LT';
    PRINT 'Updated: DRI-SPN-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPN-2LT', 'Spar Sparbry Pine Nut 2ltr', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPN-2LT';
END
GO

-- DRI-SPR-125 - Sprite 1 litre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite 1 litre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPR-125';
    PRINT 'Updated: DRI-SPR-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPR-125', 'Sprite 1 litre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPR-125';
END
GO

-- DRI-SPR-2LT - Sprite 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPR-2LT';
    PRINT 'Updated: DRI-SPR-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPR-2LT', 'Sprite 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPR-2LT';
END
GO

-- DRI-SPR-300 - Sprite 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPR-300';
    PRINT 'Updated: DRI-SPR-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPR-300', 'Sprite 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPR-300';
END
GO

-- DRI-SPR-330 - Sprite 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPR-330';
    PRINT 'Updated: DRI-SPR-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPR-330', 'Sprite 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPR-330';
END
GO

-- DRI-SPR-440 - Sprite 400ml can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-440')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite 400ml can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPR-440';
    PRINT 'Updated: DRI-SPR-440';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPR-440', 'Sprite 400ml can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPR-440';
END
GO

-- DRI-SPR-500 - Sprite 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPR-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPR-500';
    PRINT 'Updated: DRI-SPR-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPR-500', 'Sprite 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPR-500';
END
GO

-- DRI-SPZ-2LT - Sprite Zero 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPZ-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite Zero 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPZ-2LT';
    PRINT 'Updated: DRI-SPZ-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPZ-2LT', 'Sprite Zero 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPZ-2LT';
END
GO

-- DRI-SPZ-330 - Sprite Zero 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPZ-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite Zero 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPZ-330';
    PRINT 'Updated: DRI-SPZ-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPZ-330', 'Sprite Zero 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPZ-330';
END
GO

-- DRI-SPZ-500 - Sprite Zero 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SPZ-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sprite Zero 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SPZ-500';
    PRINT 'Updated: DRI-SPZ-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SPZ-500', 'Sprite Zero 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SPZ-500';
END
GO

-- DRI-SRB-500 - Sparletta Raspberry 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SRB-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sparletta Raspberry 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SRB-500';
    PRINT 'Updated: DRI-SRB-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SRB-500', 'Sparletta Raspberry 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SRB-500';
END
GO

-- DRI-SSB-125 - Sparletta 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SSB-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sparletta 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SSB-125';
    PRINT 'Updated: DRI-SSB-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SSB-125', 'Sparletta 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SSB-125';
END
GO

-- DRI-SSB-2LT - Spar Sparberry 2LTR
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SSB-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Sparberry 2LTR',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SSB-2LT';
    PRINT 'Updated: DRI-SSB-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SSB-2LT', 'Spar Sparberry 2LTR', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SSB-2LT';
END
GO

-- DRI-SSB-330 - Spar Sparbry 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SSB-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Sparbry 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SSB-330';
    PRINT 'Updated: DRI-SSB-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SSB-330', 'Spar Sparbry 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SSB-330';
END
GO

-- DRI-SST-300 - Spar Stoney 300ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SST-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Stoney 300ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SST-300';
    PRINT 'Updated: DRI-SST-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SST-300', 'Spar Stoney 300ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SST-300';
END
GO

-- DRI-SST-330 - Spar Stoney 330ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-SST-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Spar Stoney 330ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-SST-330';
    PRINT 'Updated: DRI-SST-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-SST-330', 'Spar Stoney 330ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-SST-330';
END
GO

-- DRI-STO-125 - Stoney 1 litre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Stoney 1 litre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-STO-125';
    PRINT 'Updated: DRI-STO-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-STO-125', 'Stoney 1 litre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-STO-125';
END
GO

-- DRI-STO-2LT - Stoney Ginger Beer 2lt
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Stoney Ginger Beer 2lt',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-STO-2LT';
    PRINT 'Updated: DRI-STO-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-STO-2LT', 'Stoney Ginger Beer 2lt', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-STO-2LT';
END
GO

-- DRI-STO-440 - Stoney 400ml can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-440')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Stoney 400ml can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-STO-440';
    PRINT 'Updated: DRI-STO-440';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-STO-440', 'Stoney 400ml can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-STO-440';
END
GO

-- DRI-STO-500 - Stoney -gingerbeer 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-STO-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Stoney -gingerbeer 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-STO-500';
    PRINT 'Updated: DRI-STO-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-STO-500', 'Stoney -gingerbeer 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-STO-500';
END
GO

-- DRI-STW-500 - Water 500ml Still
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-STW-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Water 500ml Still',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-STW-500';
    PRINT 'Updated: DRI-STW-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-STW-500', 'Water 500ml Still', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-STW-500';
END
GO

-- DRI-STW-EAC - Still Water
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-STW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Still Water',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-STW-EAC';
    PRINT 'Updated: DRI-STW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-STW-EAC', 'Still Water', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-STW-EAC';
END
GO

-- DRI-TGR-1.5L - Twist Grandilla 1.5ltr
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TGR-1.5L')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Grandilla 1.5ltr',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TGR-1.5L';
    PRINT 'Updated: DRI-TGR-1.5L';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TGR-1.5L', 'Twist Grandilla 1.5ltr', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TGR-1.5L';
END
GO

-- DRI-TWG-125 - Twist Gran 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Gran 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWG-125';
    PRINT 'Updated: DRI-TWG-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWG-125', 'Twist Gran 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWG-125';
END
GO

-- DRI-TWG-2LT - Twist Gran 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Gran 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWG-2LT';
    PRINT 'Updated: DRI-TWG-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWG-2LT', 'Twist Gran 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWG-2LT';
END
GO

-- DRI-TWG-2LT - Twist Gran 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Gran 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWG-2LT';
    PRINT 'Updated: DRI-TWG-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWG-2LT', 'Twist Gran 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWG-2LT';
END
GO

-- DRI-TWG-300 - Twist Gran 300ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-300')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Gran 300ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWG-300';
    PRINT 'Updated: DRI-TWG-300';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWG-300', 'Twist Gran 300ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWG-300';
END
GO

-- DRI-TWG-330 - Twist Gran 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Gran 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWG-330';
    PRINT 'Updated: DRI-TWG-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWG-330', 'Twist Gran 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWG-330';
END
GO

-- DRI-TWG-500 - Twist Gran 440ml Buddy
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWG-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Gran 440ml Buddy',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWG-500';
    PRINT 'Updated: DRI-TWG-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWG-500', 'Twist Gran 440ml Buddy', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWG-500';
END
GO

-- DRI-TWL-1.5L - Twist Lemon 1.5 Litre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-1.5L')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Lemon 1.5 Litre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWL-1.5L';
    PRINT 'Updated: DRI-TWL-1.5L';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWL-1.5L', 'Twist Lemon 1.5 Litre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWL-1.5L';
END
GO

-- DRI-TWL-125 - Twist Lemon 1250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-125')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Lemon 1250ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWL-125';
    PRINT 'Updated: DRI-TWL-125';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWL-125', 'Twist Lemon 1250ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWL-125';
END
GO

-- DRI-TWL-2LT - Twist Lemon 2l
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Lemon 2l',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWL-2LT';
    PRINT 'Updated: DRI-TWL-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWL-2LT', 'Twist Lemon 2l', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWL-2LT';
END
GO

-- DRI-TWL-330 - Twist Lemon 300ml Can
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-330')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Lemon 300ml Can',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWL-330';
    PRINT 'Updated: DRI-TWL-330';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWL-330', 'Twist Lemon 300ml Can', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWL-330';
END
GO

-- DRI-TWL-500 - Twist Lemon 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-TWL-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Twist Lemon 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-TWL-500';
    PRINT 'Updated: DRI-TWL-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-TWL-500', 'Twist Lemon 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-TWL-500';
END
GO

-- DRI-VAL-150 - Water valpre still 1500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-VAL-150')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Water valpre still 1500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-VAL-150';
    PRINT 'Updated: DRI-VAL-150';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-VAL-150', 'Water valpre still 1500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-VAL-150';
END
GO

-- DRI-VAL-500 - Water Valpre Still 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-VAL-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Water Valpre Still 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-VAL-500';
    PRINT 'Updated: DRI-VAL-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-VAL-500', 'Water Valpre Still 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-VAL-500';
END
GO

-- DRI-WTF-2LTR - Fanta What The Flavour 2litre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'DRI-WTF-2LTR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fanta What The Flavour 2litre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'DRI-WTF-2LTR';
    PRINT 'Updated: DRI-WTF-2LTR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('DRI-WTF-2LTR', 'Fanta What The Flavour 2litre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: DRI-WTF-2LTR';
END
GO

-- JUI- FNB-500ML - Juice Krush Fruit Nectar 500ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI- FNB-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Juice Krush Fruit Nectar 500ml',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI- FNB-500ML';
    PRINT 'Updated: JUI- FNB-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI- FNB-500ML', 'Juice Krush Fruit Nectar 500ml', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI- FNB-500ML';
END
GO

-- JUI-EBL-500 - Energade 500ml Blueberry
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-EBL-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Energade 500ml Blueberry',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-EBL-500';
    PRINT 'Updated: JUI-EBL-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-EBL-500', 'Energade 500ml Blueberry', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-EBL-500';
END
GO

-- JUI-EGR-500 - Energade 500ml Grape
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-EGR-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Energade 500ml Grape',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-EGR-500';
    PRINT 'Updated: JUI-EGR-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-EGR-500', 'Energade 500ml Grape', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-EGR-500';
END
GO

-- JUI-ELL-500 - Energade 500ml Lemon & Lime
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-ELL-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Energade 500ml Lemon & Lime',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-ELL-500';
    PRINT 'Updated: JUI-ELL-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-ELL-500', 'Energade 500ml Lemon & Lime', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-ELL-500';
END
GO

-- JUI-EMB-500 - Energade 500ml Mixed Berry
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-EMB-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Energade 500ml Mixed Berry',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-EMB-500';
    PRINT 'Updated: JUI-EMB-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-EMB-500', 'Energade 500ml Mixed Berry', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-EMB-500';
END
GO

-- JUI-ENA-500 - Energade 500ml Naartjie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-ENA-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Energade 500ml Naartjie',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-ENA-500';
    PRINT 'Updated: JUI-ENA-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-ENA-500', 'Energade 500ml Naartjie', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-ENA-500';
END
GO

-- JUI-ENO-500 - Energade 500ml Orange
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-ENO-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Energade 500ml Orange',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-ENO-500';
    PRINT 'Updated: JUI-ENO-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-ENO-500', 'Energade 500ml Orange', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-ENO-500';
END
GO

-- JUI-ETR-500 - Energade 500ml Tropical
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-ETR-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Energade 500ml Tropical',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-ETR-500';
    PRINT 'Updated: JUI-ETR-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-ETR-500', 'Energade 500ml Tropical', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-ETR-500';
END
GO

-- JUI-KRM-500ML - Clover Krush 100% Mango
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-KRM-500ML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Clover Krush 100% Mango',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-KRM-500ML';
    PRINT 'Updated: JUI-KRM-500ML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-KRM-500ML', 'Clover Krush 100% Mango', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-KRM-500ML';
END
GO

-- JUI-ORA-2LT - Juice 2l Orange Nectar
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-ORA-2LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Juice 2l Orange Nectar',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-ORA-2LT';
    PRINT 'Updated: JUI-ORA-2LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-ORA-2LT', 'Juice 2l Orange Nectar', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-ORA-2LT';
END
GO

-- JUI-ORA-500 - Juice 500ml Orange Nectar
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-ORA-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Juice 500ml Orange Nectar',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-ORA-500';
    PRINT 'Updated: JUI-ORA-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-ORA-500', 'Juice 500ml Orange Nectar', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-ORA-500';
END
GO

-- JUI-PIN-1LT - Juice Tropika 1Litre
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-PIN-1LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Juice Tropika 1Litre',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-PIN-1LT';
    PRINT 'Updated: JUI-PIN-1LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-PIN-1LT', 'Juice Tropika 1Litre', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-PIN-1LT';
END
GO

-- JUI-TRO-1.5L - Tropika 1.5lt pineapple
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-1.5L')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tropika 1.5lt pineapple',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-TRO-1.5L';
    PRINT 'Updated: JUI-TRO-1.5L';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-TRO-1.5L', 'Tropika 1.5lt pineapple', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-TRO-1.5L';
END
GO

-- JUI-TRO-1.5Lt - Tropika 1.5lt Orange
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-1.5Lt')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tropika 1.5lt Orange',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-TRO-1.5Lt';
    PRINT 'Updated: JUI-TRO-1.5Lt';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-TRO-1.5Lt', 'Tropika 1.5lt Orange', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-TRO-1.5Lt';
END
GO

-- JUI-TRO-1LT - Tropika 1l Orange
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-1LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tropika 1l Orange',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-TRO-1LT';
    PRINT 'Updated: JUI-TRO-1LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-TRO-1LT', 'Tropika 1l Orange', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-TRO-1LT';
END
GO

-- JUI-TRO-500 - Tropika 500ml Orange
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-TRO-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tropika 500ml Orange',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-TRO-500';
    PRINT 'Updated: JUI-TRO-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-TRO-500', 'Tropika 500ml Orange', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-TRO-500';
END
GO

-- JUI-TRP-1LT - Tropika 1l Pineapple
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-TRP-1LT')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tropika 1l Pineapple',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-TRP-1LT';
    PRINT 'Updated: JUI-TRP-1LT';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-TRP-1LT', 'Tropika 1l Pineapple', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-TRP-1LT';
END
GO

-- JUI-TRP-250 - Tropika 250ml Pineapple
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-TRP-250')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tropika 250ml Pineapple',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-TRP-250';
    PRINT 'Updated: JUI-TRP-250';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-TRP-250', 'Tropika 250ml Pineapple', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-TRP-250';
END
GO

-- JUI-TRP-500 - Tropika 500ml Pineapple
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'juice' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'JUI-TRP-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tropika 500ml Pineapple',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'JUI-TRP-500';
    PRINT 'Updated: JUI-TRP-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('JUI-TRP-500', 'Tropika 500ml Pineapple', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: JUI-TRP-500';
END
GO

-- MIL-SMB-EAC - Super M 300ml Banana
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIL-SMB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Super M 300ml Banana',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIL-SMB-EAC';
    PRINT 'Updated: MIL-SMB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIL-SMB-EAC', 'Super M 300ml Banana', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIL-SMB-EAC';
END
GO

-- MIL-SMC-EAC - Super M 300ml Chocolate
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIL-SMC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Super M 300ml Chocolate',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIL-SMC-EAC';
    PRINT 'Updated: MIL-SMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIL-SMC-EAC', 'Super M 300ml Chocolate', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIL-SMC-EAC';
END
GO

-- MIL-SMO-EAC - Super M 300ml Cream Soda
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIL-SMO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Super M 300ml Cream Soda',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIL-SMO-EAC';
    PRINT 'Updated: MIL-SMO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIL-SMO-EAC', 'Super M 300ml Cream Soda', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIL-SMO-EAC';
END
GO

-- MIL-SMS-EAC - Super M 300ml Strawberry
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Drinks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'drink' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIL-SMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Super M 300ml Strawberry',
        Category = 'Drinks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIL-SMS-EAC';
    PRINT 'Updated: MIL-SMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIL-SMS-EAC', 'Super M 300ml Strawberry', 'Drinks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIL-SMS-EAC';
END
GO

-- CEX- BDC-EAC - Bar One 6 Layer Drip With Toppings
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX- BDC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bar One 6 Layer Drip With Toppings',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX- BDC-EAC';
    PRINT 'Updated: CEX- BDC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX- BDC-EAC', 'Bar One 6 Layer Drip With Toppings', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX- BDC-EAC';
END
GO

-- CEX- BEG-EAC - FC Bar One Eggless Drip
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX- BEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Bar One Eggless Drip',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX- BEG-EAC';
    PRINT 'Updated: CEX- BEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX- BEG-EAC', 'FC Bar One Eggless Drip', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX- BEG-EAC';
END
GO

-- CEX CCD-EAC - Cheese Cake Dessert
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX CCD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cheese Cake Dessert',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX CCD-EAC';
    PRINT 'Updated: CEX CCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX CCD-EAC', 'Cheese Cake Dessert', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX CCD-EAC';
END
GO

-- CEX- MCP-EAC - Moist Chocolate Pudding
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX- MCP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Moist Chocolate Pudding',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX- MCP-EAC';
    PRINT 'Updated: CEX- MCP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX- MCP-EAC', 'Moist Chocolate Pudding', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX- MCP-EAC';
END
GO

-- CEX- MDB-EAC - Buttercream 6 Layer Drip Cake with toppings
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX- MDB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Buttercream 6 Layer Drip Cake with toppings',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX- MDB-EAC';
    PRINT 'Updated: CEX- MDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX- MDB-EAC', 'Buttercream 6 Layer Drip Cake with toppings', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX- MDB-EAC';
END
GO

-- CEX- NBS-EAC - New York Blueberry Cheese Cake Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX- NBS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'New York Blueberry Cheese Cake Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX- NBS-EAC';
    PRINT 'Updated: CEX- NBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX- NBS-EAC', 'New York Blueberry Cheese Cake Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX- NBS-EAC';
END
GO

-- CEX -NYW-EAC - New York Baked Cheese Cake Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX -NYW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'New York Baked Cheese Cake Round',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX -NYW-EAC';
    PRINT 'Updated: CEX -NYW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX -NYW-EAC', 'New York Baked Cheese Cake Round', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX -NYW-EAC';
END
GO

-- CEX-AMB-EAC - American Brownie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-AMB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'American Brownie',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-AMB-EAC';
    PRINT 'Updated: CEX-AMB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-AMB-EAC', 'American Brownie', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-AMB-EAC';
END
GO

-- CEX-APP-EAC - Apple Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-APP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Apple Tart',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-APP-EAC';
    PRINT 'Updated: CEX-APP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-APP-EAC', 'Apple Tart', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-APP-EAC';
END
GO

-- CEX-ATS-EAC - Apple Tartlet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-ATS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Apple Tartlet',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-ATS-EAC';
    PRINT 'Updated: CEX-ATS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-ATS-EAC', 'Apple Tartlet', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-ATS-EAC';
END
GO

-- CEX-BAR-012 - BD Bar One Square 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Bar One Square 12',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BAR-012';
    PRINT 'Updated: CEX-BAR-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BAR-012', 'BD Bar One Square 12', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BAR-012';
END
GO

-- CEX-BAR-014 - BD Bar One Square 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Bar One Square 14',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BAR-014';
    PRINT 'Updated: CEX-BAR-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BAR-014', 'BD Bar One Square 14', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BAR-014';
END
GO

-- CEX-BAR-016 - BD Bar One Square 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Bar One Square 16',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BAR-016';
    PRINT 'Updated: CEX-BAR-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BAR-016', 'BD Bar One Square 16', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BAR-016';
END
GO

-- CEX-BAR-018 - BD Bar One Square 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Bar One Square 18',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BAR-018';
    PRINT 'Updated: CEX-BAR-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BAR-018', 'BD Bar One Square 18', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BAR-018';
END
GO

-- CEX-BAR-020 - BD Bar One Square 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BAR-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Bar One Square 20',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BAR-020';
    PRINT 'Updated: CEX-BAR-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BAR-020', 'BD Bar One Square 20', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BAR-020';
END
GO

-- CEX-BCC-EAC - Baked Citrus Cheese Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Baked Citrus Cheese Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BCC-EAC';
    PRINT 'Updated: CEX-BCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BCC-EAC', 'Baked Citrus Cheese Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BCC-EAC';
END
GO

-- CEX-BOL-EAC - Bar One Log
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BOL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bar One Log',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BOL-EAC';
    PRINT 'Updated: CEX-BOL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BOL-EAC', 'Bar One Log', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BOL-EAC';
END
GO

-- CEX-BOM-EAC - Mothers Day Bar One Round with rose and leaves
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BOM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mothers Day Bar One Round with rose and leaves',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BOM-EAC';
    PRINT 'Updated: CEX-BOM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BOM-EAC', 'Mothers Day Bar One Round with rose and leaves', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BOM-EAC';
END
GO

-- CEX-BOR-EAC - Bar One Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BOR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bar One Round',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BOR-EAC';
    PRINT 'Updated: CEX-BOR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BOR-EAC', 'Bar One Round', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BOR-EAC';
END
GO

-- CEX-BOS-EAC - Bar One Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BOS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bar One Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BOS-EAC';
    PRINT 'Updated: CEX-BOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BOS-EAC', 'Bar One Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BOS-EAC';
END
GO

-- CEX-BRC-EAC - Baked Red Velvet Cheese Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BRC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Baked Red Velvet Cheese Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BRC-EAC';
    PRINT 'Updated: CEX-BRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BRC-EAC', 'Baked Red Velvet Cheese Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BRC-EAC';
END
GO

-- CEX-BVC-EAC - Baked Vanilla Cheese Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-BVC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Baked Vanilla Cheese Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-BVC-EAC';
    PRINT 'Updated: CEX-BVC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-BVC-EAC', 'Baked Vanilla Cheese Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-BVC-EAC';
END
GO

-- CEX-CAC-012 - BD 12 Carrot Cake square wit cream cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CAC-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 12 Carrot Cake square wit cream cheese',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CAC-012';
    PRINT 'Updated: CEX-CAC-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CAC-012', 'BD 12 Carrot Cake square wit cream cheese', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CAC-012';
END
GO

-- CEX-CAC-014 - BD 14'' Carrot cake square with cream cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CAC-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 14'' Carrot cake square with cream cheese',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CAC-014';
    PRINT 'Updated: CEX-CAC-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CAC-014', 'BD 14'' Carrot cake square with cream cheese', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CAC-014';
END
GO

-- CEX-CAC-016 - BD 16'' Carrot Cake Square with cream cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CAC-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16'' Carrot Cake Square with cream cheese',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CAC-016';
    PRINT 'Updated: CEX-CAC-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CAC-016', 'BD 16'' Carrot Cake Square with cream cheese', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CAC-016';
END
GO

-- CEX-CAC-018 - BD 18 Carrot Cake Square with cream cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CAC-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 18 Carrot Cake Square with cream cheese',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CAC-018';
    PRINT 'Updated: CEX-CAC-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CAC-018', 'BD 18 Carrot Cake Square with cream cheese', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CAC-018';
END
GO

-- CEX-CAC-020 - BD 20 Carrot Cake Square with cream cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CAC-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 20 Carrot Cake Square with cream cheese',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CAC-020';
    PRINT 'Updated: CEX-CAC-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CAC-020', 'BD 20 Carrot Cake Square with cream cheese', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CAC-020';
END
GO

-- CEX-CAC-EAC - Carrot Cake Cupcake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CAC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Carrot Cake Cupcake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CAC-EAC';
    PRINT 'Updated: CEX-CAC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CAC-EAC', 'Carrot Cake Cupcake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CAC-EAC';
END
GO

-- CEX-CBD-EAC - Chocolate Bar One 6 Layer Drip Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CBD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Bar One 6 Layer Drip Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CBD-EAC';
    PRINT 'Updated: CEX-CBD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CBD-EAC', 'Chocolate Bar One 6 Layer Drip Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CBD-EAC';
END
GO

-- CEX-CBO-EAC - Christmas Bar One Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CBO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Bar One Round',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CBO-EAC';
    PRINT 'Updated: CEX-CBO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CBO-EAC', 'Christmas Bar One Round', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CBO-EAC';
END
GO

-- CEX-CCC-EAC - Baked Choclate Cheese Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Baked Choclate Cheese Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CCC-EAC';
    PRINT 'Updated: CEX-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CCC-EAC', 'Baked Choclate Cheese Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CCC-EAC';
END
GO

-- CEX-CCP-6S - Chocolate Cake Pops (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CCP-6S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Cake Pops (6s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CCP-6S';
    PRINT 'Updated: CEX-CCP-6S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CCP-6S', 'Chocolate Cake Pops (6s)', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CCP-6S';
END
GO

-- CEX-CCS-EAC - Cheese Cake Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CCS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cheese Cake Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CCS-EAC';
    PRINT 'Updated: CEX-CCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CCS-EAC', 'Cheese Cake Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CCS-EAC';
END
GO

-- CEX-CCT-EAC - Cheese Cake Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CCT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cheese Cake Tart',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CCT-EAC';
    PRINT 'Updated: CEX-CCT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CCT-EAC', 'Cheese Cake Tart', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CCT-EAC';
END
GO

-- CEX-CEG-EAC - Caramel Exotic Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Caramel Exotic Gateaux',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CEG-EAC';
    PRINT 'Updated: CEX-CEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CEG-EAC', 'Caramel Exotic Gateaux', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CEG-EAC';
END
GO

-- CEX-CFD-EAC - Chocolate Fererro 6 Layer Drip Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CFD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Fererro 6 Layer Drip Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CFD-EAC';
    PRINT 'Updated: CEX-CFD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CFD-EAC', 'Chocolate Fererro 6 Layer Drip Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CFD-EAC';
END
GO

-- CEX-CFE-EAC - Christmas Ferrero Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CFE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Ferrero Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CFE-EAC';
    PRINT 'Updated: CEX-CFE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CFE-EAC', 'Christmas Ferrero Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CFE-EAC';
END
GO

-- CEX-CHC-EAC - Chocolate Cheese Cake Cup
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CHC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Cheese Cake Cup',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CHC-EAC';
    PRINT 'Updated: CEX-CHC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CHC-EAC', 'Chocolate Cheese Cake Cup', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CHC-EAC';
END
GO

-- CEX-CIC-EAC - Citrus Cheese Cake Cup
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CIC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Citrus Cheese Cake Cup',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CIC-EAC';
    PRINT 'Updated: CEX-CIC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CIC-EAC', 'Citrus Cheese Cake Cup', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CIC-EAC';
END
GO

-- CEX-CRM-EAC - Moist Choc Cake With Cream Cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CRM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Moist Choc Cake With Cream Cheese',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CRM-EAC';
    PRINT 'Updated: CEX-CRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CRM-EAC', 'Moist Choc Cake With Cream Cheese', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CRM-EAC';
END
GO

-- CEX-CUS-EAC - Custard & Jelly
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-CUS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Custard & Jelly',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-CUS-EAC';
    PRINT 'Updated: CEX-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-CUS-EAC', 'Custard & Jelly', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-CUS-EAC';
END
GO

-- CEX-DCV-EAC - Decorative Chocolate Vanilla Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-DCV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Decorative Chocolate Vanilla Gateaux',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-DCV-EAC';
    PRINT 'Updated: CEX-DCV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-DCV-EAC', 'Decorative Chocolate Vanilla Gateaux', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-DCV-EAC';
END
GO

-- CEX-EBC-EACH - Bar One Cupcake Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-EBC-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bar One Cupcake Eggless',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-EBC-EACH';
    PRINT 'Updated: CEX-EBC-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-EBC-EACH', 'Bar One Cupcake Eggless', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-EBC-EACH';
END
GO

-- CEX-FEM-EAC - Mothers Day Ferrero Round with rose and leaves
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FEM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mothers Day Ferrero Round with rose and leaves',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-FEM-EAC';
    PRINT 'Updated: CEX-FEM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FEM-EAC', 'Mothers Day Ferrero Round with rose and leaves', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-FEM-EAC';
END
GO

-- CEX-FER-012 - BD Ferrero Cake 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Ferrero Cake 12',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-FER-012';
    PRINT 'Updated: CEX-FER-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FER-012', 'BD Ferrero Cake 12', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-FER-012';
END
GO

-- CEX-FER-014 - BD Ferrero Cake 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Ferrero Cake 14',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-FER-014';
    PRINT 'Updated: CEX-FER-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FER-014', 'BD Ferrero Cake 14', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-FER-014';
END
GO

-- CEX-FER-016 - BD Ferrero Cake 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Ferrero Cake 16',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-FER-016';
    PRINT 'Updated: CEX-FER-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FER-016', 'BD Ferrero Cake 16', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-FER-016';
END
GO

-- CEX-FER-018 - BD Ferrero Cake 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Ferrero Cake 18',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-FER-018';
    PRINT 'Updated: CEX-FER-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FER-018', 'BD Ferrero Cake 18', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-FER-018';
END
GO

-- CEX-FER-020 - BD Ferrero Cake 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FER-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Ferrero Cake 20',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-FER-020';
    PRINT 'Updated: CEX-FER-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FER-020', 'BD Ferrero Cake 20', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-FER-020';
END
GO

-- CEX-FRC-EAC - Ferrero Rocher Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FRC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Ferrero Rocher Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-FRC-EAC';
    PRINT 'Updated: CEX-FRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FRC-EAC', 'Ferrero Rocher Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-FRC-EAC';
END
GO

-- CEX-GCA-EAC - Giant Cappuchino Muffin
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GCA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Cappuchino Muffin',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GCA-EAC';
    PRINT 'Updated: CEX-GCA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GCA-EAC', 'Giant Cappuchino Muffin', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GCA-EAC';
END
GO

-- CEX-GCC-EAC - Giant Corn & Chives Muffin
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Corn & Chives Muffin',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GCC-EAC';
    PRINT 'Updated: CEX-GCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GCC-EAC', 'Giant Corn & Chives Muffin', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GCC-EAC';
END
GO

-- CEX-GCH-EAC - Giant Choc Muffin
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GCH-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Choc Muffin',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GCH-EAC';
    PRINT 'Updated: CEX-GCH-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GCH-EAC', 'Giant Choc Muffin', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GCH-EAC';
END
GO

-- CEX-GCM-EAC - Giant Chicken & Mushroom Muffin
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GCM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Chicken & Mushroom Muffin',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GCM-EAC';
    PRINT 'Updated: CEX-GCM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GCM-EAC', 'Giant Chicken & Mushroom Muffin', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GCM-EAC';
END
GO

-- CEX-GIM-EAC - Giant Muffins
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GIM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Muffins',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GIM-EAC';
    PRINT 'Updated: CEX-GIM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GIM-EAC', 'Giant Muffins', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GIM-EAC';
END
GO

-- CEX-GLP-EAC - Giant Lemon Poppy& Nuts
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GLP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Lemon Poppy& Nuts',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GLP-EAC';
    PRINT 'Updated: CEX-GLP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GLP-EAC', 'Giant Lemon Poppy& Nuts', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GLP-EAC';
END
GO

-- CEX-GPC-EAC - Giant Pecan & Carrot Muffin
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GPC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Pecan & Carrot Muffin',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GPC-EAC';
    PRINT 'Updated: CEX-GPC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GPC-EAC', 'Giant Pecan & Carrot Muffin', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GPC-EAC';
END
GO

-- CEX-GSF-EAC - Giant Spinach & Feta Muffin
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GSF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Spinach & Feta Muffin',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GSF-EAC';
    PRINT 'Updated: CEX-GSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GSF-EAC', 'Giant Spinach & Feta Muffin', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GSF-EAC';
END
GO

-- CEX-GVA-EAC - Giant Vanilla Muffins
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-GVA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Giant Vanilla Muffins',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-GVA-EAC';
    PRINT 'Updated: CEX-GVA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-GVA-EAC', 'Giant Vanilla Muffins', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-GVA-EAC';
END
GO

-- CEX-LMS-EAC - Lemon Meringue Tart Small
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-LMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Lemon Meringue Tart Small',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-LMS-EAC';
    PRINT 'Updated: CEX-LMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-LMS-EAC', 'Lemon Meringue Tart Small', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-LMS-EAC';
END
GO

-- CEX-LMT-EAC - Lemon Meringue Tart Large
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-LMT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Lemon Meringue Tart Large',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-LMT-EAC';
    PRINT 'Updated: CEX-LMT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-LMT-EAC', 'Lemon Meringue Tart Large', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-LMT-EAC';
END
GO

-- CEX-MAC-EAC - Macaroons (4s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MAC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Macaroons (4s)',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MAC-EAC';
    PRINT 'Updated: CEX-MAC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MAC-EAC', 'Macaroons (4s)', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MAC-EAC';
END
GO

-- CEX-MAL-EAC - Malva Pudding
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MAL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Malva Pudding',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MAL-EAC';
    PRINT 'Updated: CEX-MAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MAL-EAC', 'Malva Pudding', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MAL-EAC';
END
GO

-- CEX-MAO-EAC - Macaroons (1s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MAO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Macaroons (1s)',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MAO-EAC';
    PRINT 'Updated: CEX-MAO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MAO-EAC', 'Macaroons (1s)', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MAO-EAC';
END
GO

-- CEX-MBE-EAC - Milky Bar Exotic
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MBE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Milky Bar Exotic',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MBE-EAC';
    PRINT 'Updated: CEX-MBE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MBE-EAC', 'Milky Bar Exotic', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MBE-EAC';
END
GO

-- CEX-MBS-EAC - Bar One Swissroll Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MBS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bar One Swissroll Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MBS-EAC';
    PRINT 'Updated: CEX-MBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MBS-EAC', 'Bar One Swissroll Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MBS-EAC';
END
GO

-- CEX-MCL-EACH - Moist Chocolate Cake Large With Cream Cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MCL-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Moist Chocolate Cake Large With Cream Cheese',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MCL-EACH';
    PRINT 'Updated: CEX-MCL-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MCL-EACH', 'Moist Chocolate Cake Large With Cream Cheese', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MCL-EACH';
END
GO

-- CEX-MIL-12 - BD Milky Bar 12''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MIL-12')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Milky Bar 12''''',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MIL-12';
    PRINT 'Updated: CEX-MIL-12';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MIL-12', 'BD Milky Bar 12''''', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MIL-12';
END
GO

-- CEX-MIL-14 - BD Milky Bar 14''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MIL-14')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Milky Bar 14''''',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MIL-14';
    PRINT 'Updated: CEX-MIL-14';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MIL-14', 'BD Milky Bar 14''''', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MIL-14';
END
GO

-- CEX-MIL-EAC - Milky Bar Swissroll Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MIL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Milky Bar Swissroll Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MIL-EAC';
    PRINT 'Updated: CEX-MIL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MIL-EAC', 'Milky Bar Swissroll Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MIL-EAC';
END
GO

-- CEX-MPN-EAC - Mini Pecan Nut Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MPN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Pecan Nut Tart',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MPN-EAC';
    PRINT 'Updated: CEX-MPN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MPN-EAC', 'Mini Pecan Nut Tart', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MPN-EAC';
END
GO

-- CEX-MPT-EAC - Malva Pudding Tartlet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MPT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Malva Pudding Tartlet',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MPT-EAC';
    PRINT 'Updated: CEX-MPT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MPT-EAC', 'Malva Pudding Tartlet', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MPT-EAC';
END
GO

-- CEX-MRC-EAC - Cream Cheese Rainbow Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MRC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cream Cheese Rainbow Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MRC-EAC';
    PRINT 'Updated: CEX-MRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MRC-EAC', 'Cream Cheese Rainbow Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MRC-EAC';
END
GO

-- CEX-MRS-EAC - Cream Cheese Rainbow Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MRS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cream Cheese Rainbow Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MRS-EAC';
    PRINT 'Updated: CEX-MRS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MRS-EAC', 'Cream Cheese Rainbow Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MRS-EAC';
END
GO

-- CEX-MVC-EAC - Moist Vanilla Cake with Caramel Drizzle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MVC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Moist Vanilla Cake with Caramel Drizzle',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MVC-EAC';
    PRINT 'Updated: CEX-MVC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MVC-EAC', 'Moist Vanilla Cake with Caramel Drizzle', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MVC-EAC';
END
GO

-- CEX-NBC-EAC - New York Baked Blueberry Cheesecake Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NBC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'New York Baked Blueberry Cheesecake Round',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NBC-EAC';
    PRINT 'Updated: CEX-NBC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NBC-EAC', 'New York Baked Blueberry Cheesecake Round', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NBC-EAC';
END
GO

-- CEX-NRV-EAC - New Red Velvet Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NRV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'New Red Velvet Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NRV-EAC';
    PRINT 'Updated: CEX-NRV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NRV-EAC', 'New Red Velvet Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NRV-EAC';
END
GO

-- CEX-NUT-18 - 18'''' Nibbed Nuts Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NUT-18')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '18'''' Nibbed Nuts Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NUT-18';
    PRINT 'Updated: CEX-NUT-18';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NUT-18', '18'''' Nibbed Nuts Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NUT-18';
END
GO

-- CEX-NYC-EAC - New York Baked Cheese Cake Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NYC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'New York Baked Cheese Cake Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NYC-EAC';
    PRINT 'Updated: CEX-NYC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NYC-EAC', 'New York Baked Cheese Cake Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NYC-EAC';
END
GO

-- CEX-PCT-4S - Portuguese Custard Tart (4S)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PCT-4S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Portuguese Custard Tart (4S)',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CEX-PCT-4S';
    PRINT 'Updated: CEX-PCT-4S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PCT-4S', 'Portuguese Custard Tart (4S)', 'exotic cakes', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CEX-PCT-4S';
END
GO

-- CEX-PCT-EAC - Portuguese Custard Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PCT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Portuguese Custard Tart',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CEX-PCT-EAC';
    PRINT 'Updated: CEX-PCT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PCT-EAC', 'Portuguese Custard Tart', 'exotic cakes', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CEX-PCT-EAC';
END
GO

-- CEX-PET-EACH - Pecan Nut Tartlet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PET-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pecan Nut Tartlet',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PET-EACH';
    PRINT 'Updated: CEX-PET-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PET-EACH', 'Pecan Nut Tartlet', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PET-EACH';
END
GO

-- CEX-PMC-EACH - Peppermint Crisp Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PMC-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Peppermint Crisp Cake',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PMC-EACH';
    PRINT 'Updated: CEX-PMC-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PMC-EACH', 'Peppermint Crisp Cake', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PMC-EACH';
END
GO

-- CEX-PNT-EAC - Pecan Nut Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PNT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pecan Nut Tart',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PNT-EAC';
    PRINT 'Updated: CEX-PNT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PNT-EAC', 'Pecan Nut Tart', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PNT-EAC';
END
GO

-- CEX-RCC-EAC - CARROT CAKE ROUND
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'CARROT CAKE ROUND',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RCC-EAC';
    PRINT 'Updated: CEX-RCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RCC-EAC', 'CARROT CAKE ROUND', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RCC-EAC';
END
GO

-- CEX-REC-EAC - Redvelvet Cheese Cake Cup
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-REC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Redvelvet Cheese Cake Cup',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-REC-EAC';
    PRINT 'Updated: CEX-REC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-REC-EAC', 'Redvelvet Cheese Cake Cup', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-REC-EAC';
END
GO

-- CEX-RED-016 - BD 16 Red Velvet Square
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RED-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16 Red Velvet Square',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RED-016';
    PRINT 'Updated: CEX-RED-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RED-016', 'BD 16 Red Velvet Square', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RED-016';
END
GO

-- CEX-RMC-EAC - OREO CAKE
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RMC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OREO CAKE',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RMC-EAC';
    PRINT 'Updated: CEX-RMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RMC-EAC', 'OREO CAKE', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RMC-EAC';
END
GO

-- CEX-RSW-EAC - Red velvet Swissroll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RSW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red velvet Swissroll',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RSW-EAC';
    PRINT 'Updated: CEX-RSW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RSW-EAC', 'Red velvet Swissroll', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RSW-EAC';
END
GO

-- CEX-RVB-018 - BD 18 Red Velvet Square
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RVB-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 18 Red Velvet Square',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RVB-018';
    PRINT 'Updated: CEX-RVB-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RVB-018', 'BD 18 Red Velvet Square', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RVB-018';
END
GO

-- CEX-RVB-020 - BD 20 Red Velvet Square
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RVB-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 20 Red Velvet Square',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RVB-020';
    PRINT 'Updated: CEX-RVB-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RVB-020', 'BD 20 Red Velvet Square', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RVB-020';
END
GO

-- CEX-RVC-EAC - Red Velvet Cupcakes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RVC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red Velvet Cupcakes',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RVC-EAC';
    PRINT 'Updated: CEX-RVC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RVC-EAC', 'Red Velvet Cupcakes', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RVC-EAC';
END
GO

-- CEX-RVG-EAC - Red Velvet Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RVG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red Velvet Gateaux',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RVG-EAC';
    PRINT 'Updated: CEX-RVG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RVG-EAC', 'Red Velvet Gateaux', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RVG-EAC';
END
GO

-- CEX-RVL-EAC - Red Velvet Log
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RVL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red Velvet Log',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RVL-EAC';
    PRINT 'Updated: CEX-RVL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RVL-EAC', 'Red Velvet Log', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RVL-EAC';
END
GO

-- CEX-RVS-EAC - Red Velvet Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RVS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Red Velvet Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RVS-EAC';
    PRINT 'Updated: CEX-RVS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RVS-EAC', 'Red Velvet Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RVS-EAC';
END
GO

-- CEX-TID-EAC - Tirumisu Dessert
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-TID-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tirumisu Dessert',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-TID-EAC';
    PRINT 'Updated: CEX-TID-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-TID-EAC', 'Tirumisu Dessert', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-TID-EAC';
END
GO

-- CEX-TIR-EAC - Cake Tiramisu
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-TIR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cake Tiramisu',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-TIR-EAC';
    PRINT 'Updated: CEX-TIR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-TIR-EAC', 'Cake Tiramisu', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-TIR-EAC';
END
GO

-- CEX-TIS-EAC - tirumisu slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-TIS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'tirumisu slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-TIS-EAC';
    PRINT 'Updated: CEX-TIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-TIS-EAC', 'tirumisu slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-TIS-EAC';
END
GO

-- CEX-TRE-EAC - Truffles Eggless 6s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-TRE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Truffles Eggless 6s',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-TRE-EAC';
    PRINT 'Updated: CEX-TRE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-TRE-EAC', 'Truffles Eggless 6s', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-TRE-EAC';
END
GO

-- CEX-TRF-EAC - Truffles (1)s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-TRF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Truffles (1)s',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-TRF-EAC';
    PRINT 'Updated: CEX-TRF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-TRF-EAC', 'Truffles (1)s', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-TRF-EAC';
END
GO

-- CEX-TRO-EAC - Tirumisu round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-TRO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tirumisu round',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-TRO-EAC';
    PRINT 'Updated: CEX-TRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-TRO-EAC', 'Tirumisu round', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-TRO-EAC';
END
GO

-- CEX-TRU-EAC - Truffles (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-TRU-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Truffles (6s)',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-TRU-EAC';
    PRINT 'Updated: CEX-TRU-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-TRU-EAC', 'Truffles (6s)', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-TRU-EAC';
END
GO

-- CEX-VAC-EAC - Vanilla Cheese Cake Cup
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-VAC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Vanilla Cheese Cake Cup',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-VAC-EAC';
    PRINT 'Updated: CEX-VAC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-VAC-EAC', 'Vanilla Cheese Cake Cup', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-VAC-EAC';
END
GO

-- CEX-VGB-EACH - Vegan Chocolate Brownie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-VGB-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Vegan Chocolate Brownie',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-VGB-EACH';
    PRINT 'Updated: CEX-VGB-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-VGB-EACH', 'Vegan Chocolate Brownie', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-VGB-EACH';
END
GO

-- CEZ-MIL-16 - BD Milky Bar 16''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEZ-MIL-16')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Milky Bar 16''''',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEZ-MIL-16';
    PRINT 'Updated: CEZ-MIL-16';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEZ-MIL-16', 'BD Milky Bar 16''''', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEZ-MIL-16';
END
GO

-- CFC-CCT-15CM - Gluten Free Carrot Cake Tub 15cm
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CCT-15CM')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Gluten Free Carrot Cake Tub 15cm',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CCT-15CM';
    PRINT 'Updated: CFC-CCT-15CM';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CCT-15CM', 'Gluten Free Carrot Cake Tub 15cm', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CCT-15CM';
END
GO

-- CFC-FCP-EAC - FC Caramel Sponge
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Caramel Sponge',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCP-EAC';
    PRINT 'Updated: CFC-FCP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCP-EAC', 'FC Caramel Sponge', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCP-EAC';
END
GO

-- CFC-FMS-EAC - FC Milky Bar Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Milky Bar Slice',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FMS-EAC';
    PRINT 'Updated: CFC-FMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FMS-EAC', 'FC Milky Bar Slice', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FMS-EAC';
END
GO

-- CFC-VVB-EAC - Vegan Vanilla 4 Layer -Berry Garnish
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-VVB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Vegan Vanilla 4 Layer -Berry Garnish',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-VVB-EAC';
    PRINT 'Updated: CFC-VVB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-VVB-EAC', 'Vegan Vanilla 4 Layer -Berry Garnish', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-VVB-EAC';
END
GO

-- ICE-SMO-EAC - GLUTEN FREE LEMON FRIDGE CHEESECAKE TUB
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'ICE-SMO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'GLUTEN FREE LEMON FRIDGE CHEESECAKE TUB',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'ICE-SMO-EAC';
    PRINT 'Updated: ICE-SMO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('ICE-SMO-EAC', 'GLUTEN FREE LEMON FRIDGE CHEESECAKE TUB', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: ICE-SMO-EAC';
END
GO

-- ICE-SRP-EAC - GLUTEN FREE CHOCOLATE GANACHE TUB
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'ICE-SRP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'GLUTEN FREE CHOCOLATE GANACHE TUB',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'ICE-SRP-EAC';
    PRINT 'Updated: ICE-SRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('ICE-SRP-EAC', 'GLUTEN FREE CHOCOLATE GANACHE TUB', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: ICE-SRP-EAC';
END
GO

-- PAC-STL-EAC - GLUTEN FREE COFFEE CAKE TUB
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-STL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'GLUTEN FREE COFFEE CAKE TUB',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-STL-EAC';
    PRINT 'Updated: PAC-STL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-STL-EAC', 'GLUTEN FREE COFFEE CAKE TUB', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-STL-EAC';
END
GO

-- PAC-TAL-EAC - GLUTEN FREE CHOC MOUSSE CAKE TUB
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-TAL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'GLUTEN FREE CHOC MOUSSE CAKE TUB',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-TAL-EAC';
    PRINT 'Updated: PAC-TAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-TAL-EAC', 'GLUTEN FREE CHOC MOUSSE CAKE TUB', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-TAL-EAC';
END
GO

-- XCH-BAR-EAC - Chocolate Bar One
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'XCH-BAR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Bar One',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'XCH-BAR-EAC';
    PRINT 'Updated: XCH-BAR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('XCH-BAR-EAC', 'Chocolate Bar One', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: XCH-BAR-EAC';
END
GO

-- YCC-MMC-EAC - RICH MOIST XMAS CAKE
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-MMC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'RICH MOIST XMAS CAKE',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'YCC-MMC-EAC';
    PRINT 'Updated: YCC-MMC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-MMC-EAC', 'RICH MOIST XMAS CAKE', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: YCC-MMC-EAC';
END
GO

-- ZDB-SDT-EAC - GLUTEN FREE COFFEE CAKE TUB
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'exotic cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'exotic cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'ZDB-SDT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'GLUTEN FREE COFFEE CAKE TUB',
        Category = 'exotic cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'ZDB-SDT-EAC';
    PRINT 'Updated: ZDB-SDT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('ZDB-SDT-EAC', 'GLUTEN FREE COFFEE CAKE TUB', 'exotic cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: ZDB-SDT-EAC';
END
GO

-- CBF-BLF-014 - BD Freshcream 14 Black Forest
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square black forest' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BLF-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 14 Black Forest',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BLF-014';
    PRINT 'Updated: CBF-BLF-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BLF-014', 'BD Freshcream 14 Black Forest', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BLF-014';
END
GO

-- CBF-BLF-016 - BD Freshcream 16 Blackforest
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream blackforest' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BLF-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 16 Blackforest',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BLF-016';
    PRINT 'Updated: CBF-BLF-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BLF-016', 'BD Freshcream 16 Blackforest', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BLF-016';
END
GO

-- CBF-FCD-014 - BD Freshcream 14 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FCD-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 14 DL',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FCD-014';
    PRINT 'Updated: CBF-FCD-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FCD-014', 'BD Freshcream 14 DL', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FCD-014';
END
GO

-- CBF-FCF-018 - BD Freshcream Figure 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FCF-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream Figure 18',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FCF-018';
    PRINT 'Updated: CBF-FCF-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FCF-018', 'BD Freshcream Figure 18', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FCF-018';
END
GO

-- CBF-FCF-020 - BD Freshcream Figure 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FCF-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream Figure 20',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FCF-020';
    PRINT 'Updated: CBF-FCF-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FCF-020', 'BD Freshcream Figure 20', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FCF-020';
END
GO

-- CBF-FF0-020 - BD 20 Freshcream Figure Only Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FF0-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 20 Freshcream Figure Only Eggless',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FF0-020';
    PRINT 'Updated: CBF-FF0-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FF0-020', 'BD 20 Freshcream Figure Only Eggless', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FF0-020';
END
GO

-- CBF-FFE-020 - BD Freshcream Figure on Base Eggless 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FFE-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream Figure on Base Eggless 20',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FFE-020';
    PRINT 'Updated: CBF-FFE-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FFE-020', 'BD Freshcream Figure on Base Eggless 20', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FFE-020';
END
GO

-- CBF-FFS-018 - BD Freshcream Fig on SL 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream figure cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FFS-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream Fig on SL 18',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FFS-018';
    PRINT 'Updated: CBF-FFS-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FFS-018', 'BD Freshcream Fig on SL 18', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FFS-018';
END
GO

-- CBF-FFS-020 - BD Freshcream Fig on SL 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream figure' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FFS-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream Fig on SL 20',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FFS-020';
    PRINT 'Updated: CBF-FFS-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FFS-020', 'BD Freshcream Fig on SL 20', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FFS-020';
END
GO

-- CBR-FCR-012 - BD Freshcream 12 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cake round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 12 Round',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-FCR-012';
    PRINT 'Updated: CBR-FCR-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-FCR-012', 'BD Freshcream 12 Round', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-FCR-012';
END
GO

-- CBR-FCR-014 - BD Freshcream 14 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cake round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 14 Round',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-FCR-014';
    PRINT 'Updated: CBR-FCR-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-FCR-014', 'BD Freshcream 14 Round', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-FCR-014';
END
GO

-- CBR-FCR-016 - BD Freshcream 16 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freashcream round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 16 Round',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-FCR-016';
    PRINT 'Updated: CBR-FCR-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-FCR-016', 'BD Freshcream 16 Round', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-FCR-016';
END
GO

-- CBR-FCR-018 - BD Freshcream 18 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 18 Round',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-FCR-018';
    PRINT 'Updated: CBR-FCR-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-FCR-018', 'BD Freshcream 18 Round', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-FCR-018';
END
GO

-- CBR-FCR-020 - BD Freshcream 20 Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream round' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBR-FCR-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 20 Round',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBR-FCR-020';
    PRINT 'Updated: CBR-FCR-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBR-FCR-020', 'BD Freshcream 20 Round', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBR-FCR-020';
END
GO

-- CBS-BLF-012 - BD Freshcream 12 Black Forest
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream black forest' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-BLF-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 12 Black Forest',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-BLF-012';
    PRINT 'Updated: CBS-BLF-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-BLF-012', 'BD Freshcream 12 Black Forest', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-BLF-012';
END
GO

-- CBS-FCD-012 - BD Freshcream 12 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 12 DL',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-FCD-012';
    PRINT 'Updated: CBS-FCD-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-FCD-012', 'BD Freshcream 12 DL', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-FCD-012';
END
GO

-- CBS-FCD-016 - BD Freshcream 16 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 16 DL',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-FCD-016';
    PRINT 'Updated: CBS-FCD-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-FCD-016', 'BD Freshcream 16 DL', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-FCD-016';
END
GO

-- CBS-FCD-018 - BD Freshcream 18 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 18 DL',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-FCD-018';
    PRINT 'Updated: CBS-FCD-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-FCD-018', 'BD Freshcream 18 DL', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-FCD-018';
END
GO

-- CBS-FCD-020 - BD Freshcream 20 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 20 DL',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-FCD-020';
    PRINT 'Updated: CBS-FCD-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-FCD-020', 'BD Freshcream 20 DL', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-FCD-020';
END
GO

-- CBS-FCD-022 - BD Freshcream 22 DL
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-FCD-022')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 22 DL',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-FCD-022';
    PRINT 'Updated: CBS-FCD-022';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-FCD-022', 'BD Freshcream 22 DL', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-FCD-022';
END
GO

-- CBS-FCE-016 - BD 16 Freshcream Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBS-FCE-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16 Freshcream Eggless',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBS-FCE-016';
    PRINT 'Updated: CBS-FCE-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBS-FCE-016', 'BD 16 Freshcream Eggless', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBS-FCE-016';
END
GO

-- CFC-EF1-1M - BD 1M X500 FC Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream 1mx 500' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-EF1-1M')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 1M X500 FC Eggless',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-EF1-1M';
    PRINT 'Updated: CFC-EF1-1M';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-EF1-1M', 'BD 1M X500 FC Eggless', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-EF1-1M';
END
GO

-- CNO-FC1-1X5 - BD Freshcream 1mx500
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream 1mx 500' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FC1-1X5')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 1mx500',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FC1-1X5';
    PRINT 'Updated: CNO-FC1-1X5';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FC1-1X5', 'BD Freshcream 1mx500', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FC1-1X5';
END
GO

-- CNO-FCE-1X5 - BD Freshcream 1m x 500 Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes 1mx500 eggless' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCE-1X5')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 1m x 500 Eggless',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCE-1X5';
    PRINT 'Updated: CNO-FCE-1X5';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCE-1X5', 'BD Freshcream 1m x 500 Eggless', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCE-1X5';
END
GO

-- SRN-FCE-020 - BD 20 Fresh Cream Eggless cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream Birthday Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream square eggless' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-FCE-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 20 Fresh Cream Eggless cake',
        Category = 'Fresh Cream Birthday Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-FCE-020';
    PRINT 'Updated: SRN-FCE-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-FCE-020', 'BD 20 Fresh Cream Eggless cake', 'Fresh Cream Birthday Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-FCE-020';
END
GO

-- CFC-BET-EAC - Belgica Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-BET-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Belgica Tart',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-BET-EAC';
    PRINT 'Updated: CFC-BET-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-BET-EAC', 'Belgica Tart', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-BET-EAC';
END
GO

-- CFC-BTL-EAC - Belgica Tartlet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-BTL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Belgica Tartlet',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-BTL-EAC';
    PRINT 'Updated: CFC-BTL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-BTL-EAC', 'Belgica Tartlet', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-BTL-EAC';
END
GO

-- CFC-CBS-EAC - FC Black Forest Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CBS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Black Forest Slice',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CBS-EAC';
    PRINT 'Updated: CFC-CBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CBS-EAC', 'FC Black Forest Slice', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CBS-EAC';
END
GO

-- CFC-CCC-EAC - Carrot Cake With Cream Cheese
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Carrot Cake With Cream Cheese',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CCC-EAC';
    PRINT 'Updated: CFC-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CCC-EAC', 'Carrot Cake With Cream Cheese', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CCC-EAC';
END
GO

-- CFC-CCD-EAC - Custard Doughnut
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CCD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Custard Doughnut',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CCD-EAC';
    PRINT 'Updated: CFC-CCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CCD-EAC', 'Custard Doughnut', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CCD-EAC';
END
GO

-- CFC-CFD-EAC - FC Choc Drip Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CFD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Choc Drip Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CFD-EAC';
    PRINT 'Updated: CFC-CFD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CFD-EAC', 'FC Choc Drip Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CFD-EAC';
END
GO

-- CFC-CFE-EACH - Christmas Freshcream Eggless Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CFE-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Freshcream Eggless Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CFE-EACH';
    PRINT 'Updated: CFC-CFE-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CFE-EACH', 'Christmas Freshcream Eggless Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CFE-EACH';
END
GO

-- CFC-CUD-EAC - Custard Danish
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CUD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Custard Danish',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CUD-EAC';
    PRINT 'Updated: CFC-CUD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CUD-EAC', 'Custard Danish', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CUD-EAC';
END
GO

-- CFC-CUS-EAC - Custard Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-CUS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Custard Slice',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-CUS-EAC';
    PRINT 'Updated: CFC-CUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-CUS-EAC', 'Custard Slice', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-CUS-EAC';
END
GO

-- CFC-EMT-EACH - Eggless Milk Tartlet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-EMT-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Eggless Milk Tartlet',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-EMT-EACH';
    PRINT 'Updated: CFC-EMT-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-EMT-EACH', 'Eggless Milk Tartlet', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-EMT-EACH';
END
GO

-- CFC-FBF-EAC - FC Black Forest Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FBF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Black Forest Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FBF-EAC';
    PRINT 'Updated: CFC-FBF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FBF-EAC', 'FC Black Forest Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FBF-EAC';
END
GO

-- CFC-FBG-EAC - FC Birthday Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FBG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Birthday Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FBG-EAC';
    PRINT 'Updated: CFC-FBG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FBG-EAC', 'FC Birthday Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FBG-EAC';
END
GO

-- CFC-FCD-EAC - Fresh Cream Doughnut
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fresh Cream Doughnut',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCD-EAC';
    PRINT 'Updated: CFC-FCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCD-EAC', 'Fresh Cream Doughnut', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCD-EAC';
END
GO

-- CFC-FCE-EAC - FC Eclair Chocolate
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Eclair Chocolate',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCE-EAC';
    PRINT 'Updated: CFC-FCE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCE-EAC', 'FC Eclair Chocolate', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCE-EAC';
END
GO

-- CFC-FCG-EAC - FC Chocolate Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Chocolate Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCG-EAC';
    PRINT 'Updated: CFC-FCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCG-EAC', 'FC Chocolate Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCG-EAC';
END
GO

-- CFC-FCJ-EAC - Christmas Freshcream Choc Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCJ-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Freshcream Choc Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCJ-EAC';
    PRINT 'Updated: CFC-FCJ-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCJ-EAC', 'Christmas Freshcream Choc Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCJ-EAC';
END
GO

-- CFC-FCL-EAC - FC Fresh Cream Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Fresh Cream Slice',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCL-EAC';
    PRINT 'Updated: CFC-FCL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCL-EAC', 'FC Fresh Cream Slice', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCL-EAC';
END
GO

-- CFC-FCM-EAC - FC Lamington Chocolate
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Lamington Chocolate',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCM-EAC';
    PRINT 'Updated: CFC-FCM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCM-EAC', 'FC Lamington Chocolate', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCM-EAC';
END
GO

-- CFC-FCR-EAC - FC Croissant 80g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Croissant 80g',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCR-EAC';
    PRINT 'Updated: CFC-FCR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCR-EAC', 'FC Croissant 80g', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCR-EAC';
END
GO

-- CFC-FCS-EAC - FC Chocolate Swiss Roll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FCS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Chocolate Swiss Roll',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FCS-EAC';
    PRINT 'Updated: CFC-FCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FCS-EAC', 'FC Chocolate Swiss Roll', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FCS-EAC';
END
GO

-- CFC-FDD-EAC - Cake Freshcream In Dome Eggless
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FDD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cake Freshcream In Dome Eggless',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FDD-EAC';
    PRINT 'Updated: CFC-FDD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FDD-EAC', 'Cake Freshcream In Dome Eggless', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FDD-EAC';
END
GO

-- CFC-FEB-EAC - FC Eggless Birthday Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FEB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Eggless Birthday Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FEB-EAC';
    PRINT 'Updated: CFC-FEB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FEB-EAC', 'FC Eggless Birthday Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FEB-EAC';
END
GO

-- CFC-FEG-EAC - FC Eggless Vanilla Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Eggless Vanilla Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FEG-EAC';
    PRINT 'Updated: CFC-FEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FEG-EAC', 'FC Eggless Vanilla Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FEG-EAC';
END
GO

-- CFC-FES-EAC - FC Eggless Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FES-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Eggless Slice',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FES-EAC';
    PRINT 'Updated: CFC-FES-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FES-EAC', 'FC Eggless Slice', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FES-EAC';
END
GO

-- CFC-FOS-EAC - Freshcream Oreo Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FOS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Freshcream Oreo Slice',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FOS-EAC';
    PRINT 'Updated: CFC-FOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FOS-EAC', 'Freshcream Oreo Slice', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FOS-EAC';
END
GO

-- CFC-FRL-EAC - FC Lamington Raspberry
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Lamington Raspberry',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRL-EAC';
    PRINT 'Updated: CFC-FRL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRL-EAC', 'FC Lamington Raspberry', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRL-EAC';
END
GO

-- CFC-FSM-EAC - Mini Freshcream Swissroll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FSM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Freshcream Swissroll',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FSM-EAC';
    PRINT 'Updated: CFC-FSM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FSM-EAC', 'Mini Freshcream Swissroll', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FSM-EAC';
END
GO

-- CFC-FSS-EAC - FC Strawberry Sponge
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FSS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'FC Strawberry Sponge',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FSS-EAC';
    PRINT 'Updated: CFC-FSS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FSS-EAC', 'FC Strawberry Sponge', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FSS-EAC';
END
GO

-- CFC-MEG-EAC - Mothers Day Eggless Freshcream Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mothers Day Eggless Freshcream Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MEG-EAC';
    PRINT 'Updated: CFC-MEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MEG-EAC', 'Mothers Day Eggless Freshcream Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MEG-EAC';
END
GO

-- CFC-MFD-EAC - Mini FC D/N
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MFD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini FC D/N',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MFD-EAC';
    PRINT 'Updated: CFC-MFD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MFD-EAC', 'Mini FC D/N', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MFD-EAC';
END
GO

-- CFC-MFE-EAC - Mini Freshcream Eclairs
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MFE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Freshcream Eclairs',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MFE-EAC';
    PRINT 'Updated: CFC-MFE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MFE-EAC', 'Mini Freshcream Eclairs', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MFE-EAC';
END
GO

-- CFC-MFG-EAC - Mothers Day FC Choc Gateaux with rose and leaves
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MFG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mothers Day FC Choc Gateaux with rose and leaves',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MFG-EAC';
    PRINT 'Updated: CFC-MFG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MFG-EAC', 'Mothers Day FC Choc Gateaux with rose and leaves', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MFG-EAC';
END
GO

-- CFC-MMT-EAC - Mini Milk Tart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MMT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Milk Tart',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MMT-EAC';
    PRINT 'Updated: CFC-MMT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MMT-EAC', 'Mini Milk Tart', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MMT-EAC';
END
GO

-- CFC-MTA-EAC - Milk Tart Large
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MTA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Milk Tart Large',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MTA-EAC';
    PRINT 'Updated: CFC-MTA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MTA-EAC', 'Milk Tart Large', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MTA-EAC';
END
GO

-- CFC-MTL-EAC - Milk Tartlet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-MTL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Milk Tartlet',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-MTL-EAC';
    PRINT 'Updated: CFC-MTL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-MTL-EAC', 'Milk Tartlet', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-MTL-EAC';
END
GO

-- CFC-NOB-EAC - No Bake Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-NOB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'No Bake Cake',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-NOB-EAC';
    PRINT 'Updated: CFC-NOB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-NOB-EAC', 'No Bake Cake', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-NOB-EAC';
END
GO

-- CFC-SEF-EAC - Eggless Small Freshcream Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fresh Cream';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'freshcream cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-SEF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Eggless Small Freshcream Gateaux',
        Category = 'Fresh Cream',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-SEF-EAC';
    PRINT 'Updated: CFC-SEF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-SEF-EAC', 'Eggless Small Freshcream Gateaux', 'Fresh Cream', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-SEF-EAC';
END
GO

-- CFC-FRU-010 - BD Fruit Cake 10
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-010')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Fruit Cake 10',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRU-010';
    PRINT 'Updated: CFC-FRU-010';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRU-010', 'BD Fruit Cake 10', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRU-010';
END
GO

-- CFC-FRU-012 - BDFruit Cake 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BDFruit Cake 12',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRU-012';
    PRINT 'Updated: CFC-FRU-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRU-012', 'BDFruit Cake 12', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRU-012';
END
GO

-- CFC-FRU-014 - BD Fruit Cake 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Fruit Cake 14',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRU-014';
    PRINT 'Updated: CFC-FRU-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRU-014', 'BD Fruit Cake 14', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRU-014';
END
GO

-- CFC-FRU-016 - BD Fruit Cake 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Fruit Cake 16',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRU-016';
    PRINT 'Updated: CFC-FRU-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRU-016', 'BD Fruit Cake 16', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRU-016';
END
GO

-- CFC-FRU-EAU - Fruit Cake Pieces Unwrapped
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-EAU')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fruit Cake Pieces Unwrapped',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRU-EAU';
    PRINT 'Updated: CFC-FRU-EAU';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRU-EAU', 'Fruit Cake Pieces Unwrapped', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRU-EAU';
END
GO

-- CFC-FRU-EAW - Fruit Cake Pieces Wrapped
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFC-FRU-EAW')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fruit Cake Pieces Wrapped',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFC-FRU-EAW';
    PRINT 'Updated: CFC-FRU-EAW';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFC-FRU-EAW', 'Fruit Cake Pieces Wrapped', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFC-FRU-EAW';
END
GO

-- CFR-CFR-012 - BD Round Fruitcake 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Round Fruitcake 12',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFR-CFR-012';
    PRINT 'Updated: CFR-CFR-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFR-CFR-012', 'BD Round Fruitcake 12', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFR-CFR-012';
END
GO

-- CFR-CFR-012 - BD Round Fruitcake 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Round Fruitcake 12',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFR-CFR-012';
    PRINT 'Updated: CFR-CFR-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFR-CFR-012', 'BD Round Fruitcake 12', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFR-CFR-012';
END
GO

-- CFR-CFR-014 - BD Round Fruitcake 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Round Fruitcake 14',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFR-CFR-014';
    PRINT 'Updated: CFR-CFR-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFR-CFR-014', 'BD Round Fruitcake 14', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFR-CFR-014';
END
GO

-- CFR-CFR-016 - BD Round Fruitcake 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Round Fruitcake 16',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFR-CFR-016';
    PRINT 'Updated: CFR-CFR-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFR-CFR-016', 'BD Round Fruitcake 16', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFR-CFR-016';
END
GO

-- CFR-CFR-016 - BD Round Fruitcake 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Fruitcake';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'fruit cake' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFR-CFR-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Round Fruitcake 16',
        Category = 'Fruitcake',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFR-CFR-016';
    PRINT 'Updated: CFR-CFR-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFR-CFR-016', 'BD Round Fruitcake 16', 'Fruitcake', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFR-CFR-016';
END
GO

-- CEX-NUT-12 - 12'''' Nibbed Nuts Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NUT-12')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '12'''' Nibbed Nuts Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NUT-12';
    PRINT 'Updated: CEX-NUT-12';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NUT-12', '12'''' Nibbed Nuts Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NUT-12';
END
GO

-- CEX-NUT-14 - 14'''' Nibbed Nuts Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NUT-14')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '14'''' Nibbed Nuts Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NUT-14';
    PRINT 'Updated: CEX-NUT-14';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NUT-14', '14'''' Nibbed Nuts Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NUT-14';
END
GO

-- CEX-NUT-16 - 16'''' Nibbed Nuts Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NUT-16')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '16'''' Nibbed Nuts Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NUT-16';
    PRINT 'Updated: CEX-NUT-16';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NUT-16', '16'''' Nibbed Nuts Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NUT-16';
END
GO

-- CEX-NUT-20 - 20'''' Nibbed Nuts Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NUT-20')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20'''' Nibbed Nuts Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NUT-20';
    PRINT 'Updated: CEX-NUT-20';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NUT-20', '20'''' Nibbed Nuts Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NUT-20';
END
GO

-- CEX-NUT-22 - 22'''' Nibbed Nuts Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-NUT-22')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '22'''' Nibbed Nuts Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-NUT-22';
    PRINT 'Updated: CEX-NUT-22';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-NUT-22', '22'''' Nibbed Nuts Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-NUT-22';
END
GO

-- CEX-PEA-12 - 12'''' Peaches Slices Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PEA-12')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '12'''' Peaches Slices Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PEA-12';
    PRINT 'Updated: CEX-PEA-12';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PEA-12', '12'''' Peaches Slices Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PEA-12';
END
GO

-- CEX-PEA-14 - 14'''' Peaches Slices Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PEA-14')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '14'''' Peaches Slices Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PEA-14';
    PRINT 'Updated: CEX-PEA-14';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PEA-14', '14'''' Peaches Slices Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PEA-14';
END
GO

-- CEX-PEA-16 - 16'''' Peaches Slices Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PEA-16')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '16'''' Peaches Slices Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PEA-16';
    PRINT 'Updated: CEX-PEA-16';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PEA-16', '16'''' Peaches Slices Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PEA-16';
END
GO

-- CEX-PEA-18 - 18'''' Peaches Slices Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PEA-18')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '18'''' Peaches Slices Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PEA-18';
    PRINT 'Updated: CEX-PEA-18';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PEA-18', '18'''' Peaches Slices Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PEA-18';
END
GO

-- CEX-PEA-20 - 20'''' Peaches Slices Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PEA-20')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20'''' Peaches Slices Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PEA-20';
    PRINT 'Updated: CEX-PEA-20';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PEA-20', '20'''' Peaches Slices Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PEA-20';
END
GO

-- CEX-PEA-22 - 22'''' Peaches Slices Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-PEA-22')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '22'''' Peaches Slices Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-PEA-22';
    PRINT 'Updated: CEX-PEA-22';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-PEA-22', '22'''' Peaches Slices Only', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-PEA-22';
END
GO

-- MIS - CCB-12 - Colour Cream - 12''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS - CCB-12')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Colour Cream - 12''''',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS - CCB-12';
    PRINT 'Updated: MIS - CCB-12';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS - CCB-12', 'Colour Cream - 12''''', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS - CCB-12';
END
GO

-- MIS - SCB-KGR - Solid Colour Buttercream
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS - SCB-KGR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Solid Colour Buttercream',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS - SCB-KGR';
    PRINT 'Updated: MIS - SCB-KGR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS - SCB-KGR', 'Solid Colour Buttercream', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS - SCB-KGR';
END
GO

-- MIS- CCB-14 - Colour Cream - 14''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS- CCB-14')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Colour Cream - 14''''',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS- CCB-14';
    PRINT 'Updated: MIS- CCB-14';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS- CCB-14', 'Colour Cream - 14''''', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS- CCB-14';
END
GO

-- MIS- FIT-EAC - Happy Anniversary Cake Topper
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS- FIT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Happy Anniversary Cake Topper',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS- FIT-EAC';
    PRINT 'Updated: MIS- FIT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS- FIT-EAC', 'Happy Anniversary Cake Topper', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS- FIT-EAC';
END
GO

-- MIS- FON-EAC - Fondant Writing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS- FON-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fondant Writing',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS- FON-EAC';
    PRINT 'Updated: MIS- FON-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS- FON-EAC', 'Fondant Writing', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS- FON-EAC';
END
GO

-- MIS-ACC-EAC - Plastic Icing Baby Accessory Set
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-ACC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Plastic Icing Baby Accessory Set',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-ACC-EAC';
    PRINT 'Updated: MIS-ACC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-ACC-EAC', 'Plastic Icing Baby Accessory Set', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-ACC-EAC';
END
GO

-- MIS-AES-EACH - Additional Espresso Shot
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-AES-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Additional Espresso Shot',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-AES-EACH';
    PRINT 'Updated: MIS-AES-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-AES-EACH', 'Additional Espresso Shot', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-AES-EACH';
END
GO

-- MIS-BAB-EAC - Plastic icing Baby with blanket
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-BAB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Plastic icing Baby with blanket',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-BAB-EAC';
    PRINT 'Updated: MIS-BAB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-BAB-EAC', 'Plastic icing Baby with blanket', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-BAB-EAC';
END
GO

-- MIS-BGM-EAC - Bride & Groom Meduim
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-BGM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bride & Groom Meduim',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-BGM-EAC';
    PRINT 'Updated: MIS-BGM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-BGM-EAC', 'Bride & Groom Meduim', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-BGM-EAC';
END
GO

-- MIS-BGS-EAC - Bride & Groom Small
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-BGS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bride & Groom Small',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-BGS-EAC';
    PRINT 'Updated: MIS-BGS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-BGS-EAC', 'Bride & Groom Small', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-BGS-EAC';
END
GO

-- MIS-BMV-EAC - Mvutu Bar One
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-BMV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mvutu Bar One',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-BMV-EAC';
    PRINT 'Updated: MIS-BMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-BMV-EAC', 'Mvutu Bar One', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-BMV-EAC';
END
GO

-- MIS-BOO-EAC - Plastic icing Booties
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-BOO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Plastic icing Booties',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-BOO-EAC';
    PRINT 'Updated: MIS-BOO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-BOO-EAC', 'Plastic icing Booties', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-BOO-EAC';
END
GO

-- MIS-BRP-EAC - Big Roses With Polysterene
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-BRP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Big Roses With Polysterene',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-BRP-EAC';
    PRINT 'Updated: MIS-BRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-BRP-EAC', 'Big Roses With Polysterene', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-BRP-EAC';
END
GO

-- MIS-CAN-EAC - Cancellation
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CAN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cancellation',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CAN-EAC';
    PRINT 'Updated: MIS-CAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CAN-EAC', 'Cancellation', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CAN-EAC';
END
GO

-- MIS-CAT-EAC - Cake Toppers Acyrlic
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CAT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cake Toppers Acyrlic',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-CAT-EAC';
    PRINT 'Updated: MIS-CAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CAT-EAC', 'Cake Toppers Acyrlic', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-CAT-EAC';
END
GO

-- MIS-CBC-BDC - Chocolate Buttercream -Birthday Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CBC-BDC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Buttercream -Birthday Cake',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CBC-BDC';
    PRINT 'Updated: MIS-CBC-BDC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CBC-BDC', 'Chocolate Buttercream -Birthday Cake', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CBC-BDC';
END
GO

-- MIS-CCB-16 - Colour Cream - 16''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CCB-16')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Colour Cream - 16''''',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CCB-16';
    PRINT 'Updated: MIS-CCB-16';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CCB-16', 'Colour Cream - 16''''', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CCB-16';
END
GO

-- MIS-CCB-18 - Colour Cream - 18''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CCB-18')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Colour Cream - 18''''',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CCB-18';
    PRINT 'Updated: MIS-CCB-18';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CCB-18', 'Colour Cream - 18''''', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CCB-18';
END
GO

-- MIS-CCB-20 - Colour Cream - 20''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CCB-20')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Colour Cream - 20''''',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CCB-20';
    PRINT 'Updated: MIS-CCB-20';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CCB-20', 'Colour Cream - 20''''', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CCB-20';
END
GO

-- MIS-CCB-22 - Colour Cream - 22''''
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CCB-22')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Colour Cream - 22''''',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CCB-22';
    PRINT 'Updated: MIS-CCB-22';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CCB-22', 'Colour Cream - 22''''', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CCB-22';
END
GO

-- MIS-CHA-EAC - Service Charge for Changes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CHA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Service Charge for Changes',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CHA-EAC';
    PRINT 'Updated: MIS-CHA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CHA-EAC', 'Service Charge for Changes', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CHA-EAC';
END
GO

-- MIS-CHT-EAC - Figure Cake Topper
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CHT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Figure Cake Topper',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-CHT-EAC';
    PRINT 'Updated: MIS-CHT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CHT-EAC', 'Figure Cake Topper', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-CHT-EAC';
END
GO

-- MIS-CHW-EAC - Choc Writing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CHW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Choc Writing',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CHW-EAC';
    PRINT 'Updated: MIS-CHW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CHW-EAC', 'Choc Writing', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CHW-EAC';
END
GO

-- MIS-CUP-EAC - Foam Cups 250ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CUP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Foam Cups 250ml',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-CUP-EAC';
    PRINT 'Updated: MIS-CUP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CUP-EAC', 'Foam Cups 250ml', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-CUP-EAC';
END
GO

-- MIS-CWR-EAC - Customised Writing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CWR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Customised Writing',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-CWR-EAC';
    PRINT 'Updated: MIS-CWR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CWR-EAC', 'Customised Writing', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-CWR-EAC';
END
GO

-- MIS-DAO-EAC - Day Old Cakes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DAO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Day Old Cakes',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DAO-EAC';
    PRINT 'Updated: MIS-DAO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DAO-EAC', 'Day Old Cakes', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DAO-EAC';
END
GO

-- MIS-DBC-012 - Dbl Choc 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Choc 12',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBC-012';
    PRINT 'Updated: MIS-DBC-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBC-012', 'Dbl Choc 12', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBC-012';
END
GO

-- MIS-DBC-014 - Dbl Choc 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Choc 14',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBC-014';
    PRINT 'Updated: MIS-DBC-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBC-014', 'Dbl Choc 14', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBC-014';
END
GO

-- MIS-DBC-016 - Dbl Choc 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Choc 16',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBC-016';
    PRINT 'Updated: MIS-DBC-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBC-016', 'Dbl Choc 16', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBC-016';
END
GO

-- MIS-DBC-018 - Dbl Choc 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Choc 18',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBC-018';
    PRINT 'Updated: MIS-DBC-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBC-018', 'Dbl Choc 18', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBC-018';
END
GO

-- MIS-DBC-020 - Dbl Choc 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBC-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Choc 20',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBC-020';
    PRINT 'Updated: MIS-DBC-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBC-020', 'Dbl Choc 20', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBC-020';
END
GO

-- MIS-DBV-012 - Dbl Vanilla 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Vanilla 12',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBV-012';
    PRINT 'Updated: MIS-DBV-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBV-012', 'Dbl Vanilla 12', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBV-012';
END
GO

-- MIS-DBV-014 - Dbl Vanilla 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Vanilla 14',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBV-014';
    PRINT 'Updated: MIS-DBV-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBV-014', 'Dbl Vanilla 14', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBV-014';
END
GO

-- MIS-DBV-016 - Dbl Vanilla 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Vanilla 16',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBV-016';
    PRINT 'Updated: MIS-DBV-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBV-016', 'Dbl Vanilla 16', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBV-016';
END
GO

-- MIS-DBV-018 - Dbl Vanilla 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Vanilla 18',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBV-018';
    PRINT 'Updated: MIS-DBV-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBV-018', 'Dbl Vanilla 18', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBV-018';
END
GO

-- MIS-DBV-020 - Dbl Vanilla 20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Vanilla 20',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBV-020';
    PRINT 'Updated: MIS-DBV-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBV-020', 'Dbl Vanilla 20', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBV-020';
END
GO

-- MIS-DBV-022 - Dbl Vanilla 22
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DBV-022')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dbl Vanilla 22',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DBV-022';
    PRINT 'Updated: MIS-DBV-022';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DBV-022', 'Dbl Vanilla 22', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DBV-022';
END
GO

-- MIS-DEL-EAC - Delivery
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DEL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Delivery',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DEL-EAC';
    PRINT 'Updated: MIS-DEL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DEL-EAC', 'Delivery', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DEL-EAC';
END
GO

-- MIS-DMV-EACH - Mvutu Donut 4s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DMV-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mvutu Donut 4s',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DMV-EACH';
    PRINT 'Updated: MIS-DMV-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DMV-EACH', 'Mvutu Donut 4s', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DMV-EACH';
END
GO

-- MIS-DOS-EAC - Day Old Scones
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-DOS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Day Old Scones',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'MIS-DOS-EAC';
    PRINT 'Updated: MIS-DOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-DOS-EAC', 'Day Old Scones', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: MIS-DOS-EAC';
END
GO

-- MIS-EPO-EAC - Edible Picture Only
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-EPO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Edible Picture Only',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-EPO-EAC';
    PRINT 'Updated: MIS-EPO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-EPO-EAC', 'Edible Picture Only', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-EPO-EAC';
END
GO

-- MIS-FCB-EAC - Balloons -Foil Character
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FCB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons -Foil Character',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FCB-EAC';
    PRINT 'Updated: MIS-FCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FCB-EAC', 'Balloons -Foil Character', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FCB-EAC';
END
GO

-- MIS-FFL-EAC - Fresh Flowers Each
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FFL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fresh Flowers Each',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FFL-EAC';
    PRINT 'Updated: MIS-FFL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FFL-EAC', 'Fresh Flowers Each', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FFL-EAC';
END
GO

-- MIS-FGB-EAC - Balloons-Foil General
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FGB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons-Foil General',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FGB-EAC';
    PRINT 'Updated: MIS-FGB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FGB-EAC', 'Balloons-Foil General', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FGB-EAC';
END
GO

-- MIS-FMG-EAC - Balloons- Foil Number Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FMG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons- Foil Number Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FMG-EAC';
    PRINT 'Updated: MIS-FMG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FMG-EAC', 'Balloons- Foil Number Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FMG-EAC';
END
GO

-- MIS-FNG-EAC - Balloons- Foil Number Rose Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FNG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons- Foil Number Rose Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FNG-EAC';
    PRINT 'Updated: MIS-FNG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FNG-EAC', 'Balloons- Foil Number Rose Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FNG-EAC';
END
GO

-- MIS-FNR-EAC - Balloons-Foil Number Rainbow Splash
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FNR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons-Foil Number Rainbow Splash',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FNR-EAC';
    PRINT 'Updated: MIS-FNR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FNR-EAC', 'Balloons-Foil Number Rainbow Splash', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FNR-EAC';
END
GO

-- MIS-FNS-EAC - Balloons- Foil Number Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FNS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons- Foil Number Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FNS-EAC';
    PRINT 'Updated: MIS-FNS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FNS-EAC', 'Balloons- Foil Number Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FNS-EAC';
END
GO

-- MIS-FWO-EACH - Fondant Wording
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-FWO-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fondant Wording',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-FWO-EACH';
    PRINT 'Updated: MIS-FWO-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-FWO-EACH', 'Fondant Wording', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-FWO-EACH';
END
GO

-- MIS-GBE-EAC - Gold Beads
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-GBE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Gold Beads',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-GBE-EAC';
    PRINT 'Updated: MIS-GBE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-GBE-EAC', 'Gold Beads', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-GBE-EAC';
END
GO

-- MIS-GWR-EAC - Gold Writing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-GWR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Gold Writing',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-GWR-EAC';
    PRINT 'Updated: MIS-GWR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-GWR-EAC', 'Gold Writing', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-GWR-EAC';
END
GO

-- MIS-HBT-EAC - Happy Birthday Cake Topper
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-HBT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Happy Birthday Cake Topper',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-HBT-EAC';
    PRINT 'Updated: MIS-HBT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-HBT-EAC', 'Happy Birthday Cake Topper', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-HBT-EAC';
END
GO

-- MIS-HEL-LAR - Heluim Large
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-HEL-LAR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Heluim Large',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-HEL-LAR';
    PRINT 'Updated: MIS-HEL-LAR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-HEL-LAR', 'Heluim Large', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-HEL-LAR';
END
GO

-- MIS-HEL-SML - Heluim Small
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-HEL-SML')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Heluim Small',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-HEL-SML';
    PRINT 'Updated: MIS-HEL-SML';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-HEL-SML', 'Heluim Small', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-HEL-SML';
END
GO

-- MIS-LEA-EAC - Leaves
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-LEA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Leaves',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-LEA-EAC';
    PRINT 'Updated: MIS-LEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-LEA-EAC', 'Leaves', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-LEA-EAC';
END
GO

-- MIS-MGR-EAC - Rib Metallic Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-MGR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rib Metallic Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-MGR-EAC';
    PRINT 'Updated: MIS-MGR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-MGR-EAC', 'Rib Metallic Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-MGR-EAC';
END
GO

-- MIS-MSR-EAC - Rib Metallic Silver
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-MSR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rib Metallic Silver',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-MSR-EAC';
    PRINT 'Updated: MIS-MSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-MSR-EAC', 'Rib Metallic Silver', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-MSR-EAC';
END
GO

-- MIS-MVU-EAC - Mvutu
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-MVU-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mvutu',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-MVU-EAC';
    PRINT 'Updated: MIS-MVU-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-MVU-EAC', 'Mvutu', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-MVU-EAC';
END
GO

-- MIS-NOV-EAC - Novelities Sets
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-NOV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Novelities Sets',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-NOV-EAC';
    PRINT 'Updated: MIS-NOV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-NOV-EAC', 'Novelities Sets', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-NOV-EAC';
END
GO

-- MIS-PLD-EAC - Platter Dip 70ml
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-PLD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Dip 70ml',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-PLD-EAC';
    PRINT 'Updated: MIS-PLD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-PLD-EAC', 'Platter Dip 70ml', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-PLD-EAC';
END
GO

-- MIS-RAS-EACH - Rakhi String
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-RAS-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rakhi String',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-RAS-EACH';
    PRINT 'Updated: MIS-RAS-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-RAS-EACH', 'Rakhi String', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-RAS-EACH';
END
GO

-- MIS-RMV-EAC - Mvutu Rainbow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-RMV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mvutu Rainbow',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-RMV-EAC';
    PRINT 'Updated: MIS-RMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-RMV-EAC', 'Mvutu Rainbow', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-RMV-EAC';
END
GO

-- MIS-ROS-EAC - Roses
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-ROS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Roses',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-ROS-EAC';
    PRINT 'Updated: MIS-ROS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-ROS-EAC', 'Roses', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-ROS-EAC';
END
GO

-- MIS-RSS-EAC - Roses Small New Assorted Colours
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-RSS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Roses Small New Assorted Colours',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-RSS-EAC';
    PRINT 'Updated: MIS-RSS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-RSS-EAC', 'Roses Small New Assorted Colours', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-RSS-EAC';
END
GO

-- MIS-SBE-EAC - Silver Beads
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-SBE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Silver Beads',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-SBE-EAC';
    PRINT 'Updated: MIS-SBE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-SBE-EAC', 'Silver Beads', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-SBE-EAC';
END
GO

-- MIS-SCB-EAC - Balloons- Stick Character
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-SCB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons- Stick Character',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-SCB-EAC';
    PRINT 'Updated: MIS-SCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-SCB-EAC', 'Balloons- Stick Character', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-SCB-EAC';
END
GO

-- MIS-SDC-EAC - Same Day Charge
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-SDC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Same Day Charge',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-SDC-EAC';
    PRINT 'Updated: MIS-SDC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-SDC-EAC', 'Same Day Charge', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-SDC-EAC';
END
GO

-- MIS-SFB-EAC - Sign Happy Birthday Gold Foil
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-SFB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sign Happy Birthday Gold Foil',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-SFB-EAC';
    PRINT 'Updated: MIS-SFB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-SFB-EAC', 'Sign Happy Birthday Gold Foil', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-SFB-EAC';
END
GO

-- MIS-SGA-EAC - Sign H.A. Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-SGA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sign H.A. Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-SGA-EAC';
    PRINT 'Updated: MIS-SGA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-SGA-EAC', 'Sign H.A. Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-SGA-EAC';
END
GO

-- MIS-SGB-EAC - Sign H.B. Gold
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-SGB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sign H.B. Gold',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-SGB-EAC';
    PRINT 'Updated: MIS-SGB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-SGB-EAC', 'Sign H.B. Gold', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-SGB-EAC';
END
GO

-- MIS-STG-EAC - Balloons-Stick General
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-STG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Balloons-Stick General',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-STG-EAC';
    PRINT 'Updated: MIS-STG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-STG-EAC', 'Balloons-Stick General', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-STG-EAC';
END
GO

-- MIS-STR-EAC - Strawberry
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-STR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-STR-EAC';
    PRINT 'Updated: MIS-STR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-STR-EAC', 'Strawberry', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-STR-EAC';
END
GO

-- MIS-SWR-EAC - Silver Writing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-SWR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Silver Writing',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-SWR-EAC';
    PRINT 'Updated: MIS-SWR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-SWR-EAC', 'Silver Writing', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-SWR-EAC';
END
GO

-- MIS-WHC-EAC - Additional Whipped Cream
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-WHC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Additional Whipped Cream',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-WHC-EAC';
    PRINT 'Updated: MIS-WHC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-WHC-EAC', 'Additional Whipped Cream', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: MIS-WHC-EAC';
END
GO

-- SRC-CHO-CRE - Choc Cream -20 Fig On Base
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRC-CHO-CRE')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Choc Cream -20 Fig On Base',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRC-CHO-CRE';
    PRINT 'Updated: SRC-CHO-CRE';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRC-CHO-CRE', 'Choc Cream -20 Fig On Base', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRC-CHO-CRE';
END
GO

-- SRN-CML-016 - Caramel Spread only - on 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-CML-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Caramel Spread only - on 16',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-CML-016';
    PRINT 'Updated: SRN-CML-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-CML-016', 'Caramel Spread only - on 16', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-CML-016';
END
GO

-- SRN-CRM-016 - Cream colour cream only - 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-CRM-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cream colour cream only - 16',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-CRM-016';
    PRINT 'Updated: SRN-CRM-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-CRM-016', 'Cream colour cream only - 16', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-CRM-016';
END
GO

-- SRN-JAM-012 - Strawberry Jam only - 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-JAM-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Jam only - 12',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-JAM-012';
    PRINT 'Updated: SRN-JAM-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-JAM-012', 'Strawberry Jam only - 12', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-JAM-012';
END
GO

-- SRN-JAM-012 - Strawberry Jam only - 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-JAM-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Jam only - 12',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-JAM-012';
    PRINT 'Updated: SRN-JAM-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-JAM-012', 'Strawberry Jam only - 12', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-JAM-012';
END
GO

-- SRN-JAM-014 - Strawberry Jam only - 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-JAM-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Jam only - 14',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-JAM-014';
    PRINT 'Updated: SRN-JAM-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-JAM-014', 'Strawberry Jam only - 14', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-JAM-014';
END
GO

-- SRN-JAM-014 - Strawberry Jam only - 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-JAM-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Jam only - 14',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-JAM-014';
    PRINT 'Updated: SRN-JAM-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-JAM-014', 'Strawberry Jam only - 14', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-JAM-014';
END
GO

-- SRN-JAM-016 - Strawberry Jam only - 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-JAM-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Jam only - 16',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-JAM-016';
    PRINT 'Updated: SRN-JAM-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-JAM-016', 'Strawberry Jam only - 16', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-JAM-016';
END
GO

-- SRN-JAM-18 - Strawberry Jam Only-18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-JAM-18')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Jam Only-18',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-JAM-18';
    PRINT 'Updated: SRN-JAM-18';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-JAM-18', 'Strawberry Jam Only-18', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-JAM-18';
END
GO

-- SRN-JAM-20 - Strawberry Jam Only-20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-JAM-20')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Jam Only-20',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-JAM-20';
    PRINT 'Updated: SRN-JAM-20';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-JAM-20', 'Strawberry Jam Only-20', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-JAM-20';
END
GO

-- SRN-PAI-EAC - Painting on Roses
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PAI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Painting on Roses',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PAI-EAC';
    PRINT 'Updated: SRN-PAI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PAI-EAC', 'Painting on Roses', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PAI-EAC';
END
GO

-- SRN-PEA-014 - Peach Slices Only 14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PEA-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Peach Slices Only 14',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PEA-014';
    PRINT 'Updated: SRN-PEA-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PEA-014', 'Peach Slices Only 14', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PEA-014';
END
GO

-- SRN-PLI-012 - Plastic Icing Covering Only 12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PLI-012')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Plastic Icing Covering Only 12',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PLI-012';
    PRINT 'Updated: SRN-PLI-012';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PLI-012', 'Plastic Icing Covering Only 12', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PLI-012';
END
GO

-- SRN-PLI-016 - Plastic Icing Covering Only 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PLI-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Plastic Icing Covering Only 16',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PLI-016';
    PRINT 'Updated: SRN-PLI-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PLI-016', 'Plastic Icing Covering Only 16', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PLI-016';
END
GO

-- SRN-PLI-016 - Plastic Icing Covering Only 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PLI-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Plastic Icing Covering Only 16',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PLI-016';
    PRINT 'Updated: SRN-PLI-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PLI-016', 'Plastic Icing Covering Only 16', 'miscellaneous', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PLI-016';
END
GO

-- XDE-AST-EAC - Astd roses
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'XDE-AST-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Astd roses',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'XDE-AST-EAC';
    PRINT 'Updated: XDE-AST-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('XDE-AST-EAC', 'Astd roses', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: XDE-AST-EAC';
END
GO

-- XDE-SIL-KGR - Silver Beads Per Kg
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'XDE-SIL-KGR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Silver Beads Per Kg',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'XDE-SIL-KGR';
    PRINT 'Updated: XDE-SIL-KGR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('XDE-SIL-KGR', 'Silver Beads Per Kg', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: XDE-SIL-KGR';
END
GO

-- XDE-TEA-EAC - Ribbon tear 1 Roll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'XDE-TEA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Ribbon tear 1 Roll',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'XDE-TEA-EAC';
    PRINT 'Updated: XDE-TEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('XDE-TEA-EAC', 'Ribbon tear 1 Roll', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: XDE-TEA-EAC';
END
GO

-- YCC-CHA-EAC - Champagne Bottle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-CHA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Champagne Bottle',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YCC-CHA-EAC';
    PRINT 'Updated: YCC-CHA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-CHA-EAC', 'Champagne Bottle', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YCC-CHA-EAC';
END
GO

-- YCC-LEA-EAC - Leaves No.Large
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-LEA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Leaves No.Large',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YCC-LEA-EAC';
    PRINT 'Updated: YCC-LEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-LEA-EAC', 'Leaves No.Large', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YCC-LEA-EAC';
END
GO

-- YCC-MIS-EAC - Mistletoe Garland ribbon
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-MIS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mistletoe Garland ribbon',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YCC-MIS-EAC';
    PRINT 'Updated: YCC-MIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-MIS-EAC', 'Mistletoe Garland ribbon', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YCC-MIS-EAC';
END
GO

-- YCC-OCC-KGR - Old Cakes Currant Square
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-OCC-KGR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Old Cakes Currant Square',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YCC-OCC-KGR';
    PRINT 'Updated: YCC-OCC-KGR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-OCC-KGR', 'Old Cakes Currant Square', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YCC-OCC-KGR';
END
GO

-- YCC-PIL-EAC - Pillars White
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-PIL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pillars White',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YCC-PIL-EAC';
    PRINT 'Updated: YCC-PIL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-PIL-EAC', 'Pillars White', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YCC-PIL-EAC';
END
GO

-- YCC-SOS-EAC - Soccer Set
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-SOS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Soccer Set',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YCC-SOS-EAC';
    PRINT 'Updated: YCC-SOS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-SOS-EAC', 'Soccer Set', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YCC-SOS-EAC';
END
GO

-- YCC-XPS-EAC - Xmas Poinsettia Star Ribbon
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YCC-XPS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Xmas Poinsettia Star Ribbon',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YCC-XPS-EAC';
    PRINT 'Updated: YCC-XPS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YCC-XPS-EAC', 'Xmas Poinsettia Star Ribbon', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YCC-XPS-EAC';
END
GO

-- YGA-AFS-EAC - Air Filled Stand 1550x500
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'miscellaneous';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'miscellaneous' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'YGA-AFS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Air Filled Stand 1550x500',
        Category = 'miscellaneous',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'YGA-AFS-EAC';
    PRINT 'Updated: YGA-AFS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('YGA-AFS-EAC', 'Air Filled Stand 1550x500', 'miscellaneous', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: YGA-AFS-EAC';
END
GO

-- CBA-BAC-014 - BD 14'''' Buttercream Alphabet Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBA-BAC-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 14'''' Buttercream Alphabet Cake',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBA-BAC-014';
    PRINT 'Updated: CBA-BAC-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBA-BAC-014', 'BD 14'''' Buttercream Alphabet Cake', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBA-BAC-014';
END
GO

-- CBA-BEA-016 - BD 16'''' Eggless Buttercream Alphabet Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBA-BEA-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16'''' Eggless Buttercream Alphabet Cake',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBA-BEA-016';
    PRINT 'Updated: CBA-BEA-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBA-BEA-016', 'BD 16'''' Eggless Buttercream Alphabet Cake', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBA-BEA-016';
END
GO

-- CBF-BCK-020 - BD Buttercream Key
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-BCK-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream Key',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-BCK-020';
    PRINT 'Updated: CBF-BCK-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-BCK-020', 'BD Buttercream Key', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-BCK-020';
END
GO

-- CBF-FCK-020 - BD Freshcream Key
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBF-FCK-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream Key',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBF-FCK-020';
    PRINT 'Updated: CBF-FCK-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBF-FCK-020', 'BD Freshcream Key', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBF-FCK-020';
END
GO

-- CBN-B1M-EACH - BD Buttercream 1MX1M
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBN-B1M-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 1MX1M',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBN-B1M-EACH';
    PRINT 'Updated: CBN-B1M-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBN-B1M-EACH', 'BD Buttercream 1MX1M', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBN-B1M-EACH';
END
GO

-- CBN-F1M-EACH - BD Freshcream 1M X1M
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBN-F1M-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 1M X1M',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBN-F1M-EACH';
    PRINT 'Updated: CBN-F1M-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBN-F1M-EACH', 'BD Freshcream 1M X1M', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBN-F1M-EACH';
END
GO

-- CEX- LFD-EACH - 20cmBC4LayerDrip Cake- Fresh Flowers Macaroon/topp
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX- LFD-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20cmBC4LayerDrip Cake- Fresh Flowers Macaroon/topp',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX- LFD-EACH';
    PRINT 'Updated: CEX- LFD-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX- LFD-EACH', '20cmBC4LayerDrip Cake- Fresh Flowers Macaroon/topp', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX- LFD-EACH';
END
GO

-- CEX- RTR-12 - BC 12'''' Round Triple Layer Rose Pattern
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX- RTR-12')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC 12'''' Round Triple Layer Rose Pattern',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX- RTR-12';
    PRINT 'Updated: CEX- RTR-12';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX- RTR-12', 'BC 12'''' Round Triple Layer Rose Pattern', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX- RTR-12';
END
GO

-- CEX-RTR-14 - BC 14'''' Round Triple Layer Rose Pattern
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RTR-14')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC 14'''' Round Triple Layer Rose Pattern',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RTR-14';
    PRINT 'Updated: CEX-RTR-14';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RTR-14', 'BC 14'''' Round Triple Layer Rose Pattern', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RTR-14';
END
GO

-- CEX-RTR-16 - BC 16'''' Round Triple Layer Rose Pattern
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RTR-16')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC 16'''' Round Triple Layer Rose Pattern',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RTR-16';
    PRINT 'Updated: CEX-RTR-16';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RTR-16', 'BC 16'''' Round Triple Layer Rose Pattern', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RTR-16';
END
GO

-- CEX-RTR-18 - BC 18'''' Round Triple Layer Rose Pattern
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RTR-18')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC 18'''' Round Triple Layer Rose Pattern',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RTR-18';
    PRINT 'Updated: CEX-RTR-18';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RTR-18', 'BC 18'''' Round Triple Layer Rose Pattern', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RTR-18';
END
GO

-- CEX-RTR-20 - BC 20'''' Round Triple Layer Rose Pattern
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-RTR-20')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BC 20'''' Round Triple Layer Rose Pattern',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-RTR-20';
    PRINT 'Updated: CEX-RTR-20';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-RTR-20', 'BC 20'''' Round Triple Layer Rose Pattern', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-RTR-20';
END
GO

-- CFA-FAE-016 - BD 16'''' Eggless Freshcream Alphabet Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFA-FAE-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16'''' Eggless Freshcream Alphabet Cake',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFA-FAE-016';
    PRINT 'Updated: CFA-FAE-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFA-FAE-016', 'BD 16'''' Eggless Freshcream Alphabet Cake', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFA-FAE-016';
END
GO

-- CNO-BCB-016 - BD Buttercream 16 Bible
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCB-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 Bible',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCB-016';
    PRINT 'Updated: CNO-BCB-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCB-016', 'BD Buttercream 16 Bible', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCB-016';
END
GO

-- CNO-BCB-018 - BD Buttercream 18 Bible
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCB-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 18 Bible',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCB-018';
    PRINT 'Updated: CNO-BCB-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCB-018', 'BD Buttercream 18 Bible', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCB-018';
END
GO

-- CNO-BCB-020 - BD Buttercream 20 Bible
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCB-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 20 Bible',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCB-020';
    PRINT 'Updated: CNO-BCB-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCB-020', 'BD Buttercream 20 Bible', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCB-020';
END
GO

-- CNO-BCH-016 - BD Buttercream 16 Heart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCH-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 Heart',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCH-016';
    PRINT 'Updated: CNO-BCH-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCH-016', 'BD Buttercream 16 Heart', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCH-016';
END
GO

-- CNO-BCH-018 - BD Buttercream 18 Heart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCH-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 18 Heart',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCH-018';
    PRINT 'Updated: CNO-BCH-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCH-018', 'BD Buttercream 18 Heart', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCH-018';
END
GO

-- CNO-BCH-020 - BD Buttercream 20 Heart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCH-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 20 Heart',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCH-020';
    PRINT 'Updated: CNO-BCH-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCH-020', 'BD Buttercream 20 Heart', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCH-020';
END
GO

-- CNO-BCS-014 - BD Buttercream 14 Soccer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCS-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 14 Soccer',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCS-014';
    PRINT 'Updated: CNO-BCS-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCS-014', 'BD Buttercream 14 Soccer', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCS-014';
END
GO

-- CNO-BCS-014 - BD Buttercream 14 Soccer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCS-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 14 Soccer',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCS-014';
    PRINT 'Updated: CNO-BCS-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCS-014', 'BD Buttercream 14 Soccer', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCS-014';
END
GO

-- CNO-BCS-016 - BD Buttercream 16 Soccer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BCS-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 Soccer',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BCS-016';
    PRINT 'Updated: CNO-BCS-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BCS-016', 'BD Buttercream 16 Soccer', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BCS-016';
END
GO

-- CNO-BNY-018 - BD Mould On SL 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BNY-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Mould On SL 18',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BNY-018';
    PRINT 'Updated: CNO-BNY-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BNY-018', 'BD Mould On SL 18', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BNY-018';
END
GO

-- CNO-BNY-018 - BD Mould On SL 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BNY-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Mould On SL 18',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BNY-018';
    PRINT 'Updated: CNO-BNY-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BNY-018', 'BD Mould On SL 18', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BNY-018';
END
GO

-- CNO-BUT-014 - BD Buttercream 14 Butterfly
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BUT-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 14 Butterfly',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BUT-014';
    PRINT 'Updated: CNO-BUT-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BUT-014', 'BD Buttercream 14 Butterfly', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BUT-014';
END
GO

-- CNO-BUT-016 - BD Buttercream 16 Butterfly
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-BUT-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 Butterfly',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-BUT-016';
    PRINT 'Updated: CNO-BUT-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-BUT-016', 'BD Buttercream 16 Butterfly', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-BUT-016';
END
GO

-- CNO-CAS-018 - BD Castle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-CAS-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Castle',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-CAS-018';
    PRINT 'Updated: CNO-CAS-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-CAS-018', 'BD Castle', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-CAS-018';
END
GO

-- CNO-DHB-020 - BD Buttercream 20 Double Heart With Base
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-DHB-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 20 Double Heart With Base',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-DHB-020';
    PRINT 'Updated: CNO-DHB-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-DHB-020', 'BD Buttercream 20 Double Heart With Base', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-DHB-020';
END
GO

-- CNO-DOLL-014 - BD Buttercream 14 Doll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-DOLL-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 14 Doll',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-DOLL-014';
    PRINT 'Updated: CNO-DOLL-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-DOLL-014', 'BD Buttercream 14 Doll', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-DOLL-014';
END
GO

-- CNO-DOLL-016 - BD Buttercream 16 Doll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-DOLL-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 Doll',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-DOLL-016';
    PRINT 'Updated: CNO-DOLL-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-DOLL-016', 'BD Buttercream 16 Doll', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-DOLL-016';
END
GO

-- CNO-DOLL-016 - BD Buttercream 16 Doll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-DOLL-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 16 Doll',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-DOLL-016';
    PRINT 'Updated: CNO-DOLL-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-DOLL-016', 'BD Buttercream 16 Doll', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-DOLL-016';
END
GO

-- CNO-FCB-016 - BD 16 Freshcream BIBLE
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16 Freshcream BIBLE',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCB-016';
    PRINT 'Updated: CNO-FCB-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCB-016', 'BD 16 Freshcream BIBLE', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCB-016';
END
GO

-- CNO-FCB-016 - BD 16 Freshcream BIBLE
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16 Freshcream BIBLE',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCB-016';
    PRINT 'Updated: CNO-FCB-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCB-016', 'BD 16 Freshcream BIBLE', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCB-016';
END
GO

-- CNO-FCB-018 - BD Freshcream 18 Bible
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 18 Bible',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCB-018';
    PRINT 'Updated: CNO-FCB-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCB-018', 'BD Freshcream 18 Bible', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCB-018';
END
GO

-- CNO-FCB-018 - BD Freshcream 18 Bible
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 18 Bible',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCB-018';
    PRINT 'Updated: CNO-FCB-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCB-018', 'BD Freshcream 18 Bible', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCB-018';
END
GO

-- CNO-FCB-020 - BD Freshcream 20 Bible
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCB-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 20 Bible',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCB-020';
    PRINT 'Updated: CNO-FCB-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCB-020', 'BD Freshcream 20 Bible', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCB-020';
END
GO

-- CNO-FCH-016 - BD Freshcream 16 Heart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 16 Heart',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCH-016';
    PRINT 'Updated: CNO-FCH-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCH-016', 'BD Freshcream 16 Heart', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCH-016';
END
GO

-- CNO-FCH-016 - BD Freshcream 16 Heart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 16 Heart',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCH-016';
    PRINT 'Updated: CNO-FCH-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCH-016', 'BD Freshcream 16 Heart', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCH-016';
END
GO

-- CNO-FCH-018 - BD Freshcream 18 Heart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 18 Heart',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCH-018';
    PRINT 'Updated: CNO-FCH-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCH-018', 'BD Freshcream 18 Heart', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCH-018';
END
GO

-- CNO-FCH-020 - BD Freshcream 20 Heart
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCH-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 20 Heart',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCH-020';
    PRINT 'Updated: CNO-FCH-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCH-020', 'BD Freshcream 20 Heart', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCH-020';
END
GO

-- CNO-FCS-014 - BD Freshcream 14 Soccer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCS-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 14 Soccer',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCS-014';
    PRINT 'Updated: CNO-FCS-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCS-014', 'BD Freshcream 14 Soccer', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCS-014';
END
GO

-- CNO-FCS-016 - BD Freshcream 16 Soccer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FCS-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Freshcream 16 Soccer',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FCS-016';
    PRINT 'Updated: CNO-FCS-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FCS-016', 'BD Freshcream 16 Soccer', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FCS-016';
END
GO

-- CNO-FSF-014 - BD FC With Strawberries & Fence
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-FSF-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD FC With Strawberries & Fence',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-FSF-014';
    PRINT 'Updated: CNO-FSF-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-FSF-014', 'BD FC With Strawberries & Fence', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-FSF-014';
END
GO

-- CNO-SPI-018 - BD Spiderman On SL 18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CNO-SPI-018')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Spiderman On SL 18',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CNO-SPI-018';
    PRINT 'Updated: CNO-SPI-018';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CNO-SPI-018', 'BD Spiderman On SL 18', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CNO-SPI-018';
END
GO

-- SRN-AER-022 - Aeroplane Cake 22 in Plastic Icing and B/C
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-AER-022')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Aeroplane Cake 22 in Plastic Icing and B/C',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-AER-022';
    PRINT 'Updated: SRN-AER-022';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-AER-022', 'Aeroplane Cake 22 in Plastic Icing and B/C', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-AER-022';
END
GO

-- SRN-ANI-016 - 16 Buttercream Animal Farm
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-ANI-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '16 Buttercream Animal Farm',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-ANI-016';
    PRINT 'Updated: SRN-ANI-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-ANI-016', '16 Buttercream Animal Farm', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-ANI-016';
END
GO

-- SRN-BIB-016 - 16 Buttercream Eggless Bible Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BIB-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '16 Buttercream Eggless Bible Cake',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BIB-016';
    PRINT 'Updated: SRN-BIB-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BIB-016', '16 Buttercream Eggless Bible Cake', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BIB-016';
END
GO

-- SRN-BIB-020 - 20 Fresh Cream Egless Bible Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BIB-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20 Fresh Cream Egless Bible Cake',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BIB-020';
    PRINT 'Updated: SRN-BIB-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BIB-020', '20 Fresh Cream Egless Bible Cake', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BIB-020';
END
GO

-- SRN-BMW-014 - 14 Sponge in plastic icing with BMW sign
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BMW-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '14 Sponge in plastic icing with BMW sign',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BMW-014';
    PRINT 'Updated: SRN-BMW-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BMW-014', '14 Sponge in plastic icing with BMW sign', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BMW-014';
END
GO

-- SRN-BRE-016 - Buttercream Round Eggless with Baby
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BRE-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Buttercream Round Eggless with Baby',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BRE-016';
    PRINT 'Updated: SRN-BRE-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BRE-016', 'Buttercream Round Eggless with Baby', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BRE-016';
END
GO

-- SRN-BSC-016 - BD 16Buttercream with baby grower in PI
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BSC-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD 16Buttercream with baby grower in PI',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BSC-016';
    PRINT 'Updated: SRN-BSC-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BSC-016', 'BD 16Buttercream with baby grower in PI', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BSC-016';
END
GO

-- SRN-BYK-022 - 22 Motorbike on Base with Plastic icing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-BYK-022')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '22 Motorbike on Base with Plastic icing',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-BYK-022';
    PRINT 'Updated: SRN-BYK-022';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-BYK-022', '22 Motorbike on Base with Plastic icing', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-BYK-022';
END
GO

-- SRN-DAI-020 - 20 Buttercream with Piped Daisies
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-DAI-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20 Buttercream with Piped Daisies',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-DAI-020';
    PRINT 'Updated: SRN-DAI-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-DAI-020', '20 Buttercream with Piped Daisies', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-DAI-020';
END
GO

-- SRN-DBF-020 - 20 BC Double Base With Double Figure
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-DBF-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20 BC Double Base With Double Figure',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-DBF-020';
    PRINT 'Updated: SRN-DBF-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-DBF-020', '20 BC Double Base With Double Figure', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-DBF-020';
END
GO

-- SRN-DIA-020 - 20 Round PI Diamond pattern & Daisies
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-DIA-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20 Round PI Diamond pattern & Daisies',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-DIA-020';
    PRINT 'Updated: SRN-DIA-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-DIA-020', '20 Round PI Diamond pattern & Daisies', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-DIA-020';
END
GO

-- SRN-DOL-016 - 16 Doll Cake in Plastic Icing no base
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-DOL-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '16 Doll Cake in Plastic Icing no base',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-DOL-016';
    PRINT 'Updated: SRN-DOL-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-DOL-016', '16 Doll Cake in Plastic Icing no base', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-DOL-016';
END
GO

-- SRN-FOB-020 - 20 FC Fig on Base with Choc Flakes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-FOB-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20 FC Fig on Base with Choc Flakes',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-FOB-020';
    PRINT 'Updated: SRN-FOB-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-FOB-020', '20 FC Fig on Base with Choc Flakes', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-FOB-020';
END
GO

-- SRN-HBS-020 - Hugo Boss Suitcase Belt 20 in Plastic Icing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-HBS-020')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Hugo Boss Suitcase Belt 20 in Plastic Icing',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-HBS-020';
    PRINT 'Updated: SRN-HBS-020';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-HBS-020', 'Hugo Boss Suitcase Belt 20 in Plastic Icing', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-HBS-020';
END
GO

-- SRN-LIV-022 - 22 PI Liverpool with Scarf and Boots
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-LIV-022')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '22 PI Liverpool with Scarf and Boots',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-LIV-022';
    PRINT 'Updated: SRN-LIV-022';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-LIV-022', '22 PI Liverpool with Scarf and Boots', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-LIV-022';
END
GO

-- SRN-LVB-016 - Louis Vittone Bag 16 in Plastic Icing
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-LVB-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Louis Vittone Bag 16 in Plastic Icing',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-LVB-016';
    PRINT 'Updated: SRN-LVB-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-LVB-016', 'Louis Vittone Bag 16 in Plastic Icing', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-LVB-016';
END
GO

-- SRN-PAD-016 - 40*50 B/C cake with Ipad in PI + pic
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PAD-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '40*50 B/C cake with Ipad in PI + pic',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PAD-016';
    PRINT 'Updated: SRN-PAD-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PAD-016', '40*50 B/C cake with Ipad in PI + pic', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PAD-016';
END
GO

-- SRN-PID-014 - BD14'' Round covered in plastic icing and daisies
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PID-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD14'' Round covered in plastic icing and daisies',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PID-014';
    PRINT 'Updated: SRN-PID-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PID-014', 'BD14'' Round covered in plastic icing and daisies', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PID-014';
END
GO

-- SRN-PLR-016 - Plastic Icing 16 round with musical notes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-PLR-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Plastic Icing 16 round with musical notes',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-PLR-016';
    PRINT 'Updated: SRN-PLR-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-PLR-016', 'Plastic Icing 16 round with musical notes', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-PLR-016';
END
GO

-- SRN-ROA-014 - 14 Buttercream with Plastic icing Road
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-ROA-014')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '14 Buttercream with Plastic icing Road',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-ROA-014';
    PRINT 'Updated: SRN-ROA-014';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-ROA-014', '14 Buttercream with Plastic icing Road', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-ROA-014';
END
GO

-- SRN-SSC-016 - 16 BC S/Berry Short/C Figurine-PI
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-SSC-016')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '16 BC S/Berry Short/C Figurine-PI',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-SSC-016';
    PRINT 'Updated: SRN-SSC-016';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-SSC-016', '16 BC S/Berry Short/C Figurine-PI', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-SSC-016';
END
GO

-- SRN-STA-2TI - BD2 Tier Stack Sponge- Plastic Icing-12&14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-STA-2TI')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD2 Tier Stack Sponge- Plastic Icing-12&14',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-STA-2TI';
    PRINT 'Updated: SRN-STA-2TI';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-STA-2TI', 'BD2 Tier Stack Sponge- Plastic Icing-12&14', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-STA-2TI';
END
GO

-- SRN-STA-2TI - BD2 Tier Stack Sponge- Plastic Icing-12&14
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'novelty';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'novelty' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SRN-STA-2TI')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD2 Tier Stack Sponge- Plastic Icing-12&14',
        Category = 'novelty',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SRN-STA-2TI';
    PRINT 'Updated: SRN-STA-2TI';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SRN-STA-2TI', 'BD2 Tier Stack Sponge- Plastic Icing-12&14', 'novelty', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SRN-STA-2TI';
END
GO

-- PIE -CSR-EAC - OD Premium Chicken Tikka Sausage Roll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE -CSR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Premium Chicken Tikka Sausage Roll',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE -CSR-EAC';
    PRINT 'Updated: PIE -CSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE -CSR-EAC', 'OD Premium Chicken Tikka Sausage Roll', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE -CSR-EAC';
END
GO

-- PIE- FSK-EAC - Pie Steak & Kidney Foil
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE- FSK-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Steak & Kidney Foil',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE- FSK-EAC';
    PRINT 'Updated: PIE- FSK-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE- FSK-EAC', 'Pie Steak & Kidney Foil', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE- FSK-EAC';
END
GO

-- PIE-BBP-EAC - Pie - Burger Beef
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-BBP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie - Burger Beef',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-BBP-EAC';
    PRINT 'Updated: PIE-BBP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-BBP-EAC', 'Pie - Burger Beef', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-BBP-EAC';
END
GO

-- PIE-BRC-EAC - Pie - Burger Chicken Cheese / Sweet Chilli
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-BRC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie - Burger Chicken Cheese / Sweet Chilli',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-BRC-EAC';
    PRINT 'Updated: PIE-BRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-BRC-EAC', 'Pie - Burger Chicken Cheese / Sweet Chilli', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-BRC-EAC';
END
GO

-- PIE-CCG-EAC - Pie Chicken Cheese Griller
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-CCG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Chicken Cheese Griller',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-CCG-EAC';
    PRINT 'Updated: PIE-CCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-CCG-EAC', 'Pie Chicken Cheese Griller', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-CCG-EAC';
END
GO

-- PIE-CMS-EAC - Pie Chicken and Mayo Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-CMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Chicken and Mayo Slice',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-CMS-EAC';
    PRINT 'Updated: PIE-CMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-CMS-EAC', 'Pie Chicken and Mayo Slice', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-CMS-EAC';
END
GO

-- PIE-COD-EAC - Pie OD Chicken & Mushroom
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-COD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie OD Chicken & Mushroom',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PIE-COD-EAC';
    PRINT 'Updated: PIE-COD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-COD-EAC', 'Pie OD Chicken & Mushroom', 'pies', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PIE-COD-EAC';
END
GO

-- PIE-CPP-EAC - Pie Chicken Peri Peri
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-CPP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Chicken Peri Peri',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-CPP-EAC';
    PRINT 'Updated: PIE-CPP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-CPP-EAC', 'Pie Chicken Peri Peri', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-CPP-EAC';
END
GO

-- PIE-CRP-EAC - Pie - Cornish Pastry
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-CRP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie - Cornish Pastry',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-CRP-EAC';
    PRINT 'Updated: PIE-CRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-CRP-EAC', 'Pie - Cornish Pastry', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-CRP-EAC';
END
GO

-- PIE-FCP-EAC - Pie Chicken Peri Peri Foil
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-FCP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Chicken Peri Peri Foil',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-FCP-EAC';
    PRINT 'Updated: PIE-FCP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-FCP-EAC', 'Pie Chicken Peri Peri Foil', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-FCP-EAC';
END
GO

-- PIE-FVE-EAC - Pie Vegetable Curry Foil
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-FVE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Vegetable Curry Foil',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-FVE-EAC';
    PRINT 'Updated: PIE-FVE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-FVE-EAC', 'Pie Vegetable Curry Foil', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-FVE-EAC';
END
GO

-- PIE-MCB-EAC - Pie Mutton Curry Burger
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-MCB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Mutton Curry Burger',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-MCB-EAC';
    PRINT 'Updated: PIE-MCB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-MCB-EAC', 'Pie Mutton Curry Burger', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-MCB-EAC';
END
GO

-- PIE-MSR-EAC - OD Premium Mutton Oriental Sausage Roll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-MSR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'OD Premium Mutton Oriental Sausage Roll',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-MSR-EAC';
    PRINT 'Updated: PIE-MSR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-MSR-EAC', 'OD Premium Mutton Oriental Sausage Roll', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-MSR-EAC';
END
GO

-- PIE-ODM-EAC - Pie OD Mutton Curry
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-ODM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie OD Mutton Curry',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PIE-ODM-EAC';
    PRINT 'Updated: PIE-ODM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-ODM-EAC', 'Pie OD Mutton Curry', 'pies', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PIE-ODM-EAC';
END
GO

-- PIE-PPS-EAC - Pie Pepper Steak
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-PPS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Pepper Steak',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PIE-PPS-EAC';
    PRINT 'Updated: PIE-PPS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-PPS-EAC', 'Pie Pepper Steak', 'pies', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PIE-PPS-EAC';
END
GO

-- PIE-PRS-EAC - Pie Prime Steak
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-PRS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Prime Steak',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-PRS-EAC';
    PRINT 'Updated: PIE-PRS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-PRS-EAC', 'Pie Prime Steak', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-PRS-EAC';
END
GO

-- PIE-SAF-EAC - Pie Spinach & Feta
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-SAF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Spinach & Feta',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-SAF-EAC';
    PRINT 'Updated: PIE-SAF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-SAF-EAC', 'Pie Spinach & Feta', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-SAF-EAC';
END
GO

-- PIE-SAK-EAC - Pie Steak & Kidney
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-SAK-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Steak & Kidney',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-SAK-EAC';
    PRINT 'Updated: PIE-SAK-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-SAK-EAC', 'Pie Steak & Kidney', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-SAK-EAC';
END
GO

-- PIE-SRB-EACH - Pie Sausage Roll( Beef)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-SRB-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie Sausage Roll( Beef)',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'PIE-SRB-EACH';
    PRINT 'Updated: PIE-SRB-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-SRB-EACH', 'Pie Sausage Roll( Beef)', 'pies', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: PIE-SRB-EACH';
END
GO

-- PIE-VEG-EAC - Pie OD Vegetable
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PIE-VEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Pie OD Vegetable',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PIE-VEG-EAC';
    PRINT 'Updated: PIE-VEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PIE-VEG-EAC', 'Pie OD Vegetable', 'pies', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PIE-VEG-EAC';
END
GO

-- SAV-FCM-EAC - Frozen Chicken And Mushroom Pie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'pies';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'pies' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FCM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Chicken And Mushroom Pie',
        Category = 'pies',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FCM-EAC';
    PRINT 'Updated: SAV-FCM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FCM-EAC', 'Frozen Chicken And Mushroom Pie', 'pies', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FCM-EAC';
END
GO

-- PLA- MIX-EAC - Platter Mixy Delight
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA- MIX-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mixy Delight',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA- MIX-EAC';
    PRINT 'Updated: PLA- MIX-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA- MIX-EAC', 'Platter Mixy Delight', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA- MIX-EAC';
END
GO

-- PLA- PEM-EAC - Platter Mini Pecan Nut Tarts 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA- PEM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Pecan Nut Tarts 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA- PEM-EAC';
    PRINT 'Updated: PLA- PEM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA- PEM-EAC', 'Platter Mini Pecan Nut Tarts 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA- PEM-EAC';
END
GO

-- PLA -SCO-EAC - Platter Scone Delight 18s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA -SCO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Scone Delight 18s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA -SCO-EAC';
    PRINT 'Updated: PLA -SCO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA -SCO-EAC', 'Platter Scone Delight 18s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA -SCO-EAC';
END
GO

-- PLA-CHE-EAC - Platter Cheeky Delight
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-CHE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Cheeky Delight',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-CHE-EAC';
    PRINT 'Updated: PLA-CHE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-CHE-EAC', 'Platter Cheeky Delight', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-CHE-EAC';
END
GO

-- PLA-CRM-EAC - Platter Mini Cream Puffs 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-CRM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Cream Puffs 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-CRM-EAC';
    PRINT 'Updated: PLA-CRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-CRM-EAC', 'Platter Mini Cream Puffs 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-CRM-EAC';
END
GO

-- PLA-CRO-EAC - Platter Croissant Delight 20s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-CRO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Croissant Delight 20s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-CRO-EAC';
    PRINT 'Updated: PLA-CRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-CRO-EAC', 'Platter Croissant Delight 20s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-CRO-EAC';
END
GO

-- PLA-ECM-EAC - Platter Mini Freshcream Eclairs
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-ECM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Freshcream Eclairs',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-ECM-EAC';
    PRINT 'Updated: PLA-ECM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-ECM-EAC', 'Platter Mini Freshcream Eclairs', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-ECM-EAC';
END
GO

-- PLA-FLM-EAC - Platter Mini Flakey Bits 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-FLM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Flakey Bits 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-FLM-EAC';
    PRINT 'Updated: PLA-FLM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-FLM-EAC', 'Platter Mini Flakey Bits 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-FLM-EAC';
END
GO

-- PLA-FRM-EAC - Platter Mini Freshcream Donuts
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-FRM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Freshcream Donuts',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-FRM-EAC';
    PRINT 'Updated: PLA-FRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-FRM-EAC', 'Platter Mini Freshcream Donuts', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-FRM-EAC';
END
GO

-- PLA-JAM-EAC - Platter Mini Jam Turnovers 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-JAM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Jam Turnovers 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-JAM-EAC';
    PRINT 'Updated: PLA-JAM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-JAM-EAC', 'Platter Mini Jam Turnovers 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-JAM-EAC';
END
GO

-- PLA-MBD-EAC - Platter Mini Buttercream Donuts 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-MBD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Buttercream Donuts 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-MBD-EAC';
    PRINT 'Updated: PLA-MBD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-MBD-EAC', 'Platter Mini Buttercream Donuts 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-MBD-EAC';
END
GO

-- PLA-MCD-EAC - Platter Mini Chocolate Donut 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-MCD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Chocolate Donut 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-MCD-EAC';
    PRINT 'Updated: PLA-MCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-MCD-EAC', 'Platter Mini Chocolate Donut 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-MCD-EAC';
END
GO

-- PLA-MEA-EAC - Platter Meaty Delight
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-MEA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Meaty Delight',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-MEA-EAC';
    PRINT 'Updated: PLA-MEA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-MEA-EAC', 'Platter Meaty Delight', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-MEA-EAC';
END
GO

-- PLA-MIM-EAC - Platter Mini Milk Tarts 24S
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-MIM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Milk Tarts 24S',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-MIM-EAC';
    PRINT 'Updated: PLA-MIM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-MIM-EAC', 'Platter Mini Milk Tarts 24S', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-MIM-EAC';
END
GO

-- PLA-MLP-EAC - Platter Mini Lamingtons 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-MLP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Lamingtons 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-MLP-EAC';
    PRINT 'Updated: PLA-MLP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-MLP-EAC', 'Platter Mini Lamingtons 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-MLP-EAC';
END
GO

-- PLA-MUFF- EAC - Platter Muffin Delight 30s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-MUFF- EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Muffin Delight 30s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-MUFF- EAC';
    PRINT 'Updated: PLA-MUFF- EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-MUFF- EAC', 'Platter Muffin Delight 30s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-MUFF- EAC';
END
GO

-- PLA-SMA-EAC - Platter Snacky Delight
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-SMA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Snacky Delight',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-SMA-EAC';
    PRINT 'Updated: PLA-SMA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-SMA-EAC', 'Platter Snacky Delight', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-SMA-EAC';
END
GO

-- PLA-SNM-EAC - Platter Mini Snowballs 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-SNM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Mini Snowballs 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-SNM-EAC';
    PRINT 'Updated: PLA-SNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-SNM-EAC', 'Platter Mini Snowballs 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-SNM-EAC';
END
GO

-- PLA-VEG-EAC - Platter Veggy Delights
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PLA-VEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Veggy Delights',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PLA-VEG-EAC';
    PRINT 'Updated: PLA-VEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PLA-VEG-EAC', 'Platter Veggy Delights', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PLA-VEG-EAC';
END
GO

-- SHP- IDH-32S - Idhli Platter 32s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- IDH-32S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Idhli Platter 32s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP- IDH-32S';
    PRINT 'Updated: SHP- IDH-32S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- IDH-32S', 'Idhli Platter 32s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP- IDH-32S';
END
GO

-- SHP-BSP-24S - Butter Scone Platter 24s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BSP-24S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Butter Scone Platter 24s',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BSP-24S';
    PRINT 'Updated: SHP-BSP-24S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BSP-24S', 'Butter Scone Platter 24s', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BSP-24S';
END
GO

-- SHP-IDH-EACH - Idhli Pure Butter (4s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'platter';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'platter' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-IDH-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Idhli Pure Butter (4s)',
        Category = 'platter',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-IDH-EACH';
    PRINT 'Updated: SHP-IDH-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-IDH-EACH', 'Idhli Pure Butter (4s)', 'platter', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-IDH-EACH';
END
GO

-- SAV-CCS-EAC - Crumbed Chicken Samoosa
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-CCS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Crumbed Chicken Samoosa',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-CCS-EAC';
    PRINT 'Updated: SAV-CCS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-CCS-EAC', 'Crumbed Chicken Samoosa', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-CCS-EAC';
END
GO

-- SAV-CJF-EAC - Frozen Cheese And Jalapeno
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-CJF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Cheese And Jalapeno',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-CJF-EAC';
    PRINT 'Updated: SAV-CJF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-CJF-EAC', 'Frozen Cheese And Jalapeno', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-CJF-EAC';
END
GO

-- SAV-CJR-EAC - Chicken & Jalapeno Rissoles
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-CJR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chicken & Jalapeno Rissoles',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-CJR-EAC';
    PRINT 'Updated: SAV-CJR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-CJR-EAC', 'Chicken & Jalapeno Rissoles', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-CJR-EAC';
END
GO

-- SAV-CSA-EAC - Chicken Samoosa
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-CSA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chicken Samoosa',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-CSA-EAC';
    PRINT 'Updated: SAV-CSA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-CSA-EAC', 'Chicken Samoosa', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-CSA-EAC';
END
GO

-- SAV-FCR-EAC - Frozen Chicken Sausage Rolls
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FCR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Chicken Sausage Rolls',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FCR-EAC';
    PRINT 'Updated: SAV-FCR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FCR-EAC', 'Frozen Chicken Sausage Rolls', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FCR-EAC';
END
GO

-- SAV-FFI-EAC - Frozen Fish Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FFI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Fish Cake',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FFI-EAC';
    PRINT 'Updated: SAV-FFI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FFI-EAC', 'Frozen Fish Cake', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FFI-EAC';
END
GO

-- SAV-FIS-EAC - Fish Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FIS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Fish Cake',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FIS-EAC';
    PRINT 'Updated: SAV-FIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FIS-EAC', 'Fish Cake', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FIS-EAC';
END
GO

-- SAV-FJC-EAC - Frozen Chicken And Jalapeno
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FJC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Chicken And Jalapeno',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FJC-EAC';
    PRINT 'Updated: SAV-FJC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FJC-EAC', 'Frozen Chicken And Jalapeno', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FJC-EAC';
END
GO

-- SAV-FKE-EAC - Frozen Kebabs
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FKE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Kebabs',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FKE-EAC';
    PRINT 'Updated: SAV-FKE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FKE-EAC', 'Frozen Kebabs', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FKE-EAC';
END
GO

-- SAV-FMV-EAC - Frozen Mix Veg Pie
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FMV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Mix Veg Pie',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FMV-EAC';
    PRINT 'Updated: SAV-FMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FMV-EAC', 'Frozen Mix Veg Pie', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FMV-EAC';
END
GO

-- SAV-FPA-EACH - Frozen Patha Wheel
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-FPA-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Frozen Patha Wheel',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-FPA-EACH';
    PRINT 'Updated: SAV-FPA-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-FPA-EACH', 'Frozen Patha Wheel', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-FPA-EACH';
END
GO

-- SAV-LMS-EAC - Lamb Mince Samoosa
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-LMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Lamb Mince Samoosa',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-LMS-EAC';
    PRINT 'Updated: SAV-LMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-LMS-EAC', 'Lamb Mince Samoosa', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-LMS-EAC';
END
GO

-- SAV-PAP-EAC - Puri & Patha (3s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-PAP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Puri & Patha (3s)',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-PAP-EAC';
    PRINT 'Updated: SAV-PAP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-PAP-EAC', 'Puri & Patha (3s)', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-PAP-EAC';
END
GO

-- SAV-PAS-EAC - Patha Samoosa
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-PAS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Patha Samoosa',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-PAS-EAC';
    PRINT 'Updated: SAV-PAS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-PAS-EAC', 'Patha Samoosa', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-PAS-EAC';
END
GO

-- SAV-PUP-EAC - Puri Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-PUP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Puri Plain',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-PUP-EAC';
    PRINT 'Updated: SAV-PUP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-PUP-EAC', 'Puri Plain', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-PUP-EAC';
END
GO

-- SAV-RCJ-EAC - Cheese & Jalapeno Rissoles
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-RCJ-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cheese & Jalapeno Rissoles',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-RCJ-EAC';
    PRINT 'Updated: SAV-RCJ-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-RCJ-EAC', 'Cheese & Jalapeno Rissoles', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-RCJ-EAC';
END
GO

-- SAV-RRC-EAC - Roti Roll Chicken
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-RRC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Roti Roll Chicken',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-RRC-EAC';
    PRINT 'Updated: SAV-RRC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-RRC-EAC', 'Roti Roll Chicken', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-RRC-EAC';
END
GO

-- SAV-RRP-EAC - Roti Roll Potatoe
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-RRP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Roti Roll Potatoe',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-RRP-EAC';
    PRINT 'Updated: SAV-RRP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-RRP-EAC', 'Roti Roll Potatoe', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-RRP-EAC';
END
GO

-- SAV-SAM-EAC - Samoosa 3s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-SAM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Samoosa 3s',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-SAM-EAC';
    PRINT 'Updated: SAV-SAM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-SAM-EAC', 'Samoosa 3s', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-SAM-EAC';
END
GO

-- SAV-SCC-EAC - Cheese And Corn Samoosa
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-SCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cheese And Corn Samoosa',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-SCC-EAC';
    PRINT 'Updated: SAV-SCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-SCC-EAC', 'Cheese And Corn Samoosa', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-SCC-EAC';
END
GO

-- SAV-VED-EAC - Veda
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SAV-VED-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Veda',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SAV-VED-EAC';
    PRINT 'Updated: SAV-VED-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SAV-VED-EAC', 'Veda', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SAV-VED-EAC';
END
GO

-- SHP- CRW-EAC - Roti Chicken Wrap
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- CRW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Roti Chicken Wrap',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP- CRW-EAC';
    PRINT 'Updated: SHP- CRW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- CRW-EAC', 'Roti Chicken Wrap', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP- CRW-EAC';
END
GO

-- SHP- PRW-EAC - Roti Potatoe Wrap
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'savoury';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'savoury' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- PRW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Roti Potatoe Wrap',
        Category = 'savoury',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP- PRW-EAC';
    PRINT 'Updated: SHP- PRW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- PRW-EAC', 'Roti Potatoe Wrap', 'savoury', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP- PRW-EAC';
END
GO

-- CBC-MCL-EAC - Mini Lamington Chocolate Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBC-MCL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mini Lamington Chocolate Plain',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBC-MCL-EAC';
    PRINT 'Updated: CBC-MCL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBC-MCL-EAC', 'Mini Lamington Chocolate Plain', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBC-MCL-EAC';
END
GO

-- CEX-MDF-EAC - Freshcream 6 Layer Drip Cake with Toppings
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-MDF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Freshcream 6 Layer Drip Cake with Toppings',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CEX-MDF-EAC';
    PRINT 'Updated: CEX-MDF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-MDF-EAC', 'Freshcream 6 Layer Drip Cake with Toppings', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CEX-MDF-EAC';
END
GO

-- SHP - JAL-EACH - Jalebi 250g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP - JAL-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Jalebi 250g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP - JAL-EACH';
    PRINT 'Updated: SHP - JAL-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP - JAL-EACH', 'Jalebi 250g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP - JAL-EACH';
END
GO

-- SHP- BAN-EAC - Banana Loaf
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- BAN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Banana Loaf',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP- BAN-EAC';
    PRINT 'Updated: SHP- BAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- BAN-EAC', 'Banana Loaf', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP- BAN-EAC';
END
GO

-- SHP- GUL-1KG - Gulab Jamun 1kg
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- GUL-1KG')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Gulab Jamun 1kg',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP- GUL-1KG';
    PRINT 'Updated: SHP- GUL-1KG';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- GUL-1KG', 'Gulab Jamun 1kg', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP- GUL-1KG';
END
GO

-- SHP- GUL-4S - Gulab Jamun 4s Pure Butter
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- GUL-4S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Gulab Jamun 4s Pure Butter',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP- GUL-4S';
    PRINT 'Updated: SHP- GUL-4S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- GUL-4S', 'Gulab Jamun 4s Pure Butter', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP- GUL-4S';
END
GO

-- SHP- MOL-6S - DC Sweetmeats Mini Oval Laser Cut Wooden (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- MOL-6S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Sweetmeats Mini Oval Laser Cut Wooden (6s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP- MOL-6S';
    PRINT 'Updated: SHP- MOL-6S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- MOL-6S', 'DC Sweetmeats Mini Oval Laser Cut Wooden (6s)', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP- MOL-6S';
END
GO

-- SHP- RAE-EAC - Eggless Rainbow Sponge Log
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- RAE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Eggless Rainbow Sponge Log',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP- RAE-EAC';
    PRINT 'Updated: SHP- RAE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- RAE-EAC', 'Eggless Rainbow Sponge Log', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP- RAE-EAC';
END
GO

-- SHP- SWEE-250G - DC Sweet Meats Assorted 250g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP- SWEE-250G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Sweet Meats Assorted 250g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP- SWEE-250G';
    PRINT 'Updated: SHP- SWEE-250G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP- SWEE-250G', 'DC Sweet Meats Assorted 250g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP- SWEE-250G';
END
GO

-- SHP-AUA-EAC - DC Authentic Assorted Sweetmeats 11 pieces
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-AUA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Authentic Assorted Sweetmeats 11 pieces',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-AUA-EAC';
    PRINT 'Updated: SHP-AUA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-AUA-EAC', 'DC Authentic Assorted Sweetmeats 11 pieces', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-AUA-EAC';
END
GO

-- SHP-AUT-EAC - Authentic Ladoo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-AUT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Authentic Ladoo',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-AUT-EAC';
    PRINT 'Updated: SHP-AUT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-AUT-EAC', 'Authentic Ladoo', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-AUT-EAC';
END
GO

-- SHP-BAN-6S - Banana Puri (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BAN-6S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Banana Puri (6s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-BAN-6S';
    PRINT 'Updated: SHP-BAN-6S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BAN-6S', 'Banana Puri (6s)', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-BAN-6S';
END
GO

-- SHP-BBS-EAC - Sweetmeats Boujee Singles
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BBS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sweetmeats Boujee Singles',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-BBS-EAC';
    PRINT 'Updated: SHP-BBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BBS-EAC', 'Sweetmeats Boujee Singles', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-BBS-EAC';
END
GO

-- SHP-BCC-EAC - Buttercream Christmas cakes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Buttercream Christmas cakes',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BCC-EAC';
    PRINT 'Updated: SHP-BCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BCC-EAC', 'Buttercream Christmas cakes', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BCC-EAC';
END
GO

-- SHP-BCG-EAC - ButterCream Christmas Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BCG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'ButterCream Christmas Gateaux',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BCG-EAC';
    PRINT 'Updated: SHP-BCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BCG-EAC', 'ButterCream Christmas Gateaux', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BCG-EAC';
END
GO

-- SHP-BRB-400 - Bread Brown 400g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRB-400')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bread Brown 400g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRB-400';
    PRINT 'Updated: SHP-BRB-400';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRB-400', 'Bread Brown 400g', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRB-400';
END
GO

-- SHP-BRB-400G - Bread Bunny Loaf 400g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRB-400G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bread Bunny Loaf 400g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRB-400G';
    PRINT 'Updated: SHP-BRB-400G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRB-400G', 'Bread Bunny Loaf 400g', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRB-400G';
END
GO

-- SHP-BRB-800 - Sun Bread Brown 800g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRB-800')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sun Bread Brown 800g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRB-800';
    PRINT 'Updated: SHP-BRB-800';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRB-800', 'Sun Bread Brown 800g', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRB-800';
END
GO

-- SHP-BRG-EAC - Bread Garlic 300g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bread Garlic 300g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRG-EAC';
    PRINT 'Updated: SHP-BRG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRG-EAC', 'Bread Garlic 300g', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRG-EAC';
END
GO

-- SHP-BRO-EAC - Butter Roti (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Butter Roti (6s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRO-EAC';
    PRINT 'Updated: SHP-BRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRO-EAC', 'Butter Roti (6s)', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRO-EAC';
END
GO

-- SHP-BRR-500 - Bread Tea Ring
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRR-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bread Tea Ring',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRR-500';
    PRINT 'Updated: SHP-BRR-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRR-500', 'Bread Tea Ring', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRR-500';
END
GO

-- SHP-BRT-500 - Bread Tea Loaf 500g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRT-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bread Tea Loaf 500g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRT-500';
    PRINT 'Updated: SHP-BRT-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRT-500', 'Bread Tea Loaf 500g', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRT-500';
END
GO

-- SHP-BRW-400 - Bread White 400g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRW-400')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bread White 400g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRW-400';
    PRINT 'Updated: SHP-BRW-400';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRW-400', 'Bread White 400g', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRW-400';
END
GO

-- SHP-BRW-800 - Sun Bread White 800
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BRW-800')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sun Bread White 800',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BRW-800';
    PRINT 'Updated: SHP-BRW-800';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BRW-800', 'Sun Bread White 800', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BRW-800';
END
GO

-- SHP-BSC-EAC - Butter Scones (4s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BSC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Butter Scones (4s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BSC-EAC';
    PRINT 'Updated: SHP-BSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BSC-EAC', 'Butter Scones (4s)', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BSC-EAC';
END
GO

-- SHP-BTW-500 - Bread 500g Twist
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BTW-500')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bread 500g Twist',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BTW-500';
    PRINT 'Updated: SHP-BTW-500';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BTW-500', 'Bread 500g Twist', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BTW-500';
END
GO

-- SHP-BUN-EAC - Buns 100g Soft 6s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BUN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Buns 100g Soft 6s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BUN-EAC';
    PRINT 'Updated: SHP-BUN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BUN-EAC', 'Buns 100g Soft 6s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BUN-EAC';
END
GO

-- SHP-BUR-1KG - Burfee 1kg
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BUR-1KG')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Burfee 1kg',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BUR-1KG';
    PRINT 'Updated: SHP-BUR-1KG';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BUR-1KG', 'Burfee 1kg', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BUR-1KG';
END
GO

-- SHP-BUR-KGR - Burfee 9pc
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-BUR-KGR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Burfee 9pc',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-BUR-KGR';
    PRINT 'Updated: SHP-BUR-KGR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-BUR-KGR', 'Burfee 9pc', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-BUR-KGR';
END
GO

-- SHP-CFI-EAC - Christmas fruit Cake Round Iced
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CFI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas fruit Cake Round Iced',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CFI-EAC';
    PRINT 'Updated: SHP-CFI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CFI-EAC', 'Christmas fruit Cake Round Iced', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CFI-EAC';
END
GO

-- SHP-CFP-EAC - Christmas Fruit Cake Round Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CFP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Fruit Cake Round Plain',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CFP-EAC';
    PRINT 'Updated: SHP-CFP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CFP-EAC', 'Christmas Fruit Cake Round Plain', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CFP-EAC';
END
GO

-- SHP-CHA-1KG - Chana Magaj 1kg
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CHA-1KG')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chana Magaj 1kg',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CHA-1KG';
    PRINT 'Updated: SHP-CHA-1KG';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CHA-1KG', 'Chana Magaj 1kg', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CHA-1KG';
END
GO

-- SHP-CHB-04S - Chelsea Buns (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CHB-04S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chelsea Buns (6s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CHB-04S';
    PRINT 'Updated: SHP-CHB-04S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CHB-04S', 'Chelsea Buns (6s)', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CHB-04S';
END
GO

-- SHP-CHO-PLN - Chocolate Gateaux Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CHO-PLN')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Gateaux Plain',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CHO-PLN';
    PRINT 'Updated: SHP-CHO-PLN';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CHO-PLN', 'Chocolate Gateaux Plain', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CHO-PLN';
END
GO

-- SHP-CPN-EAC - Carrot and Pecan Nut Slab
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CPN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Carrot and Pecan Nut Slab',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CPN-EAC';
    PRINT 'Updated: SHP-CPN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CPN-EAC', 'Carrot and Pecan Nut Slab', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CPN-EAC';
END
GO

-- SHP-CRB-06S - Cream Buns 6s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CRB-06S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cream Buns 6s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CRB-06S';
    PRINT 'Updated: SHP-CRB-06S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CRB-06S', 'Cream Buns 6s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CRB-06S';
END
GO

-- SHP-CRM-EAC - Christmas Round Mini Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CRM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Round Mini Cake',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CRM-EAC';
    PRINT 'Updated: SHP-CRM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CRM-EAC', 'Christmas Round Mini Cake', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CRM-EAC';
END
GO

-- SHP-CRO-06S - Rolls 70g Soft Hotdog Cheese 6
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CRO-06S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rolls 70g Soft Hotdog Cheese 6',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CRO-06S';
    PRINT 'Updated: SHP-CRO-06S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CRO-06S', 'Rolls 70g Soft Hotdog Cheese 6', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CRO-06S';
END
GO

-- SHP-CSC-EAC - Chocolate Sponge Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CSC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Sponge Cake',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CSC-EAC';
    PRINT 'Updated: SHP-CSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CSC-EAC', 'Chocolate Sponge Cake', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CSC-EAC';
END
GO

-- SHP-CTP-EAC - Christmas Steamed Pudding
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CTP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Steamed Pudding',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CTP-EAC';
    PRINT 'Updated: SHP-CTP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CTP-EAC', 'Christmas Steamed Pudding', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CTP-EAC';
END
GO

-- SHP-CTR-EAC - Cocktail Rolls
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CTR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cocktail Rolls',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CTR-EAC';
    PRINT 'Updated: SHP-CTR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CTR-EAC', 'Cocktail Rolls', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CTR-EAC';
END
GO

-- SHP-CWP-EAC - Christmas Windsor Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CWP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Windsor Plain',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CWP-EAC';
    PRINT 'Updated: SHP-CWP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CWP-EAC', 'Christmas Windsor Plain', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CWP-EAC';
END
GO

-- SHP-CWS-EAC - Christmas Windsor Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-CWS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Windsor Slice',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-CWS-EAC';
    PRINT 'Updated: SHP-CWS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-CWS-EAC', 'Christmas Windsor Slice', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-CWS-EAC';
END
GO

-- SHP-DBB-EAC - DC Diwali Bandhani Box
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DBB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Bandhani Box',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DBB-EAC';
    PRINT 'Updated: SHP-DBB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DBB-EAC', 'DC Diwali Bandhani Box', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DBB-EAC';
END
GO

-- SHP-DDB-EAC - DC Diwali Designer Biscuit
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DDB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Designer Biscuit',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DDB-EAC';
    PRINT 'Updated: SHP-DDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DDB-EAC', 'DC Diwali Designer Biscuit', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DDB-EAC';
END
GO

-- SHP-DDD-EAC - DC Diwali Designer Burfee
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DDD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Designer Burfee',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DDD-EAC';
    PRINT 'Updated: SHP-DDD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DDD-EAC', 'DC Diwali Designer Burfee', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DDD-EAC';
END
GO

-- SHP-DEG-EAC - DC Diwali Eggless Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DEG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Eggless Cake',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-DEG-EAC';
    PRINT 'Updated: SHP-DEG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DEG-EAC', 'DC Diwali Eggless Cake', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-DEG-EAC';
END
GO

-- SHP-DIB-EACH - DC Authentic Diya Boxes
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DIB-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Authentic Diya Boxes',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DIB-EACH';
    PRINT 'Updated: SHP-DIB-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DIB-EACH', 'DC Authentic Diya Boxes', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DIB-EACH';
END
GO

-- SHP-DJA-EAC - DC Diwali Jalebi
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DJA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Jalebi',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DJA-EAC';
    PRINT 'Updated: SHP-DJA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DJA-EAC', 'DC Diwali Jalebi', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DJA-EAC';
END
GO

-- SHP-DLB-EAC - DC Diwali Large Bag
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DLB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Large Bag',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DLB-EAC';
    PRINT 'Updated: SHP-DLB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DLB-EAC', 'DC Diwali Large Bag', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DLB-EAC';
END
GO

-- SHP-DLD-EAC - DC Diwali Large Designer Box
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DLD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Large Designer Box',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DLD-EAC';
    PRINT 'Updated: SHP-DLD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DLD-EAC', 'DC Diwali Large Designer Box', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DLD-EAC';
END
GO

-- SHP-DMA-EAC - DC Diwali Macaroons
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DMA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Macaroons',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DMA-EAC';
    PRINT 'Updated: SHP-DMA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DMA-EAC', 'DC Diwali Macaroons', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DMA-EAC';
END
GO

-- SHP-DOP-10S - Doughnut Pops 10s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DOP-10S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Doughnut Pops 10s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DOP-10S';
    PRINT 'Updated: SHP-DOP-10S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DOP-10S', 'Doughnut Pops 10s', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DOP-10S';
END
GO

-- SHP-DPB-EAC - DC Diwali Peacock Box
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DPB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Peacock Box',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DPB-EAC';
    PRINT 'Updated: SHP-DPB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DPB-EAC', 'DC Diwali Peacock Box', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DPB-EAC';
END
GO

-- SHP-DRO-EAC - Dhall Roti (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DRO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dhall Roti (6s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DRO-EAC';
    PRINT 'Updated: SHP-DRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DRO-EAC', 'Dhall Roti (6s)', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DRO-EAC';
END
GO

-- SHP-DSB-EAC - DC Diwali Small Bag
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-DSB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Small Bag',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-DSB-EAC';
    PRINT 'Updated: SHP-DSB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-DSB-EAC', 'DC Diwali Small Bag', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-DSB-EAC';
END
GO

-- SHP-FCE-EAC - Christmas Fruit Cake Eggless Round
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-FCE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Fruit Cake Eggless Round',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-FCE-EAC';
    PRINT 'Updated: SHP-FCE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-FCE-EAC', 'Christmas Fruit Cake Eggless Round', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-FCE-EAC';
END
GO

-- SHP-GAT-EAC - DC Diwali Gateaux
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-GAT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Gateaux',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-GAT-EAC';
    PRINT 'Updated: SHP-GAT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-GAT-EAC', 'DC Diwali Gateaux', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-GAT-EAC';
END
GO

-- SHP-GLC-EAC - DC Diwali Gold Laser Cut
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-GLC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Gold Laser Cut',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-GLC-EAC';
    PRINT 'Updated: SHP-GLC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-GLC-EAC', 'DC Diwali Gold Laser Cut', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-GLC-EAC';
END
GO

-- SHP-HBU-EAC - Hot x Buns 6s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-HBU-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Hot x Buns 6s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-HBU-EAC';
    PRINT 'Updated: SHP-HBU-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-HBU-EAC', 'Hot x Buns 6s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-HBU-EAC';
END
GO

-- SHP-JSW-EAC - Vanilla Jam Swissroll
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-JSW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Vanilla Jam Swissroll',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-JSW-EAC';
    PRINT 'Updated: SHP-JSW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-JSW-EAC', 'Vanilla Jam Swissroll', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-JSW-EAC';
END
GO

-- SHP-LAC-EACH - Chocolate Lamington 5 pack
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-LAC-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Lamington 5 pack',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-LAC-EACH';
    PRINT 'Updated: SHP-LAC-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-LAC-EACH', 'Chocolate Lamington 5 pack', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-LAC-EACH';
END
GO

-- SHP-LAD-EAC - Ladoo 9 piece
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-LAD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Ladoo 9 piece',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-LAD-EAC';
    PRINT 'Updated: SHP-LAD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-LAD-EAC', 'Ladoo 9 piece', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-LAD-EAC';
END
GO

-- SHP-LAR-EACH - Raspberry Lamington 5 pack
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-LAR-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Raspberry Lamington 5 pack',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-LAR-EACH';
    PRINT 'Updated: SHP-LAR-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-LAR-EACH', 'Raspberry Lamington 5 pack', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-LAR-EACH';
END
GO

-- SHP-LEM-EAC - Lemon Loaf
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-LEM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Lemon Loaf',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-LEM-EAC';
    PRINT 'Updated: SHP-LEM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-LEM-EAC', 'Lemon Loaf', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-LEM-EAC';
END
GO

-- SHP-LHS-375 - DC Large Hexagonal Deluxe Sweetmeats 375g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-LHS-375')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Large Hexagonal Deluxe Sweetmeats 375g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-LHS-375';
    PRINT 'Updated: SHP-LHS-375';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-LHS-375', 'DC Large Hexagonal Deluxe Sweetmeats 375g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-LHS-375';
END
GO

-- SHP-LJS-350 - DC Large Jewels Deluxe Sweetmeats 350g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-LJS-350')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Large Jewels Deluxe Sweetmeats 350g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-LJS-350';
    PRINT 'Updated: SHP-LJS-350';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-LJS-350', 'DC Large Jewels Deluxe Sweetmeats 350g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-LJS-350';
END
GO

-- SHP-LWC-360G - DC Sweetmeats Lamp Wooden Cut 360g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-LWC-360G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Sweetmeats Lamp Wooden Cut 360g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-LWC-360G';
    PRINT 'Updated: SHP-LWC-360G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-LWC-360G', 'DC Sweetmeats Lamp Wooden Cut 360g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-LWC-360G';
END
GO

-- SHP-MAD-EAC - Madeira
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-MAD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Madeira',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-MAD-EAC';
    PRINT 'Updated: SHP-MAD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-MAD-EAC', 'Madeira', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-MAD-EAC';
END
GO

-- SHP-MHS-165 - DC Mini Hexagonal Deluxe Sweetmeats 165g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-MHS-165')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Mini Hexagonal Deluxe Sweetmeats 165g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-MHS-165';
    PRINT 'Updated: SHP-MHS-165';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-MHS-165', 'DC Mini Hexagonal Deluxe Sweetmeats 165g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-MHS-165';
END
GO

-- SHP-MIN-EAC - Mince Pies
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-MIN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mince Pies',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-MIN-EAC';
    PRINT 'Updated: SHP-MIN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-MIN-EAC', 'Mince Pies', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-MIN-EAC';
END
GO

-- SHP-MJS-250 - DC Mini Jewels Deluxe Sweetmeats 250g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-MJS-250')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Mini Jewels Deluxe Sweetmeats 250g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-MJS-250';
    PRINT 'Updated: SHP-MJS-250';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-MJS-250', 'DC Mini Jewels Deluxe Sweetmeats 250g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-MJS-250';
END
GO

-- SHP-MRO-EACH - Brown Roti (6s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-MRO-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Brown Roti (6s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-MRO-EACH';
    PRINT 'Updated: SHP-MRO-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-MRO-EACH', 'Brown Roti (6s)', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-MRO-EACH';
END
GO

-- SHP-NAA-02S - Naan 300g 2s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-NAA-02S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Naan 300g 2s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-NAA-02S';
    PRINT 'Updated: SHP-NAA-02S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-NAA-02S', 'Naan 300g 2s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-NAA-02S';
END
GO

-- SHP-NAA-EAC - Naan 300g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-NAA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Naan 300g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-NAA-EAC';
    PRINT 'Updated: SHP-NAA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-NAA-EAC', 'Naan 300g', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-NAA-EAC';
END
GO

-- SHP-PFC-4S - Poli With Fresh Coconut 4s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-PFC-4S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Poli With Fresh Coconut 4s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-PFC-4S';
    PRINT 'Updated: SHP-PFC-4S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-PFC-4S', 'Poli With Fresh Coconut 4s', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-PFC-4S';
END
GO

-- SHP-POL-EAC - Poli (4s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-POL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Poli (4s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-POL-EAC';
    PRINT 'Updated: SHP-POL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-POL-EAC', 'Poli (4s)', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-POL-EAC';
END
GO

-- SHP-PPP-30S - Puri Patha Platter 30s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-PPP-30S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Puri Patha Platter 30s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-PPP-30S';
    PRINT 'Updated: SHP-PPP-30S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-PPP-30S', 'Puri Patha Platter 30s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-PPP-30S';
END
GO

-- SHP-RAI-EAC - Rainbow Sponge Log
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RAI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rainbow Sponge Log',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-RAI-EAC';
    PRINT 'Updated: SHP-RAI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RAI-EAC', 'Rainbow Sponge Log', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-RAI-EAC';
END
GO

-- SHP-RAL-EAC - Raisin Loaf
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RAL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Raisin Loaf',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-RAL-EAC';
    PRINT 'Updated: SHP-RAL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RAL-EAC', 'Raisin Loaf', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-RAL-EAC';
END
GO

-- SHP-RJS-595 - DC Rajasthani Jewel Sweetmeats 595g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RJS-595')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Rajasthani Jewel Sweetmeats 595g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-RJS-595';
    PRINT 'Updated: SHP-RJS-595';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RJS-595', 'DC Rajasthani Jewel Sweetmeats 595g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-RJS-595';
END
GO

-- SHP-RLC-EAC - DC Diwali Round Clear Assorted
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RLC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Round Clear Assorted',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-RLC-EAC';
    PRINT 'Updated: SHP-RLC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RLC-EAC', 'DC Diwali Round Clear Assorted', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-RLC-EAC';
END
GO

-- SHP-ROLL-06S - Rolls 60g Soft Hotdog 6s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-ROLL-06S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rolls 60g Soft Hotdog 6s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-ROLL-06S';
    PRINT 'Updated: SHP-ROLL-06S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-ROLL-06S', 'Rolls 60g Soft Hotdog 6s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-ROLL-06S';
END
GO

-- SHP-ROLL-12S - Rolls 60g Soft Hotdog 12s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-ROLL-12S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rolls 60g Soft Hotdog 12s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-ROLL-12S';
    PRINT 'Updated: SHP-ROLL-12S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-ROLL-12S', 'Rolls 60g Soft Hotdog 12s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-ROLL-12S';
END
GO

-- SHP-ROT-EAC - Rotis 12s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-ROT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Rotis 12s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-ROT-EAC';
    PRINT 'Updated: SHP-ROT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-ROT-EAC', 'Rotis 12s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-ROT-EAC';
END
GO

-- SHP-RWC-265G - DC Sweetmeats Round Wooden Cut 265G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RWC-265G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Sweetmeats Round Wooden Cut 265G',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-RWC-265G';
    PRINT 'Updated: SHP-RWC-265G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RWC-265G', 'DC Sweetmeats Round Wooden Cut 265G', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-RWC-265G';
END
GO

-- SHP-RWC-380G - DC Sweetmeats Rectangle Wooden Cut 380g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-RWC-380G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Sweetmeats Rectangle Wooden Cut 380g',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-RWC-380G';
    PRINT 'Updated: SHP-RWC-380G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-RWC-380G', 'DC Sweetmeats Rectangle Wooden Cut 380g', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-RWC-380G';
END
GO

-- SHP-SBB-EACH - DC Sweetmeats Boujee Burfee
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SBB-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Sweetmeats Boujee Burfee',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-SBB-EACH';
    PRINT 'Updated: SHP-SBB-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SBB-EACH', 'DC Sweetmeats Boujee Burfee', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-SBB-EACH';
END
GO

-- SHP-SBC-EAC - Burfee Soji Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SBC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Burfee Soji Cake',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-SBC-EAC';
    PRINT 'Updated: SHP-SBC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SBC-EAC', 'Burfee Soji Cake', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-SBC-EAC';
END
GO

-- SHP-SCF-EAC - Scones Fruit 4s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SCF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Scones Fruit 4s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-SCF-EAC';
    PRINT 'Updated: SHP-SCF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SCF-EAC', 'Scones Fruit 4s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-SCF-EAC';
END
GO

-- SHP-SCG-EAC - Dome Buttercream Christmas Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SCG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Dome Buttercream Christmas Cake',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-SCG-EAC';
    PRINT 'Updated: SHP-SCG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SCG-EAC', 'Dome Buttercream Christmas Cake', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-SCG-EAC';
END
GO

-- SHP-SCO-EAC - Scones 4s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SCO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Scones 4s',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-SCO-EAC';
    PRINT 'Updated: SHP-SCO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SCO-EAC', 'Scones 4s', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-SCO-EAC';
END
GO

-- SHP-SDB-EAC - DC Diwali Small Designer Box
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SDB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Diwali Small Designer Box',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-SDB-EAC';
    PRINT 'Updated: SHP-SDB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SDB-EAC', 'DC Diwali Small Designer Box', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-SDB-EAC';
END
GO

-- SHP-SGL-EAC - Sweet Meats Gold Foil Large
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SGL-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sweet Meats Gold Foil Large',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-SGL-EAC';
    PRINT 'Updated: SHP-SGL-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SGL-EAC', 'Sweet Meats Gold Foil Large', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-SGL-EAC';
END
GO

-- SHP-SGS-EAC - Sweet Meats Gold Foil Small
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SGS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sweet Meats Gold Foil Small',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-SGS-EAC';
    PRINT 'Updated: SHP-SGS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SGS-EAC', 'Sweet Meats Gold Foil Small', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-SGS-EAC';
END
GO

-- SHP-SPF-EAC - Sweet Meats Paisley Gold Foil
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SPF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sweet Meats Paisley Gold Foil',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-SPF-EAC';
    PRINT 'Updated: SHP-SPF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SPF-EAC', 'Sweet Meats Paisley Gold Foil', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-SPF-EAC';
END
GO

-- SHP-SPO-EACH - Soji Poli (5s)
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SPO-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Soji Poli (5s)',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-SPO-EACH';
    PRINT 'Updated: SHP-SPO-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SPO-EACH', 'Soji Poli (5s)', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-SPO-EACH';
END
GO

-- SHP-SSC-EAC - Strawberry Sponge Cake
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-SSC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Strawberry Sponge Cake',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-SSC-EAC';
    PRINT 'Updated: SHP-SSC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-SSC-EAC', 'Strawberry Sponge Cake', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-SSC-EAC';
END
GO

-- SHP-STE-EAC - Eggless Trifle Sponge
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-STE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Eggless Trifle Sponge',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-STE-EAC';
    PRINT 'Updated: SHP-STE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-STE-EAC', 'Eggless Trifle Sponge', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-STE-EAC';
END
GO

-- SHP-TLB-EAC - DC Traingle Lotus Box
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-TLB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Traingle Lotus Box',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-TLB-EAC';
    PRINT 'Updated: SHP-TLB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-TLB-EAC', 'DC Traingle Lotus Box', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-TLB-EAC';
END
GO

-- SHP-TRI-EAC - Trifle Sponge
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-TRI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Trifle Sponge',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-TRI-EAC';
    PRINT 'Updated: SHP-TRI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-TRI-EAC', 'Trifle Sponge', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-TRI-EAC';
END
GO

-- SHP-VSA-EACH - DC Vegan Sweetmeats Assorted Authentic
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-VSA-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DC Vegan Sweetmeats Assorted Authentic',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SHP-VSA-EACH';
    PRINT 'Updated: SHP-VSA-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-VSA-EACH', 'DC Vegan Sweetmeats Assorted Authentic', 'shop front', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SHP-VSA-EACH';
END
GO

-- SHP-WIC-EAC - Christmas Windsor iced
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-WIC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Christmas Windsor iced',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-WIC-EAC';
    PRINT 'Updated: SHP-WIC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-WIC-EAC', 'Christmas Windsor iced', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-WIC-EAC';
END
GO

-- SHP-WIS-EAC - Windsor Slab
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-WIS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Windsor Slab',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-WIS-EAC';
    PRINT 'Updated: SHP-WIS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-WIS-EAC', 'Windsor Slab', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-WIS-EAC';
END
GO

-- SHP-WMV-EAC - Windsor Slice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'shop front';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'shop front' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-WMV-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Windsor Slice',
        Category = 'shop front',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-WMV-EAC';
    PRINT 'Updated: SHP-WMV-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-WMV-EAC', 'Windsor Slice', 'shop front', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-WMV-EAC';
END
GO

-- SNA-CHE-340 - DIWALI CHEVDA 250G
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-CHE-340')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'DIWALI CHEVDA 250G',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-CHE-340';
    PRINT 'Updated: SNA-CHE-340';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-CHE-340', 'DIWALI CHEVDA 250G', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-CHE-340';
END
GO

-- SNA-CHE-EAC - Maya Spices Chevda 250g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-CHE-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Maya Spices Chevda 250g',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-CHE-EAC';
    PRINT 'Updated: SNA-CHE-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-CHE-EAC', 'Maya Spices Chevda 250g', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-CHE-EAC';
END
GO

-- SNA-KMU-EAC - Kashmiri Murkoo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-KMU-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Kashmiri Murkoo',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-KMU-EAC';
    PRINT 'Updated: SNA-KMU-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-KMU-EAC', 'Kashmiri Murkoo', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-KMU-EAC';
END
GO

-- SNA-KNP-EAC - Kara Nichhas Peanuts
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-KNP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Kara Nichhas Peanuts',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-KNP-EAC';
    PRINT 'Updated: SNA-KNP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-KNP-EAC', 'Kara Nichhas Peanuts', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-KNP-EAC';
END
GO

-- SNA-LMP-EAC - Murkoo Extra Large Plain
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-LMP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Murkoo Extra Large Plain',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-LMP-EAC';
    PRINT 'Updated: SNA-LMP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-LMP-EAC', 'Murkoo Extra Large Plain', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-LMP-EAC';
END
GO

-- SNA-LMS-EAC - Murkoo Extra Large
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-LMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Murkoo Extra Large',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-LMS-EAC';
    PRINT 'Updated: SNA-LMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-LMS-EAC', 'Murkoo Extra Large', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-LMS-EAC';
END
GO

-- SNA-MOC-EAC - Murkoo Original Crunch
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-MOC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Murkoo Original Crunch',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-MOC-EAC';
    PRINT 'Updated: SNA-MOC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-MOC-EAC', 'Murkoo Original Crunch', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-MOC-EAC';
END
GO

-- SNA-MSF-EAC - Murkoo sticks flavoured
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-MSF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Murkoo sticks flavoured',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-MSF-EAC';
    PRINT 'Updated: SNA-MSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-MSF-EAC', 'Murkoo sticks flavoured', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-MSF-EAC';
END
GO

-- SNA-MUS-EAC - Murkoo Sticks
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-MUS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Murkoo Sticks',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-MUS-EAC';
    PRINT 'Updated: SNA-MUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-MUS-EAC', 'Murkoo Sticks', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-MUS-EAC';
END
GO

-- SNA-NUT-60G - ralphies nutties 60g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-NUT-60G')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'ralphies nutties 60g',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-NUT-60G';
    PRINT 'Updated: SNA-NUT-60G';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-NUT-60G', 'ralphies nutties 60g', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-NUT-60G';
END
GO

-- SNA-PGA-EAC - Papdi Ganthiya
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-PGA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Papdi Ganthiya',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-PGA-EAC';
    PRINT 'Updated: SNA-PGA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-PGA-EAC', 'Papdi Ganthiya', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-PGA-EAC';
END
GO

-- SNA-PNM-EAC - PNS Murkoo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-PNM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'PNS Murkoo',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-PNM-EAC';
    PRINT 'Updated: SNA-PNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-PNM-EAC', 'PNS Murkoo', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-PNM-EAC';
END
GO

-- SNA-PNM-EAC - PNS Murkoo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-PNM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'PNS Murkoo',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-PNM-EAC';
    PRINT 'Updated: SNA-PNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-PNM-EAC', 'PNS Murkoo', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-PNM-EAC';
END
GO

-- snA-PNM-EAC - Serve and Nuts 400g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'snA-PNM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Serve and Nuts 400g',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'snA-PNM-EAC';
    PRINT 'Updated: snA-PNM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('snA-PNM-EAC', 'Serve and Nuts 400g', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: snA-PNM-EAC';
END
GO

-- SNA-PNT-EAC - PNS Traditional Murkoo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-PNT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'PNS Traditional Murkoo',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-PNT-EAC';
    PRINT 'Updated: SNA-PNT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-PNT-EAC', 'PNS Traditional Murkoo', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-PNT-EAC';
END
GO

-- SNA-SAN-EAC - Serv & Nuts
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-SAN-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Serv & Nuts',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-SAN-EAC';
    PRINT 'Updated: SNA-SAN-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-SAN-EAC', 'Serv & Nuts', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-SAN-EAC';
END
GO

-- SNA-SGA-EAC - Soft Gantia
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-SGA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Soft Gantia',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-SGA-EAC';
    PRINT 'Updated: SNA-SGA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-SGA-EAC', 'Soft Gantia', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-SGA-EAC';
END
GO

-- SNA-SUS-EAC - Sugar Sticks
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-SUS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sugar Sticks',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-SUS-EAC';
    PRINT 'Updated: SNA-SUS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-SUS-EAC', 'Sugar Sticks', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-SUS-EAC';
END
GO

-- SNA-TMU-EAC - Tub Murkoo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'snacks';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'snacks' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SNA-TMU-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Tub Murkoo',
        Category = 'snacks',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SNA-TMU-EAC';
    PRINT 'Updated: SNA-TMU-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SNA-TMU-EAC', 'Tub Murkoo', 'snacks', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SNA-TMU-EAC';
END
GO

-- CEX-FRT-EAC - Ferrero
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CEX-FRT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Ferrero',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CEX-FRT-EAC';
    PRINT 'Updated: CEX-FRT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CEX-FRT-EAC', 'Ferrero', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: CEX-FRT-EAC';
END
GO

-- SHP-COC-KGR - Coconut Ice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SHP-COC-KGR')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut Ice',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'SHP-COC-KGR';
    PRINT 'Updated: SHP-COC-KGR';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SHP-COC-KGR', 'Coconut Ice', 'sweets', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: SHP-COC-KGR';
END
GO

-- SWE-ALC-EACH - Almond Cones
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-ALC-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Almond Cones',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-ALC-EACH';
    PRINT 'Updated: SWE-ALC-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-ALC-EACH', 'Almond Cones', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-ALC-EACH';
END
GO

-- SWE-BOR-EAC - Masala Bor
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-BOR-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Masala Bor',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-BOR-EAC';
    PRINT 'Updated: SWE-BOR-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-BOR-EAC', 'Masala Bor', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-BOR-EAC';
END
GO

-- SWE-CAC-EACK - Cashew Cones
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CAC-EACK')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Cashew Cones',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CAC-EACK';
    PRINT 'Updated: SWE-CAC-EACK';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CAC-EACK', 'Cashew Cones', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CAC-EACK';
END
GO

-- SWE-CCC-EAC - Chocolate Coconut Cluster
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CCC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Coconut Cluster',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CCC-EAC';
    PRINT 'Updated: SWE-CCC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CCC-EAC', 'Chocolate Coconut Cluster', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CCC-EAC';
END
GO

-- SWE-CCD-EAC - Caruchi Candy Dates
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CCD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Caruchi Candy Dates',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CCD-EAC';
    PRINT 'Updated: SWE-CCD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CCD-EAC', 'Caruchi Candy Dates', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CCD-EAC';
END
GO

-- SWE-CFW-EAC - China fruit sweet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CFW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'China fruit sweet',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CFW-EAC';
    PRINT 'Updated: SWE-CFW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CFW-EAC', 'China fruit sweet', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CFW-EAC';
END
GO

-- SWE-CHF-EAC - China Fruit
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CHF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'China Fruit',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CHF-EAC';
    PRINT 'Updated: SWE-CHF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CHF-EAC', 'China Fruit', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CHF-EAC';
END
GO

-- SWE-CHI-EAC - Chicks Violet
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CHI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chicks Violet',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CHI-EAC';
    PRINT 'Updated: SWE-CHI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CHI-EAC', 'Chicks Violet', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CHI-EAC';
END
GO

-- SWE-CMM-EAC - Choc Marshmallow
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CMM-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Choc Marshmallow',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CMM-EAC';
    PRINT 'Updated: SWE-CMM-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CMM-EAC', 'Choc Marshmallow', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CMM-EAC';
END
GO

-- SWE-CNI-EAC - Coconut Ice
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CNI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut Ice',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CNI-EAC';
    PRINT 'Updated: SWE-CNI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CNI-EAC', 'Coconut Ice', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CNI-EAC';
END
GO

-- SWE-CNW-EAC - Coconut Wheel
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CNW-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut Wheel',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CNW-EAC';
    PRINT 'Updated: SWE-CNW-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CNW-EAC', 'Coconut Wheel', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CNW-EAC';
END
GO

-- SWE-COI-EAC - Coconut ice small
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-COI-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Coconut ice small',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-COI-EAC';
    PRINT 'Updated: SWE-COI-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-COI-EAC', 'Coconut ice small', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-COI-EAC';
END
GO

-- SWE-CPC-EAC - Chocolate Peanut Cluster
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CPC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Peanut Cluster',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CPC-EAC';
    PRINT 'Updated: SWE-CPC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CPC-EAC', 'Chocolate Peanut Cluster', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CPC-EAC';
END
GO

-- SWE-CRO-EAC - Chocolate Rocher
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CRO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Rocher',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CRO-EAC';
    PRINT 'Updated: SWE-CRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CRO-EAC', 'Chocolate Rocher', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CRO-EAC';
END
GO

-- SWE-CRO-EAC - Chocolate Rocher
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CRO-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Chocolate Rocher',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CRO-EAC';
    PRINT 'Updated: SWE-CRO-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CRO-EAC', 'Chocolate Rocher', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CRO-EAC';
END
GO

-- SWE-CSP-EAC - Sour Punk Cola
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-CSP-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sour Punk Cola',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-CSP-EAC';
    PRINT 'Updated: SWE-CSP-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-CSP-EAC', 'Sour Punk Cola', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-CSP-EAC';
END
GO

-- SWE-FIG-EAC - Masala Figs
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-FIG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Masala Figs',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-FIG-EAC';
    PRINT 'Updated: SWE-FIG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-FIG-EAC', 'Masala Figs', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-FIG-EAC';
END
GO

-- SWE-KIT-EAC - Kitkat 135g
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-KIT-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Kitkat 135g',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-KIT-EAC';
    PRINT 'Updated: SWE-KIT-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-KIT-EAC', 'Kitkat 135g', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-KIT-EAC';
END
GO

-- SWE-MES-EAC - Mebos Sweets
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-MES-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Mebos Sweets',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-MES-EAC';
    PRINT 'Updated: SWE-MES-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-MES-EAC', 'Mebos Sweets', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-MES-EAC';
END
GO

-- SWE-PAA-EAC - Paan Cones
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-PAA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Paan Cones',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-PAA-EAC';
    PRINT 'Updated: SWE-PAA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-PAA-EAC', 'Paan Cones', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-PAA-EAC';
END
GO

-- SWE-PBS-EAC - Peanut Brittle Slabs Singles
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-PBS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Peanut Brittle Slabs Singles',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-PBS-EAC';
    PRINT 'Updated: SWE-PBS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-PBS-EAC', 'Peanut Brittle Slabs Singles', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-PBS-EAC';
END
GO

-- SWE-PEC-EAC - Peanut Cones
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-PEC-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Peanut Cones',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-PEC-EAC';
    PRINT 'Updated: SWE-PEC-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-PEC-EAC', 'Peanut Cones', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-PEC-EAC';
END
GO

-- SWE-PNB-EAC - peanut brittle
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-PNB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'peanut brittle',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-PNB-EAC';
    PRINT 'Updated: SWE-PNB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-PNB-EAC', 'peanut brittle', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-PNB-EAC';
END
GO

-- SWE-PNB-EACH - Peanut Brittle Slab 10s
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-PNB-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Peanut Brittle Slab 10s',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-PNB-EACH';
    PRINT 'Updated: SWE-PNB-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-PNB-EACH', 'Peanut Brittle Slab 10s', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-PNB-EACH';
END
GO

-- SWE-PNP-EACH - Peanut Brittle Pieces
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-PNP-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Peanut Brittle Pieces',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-PNP-EACH';
    PRINT 'Updated: SWE-PNP-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-PNP-EACH', 'Peanut Brittle Pieces', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-PNP-EACH';
END
GO

-- SWE-SAB-EACH - Almond Bar 40g single
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-SAB-EACH')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Almond Bar 40g single',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-SAB-EACH';
    PRINT 'Updated: SWE-SAB-EACH';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-SAB-EACH', 'Almond Bar 40g single', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-SAB-EACH';
END
GO

-- SWE-SPA-EAC - Sour Punk Apple
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-SPA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sour Punk Apple',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-SPA-EAC';
    PRINT 'Updated: SWE-SPA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-SPA-EAC', 'Sour Punk Apple', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-SPA-EAC';
END
GO

-- SWE-SPB-EAC - Sesame Brittle Pieces
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-SPB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sesame Brittle Pieces',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-SPB-EAC';
    PRINT 'Updated: SWE-SPB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-SPB-EAC', 'Sesame Brittle Pieces', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-SPB-EAC';
END
GO

-- SWE-SPS-EAC - Sour Punk
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-SPS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sour Punk',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-SPS-EAC';
    PRINT 'Updated: SWE-SPS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-SPS-EAC', 'Sour Punk', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-SPS-EAC';
END
GO

-- SWE-SSB-EAC - Sweet & Sour Bor
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-SSB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sweet & Sour Bor',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-SSB-EAC';
    PRINT 'Updated: SWE-SSB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-SSB-EAC', 'Sweet & Sour Bor', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-SSB-EAC';
END
GO

-- PAC-12X-EAC - 12x12x6
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-12X-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '12x12x6',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-12X-EAC';
    PRINT 'Updated: PAC-12X-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-12X-EAC', '12x12x6', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-12X-EAC';
END
GO

-- PAC-14X-EAC - 14X14X6
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-14X-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '14X14X6',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-14X-EAC';
    PRINT 'Updated: PAC-14X-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-14X-EAC', '14X14X6', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-14X-EAC';
END
GO

-- PAC-16X-EAC - 16x16x6
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-16X-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '16x16x6',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-16X-EAC';
    PRINT 'Updated: PAC-16X-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-16X-EAC', '16x16x6', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-16X-EAC';
END
GO

-- PAC-18X-EAC - 18X18X6
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-18X-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '18X18X6',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-18X-EAC';
    PRINT 'Updated: PAC-18X-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-18X-EAC', '18X18X6', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-18X-EAC';
END
GO

-- PAC-20X-EAC - 20X20X6
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-20X-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '20X20X6',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-20X-EAC';
    PRINT 'Updated: PAC-20X-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-20X-EAC', '20X20X6', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-20X-EAC';
END
GO

-- PAC-552-EAC - 5*5*2.5
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-552-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '5*5*2.5',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-552-EAC';
    PRINT 'Updated: PAC-552-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-552-EAC', '5*5*2.5', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-552-EAC';
END
GO

-- PAC-572-EAC - 5*5*2.5
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-572-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '5*5*2.5',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-572-EAC';
    PRINT 'Updated: PAC-572-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-572-EAC', '5*5*2.5', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-572-EAC';
END
GO

-- PAC-573-EAC - 5*7*3
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-573-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '5*7*3',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-573-EAC';
    PRINT 'Updated: PAC-573-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-573-EAC', '5*7*3', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-573-EAC';
END
GO

-- PAC-835-EAC - Bag 1000 83*54*300mm
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-835-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bag 1000 83*54*300mm',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-835-EAC';
    PRINT 'Updated: PAC-835-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-835-EAC', 'Bag 1000 83*54*300mm', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-835-EAC';
END
GO

-- SWE-SSF-EAC - Sweet & Sour Figs
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-SSF-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Sweet & Sour Figs',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-SSF-EAC';
    PRINT 'Updated: SWE-SSF-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-SSF-EAC', 'Sweet & Sour Figs', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-SSF-EAC';
END
GO

-- PAC-884-EAC - 8X8X4
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-884-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = '8X8X4',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-884-EAC';
    PRINT 'Updated: PAC-884-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-884-EAC', '8X8X4', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-884-EAC';
END
GO

-- PAC-BAG-EAC - Bags 1000 White Midi
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-BAG-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bags 1000 White Midi',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-BAG-EAC';
    PRINT 'Updated: PAC-BAG-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-BAG-EAC', 'Bags 1000 White Midi', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-BAG-EAC';
END
GO

-- PAC-BAG-JUM - Bags 1000 White Jumbo
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-BAG-JUM')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Bags 1000 White Jumbo',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-BAG-JUM';
    PRINT 'Updated: PAC-BAG-JUM';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-BAG-JUM', 'Bags 1000 White Jumbo', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-BAG-JUM';
END
GO

-- SWE-TOA-EAC - Toasted Jabs
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'sweets';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'sweet' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'SWE-TOA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Toasted Jabs',
        Category = 'sweets',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'SWE-TOA-EAC';
    PRINT 'Updated: SWE-TOA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('SWE-TOA-EAC', 'Toasted Jabs', 'sweets', @CatID, @SubCatID, 'External', 1);
    PRINT 'Inserted: SWE-TOA-EAC';
END
GO

-- CBW-CAK-003 - BD Buttercream 3 Tier Stacked
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Wedding Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Wedding Cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBW-CAK-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 3 Tier Stacked',
        Category = 'Wedding Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBW-CAK-003';
    PRINT 'Updated: CBW-CAK-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBW-CAK-003', 'BD Buttercream 3 Tier Stacked', 'Wedding Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBW-CAK-003';
END
GO

-- CBW-CKE-003 - BD Wedding Cake BC 10 12 14 Loose
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Wedding Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Wedding Cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBW-CKE-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Wedding Cake BC 10 12 14 Loose',
        Category = 'Wedding Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBW-CKE-003';
    PRINT 'Updated: CBW-CKE-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBW-CKE-003', 'BD Wedding Cake BC 10 12 14 Loose', 'Wedding Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBW-CKE-003';
END
GO

-- CBW-STA-EAC - BD Buttercream 2Tier Stacked 12 16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Wedding Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Wedding Cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CBW-STA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Buttercream 2Tier Stacked 12 16',
        Category = 'Wedding Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CBW-STA-EAC';
    PRINT 'Updated: CBW-STA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CBW-STA-EAC', 'BD Buttercream 2Tier Stacked 12 16', 'Wedding Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CBW-STA-EAC';
END
GO

-- CFW-CAF-002 - BD WC Fruit 2 Layer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Wedding Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Wedding Cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFW-CAF-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD WC Fruit 2 Layer',
        Category = 'Wedding Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFW-CAF-002';
    PRINT 'Updated: CFW-CAF-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFW-CAF-002', 'BD WC Fruit 2 Layer', 'Wedding Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFW-CAF-002';
END
GO

-- CFW-CAF-003 - BD WC Fruit 3 Layer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Wedding Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Wedding Cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFW-CAF-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD WC Fruit 3 Layer',
        Category = 'Wedding Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFW-CAF-003';
    PRINT 'Updated: CFW-CAF-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFW-CAF-003', 'BD WC Fruit 3 Layer', 'Wedding Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFW-CAF-003';
END
GO

-- CFW-CAF-003 - BD WC Fruit 3 Layer
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Wedding Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Wedding Cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFW-CAF-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD WC Fruit 3 Layer',
        Category = 'Wedding Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFW-CAF-003';
    PRINT 'Updated: CFW-CAF-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFW-CAF-003', 'BD WC Fruit 3 Layer', 'Wedding Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFW-CAF-003';
END
GO

-- PAC-PFB-EAC - Platter base
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-PFB-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter base',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-PFB-EAC';
    PRINT 'Updated: PAC-PFB-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-PFB-EAC', 'Platter base', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-PFB-EAC';
END
GO

-- PAC-PLD-EAC - Platter Dome
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'PAC-PLD-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Platter Dome',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'PAC-PLD-EAC';
    PRINT 'Updated: PAC-PLD-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('PAC-PLD-EAC', 'Platter Dome', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: PAC-PLD-EAC';
END
GO

-- ZFO-NS2-EAC - NS12
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'ZFO-NS2-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'NS12',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'ZFO-NS2-EAC';
    PRINT 'Updated: ZFO-NS2-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('ZFO-NS2-EAC', 'NS12', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: ZFO-NS2-EAC';
END
GO

-- ZFO-S16-EAC - KS16
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'ZFO-S16-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'KS16',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'ZFO-S16-EAC';
    PRINT 'Updated: ZFO-S16-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('ZFO-S16-EAC', 'KS16', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: ZFO-S16-EAC';
END
GO

-- ZFO-S18-EAC - KS18
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'ZFO-S18-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'KS18',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'ZFO-S18-EAC';
    PRINT 'Updated: ZFO-S18-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('ZFO-S18-EAC', 'KS18', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: ZFO-S18-EAC';
END
GO

-- ZFO-S20-EAC - KS20
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'packaging';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'packaging' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'ZFO-S20-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'KS20',
        Category = 'packaging',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'ZFO-S20-EAC';
    PRINT 'Updated: ZFO-S20-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('ZFO-S20-EAC', 'KS20', 'packaging', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: ZFO-S20-EAC';
END
GO

-- CFW-CKE-003 - BD Wedding Cake FC 10 12 14 Loose
DECLARE @CatID INT, @SubCatID INT;
SELECT @CatID = CategoryID FROM Categories WHERE CategoryName = 'Wedding Cakes';
SELECT @SubCatID = SubCategoryID FROM SubCategories WHERE SubCategoryName = 'Wedding Cakes' AND CategoryID = @CatID;

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CFW-CKE-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'BD Wedding Cake FC 10 12 14 Loose',
        Category = 'Wedding Cakes',
        CategoryID = @CatID,
        SubCategoryID = @SubCatID,
        ProductType = 'Internal',
        IsActive = 1
    WHERE SKU = 'CFW-CKE-003';
    PRINT 'Updated: CFW-CKE-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CFW-CKE-003', 'BD Wedding Cake FC 10 12 14 Loose', 'Wedding Cakes', @CatID, @SubCatID, 'Internal', 1);
    PRINT 'Inserted: CFW-CKE-003';
END
GO

COMMIT TRANSACTION;

PRINT 'Product import completed!';
PRINT 'Total POS products processed: 962';
PRINT 'Total Internal products: 1126';

-- Show results
SELECT CategoryID, Category, ProductType, COUNT(*) AS ProductCount
FROM Demo_Retail_Product
WHERE IsActive = 1
GROUP BY CategoryID, Category, ProductType
ORDER BY Category, ProductType;

