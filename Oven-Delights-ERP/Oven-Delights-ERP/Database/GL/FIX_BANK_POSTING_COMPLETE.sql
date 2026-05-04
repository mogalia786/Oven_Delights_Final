-- =============================================
-- COMPLETE FIX FOR BANK POSTING
-- 1. Clear existing postings
-- 2. Add missing account 1600
-- 3. Create procedures using mapping rules
-- =============================================

PRINT '========================================='
PRINT 'STEP 1: CLEAR EXISTING BANK POSTINGS'
PRINT '========================================='
PRINT ''

DELETE FROM GeneralLedger WHERE JournalEntryNumber LIKE 'BANK-%'
DELETE FROM JournalDetails WHERE JournalID IN (SELECT JournalID FROM Journals WHERE JournalNumber LIKE 'BANK-%')
DELETE FROM Journals WHERE JournalNumber LIKE 'BANK-%'

UPDATE AP_StatementTransactions
SET IsReconciled = 0, ReconciledDate = NULL, ReconciledBy = NULL,
    IsMapped = 0, MappedDate = NULL, AccountCode = NULL, SupplierID = NULL, MappingType = NULL

PRINT '✓ Cleared all bank postings'
PRINT ''

PRINT '========================================='
PRINT 'STEP 2: ADD MISSING ACCOUNT 1600'
PRINT '========================================='
PRINT ''

IF NOT EXISTS (SELECT 1 FROM ChartOfAccounts WHERE AccountCode = '1600')
BEGIN
    INSERT INTO ChartOfAccounts (AccountCode, AccountName, AccountType, IsActive, CreatedBy, CreatedDate)
    VALUES ('1600', 'Inter-Branch Transfers', 'Asset', 1, 1, GETDATE())
    PRINT '✓ Created account 1600 - Inter-Branch Transfers'
END
ELSE
BEGIN
    PRINT '✓ Account 1600 already exists'
END
PRINT ''

PRINT '========================================='
PRINT 'STEP 3: DROP OLD PROCEDURES'
PRINT '========================================='
PRINT ''

IF OBJECT_ID('sp_BankStatement_CompletePayment', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompletePayment
PRINT '✓ Dropped sp_BankStatement_CompletePayment'

IF OBJECT_ID('sp_BankStatement_CompleteReceipt', 'P') IS NOT NULL
    DROP PROCEDURE sp_BankStatement_CompleteReceipt
PRINT '✓ Dropped sp_BankStatement_CompleteReceipt'

PRINT ''
PRINT '========================================='
PRINT 'STEP 4: CREATE NEW PROCEDURES USING MAPPING RULES'
PRINT '========================================='
PRINT ''

GO

-- =============================================
-- PAYMENT PROCEDURE (Money OUT)
-- =============================================
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
        DECLARE @ContraAccountID INT
        DECLARE @ContraAccountCode NVARCHAR(20)
        DECLARE @JournalID INT
        DECLARE @JournalNumber NVARCHAR(50)
        DECLARE @BranchID INT = 1
        
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        IF @BankAccountID IS NULL
        BEGIN
            RAISERROR('Bank account (1010) not found', 16, 1)
            RETURN
        END
        
        SELECT TOP 1 
            @ContraAccountCode = AccountCode
        FROM BankTransactionMappingRules
        WHERE IsActive = 1
            AND (
                (MatchType = 'Prefix' AND @Description LIKE MatchValue + '%') OR
                (MatchType = 'Contains' AND @Description LIKE '%' + MatchValue + '%') OR
                (MatchType = 'Suffix' AND @Description LIKE '%' + MatchValue) OR
                (MatchType = 'Exact' AND @Description = MatchValue)
            )
        ORDER BY Priority ASC
        
        IF @ContraAccountCode IS NULL
            SET @ContraAccountCode = '2100'
        
        SELECT @ContraAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ContraAccountCode AND IsActive = 1
        
        IF @ContraAccountID IS NULL
        BEGIN
            RAISERROR('Contra account not found: %s', 16, 1, @ContraAccountCode)
            RETURN
        END
        
        SET @JournalNumber = 'BANK-' + FORMAT(@TransactionID, '000000')
        
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @TransactionDate, @Description, @BranchID, @PostedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @ContraAccountID, @Amount, 0, @Description)
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @BankAccountID, 0, @Amount, @Description)
        
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @ContraAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0)
        
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @BankAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0)
        
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1, ReconciledDate = GETDATE(), ReconciledBy = @PostedBy,
            IsMapped = 1, MappedDate = GETDATE(), AccountCode = @ContraAccountCode
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✓ Created sp_BankStatement_CompletePayment'
PRINT ''

