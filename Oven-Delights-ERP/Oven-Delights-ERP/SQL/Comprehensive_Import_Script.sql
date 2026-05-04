-- Comprehensive Import Script for CSV Data
-- Imports to: Products (master), ProductInventory, Demo_Retail tables
-- Handles: External products, Internal finished goods, Ingredients, Sub-assemblies
-- Both branches: OD200 (BranchID=6) and OD400 (BranchID=4)
-- VAT Calculations: InclVAT and ExVAT pricing

USE OvenDelightsERP;
GO

-- =====================================================
-- STEP 1: Create Staging Table and Load CSV Data
-- =====================================================
PRINT 'Creating staging table...';
GO

IF OBJECT_ID('tempdb..#StagingImport') IS NOT NULL DROP TABLE #StagingImport;
CREATE TABLE #StagingImport (
    Cost DECIMAL(18,4),
    Warehouse NVARCHAR(50),
    Ingredients NVARCHAR(MAX),
    ItemDescription NVARCHAR(500),
    Category NVARCHAR(100),
    ItemCategory NVARCHAR(50), -- 'internal' or 'external'
    Barcode NVARCHAR(50),
    ItemDescription2 NVARCHAR(500),
    Col9 NVARCHAR(50),
    ItemCode NVARCHAR(50),
    InclPrice DECIMAL(18,2),
    Treatment NVARCHAR(50),
    Branch NVARCHAR(100),
    -- Computed columns
    TreatmentType NVARCHAR(50),
    ProductType NVARCHAR(50),
    BranchID INT,
    ExVATPrice DECIMAL(18,2)
);
GO

-- NOTE: You'll need to manually insert data here from the CSV converter
-- Or use the CSVToSQLConverter form to generate INSERT statements
PRINT 'Staging table ready. Please insert CSV data manually.';
PRINT 'Use the CSV to SQL Converter utility to generate INSERT statements.';
GO

-- =====================================================
-- STEP 2: Classify Products by Treatment Type
-- =====================================================
PRINT 'Classifying products by treatment type...';
GO

UPDATE #StagingImport
SET 
    -- Determine treatment type based on category
    TreatmentType = CASE 
        WHEN LOWER(Category) IN ('ingredients') THEN 'RawMaterial'
        WHEN LOWER(Category) IN ('buttercream', 'buttercream 1mx500', 'freshcream 1mx500', 'sub recipe') THEN 'SubComponent'
        WHEN LOWER(Category) IN ('consumables', 'miscellaneous') THEN 'Accessory'
        ELSE 'FinishedProduct' -- Biscuits, cakes, candles, etc.
    END,
    -- Determine product type (Internal vs External)
    ProductType = CASE 
        WHEN LOWER(ItemCategory) = 'external' THEN 'External'
        ELSE 'Internal'
    END,
    -- Map branch codes to IDs
    BranchID = CASE 
        WHEN Warehouse = 'OD200' THEN 6
        WHEN Warehouse = 'OD400' THEN 4
        ELSE NULL
    END,
    -- Calculate Ex-VAT price (divide by 1.15)
    ExVATPrice = CASE 
        WHEN InclPrice > 0 THEN ROUND(InclPrice / 1.15, 2)
        ELSE 0
    END
WHERE ItemCode IS NOT NULL;
GO

PRINT 'Classification complete.';
GO

-- =====================================================
-- STEP 3: Import RAW MATERIALS (Ingredients Only)
-- =====================================================
PRINT 'Importing Raw Materials (Ingredients)...';
GO

INSERT INTO RawMaterials (
    MaterialCode,
    MaterialName,
    UnitOfMeasure,
    LastPaidPrice,
    AverageCost,
    IsActive
)
SELECT DISTINCT
    ItemCode,
    ItemDescription,
    'EA', -- Default unit
    Cost,
    Cost,
    1
FROM #StagingImport
WHERE TreatmentType = 'RawMaterial'
    AND ItemCode IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM RawMaterials WHERE MaterialCode = ItemCode
    );
GO

DECLARE @RawMaterialCount INT = @@ROWCOUNT;
PRINT CAST(@RawMaterialCount AS NVARCHAR) + ' Raw Materials imported.';
GO

-- =====================================================
-- STEP 4: Import SUB ASSEMBLIES (Sub-components)
-- =====================================================
PRINT 'Importing Sub Assemblies...';
GO

