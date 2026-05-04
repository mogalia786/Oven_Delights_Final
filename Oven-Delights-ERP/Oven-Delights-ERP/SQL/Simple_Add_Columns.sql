-- =============================================
-- SIMPLY ADD COLUMNS TO PurchaseOrders
-- =============================================

-- Check if PurchaseOrders table exists
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PurchaseOrders')
BEGIN
    PRINT '❌ Error: PurchaseOrders table does not exist';
    RETURN;
END

-- Add LastModifiedDate if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns 
              WHERE object_id = OBJECT_ID('PurchaseOrders') 
              AND name = 'LastModifiedDate')
BEGIN
    BEGIN TRY
        ALTER TABLE PurchaseOrders ADD LastModifiedDate DATETIME NULL;
        PRINT '✅ Added LastModifiedDate to PurchaseOrders';
        
        -- Set default value for existing records
        UPDATE PurchaseOrders SET LastModifiedDate = GETDATE() WHERE LastModifiedDate IS NULL;
        PRINT '   - Set default values for existing records';
    END TRY
    BEGIN CATCH
        PRINT '❌ Error adding LastModifiedDate: ' + ERROR_MESSAGE();
    END CATCH
END
ELSE
BEGIN
    PRINT 'ℹ️ LastModifiedDate already exists in PurchaseOrders';
END

-- Add LastModifiedBy if it doesn't exist
IF NOT EXISTS (SELECT 1 FROM sys.columns 
              WHERE object_id = OBJECT_ID('PurchaseOrders') 
              AND name = 'LastModifiedBy')
BEGIN
    BEGIN TRY
        ALTER TABLE PurchaseOrders ADD LastModifiedBy INT NULL;
        PRINT '✅ Added LastModifiedBy to PurchaseOrders';
    END TRY
    BEGIN CATCH
        PRINT '❌ Error adding LastModifiedBy: ' + ERROR_MESSAGE();
    END CATCH
ELSE
BEGIN
    PRINT 'ℹ️ LastModifiedBy already exists in PurchaseOrders';
END

PRINT '\n═══════════════════════════════════════════════';
PRINT '✅ SCRIPT COMPLETED - PLEASE CHECK OUTPUT ABOVE';
PRINT '═══════════════════════════════════════════════';
GO
