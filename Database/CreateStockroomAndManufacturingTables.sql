-- Create Stockroom_Product and Manufacturing_Product tables
-- These tables mirror the Retail_Product structure with Code field included

-- Create Stockroom_Product table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Stockroom_Product')
BEGIN
    CREATE TABLE dbo.Stockroom_Product (
        ProductID INT IDENTITY(1,1) PRIMARY KEY,
        SKU NVARCHAR(50) NOT NULL,
        Code NVARCHAR(20) NULL,
        ProductName NVARCHAR(255) NOT NULL,
        Category NVARCHAR(100) NULL,
        Description NVARCHAR(MAX) NULL,
        UnitPrice DECIMAL(10,2) NOT NULL DEFAULT 0,
        StockQuantity INT NOT NULL DEFAULT 0,
        ReorderPoint INT NOT NULL DEFAULT 0,
        BranchID INT NOT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        ImageData VARBINARY(MAX) NULL
    )
    
    -- Create unique index on SKU
    CREATE UNIQUE NONCLUSTERED INDEX IX_Stockroom_Product_SKU 
    ON dbo.Stockroom_Product (SKU)
    
    -- Create unique index on Code
    CREATE UNIQUE NONCLUSTERED INDEX IX_Stockroom_Product_Code 
    ON dbo.Stockroom_Product (Code) 
    WHERE Code IS NOT NULL
    
    PRINT 'Created Stockroom_Product table with Code field'
END
ELSE
    PRINT 'Stockroom_Product table already exists'

-- Create Manufacturing_Product table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Manufacturing_Product')
BEGIN
    CREATE TABLE dbo.Manufacturing_Product (
        ProductID INT IDENTITY(1,1) PRIMARY KEY,
        SKU NVARCHAR(50) NOT NULL,
        Code NVARCHAR(20) NULL,
        ProductName NVARCHAR(255) NOT NULL,
        Category NVARCHAR(100) NULL,
        Description NVARCHAR(MAX) NULL,
        UnitCost DECIMAL(10,2) NOT NULL DEFAULT 0,
        ProductionTime INT NULL, -- in minutes
        BranchID INT NOT NULL,
        IsActive BIT NOT NULL DEFAULT 1,
        CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        ModifiedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
        ImageData VARBINARY(MAX) NULL
    )
    
    -- Create unique index on SKU
    CREATE UNIQUE NONCLUSTERED INDEX IX_Manufacturing_Product_SKU 
    ON dbo.Manufacturing_Product (SKU)
    
    -- Create unique index on Code
    CREATE UNIQUE NONCLUSTERED INDEX IX_Manufacturing_Product_Code 
    ON dbo.Manufacturing_Product (Code) 
    WHERE Code IS NOT NULL
    
    PRINT 'Created Manufacturing_Product table with Code field'
END
ELSE
    PRINT 'Manufacturing_Product table already exists'

PRINT 'Stockroom and Manufacturing product tables created successfully!'
PRINT 'Both tables include Code field with unique indexes'
