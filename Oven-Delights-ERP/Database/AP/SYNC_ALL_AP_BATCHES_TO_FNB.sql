-- =============================================
-- Sync ALL Submitted AP Batches to FNB Tables
-- This ensures all payment batches appear in FNB Payment Transactions viewer
-- =============================================

SET NOCOUNT ON;
GO

PRINT '========================================';
PRINT 'SYNCING ALL AP BATCHES TO FNB TABLES';
PRINT '========================================';
PRINT '';

-- Get all submitted AP batches that don't have FNB records
DECLARE @BatchID INT
DECLARE @MessageID NVARCHAR(100)
DECLARE @InstructionID NVARCHAR(100)
DECLARE @TotalInvoices INT
DECLARE @TotalAmount DECIMAL(18,2)
DECLARE @SubmittedDate DATETIME
DECLARE @BranchID INT
DECLARE @CreatedBy NVARCHAR(100)
DECLARE @Status NVARCHAR(50)
DECLARE @FNBBatchID INT
DECLARE @UserID INT
DECLARE @SyncCount INT = 0
DECLARE @ErrorCount INT = 0

-- Cursor for all submitted batches without FNB records
DECLARE batch_cursor CURSOR FOR
SELECT 
    ap.BatchID,
    ap.MessageID,
    ap.InstructionID,
    ap.TotalInvoices,
    ap.TotalAmount,
    ap.SubmittedDate,
    ap.BranchID,
    ap.CreatedBy,
    ap.Status
FROM AP_PaymentBatches ap
WHERE ap.Status IN ('Submitted', 'Processing', 'Completed')
    AND ap.MessageID IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM FNB_PaymentBatches fnb 
        WHERE fnb.MessageID = ap.MessageID
    )
ORDER BY ap.SubmittedDate ASC;

