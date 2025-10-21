-- Add Code field to Retail_Product table only - completely isolated approach
-- This script handles only Retail_Product to avoid any cross-table reference issues

-- Step 1: Check if Code field exists in Retail_Product
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Code')
BEGIN
    -- Add the Code field
    ALTER TABLE dbo.Retail_Product 
    ADD Code NVARCHAR(20) NULL
    
    PRINT 'Added Code field to Retail_Product table'
END
ELSE
BEGIN
    PRINT 'Code field already exists in Retail_Product table'
END
GO

-- Step 2: Populate Code field if it has NULL values (separate batch)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Code')
BEGIN
    IF EXISTS (SELECT 1 FROM dbo.Retail_Product WHERE Code IS NULL)
    BEGIN
        DECLARE @Counter INT = 1
        
        UPDATE dbo.Retail_Product 
        SET Code = FORMAT(@Counter, '00000'),
            @Counter = @Counter + 1
        WHERE Code IS NULL
        
        PRINT 'Populated Code field in Retail_Product with sequential values'
    END
    ELSE
    BEGIN
        PRINT 'Code field in Retail_Product already populated'
    END
END
GO

-- Step 3: Create unique index if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Retail_Product_Code' AND object_id = OBJECT_ID('dbo.Retail_Product'))
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX IX_Retail_Product_Code 
    ON dbo.Retail_Product (Code) 
    WHERE Code IS NOT NULL
    
    PRINT 'Created unique index on Retail_Product.Code'
END
ELSE
BEGIN
    PRINT 'Unique index on Retail_Product.Code already exists'
END

PRINT 'Code field setup completed for Retail_Product table!'
PRINT 'Code format: 5-digit zero-padded numbers (00001, 00002, etc.)'
