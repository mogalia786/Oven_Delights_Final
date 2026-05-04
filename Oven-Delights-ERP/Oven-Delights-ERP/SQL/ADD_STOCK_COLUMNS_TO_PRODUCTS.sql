-- =============================================
-- OPTIONAL: Add ReorderLevel and MaxStock columns to Products
-- =============================================
-- Run this if you want to track reorder levels and max stock
-- =============================================

PRINT '🔧 Adding stock management columns to Products table...';
PRINT '';

-- Check if columns already exist
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'ReorderLevel')
BEGIN
    ALTER TABLE Products ADD ReorderLevel DECIMAL(18,2) DEFAULT 0;
    PRINT '✅ Added ReorderLevel column';
END
ELSE
    PRINT '⚠️  ReorderLevel column already exists';

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('Products') AND name = 'MaxStock')
BEGIN
    ALTER TABLE Products ADD MaxStock DECIMAL(18,2) DEFAULT 0;
    PRINT '✅ Added MaxStock column';
END
ELSE
    PRINT '⚠️  MaxStock column already exists';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 COLUMNS ADDED:';
PRINT '1. ReorderLevel - Minimum stock before reordering';
PRINT '2. MaxStock - Maximum stock to maintain';
PRINT '';
PRINT '💡 NEXT STEPS:';
PRINT '1. Set reorder levels for your products';
PRINT '2. Run FIX_STOCK_LEVELS_REPORT_WITH_COLUMNS.sql';
PRINT '3. Report will show low stock alerts';
PRINT '═══════════════════════════════════════════════';
