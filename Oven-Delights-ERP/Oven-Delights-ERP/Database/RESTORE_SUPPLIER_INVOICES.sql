-- =============================================
-- Restore SupplierInvoices data from backup
-- Run this AFTER DROP_AND_RECREATE_SUPPLIER_INVOICES.sql
-- =============================================

PRINT 'Restoring SupplierInvoices data from backup...'

-- Restore invoice data (excluding computed column)
SET IDENTITY_INSERT SupplierInvoices ON;

INSERT INTO SupplierInvoices (
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    BranchID,
    PurchaseOrderID,
    InvoiceDate,
    DueDate,
    SubTotal,
    VATAmount,
    TotalAmount,
    AmountPaid,
    AmountOutstanding,
    Status,
    Reference,
    Notes,
    DiscountAmount,
    DiscountPercent,
    CreatedBy,
    CreatedDate,
    GRVID
)
SELECT 
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    BranchID,
    PurchaseOrderID,
    InvoiceDate,
    DueDate,
    SubTotal,
    VATAmount,
    TotalAmount,
    ISNULL(AmountPaid, 0) AS AmountPaid,
    TotalAmount - ISNULL(AmountPaid, 0) AS AmountOutstanding,
    Status,
    Reference,
    Notes,
    ISNULL(DiscountAmount, 0) AS DiscountAmount,
    ISNULL(DiscountPercent, 0) AS DiscountPercent,
    CreatedBy,
    CreatedDate,
    GRVID
FROM SupplierInvoices_Backup;

SET IDENTITY_INSERT SupplierInvoices OFF;

DECLARE @rowCount INT = @@ROWCOUNT;
PRINT 'Restored ' + CAST(@rowCount AS NVARCHAR(10)) + ' invoice records'

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

SET @rowCount = @@ROWCOUNT;
PRINT 'Restored ' + CAST(@rowCount AS NVARCHAR(10)) + ' invoice line records'

-- Drop backup tables
DROP TABLE SupplierInvoices_Backup;
DROP TABLE SupplierInvoiceLines_Backup;

PRINT ''
PRINT 'Restore completed successfully!'
PRINT 'Backup tables dropped'
