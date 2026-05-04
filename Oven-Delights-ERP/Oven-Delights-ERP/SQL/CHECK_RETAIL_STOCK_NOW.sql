-- =============================================
-- SIMPLE CHECK: What's in RetailStock right now?
-- =============================================

PRINT '🔍 Checking RetailStock table...';
PRINT '';

-- Check if RetailStock table exists
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
BEGIN
    PRINT '✅ RetailStock table exists';
    PRINT '';
    
    -- Show schema
    PRINT '📋 RetailStock Columns:';
    SELECT 
        COLUMN_NAME,
        DATA_TYPE,
        IS_NULLABLE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'RetailStock'
    ORDER BY ORDINAL_POSITION;
    
    PRINT '';
    PRINT '📊 Current RetailStock Data:';
    
    -- Show all data
    EXEC('
    SELECT 
        rs.*,
        p.ProductName,
        p.SKU
    FROM RetailStock rs
    LEFT JOIN Products p ON rs.ProductID = p.ProductID
    ORDER BY rs.LastUpdated DESC;
    ');
    
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT '';
        PRINT '⚠️  RetailStock table is EMPTY!';
        PRINT '   This confirms products are not being added to retail stock.';
    END
    ELSE
    BEGIN
        PRINT '';
        PRINT '✅ RetailStock has data';
    END
END
ELSE
BEGIN
    PRINT '❌ RetailStock table does NOT exist!';
    PRINT '';
    PRINT 'Checking for alternative tables...';
    
    IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Stock')
    BEGIN
        PRINT '✅ Found Retail_Stock table (with underscore)';
        
        EXEC('
        SELECT 
            rs.*,
            p.ProductName,
            p.SKU
        FROM Retail_Stock rs
        LEFT JOIN Products p ON rs.ProductID = p.ProductID
        ORDER BY rs.LastUpdated DESC;
        ');
    END
    ELSE
    BEGIN
        PRINT '❌ No retail stock table found';
        PRINT '';
        PRINT '💡 Stock might be tracked in Products table directly';
        PRINT '   Run CHECK_PRODUCTS_SCHEMA.sql to verify';
    END
END

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 NEXT STEPS:';
PRINT '1. Run CHECK_PRODUCTS_SCHEMA.sql to see Products columns';
PRINT '2. Run FIX_REORDER_BOOK_COMPLETE.sql to update stored procedure';
PRINT '3. Complete a product and check again';
PRINT '═══════════════════════════════════════════════';
