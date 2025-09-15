-- Add Code field to all product tables and populate with sequential values
-- This is a completely rewritten version to avoid column reference errors

-- Step 1: Add Code field to Retail_Product table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Code')
BEGIN
    ALTER TABLE dbo.Retail_Product 
    ADD Code NVARCHAR(20) NULL
    
    PRINT 'Added Code field to Retail_Product table'
    
    -- Immediately populate the Code field after adding it
    UPDATE dbo.Retail_Product 
    SET Code = RIGHT('00000' + CAST(ROW_NUMBER() OVER (ORDER BY ProductID) AS VARCHAR), 5)
    
    PRINT 'Populated Code field in Retail_Product with sequential values'
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
        
        -- Populate the Code field
        UPDATE dbo.Stockroom_Product 
        SET Code = RIGHT('00000' + CAST(ROW_NUMBER() OVER (ORDER BY ProductID) AS VARCHAR), 5)
        
        PRINT 'Populated Code field in Stockroom_Product with sequential values'
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
        
        -- Populate the Code field
        UPDATE dbo.Manufacturing_Product 
        SET Code = RIGHT('00000' + CAST(ROW_NUMBER() OVER (ORDER BY ProductID) AS VARCHAR), 5)
        
        PRINT 'Populated Code field in Manufacturing_Product with sequential values'
    END
    ELSE
        PRINT 'Code field already exists in Manufacturing_Product table'
END
ELSE
    PRINT 'Manufacturing_Product table does not exist - skipping'

-- Step 4: Create unique index on Code field for Retail_Product
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
