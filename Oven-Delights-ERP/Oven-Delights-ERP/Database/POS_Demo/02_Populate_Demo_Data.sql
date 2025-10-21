-- =============================================
-- POS DEMO TABLES - STEP 2: POPULATE DATA
-- =============================================
-- Purpose: Populate demo tables from Products master
-- Safe: Only reads from Products, writes to Demo tables
-- Includes: Simulated prices and stock quantities
-- =============================================




PRINT '========================================';
PRINT 'Populating Demo Tables with Data';
PRINT 'Bismillah - Starting with Allah''s name';
PRINT '========================================';
GO

-- =============================================
-- STEP 1: Populate Demo_Retail_Product from Products Master
-- =============================================
PRINT 'Step 1: Copying products from master Products table...';
GO

INSERT INTO dbo.Demo_Retail_Product (SKU, Name, Category, Description, IsActive)
SELECT 
    ISNULL(SKU, 'SKU-' + CAST(ProductID AS VARCHAR(10))) AS SKU,
    ProductName AS Name,
    'General' AS Category, -- Default category since Products table doesn't have Category column
    ProductName AS Description, -- Use ProductName as description
    CASE WHEN IsActive = 1 THEN 1 ELSE 0 END AS IsActive
FROM dbo.Products
WHERE IsActive = 1;
GO

DECLARE @ProductCount INT = @@ROWCOUNT;
PRINT '✓ Copied ' + CAST(@ProductCount AS VARCHAR(10)) + ' products from master table';
GO

-- =============================================
-- STEP 2: Create Variants for Each Product
-- =============================================
PRINT 'Step 2: Creating variants for all products...';
GO

INSERT INTO dbo.Demo_Retail_Variant (ProductID, Barcode, IsActive)
SELECT 
    ProductID,
    SKU AS Barcode,
    IsActive
FROM dbo.Demo_Retail_Product;
GO

DECLARE @VariantCount INT = @@ROWCOUNT;
PRINT '✓ Created ' + CAST(@VariantCount AS VARCHAR(10)) + ' variants';
GO

-- =============================================
-- STEP 3: Generate Simulated Prices
-- =============================================
PRINT 'Step 3: Generating simulated prices based on categories...';
GO

-- Price simulation based on product category
INSERT INTO dbo.Demo_Retail_Price (ProductID, BranchID, SellingPrice, CostPrice, EffectiveFrom)
SELECT 
    p.ProductID,
    NULL AS BranchID, -- NULL = applies to all branches
    CASE 
        -- Bread products
        WHEN p.Category LIKE '%Bread%' OR p.Category LIKE '%Loaf%' 
            THEN ROUND(15 + (ABS(CHECKSUM(NEWID())) % 36), 2) -- R15-R50
        
        -- Rolls and buns
        WHEN p.Category LIKE '%Roll%' OR p.Category LIKE '%Bun%' 
            THEN ROUND(5 + (ABS(CHECKSUM(NEWID())) % 16), 2) -- R5-R20
        
        -- Pastries
        WHEN p.Category LIKE '%Pastry%' OR p.Category LIKE '%Croissant%' OR p.Category LIKE '%Danish%'
            THEN ROUND(25 + (ABS(CHECKSUM(NEWID())) % 56), 2) -- R25-R80
        
        -- Cakes
        WHEN p.Category LIKE '%Cake%' 
            THEN ROUND(50 + (ABS(CHECKSUM(NEWID())) % 451), 2) -- R50-R500
        
        -- Cookies and biscuits
        WHEN p.Category LIKE '%Cookie%' OR p.Category LIKE '%Biscuit%'
            THEN ROUND(10 + (ABS(CHECKSUM(NEWID())) % 31), 2) -- R10-R40
        
        -- Pies
        WHEN p.Category LIKE '%Pie%' 
            THEN ROUND(30 + (ABS(CHECKSUM(NEWID())) % 71), 2) -- R30-R100
        
        -- Tarts
        WHEN p.Category LIKE '%Tart%' 
            THEN ROUND(20 + (ABS(CHECKSUM(NEWID())) % 131), 2) -- R20-R150
        
        -- Donuts
        WHEN p.Category LIKE '%Donut%' OR p.Category LIKE '%Doughnut%'
            THEN ROUND(8 + (ABS(CHECKSUM(NEWID())) % 28), 2) -- R8-R35
        
        -- Muffins
        WHEN p.Category LIKE '%Muffin%' 
            THEN ROUND(15 + (ABS(CHECKSUM(NEWID())) % 31), 2) -- R15-R45
        
        -- Scones
        WHEN p.Category LIKE '%Scone%' 
            THEN ROUND(12 + (ABS(CHECKSUM(NEWID())) % 29), 2) -- R12-R40
        
        -- Cupcakes
        WHEN p.Category LIKE '%Cupcake%' 
            THEN ROUND(18 + (ABS(CHECKSUM(NEWID())) % 33), 2) -- R18-R50
        
        -- Brownies
        WHEN p.Category LIKE '%Brownie%' 
            THEN ROUND(15 + (ABS(CHECKSUM(NEWID())) % 36), 2) -- R15-R50
        
        -- Slices
        WHEN p.Category LIKE '%Slice%' 
            THEN ROUND(20 + (ABS(CHECKSUM(NEWID())) % 41), 2) -- R20-R60
        
        -- Default for uncategorized
        ELSE ROUND(20 + (ABS(CHECKSUM(NEWID())) % 81), 2) -- R20-R100
    END AS SellingPrice,
    NULL AS CostPrice, -- Will calculate below
    CAST(GETDATE() AS DATE) AS EffectiveFrom
