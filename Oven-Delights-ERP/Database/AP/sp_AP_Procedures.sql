-- =============================================
-- Accounts Payable System - Stored Procedures
-- =============================================

-- 1. Get Outstanding Invoices
GO
CREATE OR ALTER PROCEDURE sp_AP_GetOutstandingInvoices
    @BeneficiaryID INT = NULL,
    @CategoryID INT = NULL,
    @DueDateFrom DATE = NULL,
    @DueDateTo DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        i.InvoiceID,
        i.InvoiceNumber,
        i.InvoiceDate,
        i.DueDate,
        DATEDIFF(DAY, GETDATE(), i.DueDate) AS DaysUntilDue,
        i.Amount,
        i.TaxAmount,
        i.TotalAmount,
        i.Description,
        i.Reference,
        i.Status,
        b.BeneficiaryName,
        b.BankName,
        b.AccountNumber,
        b.BranchCode,
        c.CategoryName,
        c.GLAccountCode
    FROM AP_Invoices i
    INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
    INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID
    WHERE i.Status = 'Pending'
        AND (@BeneficiaryID IS NULL OR i.BeneficiaryID = @BeneficiaryID)
        AND (@CategoryID IS NULL OR i.CategoryID = @CategoryID)
        AND (@DueDateFrom IS NULL OR i.DueDate >= @DueDateFrom)
        AND (@DueDateTo IS NULL OR i.DueDate <= @DueDateTo)
    ORDER BY i.DueDate ASC
END
GO

-- 2. Create Invoice
GO
CREATE OR ALTER PROCEDURE sp_AP_CreateInvoice
    @InvoiceNumber NVARCHAR(50),
    @BeneficiaryID INT,
    @CategoryID INT,
    @InvoiceDate DATE,
    @DueDate DATE,
    @Amount DECIMAL(18,2),
    @TaxAmount DECIMAL(18,2) = 0,
    @Description NVARCHAR(500) = NULL,
    @Reference NVARCHAR(100) = NULL,
    @BranchID INT = 1,
    @CreatedBy NVARCHAR(100),
    @InvoiceID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    INSERT INTO AP_Invoices (
        InvoiceNumber, BeneficiaryID, CategoryID, InvoiceDate, DueDate,
        Amount, TaxAmount, Description, Reference, BranchID, Status, CreatedBy, CreatedDate
    )
    VALUES (
        @InvoiceNumber, @BeneficiaryID, @CategoryID, @InvoiceDate, @DueDate,
        @Amount, @TaxAmount, @Description, @Reference, @BranchID, 'Pending', @CreatedBy, GETDATE()
    )
    
    SET @InvoiceID = SCOPE_IDENTITY()
    
    SELECT @InvoiceID AS InvoiceID
END
GO

