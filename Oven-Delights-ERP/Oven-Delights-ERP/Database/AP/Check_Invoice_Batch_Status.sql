-- Check which batches contain invoices 7 and 8
SELECT 
    pbi.BatchItemID,
    pbi.BatchID,
    pbi.InvoiceID,
    pbi.InvoiceNumber,
    pbi.AmountPaid,
    pb.Status AS BatchStatus,
    pb.PaymentDate,
    pb.PaymentMethod
FROM PaymentBatchItems pbi
INNER JOIN PaymentBatches pb ON pbi.BatchID = pb.BatchID
WHERE pbi.InvoiceID IN (7, 8)
ORDER BY pbi.InvoiceID, pbi.BatchID
GO

-- Show all batch statuses in use
SELECT DISTINCT Status, COUNT(*) AS BatchCount
FROM PaymentBatches
GROUP BY Status
ORDER BY Status
GO
