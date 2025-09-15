-- Add Code field to all product tables (Retail, Stockroom, Manufacturing)
-- This script adds Code field uniformly across all three product tables

-- Step 1: Add Code field to Retail_Product table
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Retail_Product' AND COLUMN_NAME = 'Code')
BEGIN
    ALTER TABLE dbo.Retail_Product 
    ADD Code NVARCHAR(20) NULL
    
    PRINT 'Added Code field to Retail_Product table'
    
    -- Populate Code field with sequential values
    DECLARE @RowNum1 INT = 1
    DECLARE @ProductID1 INT
    
    DECLARE retail_cursor CURSOR FOR
    SELECT ProductID FROM dbo.Retail_Product ORDER BY ProductID
    
    OPEN retail_cursor
    FETCH NEXT FROM retail_cursor INTO @ProductID1
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE dbo.Retail_Product 
        SET Code = FORMAT(@RowNum1, '00000')
        WHERE ProductID = @ProductID1
        
        SET @RowNum1 = @RowNum1 + 1
        FETCH NEXT FROM retail_cursor INTO @ProductID1
    END
    
    CLOSE retail_cursor
    DEALLOCATE retail_cursor
    
    PRINT 'Populated Code field in Retail_Product with sequential values'
    
    -- Create unique index on Code field
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Retail_Product_Code' AND object_id = OBJECT_ID('dbo.Retail_Product'))
    BEGIN
        CREATE UNIQUE NONCLUSTERED INDEX IX_Retail_Product_Code 
        ON dbo.Retail_Product (Code) 
        WHERE Code IS NOT NULL
        
        PRINT 'Created unique index on Retail_Product.Code'
    END
END
ELSE
    PRINT 'Code field already exists in Retail_Product table'

-- Step 2: Add Code field to Stockroom_Product table (if it exists and needs Code field)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Stockroom_Product')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE dbo.Stockroom_Product 
        ADD Code NVARCHAR(20) NULL
        
        PRINT 'Added Code field to Stockroom_Product table'
    END
    
    -- Only populate if Code field exists and has NULL values
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.Stockroom_Product WHERE Code IS NULL)
        BEGIN
            DECLARE @RowNum2 INT = 1
            DECLARE @ProductID2 INT
            
            DECLARE stockroom_cursor CURSOR FOR
            SELECT ProductID FROM dbo.Stockroom_Product WHERE Code IS NULL ORDER BY ProductID
            
            OPEN stockroom_cursor
            FETCH NEXT FROM stockroom_cursor INTO @ProductID2
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE dbo.Stockroom_Product 
                SET Code = FORMAT(@RowNum2, '00000')
                WHERE ProductID = @ProductID2
                
                SET @RowNum2 = @RowNum2 + 1
                FETCH NEXT FROM stockroom_cursor INTO @ProductID2
            END
            
            CLOSE stockroom_cursor
            DEALLOCATE stockroom_cursor
            
            PRINT 'Populated Code field in Stockroom_Product with sequential values'
        END
        ELSE
            PRINT 'Code field in Stockroom_Product already populated'
    END
END
ELSE
    PRINT 'Stockroom_Product table does not exist - skipping'

-- Step 3: Add Code field to Manufacturing_Product table (if it exists and needs Code field)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Manufacturing_Product')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Manufacturing_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE dbo.Manufacturing_Product 
        ADD Code NVARCHAR(20) NULL
        
        PRINT 'Added Code field to Manufacturing_Product table'
    END
    
    -- Only populate if Code field exists and has NULL values
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Manufacturing_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.Manufacturing_Product WHERE Code IS NULL)
        BEGIN
            DECLARE @RowNum3 INT = 1
            DECLARE @ProductID3 INT
            
            DECLARE manufacturing_cursor CURSOR FOR
            SELECT ProductID FROM dbo.Manufacturing_Product WHERE Code IS NULL ORDER BY ProductID
            
            OPEN manufacturing_cursor
            FETCH NEXT FROM manufacturing_cursor INTO @ProductID3
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                UPDATE dbo.Manufacturing_Product 
                SET Code = FORMAT(@RowNum3, '00000')
                WHERE ProductID = @ProductID3
                
                SET @RowNum3 = @RowNum3 + 1
                FETCH NEXT FROM manufacturing_cursor INTO @ProductID3
            END
            
            CLOSE manufacturing_cursor
            DEALLOCATE manufacturing_cursor
            
            PRINT 'Populated Code field in Manufacturing_Product with sequential values'
        END
        ELSE
            PRINT 'Code field in Manufacturing_Product already populated'
    END
END
ELSE
    PRINT 'Manufacturing_Product table does not exist - skipping'

PRINT 'Code field addition completed successfully for all product tables!'
PRINT 'Code format: 5-digit zero-padded numbers (00001, 00002, etc.)'
PRINT 'All product tables now have uniform Code field structure'
