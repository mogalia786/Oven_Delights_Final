-- Fix StockroomStock table to use Demo_Retail_Product

-- Step 1: Check current StockroomStock structure
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'StockroomStock')
BEGIN
    PRINT 'StockroomStock table exists'
    
    -- Show current data
    SELECT TOP 10 * FROM StockroomStock
    
    -- Step 2: Drop foreign key constraint if exists
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_StockroomStock_Products')
    BEGIN
        ALTER TABLE StockroomStock DROP CONSTRAINT FK_StockroomStock_Products
        PRINT 'Dropped FK_StockroomStock_Products'
    END
    
    IF EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_StockroomStock_Demo_Retail_Product')
    BEGIN
        ALTER TABLE StockroomStock DROP CONSTRAINT FK_StockroomStock_Demo_Retail_Product
        PRINT 'Dropped FK_StockroomStock_Demo_Retail_Product'
    END
    
    -- Step 3: Ensure ProductID column exists and is correct type
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('StockroomStock') AND name = 'ProductID')
    BEGIN
        ALTER TABLE StockroomStock ADD ProductID INT NULL
        PRINT 'Added ProductID column'
    END
    
    -- Step 4: Ensure BranchID column exists
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('StockroomStock') AND name = 'BranchID')
    BEGIN
        ALTER TABLE StockroomStock ADD BranchID INT NULL
        PRINT 'Added BranchID column'
    END
    
    -- Step 5: Ensure UpdatedBy and UpdatedDate columns exist
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('StockroomStock') AND name = 'UpdatedBy')
    BEGIN
        ALTER TABLE StockroomStock ADD UpdatedBy NVARCHAR(100) NULL
        PRINT 'Added UpdatedBy column'
    END
    
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('StockroomStock') AND name = 'UpdatedDate')
    BEGIN
        ALTER TABLE StockroomStock ADD UpdatedDate DATETIME NULL
        PRINT 'Added UpdatedDate column'
    END
    
    -- Step 6: Add foreign key to Demo_Retail_Product
    ALTER TABLE StockroomStock 
    ADD CONSTRAINT FK_StockroomStock_Demo_Retail_Product 
    FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID)
    
    PRINT 'Added FK to Demo_Retail_Product'
    
    -- Step 7: Show final structure
    SELECT 
        c.name AS ColumnName,
        t.name AS DataType,
        c.max_length AS MaxLength,
        c.is_nullable AS IsNullable
    FROM sys.columns c
    INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
    WHERE c.object_id = OBJECT_ID('StockroomStock')
    ORDER BY c.column_id
    
END
ELSE
BEGIN
    -- Create StockroomStock table if it doesn't exist
    CREATE TABLE StockroomStock (
        StockID INT IDENTITY(1,1) PRIMARY KEY,
        ProductID INT NOT NULL,
        Quantity DECIMAL(18,3) NOT NULL DEFAULT 0,
        BranchID INT NOT NULL,
        UpdatedBy NVARCHAR(100) NULL,
        UpdatedDate DATETIME NULL,
        CONSTRAINT FK_StockroomStock_Demo_Retail_Product FOREIGN KEY (ProductID) REFERENCES Demo_Retail_Product(ProductID)
    )
    
    PRINT 'Created StockroomStock table'
END
GO

PRINT 'StockroomStock schema fixed successfully'
GO
