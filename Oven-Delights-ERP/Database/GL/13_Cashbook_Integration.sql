-- =============================================
-- Cashbook GL Integration Procedures
-- =============================================

-- =============================================
-- sp_CB_PostCashReceiptToGL - Post Cash Receipt to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_CB_PostCashReceiptToGL
    @ReceiptID INT,
    @ReceiptNumber NVARCHAR(50),
    @ReceiptDate DATE,
    @Amount DECIMAL(18,2),
    @ReceivedFrom NVARCHAR(200),
    @PaymentMethod NVARCHAR(20), -- 'Cash' or 'Bank'
    @SourceAccountCode NVARCHAR(20), -- Revenue or AR account
    @BranchID INT,
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @CashAccountID INT
        DECLARE @BankAccountID INT
        DECLARE @SourceAccountID INT
        
        -- Get account IDs
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @SourceAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @SourceAccountCode AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'CR-' + @ReceiptNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @ReceiptDate,
            @ReceiptNumber,
            'Cash Receipt - ' + @ReceivedFrom,
            NULL,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Cash or Bank (Receipt)
        IF @PaymentMethod = 'Bank'
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 1, @BankAccountID, @Amount, 0,
                'Bank Receipt', @ReceiptNumber, @ReceivedFrom
            )
        END
        ELSE
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 1, @CashAccountID, @Amount, 0,
                'Cash Receipt', @ReceiptNumber, @ReceivedFrom
            )
        END
        
        -- Credit: Source Account (Revenue or AR)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 2, @SourceAccountID, 0, @Amount,
            'Receipt Source', @ReceiptNumber, @ReceivedFrom
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Cash receipt posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- sp_CB_PostCashPaymentToGL - Post Cash Payment to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_CB_PostCashPaymentToGL
    @PaymentID INT,
    @PaymentNumber NVARCHAR(50),
    @PaymentDate DATE,
    @Amount DECIMAL(18,2),
    @PaidTo NVARCHAR(200),
    @PaymentMethod NVARCHAR(20), -- 'Cash' or 'Bank'
    @ExpenseAccountCode NVARCHAR(20), -- Expense or AP account
    @BranchID INT,
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @CashAccountID INT
        DECLARE @BankAccountID INT
        DECLARE @ExpenseAccountID INT
        
        -- Get account IDs
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @ExpenseAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ExpenseAccountCode AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'CP-' + @PaymentNumber
        
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
            'Cash Payment - ' + @PaidTo,
            NULL,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Expense or AP Account
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1, Reference2
        )
        VALUES (
            @JournalID, 1, @ExpenseAccountID, @Amount, 0,
            'Payment Purpose', @PaymentNumber, @PaidTo
        )
        
        -- Credit: Cash or Bank (Payment)
        IF @PaymentMethod = 'Bank'
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @BankAccountID, 0, @Amount,
                'Bank Payment', @PaymentNumber, @PaidTo
            )
        END
        ELSE
        BEGIN
            INSERT INTO JournalDetails (
                JournalID, LineNumber, AccountID, Debit, Credit,
                Description, Reference1, Reference2
            )
            VALUES (
                @JournalID, 2, @CashAccountID, 0, @Amount,
                'Cash Payment', @PaymentNumber, @PaidTo
            )
        END
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Cash payment posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- sp_CB_PostBankDepositToGL - Post Bank Deposit to GL
-- =============================================
CREATE OR ALTER PROCEDURE sp_CB_PostBankDepositToGL
    @DepositID INT,
    @DepositNumber NVARCHAR(50),
    @DepositDate DATE,
    @Amount DECIMAL(18,2),
    @BranchID INT,
    @CreatedBy NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    
    BEGIN TRY
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @BankAccountID INT
        DECLARE @CashAccountID INT
        
        -- Get account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @CashAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1030' AND IsActive = 1
        
        -- Generate journal number
        SET @JournalNumber = 'DEP-' + @DepositNumber
        
        -- Create journal header
        INSERT INTO JournalHeaders (
            JournalNumber, BranchID, JournalDate, Reference, Description,
            FiscalPeriodID, IsPosted, CreatedBy
        )
        VALUES (
            @JournalNumber,
            @BranchID,
            @DepositDate,
            @DepositNumber,
            'Bank Deposit',
            NULL,
            1,
            @CreatedBy
        )
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Debit: Bank Account (Deposit)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1
        )
        VALUES (
            @JournalID, 1, @BankAccountID, @Amount, 0,
            'Bank Deposit', @DepositNumber
        )
        
        -- Credit: Cash on Hand (Cash deposited)
        INSERT INTO JournalDetails (
            JournalID, LineNumber, AccountID, Debit, Credit,
            Description, Reference1
        )
        VALUES (
            @JournalID, 2, @CashAccountID, 0, @Amount,
            'Cash Deposited', @DepositNumber
        )
        
        COMMIT TRANSACTION;
        
        SELECT @JournalID AS JournalID, 'Bank deposit posted to GL successfully' AS Message
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

PRINT 'Cashbook Integration procedures created successfully'
GO