-- Note: Check if SubAssemblies table exists and has correct columns
IF OBJECT_ID('SubAssemblies', 'U') IS NOT NULL
BEGIN
    PRINT 'SubAssemblies table found. Importing...';
    -- Add your SubAssemblies import here based on actual table schema
END
ELSE
BEGIN
    PRINT 'SubAssemblies table not found. Skipping sub-assemblies import.';
END
GO

-- =====================================================
-- STEP 5: Import PRODUCTS (Master Table - Branch Independent)
-- External products + Internal finished goods ONLY
-- =====================================================
PRINT 'Importing Products to master table...';
GO

INSERT INTO Products (
    ProductCode,
    ProductName,
    SKU,
    ItemType,
    LastPaidPrice,
    AverageCost,
    SellingPrice,
    IsActive
)
SELECT DISTINCT
    s.ItemCode,
    s.ItemDescription,
    -- Generate SKU/Barcode
    CASE 
        WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' 
            THEN s.Barcode
        WHEN s.ProductType = 'Internal' AND s.ItemCode IS NOT NULL 
            THEN '2' + RIGHT('00000000' + REPLACE(REPLACE(REPLACE(s.ItemCode, '-', ''), ' ', ''), '.', ''), 8)
        ELSE NULL
    END,
    -- ItemType
    CASE 
        WHEN s.ProductType = 'External' THEN 'External'
        WHEN s.TreatmentType = 'Accessory' THEN 'Accessory'
        ELSE 'Internal'
    END,
    -- Use average cost across branches
    AVG(s.Cost),
    AVG(s.Cost),
    -- Use average selling price across branches (InclVAT)
    AVG(s.InclPrice),
    1
FROM #StagingImport s
WHERE s.TreatmentType IN ('FinishedProduct', 'Accessory')
    AND s.ItemCode IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM Products WHERE ProductCode = s.ItemCode
    )
GROUP BY 
    s.ItemCode,
    s.ItemDescription,
    s.ProductType,
    s.TreatmentType,
    s.Barcode;
GO

DECLARE @ProductCount INT = @@ROWCOUNT;
PRINT CAST(@ProductCount AS NVARCHAR) + ' Products imported to master table.';
GO

-- =====================================================
-- STEP 6: Import PRODUCT INVENTORY (Branch-Specific)
-- =====================================================
PRINT 'Creating Product Inventory records for branches...';
GO

INSERT INTO ProductInventory (
    ProductID,
    BranchID,
    QtyOnHand,
    ReorderLevel,
    LastUpdated
)
SELECT 
    p.ProductID,
    s.BranchID,
    0, -- Initial stock = 0
    0,
    GETDATE()
FROM #StagingImport s
INNER JOIN Products p ON p.ProductCode = s.ItemCode
WHERE s.TreatmentType IN ('FinishedProduct', 'Accessory')
    AND s.BranchID IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM ProductInventory 
        WHERE ProductID = p.ProductID AND BranchID = s.BranchID
    )
GROUP BY p.ProductID, s.BranchID;
GO

DECLARE @InventoryCount INT = @@ROWCOUNT;
PRINT CAST(@InventoryCount AS NVARCHAR) + ' Product Inventory records created.';
GO

-- =====================================================
-- STEP 7: Import DEMO_RETAIL_PRODUCT (for POS)
-- =====================================================
PRINT 'Importing Demo_Retail_Product for POS...';
GO

INSERT INTO Demo_Retail_Product (
    Code,
    Name,
    Description,
    ProductType,
    ExternalBarcode,
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
    1,
    GETDATE()
FROM #StagingImport s
WHERE s.TreatmentType IN ('FinishedProduct', 'Accessory')
    AND s.ItemCode IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Product WHERE Code = s.ItemCode
    );
GO

DECLARE @DemoProductCount INT = @@ROWCOUNT;
PRINT CAST(@DemoProductCount AS NVARCHAR) + ' Demo_Retail_Product records created.';
GO

-- =====================================================
-- STEP 8: Create Default Variants
-- =====================================================
PRINT 'Creating default variants...';
GO

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
GO

DECLARE @VariantCount INT = @@ROWCOUNT;
PRINT CAST(@VariantCount AS NVARCHAR) + ' variants created.';
GO

-- =====================================================
-- STEP 9: Import PRICING (Branch-Specific with VAT)
-- =====================================================
PRINT 'Importing branch-specific pricing with VAT calculations...';
GO

