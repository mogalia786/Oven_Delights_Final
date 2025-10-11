-- Enforce Mandatory Category and Subcategory for All Products
-- Prevents orphaned products and ensures proper POS classification

-- Step 1: Make Category and Subcategory NOT NULL in all product tables
-- Retail_Product
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Category' AND IS_NULLABLE = 'YES')
BEGIN
    -- First, assign default category to orphaned products
    UPDATE dbo.Retail_Product 
    SET Category = 'Uncategorized', 
        Subcategory = 'General'
    WHERE Category IS NULL OR Category = ''
    
    -- Make Category NOT NULL
    ALTER TABLE dbo.Retail_Product 
    ALTER COLUMN Category NVARCHAR(50) NOT NULL
    
    PRINT 'Made Category mandatory in Retail_Product table'
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Subcategory' AND IS_NULLABLE = 'YES')
BEGIN
    -- Assign default subcategory to orphaned products
    UPDATE dbo.Retail_Product 
    SET Subcategory = 'General'
    WHERE Subcategory IS NULL OR Subcategory = ''
    
    -- Make Subcategory NOT NULL
    ALTER TABLE dbo.Retail_Product 
    ALTER COLUMN Subcategory NVARCHAR(50) NOT NULL
    
    PRINT 'Made Subcategory mandatory in Retail_Product table'
END
GO

-- Stockroom_Product
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Category' AND IS_NULLABLE = 'YES')
BEGIN
    UPDATE dbo.Stockroom_Product 
    SET Category = 'Raw Materials', 
        Subcategory = 'General'
    WHERE Category IS NULL OR Category = ''
    
    ALTER TABLE dbo.Stockroom_Product 
    ALTER COLUMN Category NVARCHAR(50) NOT NULL
    
    PRINT 'Made Category mandatory in Stockroom_Product table'
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Subcategory' AND IS_NULLABLE = 'YES')
BEGIN
    UPDATE dbo.Stockroom_Product 
    SET Subcategory = 'General'
    WHERE Subcategory IS NULL OR Subcategory = ''
    
    ALTER TABLE dbo.Stockroom_Product 
    ALTER COLUMN Subcategory NVARCHAR(50) NOT NULL
    
    PRINT 'Made Subcategory mandatory in Stockroom_Product table'
END
GO

-- Manufacturing_Product
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Manufacturing_Product' AND COLUMN_NAME = 'Category' AND IS_NULLABLE = 'YES')
BEGIN
    UPDATE dbo.Manufacturing_Product 
    SET Category = 'Manufactured Goods', 
        Subcategory = 'General'
    WHERE Category IS NULL OR Category = ''
    
    ALTER TABLE dbo.Manufacturing_Product 
    ALTER COLUMN Category NVARCHAR(50) NOT NULL
    
    PRINT 'Made Category mandatory in Manufacturing_Product table'
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Manufacturing_Product' AND COLUMN_NAME = 'Subcategory' AND IS_NULLABLE = 'YES')
BEGIN
    UPDATE dbo.Manufacturing_Product 
    SET Subcategory = 'General'
    WHERE Subcategory IS NULL OR Subcategory = ''
    
    ALTER TABLE dbo.Manufacturing_Product 
    ALTER COLUMN Subcategory NVARCHAR(50) NOT NULL
    
    PRINT 'Made Subcategory mandatory in Manufacturing_Product table'
END
GO

-- Step 2: Add "Uncategorized" category for orphaned products
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'UNCAT')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('UNCAT', 'Uncategorized', 1)

IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'MANUF')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('MANUF', 'Manufactured Goods', 1)

-- Add corresponding subcategories
IF NOT EXISTS (SELECT 1 FROM dbo.ProductSubcategories WHERE SubcategoryCode = 'GENERAL')
BEGIN
    INSERT INTO dbo.ProductSubcategories (CategoryID, SubcategoryCode, SubcategoryName)
    SELECT pc.CategoryID, 'GENERAL', 'General'
    FROM dbo.ProductCategories pc 
    WHERE pc.CategoryCode IN ('UNCAT', 'RAWMAT', 'MANUF')
END
GO

