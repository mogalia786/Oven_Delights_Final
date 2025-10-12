-- =============================================
-- STOCKROOM MODULE - FINAL FIX
-- Fixes the Barcode UNIQUE constraint issue
-- Date: 2025-10-03
-- =============================================

PRINT '=== FINAL FIX: Resolving Barcode Constraint Issue ==='
PRINT ''

-- =============================================
-- Step 1: Drop the problematic UNIQUE constraint on Barcode
-- =============================================
PRINT 'Step 1: Removing UNIQUE constraint on Barcode...'

DECLARE @ConstraintName NVARCHAR(200)
SELECT @ConstraintName = name 
FROM sys.key_constraints 
WHERE parent_object_id = OBJECT_ID('Retail_Variant') 
AND type = 'UQ'
AND name LIKE '%Barcode%'

IF @ConstraintName IS NOT NULL
BEGIN
    DECLARE @SQL NVARCHAR(500) = 'ALTER TABLE Retail_Variant DROP CONSTRAINT ' + @ConstraintName
    EXEC sp_executesql @SQL
    PRINT 'UNIQUE constraint on Barcode dropped: ' + @ConstraintName
END
ELSE
BEGIN
    -- Try to find it by column
    SELECT @ConstraintName = kc.name
    FROM sys.key_constraints kc
    INNER JOIN sys.index_columns ic ON kc.parent_object_id = ic.object_id AND kc.unique_index_id = ic.index_id
    INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
    WHERE kc.parent_object_id = OBJECT_ID('Retail_Variant')
    AND c.name = 'Barcode'
    AND kc.type = 'UQ'
    
    IF @ConstraintName IS NOT NULL
    BEGIN
        SET @SQL = 'ALTER TABLE Retail_Variant DROP CONSTRAINT ' + @ConstraintName
        EXEC sp_executesql @SQL
        PRINT 'UNIQUE constraint on Barcode dropped: ' + @ConstraintName
    END
    ELSE
    BEGIN
        PRINT 'No UNIQUE constraint found on Barcode (may already be dropped).'
    END
END
GO

-- =============================================
-- Step 2: Create non-unique index on Barcode instead
-- =============================================
PRINT ''
PRINT 'Step 2: Creating non-unique index on Barcode...'

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Retail_Variant_Barcode' AND object_id = OBJECT_ID('Retail_Variant'))
BEGIN
    CREATE INDEX IX_Retail_Variant_Barcode ON Retail_Variant(Barcode) 
    WHERE Barcode IS NOT NULL;
    PRINT 'Non-unique index created on Barcode.'
END
ELSE
BEGIN
    PRINT 'Index on Barcode already exists.'
END
GO

-- =============================================
-- Step 3: Populate Retail_Variant with Generated Barcodes
-- =============================================
PRINT ''
PRINT 'Step 3: Populating Retail_Variant with generated barcodes...'

-- Create variants for products without them
-- Use ProductCode or generate a barcode if SKU is NULL
INSERT INTO Retail_Variant (ProductID, Barcode, IsActive, CreatedAt, UpdatedAt)
SELECT 
    p.ProductID,
    CASE 
        WHEN p.SKU IS NOT NULL AND p.SKU <> '' THEN p.SKU
        WHEN p.ProductCode IS NOT NULL AND p.ProductCode <> '' THEN p.ProductCode
        ELSE 'GEN' + RIGHT('000000' + CAST(p.ProductID AS VARCHAR), 6)  -- Generate barcode
    END AS Barcode,
    ISNULL(p.IsActive, 1),
    SYSUTCDATETIME(),
    SYSUTCDATETIME()
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID
)
AND ISNULL(p.ItemType, 'Manufactured') IN ('External', 'Manufactured');

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' variants created for existing products.'
GO

-- =============================================
-- Step 4: Update Products ItemType
-- =============================================
PRINT ''
PRINT 'Step 4: Setting default ItemType for products...'

