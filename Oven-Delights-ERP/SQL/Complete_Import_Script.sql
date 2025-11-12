-- =====================================================
-- COMPLETE IMPORT SCRIPT FOR OVEN DELIGHTS ERP
-- Imports: Products, Categories, Variants, Prices, Stock, RawMaterials, Subassemblies, Master Products
-- Data Source: Combined OD200 + OD400 CSV files (2729 records)
-- =====================================================

PRINT '========================================';
PRINT 'OVEN DELIGHTS ERP - COMPLETE DATA IMPORT';
PRINT '========================================';
PRINT '';
GO

-- =====================================================
-- STEP 1: Clear Existing Demo_Retail Data
-- =====================================================
PRINT 'Clearing existing Demo_Retail data...';
GO

DELETE FROM Demo_Retail_Stock;
DELETE FROM Demo_Retail_Price;
DELETE FROM Demo_Retail_Variant;
DELETE FROM Demo_Retail_Product;
DELETE FROM RawMaterials WHERE MaterialCode LIKE 'AC%' OR MaterialCode LIKE 'UM%';
DELETE FROM Subassemblies WHERE SubAssemblyCode LIKE 'AC%' OR SubAssemblyCode LIKE 'UM%';
GO

PRINT 'Existing data cleared.';
GO

-- =====================================================
-- STEP 2: Load Data from Batched_Import_Ready.sql
-- =====================================================
PRINT 'Loading staging data from Combined_Inventory.csv...';
PRINT 'Please run Batched_Import_Ready.sql first to load the staging table.';
PRINT 'Then continue with the rest of this script.';
PRINT '';
PRINT 'Press any key after running Batched_Import_Ready.sql...';
GO

-- NOTE: At this point, you should have run Batched_Import_Ready.sql
-- which creates #StagingImport table with 2729 records

-- =====================================================
-- STEP 3: Classify Products and Map BranchID
-- =====================================================
PRINT 'Classifying products and mapping BranchID...';
GO

-- Add computed columns
ALTER TABLE #StagingImport ADD TreatmentType NVARCHAR(50);
ALTER TABLE #StagingImport ADD ProductType NVARCHAR(50);
ALTER TABLE #StagingImport ADD BranchID INT;
ALTER TABLE #StagingImport ADD BranchPrefix NVARCHAR(10);
ALTER TABLE #StagingImport ADD ExVATPrice DECIMAL(18,2);
GO

-- Classify products and get branch prefix
-- Use CASE to map Warehouse values to BranchID directly
UPDATE s
SET 
    s.TreatmentType = CASE 
        WHEN LOWER(s.Category) IN ('ingredients', 'ingredient') THEN 'RawMaterial'
        WHEN LOWER(s.Category) IN ('buttercream', 'subrecipe', 'sub recipe') THEN 'SubComponent'
        WHEN LOWER(s.Category) IN ('consumables', 'miscellaneous') THEN 'Accessory'
        ELSE 'FinishedProduct'
    END,
    s.ProductType = CASE 
        WHEN LOWER(s.ItemCategory) = 'external' THEN 'External'
        ELSE 'Internal'
    END,
    s.BranchID = CASE 
        WHEN s.Warehouse = 'OD200' THEN 6
        WHEN s.Warehouse = 'OD400' THEN 4
        ELSE NULL
    END,
    s.BranchPrefix = CASE 
        WHEN s.Warehouse = 'OD200' THEN 'AC'
        WHEN s.Warehouse = 'OD400' THEN 'UM'
        ELSE NULL
    END,
    s.ExVATPrice = ROUND(s.InclPrice / 1.15, 2)
FROM #StagingImport s;
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' records classified.';
GO

-- Check BranchID mapping results
PRINT 'BranchID mapping results:';
SELECT DISTINCT Warehouse, BranchID, BranchPrefix, COUNT(*) AS RecordCount
FROM #StagingImport
GROUP BY Warehouse, BranchID, BranchPrefix;
GO

-- Check total records by Warehouse
PRINT 'Total staging records by Warehouse:';
SELECT Warehouse, COUNT(*) AS TotalRecords
FROM #StagingImport
GROUP BY Warehouse;
GO

