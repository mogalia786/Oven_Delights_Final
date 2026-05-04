-- Import Script with Batching (Max 1000 rows per INSERT)
-- NOTE: Connect to OvenDelightsERP database before running this script

-- =====================================================
-- STEP 1: Create Staging Table
-- =====================================================
PRINT 'Creating staging table...';

IF OBJECT_ID('tempdb..#StagingImport') IS NOT NULL DROP TABLE #StagingImport;
CREATE TABLE #StagingImport (
    Cost DECIMAL(18,4),
    Warehouse NVARCHAR(50),
    Ingredients NVARCHAR(MAX),
    ItemDescription NVARCHAR(500),
    Category NVARCHAR(100),
    ItemCategory NVARCHAR(50),
    Barcode NVARCHAR(50),
    ItemDescription2 NVARCHAR(500),
    Col9 NVARCHAR(50),
    ItemCode NVARCHAR(50),
    InclPrice DECIMAL(18,2),
    Treatment NVARCHAR(50),
    Branch NVARCHAR(100)
);

PRINT 'Staging table created.';
GO

-- =====================================================
-- STEP 2: PASTE YOUR DATA HERE IN BATCHES OF 1000 ROWS
-- =====================================================
-- IMPORTANT: Split your INSERT statements into batches of 1000 rows or less
-- Example format:

-- BATCH 1 (Rows 1-1000)
INSERT INTO #StagingImport (Cost, Warehouse, Ingredients, ItemDescription, Category, ItemCategory, Barcode, ItemDescription2, Col9, ItemCode, InclPrice, Treatment, Branch)
VALUES
-- Paste first 1000 rows here
(0.0000, 'OD200', NULL, 'BD Bar One Square 20', 'exotic', 'internal', NULL, 'BD Bar One Square 20', NULL, 'BD-BAR-020', 1800.00, NULL, 'OD200 - Ayesha Centre')
-- Add more rows (up to 1000 total)
;
GO

PRINT 'Batch 1 loaded.';
GO

-- BATCH 2 (Rows 1001-2000)
-- INSERT INTO #StagingImport (Cost, Warehouse, Ingredients, ItemDescription, Category, ItemCategory, Barcode, ItemDescription2, Col9, ItemCode, InclPrice, Treatment, Branch)
-- VALUES
-- Paste next 1000 rows here
-- ;
-- GO

-- PRINT 'Batch 2 loaded.';
-- GO

-- Continue with additional batches as needed...

-- =====================================================
-- STEP 3: Process and Import
-- =====================================================
PRINT 'Processing data...';

-- Add computed columns
ALTER TABLE #StagingImport ADD TreatmentType NVARCHAR(50);
ALTER TABLE #StagingImport ADD ProductType NVARCHAR(50);
ALTER TABLE #StagingImport ADD BranchID INT;
ALTER TABLE #StagingImport ADD ExVATPrice DECIMAL(18,2);

-- Classify products
UPDATE #StagingImport
SET 
    TreatmentType = CASE 
        WHEN LOWER(Category) IN ('ingredients', 'ingredient') THEN 'RawMaterial'
        WHEN LOWER(Category) IN ('buttercream', 'sub recipe', 'subrecipe') THEN 'SubComponent'
        WHEN LOWER(Category) IN ('consumables', 'miscellaneous', 'packaging', 'equipment') THEN 'Accessory'
        ELSE 'FinishedProduct'
    END,
    ProductType = CASE 
        WHEN LOWER(ItemCategory) = 'external' THEN 'External'
        ELSE 'Internal'
    END,
    BranchID = CASE 
        WHEN Warehouse = 'OD200' THEN 6
        WHEN Warehouse = 'OD400' THEN 4
        ELSE NULL
    END,
    ExVATPrice = ROUND(InclPrice / 1.15, 2);

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' records classified.';
GO

-- Import to Demo_Retail_Product
PRINT 'Importing products...';

