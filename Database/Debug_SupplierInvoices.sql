-- Debug SupplierInvoices to see what's actually there

PRINT '--- All SupplierInvoices ---';
SELECT 
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    BranchID,
    TotalAmount,
    AmountPaid,
    AmountOutstanding,
    Status
FROM dbo.SupplierInvoices
ORDER BY InvoiceID;

PRINT '';
PRINT '--- Invoices with outstanding amounts ---';
SELECT 
    InvoiceID,
    InvoiceNumber,
    SupplierID,
    BranchID,
    TotalAmount,
    ISNULL(AmountPaid, 0) AS AmountPaid,
    ISNULL(AmountOutstanding, TotalAmount) AS CalcOutstanding
FROM dbo.SupplierInvoices
WHERE ISNULL(AmountOutstanding, TotalAmount) > 0
ORDER BY InvoiceID;

PRINT '';
PRINT '--- Check what the query in SupplierPaymentForm would return ---';
DECLARE @SupplierID INT = 1; -- Change this to your supplier ID
DECLARE @BranchID INT = 1;   -- Change this to your branch ID

SELECT 
    InvoiceID, 
    InvoiceNumber, 
    InvoiceDate, 
    DueDate, 
    TotalAmount,
    ISNULL(AmountPaid, 0) AS AmountPaid,
    ISNULL(AmountOutstanding, TotalAmount) AS AmountOutstanding,
    CASE WHEN DueDate < GETDATE() AND ISNULL(AmountOutstanding, TotalAmount) > 0 THEN 'Overdue'
         ELSE ISNULL(Status, 'Open') END AS DisplayStatus
FROM SupplierInvoices
WHERE SupplierID = @SupplierID
AND (BranchID = @BranchID OR BranchID IS NULL)
AND ISNULL(AmountOutstanding, TotalAmount) > 0
ORDER BY InvoiceDate;

PRINT '';
PRINT 'If you see no results above, check:';
PRINT '1. Does the SupplierID match?';
PRINT '2. Does the BranchID match?';
PRINT '3. Is AmountOutstanding > 0?';
