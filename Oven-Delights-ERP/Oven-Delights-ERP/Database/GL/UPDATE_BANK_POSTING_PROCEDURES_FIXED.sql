-- =============================================
-- UPDATE BANK STATEMENT POSTING PROCEDURES (FIXED)
-- Corrected column names to match actual database schema
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
        DECLARE @BranchID INT = 1 -- Default branch
        
        -- Get account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @APAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '2030' AND IsActive = 1
        
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        IF @APAccountID IS NULL
            RAISERROR('Accounts Payable account 2030 not found', 16, 1)
        
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
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description, TransactionDate)
        VALUES (@JournalID, @APAccountID, @Amount, 0, @Description, @TransactionDate)
        
        -- Journal Entry: CR Bank (reduce asset)
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description, TransactionDate)
        VALUES (@JournalID, @BankAccountID, 0, @Amount, @Description, @TransactionDate)
        
        -- Post to GeneralLedger
        INSERT INTO GeneralLedger (AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceNumber, CreatedBy, CreatedDate)
        VALUES (@APAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE())
        
        INSERT INTO GeneralLedger (AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceNumber, CreatedBy, CreatedDate)
        VALUES (@BankAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE())
        
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
        DECLARE @ARAccountID INT
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(20)
        DECLARE @BranchID INT = 1 -- Default branch
        
        -- Get account IDs
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        SELECT @ARAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1200' AND IsActive = 1
        
        IF @BankAccountID IS NULL
            RAISERROR('Bank account 1010 not found', 16, 1)
        IF @ARAccountID IS NULL
            RAISERROR('Accounts Receivable account 1200 not found', 16, 1)
        
        -- Note: Customer ledger posting would require customer identification
        -- For now, receipts post to AR control account only
        
        -- Create journal entry
        SET @JournalNumber = 'BANK-' + FORMAT(@TransactionID, '000000')
        
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @TransactionDate, 'Bank Receipt: ' + @Description, @BranchID, @PostedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        -- Journal Entry: DR Bank (increase asset)
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description, TransactionDate)
        VALUES (@JournalID, @BankAccountID, @Amount, 0, @Description, @TransactionDate)
        
        -- Journal Entry: CR Accounts Receivable (clear asset)
        INSERT INTO JournalDetails (JournalID, AccountID, Debit, Credit, Description, TransactionDate)
        VALUES (@JournalID, @ARAccountID, 0, @Amount, @Description, @TransactionDate)
        
        -- Post to GeneralLedger
        INSERT INTO GeneralLedger (AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceNumber, CreatedBy, CreatedDate)
        VALUES (@BankAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE())
        
        INSERT INTO GeneralLedger (AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceNumber, CreatedBy, CreatedDate)
        VALUES (@ARAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE())
        
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

PRINT '✓ Bank statement posting procedures updated (FIXED VERSION)'
PRINT '✓ Corrected column names: CreatedAt, ReferenceNumber, TransactionType'
PRINT '✓ Procedures now post to SupplierLedger when supplier identified'