INSERT INTO Demo_Retail_Product (Code, Name, Description, ProductType, ExternalBarcode, SKU, IsActive, CreatedAt)
SELECT DISTINCT
    s.ItemCode,
    s.ItemDescription,
    s.ItemDescription,
    s.ProductType,
    CASE WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' AND s.Barcode != '' THEN s.Barcode ELSE NULL END,
    CASE 
        WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' AND s.Barcode != '' THEN s.Barcode
        WHEN s.ProductType = 'Internal' THEN '2' + RIGHT('00000000' + REPLACE(REPLACE(REPLACE(s.ItemCode, '-', ''), ' ', ''), '.', ''), 8)
        ELSE NULL
    END,
    1,
    GETDATE()
FROM #StagingImport s
WHERE s.ItemCode IS NOT NULL 
    AND s.ItemCode != ''
    AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE Code = s.ItemCode);

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' products imported.';
GO

-- Create variants
PRINT 'Creating variants...';

-- Check if IsDefault column exists and add if missing
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Variant') AND name = 'IsDefault')
BEGIN
    ALTER TABLE Demo_Retail_Variant ADD IsDefault BIT NULL DEFAULT 1;
    PRINT 'Added IsDefault column to Demo_Retail_Variant.';
END

INSERT INTO Demo_Retail_Variant (ProductID, IsDefault, CreatedAt)
SELECT ProductID, 1, GETDATE()
FROM Demo_Retail_Product
WHERE NOT EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = Demo_Retail_Product.ProductID);

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' variants created.';
GO

-- Add SellingPriceExVAT column if missing
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Price') AND name = 'SellingPriceExVAT')
BEGIN
    ALTER TABLE Demo_Retail_Price ADD SellingPriceExVAT DECIMAL(18,2) NULL;
    PRINT 'Added SellingPriceExVAT column.';
END
GO

-- Import pricing
PRINT 'Importing pricing...';

INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, SellingPriceExVAT, CostPrice, CreatedAt)
SELECT 
    p.ProductID,
    s.BranchID,
    s.InclPrice,
    s.ExVATPrice,
    s.Cost,
    GETDATE()
FROM #StagingImport s
INNER JOIN Demo_Retail_Product p ON p.Code = s.ItemCode
WHERE s.BranchID IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = p.ProductID AND BranchID = s.BranchID);

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' pricing records created.';
GO

-- Create stock records
PRINT 'Creating stock records...';

INSERT INTO Demo_Retail_Stock (ProductID, BranchID, QtyOnHand, CreatedAt, UpdatedAt)
SELECT 
    p.ProductID,
    s.BranchID,
    0,
    GETDATE(),
    GETDATE()
FROM #StagingImport s
INNER JOIN Demo_Retail_Product p ON p.Code = s.ItemCode
WHERE s.BranchID IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Stock WHERE ProductID = p.ProductID AND BranchID = s.BranchID);

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' stock records created.';
GO

-- =====================================================
-- STEP 4: Summary Report
-- =====================================================
PRINT ' ';
PRINT '========================================';
PRINT '       IMPORT SUMMARY';
PRINT '========================================';

DECLARE @ProductCount INT, @VariantCount INT, @PriceCount INT, @StockCount INT;

SELECT @ProductCount = COUNT(*) FROM Demo_Retail_Product;
SELECT @VariantCount = COUNT(*) FROM Demo_Retail_Variant;
SELECT @PriceCount = COUNT(*) FROM Demo_Retail_Price;
SELECT @StockCount = COUNT(*) FROM Demo_Retail_Stock;

PRINT 'Products: ' + CAST(@ProductCount AS NVARCHAR);
PRINT 'Variants: ' + CAST(@VariantCount AS NVARCHAR);
PRINT 'Prices: ' + CAST(@PriceCount AS NVARCHAR);
PRINT 'Stock: ' + CAST(@StockCount AS NVARCHAR);
PRINT ' ';
PRINT 'Sample products:';

SELECT TOP 10 
    Code,
    Name,
    ProductType,
    SKU,
    ExternalBarcode
FROM Demo_Retail_Product
ORDER BY ProductID DESC;

PRINT '========================================';
GO
