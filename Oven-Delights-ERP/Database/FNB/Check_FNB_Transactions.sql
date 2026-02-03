-- Check FNB_PaymentTransactions for invoices 7 and 8
SELECT 
    pt.PaymentTransactionID,
    pt.BatchID,
    pt.EndToEndID,
    pt.Amount,
    pt.CreditorName,
    pb.BatchStatus,
    pb.MessageID,
    pb.RequestedExecutionDate
FROM FNB_PaymentTransactions pt
INNER JOIN FNB_PaymentBatches pb ON pt.BatchID = pb.BatchID
ORDER BY pt.PaymentTransactionID DESC
GO

-- Check what invoice numbers look like in AP_Invoices
SELECT TOP 10
    InvoiceID,
    InvoiceNumber,
    TotalAmount,
    Status
FROM AP_Invoices
WHERE InvoiceID IN (7, 8)
   OR InvoiceNumber LIKE '%202%'
ORDER BY InvoiceID DESC
GO
