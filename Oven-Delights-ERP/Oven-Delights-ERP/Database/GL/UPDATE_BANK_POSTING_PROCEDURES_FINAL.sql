-- =============================================
-- UPDATE BANK STATEMENT POSTING PROCEDURES (FINAL)
-- Corrected all column names to match actual database schema
-- =============================================

-- Drop and recreate sp_BankStatement_CompletePayment
IF OBJECT_ID('sp_BankStatement_CompletePayment', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompletePayment
GO

CREATE PROCEDURE sp_BankStatement_CompletePayment
    @TransactionID INT,
    @Amount DECIMAL(18,2),
    @TransactionDate DATE,
    @Description NVARCHAR(500),
    @Reference NVARCHAR(100),
    @SupplierName NVARCHAR(200),
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @BankAccountID INT
        DECLARE @APAccountID INT
        DECLARE @SupplierID INT
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @BranchID INT = 1
        
        -- Get account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2100' AND IsActive = 1
        
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2100 not found', 16, 1)
        
        -- Get SupplierID from AP_StatementTransactions if mapped
        SELECT @SupplierID = SupplierID 
        FROM AP_StatementTransactions 
        WHERE TransactionID = @TransactionID
        
        -- If no SupplierID mapped, try to find by name
        IF @SupplierID IS NULL
        BEGIN
            SELECT @SupplierID = SupplierID 
            FROM Suppliers 
            WHERE CompanyName = @SupplierName AND IsActive = 1
        END
        
        -- Create journal entry
        SET @JournalNumber = 'BANK-' + FORMAT(@TransactionID, '000000')
        
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @TransactionDate, 'Bank Payment: ' + @Description, @BranchID, @PostedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Journal Entry: DR Accounts Payable (clear liability)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @APAccountID, @Amount, 0, @Description)
        
        -- Journal Entry: CR Bank (reduce asset)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, @Description)
        
        -- Post to GeneralLedger
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @APAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0)
        
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @BankAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0)
        
        -- Post to SupplierLedger if supplier identified
        IF @SupplierID IS NOT NULL
        BEGIN
            DECLARE @SupplierCode NVARCHAR(50)
            SELECT @SupplierCode = SupplierCode FROM Suppliers WHERE SupplierID = @SupplierID
            
            INSERT INTO SupplierLedger (
                SupplierID, SupplierCode, SupplierName, TransactionDate, 
                TransactionType, ReferenceNumber, Description, 
                DebitAmount, CreditAmount, RunningBalance, 
                BranchID, CreatedBy, CreatedDate
            )
            SELECT 
                @SupplierID,
                @SupplierCode,
                @SupplierName,
                @TransactionDate,
                'Payment',
                @Reference,
                @Description,
                @Amount,
                0,
                ISNULL((SELECT TOP 1 RunningBalance FROM SupplierLedger WHERE SupplierID = @SupplierID ORDER BY LedgerID DESC), 0) - @Amount,
                @BranchID,
                @PostedBy,
                GETDATE()
        END
        
        -- Mark transaction as reconciled
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

-- Drop and recreate sp_BankStatement_CompleteReceipt
IF OBJECT_ID('sp_BankStatement_CompleteReceipt', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompleteReceipt
GO

CREATE PROCEDURE sp_BankStatement_CompleteReceipt
    @TransactionID INT,
    @Amount DECIMAL(18,2),
    @TransactionDate DATE,
    @Description NVARCHAR(500),
    @Reference NVARCHAR(100),
    @CustomerName NVARCHAR(200),
    @PostedBy INT
AS
BEGIN
    SET NOCOUNT ON
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        DECLARE @BankAccountID INT
        DECLARE @ContraAccountID INT
        DECLARE @ContraAccountCode NVARCHAR(20)
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @BranchID INT = 1
        
        -- Get bank account ID
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        IF @BankAccountID IS NULL
        BEGIN
            RAISERROR('Bank account (1010) not found in Chart of Accounts', 16, 1)
            RETURN
        END
        
        -- Determine contra account based on transaction description
        -- Cash deposits should credit Cash on Hand (1030)
        -- Customer payments should credit Accounts Receivable (1200)
        IF @Description LIKE '%DEPOSIT%' OR @Description LIKE '%CASH%' OR @Description LIKE '%ATM%' OR @Description LIKE '%BRANCH%'
        BEGIN
            SET @ContraAccountCode = '1030' -- Cash on Hand
        END
        ELSE
        BEGIN
            SET @ContraAccountCode = '1200' -- Accounts Receivable (customer payments)
        END
        
        SELECT @ContraAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ContraAccountCode AND IsActive = 1
        
        IF @ContraAccountID IS NULL
        BEGIN
            RAISERROR('Contra account not found in Chart of Accounts', 16, 1)
            RETURN
        END
        
        -- Create journal entry
        SET @JournalNumber = 'BANK-' + FORMAT(@TransactionID, '000000')
        
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @TransactionDate, 'Bank Receipt: ' + @Description, @BranchID, @PostedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Journal Entry: DR Bank (increase asset)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @BankAccountID, @Amount, 0, @Description)
        
        -- Journal Entry: CR Cash on Hand or AR (decrease asset)
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @ContraAccountID, 0, @Amount, @Description)
        
        -- Post to GeneralLedger
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @BankAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0)
        
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @ContraAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0)
        
        -- Mark transaction as reconciled
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1,
            ReconciledDate = GETDATE(),
            ReconciledBy = @PostedBy
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✓ Bank statement posting procedures updated (FINAL VERSION)'
PRINT '✓ Fixed column names:'
PRINT '  - JournalDetails: Removed TransactionDate (does not exist)'
PRINT '  - GeneralLedger: Uses TransactionDate and ReferenceID'
PRINT '  - Journals: Uses CreatedAt (not CreatedDate)'
PRINT '✓ Procedures now post to SupplierLedger when supplier identified'
