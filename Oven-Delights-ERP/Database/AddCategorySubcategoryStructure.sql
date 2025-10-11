-- Add Category and Subcategory structure to product classification system
-- Example: Category = "Cake", Subcategory = "Square Cake", Product = "40cm Lemon Cake"

-- Step 1: Add Category and Subcategory fields to Stockroom_Product
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Category')
BEGIN
    ALTER TABLE dbo.Stockroom_Product 
    ADD Category NVARCHAR(50) NULL
    
    PRINT 'Added Category field to Stockroom_Product table'
END
ELSE
    PRINT 'Category field already exists in Stockroom_Product table'
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Subcategory')
BEGIN
    ALTER TABLE dbo.Stockroom_Product 
    ADD Subcategory NVARCHAR(50) NULL
    
    PRINT 'Added Subcategory field to Stockroom_Product table'
END
ELSE
    PRINT 'Subcategory field already exists in Stockroom_Product table'
GO

-- Step 2: Add Category and Subcategory to Manufacturing_Product
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Manufacturing_Product' AND COLUMN_NAME = 'Subcategory')
BEGIN
    ALTER TABLE dbo.Manufacturing_Product 
    ADD Subcategory NVARCHAR(50) NULL
    
    PRINT 'Added Subcategory field to Manufacturing_Product table'
END
ELSE
    PRINT 'Subcategory field already exists in Manufacturing_Product table'
GO

-- Step 3: Add Subcategory to Retail_Product (Category already exists)
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Subcategory')
BEGIN
    ALTER TABLE dbo.Retail_Product 
    ADD Subcategory NVARCHAR(50) NULL
    
    PRINT 'Added Subcategory field to Retail_Product table'
END
ELSE
    PRINT 'Subcategory field already exists in Retail_Product table'
GO

-- Step 4: Create Categories master table for standardization
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductCategories')
BEGIN
    CREATE TABLE dbo.ProductCategories (
        CategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName NVARCHAR(50) NOT NULL UNIQUE,
        Description NVARCHAR(200) NULL,
        ModuleType NVARCHAR(20) NOT NULL, -- 'Stockroom', 'Manufacturing', 'Retail', 'All'
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE()
    )
    
    PRINT 'Created ProductCategories table'
END
ELSE
    PRINT 'ProductCategories table already exists'
GO

-- Step 5: Create Subcategories master table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ProductSubcategories')
BEGIN
    CREATE TABLE dbo.ProductSubcategories (
        SubcategoryID INT IDENTITY(1,1) PRIMARY KEY,
        CategoryID INT NOT NULL,
        SubcategoryName NVARCHAR(50) NOT NULL,
        Description NVARCHAR(200) NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        
        CONSTRAINT FK_ProductSubcategories_Category FOREIGN KEY (CategoryID) REFERENCES dbo.ProductCategories(CategoryID),
        CONSTRAINT UK_ProductSubcategories_Name UNIQUE (CategoryID, SubcategoryName)
    )
    
    PRINT 'Created ProductSubcategories table'
END
ELSE
    PRINT 'ProductSubcategories table already exists'
GO

-- Step 6: Insert sample categories for bakery business (skip if already exist)
-- Insert categories one by one to avoid duplicate key errors
IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'BREAD')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('BREAD', 'Bread', 1)

IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'CAKE')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('CAKE', 'Cake', 1)

IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'PASTRY')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('PASTRY', 'Pastry', 1)

IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'RAWMAT')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('RAWMAT', 'Raw Materials', 1)

IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'BEVERAGE')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('BEVERAGE', 'Beverages', 1)

IF NOT EXISTS (SELECT 1 FROM dbo.ProductCategories WHERE CategoryCode = 'PACKAGE')
    INSERT INTO dbo.ProductCategories (CategoryCode, CategoryName, CreatedBy) VALUES ('PACKAGE', 'Packaging', 1)

PRINT 'Sample product categories processed'
GO

