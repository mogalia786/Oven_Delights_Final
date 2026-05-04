-- =============================================
-- Manually sync AP Batch #28 to FNB tables
-- This batch was submitted but didn't sync to FNB_PaymentBatches
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'Checking AP Batch #28 Details';
PRINT '========================================';
PRINT '';

-- Get AP batch details
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
WHERE BatchID = 28;

PRINT '';
PRINT 'Checking if FNB batch exists...';

SELECT COUNT(*) AS FNB_Batch_Exists
FROM FNB_PaymentBatches
WHERE MessageID IN (SELECT MessageID FROM AP_PaymentBatches WHERE BatchID = 28);

PRINT '';
PRINT '========================================';
PRINT 'Creating FNB Batch Record for Batch #28';
PRINT '========================================';
PRINT '';

-- Declare variables
DECLARE @MessageID NVARCHAR(100)
DECLARE @InstructionID NVARCHAR(100)
DECLARE @TotalInvoices INT
DECLARE @TotalAmount DECIMAL(18,2)
DECLARE @SubmittedDate DATETIME
DECLARE @BranchID INT
DECLARE @CreatedBy NVARCHAR(100)
DECLARE @FNBBatchID INT

-- Get AP batch details
SELECT 
    @MessageID = MessageID,
    @InstructionID = InstructionID,
    @TotalInvoices = TotalInvoices,
    @TotalAmount = TotalAmount,
    @SubmittedDate = SubmittedDate,
    @BranchID = BranchID,
    @CreatedBy = CreatedBy
FROM AP_PaymentBatches
WHERE BatchID = 28;

-- Check if FNB batch already exists
IF NOT EXISTS (SELECT 1 FROM FNB_PaymentBatches WHERE MessageID = @MessageID)
BEGIN
    PRINT 'Creating FNB batch record...';
    
    -- Get UserID from username
    DECLARE @UserID INT = NULL
    SELECT @UserID = UserID FROM Users WHERE Username = @CreatedBy;
    
    -- Create FNB batch using stored procedure
    EXEC sp_FNB_CreatePaymentBatch
        @MessageID = @MessageID,
        @TotalNumberOfTransactions = @TotalInvoices,
        @TotalControlSum = @TotalAmount,
        @RequestedExecutionDate = @SubmittedDate,
        @ServiceLevelCode = 'SDVA',
        @DebtorAccountNumber = '63001723469',
        @BranchID = @BranchID,
        @CreatedBy = @UserID,
        @APIRequestJSON = NULL,
        @BatchID = @FNBBatchID OUTPUT;
    
    PRINT '✓ FNB Batch created with ID: ' + CAST(@FNBBatchID AS NVARCHAR(10));
    
    -- Update with instruction ID and status
    EXEC sp_FNB_UpdateBatchStatus
        @BatchID = @FNBBatchID,
        @InstructionID = @InstructionID,
        @BatchStatus = 'PDNG',
        @RejectionReason = NULL,
        @APIResponseJSON = NULL,
        @CheckedBy = @UserID;
    
    PRINT '✓ FNB Batch status updated';
    
    -- Create transaction records for each invoice in the batch
    PRINT '';
    PRINT 'Creating FNB transaction records...';
    
    DECLARE @InvoiceID INT
    DECLARE @InvoiceNumber NVARCHAR(50)
    DECLARE @Amount DECIMAL(18,2)
    DECLARE @BeneficiaryName NVARCHAR(200)
    DECLARE @AccountNumber NVARCHAR(50)
    DECLARE @AccountType NVARCHAR(10)
    DECLARE @BranchCode NVARCHAR(20)
    DECLARE @Description NVARCHAR(500)
    DECLARE @TransactionID INT
    
    DECLARE invoice_cursor CURSOR FOR
    SELECT 
        i.InvoiceID,
        i.InvoiceNumber,
        i.TotalAmount,
        b.BeneficiaryName,
        b.AccountNumber,
        ISNULL(b.AccountType, 'CACC') AS AccountType,
        b.BranchCode,
        i.Description
    FROM AP_PaymentBatchItems bi
    INNER JOIN AP_Invoices i ON bi.InvoiceID = i.InvoiceID
    INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
    WHERE bi.BatchID = 28;
    
    OPEN invoice_cursor;
    FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @Amount, @BeneficiaryName, 
                                        @AccountNumber, @AccountType, @BranchCode, @Description;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC sp_FNB_AddPaymentTransaction
            @BatchID = @FNBBatchID,
            @EndToEndID = @InvoiceNumber,
            @Amount = @Amount,
            @CreditorName = @BeneficiaryName,
            @CreditorAccountNumber = @AccountNumber,
            @CreditorAccountType = @AccountType,
            @CreditorBranchID = @BranchCode,
            @CreditorBIC = 'FIRNZAJJ',
            @RemittanceReference = @Description,
            @ProofOfPaymentEmail = NULL,
            @SupplierID = NULL,
            @PurchaseInvoiceID = @InvoiceID,
            @ExpenseBillID = NULL,
            @PaymentType = 'Supplier',
            @PaymentTransactionID = @TransactionID OUTPUT;
        
        PRINT '  ✓ Transaction created for invoice: ' + @InvoiceNumber;
        
        FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @Amount, @BeneficiaryName, 
                                            @AccountNumber, @AccountType, @BranchCode, @Description;
    END;
    
    CLOSE invoice_cursor;
    DEALLOCATE invoice_cursor;
    
    PRINT '';
    PRINT '✓ All transaction records created';
END
ELSE
BEGIN
    PRINT '⚠ FNB batch already exists for this MessageID';
END

PRINT '';
PRINT '========================================';
PRINT 'Verification';
PRINT '========================================';
PRINT '';

PRINT 'FNB Batch Record:';
SELECT 
    BatchID,
    MessageID,
    InstructionID,
    TotalNumberOfTransactions,
    TotalControlSum,
    BatchStatus,
    CreatedDate
FROM FNB_PaymentBatches
WHERE MessageID = @MessageID;

PRINT '';
PRINT 'FNB Transaction Records:';
SELECT 
    PaymentTransactionID,
    EndToEndID,
    Amount,
    CreditorName,
    CreditorAccountNumber,
    TransactionStatus
FROM FNB_PaymentTransactions
WHERE BatchID = (SELECT BatchID FROM FNB_PaymentBatches WHERE MessageID = @MessageID);

PRINT '';
PRINT '========================================';
PRINT 'Script completed successfully!';
PRINT '========================================';
GO