-- =====================================================
-- STEP 4: Import Products, Categories, Variants
-- =====================================================
PRINT 'Importing products...';
GO

-- Insert missing categories from CSV
PRINT 'Inserting missing categories from CSV...';
INSERT INTO ProductCategories (CategoryCode, CategoryName, IsActive, CreatedDate, CreatedBy)
SELECT DISTINCT 
    CategoryCode,
    CategoryName,
    1,
    GETDATE(),
    1
FROM (
    SELECT DISTINCT
        LEFT(UPPER(REPLACE(s.Category, ' ', '')), 10) AS CategoryCode,
        s.Category AS CategoryName,
        ROW_NUMBER() OVER (PARTITION BY LEFT(UPPER(REPLACE(s.Category, ' ', '')), 10) ORDER BY s.Category) AS RowNum
    FROM #StagingImport s
    WHERE s.Category IS NOT NULL
        AND s.Category != ''
        AND NOT EXISTS (SELECT 1 FROM ProductCategories WHERE CategoryName = s.Category)
) AS CatData
WHERE RowNum = 1
    AND NOT EXISTS (SELECT 1 FROM ProductCategories WHERE CategoryCode = CatData.CategoryCode);

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' new categories created from CSV.';
GO

-- Insert products with Branch Prefix + ItemCode
INSERT INTO Demo_Retail_Product (Code, Name, Description, ProductType, ExternalBarcode, SKU, BranchID, CategoryID, Category, IsActive, CreatedAt)
SELECT 
    PrefixedCode,
    ItemDescription,
    ItemDescription,
    ProductType,
    ExternalBarcode,
    GeneratedSKU,
    BranchID,
    CategoryID,
    Category,
    1,
    GETDATE()
FROM (
    SELECT 
        ISNULL(s.BranchPrefix, '') + s.ItemCode AS PrefixedCode,
        s.ItemDescription,
        s.ProductType,
        s.BranchID,
        s.Category,
        (SELECT TOP 1 CategoryID FROM ProductCategories WHERE CategoryName = s.Category) AS CategoryID,
        CASE WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' AND s.Barcode != '' THEN s.Barcode ELSE NULL END AS ExternalBarcode,
        CASE 
            WHEN s.Barcode IS NOT NULL 
                AND s.Barcode != '0' 
                AND s.Barcode != '' 
                AND s.Barcode NOT LIKE '%[^0-9]%'
                AND LEN(s.Barcode) >= 4 THEN 
                CASE 
                    WHEN s.ProductType = 'Internal' THEN '2' + RIGHT('00000000' + s.Barcode, 8)
                    ELSE s.Barcode
                END
            ELSE s.ItemCode
        END AS GeneratedSKU,
        ROW_NUMBER() OVER (PARTITION BY ISNULL(s.BranchPrefix, '') + s.ItemCode ORDER BY s.ItemCode) AS RowNum
    FROM #StagingImport s
    WHERE s.TreatmentType IN ('FinishedProduct', 'Accessory', 'SubComponent', 'RawMaterial')
        AND s.ItemCode IS NOT NULL
) AS Deduplicated
WHERE RowNum = 1
    AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Product WHERE Code = Deduplicated.PrefixedCode);
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' products imported.';
GO

-- Check product counts by branch
PRINT 'Product counts by branch:';
SELECT 
    BranchID,
    CASE 
        WHEN BranchID = 4 THEN 'OD400 - Umhlanga'
        WHEN BranchID = 6 THEN 'OD200 - Avondale'
        ELSE 'Unknown'
    END AS BranchName,
    COUNT(*) AS TotalProducts
FROM Demo_Retail_Product
GROUP BY BranchID
ORDER BY BranchID;
GO

-- Create variants
PRINT 'Creating variants...';
GO

INSERT INTO Demo_Retail_Variant (ProductID, VariantName, SKU, IsDefault, IsActive, CreatedAt)
SELECT 
    ProductID,
    'Default' AS VariantName,
    SKU,
    1 AS IsDefault,
    1 AS IsActive,
    GETDATE()