-- Step 3: Create Orphaned Product Detection View
CREATE OR ALTER VIEW vw_OrphanedProducts AS
SELECT 
    'Retail' AS ProductModule,
    rp.ProductID,
    rp.SKU,
    rp.Code,
    rp.Name AS ProductName,
    rp.Category,
    rp.Subcategory,
    CASE 
        WHEN rp.Category = 'Uncategorized' OR rp.Subcategory = 'General' 
        THEN 'ORPHANED - Needs Category/Subcategory Assignment'
        WHEN NOT EXISTS (SELECT 1 FROM dbo.ProductCategories pc WHERE pc.CategoryName = rp.Category)
        THEN 'INVALID CATEGORY - Category does not exist'
        WHEN NOT EXISTS (SELECT 1 FROM dbo.ProductSubcategories ps 
                        INNER JOIN dbo.ProductCategories pc ON ps.CategoryID = pc.CategoryID 
                        WHERE pc.CategoryName = rp.Category AND ps.SubcategoryName = rp.Subcategory)
        THEN 'INVALID SUBCATEGORY - Subcategory does not exist for this category'
        ELSE 'PROPERLY CLASSIFIED'
    END AS ClassificationStatus,
    rp.IsActive,
    rp.CreatedAt AS CreatedDate
FROM dbo.Retail_Product rp
WHERE rp.IsActive = 1

UNION ALL

SELECT 
    'Stockroom' AS ProductModule,
    sp.ProductID,
    sp.SKU,
    sp.Code,
    sp.ProductName,
    sp.Category,
    sp.Subcategory,
    CASE 
        WHEN sp.Category = 'Raw Materials' AND sp.Subcategory = 'General' 
        THEN 'ORPHANED - Needs Category/Subcategory Assignment'
        WHEN NOT EXISTS (SELECT 1 FROM dbo.ProductCategories pc WHERE pc.CategoryName = sp.Category)
        THEN 'INVALID CATEGORY - Category does not exist'
        WHEN NOT EXISTS (SELECT 1 FROM dbo.ProductSubcategories ps 
                        INNER JOIN dbo.ProductCategories pc ON ps.CategoryID = pc.CategoryID 
                        WHERE pc.CategoryName = sp.Category AND ps.SubcategoryName = sp.Subcategory)
        THEN 'INVALID SUBCATEGORY - Subcategory does not exist for this category'
        ELSE 'PROPERLY CLASSIFIED'
    END AS ClassificationStatus,
    sp.IsActive,
    sp.CreatedDate
FROM dbo.Stockroom_Product sp
WHERE sp.IsActive = 1

UNION ALL

SELECT 
    'Manufacturing' AS ProductModule,
    mp.ProductID,
    mp.SKU,
    mp.Code,
    mp.ProductName,
    mp.Category,
    mp.Subcategory,
    CASE 
        WHEN mp.Category = 'Manufactured Goods' AND mp.Subcategory = 'General' 
        THEN 'ORPHANED - Needs Category/Subcategory Assignment'
        WHEN NOT EXISTS (SELECT 1 FROM dbo.ProductCategories pc WHERE pc.CategoryName = mp.Category)
        THEN 'INVALID CATEGORY - Category does not exist'
        WHEN NOT EXISTS (SELECT 1 FROM dbo.ProductSubcategories ps 
                        INNER JOIN dbo.ProductCategories pc ON ps.CategoryID = pc.CategoryID 
                        WHERE pc.CategoryName = mp.Category AND ps.SubcategoryName = mp.Subcategory)
        THEN 'INVALID SUBCATEGORY - Subcategory does not exist for this category'
        ELSE 'PROPERLY CLASSIFIED'
    END AS ClassificationStatus,
    mp.IsActive,
    mp.CreatedDate
FROM dbo.Manufacturing_Product mp
WHERE mp.IsActive = 1
GO

-- Step 4: Create POS-Ready Product View (Only properly classified products)
CREATE OR ALTER VIEW vw_POSProducts AS
SELECT 
    pc.CategoryName,
    ps.SubcategoryName,
    rp.ProductID,
    rp.SKU,
    rp.Code,
    rp.Name AS ProductName,
    rpr.SellingPrice,
    rst.QtyOnHand AS StockQuantity,
    rst.ReorderPoint,
    CASE 
        WHEN rst.QtyOnHand <= 0 THEN 'OUT OF STOCK'
        WHEN rst.QtyOnHand <= rst.ReorderPoint THEN 'LOW STOCK'
        ELSE 'IN STOCK'
    END AS StockStatus,
    rp.IsActive,
    'Retail' AS ProductModule
