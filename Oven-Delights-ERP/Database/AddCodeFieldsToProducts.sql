-- Add Code field to all product tables
-- Run this script in your SQL Management environment

-- Step 1: Add Code field to Retail_Product table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Code')
BEGIN
    ALTER TABLE dbo.Retail_Product 
    ADD Code NVARCHAR(20) NULL
    
    PRINT 'Added Code field to Retail_Product table'
END
ELSE
    PRINT 'Code field already exists in Retail_Product table'

-- Step 2: Add Code field to Stockroom_Product table (if it exists)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Stockroom_Product')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE dbo.Stockroom_Product 
        ADD Code NVARCHAR(20) NULL
        
        PRINT 'Added Code field to Stockroom_Product table'
    END
    ELSE
        PRINT 'Code field already exists in Stockroom_Product table'
END
ELSE
    PRINT 'Stockroom_Product table does not exist - skipping'

-- Step 3: Add Code field to Manufacturing_Product table (if it exists)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Manufacturing_Product')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Manufacturing_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE dbo.Manufacturing_Product 
        ADD Code NVARCHAR(20) NULL
        
        PRINT 'Added Code field to Manufacturing_Product table'
    END
    ELSE
        PRINT 'Code field already exists in Manufacturing_Product table'
END
ELSE
    PRINT 'Manufacturing_Product table does not exist - skipping'

-- Step 4: Populate Code field with sequential values for existing products

-- Update Retail_Product codes (only if Code column exists)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Code')
BEGIN
    ;WITH NumberedProducts AS (
        SELECT ProductID, 
               ROW_NUMBER() OVER (ORDER BY ProductID) as RowNum
        FROM dbo.Retail_Product
    )
    UPDATE rp 
    SET Code = RIGHT('00000' + CAST(np.RowNum AS VARCHAR), 5)
    FROM dbo.Retail_Product rp
    INNER JOIN NumberedProducts np ON rp.ProductID = np.ProductID

    PRINT 'Populated Code field in Retail_Product with sequential values'
END
ELSE
    PRINT 'Code column does not exist in Retail_Product - skipping population'

-- Step 5: Update Stockroom_Product codes (if table exists)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Stockroom_Product')
BEGIN
    ;WITH NumberedProducts AS (
        SELECT ProductID, 
               ROW_NUMBER() OVER (ORDER BY ProductID) as RowNum
        FROM dbo.Stockroom_Product
    )
    UPDATE sp 
    SET Code = RIGHT('00000' + CAST(np.RowNum AS VARCHAR), 5)
    FROM dbo.Stockroom_Product sp
    INNER JOIN NumberedProducts np ON sp.ProductID = np.ProductID
    
    PRINT 'Populated Code field in Stockroom_Product with sequential values'
END

-- Step 6: Update Manufacturing_Product codes (if table exists)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Manufacturing_Product')
BEGIN
    ;WITH NumberedProducts AS (
        SELECT ProductID, 
               ROW_NUMBER() OVER (ORDER BY ProductID) as RowNum
        FROM dbo.Manufacturing_Product
    )
    UPDATE mp 
    SET Code = RIGHT('00000' + CAST(np.RowNum AS VARCHAR), 5)
    FROM dbo.Manufacturing_Product mp
    INNER JOIN NumberedProducts np ON mp.ProductID = np.ProductID
    
    PRINT 'Populated Code field in Manufacturing_Product with sequential values'
END

-- Step 7: Create unique index on Code field for Retail_Product (after population)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Retail_Product_Code' AND object_id = OBJECT_ID('dbo.Retail_Product'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_Retail_Product_Code 
    ON dbo.Retail_Product (Code) 
    WHERE Code IS NOT NULL
    
    PRINT 'Created unique index on Retail_Product.Code'
END
ELSE
    PRINT 'Unique index on Retail_Product.Code already exists'

PRINT 'Code field addition and population completed successfully!'
PRINT 'Code format: 5-digit zero-padded numbers (00001, 00002, etc.)'