FROM Demo_Retail_Product
WHERE NOT EXISTS (SELECT 1 FROM Demo_Retail_Variant WHERE ProductID = Demo_Retail_Product.ProductID);
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' variants created.';
GO

-- =====================================================
-- STEP 5: Import Pricing
-- =====================================================
PRINT 'Importing pricing...';
GO

-- Drop index on EffectiveFrom if it exists
IF EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Demo_Retail_Price') AND name = 'IX_Demo_Retail_Price_Product')
BEGIN
    DROP INDEX IX_Demo_Retail_Price_Product ON Demo_Retail_Price;
    PRINT 'Dropped index IX_Demo_Retail_Price_Product.';
END
GO

-- Make EffectiveFrom nullable
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Price') AND name = 'EffectiveFrom' AND is_nullable = 0)
BEGIN
    ALTER TABLE Demo_Retail_Price ALTER COLUMN EffectiveFrom DATETIME NULL;
    PRINT 'Made EffectiveFrom column nullable.';
END
GO

-- Recreate index without EffectiveFrom
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID('Demo_Retail_Price') AND name = 'IX_Demo_Retail_Price_Product')
BEGIN
    CREATE NONCLUSTERED INDEX IX_Demo_Retail_Price_Product ON Demo_Retail_Price(ProductID, BranchID);
    PRINT 'Recreated index IX_Demo_Retail_Price_Product without EffectiveFrom.';
END
GO

-- Insert pricing
INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPriceInclVAT, SellingPriceExVAT, EffectiveFrom, IsActive, CreatedAt)
SELECT 
    p.ProductID,
    s.BranchID,
    s.InclPrice,
    s.ExVATPrice,
    NULL AS EffectiveFrom,
    1,
    GETDATE()
FROM #StagingImport s
INNER JOIN Demo_Retail_Product p ON p.Code = ISNULL(s.BranchPrefix, '') + s.ItemCode
WHERE s.BranchID IS NOT NULL
    AND s.InclPrice > 0
    AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Price WHERE ProductID = p.ProductID AND BranchID = s.BranchID)
GROUP BY p.ProductID, s.BranchID, s.InclPrice, s.ExVATPrice;
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' pricing records created.';
GO

-- =====================================================
-- STEP 6: Create Stock Records
-- =====================================================
PRINT 'Creating stock records...';
GO

INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand)
SELECT 
    v.VariantID,
    s.BranchID,
    0
FROM #StagingImport s
INNER JOIN Demo_Retail_Product p ON p.Code = ISNULL(s.BranchPrefix, '') + s.ItemCode
INNER JOIN Demo_Retail_Variant v ON v.ProductID = p.ProductID
WHERE s.BranchID IS NOT NULL
    AND s.TreatmentType IN ('FinishedProduct', 'Accessory')
    AND NOT EXISTS (SELECT 1 FROM Demo_Retail_Stock WHERE VariantID = v.VariantID AND BranchID = s.BranchID)
GROUP BY v.VariantID, s.BranchID;
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' stock records created.';
GO

-- =====================================================
-- STEP 7: Import RawMaterials (Ingredients)
-- =====================================================
PRINT 'Importing raw materials (Ingredients)...';
GO

INSERT INTO RawMaterials (MaterialCode, MaterialName, Description, CategoryID, BaseUnit, UnitOfMeasure, 
                          CurrentStock, StandardCost, LastCost, AverageCost, IsActive, CreatedDate, CreatedBy)
SELECT DISTINCT
    Code,
    Name,
    ISNULL(Description, Name) AS Description,
    CategoryID,
    'kg' AS BaseUnit,
    'kg' AS UnitOfMeasure,
    0 AS CurrentStock,
    0 AS StandardCost,
    0 AS LastCost,
    0 AS AverageCost,
    IsActive,
    CreatedAt,
    1 AS CreatedBy
FROM Demo_Retail_Product
WHERE LOWER(Category) IN ('ingredient', 'ingredients')
    AND CategoryID IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM RawMaterials WHERE MaterialCode = Demo_Retail_Product.Code);
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' raw materials imported.';
GO

-- =====================================================
-- STEP 8: Import Subassemblies (sub recipe)
-- =====================================================
PRINT 'Importing subassemblies (subRecipe)...';
GO

