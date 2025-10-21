-- Check SupplierInvoices table data

SELECT 
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    BranchID,
    InvoiceDate,
    DueDate,
    SubTotal,
    VATAmount,
    TotalAmount,
    AmountPaid,
    AmountOutstanding,
    Status,
    GRVID,
    CreatedBy,
    CreatedDate
FROM dbo.SupplierInvoices
ORDER BY CreatedDate DESC;

PRINT '';
PRINT '--- Check if AmountOutstanding is calculated correctly ---';

SELECT 
    InvoiceID,
    InvoiceNumber,
    TotalAmount,
    ISNULL(AmountPaid, 0) AS AmountPaid,
    ISNULL(AmountOutstanding, TotalAmount) AS AmountOutstanding,
    CASE 
        WHEN ISNULL(AmountOutstanding, TotalAmount) > 0 THEN 'Has Outstanding'
        ELSE 'Fully Paid'
    END AS PaymentStatus
FROM dbo.SupplierInvoices
ORDER BY InvoiceID;
