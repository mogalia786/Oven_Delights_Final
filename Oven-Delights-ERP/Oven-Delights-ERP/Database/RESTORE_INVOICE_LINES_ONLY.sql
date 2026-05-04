-- =============================================
-- Restore SupplierInvoiceLines data from backup ONLY
-- Run this AFTER backup script
-- =============================================

PRINT 'Restoring SupplierInvoiceLines data from backup...'

-- Restore invoice lines
SET IDENTITY_INSERT SupplierInvoiceLines ON;

INSERT INTO SupplierInvoiceLines (
    InvoiceLineID,
    InvoiceID,
    LineNumber,
    ItemID,
    ItemSource,
    ProductCode,
    ProductName,
    Description,
    Quantity,
    UnitPrice,
    UnitCost,
    LineTotal
)
SELECT 
    InvoiceLineID,
    InvoiceID,
    LineNumber,
    ItemID,
    ItemSource,
    ProductCode,
    ProductName,
    Description,
    Quantity,
    ISNULL(UnitPrice, 0) AS UnitPrice,
    ISNULL(UnitCost, 0) AS UnitCost,
    LineTotal
FROM SupplierInvoiceLines_Backup;

SET IDENTITY_INSERT SupplierInvoiceLines OFF;

DECLARE @rowCount INT = @@ROWCOUNT;
PRINT 'Restored ' + CAST(@rowCount AS NVARCHAR(10)) + ' invoice line records'

-- Drop backup tables
DROP TABLE SupplierInvoices_Backup;
DROP TABLE SupplierInvoiceLines_Backup;

PRINT ''
PRINT 'Restore completed successfully!'
PRINT 'Backup tables dropped'