-- 3. Create Payment Batch
GO
CREATE OR ALTER PROCEDURE sp_AP_CreatePaymentBatch
    @InvoiceIDs NVARCHAR(MAX), -- Comma-separated list
    @CreatedBy NVARCHAR(100),
    @BatchID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Generate batch number
        DECLARE @BatchNumber NVARCHAR(50) = 'APB' + FORMAT(GETDATE(), 'yyyyMMddHHmmss')
        
        -- Calculate totals
        DECLARE @TotalAmount DECIMAL(18,2)
        DECLARE @TotalInvoices INT
        
        SELECT 
            @TotalAmount = SUM(TotalAmount),
            @TotalInvoices = COUNT(*)
        FROM AP_Invoices
        WHERE InvoiceID IN (SELECT value FROM STRING_SPLIT(@InvoiceIDs, ','))
            AND Status = 'Pending'
        
        -- Create batch
        INSERT INTO AP_PaymentBatches (
            BatchNumber, BatchDate, TotalInvoices, TotalAmount, 
            Status, CreatedBy, CreatedDate
        )
        VALUES (
            @BatchNumber, GETDATE(), @TotalInvoices, @TotalAmount,
            'Pending', @CreatedBy, GETDATE()
        )
        
        SET @BatchID = SCOPE_IDENTITY()
        
        -- Add batch items
        INSERT INTO AP_PaymentBatchItems (BatchID, InvoiceID, Amount, CreatedDate)
        SELECT 
            @BatchID,
            InvoiceID,
            TotalAmount,
            GETDATE()
        FROM AP_Invoices
        WHERE InvoiceID IN (SELECT value FROM STRING_SPLIT(@InvoiceIDs, ','))
            AND Status = 'Pending'
        
        COMMIT TRANSACTION;
        
        SELECT @BatchID AS BatchID, @BatchNumber AS BatchNumber
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 4. Update Payment Batch Status
GO
CREATE OR ALTER PROCEDURE sp_AP_UpdatePaymentBatchStatus
    @BatchID INT,
    @Status NVARCHAR(20),
    @InstructionID NVARCHAR(100) = NULL,
    @MessageID NVARCHAR(100) = NULL,
    @StatusMessage NVARCHAR(500) = NULL,
    @ResponseJSON NVARCHAR(MAX) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE AP_PaymentBatches
    SET Status = @Status,
        InstructionID = ISNULL(@InstructionID, InstructionID),
        MessageID = ISNULL(@MessageID, MessageID),
        StatusMessage = @StatusMessage,
        FNBResponseJSON = ISNULL(@ResponseJSON, FNBResponseJSON),
        SubmittedDate = CASE WHEN @Status = 'Submitted' THEN GETDATE() ELSE SubmittedDate END,
        CompletedDate = CASE WHEN @Status IN ('Completed', 'Failed') THEN GETDATE() ELSE CompletedDate END,
        ModifiedDate = GETDATE()
    WHERE BatchID = @BatchID
END
GO

-- 5. Update Invoice Payment Status
GO
CREATE OR ALTER PROCEDURE sp_AP_UpdateInvoicePaymentStatus
    @InvoiceID INT,
    @Status NVARCHAR(20),
    @PaymentBatchID INT = NULL,
    @PaymentDate DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE AP_Invoices
    SET Status = @Status,
        PaymentBatchID = ISNULL(@PaymentBatchID, PaymentBatchID),
        PaymentDate = ISNULL(@PaymentDate, PaymentDate),
        ModifiedDate = GETDATE()
    WHERE InvoiceID = @InvoiceID
END
GO

