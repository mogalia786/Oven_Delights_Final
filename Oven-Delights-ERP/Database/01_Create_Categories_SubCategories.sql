-- =============================================
-- CREATE CATEGORIES AND SUBCATEGORIES TABLES
-- =============================================
-- Purpose: Create shared category structure for POS and ERP
-- Maps to Excel: Main Category -> Categories
--                Sub Category -> SubCategories
-- =============================================

USE [OvenDelightsERP];
GO

PRINT '========================================';
PRINT 'Creating Categories and SubCategories';
PRINT '========================================';
GO

-- =============================================
-- 1. Categories Table
-- =============================================
IF OBJECT_ID('dbo.Categories', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.Categories (
        CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
        CategoryName    NVARCHAR(100) NOT NULL UNIQUE,
        DisplayOrder    INT NULL,
        IsActive        BIT NOT NULL DEFAULT 1,
        CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
    
    PRINT '✓ Created Categories table';
END
ELSE
BEGIN
    PRINT '! Categories table already exists';
END
GO

-- =============================================
-- 2. SubCategories Table
-- =============================================
IF OBJECT_ID('dbo.SubCategories', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.SubCategories (
        SubCategoryID   INT IDENTITY(1,1) PRIMARY KEY,
        CategoryID      INT NOT NULL,
        SubCategoryName NVARCHAR(100) NOT NULL,
        DisplayOrder    INT NULL,
        IsActive        BIT NOT NULL DEFAULT 1,
        CreatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        UpdatedDate     DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_SubCategories_Category 
            FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID),
        CONSTRAINT UQ_SubCategories_Name 
            UNIQUE (CategoryID, SubCategoryName)
    );
    
    CREATE INDEX IX_SubCategories_Category ON dbo.SubCategories(CategoryID);
    
    PRINT '✓ Created SubCategories table';
END
ELSE
BEGIN
    PRINT '! SubCategories table already exists';
END
GO

-- =============================================
-- 3. Add Columns to Demo_Retail_Product
-- =============================================
PRINT 'Updating Demo_Retail_Product schema...';
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'ProductCode')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD ProductCode NVARCHAR(50) NULL;
    PRINT '✓ Added ProductCode to Demo_Retail_Product';
END
ELSE
BEGIN
    PRINT '! ProductCode already exists in Demo_Retail_Product';
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'CategoryID')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD CategoryID INT NULL;
    PRINT '✓ Added CategoryID to Demo_Retail_Product';
END
ELSE
BEGIN
    PRINT '! CategoryID already exists in Demo_Retail_Product';
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'SubCategoryID')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD SubCategoryID INT NULL;
    PRINT '✓ Added SubCategoryID to Demo_Retail_Product';
END
ELSE
BEGIN
    PRINT '! SubCategoryID already exists in Demo_Retail_Product';
END
GO

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Demo_Retail_Product') AND name = 'BranchID')
BEGIN
    ALTER TABLE Demo_Retail_Product
    ADD BranchID INT NULL;
    PRINT '✓ Added BranchID to Demo_Retail_Product';
END
ELSE
BEGIN
    PRINT '! BranchID already exists in Demo_Retail_Product';
END
GO

-- Add foreign keys if Categories table exists
IF OBJECT_ID('dbo.Categories', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Product_Category')
    BEGIN
        ALTER TABLE Demo_Retail_Product
        ADD CONSTRAINT FK_Demo_Retail_Product_Category
        FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID);
        PRINT '✓ Added FK to Categories';
    END
    
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Demo_Retail_Product_SubCategory')
    BEGIN
        ALTER TABLE Demo_Retail_Product
        ADD CONSTRAINT FK_Demo_Retail_Product_SubCategory
        FOREIGN KEY (SubCategoryID) REFERENCES dbo.SubCategories(SubCategoryID);
        PRINT '✓ Added FK to SubCategories';
    END
END
GO

-- =============================================
-- 4. Add Columns to Products (Master Table)
-- =============================================
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
BEGIN
    PRINT 'Updating Products (Master) schema...';
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CategoryID')
    BEGIN
        ALTER TABLE Products
        ADD CategoryID INT NULL;
        PRINT '✓ Added CategoryID to Products';
    END
    ELSE
    BEGIN
        PRINT '! CategoryID already exists in Products';
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'SubCategoryID')
    BEGIN
        ALTER TABLE Products
        ADD SubCategoryID INT NULL;
        PRINT '✓ Added SubCategoryID to Products';
    END
    ELSE
    BEGIN
        PRINT '! SubCategoryID already exists in Products';
    END
    
    -- Add foreign keys
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Products_Category')
    BEGIN
        ALTER TABLE Products
        ADD CONSTRAINT FK_Products_Category
        FOREIGN KEY (CategoryID) REFERENCES dbo.Categories(CategoryID);
        PRINT '✓ Added FK to Categories';
    END
    
    IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_Products_SubCategory')
    BEGIN
        ALTER TABLE Products
        ADD CONSTRAINT FK_Products_SubCategory
        FOREIGN KEY (SubCategoryID) REFERENCES dbo.SubCategories(SubCategoryID);
        PRINT '✓ Added FK to SubCategories';
    END
END
ELSE
BEGIN
    PRINT '! Products table not found - skipping master table updates';
END
GO

-- =============================================
-- 5. Create Indexes for Performance
-- =============================================
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Demo_Retail_Product_ProductCode' AND object_id = OBJECT_ID('Demo_Retail_Product'))
BEGIN
    CREATE INDEX IX_Demo_Retail_Product_ProductCode ON Demo_Retail_Product(ProductCode);
    PRINT '✓ Created index on Demo_Retail_Product.ProductCode';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Demo_Retail_Product_Category' AND object_id = OBJECT_ID('Demo_Retail_Product'))
BEGIN
    CREATE INDEX IX_Demo_Retail_Product_Category ON Demo_Retail_Product(CategoryID, SubCategoryID);
    PRINT '✓ Created index on Demo_Retail_Product.CategoryID/SubCategoryID';
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Demo_Retail_Product_Branch' AND object_id = OBJECT_ID('Demo_Retail_Product'))
BEGIN
    CREATE INDEX IX_Demo_Retail_Product_Branch ON Demo_Retail_Product(BranchID, CategoryID, SubCategoryID);
    PRINT '✓ Created index on Demo_Retail_Product.BranchID';
END
GO

PRINT '';
PRINT '========================================';
PRINT 'SUCCESS! Schema Updated';
PRINT '========================================';
PRINT 'Next: Import categories from Excel';
PRINT '========================================';
GO
