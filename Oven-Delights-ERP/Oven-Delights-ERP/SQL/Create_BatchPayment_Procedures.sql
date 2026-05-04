-- =============================================
-- BATCH INVOICE PAYMENT STORED PROCEDURES
-- =============================================

-- =============================================
-- 1. GET UNPAID INVOICES
-- =============================================
IF OBJECT_ID('sp_GetUnpaidInvoices', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetUnpaidInvoices;
GO

CREATE PROCEDURE sp_GetUnpaidInvoices
    @SupplierID INT = 0,
    @DueDateFrom DATE = NULL,
    @DueDateTo DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        si.InvoiceID,
        si.InvoiceNumber,
        si.SupplierID,
        s.CompanyName AS SupplierName,
        si.InvoiceDate,
        si.DueDate,
        DATEDIFF(DAY, si.DueDate, GETDATE()) AS DaysOverdue,
        si.TotalAmount,
        si.AmountPaid,
        si.AmountDue,
        si.Status
    FROM SupplierInvoices si
    INNER JOIN Suppliers s ON si.SupplierID = s.SupplierID
    WHERE si.Status IN ('Unpaid', 'Partial')
        AND (@SupplierID = 0 OR si.SupplierID = @SupplierID)
        AND (@DueDateFrom IS NULL OR si.DueDate >= @DueDateFrom)
        AND (@DueDateTo IS NULL OR si.DueDate <= @DueDateTo)
    ORDER BY si.DueDate ASC, s.CompanyName;
END;
GO

PRINT '✅ sp_GetUnpaidInvoices created';

-- =============================================
-- 2. CREATE PAYMENT BATCH
-- =============================================
IF OBJECT_ID('sp_CreatePaymentBatch', 'P') IS NOT NULL
    DROP PROCEDURE sp_CreatePaymentBatch;
GO

CREATE PROCEDURE sp_CreatePaymentBatch
    @BatchNumber NVARCHAR(50) OUTPUT,
    @PaymentDate DATE,
    @PaymentMethod NVARCHAR(20),
    @BankAccountID INT = NULL,
    @Notes NVARCHAR(500) = NULL,
    @CreatedBy NVARCHAR(100),
    @BatchID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Generate batch number if not provided
        IF @BatchNumber IS NULL OR @BatchNumber = ''
        BEGIN
            DECLARE @NextNum INT;
            SELECT @NextNum = ISNULL(MAX(CAST(SUBSTRING(BatchNumber, 4, LEN(BatchNumber)) AS INT)), 0) + 1
            FROM PaymentBatches
            WHERE BatchNumber LIKE 'PB-%';
            
            SET @BatchNumber = 'PB-' + RIGHT('000000' + CAST(@NextNum AS VARCHAR), 6);
        END
        
        -- Create batch
        INSERT INTO PaymentBatches (
            BatchNumber, BatchDate, PaymentDate, PaymentMethod, 
            BankAccountID, Status, Notes, CreatedBy
        )
        VALUES (
            @BatchNumber, GETDATE(), @PaymentDate, @PaymentMethod,
            @BankAccountID, 'Draft', @Notes, @CreatedBy
        );
        
        SET @BatchID = SCOPE_IDENTITY();
        
        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT '✅ sp_CreatePaymentBatch created';

-- =============================================
-- 3. ADD INVOICE TO BATCH
-- =============================================
IF OBJECT_ID('sp_AddInvoiceToBatch', 'P') IS NOT NULL
    DROP PROCEDURE sp_AddInvoiceToBatch;
GO

CREATE PROCEDURE sp_AddInvoiceToBatch
    @BatchID INT,
    @InvoiceID INT,
    @AmountToPay DECIMAL(18,2),
    @DiscountTaken DECIMAL(18,2) = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Validate batch exists and is in Draft status
        IF NOT EXISTS (SELECT 1 FROM PaymentBatches WHERE BatchID = @BatchID AND Status = 'Draft')
        BEGIN
            RAISERROR('Batch not found or not in Draft status', 16, 1);
            RETURN -1;
        END
        
        -- Get invoice details
        DECLARE @SupplierID INT, @InvoiceNumber NVARCHAR(50), @InvoiceDate DATE, 
                @DueDate DATE, @InvoiceAmount DECIMAL(18,2);
        
        SELECT 
            @SupplierID = SupplierID,
            @InvoiceNumber = InvoiceNumber,
            @InvoiceDate = InvoiceDate,
            @DueDate = DueDate,
            @InvoiceAmount = TotalAmount
        FROM SupplierInvoices
        WHERE InvoiceID = @InvoiceID;
        
        IF @SupplierID IS NULL
        BEGIN
            RAISERROR('Invoice not found', 16, 1);
            RETURN -1;
        END
        
        -- Check if invoice already in batch
        IF EXISTS (SELECT 1 FROM PaymentBatchItems WHERE BatchID = @BatchID AND InvoiceID = @InvoiceID)
        BEGIN
            RAISERROR('Invoice already in this batch', 16, 1);
            RETURN -1;
        END
        
        -- Add to batch
        INSERT INTO PaymentBatchItems (
            BatchID, InvoiceID, SupplierID, InvoiceNumber, InvoiceDate,
            DueDate, InvoiceAmount, AmountPaid, DiscountTaken
        )
        VALUES (
            @BatchID, @InvoiceID, @SupplierID, @InvoiceNumber, @InvoiceDate,
            @DueDate, @InvoiceAmount, @AmountToPay, @DiscountTaken
        );
        
        -- Update batch totals
        UPDATE PaymentBatches
        SET TotalAmount = TotalAmount + @AmountToPay,
            InvoiceCount = InvoiceCount + 1
        WHERE BatchID = @BatchID;
        
        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT '✅ sp_AddInvoiceToBatch created';

-- =============================================
-- 4. REMOVE INVOICE FROM BATCH
-- =============================================
IF OBJECT_ID('sp_RemoveInvoiceFromBatch', 'P') IS NOT NULL
    DROP PROCEDURE sp_RemoveInvoiceFromBatch;
GO

CREATE PROCEDURE sp_RemoveInvoiceFromBatch
    @BatchID INT,
    @InvoiceID INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @AmountPaid DECIMAL(18,2);
        
        -- Get amount
        SELECT @AmountPaid = AmountPaid
        FROM PaymentBatchItems
        WHERE BatchID = @BatchID AND InvoiceID = @InvoiceID;
        
        IF @AmountPaid IS NULL
        BEGIN
            RAISERROR('Invoice not found in batch', 16, 1);
            RETURN -1;
        END
        
        -- Remove from batch
        DELETE FROM PaymentBatchItems
        WHERE BatchID = @BatchID AND InvoiceID = @InvoiceID;
        
        -- Update batch totals
        UPDATE PaymentBatches
        SET TotalAmount = TotalAmount - @AmountPaid,
            InvoiceCount = InvoiceCount - 1
        WHERE BatchID = @BatchID;
        
        COMMIT TRANSACTION;
        RETURN 0;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

PRINT '✅ sp_RemoveInvoiceFromBatch created';

-- =============================================
-- 5. PROCESS PAYMENT BATCH
-- =============================================
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
            
            -- Post to GL (simplified - you'll need to expand based on your GL structure)
            -- DR: Accounts Payable, CR: Bank Account
            
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

PRINT '✅ sp_ProcessPaymentBatch created';

-- =============================================
-- 6. GET PAYMENT BATCHES
-- =============================================
IF OBJECT_ID('sp_GetPaymentBatches', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetPaymentBatches;
GO

CREATE PROCEDURE sp_GetPaymentBatches
    @Status NVARCHAR(20) = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pb.BatchID,
        pb.BatchNumber,
        pb.BatchDate,
        pb.PaymentDate,
        pb.PaymentMethod,
        ba.AccountName AS BankAccount,
        pb.TotalAmount,
        pb.InvoiceCount,
        pb.Status,
        pb.CreatedBy,
        pb.CreatedDate,
        pb.PaidBy,
        pb.PaidDate
    FROM PaymentBatches pb
    LEFT JOIN BankAccounts ba ON pb.BankAccountID = ba.BankAccountID
    WHERE (@Status IS NULL OR pb.Status = @Status)
        AND (@DateFrom IS NULL OR pb.BatchDate >= @DateFrom)
        AND (@DateTo IS NULL OR pb.BatchDate <= @DateTo)
    ORDER BY pb.BatchDate DESC, pb.BatchNumber DESC;
END;
GO

PRINT '✅ sp_GetPaymentBatches created';

-- =============================================
-- 7. GET BATCH DETAILS
-- =============================================
IF OBJECT_ID('sp_GetBatchDetails', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetBatchDetails;
GO

CREATE PROCEDURE sp_GetBatchDetails
    @BatchID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        pbi.BatchItemID,
        pbi.InvoiceID,
        pbi.InvoiceNumber,
        s.CompanyName AS SupplierName,
        pbi.InvoiceDate,
        pbi.DueDate,
        pbi.InvoiceAmount,
        pbi.AmountPaid,
        pbi.DiscountTaken,
        pbi.Notes
    FROM PaymentBatchItems pbi
    INNER JOIN Suppliers s ON pbi.SupplierID = s.SupplierID
    WHERE pbi.BatchID = @BatchID
    ORDER BY s.CompanyName, pbi.InvoiceNumber;
END;
GO

PRINT '✅ sp_GetBatchDetails created';

-- =============================================
-- 8. GET PAYMENT SCHEDULE (For Printing)
-- =============================================
IF OBJECT_ID('sp_GetPaymentSchedule', 'P') IS NOT NULL
    DROP PROCEDURE sp_GetPaymentSchedule;
GO

CREATE PROCEDURE sp_GetPaymentSchedule
    @BatchID INT = NULL,
    @DateFrom DATE = NULL,
    @DateTo DATE = NULL,
    @SupplierID INT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @BatchID IS NOT NULL
    BEGIN
        -- Get specific batch schedule
        SELECT 
            pb.BatchNumber,
            pb.BatchDate,
            pb.PaymentDate,
            pb.PaymentMethod,
            ba.AccountName AS BankAccount,
            ba.AccountNumber AS BankAccountNumber,
            pb.TotalAmount AS BatchTotal,
            pb.InvoiceCount,
            pb.Status,
            pb.Notes AS BatchNotes,
            -- Invoice details
            pbi.InvoiceNumber,
            s.CompanyName AS SupplierName,
            s.ContactPerson,
            s.Phone AS SupplierPhone,
            s.Email,
            pbi.InvoiceDate,
            pbi.DueDate,
            DATEDIFF(DAY, pbi.DueDate, pb.PaymentDate) AS DaysOverdue,
            pbi.InvoiceAmount,
            pbi.AmountPaid,
            pbi.DiscountTaken,
            pbi.Notes AS InvoiceNotes
        FROM PaymentBatches pb
        INNER JOIN PaymentBatchItems pbi ON pb.BatchID = pbi.BatchID
        INNER JOIN Suppliers s ON pbi.SupplierID = s.SupplierID
        LEFT JOIN BankAccounts ba ON pb.BankAccountID = ba.BankAccountID
        WHERE pb.BatchID = @BatchID
        ORDER BY s.CompanyName, pbi.InvoiceNumber;
    END
    ELSE
    BEGIN
        -- Get payment schedule for date range
        SELECT 
            si.InvoiceID,
            si.InvoiceNumber,
            s.SupplierID,
            s.CompanyName AS SupplierName,
            s.ContactPerson,
            s.Phone AS SupplierPhone,
            s.Email,
            si.InvoiceDate,
            si.DueDate,
            DATEDIFF(DAY, si.DueDate, GETDATE()) AS DaysOverdue,
            CASE 
                WHEN DATEDIFF(DAY, si.DueDate, GETDATE()) > 30 THEN 'Overdue'
                WHEN DATEDIFF(DAY, si.DueDate, GETDATE()) BETWEEN 0 AND 30 THEN 'Due Soon'
                ELSE 'Current'
            END AS PaymentPriority,
            si.TotalAmount,
            si.AmountPaid,
            si.AmountDue,
            si.Status
        FROM SupplierInvoices si
        INNER JOIN Suppliers s ON si.SupplierID = s.SupplierID
        WHERE si.Status IN ('Unpaid', 'Partial')
            AND (@SupplierID = 0 OR si.SupplierID = @SupplierID)
            AND (@DateFrom IS NULL OR si.DueDate >= @DateFrom)
            AND (@DateTo IS NULL OR si.DueDate <= @DateTo)
        ORDER BY 
            CASE 
                WHEN DATEDIFF(DAY, si.DueDate, GETDATE()) > 30 THEN 1
                WHEN DATEDIFF(DAY, si.DueDate, GETDATE()) BETWEEN 0 AND 30 THEN 2
                ELSE 3
            END,
            si.DueDate ASC,
            s.CompanyName;
    END
END;
GO

PRINT '✅ sp_GetPaymentSchedule created';

PRINT '';
PRINT '═══════════════════════════════════════════════';
PRINT '✅ BATCH PAYMENT STORED PROCEDURES CREATED!';
PRINT '   - sp_GetUnpaidInvoices';
PRINT '   - sp_CreatePaymentBatch';
PRINT '   - sp_AddInvoiceToBatch';
PRINT '   - sp_RemoveInvoiceFromBatch';
PRINT '   - sp_ProcessPaymentBatch';
PRINT '   - sp_GetPaymentBatches';
PRINT '   - sp_GetBatchDetails';
PRINT '   - sp_GetPaymentSchedule';
PRINT '═══════════════════════════════════════════════';
