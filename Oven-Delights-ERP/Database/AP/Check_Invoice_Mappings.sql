-- Check if invoices are mapped to FNB batches
SELECT 
    m.MappingID,
    m.InvoiceID,
    i.InvoiceNumber,
    m.FNB_BatchID,
    pb.MessageID,
    pb.BatchStatus,
    m.AmountPaid,
    m.AddedDate
FROM AP_InvoiceBatchMapping m
INNER JOIN AP_Invoices i ON m.InvoiceID = i.InvoiceID
INNER JOIN FNB_PaymentBatches pb ON m.FNB_BatchID = pb.BatchID
ORDER BY m.AddedDate DESC
GO

-- Check if table is empty
IF NOT EXISTS (SELECT 1 FROM AP_InvoiceBatchMapping)
BEGIN
    PRINT 'AP_InvoiceBatchMapping table is EMPTY - invoices have not been saved after FNB submission'
    PRINT 'You need to submit a NEW batch after rebuilding the application'
END
ELSE
BEGIN
    PRINT 'AP_InvoiceBatchMapping has records - invoices are being tracked'
END
GO
