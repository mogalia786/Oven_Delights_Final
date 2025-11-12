-- =====================================================
-- AUTO-GENERATED BATCHED INSERT STATEMENTS
-- Total Rows: 24
-- Batch Size: 1000
-- Total Batches: 1
-- =====================================================

-- BATCH 1 (Rows 1-24)
INSERT INTO #StagingImport (Cost, Warehouse, Ingredients, ItemDescription, Category, ItemCategory, Barcode, ItemDescription2, Col9, ItemCode, InclPrice, Treatment, Branch)';
PRINT '-- VALUES
VALUES
(...),
(...),
...';
PRINT '';
GO

-- =====================================================
-- STEP 2: Classify Products
-- =====================================================
PRINT 'Classifying products by treatment type...';
GO

UPDATE #StagingImport
SET 
    TreatmentType = CASE 
        WHEN LOWER(Category) IN ('ingredients') THEN 'RawMaterial'
        WHEN LOWER(Category) IN ('buttercream', 'buttercream 1mx500', 'freshcream 1mx500', 'sub recipe') THEN 'SubComponent'
        WHEN LOWER(Category) IN ('consumables', 'miscellaneous') THEN 'Accessory'
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
    ExVATPrice = CASE 
        WHEN InclPrice > 0 THEN ROUND(InclPrice / 1.15, 2)
        ELSE 0
    END
WHERE ItemCode IS NOT NULL;
GO

DECLARE @StagingCount INT = @@ROWCOUNT;
PRINT CAST(@StagingCount AS NVARCHAR) + ' records classified.';
GO

-- =====================================================
-- STEP 3: Import to Demo_Retail_Product
-- =====================================================
PRINT 'Importing Demo_Retail_Product...';
GO

INSERT INTO Demo_Retail_Product (
    Code,
    Name,
    Description,
    ProductType,
    ExternalBarcode,
    SKU,
    IsActive,
    CreatedAt
)
SELECT DISTINCT
    s.ItemCode,
    s.ItemDescription,
    s.ItemDescription2,
    s.ProductType,
    CASE 
        WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' 
            THEN s.Barcode
        ELSE NULL
    END,
    -- Generate SKU/Barcode
    CASE 
        WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' 
            THEN s.Barcode
        WHEN s.ProductType = 'Internal' AND s.ItemCode IS NOT NULL 
            THEN '2' + RIGHT('00000000' + REPLACE(REPLACE(REPLACE(s.ItemCode, '-', ''), ' ', ''), '.', ''), 8)
        ELSE NULL
    END,
    1,
    GETDATE()
FROM #StagingImport s
WHERE s.TreatmentType IN ('FinishedProduct', 'Accessory')
    AND s.ItemCode IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Product WHERE Code = s.ItemCode
    );
GO

DECLARE @ProductCount INT = @@ROWCOUNT;
PRINT CAST(@ProductCount AS NVARCHAR) + ' products imported.';
GO

-- =====================================================
-- STEP 4: Create Default Variants
-- =====================================================
PRINT 'Creating default variants...';
GO

-- Check if columns exist first
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Variant') AND name = 'Name')
BEGIN
    -- Use 'Name' column
    INSERT INTO Demo_Retail_Variant (ProductID, Name, IsDefault, CreatedAt)
    SELECT 
        p.ProductID,
        'Default',
        1,
        GETDATE()
    FROM Demo_Retail_Product p
    WHERE NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = p.ProductID
    );
END
ELSE IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Variant') AND name = 'VariantName')
BEGIN
    -- Use 'VariantName' column
    INSERT INTO Demo_Retail_Variant (ProductID, VariantName, IsDefault, CreatedAt)
    SELECT 
        p.ProductID,
        'Default',
        1,
        GETDATE()
    FROM Demo_Retail_Product p
    WHERE NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = p.ProductID
    );
END
ELSE
BEGIN
    -- Minimal insert without variant name
    INSERT INTO Demo_Retail_Variant (ProductID, IsDefault, CreatedAt)
    SELECT 
        p.ProductID,
        1,
        GETDATE()
    FROM Demo_Retail_Product p
    WHERE NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = p.ProductID
    );
END
GO

DECLARE @VariantCount INT = @@ROWCOUNT;
PRINT CAST(@VariantCount AS NVARCHAR) + ' variants created.';
GO

