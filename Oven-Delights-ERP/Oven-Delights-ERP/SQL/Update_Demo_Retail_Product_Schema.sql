-- Update Demo_Retail_Product table structure
-- Add Code field for barcode generation and Is_VTable flag

USE OvenDelightsERP;
GO

-- First, clear all data from Demo tables for fresh start (in correct order due to FK constraints)
DELETE FROM ReturnLineItems;
DELETE FROM POS_InvoiceLines;
DELETE FROM Demo_ReturnDetails;
DELETE FROM Demo_Retail_ProductImage;
DELETE FROM Demo_Retail_Stock;
DELETE FROM Demo_Retail_Price;
DELETE FROM Demo_Retail_Variant;
DELETE FROM Demo_Retail_Product;
GO

-- Add new columns to Demo_Retail_Product if they don't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'Code')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD Code NVARCHAR(50) NULL;
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'Is_VTable')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD Is_VTable BIT NOT NULL DEFAULT 1;
END
GO

-- Add ProductType field to distinguish Internal/External/RawMaterial
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'ProductType')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD ProductType NVARCHAR(20) NULL; -- 'Internal', 'External', 'RawMaterial'
END
GO

-- Add ExternalBarcode field for products that already have barcodes
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'ExternalBarcode')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD ExternalBarcode NVARCHAR(50) NULL;
END
GO

-- Add index on Code for faster lookups
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Demo_Retail_Product_Code' AND object_id = OBJECT_ID('Demo_Retail_Product'))
BEGIN
    CREATE INDEX IX_Demo_Retail_Product_Code ON Demo_Retail_Product(Code);
END
GO

-- Add SellingPriceExVAT field to Demo_Retail_Price for VAT calculations
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Price') AND name = 'SellingPriceExVAT')
BEGIN
    ALTER TABLE Demo_Retail_Price
    ADD SellingPriceExVAT DECIMAL(18,2) NULL;
END
GO

-- Update existing records to calculate ExVAT from InclVAT (divide by 1.15)
UPDATE Demo_Retail_Price
SET SellingPriceExVAT = ROUND(SellingPrice / 1.15, 2)
WHERE SellingPriceExVAT IS NULL AND SellingPrice > 0;
GO

PRINT 'Demo_Retail_Product schema updated successfully.';
PRINT 'Demo_Retail_Price now includes SellingPriceExVAT column.';
PRINT 'All Demo_ tables cleared for fresh data.';
GO
