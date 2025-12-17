-- Move all candle subcategory items to main Candle category
-- Generated: 2025-12-07 01:41:33

BEGIN TRANSACTION;

-- CAN-CMS-EAC - Candles 10s- Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-CMS-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candles 10s- Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-CMS-EAC';
    PRINT 'Updated: CAN-CMS-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-CMS-EAC', 'Candles 10s- Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-CMS-EAC';
END
GO

-- CAN-DOU-010 - Candle Numeral Double
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-DOU-010')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral Double',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-DOU-010';
    PRINT 'Updated: CAN-DOU-010';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-DOU-010', 'Candle Numeral Double', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-DOU-010';
END
GO

-- CAN-DOU-080 - Candle Numeral Double
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-DOU-080')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral Double',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-DOU-080';
    PRINT 'Updated: CAN-DOU-080';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-DOU-080', 'Candle Numeral Double', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-DOU-080';
END
GO

-- CAN-GOL-000 - Candle Numeral 0 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-000';
    PRINT 'Updated: CAN-GOL-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-000', 'Candle Numeral 0 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-000';
END
GO

-- CAN-GOL-001 - Candle Numeral 1 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-001';
    PRINT 'Updated: CAN-GOL-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-001', 'Candle Numeral 1 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-001';
END
GO

-- CAN-GOL-002 - Candle Numeral 2 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-002';
    PRINT 'Updated: CAN-GOL-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-002', 'Candle Numeral 2 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-002';
END
GO

-- CAN-GOL-003 - Candle Numeral 3 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-003';
    PRINT 'Updated: CAN-GOL-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-003', 'Candle Numeral 3 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-003';
END
GO

-- CAN-GOL-004 - Candle Numeral 4 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-004';
    PRINT 'Updated: CAN-GOL-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-004', 'Candle Numeral 4 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-004';
END
GO

-- CAN-GOL-005 - Candle Numeral 5 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-005';
    PRINT 'Updated: CAN-GOL-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-005', 'Candle Numeral 5 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-005';
END
GO

-- CAN-GOL-006 - Candle Numeral 6 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-006';
    PRINT 'Updated: CAN-GOL-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-006', 'Candle Numeral 6 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-006';
END
GO

-- CAN-GOL-007 - Candle Numeral 7 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-007';
    PRINT 'Updated: CAN-GOL-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-007', 'Candle Numeral 7 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-007';
END
GO

-- CAN-GOL-008 - Candle Numeral 8 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-008')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 8 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-008';
    PRINT 'Updated: CAN-GOL-008';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-008', 'Candle Numeral 8 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-008';
END
GO

-- CAN-GOL-009 - Candle Numeral 9 Gold
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-GOL-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 Gold',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-GOL-009';
    PRINT 'Updated: CAN-GOL-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-GOL-009', 'Candle Numeral 9 Gold', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-GOL-009';
END
GO

-- CAN-MAG-24S - Candle Magic Assorted
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-MAG-24S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Magic Assorted',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-MAG-24S';
    PRINT 'Updated: CAN-MAG-24S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-MAG-24S', 'Candle Magic Assorted', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-MAG-24S';
END
GO

-- CAN-MCA-EAC - Magic Candles
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-MCA-EAC')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Magic Candles',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-MCA-EAC';
    PRINT 'Updated: CAN-MCA-EAC';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-MCA-EAC', 'Magic Candles', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-MCA-EAC';
END
GO

-- CAN-MIX-24S - Candle Mixed - 24x24
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-MIX-24S')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Mixed - 24x24',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-MIX-24S';
    PRINT 'Updated: CAN-MIX-24S';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-MIX-24S', 'Candle Mixed - 24x24', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-MIX-24S';
END
GO

-- CAN-RAI-000 - Candle Numeral 0 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-000';
    PRINT 'Updated: CAN-RAI-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-000', 'Candle Numeral 0 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-000';
END
GO

-- CAN-RAI-001 - Candle Numeral 1 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-001';
    PRINT 'Updated: CAN-RAI-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-001', 'Candle Numeral 1 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-001';
END
GO

-- CAN-RAI-002 - Candle Numeral 2 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-002';
    PRINT 'Updated: CAN-RAI-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-002', 'Candle Numeral 2 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-002';
END
GO

-- CAN-RAI-003 - Candle Numeral 3 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-003';
    PRINT 'Updated: CAN-RAI-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-003', 'Candle Numeral 3 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-003';
END
GO

-- CAN-RAI-004 - Candle Numeral 4 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-004';
    PRINT 'Updated: CAN-RAI-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-004', 'Candle Numeral 4 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-004';
END
GO

-- CAN-RAI-005 - Candle Numeral 5 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-005';
    PRINT 'Updated: CAN-RAI-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-005', 'Candle Numeral 5 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-005';
END
GO

-- CAN-RAI-006 - Candle Numeral 6 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-006';
    PRINT 'Updated: CAN-RAI-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-006', 'Candle Numeral 6 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-006';
END
GO

-- CAN-RAI-007 - Candle Numeral 7 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-007';
    PRINT 'Updated: CAN-RAI-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-007', 'Candle Numeral 7 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-007';
END
GO

-- CAN-RAI-009 - Candle Numeral 9 Rainbow
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-RAI-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 Rainbow',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-RAI-009';
    PRINT 'Updated: CAN-RAI-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-RAI-009', 'Candle Numeral 9 Rainbow', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-RAI-009';
END
GO

-- CAN-SIL-000 - Candle Numeral 0 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-000';
    PRINT 'Updated: CAN-SIL-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-000', 'Candle Numeral 0 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-000';
END
GO

