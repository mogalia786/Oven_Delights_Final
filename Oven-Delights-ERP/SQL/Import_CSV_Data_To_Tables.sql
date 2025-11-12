-- Import CSV Data into Correct Tables
-- Routes data to: Products, RawMaterials, SubAssemblies, ProductInventory
-- Based on category treatment mapping

USE OvenDelightsERP;
GO

-- Step 1: Create temporary staging table for CSV import
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
    Branch NVARCHAR(100)
);
GO

-- Step 2: BULK INSERT from CSV files
-- NOTE: Update file paths as needed
BULK INSERT #StagingImport
FROM 'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Exports\OD200_Ayesha_Centre.csv'
WITH (
    FIRSTROW = 3, -- Skip header rows
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

BULK INSERT #StagingImport
FROM 'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\Exports\OD400_Umhlanga.csv'
WITH (
    FIRSTROW = 3,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
GO

-- Step 3: Add computed columns for treatment classification
ALTER TABLE #StagingImport ADD TreatmentType NVARCHAR(50);
ALTER TABLE #StagingImport ADD ProductType NVARCHAR(50);
ALTER TABLE #StagingImport ADD BranchID INT;
GO

-- Step 4: Update treatment types based on category mapping
UPDATE #StagingImport
SET TreatmentType = CASE 
    WHEN LOWER(Category) = 'ingredients' THEN 'RawMaterial'
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
END;
GO

PRINT 'Staging data prepared. Starting import...';
GO

-- Step 5: Import RAW MATERIALS (ingredients)
PRINT 'Importing Raw Materials...';
INSERT INTO RawMaterials (
    MaterialCode,
    MaterialName,
    Description,
    Category,
    UnitOfMeasure,
    ReorderLevel,
    LastPaidPrice,
    AverageCost,
    IsActive
)
SELECT DISTINCT
    ItemCode,
    ItemDescription,
    ItemDescription2,
    Category,
    'EA', -- Default unit
    0, -- ReorderLevel
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

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Raw Materials imported.';
GO

-- Step 6: Import SUB ASSEMBLIES (sub-components)
PRINT 'Importing Sub Assemblies...';
INSERT INTO SubAssemblies (
    AssemblyCode,
    AssemblyName,
    Description,
    Category,
    UnitOfMeasure,
    StandardCost,
    IsActive
)
SELECT DISTINCT
    ItemCode,
    ItemDescription,
    ItemDescription2,
    Category,
    'EA',
    Cost,
    1
FROM #StagingImport
WHERE TreatmentType = 'SubComponent'
    AND ItemCode IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM SubAssemblies WHERE AssemblyCode = ItemCode
    );
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Sub Assemblies imported.';
GO

-- Step 7: Import PRODUCTS (Finished Products, Accessories, External)
PRINT 'Importing Products...';
INSERT INTO Products (
    ProductCode,
    ProductName,
    Description,
    ItemType,
    CategoryID,
    SKU,
    DefaultUoMID,
    ReorderLevel,
    SellingPrice,
    LastPaidPrice,
    AverageCost,
    IsActive
)
SELECT DISTINCT
    s.ItemCode,
    s.ItemDescription,
    s.ItemDescription2,
    CASE 
        WHEN s.ProductType = 'External' THEN 'External'
        WHEN s.TreatmentType = 'Accessory' THEN 'Accessory'
        ELSE 'Internal'
    END,
    NULL, -- CategoryID - needs manual mapping
    CASE 
        WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' THEN s.Barcode
        WHEN s.ProductType = 'Internal' AND s.ItemCode IS NOT NULL THEN '2' + RIGHT('00000000' + s.ItemCode, 8)
        ELSE NULL
    END,
    1, -- Default UoM
    0,
    s.InclPrice,
    s.Cost,
    s.Cost,
    1
FROM #StagingImport s
WHERE s.TreatmentType IN ('FinishedProduct', 'Accessory')
    AND s.ItemCode IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM Products WHERE ProductCode = s.ItemCode
    );
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Products imported.';
GO

-- Step 8: Import PRODUCT INVENTORY (branch-specific stock)
PRINT 'Importing Product Inventory...';
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
    );
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Product Inventory records created.';
GO

-- Step 9: Update Demo_Retail tables for POS system
PRINT 'Updating Demo_Retail tables for POS...';

-- Insert into Demo_Retail_Product
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
        WHEN s.ProductType = 'External' AND s.Barcode IS NOT NULL AND s.Barcode != '0' THEN s.Barcode
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

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Demo_Retail_Product records created.';
GO

-- Create default variants for each product
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

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Demo_Retail_Variant records created.';
GO

-- Insert pricing per branch
INSERT INTO Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, CreatedAt)
SELECT 
    p.ProductID,
    s.BranchID,
    s.InclPrice,
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

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Demo_Retail_Price records created.';
GO

-- Insert stock per branch (initial stock = 0)
INSERT INTO Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, LastUpdated)
SELECT 
    v.VariantID,
    s.BranchID,
    0,
    GETDATE()
FROM #StagingImport s
INNER JOIN Demo_Retail_Product p ON p.Code = s.ItemCode
INNER JOIN Demo_Retail_Variant v ON v.ProductID = p.ProductID AND v.IsDefault = 1
WHERE s.BranchID IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 FROM Demo_Retail_Stock 
        WHERE VariantID = v.VariantID AND BranchID = s.BranchID
    );
GO

PRINT CAST(@@ROWCOUNT AS NVARCHAR) + ' Demo_Retail_Stock records created.';
GO

-- Step 10: Summary report
PRINT '';
PRINT '=== IMPORT SUMMARY ===';
PRINT 'Raw Materials: ' + CAST((SELECT COUNT(*) FROM RawMaterials) AS NVARCHAR);
PRINT 'Sub Assemblies: ' + CAST((SELECT COUNT(*) FROM SubAssemblies) AS NVARCHAR);
PRINT 'Products: ' + CAST((SELECT COUNT(*) FROM Products) AS NVARCHAR);
PRINT 'Product Inventory Records: ' + CAST((SELECT COUNT(*) FROM ProductInventory) AS NVARCHAR);
PRINT 'Demo_Retail_Product: ' + CAST((SELECT COUNT(*) FROM Demo_Retail_Product) AS NVARCHAR);
PRINT 'Demo_Retail_Variant: ' + CAST((SELECT COUNT(*) FROM Demo_Retail_Variant) AS NVARCHAR);
PRINT 'Demo_Retail_Price: ' + CAST((SELECT COUNT(*) FROM Demo_Retail_Price) AS NVARCHAR);
PRINT 'Demo_Retail_Stock: ' + CAST((SELECT COUNT(*) FROM Demo_Retail_Stock) AS NVARCHAR);
PRINT '';
PRINT 'Import completed successfully!';
GO

-- Cleanup
DROP TABLE #StagingImport;
GO
