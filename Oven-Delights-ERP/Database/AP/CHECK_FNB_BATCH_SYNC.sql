-- =============================================
-- Check FNB Batch Synchronization
-- Verify if AP batches are being synced to FNB tables
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'AP PAYMENT BATCHES';
PRINT '========================================';
PRINT '';

SELECT 
    BatchID,
    BatchNumber,
    CreatedDate,
    TotalInvoices,
    TotalAmount,
    Status,
    InstructionID,
    MessageID,
    SubmittedDate,
    BranchID,
    CreatedBy
FROM AP_PaymentBatches
ORDER BY CreatedDate DESC;

PRINT '';
PRINT '========================================';
PRINT 'FNB PAYMENT BATCHES';
PRINT '========================================';
PRINT '';

SELECT 
    BatchID,
    MessageID,
    InstructionID,
    TotalNumberOfTransactions,
    TotalControlSum,
    BatchStatus,
    RequestedExecutionDate,
    CreatedDate,
    BranchID,
    CreatedBy
FROM FNB_PaymentBatches
ORDER BY CreatedDate DESC;

PRINT '';
PRINT '========================================';
PRINT 'FNB PAYMENT TRANSACTIONS';
PRINT '========================================';
PRINT '';

SELECT 
    PaymentTransactionID,
    BatchID,
    EndToEndID,
    Amount,
    CreditorName,
    CreditorAccountNumber,
    TransactionStatus,
    CreatedDate
FROM FNB_PaymentTransactions
ORDER BY CreatedDate DESC;

PRINT '';
PRINT '========================================';
PRINT 'COMPARISON';
PRINT '========================================';
PRINT '';

PRINT 'AP Batches Count:';
SELECT COUNT(*) AS AP_Batches_Count FROM AP_PaymentBatches;

PRINT '';
PRINT 'FNB Batches Count:';
SELECT COUNT(*) AS FNB_Batches_Count FROM FNB_PaymentBatches;

PRINT '';
PRINT 'FNB Transactions Count:';
SELECT COUNT(*) AS FNB_Transactions_Count FROM FNB_PaymentTransactions;

PRINT '';
PRINT '========================================';
PRINT 'SUBMITTED AP BATCHES WITHOUT FNB RECORDS';
PRINT '========================================';
PRINT '';

SELECT 
    ap.BatchID,
    ap.BatchNumber,
    ap.Status,
    ap.InstructionID,
    ap.MessageID,
    ap.SubmittedDate
FROM AP_PaymentBatches ap
WHERE ap.Status IN ('Submitted', 'Processing', 'Completed')
    AND NOT EXISTS (
        SELECT 1 
        FROM FNB_PaymentBatches fnb 
        WHERE fnb.MessageID = ap.MessageID
    )
ORDER BY ap.SubmittedDate DESC;

PRINT '';
PRINT 'Script completed!';
GO