FROM dbo.Retail_Product rp
INNER JOIN dbo.ProductCategories pc ON pc.CategoryName = rp.Category
INNER JOIN dbo.ProductSubcategories ps ON ps.CategoryID = pc.CategoryID AND ps.SubcategoryName = rp.Subcategory
LEFT JOIN dbo.Retail_Variant rv ON rv.ProductID = rp.ProductID AND rv.IsActive = 1
LEFT JOIN dbo.Retail_Stock rst ON rst.VariantID = rv.VariantID
LEFT JOIN dbo.Retail_Price rpr ON rpr.ProductID = rp.ProductID AND rpr.EffectiveTo IS NULL
WHERE rp.IsActive = 1 
    AND rp.Category != 'Uncategorized' 
    AND rp.Subcategory != 'General'
    AND pc.IsActive = 1 
    AND ps.IsActive = 1
GO

-- Step 5: Create stored procedure to validate product classification
CREATE OR ALTER PROCEDURE sp_ValidateProductClassification
    @ProductModule NVARCHAR(20),
    @ProductID INT,
    @Category NVARCHAR(50),
    @Subcategory NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IsValid BIT = 0
    DECLARE @ErrorMessage NVARCHAR(500) = ''
    
    -- Check if category exists
    IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryName = @Category AND IsActive = 1)
    BEGIN
        SET @ErrorMessage = 'Category "' + @Category + '" does not exist or is inactive'
        SELECT @IsValid AS IsValid, @ErrorMessage AS ErrorMessage
        RETURN
    END
    
    -- Check if subcategory exists for the category
    IF NOT EXISTS (
        SELECT 1 FROM dbo.ProductSubcategories ps 
        INNER JOIN dbo.ProductCategories pc ON ps.CategoryID = pc.CategoryID 
        WHERE pc.CategoryName = @Category AND ps.SubcategoryName = @Subcategory 
        AND pc.IsActive = 1 AND ps.IsActive = 1
    )
    BEGIN
        SET @ErrorMessage = 'Subcategory "' + @Subcategory + '" does not exist for category "' + @Category + '"'
        SELECT @IsValid AS IsValid, @ErrorMessage AS ErrorMessage
        RETURN
    END
    
    -- Check for orphaned classifications
    IF (@Category = 'Uncategorized' OR @Subcategory = 'General')
    BEGIN
        SET @ErrorMessage = 'Product cannot use default "Uncategorized" category or "General" subcategory. Please select proper classification.'
        SELECT @IsValid AS IsValid, @ErrorMessage AS ErrorMessage
        RETURN
    END
    
    SET @IsValid = 1
    SET @ErrorMessage = 'Product classification is valid'
    SELECT @IsValid AS IsValid, @ErrorMessage AS ErrorMessage
END
GO

-- Step 6: Create function to get category/subcategory dropdowns
CREATE OR ALTER FUNCTION fn_GetCategorySubcategoryOptions()
RETURNS TABLE
AS
RETURN
(
    SELECT 
        pc.CategoryID,
        pc.CategoryCode,
        pc.CategoryName,
        ps.SubcategoryID,
        ps.SubcategoryCode,
        ps.SubcategoryName,
        pc.CategoryName + ' → ' + ps.SubcategoryName AS FullPath
    FROM dbo.ProductCategories pc
    INNER JOIN dbo.ProductSubcategories ps ON ps.CategoryID = pc.CategoryID
    WHERE pc.IsActive = 1 AND ps.IsActive = 1
)
GO

PRINT 'Mandatory Category/Subcategory enforcement implemented successfully!'
PRINT 'Available components:'
PRINT '- vw_OrphanedProducts: Identifies products needing classification'
PRINT '- vw_POSProducts: POS-ready products with proper classification'
PRINT '- sp_ValidateProductClassification: Validates category/subcategory assignments'
PRINT '- fn_GetCategorySubcategoryOptions: Provides dropdown options for UI'
PRINT ''
PRINT 'Business Rules Enforced:'
PRINT '1. All products MUST have Category and Subcategory (NOT NULL)'
PRINT '2. Orphaned products are detected and flagged'
PRINT '3. Only properly classified products appear in POS'
PRINT '4. Build My Product workflow must include category selection'
