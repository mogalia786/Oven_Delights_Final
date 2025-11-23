-- Fix ReOrderBookLines foreign key to point to Products table instead of Demo_Retail_Product

-- Drop existing foreign key if it exists
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ReOrderBookLines_Demo_Retail_Product')
BEGIN
    ALTER TABLE ReOrderBookLines DROP CONSTRAINT FK_ReOrderBookLines_Demo_Retail_Product
    PRINT 'Dropped FK_ReOrderBookLines_Demo_Retail_Product'
END

-- Delete orphaned records (ProductIDs that don't exist in Products table)
DELETE FROM ReOrderBookLines 
WHERE ProductID NOT IN (SELECT ProductID FROM Products)
PRINT 'Deleted orphaned ReOrderBookLines records'

-- Add new foreign key to Products table
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_ReOrderBookLines_Products')
BEGIN
    ALTER TABLE ReOrderBookLines 
    ADD CONSTRAINT FK_ReOrderBookLines_Products 
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
    PRINT 'Added FK_ReOrderBookLines_Products'
END

-- Add Barcode column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('ReOrderBookLines') AND name = 'Barcode')
BEGIN
    ALTER TABLE ReOrderBookLines ADD Barcode NVARCHAR(100)
    PRINT 'Added Barcode column'
END

PRINT 'ReOrderBookLines foreign key fixed successfully'
