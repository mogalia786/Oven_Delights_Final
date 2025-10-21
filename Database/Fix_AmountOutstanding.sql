-- Fix ALL invoices to have correct AmountOutstanding

UPDATE dbo.SupplierInvoices
SET AmountOutstanding = TotalAmount - ISNULL(AmountPaid, 0)
WHERE AmountOutstanding <> (TotalAmount - ISNULL(AmountPaid, 0)) OR AmountOutstanding IS NULL;

PRINT 'Fixed AmountOutstanding for existing invoices';

-- Verify the fix
SELECT 
    si.InvoiceID,
    si.InvoiceNumber,
    si.SupplierID,
    s.CompanyName AS SupplierName,
    si.BranchID,
    si.TotalAmount,
    si.AmountPaid,
    si.AmountOutstanding,
    si.Status
FROM dbo.SupplierInvoices si
LEFT JOIN dbo.Suppliers s ON s.SupplierID = si.SupplierID
ORDER BY si.InvoiceID;
