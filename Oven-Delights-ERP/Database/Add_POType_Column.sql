-- =============================================
-- Add POType Column to PurchaseOrders Table
-- To distinguish between Regular PO and Inter-Branch PO
-- =============================================

IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('PurchaseOrders') AND name = 'POType')
BEGIN
    ALTER TABLE PurchaseOrders ADD POType NVARCHAR(50) NULL DEFAULT 'Regular';
    PRINT '✓ Added POType column to PurchaseOrders table';
    
    -- Update existing records to 'Regular'
    UPDATE PurchaseOrders SET POType = 'Regular' WHERE POType IS NULL;
    PRINT '✓ Updated existing POs to Regular type';
END
ELSE
BEGIN
    PRINT 'POType column already exists in PurchaseOrders table';
END
GO

PRINT 'POType column setup completed';