FROM dbo.Demo_Retail_Product p;
GO

-- Calculate cost price as 60% of selling price (40% markup)
UPDATE dbo.Demo_Retail_Price
SET CostPrice = ROUND(SellingPrice * 0.60, 2);
GO

DECLARE @PriceCount INT = (SELECT COUNT(*) FROM dbo.Demo_Retail_Price);
PRINT '✓ Generated ' + CAST(@PriceCount AS VARCHAR(10)) + ' prices';
GO

-- =============================================
-- STEP 4: Populate Stock for All Branches
-- =============================================
PRINT 'Step 4: Generating stock quantities for all branches...';
GO

-- Create stock records for each variant at each active branch
INSERT INTO dbo.Demo_Retail_Stock (VariantID, BranchID, QtyOnHand, ReorderPoint, Location)
SELECT 
    v.VariantID,
    b.BranchID,
    -- Random quantity between 10 and 100
    CAST(10 + (ABS(CHECKSUM(NEWID())) % 91) AS DECIMAL(18,3)) AS QtyOnHand,
    -- Reorder point between 5 and 20
    CAST(5 + (ABS(CHECKSUM(NEWID())) % 16) AS DECIMAL(18,3)) AS ReorderPoint,
    'SHELF-A' AS Location
FROM dbo.Demo_Retail_Variant v
CROSS JOIN dbo.Branches b
WHERE b.IsActive = 1;
GO

DECLARE @StockCount INT = @@ROWCOUNT;
PRINT '✓ Created ' + CAST(@StockCount AS VARCHAR(10)) + ' stock records';
GO

-- =============================================
-- STEP 5: Add Sample Product Images (Placeholders)
-- =============================================
PRINT 'Step 5: Adding placeholder product images...';
GO

-- Add placeholder images for first 10 products
INSERT INTO dbo.Demo_Retail_ProductImage (ProductID, ImageUrl, ThumbnailUrl, IsPrimary)
SELECT TOP 10
    ProductID,
    '/images/products/placeholder.jpg' AS ImageUrl,
    '/images/products/placeholder_thumb.jpg' AS ThumbnailUrl,
    1 AS IsPrimary
FROM dbo.Demo_Retail_Product
ORDER BY ProductID;
GO

DECLARE @ImageCount INT = @@ROWCOUNT;
PRINT '✓ Added ' + CAST(@ImageCount AS VARCHAR(10)) + ' placeholder images';
GO

-- =============================================
-- VERIFICATION QUERIES
-- =============================================
PRINT '';
PRINT '========================================';
PRINT 'DATA POPULATION SUMMARY';
PRINT '========================================';
GO

DECLARE @Products INT = (SELECT COUNT(*) FROM Demo_Retail_Product);
DECLARE @Variants INT = (SELECT COUNT(*) FROM Demo_Retail_Variant);
DECLARE @Prices INT = (SELECT COUNT(*) FROM Demo_Retail_Price);
DECLARE @Stock INT = (SELECT COUNT(*) FROM Demo_Retail_Stock);
DECLARE @Images INT = (SELECT COUNT(*) FROM Demo_Retail_ProductImage);

PRINT 'Products:  ' + CAST(@Products AS VARCHAR(10));
PRINT 'Variants:  ' + CAST(@Variants AS VARCHAR(10));
PRINT 'Prices:    ' + CAST(@Prices AS VARCHAR(10));
PRINT 'Stock:     ' + CAST(@Stock AS VARCHAR(10));
PRINT 'Images:    ' + CAST(@Images AS VARCHAR(10));
GO

-- Show price range by category
PRINT '';
PRINT 'Price Ranges by Category:';
PRINT '----------------------------------------';
SELECT 
    p.Category,
    COUNT(*) AS ProductCount,
    MIN(pr.SellingPrice) AS MinPrice,
    MAX(pr.SellingPrice) AS MaxPrice,
    AVG(pr.SellingPrice) AS AvgPrice
FROM Demo_Retail_Product p
INNER JOIN Demo_Retail_Price pr ON p.ProductID = pr.ProductID
GROUP BY p.Category
ORDER BY p.Category;
GO

-- Show stock summary by branch
PRINT '';
PRINT 'Stock Summary by Branch:';
PRINT '----------------------------------------';
SELECT 
    b.BranchName,
    COUNT(DISTINCT s.VariantID) AS UniqueProducts,
    SUM(s.QtyOnHand) AS TotalQuantity,
    AVG(s.QtyOnHand) AS AvgQuantity
FROM Demo_Retail_Stock s
INNER JOIN Branches b ON s.BranchID = b.BranchID
GROUP BY b.BranchName
ORDER BY b.BranchName;
GO

PRINT '';
PRINT '========================================';
PRINT 'SUCCESS! Demo Data Populated';
PRINT '========================================';
PRINT 'Your POS demo environment is ready!';
PRINT '';
PRINT 'Next Steps:';
PRINT '1. Review the data above';
PRINT '2. Configure POS to use Demo tables';
PRINT '3. Start building the POS interface';
PRINT '========================================';
GO
