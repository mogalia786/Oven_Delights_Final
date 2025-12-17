-- =============================================
-- Add IsVatable column to PurchaseOrderLines table
-- This tracks whether each line item is subject to VAT
-- =============================================

PRINT '=== Adding IsVatable column to PurchaseOrderLines table ==='
IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseOrderLines') AND name = 'IsVatable')
BEGIN
    ALTER TABLE PurchaseOrderLines
    ADD IsVatable BIT NOT NULL DEFAULT 1
    
    PRINT '✓ IsVatable column added to PurchaseOrderLines with default value TRUE'
END
ELSE
BEGIN
    PRINT '✓ IsVatable column already exists in PurchaseOrderLines'
END
GO

-- Update existing PO lines to TRUE (default)
UPDATE PurchaseOrderLines
SET IsVatable = 1
WHERE IsVatable IS NULL
GO

PRINT ''
PRINT '✓ All PO lines set to vatable by default.'
GO