-- Set ItemType to Manufactured for products without it
UPDATE Products 
SET ItemType = 'Manufactured'
WHERE ItemType IS NULL;

PRINT CAST(@@ROWCOUNT AS VARCHAR) + ' products set to Manufactured.'
GO

-- =============================================
-- Step 5: Verification Report
-- =============================================
PRINT ''
PRINT '========================================='
PRINT 'VERIFICATION REPORT'
PRINT '========================================='
PRINT ''

-- Products by ItemType
PRINT 'PRODUCTS BY TYPE:'
SELECT 
    ISNULL(ItemType, 'NULL') AS ItemType,
    COUNT(*) AS ProductCount
FROM Products
WHERE ISNULL(IsActive, 1) = 1
GROUP BY ItemType
ORDER BY ItemType;
PRINT ''

-- Variants created
DECLARE @VariantCount INT
SELECT @VariantCount = COUNT(*) FROM Retail_Variant WHERE IsActive = 1
PRINT 'RETAIL VARIANTS:'
PRINT '  Total Active Variants: ' + CAST(@VariantCount AS VARCHAR)
PRINT ''

-- Products without variants
DECLARE @ProductsWithoutVariants INT
SELECT @ProductsWithoutVariants = COUNT(*)
FROM Products p
WHERE ISNULL(p.ItemType, 'External') IN ('External', 'Manufactured')
AND ISNULL(p.IsActive, 1) = 1
AND NOT EXISTS (SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID);

IF @ProductsWithoutVariants > 0
BEGIN
    PRINT 'WARNING: ' + CAST(@ProductsWithoutVariants AS VARCHAR) + ' products still without variants!'
    PRINT ''
    PRINT 'Products without variants:'
    SELECT TOP 10 
        ProductID, 
        ProductCode, 
        ProductName, 
        ISNULL(ItemType, 'NULL') AS ItemType,
        SKU
    FROM Products p
    WHERE ISNULL(p.ItemType, 'External') IN ('External', 'Manufactured')
    AND ISNULL(p.IsActive, 1) = 1
    AND NOT EXISTS (SELECT 1 FROM Retail_Variant rv WHERE rv.ProductID = p.ProductID);
END
ELSE
BEGIN
    PRINT '✓ SUCCESS: All retail products have variants!'
END
PRINT ''

-- Show sample variants
PRINT 'SAMPLE VARIANTS CREATED:'
SELECT TOP 10
    rv.VariantID,
    p.ProductCode,
    p.ProductName,
    rv.Barcode,
    p.ItemType
FROM Retail_Variant rv
INNER JOIN Products p ON rv.ProductID = p.ProductID
ORDER BY rv.VariantID DESC;
PRINT ''

-- Stock summary
PRINT 'STOCK SUMMARY:'
SELECT 
    b.BranchName,
    COUNT(DISTINCT rs.VariantID) AS UniqueProducts,
    SUM(rs.QtyOnHand) AS TotalQuantity
FROM Retail_Stock rs
INNER JOIN Branches b ON rs.BranchID = b.BranchID
GROUP BY b.BranchName
ORDER BY b.BranchName;
PRINT ''

PRINT '========================================='
PRINT 'FINAL FIX COMPLETE!'
PRINT '========================================='
PRINT ''
PRINT 'Next Steps:'
PRINT '1. Review products and manually set ItemType:'
PRINT '   - External: Products purchased from suppliers (Coke, Bread, etc.)'
PRINT '   - RawMaterial: Ingredients for manufacturing (Flour, Butter, etc.)'
PRINT '   - Manufactured: Products made in-house (Cakes, Pastries, etc.)'
PRINT ''
PRINT '2. Update ItemType using:'
PRINT '   UPDATE Products SET ItemType = ''External'' WHERE ProductCode IN (''...'');'
PRINT '   UPDATE Products SET ItemType = ''RawMaterial'' WHERE ProductCode IN (''...'');'
PRINT ''
PRINT '3. Test Purchase Order → Invoice Capture workflow'
PRINT ''
GO