GO

-- =============================================
-- RECEIPT PROCEDURE (Money IN)
-- =============================================
CREATE PROCEDURE sp_BankStatement_CompleteReceipt
    @TransactionID INT,
    @Amount DECIMAL(18,2),
    @TransactionDate DATE,
    @Description NVARCHAR(500),
    @Reference NVARCHAR(100),
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
        
        SELECT @BankAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = '1010' AND IsActive = 1
        
        IF @BankAccountID IS NULL
        BEGIN
            RAISERROR('Bank account (1010) not found', 16, 1)
            RETURN
        END
        
        SELECT TOP 1 
            @ContraAccountCode = AccountCode
        FROM BankTransactionMappingRules
        WHERE IsActive = 1
            AND (
                (MatchType = 'Prefix' AND @Description LIKE MatchValue + '%') OR
                (MatchType = 'Contains' AND @Description LIKE '%' + MatchValue + '%') OR
                (MatchType = 'Suffix' AND @Description LIKE '%' + MatchValue) OR
                (MatchType = 'Exact' AND @Description = MatchValue)
            )
        ORDER BY Priority ASC
        
        IF @ContraAccountCode IS NULL
        BEGIN
            IF @Description LIKE '%DEPOSIT%' OR @Description LIKE '%CASH%' OR @Description LIKE '%ATM%'
                SET @ContraAccountCode = '1030'
            ELSE
                SET @ContraAccountCode = '1200'
        END
        
        SELECT @ContraAccountID = AccountID FROM ChartOfAccounts WHERE AccountCode = @ContraAccountCode AND IsActive = 1
        
        IF @ContraAccountID IS NULL
        BEGIN
            RAISERROR('Contra account not found: %s', 16, 1, @ContraAccountCode)
            RETURN
        END
        
        SET @JournalNumber = 'BANK-' + FORMAT(@TransactionID, '000000')
        
        INSERT INTO Journals (JournalNumber, JournalDate, Description, BranchID, CreatedBy, CreatedAt)
        VALUES (@JournalNumber, @TransactionDate, @Description, @BranchID, @PostedBy, GETDATE())
        
        SET @JournalID = SCOPE_IDENTITY()
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 1, @BankAccountID, @Amount, 0, @Description)
        
        INSERT INTO JournalDetails (JournalID, LineNumber, AccountID, Debit, Credit, Description)
        VALUES (@JournalID, 2, @ContraAccountID, 0, @Amount, @Description)
        
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @BankAccountID, @TransactionDate, @Description, @Amount, 0, @Reference, @PostedBy, GETDATE(), 0)
        
        INSERT INTO GeneralLedger (JournalEntryNumber, AccountID, TransactionDate, Description, DebitAmount, CreditAmount, ReferenceID, CreatedBy, CreatedDate, IsReversed)
        VALUES (@JournalNumber, @ContraAccountID, @TransactionDate, @Description, 0, @Amount, @Reference, @PostedBy, GETDATE(), 0)
        
        UPDATE AP_StatementTransactions
        SET IsReconciled = 1, ReconciledDate = GETDATE(), ReconciledBy = @PostedBy,
            IsMapped = 1, MappedDate = GETDATE(), AccountCode = @ContraAccountCode
        WHERE TransactionID = @TransactionID
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE()
        RAISERROR(@ErrorMessage, 16, 1)
    END CATCH
END
GO

PRINT '✓ Created sp_BankStatement_CompleteReceipt'
PRINT ''

PRINT '========================================='
PRINT 'COMPLETE - READY TO REPOST'
PRINT '========================================='
PRINT ''
PRINT 'Procedures now use BankTransactionMappingRules table'
PRINT 'Account 1600 (Inter-Branch Transfers) created'
PRINT 'Run Auto-Process in the application to repost transactions'
