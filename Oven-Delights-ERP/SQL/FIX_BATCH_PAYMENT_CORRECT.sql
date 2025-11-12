-- =============================================
-- FIX: Batch Payment - Correct Unique Constraint
-- =============================================
-- Error shows: UQ_Supplier_B2C1733B621B125
-- This is a unique constraint on SupplierPayments table
-- =============================================

PRINT '🔧 Fixing batch payment duplicate key error (CORRECT FIX)...';
PRINT '';

-- First, let's see what the unique constraint actually is
PRINT '1️⃣ Checking unique constraints on SupplierPayments:';
SELECT 
    i.name AS ConstraintName,
    STRING_AGG(COL_NAME(ic.object_id, ic.column_id), ', ') AS Columns
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
WHERE i.object_id = OBJECT_ID('SupplierPayments')
  AND i.is_unique = 1
GROUP BY i.name, i.type_desc;

PRINT '';
PRINT '2️⃣ Updating sp_ProcessPaymentBatch...';
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
        -- Group by supplier to avoid duplicates
        DECLARE @SupplierID INT, @TotalForSupplier DECIMAL(18,2), @PaymentNumber NVARCHAR(50), @PaymentID INT;
        
        -- Cursor for unique suppliers in batch
        DECLARE supplier_cursor CURSOR FOR
        SELECT SupplierID, SUM(AmountPaid) AS TotalAmount
        FROM PaymentBatchItems
        WHERE BatchID = @BatchID
        GROUP BY SupplierID;
        
        OPEN supplier_cursor;
        FETCH NEXT FROM supplier_cursor INTO @SupplierID, @TotalForSupplier;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Generate payment number
            DECLARE @NextPayNum INT;
            SELECT @NextPayNum = ISNULL(MAX(CAST(SUBSTRING(PaymentNumber, 4, LEN(PaymentNumber)) AS INT)), 0) + 1
            FROM SupplierPayments
            WHERE PaymentNumber LIKE 'PAY-%';
            
            SET @PaymentNumber = 'PAY-' + RIGHT('000000' + CAST(@NextPayNum AS VARCHAR), 6);
            
            -- Create ONE payment record per supplier
            INSERT INTO SupplierPayments (
                PaymentNumber, BatchID, SupplierID, PaymentDate, PaymentMethod,
                Amount, BankAccountID, CreatedBy
            )
            VALUES (
                @PaymentNumber, @BatchID, @SupplierID, @PaymentDate, @PaymentMethod,
                @TotalForSupplier, @BankAccountID, @ProcessedBy
            );
            
            SET @PaymentID = SCOPE_IDENTITY();
            
            -- Now link all invoices for this supplier to this ONE payment
            DECLARE @InvoiceID INT, @AmountPaid DECIMAL(18,2), @DiscountTaken DECIMAL(18,2);
            
            DECLARE invoice_cursor CURSOR FOR
            SELECT InvoiceID, AmountPaid, DiscountTaken
            FROM PaymentBatchItems
            WHERE BatchID = @BatchID AND SupplierID = @SupplierID;
            
            OPEN invoice_cursor;
            FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @AmountPaid, @DiscountTaken;
            
            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- Link payment to invoice
                INSERT INTO SupplierInvoicePayments (PaymentID, InvoiceID, AmountApplied, DiscountTaken)
                VALUES (@PaymentID, @InvoiceID, @AmountPaid, @DiscountTaken);
                
                -- Update invoice
                UPDATE SupplierInvoices
                SET AmountPaid = AmountPaid + @AmountPaid,
                    Status = CASE 
                        WHEN AmountPaid + @AmountPaid >= TotalAmount THEN 'Paid'
                        ELSE 'Partial'
                    END
                WHERE InvoiceID = @InvoiceID;
                
                FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @AmountPaid, @DiscountTaken;
            END
            
            CLOSE invoice_cursor;
            DEALLOCATE invoice_cursor;
            
            FETCH NEXT FROM supplier_cursor INTO @SupplierID, @TotalForSupplier;
        END
        
        CLOSE supplier_cursor;
        DEALLOCATE supplier_cursor;
        
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
        IF CURSOR_STATUS('global', 'supplier_cursor') >= 0
        BEGIN
            CLOSE supplier_cursor;
            DEALLOCATE supplier_cursor;
        END
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
PRINT '1. Groups invoices by supplier FIRST';
PRINT '2. Creates ONE payment per supplier (not per invoice)';
PRINT '3. Links all invoices for that supplier to the one payment';
PRINT '4. No more duplicate supplier+batch combinations';
PRINT '';
PRINT '✅ Batch payment will work correctly now!';
PRINT '═══════════════════════════════════════════════';
