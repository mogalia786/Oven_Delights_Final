-- =============================================
-- PHASE 1.2: FIX ACCOUNTS PAYABLE TO USE 2030
-- Update all AP procedures to use correct account
-- =============================================

PRINT '========================================='
PRINT 'PHASE 1.2: FIXING AP ACCOUNT SEPARATION'
PRINT '========================================='
PRINT ''
PRINT 'CRITICAL FIX:'
PRINT '- Account 2010 = Customer Deposits (POS orders only)'
PRINT '- Account 2030 = Accounts Payable (Supplier invoices only)'
PRINT ''

-- =============================================
-- Drop and recreate AP procedures with correct account
-- =============================================

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostAdhocInvoiceToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostAdhocInvoiceToGL
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostSinglePaymentToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostSinglePaymentToGL
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostBatchPaymentToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostBatchPaymentToGL
GO

IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'sp_AP_PostCreditNoteToGL' AND type = 'P')
    DROP PROCEDURE sp_AP_PostCreditNoteToGL
GO

PRINT '✓ Dropped old AP procedures'
PRINT ''
GO

-- =============================================
-- sp_AP_PostAdhocInvoiceToGL - FIXED VERSION
-- Now uses 2030 (Accounts Payable) instead of 2010
-- =============================================
CREATE PROCEDURE sp_AP_PostAdhocInvoiceToGL
    @InvoiceID INT,
    @InvoiceNumber NVARCHAR(50),
    @InvoiceDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @SubtotalAmount DECIMAL(18,2),
    @VATAmount DECIMAL(18,2),
    @TotalAmount DECIMAL(18,2),
    @ExpenseAccountCode NVARCHAR(20), -- e.g., '6010' for Rent, '6020' for Utilities
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @ExpenseAccountID INT
        DECLARE @VATInputAccountID INT
        DECLARE @APAccountID INT
        
        -- Get account IDs - NOW USING 2030 FOR AP
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        
        -- Validate accounts exist
        IF @ExpenseAccountID IS NULL
            RAISERROR('Expense account %s not found or inactive', 16, 1, @ExpenseAccountCode)
        
        IF @VATInputAccountID IS NULL
            RAISERROR('VAT Input account 2021 not found or inactive', 16, 1)
            
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2030 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'AP-' + @InvoiceNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @InvoiceDate,
            @InvoiceNumber,
            'ADHOC Invoice - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@InvoiceDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Expense Account (Subtotal excluding VAT)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @ExpenseAccountID, @SubtotalAmount, 0,
            'Expense', @InvoiceNumber, @SupplierName
        )
        
        -- Debit: VAT Input (VAT claimable from SARS)
        IF @VATAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @VATInputAccountID, @VATAmount, 0,
                'VAT Input', @InvoiceNumber, @SupplierName
            )
        END
        
        -- Credit: Accounts Payable 2030 (Total including VAT)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 3, @APAccountID, 0, @TotalAmount,
            'Accounts Payable', @InvoiceNumber, @SupplierName
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'ADHOC invoice posted to GL successfully (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostAdhocInvoiceToGL (using 2030)'
GO

-- =============================================
-- sp_AP_PostSinglePaymentToGL - FIXED VERSION
-- Now uses 2030 (Accounts Payable) instead of 2010
-- =============================================
CREATE PROCEDURE sp_AP_PostSinglePaymentToGL
    @InvoiceID INT,
    @PaymentNumber NVARCHAR(50),
    @PaymentDate DATE,
    @SupplierName NVARCHAR(200),
    @Amount DECIMAL(18,2),
    @PaymentMethod NVARCHAR(20), -- 'EFT', 'Cash', 'Cheque'
    @BranchID INT,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @APAccountID INT
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        
        -- Get account IDs - NOW USING 2030 FOR AP
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        
        -- Validate accounts exist
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2030 not found or inactive', 16, 1)
            
        IF @BankAccountID IS NULL AND @PaymentMethod IN ('EFT', 'Cheque')
            RAISERROR('Bank account 1010 not found or inactive', 16, 1)
            
        IF @CashAccountID IS NULL AND @PaymentMethod = 'Cash'
            RAISERROR('Cash account 1030 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'PAY-' + @PaymentNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @PaymentDate,
            @PaymentNumber,
            'Payment - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@PaymentDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Accounts Payable 2030 (Clear liability)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @APAccountID, @Amount, 0,
            'Payment to Supplier', @PaymentNumber, @SupplierName
        )
        
        -- Credit: Bank or Cash (Payment out)
        IF @PaymentMethod IN ('EFT', 'Cheque')
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @BankAccountID, 0, @Amount,
                'Bank Payment - ' + @PaymentMethod, @PaymentNumber, @SupplierName
            )
        END
        ELSE IF @PaymentMethod = 'Cash'
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @CashAccountID, 0, @Amount,
                'Cash Payment', @PaymentNumber, @SupplierName
            )
        END
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Payment posted to GL successfully (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostSinglePaymentToGL (using 2030)'
GO

-- =============================================
-- sp_AP_PostBatchPaymentToGL - FIXED VERSION
-- Now uses 2030 (Accounts Payable) instead of 2010
-- =============================================
CREATE PROCEDURE sp_AP_PostBatchPaymentToGL
    @BatchID INT,
    @PaymentDate DATE,
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @APAccountID INT
        DECLARE @BankAccountID INT
        
        -- Get account IDs - NOW USING 2030 FOR AP
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        -- Validate accounts exist
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2030 not found or inactive', 16, 1)
            
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found or inactive', 16, 1)
        
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
            i.InvoiceID,
            i.InvoiceNumber,
            b.BeneficiaryName,
            pbi.Amount,
            i.BranchID
        FROM AP_PaymentBatchItems pbi
        INNER JOIN AP_Invoices i ON pbi.InvoiceID = i.InvoiceID
        INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
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
                @PaymentDate,
                @InvoiceNumber,
                'Batch Payment - ' + @SupplierName,
                dbo.fn_GetCurrentFiscalPeriodID(@PaymentDate),
                1,
                @CreatedBy
            )
            
            SET @JournalID = SCOPE_IDENTITY()
            
            -- Debit: Accounts Payable 2030
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 1, @APAccountID, @Amount, 0,
                'Batch Payment', @InvoiceNumber, @SupplierName
            )
            
            -- Credit: Bank Account
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @BankAccountID, 0, @Amount,
                'Bank Payment - EFT', @InvoiceNumber, @SupplierName
            )
            
            -- Update invoice status
            UPDATE AP_Invoices
            SET Status = 'Paid',
                PaymentDate = @PaymentDate,
                ModifiedDate = GETDATE()
            WHERE InvoiceID = @InvoiceID
            
            FETCH NEXT FROM invoice_cursor INTO @InvoiceID, @InvoiceNumber, @SupplierName, @Amount, @BranchID
        END
        
        CLOSE invoice_cursor
        DEALLOCATE invoice_cursor
        
        COMMIT TRANSACTION;
        
        SELECT 'Batch payment posted to GL successfully (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        IF CURSOR_STATUS('global', 'invoice_cursor') >= 0
        BEGIN
            CLOSE invoice_cursor
            DEALLOCATE invoice_cursor
        END
        
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostBatchPaymentToGL (using 2030)'
GO

