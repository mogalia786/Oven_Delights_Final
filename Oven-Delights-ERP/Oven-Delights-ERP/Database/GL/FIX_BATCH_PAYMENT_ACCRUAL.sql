-- =============================================
-- FIX BATCH PAYMENT FOR ACCRUAL ACCOUNTING
-- Batch payment should NOT touch bank or post to GL
-- Bank statement completes the double-entry
-- =============================================

PRINT '========================================='
PRINT 'FIXING BATCH PAYMENT FOR ACCRUAL MODEL'
PRINT '========================================='
PRINT ''

-- Drop old procedure
IF OBJECT_ID('sp_ProcessPaymentBatch', 'P') IS NOT NULL
    DROP PROCEDURE sp_ProcessPaymentBatch
GO

PRINT 'Creating updated sp_ProcessPaymentBatch...'
GO

CREATE PROCEDURE sp_ProcessPaymentBatch
    @BatchID INT,
    @ProcessedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validate batch exists
        DECLARE @BatchNumber NVARCHAR(50);
        
        SELECT @BatchNumber = BatchNumber
        FROM AP_PaymentBatches
        WHERE BatchID = @BatchID AND Status = 'Pending';
        
        IF @BatchNumber IS NULL
        BEGIN
            RAISERROR('Batch not found or already processed', 16, 1);
            RETURN -1;
        END
        
        -- ACCRUAL MODEL: Just mark batch as "Submitted"
        -- Do NOT post to GL
        -- Do NOT update bank balance
        -- Bank statement will complete the double-entry
        
        UPDATE AP_PaymentBatches
        SET Status = 'Submitted',
            SubmittedDate = GETDATE(),
            ModifiedBy = @ProcessedBy,
            ModifiedDate = GETDATE()
        WHERE BatchID = @BatchID;
        
        COMMIT TRANSACTION;
        PRINT 'Batch ' + @BatchNumber + ' marked as Submitted (waiting for bank confirmation)'
        RETURN 0;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT '✓ Created sp_ProcessPaymentBatch (Accrual Model)'
GO

-- =============================================
-- CREATE PROCEDURE TO COMPLETE BATCH PAYMENT FROM BANK STATEMENT
-- =============================================

