-- =============================================
-- Add PurchaseOrderID Column to SupplierInvoices
-- This links invoices to their originating purchase orders
-- =============================================

USE OvenDelightsERP
GO

-- Check if column already exists
IF NOT EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = 'SupplierInvoices' 
    AND COLUMN_NAME = 'PurchaseOrderID'
)
BEGIN
    PRINT 'Adding PurchaseOrderID column to SupplierInvoices table...'
    
    -- Add the column
    ALTER TABLE dbo.SupplierInvoices
    ADD PurchaseOrderID INT NULL
    
    PRINT 'PurchaseOrderID column added successfully.'
    
    -- Add foreign key constraint if PurchaseOrders table exists
    IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PurchaseOrders')
    BEGIN
        PRINT 'Adding foreign key constraint...'
        
        ALTER TABLE dbo.SupplierInvoices
        ADD CONSTRAINT FK_SupplierInvoices_PurchaseOrder 
        FOREIGN KEY (PurchaseOrderID) REFERENCES dbo.PurchaseOrders(PurchaseOrderID)
        
        PRINT 'Foreign key constraint added successfully.'
    END
    ELSE
    BEGIN
        PRINT 'WARNING: PurchaseOrders table not found. Foreign key constraint not created.'
    END
    
    -- Create index for better query performance
    CREATE NONCLUSTERED INDEX IX_SupplierInvoices_PurchaseOrderID 
    ON dbo.SupplierInvoices(PurchaseOrderID)
    
    PRINT 'Index created successfully.'
    PRINT 'PurchaseOrderID column setup complete!'
END
ELSE
BEGIN
    PRINT 'PurchaseOrderID column already exists in SupplierInvoices table.'
END
GO

-- Verify the change
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierInvoices'
AND COLUMN_NAME = 'PurchaseOrderID'
GO

PRINT ''
PRINT '========================================='
PRINT 'IMPORTANT: Run this script on your database to enable PO-Invoice linking!'
PRINT '========================================='
