-- =============================================
-- CHECK PRODUCTS TABLE SCHEMA
-- =============================================
-- First, let's see what columns actually exist
-- =============================================

PRINT '🔍 Checking Products table schema...';
PRINT '';

-- Show all columns in Products table
PRINT '📋 Products Table Columns:';
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;

PRINT '';
PRINT '═══════════════════════════════════════════════';

-- Check for stock-related columns
PRINT '📊 Stock-Related Columns:';
IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'CurrentStock')
    PRINT '✅ CurrentStock column exists';
ELSE
    PRINT '❌ CurrentStock column does NOT exist';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'StockOnHand')
    PRINT '✅ StockOnHand column exists';
ELSE
    PRINT '❌ StockOnHand column does NOT exist';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'QuantityOnHand')
    PRINT '✅ QuantityOnHand column exists';
ELSE
    PRINT '❌ QuantityOnHand column does NOT exist';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'ProductType')
    PRINT '✅ ProductType column exists';
ELSE
    PRINT '❌ ProductType column does NOT exist';

IF EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'Type')
    PRINT '✅ Type column exists';
ELSE
    PRINT '❌ Type column does NOT exist';

PRINT '';
PRINT '═══════════════════════════════════════════════';

-- Check what stock tables exist
PRINT '📦 Stock Tables:';
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'RetailStock')
    PRINT '✅ RetailStock table exists';
ELSE
    PRINT '❌ RetailStock table does NOT exist';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'Retail_Stock')
    PRINT '✅ Retail_Stock table exists';
ELSE
    PRINT '❌ Retail_Stock table does NOT exist';

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'StockMovements')
    PRINT '✅ StockMovements table exists';
ELSE
    PRINT '❌ StockMovements table does NOT exist';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '💡 Based on the results above, we can determine:';
PRINT '1. Which table tracks retail stock';
PRINT '2. Which column (if any) stores stock quantity in Products';
PRINT '3. How to update sp_CompleteReOrderProduct correctly';
PRINT '═══════════════════════════════════════════════';
