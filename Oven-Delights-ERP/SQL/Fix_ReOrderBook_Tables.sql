-- =============================================
-- FIX RE-ORDER BOOK TABLES
-- Add missing columns to match actual database
-- =============================================

-- Add StartedBy and StartedDate to ReOrderBooks
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReOrderBooks' AND COLUMN_NAME = 'StartedBy')
    ALTER TABLE ReOrderBooks ADD StartedBy NVARCHAR(100) NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReOrderBooks' AND COLUMN_NAME = 'StartedDate')
    ALTER TABLE ReOrderBooks ADD StartedDate DATETIME NULL;

PRINT '✅ Added StartedBy and StartedDate to ReOrderBooks';

-- Add ProductID and Quantity to ReOrderBookAudit
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReOrderBookAudit' AND COLUMN_NAME = 'ProductID')
    ALTER TABLE ReOrderBookAudit ADD ProductID INT NULL;

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReOrderBookAudit' AND COLUMN_NAME = 'Quantity')
    ALTER TABLE ReOrderBookAudit ADD Quantity DECIMAL(18,2) NULL;

PRINT '✅ Added ProductID and Quantity to ReOrderBookAudit';

-- Remove Barcode and ItemCode from ReOrderBookLines (Products table doesn't have these)
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReOrderBookLines' AND COLUMN_NAME = 'Barcode')
    ALTER TABLE ReOrderBookLines DROP COLUMN Barcode;

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'ReOrderBookLines' AND COLUMN_NAME = 'ItemCode')
    ALTER TABLE ReOrderBookLines DROP COLUMN ItemCode;

PRINT '✅ Removed Barcode and ItemCode from ReOrderBookLines';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ RE-ORDER BOOK TABLES FIXED!';
PRINT '   - Added StartedBy, StartedDate to ReOrderBooks';
PRINT '   - Added ProductID, Quantity to ReOrderBookAudit';
PRINT '   - Removed Barcode, ItemCode (not in Products table)';
PRINT '═══════════════════════════════════════════════';
