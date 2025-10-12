-- =============================================
-- Make CategoryID and SubcategoryID Nullable in Products Table
-- To avoid FK constraint errors when categories don't exist
-- =============================================

-- Check if FK constraint exists and drop it temporarily
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Products_Category')
BEGIN
    ALTER TABLE Products DROP CONSTRAINT FK_Products_Category;
    PRINT '✓ Dropped FK_Products_Category constraint';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Products_Subcategory')
BEGIN
    ALTER TABLE Products DROP CONSTRAINT FK_Products_Subcategory;
    PRINT '✓ Dropped FK_Products_Subcategory constraint';
END

-- Make columns nullable
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CategoryID' AND is_nullable = 0)
BEGIN
    ALTER TABLE Products ALTER COLUMN CategoryID INT NULL;
    PRINT '✓ Made CategoryID nullable';
END

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'SubcategoryID' AND is_nullable = 0)
BEGIN
    ALTER TABLE Products ALTER COLUMN SubcategoryID INT NULL;
    PRINT '✓ Made SubcategoryID nullable';
END

-- Recreate FK constraints with ON DELETE SET NULL
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Products_Category')
BEGIN
    ALTER TABLE Products 
    ADD CONSTRAINT FK_Products_Category 
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) 
    ON DELETE SET NULL;
    PRINT '✓ Recreated FK_Products_Category with ON DELETE SET NULL';
END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Products_Subcategory')
BEGIN
    ALTER TABLE Products 
    ADD CONSTRAINT FK_Products_Subcategory 
    FOREIGN KEY (SubcategoryID) REFERENCES Subcategories(SubcategoryID) 
    ON DELETE SET NULL;
    PRINT '✓ Recreated FK_Products_Subcategory with ON DELETE SET NULL';
END

GO

PRINT 'Category columns made nullable - FK constraints updated';