-- =====================================================
-- STEP 5: Import Pricing with VAT
-- =====================================================
PRINT 'Importing branch-specific pricing...';
GO

-- First, add SellingPriceExVAT column if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Price') AND name = 'SellingPriceExVAT'),
BEGIN
    ALTER TABLE Demo_Retail_Price ADD SellingPriceExVAT DECIMAL(18,2),
NULL;
    PRINT 'Added SellingPriceExVAT column to Demo_Retail_Price.';
END
GO

INSERT INTO Demo_Retail_Price (
    ProductID,
    BranchID,
    SellingPrice,
    SellingPriceExVAT,
    CostPrice,
    CreatedAt
),
SELECT 
    p.ProductID
    s.BranchID
    s.InclPrice
    s.ExVATPrice
    s.Cost
    GETDATE(),
FROM #StagingImport s
INNER JOIN Demo_Retail_Product p ON p.Code = s.ItemCode
WHERE s.BranchID IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Price 
        WHERE ProductID = p.ProductID AND BranchID = s.BranchID
    ),
;
GO

DECLARE @PriceCount INT = @@ROWCOUNT;
PRINT CAST(@PriceCount AS NVARCHAR),
+ ' pricing records created.';
GO

-- =====================================================
-- STEP 6: Create Stock Records
-- =====================================================
PRINT 'Creating stock records...';
GO

-- Check if LastUpdated column exists
DECLARE @HasLastUpdated BIT = 0;
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Stock') AND name = 'LastUpdated'),
SET @HasLastUpdated = 1;

IF @HasLastUpdated = 1
BEGIN
    INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, LastUpdated),
SELECT 
        v.VariantID
        s.BranchID
        0
        GETDATE(),
FROM #StagingImport s
    INNER JOIN Demo_Retail_Product p ON p.Code = s.ItemCode
    INNER JOIN Demo_Retail_Variant v ON v.ProductID = p.ProductID
    WHERE s.BranchID IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 FROM Demo_Retail_Stock 
            WHERE VariantID = v.VariantID AND BranchID = s.BranchID
        ),
GROUP BY v.VariantID s.BranchID;
END
ELSE
BEGIN
    INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand),
SELECT 
        v.VariantID
        s.BranchID
        0
    FROM #StagingImport s
    INNER JOIN Demo_Retail_Product p ON p.Code = s.ItemCode
    INNER JOIN Demo_Retail_Variant v ON v.ProductID = p.ProductID
    WHERE s.BranchID IS NOT NULL
        AND NOT EXISTS (
            SELECT 1 FROM Demo_Retail_Stock 
            WHERE VariantID = v.VariantID AND BranchID = s.BranchID
        ),
GROUP BY v.VariantID s.BranchID;
END
GO

DECLARE @StockCount INT = @@ROWCOUNT;
PRINT CAST(@StockCount AS NVARCHAR),
+ ' stock records created.';
GO

-- =====================================================
-- STEP 7: Summary Report
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT '       IMPORT SUMMARY REPORT';
PRINT '========================================';
PRINT '';

DECLARE @TotalProducts INT @TotalVariants INT @TotalPrices INT @TotalStock INT;

SELECT @TotalProducts = COUNT(*),
FROM Demo_Retail_Product;
SELECT @TotalVariants = COUNT(*),
FROM Demo_Retail_Variant;
SELECT @TotalPrices = COUNT(*),
FROM Demo_Retail_Price;
SELECT @TotalStock = COUNT(*),
FROM Demo_Retail_Stock;

PRINT 'Demo_Retail_Product: ' + CAST(@TotalProducts AS NVARCHAR),
;
PRINT 'Demo_Retail_Variant: ' + CAST(@TotalVariants AS NVARCHAR),
;
PRINT 'Demo_Retail_Price: ' + CAST(@TotalPrices AS NVARCHAR),
;
PRINT 'Demo_Retail_Stock: ' + CAST(@TotalStock AS NVARCHAR),
;
PRINT '';

-- Show sample of imported products
PRINT 'Sample of imported products:';
SELECT TOP 10 
    Code
    Name
    ProductType
    SKU
FROM Demo_Retail_Product
ORDER BY ProductID DESC;

PRINT '';
PRINT '========================================';
PRINT 'Import completed!';
PRINT '========================================';
GO

-- Cleanup
DROP TABLE #StagingImport;;
GO

PRINT 'Batch 1 loaded (24 rows).';
GO