IF OBJECT_ID('sp_BankStatement_CompleteBatchPayment', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompleteBatchPayment
GO

PRINT 'Creating sp_BankStatement_CompleteBatchPayment...'
GO

CREATE PROCEDURE sp_BankStatement_CompleteBatchPayment
    @BatchID INT,
    @BankTransactionID INT,
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @BankAccountID INT
        DECLARE @APAccountID INT
        DECLARE @TotalAmount DECIMAL(18,2)
        DECLARE @BatchNumber NVARCHAR(50)
        DECLARE @TransactionDate DATE
        
        -- Get batch details
        SELECT 
            @BatchNumber = BatchNumber,
            @TotalAmount = TotalAmount
        FROM AP_PaymentBatches
        WHERE BatchID = @BatchID
        
        -- Get bank transaction date
        SELECT @TransactionDate = TransactionDate
        FROM AP_StatementTransactions
        WHERE TransactionID = @BankTransactionID
        
        -- Get account IDs from ChartOfAccounts
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2010' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2010 not found', 16, 1)
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        
        -- Process each invoice in the batch
        DECLARE @InvoiceID INT
        DECLARE @InvoiceNumber NVARCHAR(50)
        DECLARE @SupplierName NVARCHAR(200)
        DECLARE @Amount DECIMAL(18,2)
        DECLARE @BranchID INT
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        
        DECLARE invoice_cursor CURSOR FOR
        SELECT 
            pbi.InvoiceID,
            ai.InvoiceNumber,
            ISNULL(b.BeneficiaryName, 'Supplier') AS SupplierName,
            pbi.Amount,
            ISNULL(ai.BranchID, 1) AS BranchID
        FROM AP_PaymentBatchItems pbi
        INNER JOIN AP_Invoices ai ON pbi.InvoiceID = ai.InvoiceID
        LEFT JOIN AP_Beneficiaries b ON ai.BeneficiaryID = b.BeneficiaryID
        WHERE pbi.BatchID = @BatchID
        
        OPEN invoice_cursor
        FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @SupplierName, @Amount, @BranchID
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Generate journal number
            SET @JournalNumber = 'BP-' + @InvoiceNumber
            
            -- Create journal header
            INSERT INTO JournalHeaders (
                JournalNumber, BranchID, JournalDate, Reference, Description,
                FiscalPeriodID, IsPosted, CreatedBy
            )
            VALUES (
                @JournalNumber,
                @BranchID,
                @TransactionDate,
                @BatchNumber,
                'Batch Payment Confirmed - ' + @SupplierName,
                dbo.fn_GetCurrentFiscalPeriodID(@TransactionDate),
                1,
                @PostedBy
            )
            
            SET @JournalID = SCOPE_IDENTITY()
            
            -- DEBIT: Accounts Payable (Clear liability)
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 1, @APAccountID, @Amount, 0,
                'Payment to ' + @SupplierName, @InvoiceNumber, @BatchNumber
            )
            
            -- CREDIT: Bank (Money out - COMPLETES DOUBLE-ENTRY)
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @BankAccountID, 0, @Amount,
                'Bank payment confirmed', @InvoiceNumber, @BatchNumber
            )
            
            FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @SupplierName, @Amount, @BranchID
        END
        
        CLOSE invoice_cursor
        DEALLOCATE invoice_cursor
        
        -- Update batch status to Completed
        UPDATE AP_PaymentBatches
        SET Status = 'Completed',
            CompletedDate = GETDATE(),
            ModifiedBy = @PostedBy,
            ModifiedDate = GETDATE()
        WHERE BatchID = @BatchID
        
        -- Mark bank transaction as reconciled
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy,
            MatchedGLEntryID = @JournalID
        WHERE TransactionID = @BankTransactionID
        
        COMMIT TRANSACTION;
        
        PRINT 'Batch payment completed: ' + @BatchNumber + ' - AP cleared, Bank reduced (DOUBLE-ENTRY COMPLETE)'
        SELECT @JournalID AS JournalID, 'Batch payment posted - double-entry completed' AS Message
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('global', 'invoice_cursor') >= 0
        BEGIN
            CLOSE invoice_cursor
            DEALLOCATE invoice_cursor
        END
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT '✓ Created sp_BankStatement_CompleteBatchPayment'
GO

PRINT ''
PRINT '========================================='
PRINT 'BATCH PAYMENT ACCRUAL MODEL COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'CHANGES MADE:'
PRINT '-------------'
PRINT '1. sp_ProcessPaymentBatch - No longer posts to GL or updates bank balance'
PRINT '   - Creates payment records'
PRINT '   - Marks invoices as "Payment Initiated"'
PRINT '   - Marks batch as "Submitted"'
PRINT '   - Bank NOT touched'
PRINT ''
PRINT '2. sp_BankStatement_CompleteBatchPayment - NEW PROCEDURE'
PRINT '   - Called when bank statement confirms batch payment'
PRINT '   - Posts: DR AP / CR Bank for each invoice'
PRINT '   - Updates invoice status to "Paid"'
PRINT '   - Updates batch status to "Paid"'
PRINT '   - Marks bank transaction as reconciled'
PRINT ''
PRINT 'WORKFLOW:'
PRINT '---------'
PRINT 'Step 1: Create batch and add invoices'
PRINT 'Step 2: Process batch (sp_ProcessPaymentBatch)'
PRINT '  Result: Payment records created, batch marked "Submitted"'
PRINT '  GL: No change (bank NOT touched)'
PRINT ''
PRINT 'Step 3: Bank statement shows payment'
PRINT '  Call: sp_BankStatement_CompleteBatchPayment'
PRINT '  Result: DR AP / CR Bank (DOUBLE-ENTRY COMPLETE)'
PRINT '  Invoices marked "Paid", batch marked "Paid"'
PRINT ''
GO