-- 6. Post Payment to General Ledger
GO
CREATE OR ALTER PROCEDURE sp_AP_PostPaymentToGL
    @InvoiceID INT,
    @PaymentBatchID INT,
    @PostingDate DATE,
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @Amount DECIMAL(18,2)
        DECLARE @CategoryID INT
        DECLARE @GLAccountCode NVARCHAR(20)
        DECLARE @Description NVARCHAR(500)
        DECLARE @BeneficiaryName NVARCHAR(200)
        DECLARE @InvoiceNumber NVARCHAR(50)
        DECLARE @BranchID INT
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @ExpenseAccountID INT
        DECLARE @BankAccountID INT
        
        -- Get invoice details
        SELECT 
            @Amount = i.TotalAmount,
            @CategoryID = i.CategoryID,
            @GLAccountCode = c.GLAccountCode,
            @Description = i.Description,
            @BeneficiaryName = b.BeneficiaryName,
            @InvoiceNumber = i.InvoiceNumber,
            @BranchID = ISNULL(i.BranchID, 0)
        FROM AP_Invoices i
        INNER JOIN AP_Categories c ON i.CategoryID = c.CategoryID
        INNER JOIN AP_Beneficiaries b ON i.BeneficiaryID = b.BeneficiaryID
        WHERE i.InvoiceID = @InvoiceID
        
        -- Get AccountIDs from ChartOfAccounts
        SELECT @ExpenseAccountID = AccountID 
        FROM ChartOfAccounts 
        WHERE AccountCode = @GLAccountCode AND IsActive = 1
        
        SELECT @BankAccountID = AccountID 
        FROM ChartOfAccounts 
        WHERE AccountCode = '1010' AND IsActive = 1
        
        -- If accounts don't exist, use default IDs
        IF @ExpenseAccountID IS NULL SET @ExpenseAccountID = 0
        IF @BankAccountID IS NULL SET @BankAccountID = 0
        
        -- Generate Journal Number
        SET @JournalNumber = 'AP-' + CAST(@PaymentBatchID AS NVARCHAR(20)) + '-' + CAST(@InvoiceID AS NVARCHAR(20))
        
        -- Create Journal Header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description, 
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @PostingDate,
            @InvoiceNumber,
            'AP Payment - ' + @BeneficiaryName + ' - ' + ISNULL(@Description, ''),
            NULL, -- FiscalPeriodID can be NULL
            1, -- IsPosted = 1 (already posted)
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Create Journal Detail - Debit Expense Account
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit, 
            Reference1, Reference2, Description
        )
        VALUES (
            @JournalID,
            1,
            @ExpenseAccountID,
            @Amount,
            0,
            @InvoiceNumber,
            @BeneficiaryName,
            'Expense - ' + @BeneficiaryName
        )
        
        -- Create Journal Detail - Credit Bank Account
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit, 
            Reference1, Reference2, Description
        )
        VALUES (
            @JournalID,
            2,
            @BankAccountID,
            0,
            @Amount,
            @InvoiceNumber,
            @BeneficiaryName,
            'Payment - ' + @BeneficiaryName
        )
        
        -- Also create AP_GLPostings record for AP tracking
        INSERT INTO AP_GLPostings (
            InvoiceID, PaymentBatchID, PostingDate, Description,
            DebitAccount, CreditAccount, Amount, CreatedBy, CreatedDate
        )
        VALUES (
            @InvoiceID, @PaymentBatchID, @PostingDate,
            'Payment to ' + @BeneficiaryName + ' - ' + ISNULL(@Description, ''),
            @GLAccountCode, -- Debit expense account
            '1010', -- Credit bank account (default)
            @Amount,
            @CreatedBy, GETDATE()
        )
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 7. Save Statement Transaction
GO
CREATE OR ALTER PROCEDURE sp_AP_SaveStatementTransaction
    @AccountNumber NVARCHAR(50),
    @TransactionDate DATE,
    @Amount DECIMAL(18,2),
    @CreditDebitIndicator NVARCHAR(10),
    @Description NVARCHAR(500),
    @Reference NVARCHAR(200) = NULL,
    @ServicerReference NVARCHAR(100) = NULL,
    @EndToEndID NVARCHAR(100) = NULL,
    @RelatedPartyName NVARCHAR(200) = NULL,
    @RawJSON NVARCHAR(MAX) = NULL,
    @FetchedBy NVARCHAR(100),
    @TransactionID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if transaction already exists
    IF EXISTS (
        SELECT 1 FROM AP_StatementTransactions
        WHERE AccountNumber = @AccountNumber
            AND TransactionDate = @TransactionDate
            AND Amount = @Amount
            AND ISNULL(ServicerReference, '') = ISNULL(@ServicerReference, '')
    )
    BEGIN
        SELECT @TransactionID = TransactionID
        FROM AP_StatementTransactions
        WHERE AccountNumber = @AccountNumber
            AND TransactionDate = @TransactionDate
            AND Amount = @Amount
            AND ISNULL(ServicerReference, '') = ISNULL(@ServicerReference, '')
        
        RETURN
    END
    
    INSERT INTO AP_StatementTransactions (
        AccountNumber, TransactionDate, Amount, CreditDebitIndicator,
        Description, Reference, ServicerReference, EndToEndID,
        RelatedPartyName, RawJSON, FetchedDate, FetchedBy
    )
    VALUES (
        @AccountNumber, @TransactionDate, @Amount, @CreditDebitIndicator,
        @Description, @Reference, @ServicerReference, @EndToEndID,
        @RelatedPartyName, @RawJSON, GETDATE(), @FetchedBy
    )
    
    SET @TransactionID = SCOPE_IDENTITY()