-- =============================================
-- sp_AP_PostCreditNoteToGL - FIXED VERSION
-- Now uses 2030 (Accounts Payable) instead of 2010
-- =============================================
CREATE PROCEDURE sp_AP_PostCreditNoteToGL
    @CreditNoteID INT,
    @CreditNoteNumber NVARCHAR(50),
    @CreditNoteDate DATE,
    @SupplierName NVARCHAR(200),
    @BranchID INT,
    @SubtotalAmount DECIMAL(18,2),
    @VATAmount DECIMAL(18,2),
    @TotalAmount DECIMAL(18,2),
    @ExpenseAccountCode NVARCHAR(20),
    @CreatedBy INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @ExpenseAccountID INT
        DECLARE @VATInputAccountID INT
        DECLARE @APAccountID INT
        
        -- Get account IDs - NOW USING 2030 FOR AP
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        SELECT @VATInputAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2021' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        
        -- Validate accounts exist
        IF @ExpenseAccountID IS NULL
            RAISERROR('Expense account %s not found or inactive', 16, 1, @ExpenseAccountCode)
        
        IF @VATInputAccountID IS NULL
            RAISERROR('VAT Input account 2021 not found or inactive', 16, 1)
            
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2030 not found or inactive', 16, 1)
        
        -- Generate journal number
        SET @JournalNumber = 'CN-' + @CreditNoteNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @CreditNoteDate,
            @CreditNoteNumber,
            'Credit Note - ' + @SupplierName,
            dbo.fn_GetCurrentFiscalPeriodID(@CreditNoteDate),
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Accounts Payable 2030 (Reduce liability)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @APAccountID, @TotalAmount, 0,
            'Credit Note - Reduce AP', @CreditNoteNumber, @SupplierName
        )
        
        -- Credit: Expense Account (Reverse expense)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @ExpenseAccountID, 0, @SubtotalAmount,
            'Expense Reversal', @CreditNoteNumber, @SupplierName
        )
        
        -- Credit: VAT Input (Reverse VAT claim)
        IF @VATAmount > 0
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 3, @VATInputAccountID, 0, @VATAmount,
                'VAT Input Reversal', @CreditNoteNumber, @SupplierName
            )
        END
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Credit note posted to GL successfully (Account 2030)' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        SELECT 0 AS JournalID, 'GL posting failed: ' + @ErrorMessage AS Message
    END CATCH
END
GO

PRINT '✓ Created sp_AP_PostCreditNoteToGL (using 2030)'
GO

PRINT ''
PRINT '========================================='
PRINT 'PHASE 1.2 COMPLETE'
PRINT '========================================='
PRINT ''
PRINT 'All AP procedures now use Account 2030 (Accounts Payable)'
PRINT 'Account 2010 is reserved for Customer Deposits only'
PRINT ''
PRINT 'Updated Procedures:'
PRINT '1. sp_AP_PostAdhocInvoiceToGL'
PRINT '2. sp_AP_PostSinglePaymentToGL'
PRINT '3. sp_AP_PostBatchPaymentToGL'
PRINT '4. sp_AP_PostCreditNoteToGL'
PRINT ''
