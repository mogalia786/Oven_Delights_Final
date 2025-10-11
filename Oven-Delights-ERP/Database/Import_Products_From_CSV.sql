-- =============================================
-- Import Products from CSV Template
-- Run this after client sends back populated CSV
-- =============================================

-- Step 1: Create temporary staging table
IF OBJECT_ID('tempdb..#ProductStaging') IS NOT NULL DROP TABLE #ProductStaging;
CREATE TABLE #ProductStaging (
    ProductCode NVARCHAR(50),
    ProductName NVARCHAR(150),
    SKU NVARCHAR(50),
    ItemType NVARCHAR(20),
    CategoryName NVARCHAR(100),
    SubcategoryName NVARCHAR(100),
    UnitOfMeasure NVARCHAR(20),
    ReorderPoint DECIMAL(18,3),
    SellingPrice DECIMAL(18,2),
    LastPaidPrice DECIMAL(18,4),
    AverageCost DECIMAL(18,4),
    Description NVARCHAR(500),
    IsActive BIT
);

-- Step 2: Bulk insert from CSV
-- IMPORTANT: Update file path to actual location
BULK INSERT #ProductStaging
FROM 'C:\Development Apps\Cascades projects\Oven-Delights-ERP\Oven-Delights-ERP\Documentation\IMPORT_TEMPLATE_PRODUCTS.csv'
WITH (
    FIRSTROW = 2,  -- Skip header row
    FIELDTERMINATOR = ' | ',  -- Pipe delimiter with spaces
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'  -- UTF-8
);

-- Step 3: Create Categories if they don't exist
INSERT INTO Categories (CategoryName, IsActive)
SELECT DISTINCT CategoryName, 1
FROM #ProductStaging
WHERE CategoryName NOT IN (SELECT CategoryName FROM Categories WHERE CategoryName IS NOT NULL);

-- Step 4: Create Subcategories if they don't exist
INSERT INTO Subcategories (SubcategoryName, CategoryID, IsActive)
SELECT DISTINCT 
    ps.SubcategoryName, 
    c.CategoryID,
    1
FROM #ProductStaging ps
INNER JOIN Categories c ON ps.CategoryName = c.CategoryName
WHERE ps.SubcategoryName IS NOT NULL
AND ps.SubcategoryName NOT IN (SELECT SubcategoryName FROM Subcategories WHERE SubcategoryName IS NOT NULL);

-- Step 5: Create UoM if they don't exist
INSERT INTO UoM (UoMCode, UoMName, IsActive)
SELECT DISTINCT 
    UnitOfMeasure,
    CASE 
        WHEN UnitOfMeasure = 'ea' THEN 'Each'
        WHEN UnitOfMeasure = 'kg' THEN 'Kilogram'
        WHEN UnitOfMeasure = 'L' THEN 'Liter'
        WHEN UnitOfMeasure = 'box' THEN 'Box'
        ELSE UnitOfMeasure
    END,
    1
FROM #ProductStaging
WHERE UnitOfMeasure NOT IN (SELECT UoMCode FROM UoM WHERE UoMCode IS NOT NULL);

-- Step 6: Import Products
INSERT INTO Products (
    ProductCode, 
    ProductName, 
    SKU, 
    ItemType, 
    CategoryID, 
    SubcategoryID, 
    DefaultUoMID,
    LastPaidPrice,
    AverageCost,
    IsActive
)
SELECT 
    ps.ProductCode,
    ps.ProductName,
    ps.SKU,
    ps.ItemType,
    c.CategoryID,
    sc.SubcategoryID,
    u.UoMID,
    ps.LastPaidPrice,
    ps.AverageCost,
    ps.IsActive
FROM #ProductStaging ps
INNER JOIN Categories c ON ps.CategoryName = c.CategoryName
LEFT JOIN Subcategories sc ON ps.SubcategoryName = sc.SubcategoryName AND sc.CategoryID = c.CategoryID
INNER JOIN UoM u ON ps.UnitOfMeasure = u.UoMCode
WHERE ps.ProductCode NOT IN (SELECT ProductCode FROM Products WHERE ProductCode IS NOT NULL);

-- Step 7: Create Retail_Product entries (for POS)
INSERT INTO Retail_Product (ProductID, SKU, Name, Description, IsActive, CreatedAt, UpdatedAt)
SELECT 
    p.ProductID,
    p.SKU,
    p.ProductName,
    ps.Description,
    p.IsActive,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
FROM Products p
INNER JOIN #ProductStaging ps ON p.ProductCode = ps.ProductCode
WHERE p.ProductID NOT IN (SELECT ProductID FROM Retail_Product WHERE ProductID IS NOT NULL);

-- Step 8: Create Retail_Variant entries (for barcode scanning)
INSERT INTO Retail_Variant (ProductID, Barcode, IsActive, CreatedAt, UpdatedAt)
SELECT 
    rp.ProductID,
    rp.SKU,
    1,
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
FROM Retail_Product rp
WHERE rp.ProductID NOT IN (SELECT ProductID FROM Retail_Variant WHERE ProductID IS NOT NULL);

-- Step 9: Create Retail_Price entries (branch-specific pricing)
-- IMPORTANT: Update @BranchID to actual branch
DECLARE @BranchID INT = 1;  -- Change this to actual branch ID

INSERT INTO Retail_Price (ProductID, BranchID, SellingPrice, Currency, EffectiveFrom, CreatedAt)
SELECT 
    p.ProductID,
    @BranchID,
    ps.SellingPrice,
    'ZAR',
    CAST(GETDATE() AS DATE),
    SYSUTCDATETIME()
FROM Products p
INNER JOIN #ProductStaging ps ON p.ProductCode = ps.ProductCode
WHERE NOT EXISTS (
    SELECT 1 FROM Retail_Price 
    WHERE ProductID = p.ProductID 
    AND BranchID = @BranchID 
    AND EffectiveTo IS NULL
);

-- Step 10: Verification queries
PRINT '=== IMPORT SUMMARY ===';
PRINT 'Categories created: ' + CAST((SELECT COUNT(*) FROM Categories) AS VARCHAR);
PRINT 'Subcategories created: ' + CAST((SELECT COUNT(*) FROM Subcategories) AS VARCHAR);
PRINT 'Products imported: ' + CAST((SELECT COUNT(*) FROM Products) AS VARCHAR);
PRINT 'Retail_Product entries: ' + CAST((SELECT COUNT(*) FROM Retail_Product) AS VARCHAR);
PRINT 'Retail_Variant entries: ' + CAST((SELECT COUNT(*) FROM Retail_Variant) AS VARCHAR);
PRINT 'Retail_Price entries: ' + CAST((SELECT COUNT(*) FROM Retail_Price WHERE BranchID = @BranchID) AS VARCHAR);

-- Show imported products
SELECT 
    p.ProductID,
    p.ProductCode,
    p.ProductName,
    p.SKU,
    p.ItemType,
    c.CategoryName,
    sc.SubcategoryName,
    rp.SellingPrice,
    p.LastPaidPrice,
    p.IsActive
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN Subcategories sc ON p.SubcategoryID = sc.SubcategoryID
LEFT JOIN Retail_Price rp ON p.ProductID = rp.ProductID AND rp.BranchID = @BranchID AND rp.EffectiveTo IS NULL
ORDER BY p.ProductCode;

-- Clean up
DROP TABLE #ProductStaging;

PRINT 'Product import completed successfully!';
GO
