-- Fix BOM tables to reference Demo_Retail_Product instead of Products
-- Step 1: Add Recipe_Created field to Demo_Retail_Product
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'Recipe_Created')
BEGIN
    ALTER TABLE Demo_Retail_Product ADD Recipe_Created BIT NULL DEFAULT 0;
    PRINT 'Added Recipe_Created column to Demo_Retail_Product';
END
GO

-- Step 2: Clean up orphaned BOM records (ProductIDs that don't exist in Demo_Retail_Product)
DELETE FROM BOM_Lines 
WHERE BOMID IN (
    SELECT BOMID FROM BOM_Header 
    WHERE ProductID NOT IN (SELECT ProductID FROM Demo_Retail_Product)
);

DELETE FROM BOM_Header 
WHERE ProductID NOT IN (SELECT ProductID FROM Demo_Retail_Product);

PRINT 'Cleaned up orphaned BOM records';
GO

-- Step 3: Drop existing foreign key constraints
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_BOM_Product')
BEGIN
    ALTER TABLE BOM_Header DROP CONSTRAINT FK_BOM_Product;
    PRINT 'Dropped FK_BOM_Product constraint';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_BOMLines_Product')
BEGIN
    ALTER TABLE BOM_Lines DROP CONSTRAINT FK_BOMLines_Product;
    PRINT 'Dropped FK_BOMLines_Product constraint';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_BOM_DemoRetailProduct')
BEGIN
    ALTER TABLE BOM_Header DROP CONSTRAINT FK_BOM_DemoRetailProduct;
    PRINT 'Dropped FK_BOM_DemoRetailProduct constraint';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_BOMLines_DemoRetailProduct')
BEGIN
    ALTER TABLE BOM_Lines DROP CONSTRAINT FK_BOMLines_DemoRetailProduct;
    PRINT 'Dropped FK_BOMLines_DemoRetailProduct constraint';
END
GO

-- Step 4: Add new foreign key constraint ONLY to BOM_Header
-- Do NOT add FK to BOM_Lines.ItemID because items can be from different tables (ingredients, sub-recipes, etc.)
ALTER TABLE BOM_Header 
ADD CONSTRAINT FK_BOM_DemoRetailProduct 
FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID);

PRINT 'BOM foreign keys updated successfully - BOM_Header references Demo_Retail_Product';
PRINT 'BOM_Lines.ItemID has NO foreign key constraint (stores items from multiple sources)';
GO