-- Step 7: Insert sample subcategories (with SubcategoryCode)
IF NOT EXISTS (SELECT 1 FROM dbo.ProductSubcategories WHERE SubcategoryName = 'Square Cake')
BEGIN
    INSERT INTO dbo.ProductSubcategories (CategoryID, SubcategoryCode, SubcategoryName)
    SELECT 
        pc.CategoryID,
        sc.SubcategoryCode,
        sc.SubcategoryName
    FROM (VALUES
        ('Cake', 'SQ_CAKE', 'Square Cake'),
        ('Cake', 'RD_CAKE', 'Round Cake'),
        ('Cake', 'SH_CAKE', 'Sheet Cake'),
        ('Bread', 'WH_BREAD', 'White Bread'),
        ('Bread', 'BR_BREAD', 'Brown Bread'),
        ('Raw Materials', 'FLOUR', 'Flour'),
        ('Raw Materials', 'SUGAR', 'Sugar'),
        ('Raw Materials', 'DAIRY', 'Dairy'),
        ('Beverages', 'SOFT_DRINK', 'Soft Drinks'),
        ('Beverages', 'JUICE', 'Juices')
    ) sc(CategoryName, SubcategoryCode, SubcategoryName)
    INNER JOIN dbo.ProductCategories pc ON pc.CategoryName = sc.CategoryName
    
    PRINT 'Inserted sample product subcategories'
END
ELSE
    PRINT 'Sample subcategories already exist'
GO

-- Step 8: Create view for complete product hierarchy
CREATE OR ALTER VIEW vw_ProductHierarchy AS
SELECT 
    pc.CategoryID,
    pc.CategoryName,
    ps.SubcategoryID,
    ps.SubcategoryName,
    
    -- Stockroom Products
    sp.ProductID AS StockroomProductID,
    sp.SKU AS StockroomSKU,
    sp.Code AS StockroomCode,
    sp.ProductName AS StockroomProductName,
    sp.MaterialType,
    sp.DestinationModule,
    'Stockroom' AS ProductModule
    
FROM dbo.ProductCategories pc
LEFT JOIN dbo.ProductSubcategories ps ON ps.CategoryID = pc.CategoryID
LEFT JOIN dbo.Stockroom_Product sp ON sp.Category = pc.CategoryName AND sp.Subcategory = ps.SubcategoryName
WHERE pc.IsActive = 1 AND (ps.IsActive = 1 OR ps.IsActive IS NULL)

UNION ALL

SELECT 
    pc.CategoryID,
    pc.CategoryName,
    ps.SubcategoryID,
    ps.SubcategoryName,
    
    -- Manufacturing Products
    mp.ProductID AS ManufacturingProductID,
    mp.SKU AS ManufacturingSKU,
    mp.Code AS ManufacturingCode,
    mp.ProductName AS ManufacturingProductName,
    'Manufactured Product' AS MaterialType,
    'Retail' AS DestinationModule,
    'Manufacturing' AS ProductModule
    
FROM dbo.ProductCategories pc
LEFT JOIN dbo.ProductSubcategories ps ON ps.CategoryID = pc.CategoryID
LEFT JOIN dbo.Manufacturing_Product mp ON mp.Category = pc.CategoryName AND mp.Subcategory = ps.SubcategoryName
WHERE pc.IsActive = 1 AND (ps.IsActive = 1 OR ps.IsActive IS NULL)

UNION ALL

SELECT 
    pc.CategoryID,
    pc.CategoryName,
    ps.SubcategoryID,
    ps.SubcategoryName,
    
    -- Retail Products
    rp.ProductID AS RetailProductID,
    rp.SKU AS RetailSKU,
    rp.Code AS RetailCode,
    rp.Name AS RetailProductName,
    CASE 
        WHEN EXISTS (SELECT 1 FROM dbo.Manufacturing_Product mp WHERE mp.SKU = rp.SKU)
        THEN 'Manufactured Product'
        ELSE 'Ready-Made Product'
    END AS MaterialType,
    'Sale' AS DestinationModule,
    'Retail' AS ProductModule
    
FROM dbo.ProductCategories pc
LEFT JOIN dbo.ProductSubcategories ps ON ps.CategoryID = pc.CategoryID
LEFT JOIN dbo.Retail_Product rp ON rp.Category = pc.CategoryName AND rp.Subcategory = ps.SubcategoryName
WHERE pc.IsActive = 1 AND (ps.IsActive = 1 OR ps.IsActive IS NULL)
GO

PRINT 'Category and Subcategory structure added successfully!';
PRINT 'Structure: Category → Subcategory → Product';
PRINT 'Example: Cake → Square Cake → 40cm Lemon Cake';
PRINT 'Available views: vw_ProductHierarchy for complete product classification';
