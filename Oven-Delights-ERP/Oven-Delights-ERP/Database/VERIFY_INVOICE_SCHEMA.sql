-- Verify SupplierInvoiceLines table schema and check for data

PRINT '=== SupplierInvoiceLines Table Schema ==='
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'SupplierInvoiceLines'
ORDER BY ORDINAL_POSITION;

PRINT ''
PRINT '=== Check if SupplierInvoiceLines has ANY data ==='
SELECT COUNT(*) AS TotalRows
FROM SupplierInvoiceLines;

PRINT ''
PRINT '=== Sample of SupplierInvoiceLines data (if any) ==='
SELECT TOP 10 *
FROM SupplierInvoiceLines
ORDER BY InvoiceLineID DESC;

PRINT ''
PRINT '=== Check SupplierInvoices table ==='
SELECT COUNT(*) AS TotalInvoices
FROM SupplierInvoices;

PRINT ''
PRINT '=== Recent SupplierInvoices (last 5) ==='
SELECT TOP 5 
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    InvoiceDate,
    TotalAmount,
    Status
FROM SupplierInvoices
ORDER BY InvoiceDate DESC;