INSERT INTO Subassemblies (SubAssemblyCode, SubAssemblyName, Description, IsActive, CreatedDate, 
                           CurrentCost, LastPaidCost)
SELECT DISTINCT
    Code,
    Name,
    ISNULL(Description, Name) AS Description,
    IsActive,
    CreatedAt,
    0 AS CurrentCost,
    0 AS LastPaidCost
FROM Demo_Retail_Product
WHERE Category = 'sub recipe'
    AND CategoryID IS NOT NULL
    AND NOT EXISTS (SELECT 1 FROM Subassemblies WHERE SubAssemblyCode = Demo_Retail_Product.Code);
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' subassemblies imported.';
GO

-- =====================================================
-- STEP 9: Update Master Products Table
-- =====================================================
PRINT 'Updating master Products table...';
GO

IF OBJECT_ID('Products', 'U') IS NOT NULL
BEGIN
    PRINT 'Found master table: Products';
    
    -- Delete existing Demo_Retail products from master Products table
    DELETE FROM Products 
    WHERE ProductCode IN (
        SELECT DISTINCT REPLACE(REPLACE(Code, 'AC', ''), 'UM', '') 
        FROM Demo_Retail_Product
    );
    PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' existing products removed from master Products table.';
    
    -- Insert Demo_Retail products into master Products table WITHOUT branch prefix
    INSERT INTO Products (ProductCode, ProductName, CategoryID, ItemType, SKU, IsActive, CreatedDate)
    SELECT 
        ProductCode,
        ProductName,
        CategoryID,
        ItemType,
        SKU,
        IsActive,
        CreatedDate
    FROM (
        SELECT DISTINCT
            REPLACE(REPLACE(Code, 'AC', ''), 'UM', '') AS ProductCode,
            Name AS ProductName,
            CategoryID,
            ProductType AS ItemType,
            SKU,
            IsActive,
            CreatedAt AS CreatedDate,
            ROW_NUMBER() OVER (PARTITION BY REPLACE(REPLACE(Code, 'AC', ''), 'UM', '') ORDER BY Code) AS RowNum
        FROM Demo_Retail_Product
        WHERE CategoryID IS NOT NULL
    ) AS UniqueProducts
    WHERE RowNum = 1
        AND NOT EXISTS (
            SELECT 1 FROM Products 
            WHERE Products.ProductCode = UniqueProducts.ProductCode
        );
    
    PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' unique products added to master Products table.';
    PRINT 'Master Products table updated successfully!';
END
ELSE
BEGIN
    PRINT 'WARNING: Master Products table not found. Skipping master table update.';
END
GO

-- =====================================================
-- STEP 10: Display Summary
-- =====================================================
PRINT '';
PRINT '========================================';
PRINT '       IMPORT SUMMARY';
PRINT '========================================';

SELECT 
    (SELECT COUNT(*) FROM Demo_Retail_Product) AS Products,
    (SELECT COUNT(*) FROM Demo_Retail_Variant) AS Variants,
    (SELECT COUNT(*) FROM Demo_Retail_Price) AS Prices,
    (SELECT COUNT(*) FROM Demo_Retail_Stock) AS Stock,
    (SELECT COUNT(*) FROM RawMaterials WHERE MaterialCode LIKE 'AC%' OR MaterialCode LIKE 'UM%') AS RawMaterials,
    (SELECT COUNT(*) FROM Subassemblies WHERE SubAssemblyCode LIKE 'AC%' OR SubAssemblyCode LIKE 'UM%') AS Subassemblies;
GO

PRINT '';
PRINT 'Sample products by branch:';
SELECT TOP 5 Code, Name, Category, BranchID FROM Demo_Retail_Product WHERE BranchID = 6 ORDER BY Code;
SELECT TOP 5 Code, Name, Category, BranchID FROM Demo_Retail_Product WHERE BranchID = 4 ORDER BY Code;
GO

PRINT '========================================';
PRINT 'IMPORT COMPLETED SUCCESSFULLY!';
PRINT '========================================';
GO

DROP TABLE #StagingImport;
GO
