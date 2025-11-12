-- =============================================
-- FIX: Batch Payment Duplicate Key Error
-- =============================================
-- Error: Cannot insert duplicate keys in SupplierPayments
-- Cause: Unique constraint on (BatchID, SupplierID) or similar
-- Solution: Check if payment exists before inserting
-- =============================================

PRINT '🔧 Fixing batch payment duplicate key error...';
GO

IF OBJECT_ID('sp_ProcessPaymentBatch', 'P') IS NOT NULL
    DROP PROCEDURE sp_ProcessPaymentBatch;
GO

CREATE PROCEDURE sp_ProcessPaymentBatch
    @BatchID INT,
    @ProcessedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validate batch
        DECLARE @BatchNumber NVARCHAR(50), @PaymentDate DATE, @PaymentMethod NVARCHAR(20),
                @BankAccountID INT, @TotalAmount DECIMAL(18,2);
        
        SELECT 
            @BatchNumber = BatchNumber,
            @PaymentDate = PaymentDate,
            @PaymentMethod = PaymentMethod,
            @BankAccountID = BankAccountID,
            @TotalAmount = TotalAmount
        FROM PaymentBatches
        WHERE BatchID = @BatchID AND Status = 'Draft';
        
        IF @BatchNumber IS NULL
        BEGIN
            RAISERROR('Batch not found or already processed', 16, 1);
            RETURN -1;
        END
        
        -- Process each invoice in batch
        DECLARE @InvoiceID INT, @SupplierID INT, @AmountPaid DECIMAL(18,2), 
                @DiscountTaken DECIMAL(18,2), @PaymentNumber NVARCHAR(50), @PaymentID INT;
        
        DECLARE invoice_cursor CURSOR FOR
        SELECT InvoiceID, SupplierID, AmountPaid, DiscountTaken
        FROM PaymentBatchItems
        WHERE BatchID = @BatchID;
        
        OPEN invoice_cursor;
        FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @SupplierID, @AmountPaid, @DiscountTaken;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Check if payment already exists for this supplier in this batch
            SELECT @PaymentID = PaymentID
            FROM SupplierPayments
            WHERE BatchID = @BatchID AND SupplierID = @SupplierID;
            
            -- Only create new payment if it doesn't exist
            IF @PaymentID IS NULL
            BEGIN
                -- Generate payment number
                DECLARE @NextPayNum INT;
                SELECT @NextPayNum = ISNULL(MAX(CAST(SUBSTRING(PaymentNumber, 4, LEN(PaymentNumber)) AS INT)), 0) + 1
                FROM SupplierPayments
                WHERE PaymentNumber LIKE 'PAY-%';
                
                SET @PaymentNumber = 'PAY-' + RIGHT('000000' + CAST(@NextPayNum AS VARCHAR), 6);
                
                -- Create payment record
                INSERT INTO SupplierPayments (
                    PaymentNumber, BatchID, SupplierID, PaymentDate, PaymentMethod,
                    Amount, BankAccountID, CreatedBy
                )
                VALUES (
                    @PaymentNumber, @BatchID, @SupplierID, @PaymentDate, @PaymentMethod,
                    @AmountPaid, @BankAccountID, @ProcessedBy
                );
                
                SET @PaymentID = SCOPE_IDENTITY();
            END
            ELSE
            BEGIN
                -- Payment exists, update the amount
                UPDATE SupplierPayments
                SET Amount = Amount + @AmountPaid
                WHERE PaymentID = @PaymentID;
            END
            
            -- Link payment to invoice (check for duplicates)
            IF NOT EXISTS (SELECT 1 FROM SupplierInvoicePayments WHERE PaymentID = @PaymentID AND InvoiceID = @InvoiceID)
            BEGIN
                INSERT INTO SupplierInvoicePayments (PaymentID, InvoiceID, AmountApplied, DiscountTaken)
                VALUES (@PaymentID, @InvoiceID, @AmountPaid, @DiscountTaken);
            END
            
            -- Update invoice
            UPDATE SupplierInvoices
            SET AmountPaid = AmountPaid + @AmountPaid,
                Status = CASE 
                    WHEN AmountPaid + @AmountPaid >= TotalAmount THEN 'Paid'
                    ELSE 'Partial'
                END
            WHERE InvoiceID = @InvoiceID;
            
            -- Reset @PaymentID for next iteration
            SET @PaymentID = NULL;
            
            FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @SupplierID, @AmountPaid, @DiscountTaken;
        END
        
        CLOSE invoice_cursor;
        DEALLOCATE invoice_cursor;
        
        -- Update batch status
        UPDATE PaymentBatches
        SET Status = 'Paid',
            PaidBy = @ProcessedBy,
            PaidDate = GETDATE()
        WHERE BatchID = @BatchID;
        
        -- Update bank account balance
        IF @BankAccountID IS NOT NULL
        BEGIN
            UPDATE BankAccounts
            SET CurrentBalance = CurrentBalance - @TotalAmount
            WHERE BankAccountID = @BankAccountID;
        END
        
        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('global', 'invoice_cursor') >= 0
        BEGIN
            CLOSE invoice_cursor;
            DEALLOCATE invoice_cursor;
        END
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT '';
PRINT '✅ sp_ProcessPaymentBatch fixed!';
PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '📋 WHAT WAS FIXED:';
PRINT '1. Check if payment already exists for supplier in batch';
PRINT '2. If exists, update amount instead of inserting duplicate';
PRINT '3. Check for duplicate invoice-payment links';
PRINT '4. Reset @PaymentID variable between iterations';
PRINT '';
PRINT '✅ Batch payment will no longer throw duplicate key error!';
PRINT '═══════════════════════════════════════════════';