-- CAN-SIL-001 - Candle Numeral 1 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-001';
    PRINT 'Updated: CAN-SIL-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-001', 'Candle Numeral 1 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-001';
END
GO

-- CAN-SIL-002 - Candle Numeral 2 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-002';
    PRINT 'Updated: CAN-SIL-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-002', 'Candle Numeral 2 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-002';
END
GO

-- CAN-SIL-003 - Candle Numeral 3 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-003';
    PRINT 'Updated: CAN-SIL-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-003', 'Candle Numeral 3 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-003';
END
GO

-- CAN-SIL-004 - Candle Numeral 4 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-004';
    PRINT 'Updated: CAN-SIL-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-004', 'Candle Numeral 4 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-004';
END
GO

-- CAN-SIL-005 - Candle Numeral 5 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-005';
    PRINT 'Updated: CAN-SIL-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-005', 'Candle Numeral 5 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-005';
END
GO

-- CAN-SIL-006 - Candle Numeral 6 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-006';
    PRINT 'Updated: CAN-SIL-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-006', 'Candle Numeral 6 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-006';
END
GO

-- CAN-SIL-007 - Candle Numeral 7 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-007';
    PRINT 'Updated: CAN-SIL-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-007', 'Candle Numeral 7 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-007';
END
GO

-- CAN-SIL-008 - Candle Numeral 8 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-008')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 8 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-008';
    PRINT 'Updated: CAN-SIL-008';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-008', 'Candle Numeral 8 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-008';
END
GO

-- CAN-SIL-009 - Candle Numeral 9 Silver
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-SIL-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 Silver',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-SIL-009';
    PRINT 'Updated: CAN-SIL-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-SIL-009', 'Candle Numeral 9 Silver', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-SIL-009';
END
GO

-- CAN-WHI-000 - Candle Numeral 0 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-000')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 0 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-000';
    PRINT 'Updated: CAN-WHI-000';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-000', 'Candle Numeral 0 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-000';
END
GO

-- CAN-WHI-001 - Candle Numeral 1 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-001')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 1 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-001';
    PRINT 'Updated: CAN-WHI-001';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-001', 'Candle Numeral 1 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-001';
END
GO

-- CAN-WHI-002 - Candle Numeral 2 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-002')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 2 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-002';
    PRINT 'Updated: CAN-WHI-002';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-002', 'Candle Numeral 2 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-002';
END
GO

-- CAN-WHI-003 - Candle Numeral 3 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-003')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 3 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-003';
    PRINT 'Updated: CAN-WHI-003';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-003', 'Candle Numeral 3 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-003';
END
GO

-- CAN-WHI-004 - Candle Numeral 4 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-004')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 4 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-004';
    PRINT 'Updated: CAN-WHI-004';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-004', 'Candle Numeral 4 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-004';
END
GO

-- CAN-WHI-005 - Candle Numeral 5 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-005')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 5 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-005';
    PRINT 'Updated: CAN-WHI-005';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-005', 'Candle Numeral 5 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-005';
END
GO

-- CAN-WHI-006 - Candle Numeral 6 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-006')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 6 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-006';
    PRINT 'Updated: CAN-WHI-006';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-006', 'Candle Numeral 6 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-006';
END
GO

-- CAN-WHI-007 - Candle Numeral 7 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-007')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 7 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-007';
    PRINT 'Updated: CAN-WHI-007';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-007', 'Candle Numeral 7 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-007';
END
GO

-- CAN-WHI-008 - Candle Numeral 8 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-008')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 8 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-008';
    PRINT 'Updated: CAN-WHI-008';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-008', 'Candle Numeral 8 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-008';
END
GO

-- CAN-WHI-009 - Candle Numeral 9 White
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'CAN-WHI-009')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Numeral 9 White',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'CAN-WHI-009';
    PRINT 'Updated: CAN-WHI-009';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('CAN-WHI-009', 'Candle Numeral 9 White', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: CAN-WHI-009';
END
GO

-- MIS-CSA-(6S) - Candle Assorted Sparkle (6s)
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CSA-(6S)')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Assorted Sparkle (6s)',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-CSA-(6S)';
    PRINT 'Updated: MIS-CSA-(6S)';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CSA-(6S)', 'Candle Assorted Sparkle (6s)', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: MIS-CSA-(6S)';
END
GO

-- MIS-CSG-(6s) - Candle Sparkle Gold (6s)
DECLARE @CandleCatID INT;
SELECT @CandleCatID = CategoryID FROM Categories WHERE LOWER(CategoryName) = 'candle';

IF EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE SKU = 'MIS-CSG-(6s)')
BEGIN
    UPDATE Demo_Retail_Product SET
        Name = 'Candle Sparkle Gold (6s)',
        Category = 'candle',
        CategoryID = @CandleCatID,
        SubCategoryID = NULL,
        ProductType = 'External',
        IsActive = 1
    WHERE SKU = 'MIS-CSG-(6s)';
    PRINT 'Updated: MIS-CSG-(6s)';
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Product (SKU, Name, Category, CategoryID, SubCategoryID, ProductType, IsActive)
    VALUES ('MIS-CSG-(6s)', 'Candle Sparkle Gold (6s)', 'candle', @CandleCatID, NULL, 'External', 1);
    PRINT 'Inserted: MIS-CSG-(6s)';
END
GO

COMMIT TRANSACTION;

PRINT 'Candle products moved to main category!';
PRINT 'Total Candle products processed: 47';

-- Show results
SELECT COUNT(*) AS TotalCandleProducts
FROM Demo_Retail_Product
WHERE Category = 'candle' AND IsActive = 1;