END
GO

-- 8. Map Statement Transaction to Category
GO
CREATE OR ALTER PROCEDURE sp_AP_MapStatementTransaction
    @TransactionID INT,
    @CategoryID INT,
    @CreateInvoice BIT = 0,
    @BeneficiaryID INT = NULL,
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        -- Update transaction mapping
        UPDATE AP_StatementTransactions
        SET MappedCategoryID = @CategoryID,
            IsReconciled = CASE WHEN @CreateInvoice = 0 THEN 1 ELSE IsReconciled END,
            ReconciledDate = CASE WHEN @CreateInvoice = 0 THEN GETDATE() ELSE ReconciledDate END,
            ReconciledBy = CASE WHEN @CreateInvoice = 0 THEN @CreatedBy ELSE ReconciledBy END
        WHERE TransactionID = @TransactionID
        
        -- Optionally create invoice from transaction
        IF @CreateInvoice = 1 AND @BeneficiaryID IS NOT NULL
        BEGIN
            DECLARE @InvoiceID INT
            DECLARE @Amount DECIMAL(18,2)
            DECLARE @Description NVARCHAR(500)
            DECLARE @TransactionDate DATE
            DECLARE @InvoiceNumber NVARCHAR(50)
            
            SELECT 
                @Amount = Amount,
                @Description = Description,
                @TransactionDate = TransactionDate
            FROM AP_StatementTransactions
            WHERE TransactionID = @TransactionID
            
            SET @InvoiceNumber = 'AUTO-' + CAST(@TransactionID AS NVARCHAR(20))
            
            EXEC sp_AP_CreateInvoice
                @InvoiceNumber = @InvoiceNumber,
                @BeneficiaryID = @BeneficiaryID,
                @CategoryID = @CategoryID,
                @InvoiceDate = @TransactionDate,
                @DueDate = @TransactionDate,
                @Amount = @Amount,
                @TaxAmount = 0,
                @Description = @Description,
                @Reference = NULL,
                @BranchID = 1,
                @CreatedBy = @CreatedBy,
                @InvoiceID = @InvoiceID OUTPUT
            
            -- Link invoice to transaction
            UPDATE AP_StatementTransactions
            SET MappedInvoiceID = @InvoiceID,
                IsReconciled = 1,
                ReconciledDate = GETDATE(),
                ReconciledBy = @CreatedBy
            WHERE TransactionID = @TransactionID
        END
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- 9. Get Beneficiaries
GO
CREATE OR ALTER PROCEDURE sp_AP_GetBeneficiaries
    @IsActive BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        b.BeneficiaryID,
        b.BeneficiaryName,
        b.BeneficiaryType,
        b.BankName,
        b.BranchCode,
        b.AccountNumber,
        b.AccountType,
        b.ContactPerson,
        b.Email,
        b.Phone,
        b.IsActive,
        c.CategoryName AS DefaultCategory
    FROM AP_Beneficiaries b
    LEFT JOIN AP_Categories c ON b.DefaultCategoryID = c.CategoryID
    WHERE (@IsActive IS NULL OR b.IsActive = @IsActive)
    ORDER BY b.BeneficiaryName
END
GO

-- 10. Get Categories
GO
CREATE OR ALTER PROCEDURE sp_AP_GetCategories
    @IsActive BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        CategoryID,
        CategoryName,
        Description,
        GLAccountCode,
        IsActive
    FROM AP_Categories
    WHERE (@IsActive IS NULL OR IsActive = @IsActive)
    ORDER BY CategoryName
END
GO

PRINT 'Accounts Payable stored procedures created successfully'
