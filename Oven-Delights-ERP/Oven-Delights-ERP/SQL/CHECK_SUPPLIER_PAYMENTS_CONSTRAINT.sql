-- Check the actual unique constraint on SupplierPayments table
PRINT '🔍 Checking SupplierPayments unique constraints...';
PRINT '';

-- Get all unique constraints and their columns
SELECT 
    i.name AS ConstraintName,
    OBJECT_NAME(ic.object_id) AS TableName,
    STRING_AGG(COL_NAME(ic.object_id, ic.column_id), ', ') WITHIN GROUP (ORDER BY ic.key_ordinal) AS Columns,
    i.type_desc AS ConstraintType
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
WHERE i.object_id = OBJECT_ID('SupplierPayments')
  AND i.is_unique = 1
GROUP BY i.name, i.type_desc, ic.object_id
ORDER BY i.name;

PRINT '';
PRINT '📋 Checking existing payments in current batch...';

-- Check if there are existing payments for the batch shown in error
SELECT 
    sp.PaymentID,
    sp.PaymentNumber,
    sp.BatchID,
    sp.SupplierID,
    s.CompanyName,
    sp.Amount,
    sp.PaymentDate
FROM SupplierPayments sp
LEFT JOIN Suppliers s ON sp.SupplierID = s.SupplierID
WHERE sp.BatchID IN (
    SELECT BatchID 
    FROM PaymentBatches 
    WHERE BatchNumber LIKE 'PB-00006%'
)
ORDER BY sp.SupplierID, sp.PaymentID;

PRINT '';
PRINT '📋 Checking batch items...';

-- Check what's in the batch
SELECT 
    pbi.BatchID,
    pbi.InvoiceID,
    si.SupplierID,
    s.CompanyName,
    si.InvoiceNumber,
    pbi.AmountPaid
FROM PaymentBatchItems pbi
INNER JOIN SupplierInvoices si ON pbi.InvoiceID = si.InvoiceID
LEFT JOIN Suppliers s ON si.SupplierID = s.SupplierID
WHERE pbi.BatchID IN (
    SELECT BatchID 
    FROM PaymentBatches 
    WHERE BatchNumber LIKE 'PB-00006%'
)
ORDER BY si.SupplierID, pbi.InvoiceID;