OPEN batch_cursor;
FETCH NEXT FROM batch_cursor INTO @BatchID, @MessageID, @InstructionID, @TotalInvoices, 
                                   @TotalAmount, @SubmittedDate, @BranchID, @CreatedBy, @Status;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        PRINT '';
        PRINT '----------------------------------------';
        PRINT 'Processing AP Batch ID: ' + CAST(@BatchID AS NVARCHAR(10));
        PRINT 'MessageID: ' + ISNULL(@MessageID, 'NULL');
        PRINT 'Status: ' + @Status;
        PRINT '----------------------------------------';
        
        -- Get UserID from username
        SET @UserID = NULL;
        SELECT @UserID = UserID FROM Users WHERE Username = @CreatedBy;
        
        IF @UserID IS NULL
        BEGIN
            PRINT '⚠ Warning: UserID not found for username: ' + ISNULL(@CreatedBy, 'NULL');
            PRINT '  Using NULL for CreatedBy field';
        END
        ELSE
        BEGIN
            PRINT 'Found UserID: ' + CAST(@UserID AS NVARCHAR(10)) + ' for username: ' + @CreatedBy;
        END
        
        -- Validate required fields
        IF @MessageID IS NULL OR @MessageID = ''
        BEGIN
            PRINT '✗ ERROR: MessageID is NULL or empty - skipping batch';
            SET @ErrorCount = @ErrorCount + 1;
            GOTO NextBatch;
        END
        
        -- Create FNB batch using stored procedure
        PRINT 'Creating FNB batch record...';
        
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
        IF @InstructionID IS NOT NULL AND @InstructionID <> ''
        BEGIN
            PRINT 'Updating FNB batch with InstructionID and status...';
            
            -- Map AP status to FNB batch status
            DECLARE @FNBStatus NVARCHAR(10);
            SET @FNBStatus = CASE 
                WHEN @Status = 'Submitted' THEN 'PDNG'
                WHEN @Status = 'Processing' THEN 'ACTC'
                WHEN @Status = 'Completed' THEN 'ACSC'
                ELSE 'PDNG'
            END;
            
            EXEC sp_FNB_UpdateBatchStatus
                @BatchID = @FNBBatchID,
                @InstructionID = @InstructionID,
                @BatchStatus = @FNBStatus,
                @RejectionReason = NULL,
                @APIResponseJSON = NULL,
                @CheckedBy = @UserID;
            
            PRINT '✓ FNB Batch status updated';
        END
        ELSE
        BEGIN
            PRINT '⚠ Warning: InstructionID is NULL - batch status not updated';
        END
        
        -- Create transaction records for each invoice in the batch
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
        DECLARE @TxnCount INT = 0
        
        DECLARE invoice_cursor CURSOR FOR
        SELECT 
            i.InvoiceID,
            i.InvoiceNumber,
            i.TotalAmount,
            b.BeneficiaryName,
            b.AccountNumber,
            ISNULL(b.AccountType, 'CACC') AS AccountType,
            b.BranchCode,
            ISNULL(i.Description, '') AS Description
        FROM AP_PaymentBatchItems bi
        INNER JOIN AP_Invoices i ON bi.InvoiceID = i.InvoiceID
        INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
        WHERE bi.BatchID = @BatchID;
        
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
            
            SET @TxnCount = @TxnCount + 1;
            
            FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @Amount, @BeneficiaryName, 
                                                @AccountNumber, @AccountType, @BranchCode, @Description;
        END;
        
        CLOSE invoice_cursor;
        DEALLOCATE invoice_cursor;
        
        PRINT '✓ Created ' + CAST(@TxnCount AS NVARCHAR(10)) + ' transaction records';
        PRINT '✓ AP Batch ' + CAST(@BatchID AS NVARCHAR(10)) + ' synced successfully';
        
        SET @SyncCount = @SyncCount + 1;
        
    END TRY
    BEGIN CATCH
        PRINT '✗ ERROR syncing batch ' + CAST(@BatchID AS NVARCHAR(10)) + ':';
        PRINT '  ' + ERROR_MESSAGE();
        SET @ErrorCount = @ErrorCount + 1;
        
        -- Clean up cursors if open
        IF CURSOR_STATUS('local', 'invoice_cursor') >= 0
        BEGIN
            CLOSE invoice_cursor;
            DEALLOCATE invoice_cursor;
        END
    END CATCH
    
    NextBatch:
    FETCH NEXT FROM batch_cursor INTO @BatchID, @MessageID, @InstructionID, @TotalInvoices, 
                                       @TotalAmount, @SubmittedDate, @BranchID, @CreatedBy, @Status;
END;

CLOSE batch_cursor;
DEALLOCATE batch_cursor;

PRINT '';
PRINT '========================================';
PRINT 'SYNC SUMMARY';
PRINT '========================================';
PRINT 'Batches synced successfully: ' + CAST(@SyncCount AS NVARCHAR(10));
PRINT 'Batches with errors: ' + CAST(@ErrorCount AS NVARCHAR(10));
PRINT '';

-- Verification
PRINT '========================================';
PRINT 'VERIFICATION';
PRINT '========================================';
PRINT '';

PRINT 'AP Batches (Submitted/Processing/Completed):';
SELECT COUNT(*) AS AP_Batches_Count 
FROM AP_PaymentBatches 
WHERE Status IN ('Submitted', 'Processing', 'Completed');

PRINT '';
PRINT 'FNB Batches:';
SELECT COUNT(*) AS FNB_Batches_Count FROM FNB_PaymentBatches;

PRINT '';
PRINT 'FNB Transactions:';
SELECT COUNT(*) AS FNB_Transactions_Count FROM FNB_PaymentTransactions;

PRINT '';
PRINT 'Remaining AP batches without FNB records:';
SELECT COUNT(*) AS Remaining_Unsynced
FROM AP_PaymentBatches ap
WHERE ap.Status IN ('Submitted', 'Processing', 'Completed')
    AND ap.MessageID IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM FNB_PaymentBatches fnb 
        WHERE fnb.MessageID = ap.MessageID
    );

PRINT '';
PRINT '========================================';
PRINT 'Script completed!';
PRINT '========================================';
GO
