-- Manual Import Script for Demo_Retail Tables
-- This script imports data from CSV into Demo_Retail_Product, Demo_Retail_Price, Demo_Retail_Stock
-- Uses Code field to generate barcodes where needed

USE OvenDelightsERP;
GO

-- Step 1: Insert products into Demo_Retail_Product
-- Format: (Code, Name, Description, ProductType, ExternalBarcode, IsActive)
-- ProductType: 'Internal' or 'External'
-- ExternalBarcode: Only for external products that have real barcodes

PRINT 'Inserting products into Demo_Retail_Product...';
GO

-- Example format (you'll need to convert CSV data to this format):
-- INSERT INTO Demo_Retail_Product (Code, Name, Description, ProductType, ExternalBarcode, IsActive, CreatedAt)
-- VALUES 
-- ('BD-BAR-020', 'BD Bar One Square 20', 'BD Bar One Square 20', 'Internal', NULL, 1, GETDATE()),
-- ('CAN-CMS-EAC', 'Candles 10s- Silver', 'Candles 10s- Silver', 'External', '0', 1, GETDATE());

-- PASTE YOUR INSERT STATEMENTS HERE FROM CSV CONVERSION


-- Step 2: Create default variants for all products
PRINT 'Creating default variants...';
GO

INSERT INTO Demo_Retail_Variant (ProductID, VariantName, IsDefault, CreatedAt)
SELECT 
    ProductID,
    'Default' AS VariantName,
    1 AS IsDefault,
    GETDATE() AS CreatedAt
FROM Demo_Retail_Product
WHERE NOT EXISTS (
    SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = Demo_Retail_Product.ProductID
);
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' variants created.';
GO

-- Step 3: Insert pricing for OD200 (BranchID = 6)
PRINT 'Inserting pricing for OD200...';
GO

-- Example format:
-- INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, CreatedAt)
-- SELECT ProductID, 6, 1800, 0, GETDATE() FROM Demo_Retail_Product WHERE Code = 'BD-BAR-020';

-- PASTE YOUR OD200 PRICING STATEMENTS HERE


-- Step 4: Insert pricing for OD400 (BranchID = 4)
PRINT 'Inserting pricing for OD400...';
GO

-- Example format:
-- INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, CreatedAt)
-- SELECT ProductID, 4, 1600, 0, GETDATE() FROM Demo_Retail_Product WHERE Code = 'BD-BAR-020';

-- PASTE YOUR OD400 PRICING STATEMENTS HERE


-- Step 5: Create stock records for OD200 (BranchID = 6)
PRINT 'Creating stock records for OD200...';
GO

INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, LastUpdated)
SELECT 
    v.VariantID,
    6 AS BranchID,
    0 AS QtyOnHand,
    GETDATE() AS LastUpdated
FROM Demo_Retail_Variant v
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
WHERE v.IsDefault = 1
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Stock 
        WHERE VariantID = v.VariantID AND BranchID = 6
    );
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' stock records created for OD200.';
GO

-- Step 6: Create stock records for OD400 (BranchID = 4)
PRINT 'Creating stock records for OD400...';
GO

INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, LastUpdated)
SELECT 
    v.VariantID,
    4 AS BranchID,
    0 AS QtyOnHand,
    GETDATE() AS LastUpdated
FROM Demo_Retail_Variant v
INNER JOIN Demo_Retail_Product p ON v.ProductID = p.ProductID
WHERE v.IsDefault = 1
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Stock 
        WHERE VariantID = v.VariantID AND BranchID = 4
    );
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' stock records created for OD400.';
GO

-- Step 7: Update SKU field with generated barcodes
PRINT 'Generating barcodes from Code field...';
GO

UPDATE Demo_Retail_Product
SET SKU = CASE 
    -- External products: use ExternalBarcode if it exists and is not '0'
    WHEN ProductType = 'External' AND ExternalBarcode IS NOT NULL AND ExternalBarcode != '0' THEN ExternalBarcode
    -- Internal products: generate barcode from Code (2 + 8-digit padded)
    WHEN ProductType = 'Internal' AND Code IS NOT NULL AND Code != '' THEN '2' + RIGHT('00000000' + REPLACE(Code, '-', ''), 8)
    ELSE NULL
END
WHERE SKU IS NULL OR SKU = '';
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' barcodes generated.';
GO

-- Step 8: Summary
PRINT '';
PRINT '=== IMPORT SUMMARY ===';

DECLARE @ProductCount INT, @VariantCount INT, @PriceCount INT, @StockCount INT;

SELECT @ProductCount = COUNT(*) FROM Demo_Retail_Product;
SELECT @VariantCount = COUNT(*) FROM Demo_Retail_Variant;
SELECT @PriceCount = COUNT(*) FROM Demo_Retail_Price;
SELECT @StockCount = COUNT(*) FROM Demo_Retail_Stock;

PRINT 'Products: ' + CAST(@ProductCount AS NVARCHAR(10));
PRINT 'Variants: ' + CAST(@VariantCount AS NVARCHAR(10));
PRINT 'Price Records: ' + CAST(@PriceCount AS NVARCHAR(10));
PRINT 'Stock Records: ' + CAST(@StockCount AS NVARCHAR(10));
PRINT '';
PRINT 'Import completed!';
GO
