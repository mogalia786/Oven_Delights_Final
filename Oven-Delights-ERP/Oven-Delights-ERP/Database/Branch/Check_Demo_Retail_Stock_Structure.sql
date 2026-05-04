-- =============================================
-- Check Demo_Retail_Stock table structure and data
-- =============================================

-- 1. Check if Demo_Retail_Stock table exists
IF OBJECT_ID('Demo_Retail_Stock', 'U') IS NOT NULL
BEGIN
    PRINT 'Demo_Retail_Stock table EXISTS';
    
    -- Show table structure
    EXEC sp_help 'Demo_Retail_Stock';
    
    -- Show sample data
    SELECT TOP 10 * FROM Demo_Retail_Stock;
    
    -- Count records per branch
    SELECT 
        BranchID,
        COUNT(*) AS RecordCount
    FROM Demo_Retail_Stock
    GROUP BY BranchID
    ORDER BY BranchID;
END
ELSE
BEGIN
    PRINT 'Demo_Retail_Stock table DOES NOT EXIST - Need to create it!';
    
    -- Check what stock tables exist
    SELECT 
        TABLE_NAME,
        TABLE_TYPE
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME LIKE '%Stock%'
    ORDER BY TABLE_NAME;
END

-- 2. Check Products table structure (master catalog)
PRINT 'Checking Products table structure:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;

-- 3. Check if Products has Category and SubCategory
SELECT TOP 10
    ProductID,
    ProductCode,
    ProductName,
    Category,
    SubCategory,
    ProductType
FROM Products
ORDER BY ProductID;

-- 4. Check RetailStock table (the one we've been using)
IF OBJECT_ID('RetailStock', 'U') IS NOT NULL
BEGIN
    PRINT 'RetailStock table structure:';
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'RetailStock'
    ORDER BY ORDINAL_POSITION;
    
    -- Count records
    SELECT 
        BranchID,
        COUNT(*) AS RecordCount
    FROM RetailStock
    GROUP BY BranchID
    ORDER BY BranchID;
END
