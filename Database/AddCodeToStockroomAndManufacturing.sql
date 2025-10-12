-- Add Code field to Stockroom_Product and Manufacturing_Product tables
-- This script adds the missing Code field to these tables

-- Step 1: Add Code field to Stockroom_Product table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Stockroom_Product')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Stockroom_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE dbo.Stockroom_Product 
        ADD Code NVARCHAR(20) NULL
        
        PRINT 'Added Code field to Stockroom_Product table'
        
        -- Populate Code field with sequential values
        DECLARE @RowNum1 INT = 1
        DECLARE @ProductID1 INT
        
        DECLARE stockroom_cursor CURSOR FOR
        SELECT ProductID FROM dbo.Stockroom_Product ORDER BY ProductID
        
        OPEN stockroom_cursor
        FETCH NEXT FROM stockroom_cursor INTO @ProductID1
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE dbo.Stockroom_Product 
            SET Code = RIGHT('00000' + CAST(@RowNum1 AS VARCHAR), 5)
            WHERE ProductID = @ProductID1
            
            SET @RowNum1 = @RowNum1 + 1
            FETCH NEXT FROM stockroom_cursor INTO @ProductID1
        END
        
        CLOSE stockroom_cursor
        DEALLOCATE stockroom_cursor
        
        PRINT 'Populated Code field in Stockroom_Product with sequential values'
    END
    ELSE
        PRINT 'Code field already exists in Stockroom_Product table'
END
ELSE
    PRINT 'Stockroom_Product table does not exist - skipping'

-- Step 2: Add Code field to Manufacturing_Product table
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Manufacturing_Product')
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Manufacturing_Product' AND COLUMN_NAME = 'Code')
    BEGIN
        ALTER TABLE dbo.Manufacturing_Product 
        ADD Code NVARCHAR(20) NULL
        
        PRINT 'Added Code field to Manufacturing_Product table'
        
        -- Populate Code field with sequential values
        DECLARE @RowNum2 INT = 1
        DECLARE @ProductID2 INT
        
        DECLARE manufacturing_cursor CURSOR FOR
        SELECT ProductID FROM dbo.Manufacturing_Product ORDER BY ProductID
        
        OPEN manufacturing_cursor
        FETCH NEXT FROM manufacturing_cursor INTO @ProductID2
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE dbo.Manufacturing_Product 
            SET Code = RIGHT('00000' + CAST(@RowNum2 AS VARCHAR), 5)
            WHERE ProductID = @ProductID2
            
            SET @RowNum2 = @RowNum2 + 1
            FETCH NEXT FROM manufacturing_cursor INTO @ProductID2
        END
        
        CLOSE manufacturing_cursor
        DEALLOCATE manufacturing_cursor
        
        PRINT 'Populated Code field in Manufacturing_Product with sequential values'
    END
    ELSE
        PRINT 'Code field already exists in Manufacturing_Product table'
END
ELSE
    PRINT 'Manufacturing_Product table does not exist - skipping'

PRINT 'Code field addition completed for Stockroom and Manufacturing product tables!'
PRINT 'Code format: 5-digit zero-padded numbers (00001, 00002, etc.)'