INSERT INTO Demo_Retail_Price (
    ProductID,
    BranchID,
    SellingPrice,      -- InclVAT
    SellingPriceExVAT, -- ExVAT (calculated)
    CostPrice,
    CreatedAt
)
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
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Price 
        WHERE ProductID = p.ProductID AND BranchID = s.BranchID
    );
GO

DECLARE @PriceCount INT = @@ROWCOUNT;
PRINT CAST(@PriceCount AS NVARCHAR) + ' pricing records created.';
GO

-- =====================================================
-- STEP 10: Create STOCK Records (Branch-Specific)
-- =====================================================
PRINT 'Creating stock records for branches...';
GO

INSERT INTO Demo_Retail_Stock (
    VariantID,
    BranchID,
    QtyOnHand,
    LastUpdated
)
SELECT 
    v.VariantID,
    s.BranchID,
    0, -- Initial stock = 0
    GETDATE()
FROM #StagingImport s
INNER JOIN Demo_Retail_Product p ON p.Code = s.ItemCode
INNER JOIN Demo_Retail_Variant v ON v.ProductID = p.ProductID AND v.IsDefault = 1
WHERE s.BranchID IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Stock 
        WHERE VariantID = v.VariantID AND BranchID = s.BranchID
    )
GROUP BY v.VariantID, s.BranchID;
GO

DECLARE @StockCount INT = @@ROWCOUNT;
PRINT CAST(@StockCount AS NVARCHAR) + ' stock records created.';
GO

-- =====================================================
-- STEP 11: Update SKU Field with Generated Barcodes
-- =====================================================
PRINT 'Generating barcodes in SKU field...';
GO

UPDATE Demo_Retail_Product
SET SKU = CASE 
    -- External products: use ExternalBarcode if it exists and is not '0'
    WHEN ProductType = 'External' AND ExternalBarcode IS NOT NULL AND ExternalBarcode != '0' 
        THEN ExternalBarcode
    -- Internal products: generate barcode from Code (2 + 8-digit padded)
    WHEN ProductType = 'Internal' AND Code IS NOT NULL AND Code != '' 
        THEN '2' + RIGHT('00000000' + REPLACE(REPLACE(REPLACE(Code, '-', ''), ' ', ''), '.', ''), 8)
    ELSE NULL
END
WHERE SKU IS NULL OR SKU = '';
GO

DECLARE @BarcodeCount INT = @@ROWCOUNT;
PRINT CAST(@BarcodeCount AS NVARCHAR) + ' barcodes generated.';
GO

-- =====================================================
-- STEP 12: SUMMARY REPORT
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT '       IMPORT SUMMARY REPORT';
PRINT '========================================';
PRINT '';

DECLARE @TotalProducts INT, @TotalRawMaterials INT, @TotalInventory INT;
DECLARE @TotalDemoProducts INT, @TotalVariants INT, @TotalPrices INT, @TotalStock INT;

SELECT @TotalRawMaterials = COUNT(*) FROM RawMaterials;
SELECT @TotalProducts = COUNT(*) FROM Products;
SELECT @TotalInventory = COUNT(*) FROM ProductInventory;
SELECT @TotalDemoProducts = COUNT(*) FROM Demo_Retail_Product;
SELECT @TotalVariants = COUNT(*) FROM Demo_Retail_Variant;
SELECT @TotalPrices = COUNT(*) FROM Demo_Retail_Price;
SELECT @TotalStock = COUNT(*) FROM Demo_Retail_Stock;

PRINT 'MASTER TABLES:';
PRINT '  Raw Materials (Ingredients): ' + CAST(@TotalRawMaterials AS NVARCHAR);
PRINT '  Products (Master): ' + CAST(@TotalProducts AS NVARCHAR);
PRINT '  Product Inventory (Branch): ' + CAST(@TotalInventory AS NVARCHAR);
PRINT '';
PRINT 'POS TABLES (Demo_Retail):';
PRINT '  Products: ' + CAST(@TotalDemoProducts AS NVARCHAR);
PRINT '  Variants: ' + CAST(@TotalVariants AS NVARCHAR);
PRINT '  Pricing Records: ' + CAST(@TotalPrices AS NVARCHAR);
PRINT '  Stock Records: ' + CAST(@TotalStock AS NVARCHAR);
PRINT '';
PRINT '========================================';
PRINT 'Import completed successfully!';
PRINT '========================================';
GO

-- Cleanup
DROP TABLE #StagingImport;
GO
