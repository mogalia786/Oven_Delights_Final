-- =============================================
-- sp_ProcessSupplierPayment
-- Process supplier payment with GL postings for VAT
-- VAT is only posted when payment is made (not on GRV)
-- =============================================

CREATE OR ALTER PROCEDURE sp_ProcessSupplierPayment
    @SupplierID INT,
    @BatchID INT = NULL,
    @PaymentAmount DECIMAL(18,2),
    @PaymentMethod NVARCHAR(50),
    @PaymentDate DATE,
    @CheckNumber NVARCHAR(50) = NULL,
    @ReferenceNumber NVARCHAR(50) = NULL,
    @BankAccountID INT = 1,
    @Notes NVARCHAR(MAX) = NULL,
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @PaymentID INT
    DECLARE @VATAmount DECIMAL(18,2)
    DECLARE @PaymentNumber NVARCHAR(50)
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Calculate VAT from payment amount (15% VAT rate)
        SET @VATAmount = @PaymentAmount * 0.15 / 1.15
        
        -- Generate payment number
        SET @PaymentNumber = 'PAY-' + FORMAT(GETDATE(), 'yyyyMMdd') + '-' + CAST(@SupplierID AS VARCHAR)
        
        -- Insert payment record
        INSERT INTO SupplierPayments (
            PaymentNumber,
            BatchID,
            SupplierID,
            PaymentDate,
            PaymentMethod,
            Amount,
            CheckNumber,
            ReferenceNumber,
            BankAccountID,
            Notes,
            CreatedBy,
            CreatedDate
        )
        VALUES (
            @PaymentNumber,
            @BatchID,
            @SupplierID,
            @PaymentDate,
            @PaymentMethod,
            @PaymentAmount,
            @CheckNumber,
            @ReferenceNumber,
            @BankAccountID,
            @Notes,
            @CreatedBy,
            GETDATE()
        )
        
        SET @PaymentID = SCOPE_IDENTITY()
        
        -- POST TO GENERAL LEDGER
        -- Now that payment is made, we can claim VAT
        
        -- 1. DR Accounts Payable (reduce liability)
        INSERT INTO GeneralLedger (
            AccountCode, 
            TransactionDate, 
            Description, 
            Reference, 
            Debit, 
            Credit, 
            CreatedBy, 
            CreatedDate
        )
        VALUES (
            '2100', -- Accounts Payable
            @PaymentDate,
            'Payment to Supplier - ' + @PaymentNumber,
            @ReferenceNumber,
            @PaymentAmount,
            0,
            @CreatedBy,
            GETDATE()
        )
        
        -- 2. DR VAT Input (claimable VAT - now that we're paying)
        INSERT INTO GeneralLedger (
            AccountCode, 
            TransactionDate, 
            Description, 
            Reference, 
            Debit, 
            Credit, 
            CreatedBy, 
            CreatedDate
        )
        VALUES (
            '1450', -- VAT Input (Asset - claimable)
            @PaymentDate,
            'VAT Input - ' + @PaymentNumber,
            @ReferenceNumber,
            @VATAmount,
            0,
            @CreatedBy,
            GETDATE()
        )
        
        -- 3. CR Bank/Cash (payment out)
        INSERT INTO GeneralLedger (
            AccountCode, 
            TransactionDate, 
            Description, 
            Reference, 
            Debit, 
            Credit, 
            CreatedBy, 
            CreatedDate
        )
        VALUES (
            '1100', -- Bank/Cash account
            @PaymentDate,
            'Payment to Supplier - ' + @PaymentMethod,
            @ReferenceNumber,
            0,
            @PaymentAmount + @VATAmount,
            @CreatedBy,
            GETDATE()
        )
        
        COMMIT TRANSACTION
        
        SELECT 
            @PaymentID AS PaymentID,
            'Success' AS Status,
            'Payment processed and posted to GL' AS Message
            
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
            
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY()
        DECLARE @ErrorState INT = ERROR_STATE()
        
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)
    END CATCH
END
GO

PRINT 'sp_ProcessSupplierPayment created successfully'
PRINT ''
PRINT 'USAGE:'
PRINT '  EXEC sp_ProcessSupplierPayment'
PRINT '    @SupplierID = 1,'
PRINT '    @BatchID = NULL,'
PRINT '    @PaymentAmount = 1000.00,'
PRINT '    @PaymentMethod = ''EFT'','
PRINT '    @PaymentDate = ''2026-02-01'','
PRINT '    @CheckNumber = NULL,'
PRINT '    @ReferenceNumber = ''REF001'','
PRINT '    @BankAccountID = 1,'
PRINT '    @Notes = ''Payment notes'','
PRINT '    @CreatedBy = ''username'''
PRINT ''
PRINT 'GL POSTINGS:'
PRINT '  DR Accounts Payable (2100) - Reduces liability'
PRINT '  DR VAT Input (1450) - Claimable VAT (15%)'
PRINT '  CR Bank/Cash (1100) - Payment out (Amount + VAT)'
PRINT ''
