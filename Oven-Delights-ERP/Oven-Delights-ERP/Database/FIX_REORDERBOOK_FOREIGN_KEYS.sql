-- Fix ReOrderBook tables to reference Demo_Retail_Product instead of Products

-- Step 1: Clean up orphaned ReOrderBook records (ProductIDs that don't exist in Demo_Retail_Product)
DELETE FROM ReOrderBookLines 
WHERE ProductID NOT IN (SELECT ProductID FROM Demo_Retail_Product);

PRINT 'Cleaned up orphaned ReOrderBookLines records';
GO

-- Step 2: Drop existing foreign key constraints on ReOrderBookLines
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ReOrderBookLines_Products')
BEGIN
    ALTER TABLE ReOrderBookLines DROP CONSTRAINT FK_ReOrderBookLines_Products;
    PRINT 'Dropped FK_ReOrderBookLines_Products constraint';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ReOrderBookLines_Product')
BEGIN
    ALTER TABLE ReOrderBookLines DROP CONSTRAINT FK_ReOrderBookLines_Product;
    PRINT 'Dropped FK_ReOrderBookLines_Product constraint';
END

IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ReOrderBookLines_DemoRetailProduct')
BEGIN
    ALTER TABLE ReOrderBookLines DROP CONSTRAINT FK_ReOrderBookLines_DemoRetailProduct;
    PRINT 'Dropped FK_ReOrderBookLines_DemoRetailProduct constraint';
END
GO

-- Step 3: Add new foreign key constraint to Demo_Retail_Product
ALTER TABLE ReOrderBookLines 
ADD CONSTRAINT FK_ReOrderBookLines_DemoRetailProduct 
FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID);

PRINT 'ReOrderBookLines foreign key updated to reference Demo_Retail_Product successfully';
GO
